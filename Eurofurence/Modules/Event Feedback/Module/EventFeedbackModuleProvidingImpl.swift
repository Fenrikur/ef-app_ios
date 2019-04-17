import EurofurenceModel
import UIKit.UIViewController

struct EventFeedbackModuleProvidingImpl: EventFeedbackModuleProviding {
    
    private let presenterFactory: EventFeedbackPresenterFactory
    private let sceneFactory: EventFeedbackSceneFactory
    
    init(presenterFactory: EventFeedbackPresenterFactory, sceneFactory: EventFeedbackSceneFactory) {
        self.presenterFactory = presenterFactory
        self.sceneFactory = sceneFactory
    }
    
    func makeEventFeedbackModule(for event: Event, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventFeedbackScene()
        presenterFactory.makeEventFeedbackPresenter(for: event, scene: scene, delegate: delegate)
        
        return scene
    }
    
}