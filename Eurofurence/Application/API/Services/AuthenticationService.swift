//
//  AuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public protocol AuthenticationService {

    func add(_ observer: AuthenticationStateObserver)
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)
    func logout(completionHandler: @escaping (LogoutResult) -> Void)

}

public enum LoginResult {
    case success(User)
    case failure
}

public protocol AuthenticationStateObserver {

    func userDidLogin(_ user: User)
    func userDidLogout()

}
