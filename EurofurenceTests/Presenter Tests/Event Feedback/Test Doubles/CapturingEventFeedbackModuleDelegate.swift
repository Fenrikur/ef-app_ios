@testable import Eurofurence

class CapturingEventFeedbackModuleDelegate: EventFeedbackModuleDelegate {
    
    private(set) var dismissed = false
    func eventFeedbackDismissed() {
        dismissed = true
    }
    
}