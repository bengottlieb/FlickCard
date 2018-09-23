//
//  SampleCardViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class SampleCardViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	
	var image: UIImage?
	
	convenience init(image: UIImage) {
		self.init(nibName: "SampleCardViewController", bundle: nil)
		self.image = image
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.imageView.image = self.image

        // Do any additional setup after loading the view.
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
