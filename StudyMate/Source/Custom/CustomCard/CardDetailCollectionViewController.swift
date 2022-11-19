//
//  CardDetailCollectionViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit


final class CardDetailCollectionViewController: UICollectionViewController {
    
    /// Properties
    var datasource: DataSource!
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let padding: CGFloat = 16
    
    let studyList = ["aaa", "Anything", "아무아무아무아무거나아무아무아무아무거나"]
    
    let reviewList: [String] = ["아무아무아무아무거나아무아무아무아무거나"]
    
    
    /// initialization
    init() {
        let layout =  UICollectionViewCompositionalLayout.init { sectionIndex, envieroment in
            switch Section.allCases[sectionIndex] {
            case .title:
                let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(40))
                let item1 = NSCollectionLayoutItem(layoutSize: itemsize)
                let item2 = NSCollectionLayoutItem(layoutSize: itemsize)
                item1.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4)
                item2.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0)
                
                let horizontalgroupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
                let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalgroupsize, subitems: [item1, item2])
                
                let verticalgroupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
                let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalgroupsize, subitems: [horizontalgroup])
                
                let section = NSCollectionLayoutSection(group: verticalgroup)
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: "header", alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
                
            case .study:
                let itemsize = NSCollectionLayoutSize(widthDimension: .estimated(32), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemsize)
                
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
                let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitems: [item])
                horizontalgroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
                
                let section = NSCollectionLayoutSection(group: horizontalgroup)
                section.interGroupSpacing = 8
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: "header", alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
                
            case .review:
                let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
                let item = NSCollectionLayoutItem(layoutSize: itemsize)
                
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitems: [item])
                
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: "header", alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Lfie Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 50)
        collectionViewHeightConstraint.isActive = true
        
        collectionView.isScrollEnabled = false
        setDatasource()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionViewLayout.collectionViewContentSize.height
    }
    
}


// MARK: - Dffable Collectionview
extension CardDetailCollectionViewController {
    
    /// Section, Item
    enum Section: String, Hashable, CaseIterable {
        case title = "새싹 타이틀"
        case study = "하고 싶은 스터디"
        case review = "새싹 리뷰"
    }
    
    enum Item: Hashable {
        case titleItem(String)
        case studyItem(String)
        case reviewItem(String?)
    }
    
    
    enum ItemTitle: String, Hashable, CaseIterable {
        case manner = "좋은 매너"
        case time = "정확한 시간 약속"
        case response = "빠른 응답"
        case kindness = "친절한 성격"
        case skill = "능숙한 실력"
        case beneficial = "유익한 시간"
    }
    
    
    /// typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CardReputationCellRegister = UICollectionView.CellRegistration<CardReputationCollectionViewCell, String>
    
    typealias CardReviewCellRegister = UICollectionView.CellRegistration<CardReviewCollectionViewCell, String>
    
    typealias CardDetailHeaderViewRegister = UICollectionView.SupplementaryRegistration<CardDetalCollectionViewHeaderView>
    
    
    /// Datasource
    private func setDatasource() {
        let cardReputationCellRegister = CardReputationCellRegister { cell, indexPath, itemIdentifier in
            switch Section.allCases[indexPath.section] {
            case .title:
                cell.studyConfigure(title: itemIdentifier, count: Int.random(in: (0...1)))
            case .study:
                cell.titleConfigure(title: itemIdentifier)
            default: break
            }
        }
        
        let cardReviewCellRegister = CardReviewCellRegister { cell, indexPath, itemIdentifier in
            cell.configure(review: itemIdentifier)
        }
        
        let cardDetailHeaderViewRegister = CardDetailHeaderViewRegister.init(elementKind: "header") { supplementaryView, elementKind, indexPath in
            supplementaryView.configure(type: Section.allCases[indexPath.section])
        }
        
        
        datasource = DataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .titleItem(let value):
                return collectionView.dequeueConfiguredReusableCell(using: cardReputationCellRegister, for: indexPath, item: value)
                
            case .studyItem(let value):
                return collectionView.dequeueConfiguredReusableCell(using: cardReputationCellRegister, for: indexPath, item: value)
                
            case .reviewItem(let value):
                return collectionView.dequeueConfiguredReusableCell(using: cardReviewCellRegister, for: indexPath, item: value)
            }
        })
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: cardDetailHeaderViewRegister, for: indexPath)
        }
        
        datasource.apply(snapshot())
    }
    
    private func snapshot() -> SnapShot {
        var snapshot = SnapShot()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(ItemTitle.allCases.map{ Item.titleItem($0.rawValue) }, toSection: .title)
        snapshot.appendItems(studyList.map{Item.studyItem($0) }, toSection: .study)
        snapshot.appendItems([Item.reviewItem(reviewList.first ?? "")], toSection: .review)
        
        return snapshot
    }

}

