//
//  KnowledgeGroupsListViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence
import UIKit.UIImage

extension KnowledgeListGroupViewModel: RandomValueProviding {
    
    static var random: KnowledgeListGroupViewModel {
        return KnowledgeListGroupViewModel(title: .random,
                                           fontAwesomeCharacter: .random,
                                           groupDescription: .random,
                                           knowledgeEntries: .random)
    }
    
}

extension KnowledgeListEntryViewModel: RandomValueProviding {
    
    static var random: KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: .random)
    }
    
}
