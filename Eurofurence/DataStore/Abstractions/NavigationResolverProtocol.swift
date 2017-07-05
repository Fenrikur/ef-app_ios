//
//  NavigationResolverProtocol.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

/**
To improve navigation between related entities, the NavigationResolverProtocol
requires knowledge of all such relations based on EntityBase.Id and respective
properties of related model entities.
*/
protocol NavigationResolverProtocol {
	/**
	Resolves all relations between known entities in given dataContext. 
	
	- Parameter dataContext Context within which relations should be resolved
	*/
	func resolve(dataContext: DataContextProtocol)
}
