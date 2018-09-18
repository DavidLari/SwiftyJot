//
//  PaletteTool.swift
//  AnnotateImage
//
//  Created by David Lari on 11/25/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit

class PaletteTool: UIView {

    let sliderR = UISlider()
    let sliderG = UISlider()
    let sliderB = UISlider()
    let sliderA = UISlider()
    let result = UIView()
    let connector = UIView()
    let colorButtons = [UIButton]()
    let colorPalette = [UIColor.red, .blue, .green, .yellow, .orange, .black]
    let min: Float = 0
    let max: Float = 255
    var brushSize: CGFloat = 8
    var newColor: UIColor = .white

    private func setUpColorButtons() {
        let startX: CGFloat = frame.width - 40
        var startY: CGFloat = 10

        for color in colorPalette {
            let button = UIButton(frame: CGRect(x: startX, y: startY, width: 30, height: 30))
            button.backgroundColor = color
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.addTarget(self, action: #selector(paletteButtonTapped(sender:)), for: .touchUpInside)
            addSubview(button)

            startY += 38
        }
    }

    @objc private func paletteButtonTapped(sender: UIButton) {

        newColor = sender.backgroundColor!
        result.backgroundColor = newColor
        if let colorComponents = newColor.getRGBAColorComponents() {
            sliderR.value = Float(colorComponents.red)
            sliderG.value = Float(colorComponents.green)
            sliderB.value = Float(colorComponents.blue)
            sliderA.value = Float(colorComponents.alpha)
        }
    }

    fileprivate func setUpSlider(slider: UISlider, frame: CGRect, color: UIColor) {
        slider.frame = frame
        slider.transform = slider.transform.rotated(by: CGFloat(1.5 * Float.pi))
        slider.isUserInteractionEnabled = true
        slider.tintColor = color
        slider.thumbTintColor = color
        slider.maximumValue = Float(max)
        slider.minimumValue = Float(min)
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        addSubview(slider)
        bringSubviewToFront(slider)
   }

    convenience init(linkedButton: UIButton, currentColor: UIColor) {

        self.init()
        setFrame(linkedButton: linkedButton)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 25

        result.frame = CGRect(x: 20, y: 10, width: 100, height: 30)
        result.layer.cornerRadius = 10
        result.layer.borderWidth = 1
        result.backgroundColor = currentColor
        newColor = currentColor
        addSubview(result)

        connector.frame = CGRect(x: frame.width - 30, y: frame.height - 2, width: 10, height: 8)
        connector.backgroundColor = linkedButton.backgroundColor
        addSubview(connector)
        bringSubviewToFront(connector)

        let y = 110
        let width = 160
        let height = 34
        let x = -55
        let xDelta = 50

        setUpSlider(slider: sliderR,frame: CGRect(x: x, y: y, width: width, height: height), color: .red)
        setUpSlider(slider: sliderG,frame: CGRect(x: x + xDelta, y: y, width: width, height: height), color: .green)
        setUpSlider(slider: sliderB,frame: CGRect(x: x + xDelta * 2, y: y, width: width, height: height), color: .blue)
        setUpSlider(slider: sliderA,frame: CGRect(x: x + xDelta * 3, y: y, width: width, height: height), color: .gray)

        if let colorComponents = currentColor.getRGBAColorComponents() {
            sliderR.value = Float(colorComponents.red)
            sliderG.value = Float(colorComponents.green)
            sliderB.value = Float(colorComponents.blue)
            sliderA.value = Float(colorComponents.alpha)
        } else {
            sliderR.value = 0
            sliderG.value = 255
            sliderB.value = 0
            sliderA.value = 255
        }

        setUpColorButtons()
    }

    @objc func valueChanged() {
        newColor = UIColor(red: CGFloat(sliderR.value / 255),
                           green: CGFloat(sliderG.value / 255),
                           blue: CGFloat(sliderB.value / 255),
                           alpha: CGFloat(sliderA.value / 255))
        result.backgroundColor = newColor
    }

    public func setFrame(linkedButton: UIButton) {
        let origin = linkedButton.frame.origin
        let width: CGFloat = 250
        let height: CGFloat = 240
        frame = CGRect(x: origin.x - width + linkedButton.frame.size.width, y: origin.y - height - 4, width: width, height: height)
    }

    public override var tintColor: UIColor! {
        didSet {
            layer.borderColor = tintColor.cgColor
        }
    }
}

