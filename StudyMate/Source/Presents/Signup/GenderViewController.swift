//
//  GenderViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class GenderViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackView = UIView()
    
    var titleLabel = LineHeightLabel()
    
    var contentLabel = LineHeightLabel()
    
    lazy var DoneButton = SelectButton(type: .disable, title: "다음")
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        return collectionView
    }()
    
    
    /// variable
    let viewModel: GenderViewModel
    
    var coordinator: GenderCoordinator?
    
    var datasource: DataSource!
        
    
    /// initialization
    init(viewModel: GenderViewModel = GenderViewModel()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        scrollView.isScrollEnabled = false
        
        collectionView.delegate = self
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        contentLabel.setupFont(type: .Title2_R16)
        contentLabel.textColor = Color.BaseColor.gray7
        contentLabel.textAlignment = .center
    }
    
    override func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(view)
            make.width.height.equalTo(view)
        }
        
        
        [titleLabel, contentLabel].forEach {
            titleBackView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        contentView.addSubview(titleBackView)
        titleBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(222.0/812.0)
        }

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(self.view).multipliedBy(120.0/724.0)
        }
        
        contentView.addSubview(DoneButton)
        DoneButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(32)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setData() {
        titleLabel.text = "성별을 선택해 주세요"
        contentLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        setupDataSource()
    }
    
    override func setupBinding() {
        /// Action
        DoneButton.rx.tap
            .map { GenderViewModel.Action.doneButton}
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        
        /// State
        viewModel.currentStore
            .map { $0.checkGenderValid }
            .bind { [weak self] value in
                let type: SDSSelectButton = value ? .fill : .disable
                self?.DoneButton.setupAttribute(type: type)
                self?.DoneButton.isEnabled = value
            }
            .disposed(by: disposeBag)   
    }
    
}


// MARK: - DiffalbeCollectionview
extension GenderViewController {
    
    enum Section: CaseIterable, Hashable {
        case gender
    }
    
    enum Item: CaseIterable, Hashable {
        case man
        case woman
        
        var titleImage: String {
            switch self {
            case .man: return "man"
            case .woman: return "woman"
            }
        }
        
        var titleLabel: String {
            switch self {
            case .man: return "남자"
            case .woman: return "여자"
            }
        }
    }
    
    /// typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias CellRegister = UICollectionView.CellRegistration<GenderCollectionViewCell, Item>
    
    
    /// layout
    private func layout() -> UICollectionViewLayout {
        return  UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection?  in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let leftitem = NSCollectionLayoutItem(layoutSize: itemSize)
            leftitem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7)
            let rightitem = NSCollectionLayoutItem(layoutSize: itemSize)
            rightitem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftitem, rightitem])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 7)
            
            let section = NSCollectionLayoutSection(group: group)

            return section
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
        snapshot.appendItems(Item.allCases, toSection: .gender)
        
        return snapshot
    }
}


extension GenderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action.accept(.tapGender(indexPath.item))
    }
}
