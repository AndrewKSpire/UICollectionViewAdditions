//
//  CollectionViewDataSource.swift
//
//  Created by Andrew Kovalenko.
//  Copyright © 2018 Andrew Kovalenko. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionDataSource
{
    // Register a typealias
    associatedtype CollectionDataSourceItem
    // Items container
    var items: Array<CollectionDataSourceItem> {get}
    var multipleSections: Bool {get}
    
    // Number of objects for given section
    func numberOfObjectsForSection(section: NSInteger) -> Int
    
    // Object at given indexpath
    func objectAtIndexPath(indexPath: NSIndexPath) -> CollectionDataSourceItem
    
    // Number of sections
    func sectionsCount() -> Int
}

public extension CollectionDataSource
{
    // Default implementation
    
    public func objectAtIndexPath(indexPath:NSIndexPath) -> CollectionDataSourceItem {
        if self.multipleSections {
            if let sectionInfo = self.items[indexPath.section] as? DataSection {
                return sectionInfo.items[indexPath.row] as! Self.CollectionDataSourceItem
            }
        }
        return self.items[indexPath.row]
    }
    
    public func sectionsCount() -> Int {
        if !self.multipleSections {
            return 1
        }
        return self.items.count
    }
    
    func numberOfObjectsForSection(section:NSInteger) -> Int {
        if self.multipleSections {
            if let sectionInfo = self.items[section] as? DataSection {
                return sectionInfo.items.count
            }
        }
        return self.items.count
    }
}

public class CollectionViewDataSource <T, CellType:CellProtocol> : NSObject, CollectionDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    // Items container
    public private(set) var items:Array<T>
    public private(set) var multipleSections:Bool
    
    // Cell Setup
    public var cellSetupHandler: ((T, CellType, NSIndexPath) -> ())?
    public var cellSizeHandler: ((NSIndexPath) -> CGSize)?
    public let collectionView: UICollectionView
    
    //MARK: - Initializer
    
    public init(itemsArray:[T], collectionView:UICollectionView, multipleSections: Bool) {
        //Default values
        self.collectionView = collectionView
        self.items = itemsArray
        self.multipleSections = multipleSections
        
        super.init()
        self.collectionView.dataSource = self;
    }
    
    //MARK: - UICollectionViewDataSource
    
    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let handler = cellSizeHandler {
            return handler(indexPath as NSIndexPath)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.itemSize
        }
        return CGSize.zero
    }
    
    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionsCount()
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfObjectsForSection(section: section)
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellClass = CellType.cellIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClass, for: indexPath)
        let model = self.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        
        /* Setup the cell */
        if let cellSetupHandler = cellSetupHandler {
            cellSetupHandler(model, cell as! CellType, indexPath as NSIndexPath)
        }
        
        return cell
    }
}
