//
//  WebHelper.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import Foundation

enum Result<T> {
	case success(T)
	case error(Error)
}

class WebHelper {
	//TODO: There's no check for if device has internet connection
	func detailEndpoint(forID id: Int)-> String {
		return "content/\(id).json"
	}
	
	/// Gets an aaray of 'Item' objects. Func writen to support iOS 8
	///
	/// - Parameter completion: Item array or Error
	func getContentList(completion: @escaping((Result<[Item]>) -> ())) {
		
		let urlString =  Constants.PULSE_LIVE_BASE_ENDPOINT + Constants.CONTENT_LIST_JSON
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
				completion(.error(error!))
			}
			
			guard let data = data else { return }
			
			do {
				
				let itemsDict = try JSONDecoder().decode([String : [Item]].self, from: data)

				if let itemsArray = itemsDict["items"] {

					completion(.success(itemsArray))
				}
				
			} catch let jsonError {
				
				completion(.error(jsonError))
			}
			
			}.resume()
	}
	
	/// Gets all the detail for a specific Item. Func writen to support iOS 8
	///
	/// - Parameters:
	///   - id: The Item's id
	///   - completion: An Item object or an Error
	func getItemDetails(forID id: Int, completion: @escaping((Result<Item>) -> ())) {
		
		let urlString =  Constants.PULSE_LIVE_BASE_ENDPOINT + detailEndpoint(forID: id)
		
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
				completion(.error(error!))
			}
			
			guard let data = data else { return }
			
			do {
				
				let itemDict = try JSONDecoder().decode([String : Item].self, from: data)
				
				if let item = itemDict["item"] {
					completion(.success(item))
				}
				
			} catch let jsonError {
				print(jsonError)
				completion(.error(jsonError))
			}
			
			}.resume()
	}
}

// MARK: -
private struct Constants {
	// Base
	static let PULSE_LIVE_BASE_ENDPOINT =  "http://dynamic.pulselive.com/test/native/"
	//Content List Endpoint:
	static let CONTENT_LIST_JSON = "contentList.json"
	//Content Detail Endpoint (​[id] should be replaced with item id):
	static let DETAIL_ENDPOINT = "content/[id].json"
}
