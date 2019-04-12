import Foundation

protocol DealersScene {

    func setDelegate(_ delegate: DealersSceneDelegate)
    func setDealersTitle(_ title: String)
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func deselectDealer(at indexPath: IndexPath)
    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder)
    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder)

}

protocol DealersSceneDelegate {

    func dealersSceneDidLoad()
    func dealersSceneDidChangeSearchQuery(to query: String)
    func dealersSceneDidSelectDealer(at indexPath: IndexPath)
    func dealersSceneDidSelectDealerSearchResult(at indexPath: IndexPath)
    func dealersSceneDidPerformRefreshAction()

}
