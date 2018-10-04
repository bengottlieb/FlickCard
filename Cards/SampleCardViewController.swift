//
//  SampleCardViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class SampleCardViewController: FlickCardController {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var indicatorLabel: UILabel!
	@IBOutlet var fullScreenButton: UIButton!

	var image: UIImage?
	
	convenience init(image: UIImage, id: ID) {
		self.init(nibName: "SampleCardViewController", bundle: nil)
		self.image = image
		self.id = id
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.indicatorLabel.isHidden = true
		self.imageView.image = self.image
		
		self.imageView.layer.borderColor = UIColor.black.cgColor
		self.imageView.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.indicatorLabel.isHidden = self.parent == nil
		self.fullScreenButton.isHidden = self.isInsideContainer
	}
	
	
	@IBAction func back() {
		self.dismiss(animated: true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
