//
//  API.swift
//  GKNetworkingKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

public protocol APIType {
    var authenticated: Bool { get }
    var ignoreBaseURL: Bool { get }
}

// used for sample data responses in Target objects
public func stubbedResponse(_ filename: String, bundle: Bundle) -> Data! {
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
