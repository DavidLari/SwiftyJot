//
//  InitialViewController.swift
//  AnnotateImage
//
//  Created by David Lari on 11/25/17.
//  Copyright © 2017 David Lari. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet var imageButtons: [UIButton]!

    @IBAction func buttonTapped(_ sender: UIButton) {

    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for button in imageButtons {
            button.imageView?.contentMode = .scaleAspectFill
        }

    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let dest = segue.destination as! MainViewController
        let button = sender as! UIButton
        dest.image = button.imageView?.image

    }


}
