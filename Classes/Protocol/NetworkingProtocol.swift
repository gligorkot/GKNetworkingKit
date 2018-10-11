//
//  NetworkingProtocol.swift
//  GKNetworkingKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Moya

protocol NetworkingProtocol {
    associatedtype API: TargetType, APIType

    var provider: MoyaProvider<API> { get }
}
