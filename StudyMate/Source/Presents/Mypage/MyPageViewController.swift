//
//  MyPageViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import RxSwift


final class MyPageViewController: BaseViewController {
    
    /// Propery
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var datasource: DatSource!
    
    weak var coordinator: MyPageCoordinator?
    
    
    /// life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        navigationItem.title = "내 정보"
        
        collectionView.delegate = self
    }
    
    override func setData() {
        setupDataSource()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {


    }
       
}


// MARK: - diffable collectionview
extension MyPageViewController {
    
    /// typealias
    typealias DatSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias MyCellRegister = UICollectionView.CellRegistration<MyPageCollectionViewCell, String>
    
    typealias SettingCellRegister = UICollectionView.CellRegistration<SettingCollectionViewCell, Setting>
    
    
    /// Section, Item
    enum Section: Hashable, CaseIterable {
        case my
        case setting
    }
    
    enum Item: Hashable {
        case myInfo(String)
        case Setting(Setting)
    }
    
    enum Setting: CaseIterable {
        case notice
        case Questions
        case qna
        case alarm
        case termsConditions
        
        var title: String {
            switch self {
            case .notice: return "공지사항"
            case .Questions: return "자주 묻는 질문"
            case .qna: return "1:1 문의"
            case .alarm: return "알림 설정"
            case .termsConditions: return "이용약관"
            }
        }
        
        var image: UIImage? {
            switch self {
                case .notice: return UIImage(named: "notice")
                case .Questions: return UIImage(named: "faq")
                case .qna: return UIImage(named: "qna")
                case .alarm: return UIImage(named: "setting_alarm")
                case .termsConditions: return UIImage(named: "permit")
            }
        }
    }
    
    
    private func setupDataSource() {
        
        let myCell = MyCellRegister { cell, indexPath, itemIdentifier in
            cell.Configure(value: itemIdentifier)
        }
        
        let settingCell = SettingCellRegister { cell, indexPath, itemIdentifier in
            cell.Configure(type: itemIdentifier)
        }
        
        datasource = DatSource(collectionView: collectionView){ collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .myInfo(let value):
               return collectionView.dequeueConfiguredReusableCell(using: myCell, for: indexPath, item: value)
                
            case .Setting(let value):
                return collectionView.dequeueConfiguredReusableCell(using: settingCell, for: indexPath, item: value)
            }
        }
        
        datasource.apply(snapshot())
    }
    
    private func snapshot() -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([Item.myInfo("내 정보 궁금해?")], toSection: .my)
        snapshot.appendItems(Setting.allCases.map{Item.Setting($0)}, toSection: .setting)
        
        return snapshot
    }
    
    private func layout() -> UICollectionViewLayout {
        
        /// sectionNumber [int] : sectionNumber마다 다르게 줄 수 있도록하는 인자
        /// env [NSCollectionLayoutEnvironment] : 사이즈, 인셋 등을 줄 수 있는 인자
        return UICollectionViewCompositionalLayout  { sectionindex, enviroment in
            switch Section.allCases[sectionindex] {
            case .my:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(96.0/375.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupsize, subitems: [item] )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 00, trailing: 10)
                
                return section
                
            case .setting:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(74.0/375.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupsize, subitems: [item] )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 00, trailing: 10)
                
                return section
            }
        }
    }
    
}


// MARK: - UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .myInfo:
            coordinator?.startChangeMyPage()
            
        case .Setting(let type):
            switch type {
            default: print(type)
            }
        }
    }
}
