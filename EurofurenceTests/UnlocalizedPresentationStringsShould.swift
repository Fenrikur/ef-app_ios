//
//  UnlocalizedPresentationStringsShould.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UnlocalizedPresentationStringsShould: XCTestCase {

    private func string(for scenario: PresentationScenario) -> String {
        return UnlocalizedPresentationStrings()[scenario]
    }

    func testProvideAppropriateStringForCancel() {
        let expected = "Cancel"
        XCTAssertEqual(expected, string(for: .cancel))
    }
    
    func testProvideAppropriateStringForTutorialRequestPushPermissionsTitle() {
        let expected = "Push Notifications"
        XCTAssertEqual(expected, string(for: .tutorialPushPermissionsRequestTitle))
    }

    func testProvideAppropriateStringForTutorialPushPermissionsRequestDescription() {
        let expected = "To keep you up-to-date with changes to the event schedule and other important announcements, the app requires your permission to display notifications on your device."
        XCTAssertEqual(expected, string(for: .tutorialPushPermissionsRequestDescription))
    }

    func testProvideAppropriateStringForTutorialAllowNotificationsDescription() {
        let expected = "Allow Notifications"
        XCTAssertEqual(expected, string(for: .tutorialAllowPushPermissions))
    }

    func testProvideAppropriateStringForTutorialDenyNotificationsDescription() {
        let expected = "No Thanks"
        XCTAssertEqual(expected, string(for: .tutorialDenyPushPermissions))
    }
    
    func testProvideAppropriateStringForTutorialInitialLoadTitle() {
        let expected = "Offline Usage"
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadTitle))
    }

    func testProvideAppropriateStringForTutorialInitialLoadDescription() {
        let expected = "The Eurofurence app is intended to remain fully functional while offline. To do this, we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection."
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadDescription))
    }

    func testProvideAppropriateStringForTutorialInitialDownloadBeginDownload() {
        let expected = "Begin Download"
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadBeginDownload))
    }

    func testProvideAppropriateStringForCellularDownloadAlertTitle() {
        let expected = "Use Cellular Data?"
        XCTAssertEqual(expected, string(for: .cellularDownloadAlertTitle))
    }

    func testProvideAppropriateStringForCellularDownloadAlertMessage() {
        let expected = "Proceeding with the initial download will consume several megabytes of data."
        XCTAssertEqual(expected, string(for: .cellularDownloadAlertMessage))
    }

    func testProviderAppropriateStringForCellularDownloadAlertContinueOverCellularTitle() {
        let expected = "Continue Over Cellular"
        XCTAssertEqual(expected, string(for: .cellularDownloadAlertContinueOverCellularTitle))
    }
    
}
