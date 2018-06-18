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
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		return UIActivityIndicatorView(activityIndicatorStyle: .gray)
	}()
	
	@IBOutlet weak var itemsTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureTableview()
	}
	
	private func configureTableview() {
		register(cellNibs: [Constants.ITEM_TABLEVIEW_CELL], cellIds:[Constants.ITEM_CELL_ID], for: self.itemsTableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let webHelper = WebHelper()
		
		webHelper.getContentList { (result) in
			
			DispatchQueue.main.async { // both cases will update the UI so the whole switch is on the main thread
				switch result {
				case let .success(items):
					self.items = items
					self.itemsTableView.reloadData()
					
				case let .error(error):
					//TODO: show alert to tell user we can not get data
					let alertView = UIAlertController(title: Constants.ERROR_TITLE, message: Constants.CANNOT_GET_ARTICLE_LIST, preferredStyle: .alert)
					alertView.show(self, sender: self)
				}
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

// MARK: - TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ITEM_CELL_ID) as? ItemTableViewCell else { return UITableViewCell()}
		let item = self.items[indexPath.row]
		cell.itemIdLabel.text = "\(Constants.ARTICLE_ID_LABLE) \(item.id)"
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
		
		showActivityIndicator()// block UI for api call
		
		webHelper.getItemDetails(forID: selectedItem.id) { (result) in
			DispatchQueue.main.async {
				self.activityIndicator.stopAnimating()
				
				switch result {
					
				case let .success(item):
					self.performSegue(withIdentifier: Constants.DETAIL_VC_SEGUE_IDENTIFIER, sender: item)
				case .error(_):
					let alertView = UIAlertController(title: Constants.ERROR_TITLE, message: Constants.CANNOT_GET_DETAILS, preferredStyle: .alert)
					alertView.show(self, sender: self)
				}
			}
		}
		
	}
	
	private func showActivityIndicator() {
		// update/block UI
		activityIndicator.hidesWhenStopped = true
		activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2);
		activityIndicator.center = view.center
		self.view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
	}
}

// MARK: -
private struct Constants {
	static let ITEM_TABLEVIEW_CELL = "ItemTableViewCell"
	static let ITEM_CELL_ID = "itemCell"
	static let DETAIL_VC_SEGUE_IDENTIFIER = "showDetail"
	static let CANNOT_GET_DETAILS = "Unable to get the article's details right now" //TODO: Not localised
	static let CANNOT_GET_ARTICLE_LIST = "Unable to get the list of artcles right now" //TODO: Not localised
	static let ERROR_TITLE = "Error" //TODO: Not localised
	static let ARTICLE_ID_LABLE = "Article ID:"
	
}

