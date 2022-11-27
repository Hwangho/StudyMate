//
//  CardDetailCollectionViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/19.
//

import UIKit

import SnapKit
import RxSwift




final class CardDetailCollectionViewController: UICollectionViewController {
    
    /// Properties
    var myinfoDatasource: MyinfoDataSource!
    
    var searchDatasource: SearchStudyDataSource!
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let padding: CGFloat = 16
    
    let studyList = ["aaa", "Anything", "아무아무아무아무거나아무아무아무아무거나"]
    
    let reviewList: [String] = ["아무아무아무아무거나아무아무아무아무거나"]
    
    let viewmodel = CardDetailCollectionViewModel()
    
    let disposeBag = DisposeBag()
    
    let type: CardType
    
    var coordinator: ChangeMyPageCoordinator?
    
    
    /// initialization
    init(type: CardType) {
        self.type = type
        super.init(collectionViewLayout: CardTypeCollectionView(type: type).layout() )
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
        setupBinding()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionViewLayout.collectionViewContentSize.height
    }
    
    
    func setupBinding() {
        viewmodel.currentStore
            .map { $0.user }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                guard let `self` = self else { return }
                
                switch self.type {
                case .myInfo:
                    self.myinfoDatasource.apply(self.myinfoSnapShot())
                case .searchStduy:
                    self.searchDatasource.apply(self.searchStudySnapShot())
                }
                
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - Dffable Collectionview
extension CardDetailCollectionViewController {

    
    /// typealias
    typealias SearchStudyDataSource = UICollectionViewDiffableDataSource<CardTypeCollectionView.SearchStudySection, CardTypeCollectionView.SearchStudyItem>
    
    typealias SearchStudySnapShot = NSDiffableDataSourceSnapshot<CardTypeCollectionView.SearchStudySection, CardTypeCollectionView.SearchStudyItem>
    
    typealias MyinfoDataSource = UICollectionViewDiffableDataSource<CardTypeCollectionView.myInfoSection, CardTypeCollectionView.myInfoStudyItem>
    
    typealias MyinfoSnapShot = NSDiffableDataSourceSnapshot<CardTypeCollectionView.myInfoSection, CardTypeCollectionView.myInfoStudyItem>
    
    typealias CardReputationCellRegister = UICollectionView.CellRegistration<CardReputationCollectionViewCell, String>
    
    typealias CardReviewCellRegister = UICollectionView.CellRegistration<CardReviewCollectionViewCell, String>
    
    typealias CardDetailHeaderViewRegister = UICollectionView.SupplementaryRegistration<CardDetalCollectionViewHeaderView>
    
    
    /// Datasource
    private func setDatasource() {
        
        switch type {
        case .myInfo:
            let cardReputationCellRegister = CardReputationCellRegister { [weak self] cell, indexPath, itemIdentifier in
                switch CardTypeCollectionView.myInfoSection.allCases[indexPath.section] {
                case .title:
                    guard let data = self?.viewmodel.store.user else { return }
                    cell.studyConfigure(title: itemIdentifier, count: data.reputation[indexPath.item] )
                default: break
                }
            }
            
            let cardReviewCellRegister = CardReviewCellRegister { cell, indexPath, itemIdentifier in
                cell.configure(review: itemIdentifier)
            }
            
            let cardDetailHeaderViewRegister = CardDetailHeaderViewRegister.init(elementKind: "header") { [weak self] supplementaryView, elementKind, indexPath in
                guard let data = self?.viewmodel.store.user else { return }
                supplementaryView.myInfoConfigure(type: CardTypeCollectionView.myInfoSection.allCases[indexPath.section], reviews: data.comment)
                supplementaryView.coordinator = self?.coordinator
            }
            
            myinfoDatasource = MyinfoDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .titleItem(let value):
                    return collectionView.dequeueConfiguredReusableCell(using: cardReputationCellRegister, for: indexPath, item: value)
   
                case .reviewItem(let value):
                    return collectionView.dequeueConfiguredReusableCell(using: cardReviewCellRegister, for: indexPath, item: value)
                }
            })
            
            myinfoDatasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
                collectionView.dequeueConfiguredReusableSupplementary(using: cardDetailHeaderViewRegister, for: indexPath)
            }
            
            myinfoDatasource.apply(myinfoSnapShot())
            
        case .searchStduy:
            let cardReputationCellRegister = CardReputationCellRegister { [weak self] cell, indexPath, itemIdentifier in
                switch CardTypeCollectionView.SearchStudySection.allCases[indexPath.section] {
                case .title:
                    guard let data = self?.viewmodel.store.user else { return }
                    cell.studyConfigure(title: itemIdentifier, count: data.reputation[indexPath.item] )
                    
                case .study:
                    guard let data = self?.viewmodel.store.user else { return }
                    cell.titleConfigure(title: itemIdentifier)
                default: break
                }
            }
            
            let cardReviewCellRegister = CardReviewCellRegister { cell, indexPath, itemIdentifier in
                cell.configure(review: itemIdentifier)
            }
            
            let cardDetailHeaderViewRegister = CardDetailHeaderViewRegister.init(elementKind: "header") { supplementaryView, elementKind, indexPath in
                supplementaryView.searchStudyConfigure(type: CardTypeCollectionView.SearchStudySection.allCases[indexPath.section])
            }
            
            searchDatasource = SearchStudyDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .titleItem(let value):
                    return collectionView.dequeueConfiguredReusableCell(using: cardReputationCellRegister, for: indexPath, item: value)
                    
                case .studyItem(let value):
                    return collectionView.dequeueConfiguredReusableCell(using: cardReputationCellRegister, for: indexPath, item: value)
                    
                case .reviewItem(let value):
                    return collectionView.dequeueConfiguredReusableCell(using: cardReviewCellRegister, for: indexPath, item: value)
                }
            })
            
            searchDatasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
                collectionView.dequeueConfiguredReusableSupplementary(using: cardDetailHeaderViewRegister, for: indexPath)
            }
            
            searchDatasource.apply(searchStudySnapShot())
        }
        
    }
    
    
    
    private func myinfoSnapShot() -> MyinfoSnapShot {
        var snapshot = MyinfoSnapShot()
        
        guard let data = viewmodel.store.user else {
            return snapshot
        }

        snapshot.appendSections(CardTypeCollectionView.myInfoSection.allCases)
        snapshot.appendItems(CardTypeCollectionView.ItemTitle.allCases.map{ CardTypeCollectionView.myInfoStudyItem.titleItem($0.rawValue) }, toSection: .title)
        snapshot.appendItems([CardTypeCollectionView.myInfoStudyItem.reviewItem(data.comment.first ?? "")], toSection: .review)
        
        return snapshot
    }
    
    private func searchStudySnapShot() -> SearchStudySnapShot {
        var snapshot = SearchStudySnapShot()

//        guard let data = viewmodel.store.user else {
//            return snapshot
//        }
        
        snapshot.appendSections(CardTypeCollectionView.SearchStudySection.allCases)
        snapshot.appendItems(CardTypeCollectionView.ItemTitle.allCases.map{ CardTypeCollectionView.SearchStudyItem.titleItem($0.rawValue) }, toSection: .title)
        snapshot.appendItems(studyList.map{CardTypeCollectionView.SearchStudyItem.studyItem($0) }, toSection: .study)
        snapshot.appendItems([CardTypeCollectionView.SearchStudyItem.reviewItem(reviewList.first ?? "")], toSection: .review)
        
        return snapshot
    }

}
