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
    }
    
    /// UI
    private let tabStackView = UIStackView()
    
    let aroundButton = UIButton()
    
    let responseButton = UIButton()
    
    private let grayLineView = UIView()
    
    private let greenLineView = UIView()
    
    private let scrollview = UIScrollView()
    
    private lazy var arroundStudyVC = ArroundStudyViewController(viewModel: viewModel)
    
    private lazy var responseStudyVC = ResponseStudyViewController(viewModel: viewModel)
    
    
    /// properties
    weak var coordinator: LookupStudyCoordinator?
    
    let viewModel = LookupStudyViewModel()
        
    
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






class EmptyView: BaseView {
    
    private let backView = UIView()
    
    private let imageView = UIImageView()
    
    private let titleLabel = LineHeightLabel()
    
    private let contentLabel = LineHeightLabel()
    
    private let refreshStackview = UIStackView()
    
    private let changeStudyButton = SelectButton(type: .fill, title: "스터디 변경하기")
    
    private let refreshButton = UIButton()
    
    override func setupAttributes() {
        super.setupAttributes()
        
        imageView.image = UIImage(named: "empty")
        titleLabel.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        titleLabel.setupFont(type: .Display1_R20)
        
        contentLabel.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        contentLabel.setupFont(type: .Title4_R14)
        
        refreshButton.setImage(UIImage(named: "refresh-line"), for: .normal)
        refreshButton.layer.cornerRadius = 8
        refreshButton.layer.borderColor = Color.BaseColor.green.cgColor
        refreshButton.layer.borderWidth = 1
        
        refreshStackview.axis = .horizontal
        refreshStackview.spacing = 8
    }
    
    override func setupLayout() {
        [imageView, titleLabel, contentLabel].forEach {
            backView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        [changeStudyButton, refreshButton].forEach {
            refreshStackview.addArrangedSubview($0)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
        
        [backView, refreshStackview].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        refreshStackview.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
