//
//  ViewController.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import UIKit
//Content List Endpoint:
// http://dynamic.pulselive.com/test/native/contentList.json

//Content Detail Endpoint (​[id] should be replaced with item id):
// http://dynamic.pulselive.com/test/native/content/[id].json
class ViewController: UIViewController {
	var items: [Item] = []
	
	@IBOutlet weak var itemsTableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		configureTableview()
	}
	private func configureTableview() {
		register(cellNibs: ["ItemTableViewCell"], cellIds:["itemCell"], for: self.itemsTableView)
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
		// Dispose of any resources that can be recreated.
	}
	
	/// Register Tableview Cells
	func register(cellNibs: [String], cellIds: [String], for tableView: UITableView) {
		guard cellNibs.count > 0, cellIds.count > 0 else { return }
		zip(cellNibs, cellIds).forEach { tableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $1) }
	}
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemTableViewCell else { return UITableViewCell()}
		
		cell.itemIdLabel.text = "\(self.items[indexPath.row].id)"
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showDetail", sender: indexPath)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			guard let detailVC = segue.destination as? DetailViewController else { return}
			if let index = sender as? IndexPath {
				print(index)
			detailVC.item = self.items[index.row]
				//self.navigationController?.pushViewController(detailVC, animated: true)
			}
		}
	}
}


