import Foundation
import Result

/// A Moya Plugin receives callbacks to perform side effects wherever a request is sent or received.
///
/// for example, a plugin may be used to
///     - log network requests
///     - hide and show a network activity indicator
///     - inject additional information into a request
public protocol PluginType {
    /// Called to modify a request before sending
    func prepareRequest(_ request: URLRequest, target: TargetType) -> URLRequest

    /// Called immediately before a request is sent over the network (or stubbed).
    func willSendRequest(_ request: RequestType, target: TargetType)

    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceiveResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType)

    /// Called to modify a result before completion
    func processResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType) -> Result<Moya.Response, Moya.Error>
}

public extension PluginType {
    func prepareRequest(_ request: URLRequest, target: TargetType) -> URLRequest { return request }
    func willSendRequest(_ request: RequestType, target: TargetType) { }
    func didReceiveResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType) { }
    func processResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType) -> Result<Moya.Response, Moya.Error> { return result }
}

/// Request type used by `willSendRequest` plugin function.
public protocol RequestType {

    // Note:
    //
    // We use this protocol instead of the Alamofire request to avoid leaking that abstraction.
    // A plugin should not know about Alamofire at all.

    /// Retrieve an `NSURLRequest` representation.
    var request: URLRequest? { get }

    /// Authenticates the request with a username and password.
    func authenticate(user: String, password: String, persistence: URLCredential.Persistence) -> Self

    /// Authenticates the request with an `NSURLCredential` instance.
    func authenticate(usingCredential credential: URLCredential) -> Self
}
