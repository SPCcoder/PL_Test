//
//  WebHelper.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import Foundation
import UIKit
enum Result<T> {
	case success(T)
	case error(Error)
}

//Content List Endpoint:
// http://dynamic.pulselive.com/test/native/contentList.json
let PULSE_LIVE_BASE_ENDPOINT =  "http://dynamic.pulselive.com/test/native/"
let CONTENT_LIST_JSON = "contentList.json"
//Content Detail Endpoint (​[id] should be replaced with item id):
// http://dynamic.pulselive.com/test/native/content/[id].json
let DETAIL_ENDPOINT = "content/[id].json"
class WebHelper {
	
	func getContentList(completion: @escaping((Result<[Item]>) -> ())) {
		
		let urlString =  PULSE_LIVE_BASE_ENDPOINT + CONTENT_LIST_JSON
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
				completion(.error(error!))
			}
			
			guard let data = data else { return }
			
			do {
				
				let itemsDict = try JSONDecoder().decode([String : [Item]].self, from: data)
				print(itemsDict)
				if let itemsArray = itemsDict["items"] {
					print(itemsArray)
					print(itemsArray[0])
					let myItem = itemsArray[0]
					print(myItem)
					completion(.success(itemsArray))
				}
	
			} catch let jsonError {
				print(jsonError)
				completion(.error(jsonError))
			}
			
			}.resume()
	}
	func getItemDetails(forID: Double, completion: @escaping((Result<Item>) -> ())) {
		
		let urlString =  PULSE_LIVE_BASE_ENDPOINT + CONTENT_LIST_JSON
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
				completion(.error(error!))
			}
			
			guard let data = data else { return }
			
			do {
				
				let item = try JSONDecoder().decode(Item.self, from: data)
				//if let item = itemsDict["item"] {

					completion(.success(item))
			//	}
				
			} catch let jsonError {
				print(jsonError)
				completion(.error(jsonError))
			}
			
			}.resume()
	}
}
