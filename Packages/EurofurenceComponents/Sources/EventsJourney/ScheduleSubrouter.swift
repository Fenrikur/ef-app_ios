import ComponentBase
import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import ScheduleComponent

public struct ScheduleSubrouter: ScheduleComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func scheduleComponentDidSelectEvent(identifier: EventIdentifier) {
        try? router.route(EventContentRepresentation(identifier: identifier))
    }
    
    public func scheduleComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        try? router.route(EventFeedbackContentRepresentation(identifier: event))
    }
    
}