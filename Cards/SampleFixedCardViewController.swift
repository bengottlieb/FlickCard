//
//  SampleFixedCardViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class SampleFixedCardViewController: FlickCardViewController {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var indicatorLabel: UILabel!
	
	var image: UIImage?
	var parentController: UIViewController?
	
	convenience init(image: UIImage, parent: UIViewController) {
		self.init(nibName: "SampleFixedCardViewController", bundle: nil)
		self.image = image
		self.parentController = parent
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.indicatorLabel.isHidden = true
		self.imageView.image = self.image

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.indicatorLabel.isHidden = self.parent == nil
	}
	
	@IBAction func goFullScreen() {
		guard let parent = self.parentController as? FlickCardParentViewController else { return }
		
		if self.isZoomedToFullScreen {
			self.returnToParentView(in: parent, duration: 0.3) {
				self.view.backgroundColor = .white
			}
		} else {
			self.makeFullScreen(in: parent, duration: 0.3) {
				self.view.backgroundColor = .black
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
