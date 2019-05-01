//
//  CoinViewModel.swift
//  Coinbase Icons
//
//  Created by Paulo Fierro on 30/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import Kanna
import UIKit

/// Generic Network Error
enum NetworkError: Error {
    case somethingWentWrong(message: String)
}

/// The data structure for each bike stand
struct Coin {
    let symbol: String
    let name: String
    let iconURL: String
}

/// Handles fetching coin data
class CoinViewModel {

    /// Our list of downloaded coins
    private(set) var coins = [Coin]()

    /// Loads the coin data
    /// - Parameter completion: Returns an array of Coin objects, or an error
    func fetchData(_ completion: @escaping (Result<[Coin]?, NetworkError>) -> Void) {

        // TODO: We should use Reachability to figure out if we're offline

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = Constants.API_URL
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { [weak self] data, _, _ in

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            // Check for issues
            guard let data = data else {
                completion(.failure(.somethingWentWrong(message: "Received invalid data from \(url.absoluteString)")))
                return
            }
            guard let coins = self?.parseHTML(data) else {
                completion(.failure(.somethingWentWrong(message: "Could not parse HTML")))
                return
            }

            // All good! Return the data
            self?.coins = coins
            completion(.success(coins))
        }
        task.resume()
    }

    /// Converts that delicious XML into something we can use
    private func parseHTML(_ data: Data) -> [Coin]? {
        guard let doc = try? HTML(html: data, encoding: .utf8) else {
            return nil
        }

        var coins = [Coin]()

        // Loop through each row, ignoring those that don't match the CSS class we're interested in
        for row in doc.xpath("//tr") where row.className?.contains("AssetRow__Wrapper") ?? false {

            // The second column contains the info we want
            let column = row.xpath("td")[1]

            if  // Get the src attribute of the <img>
                let iconURL = column.css("img").first?["src"],
                // Get the name of the coin, nested in an <h4> deep down
                let name = column.xpath("a/div/div/span/h4").first?.text,
                // Get the name of the symbol, also nested in an <h4>
                let symbol = column.xpath("a/div/div/h4").first?.text {

                // Create the coin with this data
                let coin = Coin(symbol: symbol, name: name, iconURL: iconURL)
                coins.append(coin)
            }
        }
        return coins
    }
}
