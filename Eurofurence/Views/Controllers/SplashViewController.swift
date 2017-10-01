//
//  SplashViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin
import UIKit
import ReactiveSwift
import Whisper

class SplashViewController: UIViewController, SplashScene,
                            DataStoreLoadDelegate,
                            DataStoreRefreshDelegate {

    // MARK: IBOutlets

    @IBOutlet weak var loadingProgressView: UIProgressView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var hieroglyphLabel: UILabel!

    // MARK: Properties

    private lazy var loadController = DataStoreLoadController.shared
    private lazy var refreshController = DataStoreRefreshController.shared

    // MARK: Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingProgressView.progress = 0

        let string = String(makeRandomHieroglyphCharacter())
        hieroglyphLabel.text = string
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

		loadController.add(self, doPrepend: true)
        refreshController.add(self, doPrepend: true)
        loadController.loadFromStore()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
		refreshController.remove(self)
        loadController.remove(self)
    }

    // MARK: SplashScene

    var delegate: SplashSceneDelegate?

    func showQuote(_ quote: String) {
        quoteLabel.text = quote
    }

    func showQuoteAuthor(_ author: String) {
        quoteAuthorLabel.text = "- \(author)"
    }

    func showProgress(_ progress: Float) {

    }

    // MARK: DataStoreLoadDelegate

    func dataStoreLoadDidBegin() {

    }

    func dataStoreLoadDidProduceProgress(_ progress: Progress) {
        loadingProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
    }

    func dataStoreLoadDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

    // MARK: DataStoreRefreshDelegate

    func dataStoreRefreshDidFinish() {
        performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {
        loadingProgressView.progress = Float(progress.fractionCompleted)
    }

	func dataStoreRefreshDidBegin(_ lastSync: Date?) { }
    func dataStoreRefreshDidFailWithError(_ error: Error) {
		if let error = error as? ActionError<NSError> {
			switch error {
			case let .producerFailed(error):
				if error.domain == ApiConnectionError.errorDomain {
					let tutorialFinishedKey = UserDefaultsTutorialStateProvider.FinishedTutorialKey
					UserDefaults.standard.set(false, forKey: tutorialFinishedKey)
					UserDefaults.standard.synchronize()

					let window = UIApplication.shared.delegate!.window!
					let alert = UIAlertController(title: "Download Error", message: "Failed to download data from server. Please try again.", preferredStyle: .alert)
					alert.addAction(UIAlertAction.init(title: "Close", style: .cancel, handler: { _ in
						PresentationTier.assemble(window: window!)
					}))
					window!.rootViewController!.present(alert, animated: true)
					return
				}
			default:
				break
			}
		}
		performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: self)
	}

    // MARK: Private

    private func makeRandomHieroglyphCharacter() -> Character {
        let availableChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let length = availableChars.characters.count
        let index = Int(arc4random_uniform(UInt32(length)))
        let stringIndex = availableChars.index(availableChars.startIndex, offsetBy: index)

        return availableChars[stringIndex]
    }

}
