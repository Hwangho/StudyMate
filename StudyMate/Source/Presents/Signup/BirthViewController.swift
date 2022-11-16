//
//  BirthViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class BirthViewController: BaseViewController {
    
    /// UI
    lazy var scrollView = UIScrollView()

    var contentView = UIView()
    
    let titleBackVoew = UIView()
    
    var stackView = UIStackView()
    
    let pickerView = UIDatePicker()
    
    var titleLabel = LineHeightLabel()
    
    lazy var yearTextFieldView = BirthLineTextFieldView(type: .year, picker: pickerView)
    
    lazy var monthTextFieldView = BirthLineTextFieldView(type: .month, picker: pickerView)
    
    lazy var dayTextFieldView = BirthLineTextFieldView(type: .day, picker: pickerView)
    
    lazy var DoneButton = SelectButton(type: .disable, title: "다음")
    
    
    /// variable
    var coordinator: BirthCoordinator?
    
    let viewModel: BirthViewModel
    
    
    /// initialization
    init(viewModel: BirthViewModel = BirthViewModel()) {
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
          
        titleLabel.setupFont(type: .Display1_R20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        stackView.distribution = .fillEqually

        yearTextFieldView.textField.becomeFirstResponder()
        
        setupDatePicker()
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
        
        
        titleBackVoew.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        contentView.addSubview(titleBackVoew)
        titleBackVoew.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(222.0/812.0)
        }
        
        [yearTextFieldView, monthTextFieldView, dayTextFieldView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleBackVoew.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        view.addSubview(DoneButton)
        DoneButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.width.equalToSuperview().multipliedBy(343.0/375.0)
            make.height.equalTo(DoneButton.snp.width).multipliedBy(48.0/343)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setData() {
        titleLabel.text = "생년월일을 알려주세요"
    }
    
    override func setupBinding() {
        /// Action
        pickerView.rx.date
            .changed
            .distinctUntilChanged()
            .map { BirthViewModel.Action.inputBirth($0)}
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        DoneButton.rx.tap
            .bind{ [weak self] in
                LocalUserDefaults.shared.set(key: .birth, value: self?.viewModel.store.birthDay)
                self?.coordinator?.startEmail()
            }
            .disposed(by: disposeBag)
            
        /// State
        viewModel.currentStore
            .map { ($0.year, $0.month, $0.day) }
            .bind { [weak self] (year, month, day) in
                self?.yearTextFieldView.textField.text = year
                self?.monthTextFieldView.textField.text = month
                self?.dayTextFieldView.textField.text = day
            }
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .distinctUntilChanged{ $0.checBirthValid }
            .map { $0.checBirthValid }
            .bind { [weak self] value in
                self?.DoneButton.isEnabled = value
                self?.DoneButton.setupAttribute(type: value ? .fill : .disable)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    /// CUstom Func
    func setupDatePicker() {
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = Locale(identifier: "ko-KR")
        pickerView.datePickerMode = .date
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar

        // datePicker max 날짜 세팅 -> 오늘 날짜 에서
        components.year = -1
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!

        // datePicker min 날짜 세팅 -> 30년 전 까지
        //
        components.year = -18
        let minDate = calendar.date(byAdding: components, to: currentDate)!

        pickerView.minimumDate = minDate
        pickerView.maximumDate = maxDate
    }
    
}
