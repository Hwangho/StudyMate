//
//  OnBoardingViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import SnapKit


final class OnBoardingViewController: BaseViewController {
    
    /// UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    private var pageControl = UIPageControl()
    
    private var startButton =  SelectButton(type: .fill, title: "시작하기")
    
    
    /// variable
    var coordinator: OnBoardingCoordinator?
    
    var datasource: DataSource!
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        setPageControl()
        startButton.addTarget(self, action: #selector(tuchStartButton), for: .touchUpInside)
    }
    
    override func setupLayout() {
        [collectionView, pageControl, startButton].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(startButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setData() {
        setupDataSource()
    }
    
    
    /// Custom Func
    @objc
    private func tuchStartButton() {
        LocalUserDefaults.shared.set(key: .onBoarding, value: true)
        coordinator?.showInitialView(with: .certification)
    }
    
    
    /// Custom Func
    private func setPageControl() {
        pageControl.numberOfPages = Item.allCases.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = Color.BaseColor.gray6
        pageControl.currentPageIndicatorTintColor = Color.BaseColor.black
    }
    
}


// MARK: - Diffabe CollectionView
extension OnBoardingViewController {
    
    /// Section, Item
    enum Section: CaseIterable, Hashable {
        case onboarding
    }
    
    enum Item: CaseIterable, Hashable {
        case location
        case friend
        case study
        
        var titleLabel: String {
            switch self {
            case .location: return "위치 기반으로 빠르게\n 주위 친구를 확인"
            case .friend: return "스터디를 원하는 친구를\n 찾을 수 있어요"
            case .study: return "SeSAC Study"
            }
        }
        
        var titleImage: String {
            switch self {
            case .location: return "onboarding_img1"
            case .friend: return "onboarding_img2"
            case .study: return "onboarding_img3"
            }
        }
    }

    
    /// typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CellRegister = UICollectionView.CellRegistration<OnBoardingCollectionViewCell, Item>
    
    
    /// layout
    private func layout() -> UICollectionViewLayout {
        return  UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection?  in
            switch Section.allCases[sectionIndex] {
            case .onboarding:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 7)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .groupPaging
                
                //setup pageControl
                section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
                    self?.pageControl.currentPage = items.last?.indexPath.row ?? 0
                }
                
                return section
            }
        }
    }
    
    
    /// Datasource
    private func setupDataSource() {
        let cell = CellRegister { cell, indexPath, itemIdentifier in
            cell.setConfigure(type: itemIdentifier)
        }
        
        datasource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: itemIdentifier)
        })
         
        datasource.apply(snapshot())
    }
    
    private func snapshot() -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(Item.allCases, toSection: .onboarding)
        
        return snapshot
    }
    
}
