import EurofurenceModel
import EventDetailComponent

class CapturingEventDetailViewModel: EventDetailViewModel {

    var numberOfComponents: Int { return 0 }

    private(set) var delegate: EventDetailViewModelDelegate?
    func setDelegate(_ delegate: EventDetailViewModelDelegate) {
        self.delegate = delegate
    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {

    }

    private(set) var wasToldToFavouriteEvent = false
    func favourite() {
        wasToldToFavouriteEvent = true
    }

    private(set) var wasToldToUnfavouriteEvent = false
    func unfavourite() {
        wasToldToUnfavouriteEvent = true
    }

}

extension CapturingEventDetailViewModel {

    func simulateFavourited() {
        delegate?.eventFavourited()
    }

    func simulateUnfavourited() {
        delegate?.eventUnfavourited()
    }

}
