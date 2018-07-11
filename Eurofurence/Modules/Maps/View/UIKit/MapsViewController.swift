//
//  MapsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, MapsScene {

    // MARK: Properties

    @IBOutlet weak var collectionView: UICollectionView!
    private var mapsController: MapsController? {
        didSet {
            collectionView.dataSource = mapsController
            collectionView.delegate = mapsController
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.mapsSceneDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: MapsScene

    private var delegate: MapsSceneDelegate?
    func setDelegate(_ delegate: MapsSceneDelegate) {
        self.delegate = delegate
    }

    func setMapsTitle(_ title: String) {
        super.title = title
    }

    func bind(numberOfMaps: Int, using binder: MapsBinder) {
        mapsController = MapsController(numberOfMaps: numberOfMaps,
                                        binder: binder,
                                        onDidSelectItemAtIndexPath: didSelectMap)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: Private

    private func didSelectMap(at indexPath: IndexPath) {
        delegate?.simulateSceneDidSelectMap(at: indexPath.item)
    }

    private class MapsController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let numberOfMaps: Int
        private let binder: MapsBinder
        private let onDidSelectItemAtIndexPath: (IndexPath) -> Void

        init(numberOfMaps: Int, binder: MapsBinder, onDidSelectItemAtIndexPath: @escaping (IndexPath) -> Void) {
            self.numberOfMaps = numberOfMaps
            self.binder = binder
            self.onDidSelectItemAtIndexPath = onDidSelectItemAtIndexPath
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfMaps
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(MapCollectionViewCell.self, for: indexPath)
            binder.bind(cell, at: indexPath.item)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: collectionViewWidth - 28, height: 196)
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            onDidSelectItemAtIndexPath(indexPath)
        }

    }

}
