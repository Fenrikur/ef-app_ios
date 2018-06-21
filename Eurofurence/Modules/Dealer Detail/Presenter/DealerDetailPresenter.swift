//
//  DealerDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DealerDetailPresenter: DealerDetailSceneDelegate {

    private struct Binder: DealerDetailSceneBinder {

        var viewModel: DealerDetailViewModel

        func bindComponent<T>(at index: Int, using componentFactory: T) where T: DealerDetailComponentFactory {
            let visitor = Visitor(componentFactory)
            viewModel.describeComponent(at: index, to: visitor)
        }

        private class Visitor<T>: DealerDetailViewModelVisitor where T: DealerDetailComponentFactory {

            private let componentFactory: T

            init(_ componentFactory: T) {
                self.componentFactory = componentFactory
            }

            func visit(_ summary: DealerDetailSummaryViewModel) {
                _ = componentFactory.makeDealerSummaryComponent { (component) in
                    component.showArtistArtworkImageWithPNGData(summary.artistImagePNGData)
                }
            }

        }

    }

    private let scene: DealerDetailScene
    private let interactor: DealerDetailInteractor
    private let dealer: Dealer2.Identifier

    init(scene: DealerDetailScene, interactor: DealerDetailInteractor, dealer: Dealer2.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.dealer = dealer

        scene.setDelegate(self)
    }

    func dealerDetailSceneDidLoad() {
        interactor.makeDealerDetailViewModel(for: dealer) { (viewModel) in
            self.scene.bind(numberOfComponents: viewModel.numberOfComponents,
                            using: Binder(viewModel: viewModel))
        }
    }

}
