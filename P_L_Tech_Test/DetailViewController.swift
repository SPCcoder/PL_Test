//
//  DetailViewController.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var itemTitleLabel: UILabel!
	@IBOutlet weak var subTitleTextView: UITextView!
	@IBOutlet weak var bodyTextView: UITextView!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	var item: Item?
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let item = self.item {
			itemTitleLabel.text = item.title
			subTitleTextView.text = item.subtitle
			idLabel.text = "\(item.id)"
			dateLabel.text = item.date
			bodyTextView.text = item.body ?? ""
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
