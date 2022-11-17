//
//  BaseViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//


import UIKit

import RxSwift
import FirebaseAuth


class BaseViewController: UIViewController {
    
    // MARK: Properties
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    weak var coordinatorDelegate: CoordinatorDidFinishDelegate?
    
    var disposeBag = DisposeBag()
    
    
    // MARK: Layout Constraints
    
    private(set) var didSetupConstraints = false
    
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupLifeCycleBinding()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupLifeCycleBinding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLifeCycleBinding()
    }
    
    
    deinit {
        coordinatorDelegate?.didFinishCoordinator()
        dump("DEINIT: \(self.className)")
    }
    
    
    // MARK: Life Cycle Views
    
    override func viewDidLoad() {
        setupAttributes()
        setupLayout()
        setupLocalization()
        setupBinding()
        setData()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    // MARK: Setup
    
    func setupLayout() {
        // Override Layout
    }
    
    func setupConstraints() {
        // Override Constraints
    }
    
    func setupAttributes() {
        // Override Attributes
        view.backgroundColor = Color.BaseColor.white
        navigation()
//        view.backgroundColor = Color.mainContainerBackgroundColor
    }
    
    func setupLocalization() {
        // Override Localization
    }
    
    func setupLifeCycleBinding() {
        // Override Binding for Lify Cycle Views
    }
    
    func setupBinding() {
        // Override Binding
    }
    
    func setData() {
        // Override Set Data
    }
    
    
    // MARK: Custom Func
    func navigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false   /// navigation 반투명 상태 제거
        navigationController?.navigationBar.backgroundColor = Color.BaseColor.white    /// bacground 색상

        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Color.BaseColor.white
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.BaseColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: Font.Title3_M14.fontType, size: Font.Title3_M14.fontSize)! ]

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem

        
        let backButton  = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
}



extension BaseViewController {
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    
    func fireBaseIDTokenRefresh(handler: (() -> ())?) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print(error)
                return
            }
            LocalUserDefaults.shared.set(key: .FirebaseidToken, value: idToken)
            handler?()
        }
    }
    
    
    /// scroll in textfield
    func setupGestureRecognizer() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
      view.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
      view.endEditing(true)
    }
}

