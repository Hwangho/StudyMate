//
//  LookupStudyViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/27.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa



final class LookupStudyViewController: BaseViewController {
    
    enum StudyType {
        case around
        case response
        
        var title: String {
            switch self {
            case .around: return "아쉽게도 주변에 새싹이 없어요ㅠ"
            case .response: return "아직 받은 요청이 없어요ㅠ"
            }
        }
        
        var content: String {
            switch self {
            case .around: return "스터디를 변경하거나 조금만 더 기다려 주세요!"
            case .response: return "스터디를 변경하거나 조금만 더 기다려 주세요!"
            }
        }
    }
    
    /// UI
    private let tabStackView = UIStackView()
    
    let aroundButton = UIButton()
    
    let responseButton = UIButton()
    
    private let grayLineView = UIView()
    
    private let greenLineView = UIView()
    
    private let scrollview = UIScrollView()
    
    private lazy var arroundStudyVC = ArroundStudyViewController(viewModel: viewModel, coordinator: coordinator!)
    
    private lazy var responseStudyVC = ResponseStudyViewController(viewModel: viewModel, coordinator: coordinator!)
    
    
    /// properties
    weak var coordinator: LookupStudyCoordinator?
    
    let viewModel = LookupStudyViewModel()
        
    
    init(lat: Double?, lng: Double?) {
        super.init()
        viewModel.action.accept(.saveLocation(lat, lng))
    }
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        navigationItem.title = "새싹 찾기"
        
        tabStackView.distribution = .fillEqually
        
        aroundButton.setTitle("주변 새싹", for: .normal)
        aroundButton.setTitleColor(Color.BaseColor.green, for: .normal)
        aroundButton.addTarget(self, action: #selector(tapArroundButton), for: .touchUpInside)
        
        responseButton.setTitle("받은 요청", for: .normal)
        responseButton.setTitleColor(Color.BaseColor.gray6, for: .normal)
        responseButton.addTarget(self, action: #selector(tapresponseButton), for: .touchUpInside)
        
        grayLineView.backgroundColor = Color.BaseColor.gray6
        greenLineView.backgroundColor = Color.BaseColor.green
        
        scrollview.contentSize.width = view.frame.width * 2
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.isPagingEnabled = true
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(customBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기 중단", style: .plain, target: self, action: #selector(stopSearchStudy))
    }
    
    override func setupLayout() {
        [aroundButton, responseButton].forEach {
            tabStackView.addArrangedSubview($0)
        }
        
        [tabStackView, grayLineView, greenLineView, scrollview].forEach {
            view.addSubview($0)
        }
        
        tabStackView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(42)
        }
        
        grayLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(tabStackView.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        greenLineView.snp.makeConstraints { make in
            make.top.equalTo(tabStackView.snp.bottom)
            make.height.equalTo(2)
            make.horizontalEdges.equalTo(aroundButton.snp.horizontalEdges)
        }
        
        scrollview.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(grayLineView.snp.bottom)
        }
    
        
        [arroundStudyVC, responseStudyVC].forEach {
            addChild($0)
        }
        
        /// MainVC View의 Frame 지정
        arroundStudyVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.frame.width, height: scrollview.frame.height)
        responseStudyVC.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollview.frame.width, height: scrollview.frame.height)
       
        /// Scroll View에 MainVC의 View 넣기
        self.scrollview.addSubview(arroundStudyVC.view)
        self.scrollview.addSubview(responseStudyVC.view)
    }
    
    override func setupBinding() {
        
        // Action
        scrollview.rx.contentOffset
            .distinctUntilChanged()
            .map { $0.x }
            .bind{ [weak self] positionX in
                
                if positionX != 0 {
                    if positionX / (self?.view.frame.width)! < 0.5 {
                        self?.setArroundView(type: .around)
                    } else {
                        self?.setArroundView(type: .response)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // State
        viewModel.currentStore
            .map { $0.stopSearchType }
            .distinctUntilChanged()
            .bind { [weak self] type in
                switch type {
                case .success:
                    self?.coordinator?.popandgoMap()
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    /// Custom Func
    @objc
    func tapArroundButton(sender: UIButton) {
        scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc
    func tapresponseButton(sender: UIButton) {
        scrollview.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
    }
    
    @objc
    func customBackButton() {
        coordinator?.popandgoMap()
    }
    
    @objc
    func stopSearchStudy() {
        viewModel.action.accept(.stopSearch)
    }
    
    private func setArroundView(type: StudyType) {
        switch type {
        case .around:
            greenLineView.snp.remakeConstraints { make in
                make.top.equalTo(tabStackView.snp.bottom)
                make.height.equalTo(2)
                make.horizontalEdges.equalTo(aroundButton.snp.horizontalEdges)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            aroundButton.setTitleColor(Color.BaseColor.green, for: .normal)
            responseButton.setTitleColor(Color.BaseColor.gray6, for: .normal)
            
        case .response:
            greenLineView.snp.remakeConstraints { make in
                make.top.equalTo(tabStackView.snp.bottom)
                make.height.equalTo(2)
                make.horizontalEdges.equalTo(responseButton.snp.horizontalEdges)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            aroundButton.setTitleColor(Color.BaseColor.gray6, for: .normal)
            responseButton.setTitleColor(Color.BaseColor.green, for: .normal)
        }
    }
    
}
