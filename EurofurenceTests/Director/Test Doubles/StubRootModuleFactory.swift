@testable import Eurofurence
import EurofurenceModel

class StubRootModuleFactory: RootModuleProviding {

    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }

}

extension StubRootModuleFactory {

    func simulateAppReady() {
        delegate?.rootModuleDidDetermineRootModuleShouldBePresented()
    }

    func simulateTutorialShouldBePresented() {
        delegate?.rootModuleDidDetermineTutorialShouldBePresented()
    }

    func simulateStoreShouldBeRefreshed() {
        delegate?.rootModuleDidDetermineStoreShouldRefresh()
    }

}
