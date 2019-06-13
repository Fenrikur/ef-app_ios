import Foundation

public struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    public init() {
    }

    public func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: makeGameURL(token: "empty"))
    }

    public func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        return URLRequest(url: makeGameURL(token: credential.authenticationToken))
    }

    private func makeGameURL(token: String) -> URL {
        let urlString = "https://app.eurofurence.org/collectemall/#token-\(token)/true"
        guard let url = URL(string: urlString) else {
            fatalError("Error marshalling token into url: \(urlString)")
        }
        
        return url
    }

}