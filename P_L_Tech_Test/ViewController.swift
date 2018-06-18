//
//  ViewController.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var items: [Item] = []
	
	@IBOutlet weak var itemsTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableview()
	}
	
	private func configureTableview() {
		register(cellNibs: [Constants.ITEM_TABLEVIEW_CELL], cellIds:[Constants.ITEM_CELL_ID], for: self.itemsTableView)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let webHelper = WebHelper()
		webHelper.getContentList { (result) in
			
			switch result {
			case let .success(items):
				self.items = items
				DispatchQueue.main.async {
					self.itemsTableView.reloadData()
				}
			case let .error(error):
				print(error)
				
				//TODO: show alert to tell user we can not get data
			}
			
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	/// Register Tableview Cells
	func register(cellNibs: [String], cellIds: [String], for tableView: UITableView) {
		guard cellNibs.count > 0, cellIds.count > 0 else { return }
		zip(cellNibs, cellIds).forEach { tableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $1) }
	}
}

// MARK: - TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ITEM_CELL_ID) as? ItemTableViewCell else { return UITableViewCell()}
		let item = self.items[indexPath.row]
		cell.itemIdLabel.text = "Article ID: \(item.id)"
		cell.titleLabel.text = item.title
		cell.subTitleLabel.text = item.subtitle
		cell.dateLabel.text = item.date
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 127.0
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 127.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// call for details
		let webHelper = WebHelper()
		let selectedItem = self.items[indexPath.row]
		// update/block UI
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activityIndicator.hidesWhenStopped = true
		activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2);
		activityIndicator.center = view.center
		self.view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		
		webHelper.getItemDetails(forID: selectedItem.id) { (result) in
			DispatchQueue.main.async {
				activityIndicator.stopAnimating()
				
			}
			switch result {
				
			case let .success(item):
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: Constants.DETAIL_VC_SEGUE_IDENTIFIER, sender: item)
					
				}
			case let .error(error):
				print(error)
				
				//TODO: show alert to tell user we can not get data
			}
			
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Constants.DETAIL_VC_SEGUE_IDENTIFIER {
			guard let detailVC = segue.destination as? DetailViewController else { return}
			if let sentItem = sender as? Item {
				print(sentItem)
				detailVC.item = sentItem
				
			}
		}
	}
}

// MARK: -
private struct Constants {
	static let ITEM_TABLEVIEW_CELL = "ItemTableViewCell"
	static let ITEM_CELL_ID = "itemCell"
	static let DETAIL_VC_SEGUE_IDENTIFIER = "showDetail"
	
}

