//
//  CoinViewController.swift
//  Coinbase Icons
//
//  Created by Paulo Fierro on 30/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let viewModel = CoinViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    private func loadData() {
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }

            case .failure(let error):
                // TODO: Handle error
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

extension CoinViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.coins.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.identifier,
                                                            for: indexPath) as? CoinCollectionViewCell else {
            fatalError("Could not dequeue cell")
        }
        cell.coin = viewModel.coins[indexPath.item]
        return cell
    }
}
