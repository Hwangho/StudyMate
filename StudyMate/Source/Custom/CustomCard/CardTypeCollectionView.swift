//
//  CardType.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/20.
//

import UIKit


enum CardType {
    case myInfo
    case searchStduy
}


final class CardTypeCollectionView {
    
    
    let type: CardType
    
    
    init(type: CardType) {
        self.type = type
    }
    
    
    /// Section, Item
    enum SearchStudySection: String, Hashable, CaseIterable {
        case title = "새싹 타이틀"
        case study = "하고 싶은 스터디"
        case review = "새싹 리뷰"
    }
    
    enum SearchStudyItem: Hashable {
        case titleItem(String)
        case studyItem(String)
        case reviewItem(String?)
    }
    
    enum myInfoSection: String, Hashable, CaseIterable {
        case title = "새싹 타이틀"
        case review = "새싹 리뷰"
        
    }
    
    enum myInfoStudyItem: Hashable {
        case titleItem(String)
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
    
    func layout() -> UICollectionViewLayout {
        
        switch type {
        case .myInfo:
            return UICollectionViewCompositionalLayout.init { sectionIndex, envieroment in
                switch myInfoSection.allCases[sectionIndex] {
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
            
        case .searchStduy:
            return UICollectionViewCompositionalLayout.init { sectionIndex, envieroment in
                switch SearchStudySection.allCases[sectionIndex] {
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
        }
        
        
        
    }
}
