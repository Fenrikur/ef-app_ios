//
//  Map.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class Map: EntityBase {
    var Description = ""
    var ImageId = ""
	var IsBrowseable = true
	var Entries : [MapEntry] = []
	
    var Image : Image? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Image",keyInResource: nil)]
	}
}
