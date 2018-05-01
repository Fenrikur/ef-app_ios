//
//  WhenResolvingDataStoreState.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEurofurenceDataStore: EurofurenceDataStore {
    
    private(set) var capturedResolveContentsStateHandler: ((EurofurenceDataStoreContentsState) -> Void)?
    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
        capturedResolveContentsStateHandler = completionHandler
    }
    
    var stubbedKnowledgeGroups: [KnowledgeGroup2]?
    func fetchKnowledgeGroups(completionHandler: ([KnowledgeGroup2]?) -> Void) {
        completionHandler(stubbedKnowledgeGroups)
    }
    
    private(set) var capturedKnowledgeGroupsToSave: [KnowledgeGroup2]?
    private(set) var transaction: CapturingEurofurenceDataStoreTransaction?
    var transactionInvokedBlock: (() -> Void)?
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        let transaction = CapturingEurofurenceDataStoreTransaction()
        block(transaction)
        self.transaction = transaction
        transactionInvokedBlock?()
    }
    
}

extension CapturingEurofurenceDataStore {
    
    func didSave(_ knowledgeGroups: [KnowledgeGroup2]) -> Bool {
        guard let persistedKnowledgeGroups = transaction?.persistedKnowledgeGroups else { return false }
        return persistedKnowledgeGroups.contains(elementsFrom: knowledgeGroups)
    }
    
    func didSave(_ announcements: [Announcement2]) -> Bool {
        guard let persistedAnnouncements = transaction?.persistedAnnouncements else { return false }
        return persistedAnnouncements.contains(elementsFrom: announcements)
    }
    
}

extension Array where Element: Equatable {
    
    func contains(elementsFrom other: Array<Element>) -> Bool {
        for item in other {
            if contains(item) == false {
                return false
            }
        }
        
        return true
    }
    
}

class CapturingEurofurenceDataStoreTransaction: EurofurenceDataStoreTransaction {
    
    private(set) var persistedKnowledgeGroups: [KnowledgeGroup2] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [KnowledgeGroup2]) {
        self.persistedKnowledgeGroups = knowledgeGroups
    }
    
    private(set) var persistedAnnouncements: [Announcement2] = []
    func saveAnnouncements(_ announcements: [Announcement2]) {
        persistedAnnouncements = announcements
    }
    
}

class StubUserPreferences: UserPreferences {
    
    var refreshStoreOnLaunch = false
    
}

class WhenResolvingDataStoreState: XCTestCase {
    
    func testEmptyStateStoreProvidesAbsentStore() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserRequestedRefreshOnLaunchReturnsStale() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.stale, state)
    }
    
    func testEmptyDataStoreWhenUserRequestedRefreshOnLaunchReturnsAbsent() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserDidNotRequestRefreshOnLaunchReturnsAvailable() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.available, state)
    }
    
    func testResolutionHandlerNotInvokedBeforeDataStoreResolvesContentsState() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertNil(state)
    }
    
}
