//
//  ImageCache.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 27.09.2025.
//

import Foundation
import CryptoKit

protocol ImageCacheDescription {
    func obtain(with key: String) -> Data?
    func store(_ data: Data, with key: String)
    func getSize() -> UInt64
    func clear(completion: @escaping () -> Void)
    func fileLists() -> [CacheFileInfo]
}

final class ImageCache: ImageCacheDescription {

    static let shared: ImageCacheDescription = ImageCache()

    private let fileManager = FileManager.default

    private let ioQueue = DispatchQueue(label: "ru.Codeflix.ImageDiskCache.IO", qos: .userInitiated, attributes: [.concurrent])

    private init(folderName: String = "ImageDiskCache") {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)

        guard let cacheDirectory = urls.first else {
            fatalError("Failed to obtain caches directory URL")
        }

        let folderUrl = cacheDirectory.appendingPathComponent(folderName)

        try? fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true)

        self.directoryURL = folderUrl
    }

    private let directoryURL: URL

    func obtain(with key: String) -> Data? {
        ioQueue.sync {
            let url = fileURL(with: key)
            return try? Data(contentsOf: url)
        }

    }

    func store(_ data: Data, with key: String) {
        ioQueue.async(flags: .barrier) {
            let url = self.fileURL(with: key)

            try? data.write(to: url, options: .atomic)
        }


    }

    func getSize() -> UInt64 {
        guard
            let files = try? fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [.fileSizeKey])
            else {
            return .zero
        }

        var totalSize: UInt64 = 0


        files.forEach({ url in
            guard let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
                return
            }
            totalSize += UInt64(fileSize)
        })

        return totalSize
    }

    func clear(completion: @escaping () -> Void) {
        ioQueue.async(flags: .barrier) {
            try? self.fileManager.removeItem(at: self.directoryURL)
            try? self.fileManager.createDirectory(at: self.directoryURL, withIntermediateDirectories: true)
            
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func fileLists() -> [CacheFileInfo] {
        guard
            let files = try? fileManager.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.fileSizeKey]
            ) else {
            return []
        }

        return files.compactMap({ url -> CacheFileInfo? in
            guard let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
                return nil
            }

            return CacheFileInfo(url: url, size: UInt64(fileSize))
        })
    }
}

private extension ImageCache {
    func fileURL(with key: String) -> URL {
        let hash = SHA256.hash(data: Data(key.utf8))
            .compactMap({ String(format: "%02x", $0)})
            .joined(separator: "")
        return directoryURL.appendingPathComponent(hash)
    }
}
