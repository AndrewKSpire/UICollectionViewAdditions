//
//  ExampleViewController.swift
//
//  Created by Andrew Kovalenko.
//  Copyright © 2018 Andrew Kovalenko. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    private enum Constants {
        static let CellWidthHeightCoefficient: CGFloat = 7/9
        static let CellItemsDistance: CGFloat = 30.0
        static let ItemsPerRow: CGFloat = 3
    }
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var collectionDataSource: CollectionViewDataSource<Any, ExampleCollectionViewCell>?
    private var collectionDelegate: CollectionViewDelegate<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        
        let items: [[String:Any]] = []
        
        // Configure UICollectionViewFlowLayout
        if let collectionFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let cellWidth: CGFloat = CGFloat(Int((UIScreen.main.bounds.size.width-collectionView.frame.origin.x*2 - Constants.CellItemsDistance*(Constants.ItemsPerRow+1))/Constants.ItemsPerRow))
            let itemSize = CGSize(width: cellWidth, height: CGFloat(ceilf(Float(cellWidth/Constants.CellWidthHeightCoefficient))))
            collectionFlowLayout.itemSize = itemSize
            collectionFlowLayout.sectionInset = UIEdgeInsetsMake(Constants.CellItemsDistance, Constants.CellItemsDistance, Constants.CellItemsDistance, Constants.CellItemsDistance)
            collectionView.collectionViewLayout = collectionFlowLayout
        }
        
        collectionDataSource = CollectionViewDataSource<Any, ExampleCollectionViewCell>(itemsArray: items, collectionView: collectionView, multipleSections: false)
        collectionDataSource?.cellSetupHandler = { (item, inputCell, indexPath) in
            if let inputItem = item as? [String:Any] {
                inputCell.updateCell(with: inputItem)
            }
        }
        
        collectionDelegate = CollectionViewDelegate<Any>(itemsArray: items, collectionView: collectionView, multipleSections: false)
        collectionDelegate?.cellSelectionHandler = { (item, indexPath) in
            if let _ = item as? [String:Any] {
                // Do required logic
            }
        }
    }
}
