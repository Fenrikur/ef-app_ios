//
//  DefaultKnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {

    private struct ViewModel: KnowledgeEntryDetailViewModel {

        var title: String
        var contents: NSAttributedString
        var links: [LinkViewModel]
        var images: [KnowledgeEntryImageViewModel]
        private var linkModels: [Link]

        init(title: String, contents: NSAttributedString, links: [Link], images: [Data]) {
            self.title = title
            self.contents = contents
            self.linkModels = links
            self.links = links.map({ LinkViewModel(name: $0.name) })
            self.images = images.map(KnowledgeEntryImageViewModel.init)
        }

        func link(at index: Int) -> Link {
            return linkModels[index]
        }

    }

    var knowledgeService: KnowledgeService = EurofurenceApplication.shared
    var renderer: MarkdownRenderer = DefaultDownMarkdownRenderer()

    func makeViewModel(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        let service = knowledgeService
        service.fetchKnowledgeEntry(for: identifier) { (entry) in
            service.fetchImagesForKnowledgeEntry(identifier: identifier) { (images) in
                let renderedContents = self.renderer.render(entry.contents)
                let viewModel = ViewModel(title: entry.title, contents: renderedContents, links: entry.links, images: images)
                completionHandler(viewModel)
            }
        }
    }

}
