//
//  CapturingCredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingCredentialStore: CredentialStore {
    
    init(persistedCredential: Credential? = nil) {
        self.persistedCredential = persistedCredential
    }
    
    private(set) var persistedCredential: Credential?
    
    private(set) var capturedCredential: Credential?
    var blockToRunBeforeCompletingCredentialStorage: (() -> Void)?
    func store(_ credential: Credential) {
        capturedCredential = credential
        blockToRunBeforeCompletingCredentialStorage?()
    }
    
    private(set) var didDeletePersistedToken = false
    func deletePersistedToken() {
        didDeletePersistedToken = true
    }
    
}
