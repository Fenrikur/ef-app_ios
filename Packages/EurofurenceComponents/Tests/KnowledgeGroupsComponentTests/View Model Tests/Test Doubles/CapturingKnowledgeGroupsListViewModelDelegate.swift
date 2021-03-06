import KnowledgeGroupsComponent

class CapturingKnowledgeGroupsListViewModelDelegate: KnowledgeGroupsListViewModelDelegate {

    private(set) var capturedViewModels: [KnowledgeListGroupViewModel] = []
    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel]) {
        capturedViewModels = viewModels
    }

}
