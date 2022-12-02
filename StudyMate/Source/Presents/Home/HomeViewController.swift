//
//  HomeViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

import NMapsMap
import CoreLocation
import SnapKit
import RxSwift
import RxCocoa


final class HomeViewController: BaseViewController {
    
    /// UI
    private let mapView = NMFMapView(frame: .zero)
    
    private let locationButton = UIButton()
    
    private let pinImageVidew = UIImageView()
    
    private let searchButton = UIButton()
    
    private let filterView = FilterGenderView()
    
    
    /// properties
    weak var coordinator: HomeCoordinator?
    
    var locationManager = CLLocationManager()
    
    let viewModel = HomeViewModel()
    
    var type: Gender = .all
    
    
    /// LIfe Cycle
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }

    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        locationButton.layer.masksToBounds = true
        locationButton.layer.cornerRadius = 8
        locationButton.backgroundColor = .clear
        locationButton.layer.masksToBounds = false
        locationButton.layer.shadowRadius = 3
        locationButton.layer.shadowOpacity = 0.4
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        locationButton.backgroundColor = Color.BaseColor.white
        locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        locationButton.setImage(UIImage(named: "place"), for: .normal)
        
        pinImageVidew.image = UIImage(named: "map_marker")
        
        searchButton.setImage(UIImage(named: "map_search"), for: .normal)
        
        filterView.delegate = self

        setMapAttributes()
    }
    
    override func setupLayout() {
        
        [mapView, pinImageVidew, filterView, locationButton, searchButton].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        
        pinImageVidew.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.94)
        }
        
        filterView.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(filterView.snp.width).multipliedBy(3.0)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().inset(16)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(16)
            make.centerX.equalTo(filterView.snp.centerX)
            make.width.equalTo(filterView.snp.width)
            make.height.equalTo(locationButton.snp.width)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func setData() {
        filterView.configure()
    }
    
    override func setupLifeCycleBinding() {
        
        rx.viewWillAppear
            .bind(onNext: { [weak self] _ in
                self?.searchCurrentSesac()
                self?.viewModel.action.accept(.queueState)
            })
            .disposed(by: disposeBag)

    }
    
    override func setupBinding() {
        
        /// Action
        searchButton.rx.tap
            .bind {[weak self] in
                let stateData = self?.viewModel.store.queueState
                if stateData == nil {
                    let cameraPosition = self?.mapView.cameraPosition // 중앙 위치 좌표
                    LocalUserDefaults.shared.set(key: .lat, value: cameraPosition?.target.lat)
                    LocalUserDefaults.shared.set(key: .lng, value: cameraPosition?.target.lng)
                    self?.coordinator?.startSearch()
                } else if stateData?.matched  == 0 {
                    let cameraPosition = self?.mapView.cameraPosition // 중앙 위치 좌표
                    self?.coordinator?.pushtoLookupStudy(lat: cameraPosition!.target.lat, lng: cameraPosition!.target.lng)
                } else {
                    print("매칭 되었당")
                }
            }
            .disposed(by: disposeBag)
        
        
        /// State
        viewModel.currentStore
            .distinctUntilChanged{$0.allMarker}
            .bind { [weak self] _ in
                self?.typeGenderMarkers(type: self!.type)
            }
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .distinctUntilChanged{ $0.errorType }
            .map { $0.errorType }
            .asObservable()
            .bind {[weak self] errortype in
                guard let type = errortype else { return }
                switch type {
                case .FireBaseToken:
                    self?.fireBaseIDTokenRefresh {
                        self?.searchCurrentSesac()
                    }
                default:
                    print(type.message)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .distinctUntilChanged{ $0.queueState }
            .map { $0.queueState }
            .bind { [weak self] queueState in
                if queueState == nil {
                    self?.searchButton.setImage(UIImage(named: "map_search"), for: .normal)
                } else if queueState?.matched  == 0 {
                    self?.searchButton.setImage(UIImage(named: "map_matching"), for: .normal)
                } else {
                    self?.searchButton.setImage(UIImage(named: "map_message"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
}


// MARK: = Map
extension HomeViewController: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
    /// Custom Func
    func setMapAttributes() {
        mapView.minZoomLevel = 12.0
        mapView.maxZoomLevel = 17.0
        mapView.addCameraDelegate(delegate: self)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
            // 애매하지만 내 위치
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0,
                                                                   lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            
        default:
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.517829, lng: 126.886270))    // 새싹 위치
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    /// 화면 전환이 끝이 났을 떄 해당 함수 호출
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        searchCurrentSesac()
        mapView.isScrollGestureEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.mapView.isScrollGestureEnabled = true
        }
    }
    
    func searchCurrentSesac() {
        let cameraPosition = mapView.cameraPosition // 중앙 위치 좌표
        viewModel.action.accept(.searchSesac(cameraPosition.target.lat, cameraPosition.target.lng)) // API 받아서 뿌려주기
    }

    @objc
    func tapLocationButton(_ sender: UIButton) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.positionMode = .direction
            mapView.positionMode = .disabled
            
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            showSelectAlertMessage(title: "위치 권한 설정 가시겠습니까?", button: "예") {
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            }
            
        @unknown default:
            print("'aa'")
        }
    }
}



// MARK: - GenderData Protocool
extension HomeViewController: FilterGenderButtonProtocool {
    
    func tapGender(type: Gender) {
        self.type = type
        typeGenderMarkers(type: type)
    }
    
    func typeGenderMarkers(type: Gender) {
        viewModel.store.allMarker
            .forEach { marker in
                marker.mapView = nil
            }
        
        switch type {
        case .all:
            viewModel.store.allMarker
                .forEach { marker in
                    marker.mapView = mapView
                }
            
        case .man:
            viewModel.store.manMarker
                .forEach { marker in
                    marker.mapView = mapView
                }
            
        case .woman:
            viewModel.store.womanMarker
                .forEach { marker in
                    marker.mapView = mapView
                }
        }
    }
}

