//
//  SampleFixedCardViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class SampleFixedCardViewController: FlickCardController {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var indicatorLabel: UILabel!
	@IBOutlet var fullScreenButton: UIButton!

	var listHeight: CGFloat = 200
	//override var listViewHeight: CGFloat { return self.listHeight }
	var image: UIImage?
	
	convenience init(image: UIImage, id: ID) {
		self.init(nibName: "SampleFixedCardViewController", bundle: nil)
		self.image = image
		self.id = id
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.indicatorLabel.isHidden = true
		self.imageView.image = self.image
		self.imageView.layer.borderColor = UIColor.black.cgColor
		self.imageView.layer.borderWidth = 1
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
