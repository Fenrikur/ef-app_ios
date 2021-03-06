import EurofurenceModel
import Foundation
import KnowledgeGroupsComponent
import TestUtilities
import XCTEurofurenceModel

struct StubKnowledgeGroupsListViewModel: KnowledgeGroupsListViewModel {

    var knowledgeGroups: [KnowledgeListGroupViewModel] = []

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
        delegate.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
    }
    
    func describeContentsOfKnowledgeItem(at index: Int, visitor: KnowledgeGroupsListViewModelVisitor) {
        visitor.visit(stubbedGroupIdentifier(at: index))
    }

}

extension StubKnowledgeGroupsListViewModel: RandomValueProviding {

    static var random: StubKnowledgeGroupsListViewModel {
        return StubKnowledgeGroupsListViewModel(knowledgeGroups: .random)
    }

    func stubbedGroupIdentifier(at index: Int) -> KnowledgeGroupIdentifier {
        return KnowledgeGroupIdentifier("\(index)")
    }

}
