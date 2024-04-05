//
//  Cell+.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
