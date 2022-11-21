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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        collectionview.delegate = self
        collectionview.contentInset.top = 16
        
        navigationItem.title = "정보 관리"
        
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(tapSaveButton))
        
        navigationItem.rightBarButtonItem = saveButton
//        setupGestureRecognizer()    /// TextField KeyBoard 내리기
    }
    
    
    @objc
    func tapSaveButton() {
        print("내 마음 속에 저장~")
    }
    
    
    override func setupLayout() {
        view.addSubview(collectionview)
        collectionview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupLifeCycleBinding() {
        rx.viewDidLoad
            .map{ ChangeMyPageViewModel.Action.myInfo }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }
    
    override func setupBinding() {
        viewModel.currentStore
            .map { $0.user }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.datasource?.apply(self.snapshot(), animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    override func setData() {
        setDataSource()
    }

}


// MARK: - Diffable CollectionView
extension ChangeMyPageViewController {
    
    /// typealiase
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CardCellRegister = UICollectionView.CellRegistration<CardCollectionViewCell, Item>
    
    typealias MyInfoCeollRegister = UICollectionView.CellRegistration<MyInfoCollectionViewCell, Item>
    
    typealias HeaderViewRegister = UICollectionView.SupplementaryRegistration<CardCollectionViewHeaderView>
    
    
    /// Section Item
    enum Section: Hashable {
        case first(User)
    }
    
    enum Item: Hashable {
        case myCard(User)
        case myInfo(User)
    }
    
 
    /// Set CollectionView
    func setDataSource() {
        let cardCell = CardCellRegister.init { [weak self] cell, indexPath, itemIdentifier in
            guard let user = self?.viewModel.store.user else { return }
            cell.cardInfoViewcontroller.viewmodel.action.accept(.sendUserData(user))
            cell.cardInfoViewcontroller.coordinator = self?.coordinator
            cell.configure(user: user)
            
            self?.addChild(cell.cardInfoViewcontroller)
        }
        
        let myinfoCell = MyInfoCeollRegister {[weak self] cell, indexPath, itemIdentifier in
            cell.withDrawView.coordinator = self?.coordinator
            guard let user = self?.viewModel.store.user else { return }
            cell.configure(user: user)
            cell.genderView.delegate = self
            cell.studyView.delegate = self
            cell.searchallowView.delegate = self
            cell.ageView.delegate = self
        }
        
        let headerView = HeaderViewRegister.init(elementKind: "CardHeader") { [weak self] supplementaryView, elementKind, indexPath in
            guard let user = self?.viewModel.store.user else { return }
            supplementaryView.configure(user: user)
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
        
        guard let data = viewModel.store.user else {
            return snapshot
        }
        
        snapshot.appendSections([Section.first(data)])
        snapshot.appendItems([Item.myCard(data), Item.myInfo(data)])
        
        return snapshot
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


// MARK: - data set
extension ChangeMyPageViewController: SendGenderProtocool, SendStudyProtocool, SendSearchAllowProtocool, sendAgeProtocool {

    func sendGender(gender: Int) {
        print("내 성별 \(gender)")
    }
    
    func sendStudy(study: String?) {
        print("내가 하고싶은 스터디 \(study ?? "")")
    }
    
    func sendSearchAllow(allow: Int) {
        print("허용 할거야?? \(allow)")
    }
    
    func sendAge(ageMin: Int, ageMax: Int) {
        print("최소 나이: \(ageMin), 최대 나이: \(ageMax)")
    }
    
}
