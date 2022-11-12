//
//  BirthLineTextFieldView.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

import SnapKit


class BirthLineTextFieldView: BaseView {
    
    @frozen
    enum BirthType: String {
        case year = "년"
        case month = "월"
        case day = "일"
        
        var placholder: String {
            switch self {
            case .year: return "1990"
            case .month: return "01"
            case .day: return "01"
            }
        }
    }
    
    /// UI
    let textField = UITextField()
    
    let lineView = UIView()
    
    let dateLabel = LineHeightLabel()
    
    
    ///  properties
    let type: BirthType
    
    
    /// Initialization
    init(type: BirthType, picker: UIDatePicker) {
        self.type = type
        textField.inputView = picker
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Life Cycle
    override func setupAttributes() {
        lineView.backgroundColor = Color.BaseColor.gray3
        
        textField.textAlignment = .center
        textField.setupFont(type: .Title4_R14)
        textField.tintColor = UIColor.clear
        
        dateLabel.setupFont(type: .Title2_R16)
    }
    
    override func setupData() {
        textField.placeholder = type.placholder
        dateLabel.text = type.rawValue
    }
    
    override func setupLayout() {
        [textField, lineView, dateLabel].forEach {
            addSubview($0)
        }

        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.leading.equalTo(textField.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.width.equalTo(20)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.bottom.leading.equalToSuperview()
            make.trailing.equalTo(dateLabel.snp.leading)
            make.height.equalTo(1)
        }
        
    }
    
    
    /// Custom Function
    func focusTexField(value: Bool) {
        lineView.backgroundColor = value ? Color.BaseColor.focus : Color.BaseColor.gray3
    }

}


