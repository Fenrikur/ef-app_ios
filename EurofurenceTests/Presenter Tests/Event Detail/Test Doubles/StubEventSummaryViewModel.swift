@testable import Eurofurence
import EurofurenceModel
import TestUtilities
import Foundation

struct StubEventSummaryViewModel: EventDetailViewModel {

    let summary: EventSummaryViewModel
    private let expectedIndex: Int

    init(summary: EventSummaryViewModel, at index: Int) {
        self.summary = summary
        expectedIndex = index
    }

    var numberOfComponents: Int = .random

    func setDelegate(_ delegate: EventDetailViewModelDelegate) {

    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(summary.randomized(ifFalse: index == expectedIndex))
    }

    func favourite() {

    }

    func unfavourite() {

    }

}
