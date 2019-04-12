import EurofurenceModel

class ApplicationPreloadInteractor: PreloadInteractor {

    private let refreshService: RefreshService
    private var observations = [Any]()

    convenience init() {
        self.init(refreshService: SharedModel.instance.services.refresh)
    }

    init(refreshService: RefreshService) {
        self.refreshService = refreshService
    }

    func beginPreloading(delegate: PreloadInteractorDelegate) {
        let progress = refreshService.refreshLocalStore { (error) in
            if error == nil {
                delegate.preloadInteractorDidFinishPreloading()
            } else {
                delegate.preloadInteractorDidFailToPreload()
            }
        }

        var totalUnitCount = 0
        var completedUnitCount = 0

        let updateProgress = {
            delegate.preloadInteractorDidProgress(currentUnitCount: completedUnitCount,
                                                  totalUnitCount: totalUnitCount,
                                                  localizedDescription: progress.localizedDescription ?? "")
        }

        observations.append(progress.observe(\.totalUnitCount, options: [.new]) { (_, change) in
            if let value = change.newValue {
                totalUnitCount = Int(value)
                updateProgress()
            }
        })

        observations.append(progress.observe(\.completedUnitCount, options: [.new]) { (_, change) in
            if let value = change.newValue {
                completedUnitCount = Int(value)
                updateProgress()
            }
        })
    }

}
