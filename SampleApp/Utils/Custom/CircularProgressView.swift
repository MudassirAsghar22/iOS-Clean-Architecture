//
//  CircularProgressBarView.swift
//  Sample App
//
//  Created by Mudassir Asghar on 22/08/2024.
//

import UIKit

class CircularProgressView: UIView {

    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let percentageLabel = UILabel()

    private var progress: CGFloat = 0 {
        didSet {
            percentageLabel.text = "\(Int(progress * 100))%"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        setupLabel()
    }

    private func setupLayers() {
        let lineWidth: CGFloat = 10
        let center = self.window?.center ?? CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = Colors.theme.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    private func setupLabel() {
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        percentageLabel.textColor = .black
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func setProgress(_ progress: CGFloat, animated: Bool = true) {
        self.progress = min(max(progress, 0), 1)
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = self.progress
            animation.duration = 0.5
            progressLayer.strokeEnd = self.progress
            progressLayer.add(animation, forKey: "progressAnim")
        } else {
            progressLayer.strokeEnd = self.progress
        }
    }
}
