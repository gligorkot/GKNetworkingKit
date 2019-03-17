//
//  Networking.swift
//  GKNetworkingKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Moya
import GKBaseKit

public struct Networking<API: TargetType & APIType>: NetworkingProtocol {
    public let provider: MoyaProvider<API>
}

// MARK: - static methods
public extension Networking {

    public static func newNetworking() -> Networking {
        return Networking(provider: newProvider(plugins))
    }

}

extension Networking {

    static var plugins: [PluginType] {
        if BaseKit.isDebug() {
            return [NetworkLoggerPlugin(verbose: true)]
        }
        return []
    }

    static func newProvider<T>(_ plugins: [PluginType]) -> MoyaProvider<T> where T: APIType {
        return MoyaProvider(endpointClosure: Networking.endpointClosure(),
                            requestClosure: Networking.requestClosure(),
                            plugins: plugins)
    }

    static func endpointClosure<T>(_ stubResponseClosure: (() -> EndpointSampleResponse)? = nil) -> (T) -> Endpoint where T: TargetType, T: APIType {
        let endpointClosure = { (target: T) -> Endpoint in
            var endpoint = Networking.endpoint(target, stubResponseClosure: stubResponseClosure ?? {.networkResponse(200, target.sampleData)}, httpHeaderFields: target.headers)

            if let headers = target.headers {
                // sign all authenticated requests
                endpoint = endpoint.adding(newHTTPHeaderFields: headers)
                return endpoint
            }
            // unsigned requests
            return endpoint
        }

        return endpointClosure
    }

    static func requestClosure() -> MoyaProvider<API>.RequestClosure {
        return { (endpoint, closure) in
            var request = try! endpoint.urlRequest()
            request.httpShouldHandleCookies = false
            closure(.success(request))
        }
    }

    private static func endpoint<T>(_ target: T, stubResponseClosure: @escaping () -> EndpointSampleResponse, httpHeaderFields: [String : String]?) -> Endpoint where T: TargetType, T: APIType {
        let url: String
        if target.ignoreBaseURL {
            url = target.path
        } else {
            url = target.baseURL.appendingPathComponent(target.path).absoluteString
        }
        return Endpoint(url: url, sampleResponseClosure: stubResponseClosure, method: target.method, task: target.task, httpHeaderFields: httpHeaderFields)
    }

}
