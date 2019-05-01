//
//  Constants.swift
//  Coinbase Icons
//
//  Created by Paulo Fierro on 30/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import Foundation

struct Constants {
    /// The number of seconds the app will wait before considering a request as timed out
    static let networkRequestTimeout: TimeInterval = 30.0

    /// Our data source
    static let API_URL = URL(string: "https://www.coinbase.com/price")!
}
