//
//  MainViewController.swift
//  SwiftyJot Example
//
//  Created by David Lari on 11/23/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit
import SwiftyJot

class MainViewController: UIViewController {

    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func buttonTapped() {

        let swiftyJot = SwiftyJot()
        var config = SwiftyJot.Config()
        config.backgroundColor = .gray
        config.title = "Example"
        config.tintColor = .darkGray
        config.buttonBackgroundColor = .white
        config.brushColor = .red
        config.brushSize = 8.0
        config.showMenuButton = true
        config.showPaletteButton = true
        swiftyJot.config = config

        swiftyJot.present(sourceImageView: imageView, presentingViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
