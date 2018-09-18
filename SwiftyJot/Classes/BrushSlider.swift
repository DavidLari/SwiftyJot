//
//  BrushSlider.swift
//  AnnotateImage
//
//  Created by David Lari on 11/24/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit

class BrushSlider: UIView {

    let slider = UISlider()
    let brushView = UIView()
    let connector = UIView()
    let minSize: CGFloat = 1
    let maxSize: CGFloat = 20
    var brushSize: CGFloat = 8
    var color: UIColor!

    convenience init(linkedButton: UIButton, brushSize: CGFloat, color: UIColor) {

        self.init()
        setFrame(linkedButton: linkedButton, color: color)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = frame.size.width / 2

        connector.frame = CGRect(x: frame.width - 30, y: frame.height - 2, width: 10, height: 8)
        connector.backgroundColor = linkedButton.backgroundColor
        addSubview(connector)
        bringSubviewToFront(connector)

        let sliderFrame = CGRect(x: -55, y: 90, width: 160, height: 34)
        slider.frame = sliderFrame
        slider.transform = slider.transform.rotated(by: CGFloat(1.5 * Float.pi))
        slider.isUserInteractionEnabled = true
        slider.maximumValue = Float(maxSize)
        slider.minimumValue = Float(minSize)
        slider.value = Float(brushSize)
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        addSubview(slider)
        bringSubviewToFront(slider)

        updateBrushView()
        self.color = color
        brushView.layer.borderWidth = 1
        brushView.layer.borderColor = UIColor.black.cgColor
        addSubview(brushView)
        bringSubviewToFront(brushView)

    }

    private func updateBrushView() {
        let adjustedSize = brushSize + 2
        brushView.frame = CGRect(x: (frame.size.width - adjustedSize) / 2, y: 15 - adjustedSize / 2, width: adjustedSize, height: adjustedSize)
        brushView.layer.cornerRadius = adjustedSize / 2
        brushView.backgroundColor = color
    }

    @objc func valueChanged() {
        brushSize = CGFloat(slider.value)
        updateBrushView()
    }

    public func setFrame(linkedButton: UIButton, color: UIColor) {
        let origin = linkedButton.frame.origin
        let width = linkedButton.frame.size.width
        let height: CGFloat = 200
        frame = CGRect(x: origin.x, y: origin.y - height - 4, width: width, height: height)
        self.color = color
        updateBrushView()
    }

    public override var tintColor: UIColor! {
        didSet {
            slider.tintColor = tintColor
            layer.borderColor = tintColor.cgColor
        }
    }
}
