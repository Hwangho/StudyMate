//
//  ArroundStudyViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/30.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


final class ArroundStudyViewController: BaseViewController {
    
    /// UI
    private lazy var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let emptyView = EmptyView()
    
    
    /// Property
    var datasource: DataSource!
    
    var viewModel: LookupStudyViewModel
    
    
    /// initialization
    init(viewModel: LookupStudyViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        collectionview.contentInset.top = 20
        collectionview.delegate = self
        collectionview.allowsMultipleSelection = true
        collectionview.showsVerticalScrollIndicator = false
        
        setDataSource()
    }
    
    override func setupLayout() {
        [emptyView, collectionview].forEach {
            view.addSubview($0)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setData() {
        let lat: Double? = LocalUserDefaults.shared.value(key: .lat)
        let lng: Double? = LocalUserDefaults.shared.value(key: .lng)
        viewModel.action.accept(.searchSesac(lat!, lng!))
    }
    
    override func setupBinding() {
        
        /// State
        viewModel.currentStore
            .distinctUntilChanged{ $0.queue }
            .map{ $0.queue }
            .bind {[weak self] value in
                guard let value else { return }
                if value.fromQueueDB.isEmpty {
                    self?.collectionview.isHidden = true
                    self?.emptyView.isHidden = false
                }else {
                    self?.collectionview.isHidden = false
                    self?.emptyView.isHidden = true
                }
                self?.snapshotApply()
            }
            .disposed(by: disposeBag)
    }
        
}

extension ArroundStudyViewController {
    
    /// typealiase
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CardCellRegister = UICollectionView.CellRegistration<SearchStudyCardCollectionViewCell, Item>
    
    typealias HeaderViewRegister = UICollectionView.SupplementaryRegistration<CardCollectionViewHeaderView>
    
    
    /// Section Item
    enum Section: Hashable {
        case first(QueueUser)
    }
    
    enum Item: Hashable {
        case myCard(QueueUser)
    }
        
    /// Set CollectionView
    func setDataSource() {

        let cardCell = CardCellRegister.init { [weak self] cell, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .myCard(let queueUser):
                
                cell.cardInfoViewcontroller.viewmodel.action.accept(.sendUserData(queueUser))
                cell.configure(queueUser: queueUser)
            
                self?.addChild(cell.cardInfoViewcontroller)
            }
        }
        
        let headerView = HeaderViewRegister.init(elementKind: "CardHeader") { [weak self] supplementaryView, elementKind, indexPath in
            guard let queueUser = self?.viewModel.store.queue?.fromQueueDB else { return }
            supplementaryView.configure(queueUser: queueUser[indexPath.section])
        }
        
        datasource = DataSource.init(collectionView: collectionview, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cardCell, for: indexPath, item: itemIdentifier)
        })
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerView, for: indexPath)
        }

    }
    
    func snapshotApply() {
        var snapshot = SnapShot()
        
        guard let data = viewModel.store.queue else { return }
        
        data.fromQueueDB.forEach { data in
            let section = Section.first(data)
            snapshot.appendSections([section])
            snapshot.appendItems([Item.myCard(data)], toSection: section)
        }
        
        datasource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
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


extension ArroundStudyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        datasource.refresh()
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        datasource.refresh()
        
        return false
    }
}










