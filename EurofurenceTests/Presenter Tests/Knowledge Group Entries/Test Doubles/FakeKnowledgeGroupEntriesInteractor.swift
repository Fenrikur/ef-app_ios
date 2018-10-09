//
//  FakeKnowledgeGroupEntriesInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import Foundation

struct FakeKnowledgeGroupEntriesInteractor: KnowledgeGroupEntriesInteractor {
    
    private let groupIdentifier: KnowledgeGroup2.Identifier
    private let viewModel: KnowledgeGroupEntriesViewModel
    
    init(for groupIdentifier: KnowledgeGroup2.Identifier, viewModel: KnowledgeGroupEntriesViewModel) {
        self.groupIdentifier = groupIdentifier
        self.viewModel = viewModel
    }
    
    func makeViewModelForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void) {
        guard identifier == groupIdentifier else { return }
        completionHandler(viewModel)
    }
    
}
