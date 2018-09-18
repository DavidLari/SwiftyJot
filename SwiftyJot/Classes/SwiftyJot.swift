//
//  SwiftyJot.swift
//  AnnotateImage
//
//  Created by David Lari on 11/23/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit

public class SwiftyJot {

    public init() {

    }

    convenience init(config: Config) {
        self.init()
        self.config = config
    }

    public struct Config {

        public init() {

        }

        public var backgroundColor = UIColor.black
        public var title: String?
        public var tintColor = UIColor.blue
        public var buttonBackgroundColor = UIColor.white
        public var isButtonShadowVisible = true
        public var brushColor = UIColor.red
        public var brushSize: CGFloat = 8
        public var showMenuButton = true
        public var showPaletteButton = true
    }

    public var config = Config()

    public func present(sourceImageView: UIImageView, presentingViewController presenter: UIViewController) {

        let swiftyJotController = SwiftyJotController()
        swiftyJotController.config = config
        swiftyJotController.sourceImageView = sourceImageView

        if let navigationController = presenter.navigationController {
            navigationController.pushViewController(swiftyJotController, animated: true)
        } else {
            presenter.present(swiftyJotController, animated: true, completion: nil)
        }
    }
}
