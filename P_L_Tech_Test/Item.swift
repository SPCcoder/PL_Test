//
//  Item.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import Foundation
struct Item: Decodable {
	var id: Int
	var title: String
	var subtitle: String
	var date: String
	var body: String?
}

