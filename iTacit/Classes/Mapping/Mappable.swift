//
//  Mappable.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 9/10/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

protocol Mappable: KeyValueCodable {

	init()
	static var mapping: [PropertyDescriptor] { get }
}
