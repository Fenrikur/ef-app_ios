import EurofurenceModel
import Foundation

public class FakeDealersService: DealersService {
    
    public let index: FakeDealersIndex

    public init(index: FakeDealersIndex = FakeDealersIndex()) {
        self.index = index
    }
    
    private var stubbedDealers = [Dealer]()
    public func fetchDealer(for identifier: DealerIdentifier) -> Dealer? {
        return stubbedDealers.first(where: { $0.identifier == identifier })
    }

    public func makeDealersIndex() -> DealersIndex {
        return index
    }

}

public extension FakeDealersService {
    
    func add(_ dealer: Dealer) {
        stubbedDealers.append(dealer)
    }

}
