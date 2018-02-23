//
//  KnowledgeListViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

protocol KnowledgeListViewModel {

    var knowledgeGroups: [KnowledgeGroupViewModel] { get }

}

protocol KnowledgeGroupViewModel {

    var title: String { get }
    var icon: UIImage { get }
    var groupDescription: String { get }
    var knowledgeEntries: [KnowledgeEntryViewModel] { get }

}

protocol KnowledgeEntryViewModel {

    var title: String { get }

}
