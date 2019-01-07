//
//  StubKnowledgeDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubKnowledgeDetailModuleProviding: KnowledgeDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: KnowledgeEntryIdentifier?
    private(set) var delegate: KnowledgeDetailModuleDelegate?
    func makeKnowledgeListModule(_ knowledgeEntry: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        capturedModel = knowledgeEntry
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeDetailModuleProviding {

    func simulateLinkSelected(_ link: Link) {
        delegate?.knowledgeDetailModuleDidSelectLink(link)
    }

}
