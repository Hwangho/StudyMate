//
//  ChangeMyPageViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


final class ChangeMyPageViewController: BaseViewController {
    
    /// UI
    private lazy var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    
    /// Property
    var datasource: DataSource!
    
    var coordinator: ChangeMyPageCoordinator?
    
    var viewModel: ChangeMyPageViewModel
    
    
    /// initialization
    init(viewmodel: ChangeMyPageViewModel = ChangeMyPageViewModel()) {
        self.viewModel = viewmodel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        
        collectionview.delegate = self
//        setupGestureRecognizer()    /// TextField KeyBoard 내리기
    }
    
    override func setupLayout() {
        view.addSubview(collectionview)
        collectionview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {

    }
    
    override func setData() {
        setDataSource()
    }
    
}


// MARK: - Diffable CollectionView
extension ChangeMyPageViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CardCellRegister = UICollectionView.CellRegistration<CardCollectionViewCell, Item>
    
    typealias MyInfoCeollRegister = UICollectionView.CellRegistration<MyInfoCollectionViewCell, Item>
    
    typealias HeaderViewRegister = UICollectionView.SupplementaryRegistration<CardCollectionViewHeaderView>
    
    
    /// Section Item
    enum Section: CaseIterable, Hashable {
        case first
    }
    
    enum Item: CaseIterable, Hashable {
        case myCard
        case myInfo
    }
    
 
    /// Set CollectionView
    func setDataSource() {
        let cardCell = CardCellRegister.init { cell, indexPath, itemIdentifier in
            self.addChild(cell.cardInfoViewcontroller)
        }
        
        let myinfoCell = MyInfoCeollRegister { cell, indexPath, itemIdentifier in
            print("ddd")
        }
        
        let headerView = HeaderViewRegister.init(elementKind: "CardHeader") { supplementaryView, elementKind, indexPath in
            supplementaryView.configure()
        }
        
        datasource = DataSource.init(collectionView: collectionview, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .myCard:
                 return collectionView.dequeueConfiguredReusableCell(using: cardCell, for: indexPath, item: itemIdentifier)
                
            case .myInfo:
                return collectionView.dequeueConfiguredReusableCell(using: myinfoCell, for: indexPath, item: itemIdentifier)
            }
        })
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerView, for: indexPath)
        }

        datasource.apply(snapshot())
    }
    
    func snapshot() -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(Item.allCases)
        
        return snapshot
    }
    
    private func layout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch Section.allCases[sectionIndex] {
            case .first:
                
                let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(45))
                let item = NSCollectionLayoutItem(layoutSize: itemsize)
                
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(45))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupsize, subitems: [item])
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(194))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: "CardHeader", alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
    }
    
}


extension ChangeMyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            // Allows for closing an already open cell
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                collectionView.deselectItem(at: indexPath, animated: true)
            } else {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            datasource.refresh()
        }

        return false
    }
}
