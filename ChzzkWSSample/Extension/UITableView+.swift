//
//  UITableView+.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/5/24.
//

import UIKit

extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let section = self.numberOfSections
            let row = self.numberOfRows(inSection: section - 1)
            
            guard section > 0 else { return }
            guard row > 0 else {
                return
            }
            
            let indexPath = IndexPath(
                row: row - 1,
                section: section - 1
            )
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                UIView.performWithoutAnimation {
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
}

extension UITextView {
    var numberOfLines: Int {
        guard compare(beginningOfDocument, to: endOfDocument).same == false else {
            return 0
        }
        let direction: UITextDirection = UITextDirection(rawValue: UITextStorageDirection.forward.rawValue)
        var lineBeginning = beginningOfDocument
        var lines = 0
        while true {
            lines += 1
            guard let lineEnd = tokenizer.position(from: lineBeginning, toBoundary: .line, inDirection: direction) else {
                fatalError()
            }
            guard compare(lineEnd, to: endOfDocument).same == false else {
                break
            }
            guard let newLineBeginning = tokenizer.position(from: lineEnd, toBoundary: .character, inDirection: direction) else {
                fatalError()
            }
            guard compare(newLineBeginning, to: endOfDocument).same == false else {
                return lines + 1
            }
            lineBeginning = newLineBeginning
        }
        return lines
    }
}

extension ComparisonResult {
    public var ascending: Bool {
        switch self {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }

    public var descending: Bool {
        switch self {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }

    public var same: Bool {
        switch self {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
