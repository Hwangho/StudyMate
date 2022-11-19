//
//  UICollectionViewDiffableDataSource+Extension.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit


extension UICollectionViewDiffableDataSource {
    /// Reapplies the current snapshot to the data source, animating the differences.
    /// - Parameters:
    ///   - completion: A closure to be called on completion of reapplying the snapshot.
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}

