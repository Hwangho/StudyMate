//
//  ResponseStudyViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/30.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class ResponseStudyViewController: BaseViewController {
    
    /// UI
    private lazy var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let emptyView = EmptyView()
    
    
    /// Property
    var datasource: DataSource!
    
    var viewModel: LookupStudyViewModel
    
    weak var coordinator: LookupStudyCoordinator?
    
    var customAlertViewController = CustomAlertViewController()
    
    
    /// initialization
    init(viewModel: LookupStudyViewModel, coordinator: LookupStudyCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init()
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        collectionview.contentInset.top = 20
        collectionview.delegate = self
        collectionview.allowsMultipleSelection = true
        collectionview.showsVerticalScrollIndicator = false

        customAlertViewController.delegate = self
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
        viewModel.action.accept(.searchSesac)
    }
    
    override func setupBinding() {
        /// Action
        emptyView.changeStudyButton.rx.tap
            .bind {[weak self] in
                self?.coordinator?.popLookupStudy()
            }
            .disposed(by: disposeBag)
        
        emptyView.refreshButton.rx.tap
            .bind { [weak self] in
                let lat: Double? = LocalUserDefaults.shared.value(key: .lat)
                let lng: Double? = LocalUserDefaults.shared.value(key: .lng)
                self?.viewModel.action.accept(.searchSesac)
            }
            .disposed(by: disposeBag)
        
        /// State
        viewModel.currentStore
            .distinctUntilChanged{ $0.queue }
            .map{ $0.queue }
            .bind {[weak self] value in
                guard let value else { return }
                if value.fromQueueDBRequested.isEmpty {
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

extension ResponseStudyViewController {
    
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
            
            guard let queueUser = self?.viewModel.store.queue?.fromQueueDBRequested else { return }
            supplementaryView.headerDelegate = self
            supplementaryView.configure(queueUser: queueUser[indexPath.section], type: .response)
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
        
        data.fromQueueDBRequested.forEach { data in
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


extension ResponseStudyViewController: UICollectionViewDelegate {
    
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


extension ResponseStudyViewController: HeaderButtonDelegate, CustomAlertActionProtocool {

    func tapStudyButton(type: CardCollectionViewHeaderView.buttonType, uuid: String?) {
        
        switch type {
        case .request:
            customAlertViewController.configure(alertTitleText: "스터디를 수락할까요?", alertContentText: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요")
            customAlertViewController.modalPresentationStyle = .overFullScreen
            coordinator?.presenter.present(customAlertViewController, animated: true)
            
            viewModel.action.accept(.saveUID(uuid))
        default:
            break
        }
    }
    
    func tapCancel() {
        coordinator?.presenter.dismiss(animated: true)
    }
    
    func tapConfirm() {
        viewModel.action.accept(.studyaccept)
    }
    
}
