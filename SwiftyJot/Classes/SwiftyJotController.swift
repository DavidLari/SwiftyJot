//
//  SwiftyJotController.swift
//  SwiftyJot
//
//  Created by David Lari on 11/9/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit

class SwiftyJotController: UIViewController {

    //TODO: - List
    // shadow visible on buttons
    // more config stuff

    /// The image view on the calling view controller
    public var sourceImageView: UIImageView?
    private var originalImage: UIImage?

    public var config: SwiftyJot.Config!

    private var containerView = UIView()

    class Line {

        init(start: CGPoint, end: CGPoint, brushSize: CGFloat, color: UIColor) {
            self.start = start
            self.end = end
            self.brushSize = brushSize
            self.color = color
        }

        var start: CGPoint
        var end: CGPoint
        var brushSize: CGFloat
        let color: UIColor
    }

    private let imageView = UIImageView()
    private let drawView = UIImageView()

    private let menuItemSpacing: CGFloat = 58

    var lines = [Line]()
    var undoIndexes = [Int]()

    var lastPoint = CGPoint.zero
    var fromPoint = CGPoint()
    var toPoint = CGPoint.zero
    var red: CGFloat = 255
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 255
    var brushSize: CGFloat = 8
    var color = UIColor.red
    var swiped = false

    private var menuButton: UIButton!
    private var clearButton: UIButton!
    private var undoButton: UIButton!
    private var redoButton: UIButton!
    private var brushButton: UIButton!
    private var paletteButton: UIButton!
    private var brushSlider: BrushSlider!
    private var paletteTool: PaletteTool!

    private var isMenuOpen = false
    private var isBrushToolOpen = false
    private var isPaletteToolOpen = false
    private var isOrientationChanged = true
    private var discardedLines: [Line]?

    @objc func clear() {
        drawView.image = UIImage()
        if lines.count > 0 {
            discardedLines = lines
        } else {
            discardedLines = nil
        }
        undoIndexes.removeAll()
        lines.removeAll()
    }

    @objc func undo() {
        guard lines.count > 0 else { return }
        undoIndexes.removeLast()

        if undoIndexes.count == 0 {
            clear()
            return
        }

        discardedLines = Array(lines[undoIndexes.last!..<lines.count])

        lines = Array(lines.dropLast(lines.count - undoIndexes.last!))
        drawLines()
    }

    @objc func redo() {
        if discardedLines != nil {
            for line in discardedLines! {
                lines.append(line)
                drawLine(line: line)
            }
            undoIndexes.append(lines.count)
            discardedLines = nil
        }
    }

    @objc func toggleResizeBrushView() {

        if isBrushToolOpen {
            brushSize = brushSlider.brushSize
            brushSlider.removeFromSuperview()
            isBrushToolOpen = false
        } else {
            isBrushToolOpen = true
            if isPaletteToolOpen {
                togglePaletteTool()
            }
            if brushSlider == nil {
                brushSlider = BrushSlider(linkedButton: brushButton, brushSize: brushSize, color: color)
                brushSlider.backgroundColor = .white
                brushSlider.layer.borderColor = config.tintColor.cgColor
            } else {
                brushSlider.setFrame(linkedButton: brushButton, color: color)
            }

            view.addSubview(brushSlider)
            view.bringSubviewToFront(brushSlider)
        }
        imageView.isUserInteractionEnabled = isBrushToolOpen
    }

    @objc func togglePaletteTool() {
        if isPaletteToolOpen {
            color = paletteTool.newColor
            paletteTool.removeFromSuperview()
            isPaletteToolOpen = false
        } else {
            isPaletteToolOpen = true
            if isBrushToolOpen {
                toggleResizeBrushView()
            }

            if paletteTool == nil {
                paletteTool = PaletteTool(linkedButton: paletteButton, currentColor: color)
                paletteTool.backgroundColor = .white
                paletteTool.layer.borderColor = config.tintColor.cgColor
            } else {
                paletteTool.setFrame(linkedButton: paletteButton)
            }

            view.addSubview(paletteTool)
            view.bringSubviewToFront(paletteTool)
        }
        imageView.isUserInteractionEnabled = isPaletteToolOpen
    }

    func scaleLines(by scale: CGFloat) {

        for line in lines {
            let scaledStart = CGPoint(x: line.start.x * scale, y: line.start.y * scale)
            let scaledEnd = CGPoint(x: line.end.x * scale, y: line.end.y * scale)
            line.start = scaledStart
            line.end = scaledEnd
            line.brushSize = line.brushSize * scale
        }
    }

    @objc func save() {

        guard let sourceImageView = sourceImageView else {
            fatalError("Must set sourceImageView property to a UIImageView on your calling controller.")
        }

        let scale = originalImage!.size.height / imageView.frame.size.height
        UIGraphicsBeginImageContext(originalImage!.size)
        let context = UIGraphicsGetCurrentContext()
        let image = originalImage!
        image.draw(in: CGRect(x: 0, y: 0, width: originalImage!.size.width, height: originalImage!.size.height))
        context?.beginPath()
        context?.setLineCap(CGLineCap.round)
        context?.setBlendMode(CGBlendMode.normal)

        for line in lines {
            context?.setLineWidth(line.brushSize * scale)
            context?.setStrokeColor(line.color.cgColor)
            let scaledStart = CGPoint(x: line.start.x * scale, y: line.start.y * scale)
            let scaledEnd = CGPoint(x: line.end.x * scale, y: line.end.y * scale)
            context?.move(to: scaledStart)
            context?.addLine(to: scaledEnd)
            context?.strokePath()
        }

        sourceImageView.image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        containerView.setNeedsDisplay()

        if navigationController != nil {
            navigationController!.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func toggleMenu() {
        UIView.setAnimationCurve(.easeOut)
        if isMenuOpen {
            UIView.animate(withDuration: 0.3) {
                if self.isBrushToolOpen {
                    self.toggleResizeBrushView()
                }
                if self.isPaletteToolOpen {
                    self.togglePaletteTool()
                }
                self.clearButton.center = self.menuButton.center
                self.brushButton.center = self.menuButton.center
                self.undoButton.center = self.menuButton.center
                self.redoButton.center = self.menuButton.center
                if self.config.showPaletteButton {
                    self.paletteButton.center = self.menuButton.center
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                let y = self.menuButton.center.y
                let x = self.menuButton.center.x
                self.clearButton.center = CGPoint(x: x + self.menuItemSpacing, y: y)
                self.undoButton.center = CGPoint(x: x + self.menuItemSpacing * 2, y: y)
                self.redoButton.center = CGPoint(x: x + self.menuItemSpacing * 3, y: y)
                self.brushButton.center = CGPoint(x: x + self.menuItemSpacing * 4, y: y)
                if self.config.showPaletteButton {
                    self.paletteButton.center = CGPoint(x: x + self.menuItemSpacing * 5, y: y)
                }
            }
        }
        isMenuOpen = !isMenuOpen
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard !isBrushToolOpen && !isPaletteToolOpen else {
            super.touchesCancelled(touches, with: event)
            return
        }

        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: imageView)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard !isBrushToolOpen && !isPaletteToolOpen else {
            super.touchesCancelled(touches, with: event)
            return
        }

        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            let line = Line(start: lastPoint, end: currentPoint, brushSize: brushSize, color: color)
            lines.append(line)
            lastPoint = currentPoint
            drawLine(line: line)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard !isBrushToolOpen && !isPaletteToolOpen else {
            super.touchesCancelled(touches, with: event)
            return
        }

        undoIndexes.append(lines.count)
    }

    func drawLine(line: Line) {
        UIGraphicsBeginImageContext(drawView.frame.size)
        let context = UIGraphicsGetCurrentContext()

        drawView.image?.draw(in: CGRect(x: 0, y: 0, width: drawView.frame.size.width, height: drawView.frame.size.height))

        context?.beginPath()
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(line.brushSize)
        context?.setStrokeColor(line.color.cgColor)
        context?.setBlendMode(CGBlendMode.normal)

        context?.move(to: line.start)
        context?.addLine(to: line.end)
        context?.strokePath()

        drawView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        containerView.setNeedsDisplay()
    }

    func drawLines() {
        UIGraphicsBeginImageContextWithOptions(drawView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        drawView.image = UIImage()
        drawView.image?.draw(in: CGRect(x: 0, y: 0, width: drawView.frame.size.width, height: drawView.frame.size.height))

        context?.beginPath()
        context?.setLineCap(CGLineCap.round)
        context?.setBlendMode(CGBlendMode.normal)

        for line in lines {
            context?.setLineWidth(line.brushSize)
            context?.setStrokeColor(line.color.cgColor)
            context?.move(to: line.start)
            context?.addLine(to: line.end)
            context?.strokePath()
        }

        drawView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        containerView.setNeedsDisplay()
    }

    private func addImageView() {

        guard let image = originalImage else { return }

        imageView.image = image
        drawView.image = UIImage()
        imageView.removeFromSuperview()
        drawView.removeFromSuperview()

        let ratio = image.size.width / image.size.height

        let containerRatio = containerView.frame.size.width / containerView.frame.size.height

        let oldWidth = imageView.frame.width
        if containerView.frame.width > containerView.frame.height {
            // wider than tall
            if ratio < containerRatio {
                let newHeight = containerView.frame.height
                let newWidth = containerView.frame.height * ratio
                let originX: CGFloat = (containerView.frame.size.width - newWidth) / 2
                let originY: CGFloat = 0
                imageView.frame = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
            } else {
                let newHeight = containerView.frame.width / ratio
                let newWidth = containerView.frame.width
                let originX: CGFloat = 0
                let originY: CGFloat = (containerView.frame.size.height - newHeight) / 2
                imageView.frame = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
            }
        } else {
            // taller than wide
            if ratio < containerRatio {
                let newWidth = containerView.frame.height * ratio
                let newHeight = containerView.frame.height
                let originX: CGFloat = (containerView.frame.size.width - newWidth) / 2
                let originY: CGFloat = 0
                imageView.frame = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
            } else {
                let newWidth = containerView.frame.width
                let newHeight = containerView.frame.width / ratio
                let originX: CGFloat = 0
                let originY: CGFloat = (containerView.frame.size.height - newHeight) / 2
                imageView.frame = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
            }
        }

        let newWidth = imageView.frame.width
        if oldWidth != 0 {
            let scale = newWidth / oldWidth
            scaleLines(by: scale)
        }

        let height = round(imageView.frame.size.height)
        let width = round(imageView.frame.size.width)
        let drawFrame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: width, height: height)
        drawView.frame = drawFrame
        containerView.addSubview(imageView)
        containerView.addSubview(drawView)
        drawLines()
    }

    func makeButton(frame: CGRect, imageName name: String) -> UIButton {
        let button = RoundButton(frame: frame)
        button.layer.borderColor = config.tintColor.cgColor
        let bundle = Bundle(for: SwiftyJot.self)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = config.tintColor
        button.backgroundColor = config.buttonBackgroundColor
        return button
    }

    private func setupView() {
        // Config items
        view.backgroundColor = config.backgroundColor
        title = config.title
        color = config.brushColor
        brushSize = config.brushSize

        // layout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.frame = view.frame
        view.addSubview(containerView)


        if #available(iOS 11, *) {

            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                containerView.leftAnchor.constraint(equalTo: guide.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
                containerView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1.0)
                ])

        } else {

            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: standardSpacing)
                ])
        }
    }

    fileprivate func setupMenu() {

        guard config.showMenuButton else { return }

        let screenSize: CGRect = UIScreen.main.bounds
        let y = screenSize.height - 75
        menuButton = makeButton(frame: CGRect(x: 20, y: y, width: 50, height: 50), imageName: "hamburger")
        menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        view.addSubview(menuButton)

        clearButton = makeButton(frame: menuButton.frame, imageName: "trash")
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        view.addSubview(clearButton)

        undoButton = makeButton(frame: menuButton.frame, imageName: "undo")
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        view.addSubview(undoButton)

        redoButton = makeButton(frame: menuButton.frame, imageName: "redo")
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        view.addSubview(redoButton)

        brushButton = makeButton(frame: menuButton.frame, imageName: "brush")
        brushButton.addTarget(self, action: #selector(toggleResizeBrushView), for: .touchUpInside)
        view.addSubview(brushButton)

        if config.showPaletteButton {
            paletteButton = makeButton(frame: menuButton.frame, imageName: "palette")
            paletteButton.addTarget(self, action: #selector(togglePaletteTool), for: .touchUpInside)
            view.addSubview(paletteButton)
        }
        view.bringSubviewToFront(menuButton)
    }

    fileprivate func moveMenuButtonsOnTransition(to size: CGSize) {

        guard config.showMenuButton else { return }

        let y = size.height - 75
        let diameter = menuButton.frame.size.width
        menuButton.frame = CGRect(x: 20, y: y, width: diameter, height: diameter)
        clearButton.frame = CGRect(x: clearButton.frame.origin.x, y: y, width: diameter, height: diameter)
        undoButton.frame = CGRect(x: undoButton.frame.origin.x, y: y, width: diameter, height: diameter)
        redoButton.frame = CGRect(x: redoButton.frame.origin.x, y: y, width: diameter, height: diameter)
        brushButton.frame = CGRect(x: brushButton.frame.origin.x, y: y, width: diameter, height: diameter)
        if config.showPaletteButton {
            paletteButton.frame = CGRect(x: paletteButton.frame.origin.x, y: y, width: diameter, height: diameter)
        }
    }

    // MARK: - ViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        originalImage = sourceImageView?.image

        imageView.image = originalImage
        imageView.backgroundColor = .black

        setupMenu()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        moveMenuButtonsOnTransition(to: size)
        isOrientationChanged = true
        view.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isOrientationChanged {
            isOrientationChanged = false
            addImageView()
            if isBrushToolOpen {
                brushSlider.setFrame(linkedButton: brushButton, color: color)
            }
            if isPaletteToolOpen {
                paletteTool.setFrame(linkedButton: paletteButton)
            }
        }
    }
}

