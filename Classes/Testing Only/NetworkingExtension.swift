//
//  NetworkingExtension.swift
//  GKNetworkingKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Alamofire
import Moya

extension Networking {

    static func newSuccessfulResponseStubbedNetworking() -> Networking {
        return Networking(provider: MoyaProvider(endpointClosure: Networking.endpointClosure(), requestClosure: Networking.requestClosure(), stubClosure: MoyaProvider.immediatelyStub))
    }

    static func newCustomResponseStubbedNetworking(_ stubResponseClosure: @escaping Endpoint.SampleResponseClosure) -> Networking {
        return Networking(provider: MoyaProvider(endpointClosure: Networking.endpointClosure(stubResponseClosure), requestClosure: Networking.requestClosure(), stubClosure: MoyaProvider.immediatelyStub))
    }

    static func newCustomResponseForMappedRequestStubbedNetworking(_ stubPathSuffix: String, method: Moya.Method? = nil, stubResponseClosure: @escaping Endpoint.SampleResponseClosure) -> Networking {

        let endpointClosure: (API) -> Endpoint = { (target: API) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            if let method = method, target.method == method && url.hasSuffix(stubPathSuffix) {
                // return specific stub response if the stub path suffix is equal to the url suffix and the method is the desired method
                return Endpoint(url: url, sampleResponseClosure: stubResponseClosure, method: method, task: target.task, httpHeaderFields: target.headers)
            } else if method == nil && url.hasSuffix(stubPathSuffix) {
                // return specific stub response if the stub path suffix is equal to the url suffix
                return Endpoint(url: url, sampleResponseClosure: stubResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
            }
            // return 200 response with sample data for all other paths
            return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }

        return Networking(provider: MoyaProvider(endpointClosure: endpointClosure, requestClosure: Networking.requestClosure(), stubClosure: MoyaProvider.immediatelyStub))
    }

    static func newStubbedNetworkingWithCustomResponsesToMappedRequests(_ stubMap: [String : Endpoint.SampleResponseClosure]) -> Networking {

        let endpointClosure: (API) -> Endpoint = { (target: API) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            var needToStub = false
            var stubResponseClosure: Endpoint.SampleResponseClosure?
            for stubPathSuffix in stubMap.keys {
                if url.hasSuffix(stubPathSuffix) {
                    needToStub = true
                    stubResponseClosure = stubMap[stubPathSuffix]
                    break
                }
            }
            if needToStub, let stubResponseClosure = stubResponseClosure {
                // return specific stub response if the stub path suffix is equal to the url suffix
                return Endpoint(url: url, sampleResponseClosure: stubResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
            }
            // return 200 response with sample data for all other paths
            return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }

        return Networking(provider: MoyaProvider(endpointClosure: endpointClosure, requestClosure: Networking.requestClosure(), stubClosure: MoyaProvider.immediatelyStub))
    }

}
