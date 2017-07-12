//
//  TutorialPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class TutorialPresenter: TutorialPageSceneDelegate {

    // MARK: Properties

    private var tutorialScene: TutorialScene
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var splashScreenRouter: SplashScreenRouter
    private var alertRouter: AlertRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability
    private var pushPermissionsRequesting: PushPermissionsRequesting
    private var userAcknowledgedPushPermissionsRequest: UserAcknowledgedPushPermissionsRequestStateProviding
    private var userPushPermissionsState: UserPushPermissionsState

    // MARK: Initialization

    init(tutorialScene: TutorialScene,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         userAcknowledgedPushPermissionsRequest: UserAcknowledgedPushPermissionsRequestStateProviding,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting,
         userPushPermissionsState: UserPushPermissionsState) {
        self.tutorialScene = tutorialScene
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
        self.userAcknowledgedPushPermissionsRequest = userAcknowledgedPushPermissionsRequest
        self.userPushPermissionsState = userPushPermissionsState

        if userAcknowledgedPushPermissionsRequest.userHasAcknowledgedRequestForPushPermissions {
            showInitiateDownloadPage()
        } else {
            showRequestPushPermissionsPage()
        }
    }

    // MARK: TutorialPageSceneDelegate

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        guard userAcknowledgedPushPermissionsRequest.userHasAcknowledgedRequestForPushPermissions else {
            userPushPermissionsState.markPermittedRegisteringForPushNotifications()
            pushPermissionsRequesting.requestPushPermissions {
                self.userAcknowledgedPushPermissionsRequest.markUserAsAcknowledgingPushPermissionsRequest()
                self.showInitiateDownloadPage()
            }

            return
        }

        if networkReachability.wifiReachable {
            completeTutorial()
        } else {
            let allowDownloadMessage = string(for: .cellularDownloadAlertContinueOverCellularTitle)
            let allowDownloadOverCellular = AlertAction(title: allowDownloadMessage, action: completeTutorial)
            let cancel = AlertAction(title: string(for: .cancel))
            alertRouter.showAlert(title: string(for: .cellularDownloadAlertTitle),
                                  message: string(for: .cellularDownloadAlertMessage),
                                  actions: allowDownloadOverCellular, cancel)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        showInitiateDownloadPage()
        userAcknowledgedPushPermissionsRequest.markUserAsAcknowledgingPushPermissionsRequest()
    }

    // MARK: Private

    private func string(for scenario: PresentationScenario) -> String {
        return presentationStrings.presentationString(for: scenario)
    }

    private func showInitiateDownloadPage() {
        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(string(for: .tutorialInitialLoadTitle))
        tutorialPage.showPageDescription(string(for: .tutorialInitialLoadDescription))
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(string(for: .tutorialInitialLoadBeginDownload))
    }

    private func showRequestPushPermissionsPage() {
        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageTitle(string(for: .tutorialPushPermissionsRequestTitle))
        tutorialPage.showPageDescription(string(for: .tutorialPushPermissionsRequestDescription))
        tutorialPage.showPageImage(presentationAssets.requestPushNotificationPermissionsAsset)
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(string(for: .tutorialAllowPushPermissions))
        tutorialPage.showSecondaryActionButton()
        tutorialPage.showSecondaryActionDescription(string(for: .tutorialDenyPushPermissions))
    }

    private func completeTutorial() {
        _ = splashScreenRouter.showSplashScreen()
        tutorialStateProviding.markTutorialAsComplete()
    }

}
