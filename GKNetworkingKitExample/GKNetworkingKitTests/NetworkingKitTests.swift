//
//  NetworkingKitTests.swift
//  GKNetworkingKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import XCTest
import Moya
import Nimble
@testable import GKBaseKit
@testable import GKNetworkingKit

class NetworkingKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        BaseKit.initBaseKit(debug: NotDebugConfig())
    }

    override func tearDown() {
        BaseKitConfiguration.tearDownConfig()
        super.tearDown()
    }

    func test_networkingKitDefaultNetworkingToNotHaveAnyPluginsWhenDebugIsFalse() {
        expect(Networking<API>.newNetworking().provider.plugins).to(beEmpty())
    }

}

final class API: TargetType, APIType {
    var baseURL: URL {
        return URL(string: "someUrl")!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }

    var authenticated: Bool {
        return true
    }
    
    var ignoreBaseURL: Bool {
        return false
    }
}

final class NotDebugConfig: DebugProtocol {
    var isDebug: Bool {
        return false
    }
}

