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
	}
	
	@IBAction func goFullScreen() {
		guard let parent = self.containerController else { return }

		if !self.isInsideContainer {
			(self.navigationController ?? self).dismiss(animated: true, completion: nil)
			return
		}

		if self.isZoomedToFullScreen {
			self.fullScreenButton.setTitle("Full Screen", for: .normal)
			self.returnToParentView(duration: 0.3) {
				self.view.backgroundColor = .white
			}
		} else {
			self.fullScreenButton.setTitle("Back", for: .normal)
			self.makeFullScreen(in: parent, duration: 0.3) {
				self.view.backgroundColor = .gray
			}
		}
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
