//
//  ExampleCollectionViewCell.swift
//
//  Created by Andrew Kovalenko.
//  Copyright © 2018 Andrew Kovalenko. All rights reserved.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell, CellProtocol {
    
    func updateCell(with item: [String:Any]) {
        // Update content of the cell
    }
    
    //MARK: - CellProtocol
    
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
