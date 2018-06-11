//
//  DetailViewController.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	var item: Item?
	@IBOutlet weak var itemTitleLabel: UILabel!
	@IBOutlet weak var subTitleTextView: UITextView!
	@IBOutlet weak var bodyTextView: UITextView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let item = self.item {
		itemTitleLabel.text = item.title
		subTitleTextView.text = item.subtitle
		bodyTextView.text = item.body ?? ""
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
