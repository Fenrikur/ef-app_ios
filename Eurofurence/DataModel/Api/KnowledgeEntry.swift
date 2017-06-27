//
//  KnowledgeEntry.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeEntry: EntityBase {
	var KnowledgeGroupId : String = ""
	var Order : Int = 0
	var Text : String = ""
	var Title : String = ""
    
	var Links : [LinkFragment] = []
    
	weak var KnowledgeGroup : KnowledgeGroup? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "KnowledgeGroup",keyInResource: nil)]
	}
}

extension KnowledgeEntry: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? KnowledgeEntry).map {
			return self.Order < $0.Order
			} ?? super.lessThan(rhs)
	}
}
