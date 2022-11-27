//
//  SearchViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/25.
//

import UIKit

import SnapKit


final class SearchViewController: BaseViewController {
    
    /// UI
    lazy var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let searchBar = UISearchBar()
    
    private let searchButton = SelectButton(type: .fill, title: "새싹 찾기")
    
    
    /// Properties
    var coordinator: SearchCoordinator?
    
    private let viewModel = SearchViewModel()
    
    private var datasource: DataSource!
    

    /// life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lat: Double? = LocalUserDefaults.shared.value(key: .lat)
        let lng: Double? = LocalUserDefaults.shared.value(key: .lng)
        viewModel.action.accept(.searchSesac(lat!, lng!))
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
        self.removeKeyboardNotifications()
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        searchBar.searchTextField.font = UIFont(name: Font.Title4_R14.fontType, size: Font.Title4_R14.fontSize)
        searchBar.placeholder = "띄어쓰기로 복수 입력이 불가능해요.ㅠㅜ"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        collectionview.delegate = self
        collectionview.contentInset.top = 20
        collectionview.keyboardDismissMode = .onDrag
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        setDataSource()
        keyBoardHiddenGesture() // 왜 안되지?? (searchBar로 인해 올라오는 KeyBoard는 안되는 것인가??
    }
    
    override func setupLayout() {
        [collectionview, searchButton].forEach {
            view.addSubview($0)
        }
        
        collectionview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset(-UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
            make.height.equalTo(48)
        }
        
    }
    
    override func setupBinding() {
        
        /// State
        viewModel.currentStore
            .distinctUntilChanged{ $0.recomandStudy }
            .bind {[weak self] _ in
                self?.snapshotApply()
            }
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .map { $0.studyListIsFull }
            .bind { [weak self] isTrue in
                if isTrue {
                    self?.showAlertMessage(title: "스터디를 더 이상 추가할 수 없습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
}


// MARK: - Diffable CollectionView
extension SearchViewController {
    
    /// Section, Item
    enum Section: String, Hashable, CaseIterable {
        case around = "지금 주변에는"
        case my = "내가 하고 싶은"
    }
    
    enum Item: Hashable {
        case around(RecomandStudys)
        case my(String)
    }
 
    
    /// tpye aliase
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    typealias RecomandCellRegister = UICollectionView.CellRegistration<SearchRecomandCollectionViewCell, RecomandStudys>
    
    typealias MyCellRegister = UICollectionView.CellRegistration<SearchMyStudyCollectionViewCell, String>
    
    typealias HeaderRegister = UICollectionView.SupplementaryRegistration<SearchCollectionviewHeaderView>
    
    
    /// Datasource
    private func setDataSource() {
        let recomandCell = RecomandCellRegister { cell, indexPath, itemIdentifier in
            cell.configure(value: itemIdentifier)
        }
        
        let myCell = MyCellRegister { cell, indexPath, itemIdentifier in
            cell.configure(value: itemIdentifier)
        }
        
        let header = HeaderRegister.init(elementKind: "header") { supplementaryView, elementKind, indexPath in
            let type = Section.allCases[indexPath.section]
            supplementaryView.configure(title: type.rawValue)
        }
        
        datasource = DataSource(collectionView: collectionview, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .around(let value):
                return collectionView.dequeueConfiguredReusableCell(using: recomandCell, for: indexPath, item: value)
                
            case .my(let value):
                return collectionView.dequeueConfiguredReusableCell(using: myCell, for: indexPath, item: value)
            }
        })
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
    }
    
    func snapshotApply() {
        var snapshot = SnapShot()
        
        guard let around = viewModel.store.recomandStudy  else {
            datasource.apply(snapshot)
            return
        }
        let studyList = viewModel.store.searchStudyList
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(around.map{Item.around($0)}, toSection: .around)
        snapshot.appendItems(studyList.map{Item.my($0)}, toSection: .my)
        
        datasource.apply(snapshot)
    }
    
    /// Layout
    private func layout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(10), heightDimension: .estimated(32))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = .init(leading: .fixed(0), top: .fixed(6), trailing: .fixed(8), bottom: .fixed(6))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
            
            let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
}


// MARK: - SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let study = searchBar.text else { return }
        viewModel.action.accept(.addStudy(study))
        searchBar.text = ""
        searchBar.resignFirstResponder()
        snapshotApply()
    }
}


// MARK: - CollectionviewDelelgate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .around(let data):
            viewModel.action.accept(.addStudy(data.title))
            
        case .my(let data):
            viewModel.action.accept(.deleteStudy(data))
        }
        snapshotApply()
    }
}


// MARK: - KeyBoard 관련
extension SearchViewController {
    // 노티피케이션을 추가하는 메서드
    private func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    private func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        
        self.searchButton.snp.remakeConstraints { make in
            make.horizontalEdges.equalTo(self.view.keyboardLayoutGuide.snp.horizontalEdges).inset(-4)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        self.searchButton.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset( -UIApplication.shared.windows.first!.safeAreaInsets.bottom)
            make.height.equalTo(48)
        }
    }
    
}
