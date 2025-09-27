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
}

private extension ImageCache {
    func fileURL(with key: String) -> URL {
        let hash = SHA256.hash(data: Data(key.utf8))
            .compactMap({ String(format: "%02x", $0)})
            .joined(separator: "")
        return directoryURL.appendingPathComponent(hash)
    }
}
