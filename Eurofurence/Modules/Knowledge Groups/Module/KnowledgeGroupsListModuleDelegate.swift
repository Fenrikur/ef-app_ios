//
//  KnowledgeGroupsListModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

protocol KnowledgeGroupsListModuleDelegate {

    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroup.Identifier)

}
