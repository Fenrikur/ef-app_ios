@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class KnowledgeDetailPresenterTestBuilder {

    struct Context {
        var knowledgeEntryIdentifier: KnowledgeEntryIdentifier
        var knowledgeDetailScene: CapturingKnowledgeDetailScene
        var interactor: StubKnowledgeDetailSceneInteractor
        var module: UIViewController
        var delegate: CapturingKnowledgeDetailModuleDelegate
    }

    private var interactor = StubKnowledgeDetailSceneInteractor()

    @discardableResult
    func with(_ interactor: StubKnowledgeDetailSceneInteractor) -> KnowledgeDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> Context {
        let knowledgeEntryIdentifier = KnowledgeEntryIdentifier.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let delegate = CapturingKnowledgeDetailModuleDelegate()
        let moduleBuilder = KnowledgeDetailModuleBuilder()
            .with(knowledgeDetailSceneFactory)
            .with(interactor)
            .build()
        let module = moduleBuilder.makeKnowledgeListModule(knowledgeEntryIdentifier, delegate: delegate)

        return Context(knowledgeEntryIdentifier: knowledgeEntryIdentifier,
                       knowledgeDetailScene: knowledgeDetailScene,
                       interactor: interactor,
                       module: module,
                       delegate: delegate)
    }

}
