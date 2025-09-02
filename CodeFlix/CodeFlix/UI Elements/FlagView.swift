//
//  FlagView.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 31.08.2025.
//

import UIKit

final class FlagView: UIView {

    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }

    private func updatePath() {
        let path = UIBezierPath()

        let width: CGFloat = 20
        let height: CGFloat = 30
        let triangleSize: CGFloat = 8


        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width / 2, y: height  - triangleSize))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
}
