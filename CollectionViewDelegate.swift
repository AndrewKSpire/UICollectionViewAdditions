//
//  CollectionViewDelegate.swift
//
//  Created by Andrew Kovalenko.
//  Copyright © 2018 Andrew Kovalenko. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionDelegate
{
    // Register a typealias
    associatedtype CollectionDelegateItem
    
    // Items container
    var items: Array<CollectionDelegateItem> {get}
    var multipleSections: Bool {get}
    
    // Object at given indexpath
    func objectAtIndexPath(indexPath: NSIndexPath) -> CollectionDelegateItem
}

public extension CollectionDelegate
{
    // Default implementation
    
    public func objectAtIndexPath(indexPath:NSIndexPath) -> CollectionDelegateItem {
        if self.multipleSections {
            if let sectionInfo = self.items[indexPath.section] as? DataSection, let item = sectionInfo.items[indexPath.row] as? CollectionDelegateItem {
                return item
            }
        }
        return self.items[indexPath.row]
    }
}

public class CollectionViewDelegate <T> : NSObject, CollectionDelegate, UICollectionViewDelegate
{
    // Items container
    public private(set) var items:Array<T>
    public private(set) var multipleSections:Bool
    
    // Cell Setup
    public var cellSelectionHandler: ((T, NSIndexPath) -> ())?
    public let collectionView:UICollectionView
    
    //MARK: - Initializer
    
    public init(itemsArray:[T], collectionView:UICollectionView, multipleSections: Bool) {
        //Default values
        self.collectionView = collectionView
        self.items = itemsArray
        self.multipleSections = multipleSections
        
        super.init()
        self.collectionView.delegate = self;
    }
    
    //MARK: - UICollectionViewDelegate
    
    @objc public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.objectAtIndexPath(indexPath: indexPath as NSIndexPath)
        if let cellSelectionHandler = cellSelectionHandler {
            cellSelectionHandler(model, indexPath as NSIndexPath)
        }
    }
}
