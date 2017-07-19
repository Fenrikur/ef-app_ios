//
//  WhenLoggingIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggingIn: XCTestCase {
    
    private func makeSuccessfulLoginData(username: String = "",
                                         userID: String = "0",
                                         authToken: String = "",
                                         validUntil: String = "2017-07-17T19:45:22.666Z") -> Data {
        let payload = ["Username" : username,
                       "Uid": userID,
                       "Token" : authToken,
                       "TokenValidUntil": validUntil]
        return try! JSONSerialization.data(withJSONObject: payload, options: [])
    }
    
    func testTheLoginEndpointShouldReceievePOSTRequest() {
        let context = ApplicationTestBuilder().build()
        context.login()
        
        XCTAssertEqual("https://app.eurofurence.org/api/v2/Tokens/RegSys", context.jsonPoster.postedURL)
    }
    
    func testTheLoginEndpointShouldNotReceievePOSTRequestUntilCallingLogin() {
        let context = ApplicationTestBuilder().build()
        XCTAssertNil(context.jsonPoster.postedURL)
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithRegNo() {
        let context = ApplicationTestBuilder().build()
        let registrationNumber = 42
        context.login(registrationNumber: registrationNumber)
        
        XCTAssertEqual(registrationNumber, context.jsonPoster.postedJSONValue(forKey: "RegNo"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithUsername() {
        let context = ApplicationTestBuilder().build()
        let username = "Some awesome guy"
        context.login(username: username)
        
        XCTAssertEqual(username, context.jsonPoster.postedJSONValue(forKey: "Username"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithPassword() {
        let context = ApplicationTestBuilder().build()
        let password = "It's a secret"
        context.login(password: password)
        
        XCTAssertEqual(password, context.jsonPoster.postedJSONValue(forKey: "Password"))
    }
    
    func testLoginResponseReturnsNilDataShouldTellTheObserverLoginFailed() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.simulateJSONResponse(nil)
        
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.simulateJSONResponse(makeSuccessfulLoginData(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUserID() {
        let context = ApplicationTestBuilder().build()
        let expectedUserID = 42
        context.login(username: String(expectedUserID))
        context.simulateJSONResponse(makeSuccessfulLoginData(userID: String(expectedUserID)))
        
        XCTAssertEqual(expectedUserID, context.capturingLoginCredentialsStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(authToken: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginTokenExpiry() {
        let context = ApplicationTestBuilder().build()
        let expectedTokenExpiry = "2017-07-17T19:45:22.666Z"
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(validUntil: expectedTokenExpiry))
        
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 17, hour: 19, minute: 45, second: 22)
        let receievedDate = context.capturingLoginCredentialsStore.capturedCredential?.tokenExpiryDate
        var actualComponents: DateComponents?
        let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
        if let receievedDate = receievedDate {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
}
