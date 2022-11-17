//
//  BirthViewModel.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/12.
//

import UIKit

import RxSwift
import RxRelay


final class BirthViewModel {
    
    enum Action {
        case inputBirth(Date)
    }
    
    enum Mutation {
        case setBirthDate(String)
        case setYearMonthDay(String, String, String)
    }
    
    struct Store {
        var birthDay: String?
        
        var checBirthValid = false
        var year: String?
        var month: String?
        var day: String?
    }
    
    
    /// Properties
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    private(set) var store: Store
    
    var disposeBag = DisposeBag()
    
    
    /// initialization
    init(store: Store = Store()) {
        self.store = store
        
        action
            .flatMapLatest(mutate)
            .flatMapLatest(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    
    /// mutate, action
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
        case .inputBirth(let date):
            
            let BirthFormatter = DateFormatter()
            BirthFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 2020.08.13 오후 04시 30분  2002-01-16T09:23:44.054Z
            BirthFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
            let Birth = BirthFormatter.string(from: date)
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy" // 2020.08.13 오후 04시 30분
            yearFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
            let year = yearFormatter.string(from: date)
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM" // 2020.08.13 오후 04시 30분
            monthFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
            let month = monthFormatter.string(from: date)
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd" // 2020.08.13 오후 04시 30분
            dayFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
            let day = dayFormatter.string(from: date)
            
            return .concat([
                .just(.setBirthDate(Birth)),
                .just(.setYearMonthDay(year, month, day))
            ])
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setBirthDate(let birth):
            store.birthDay = birth
            store.checBirthValid = true
            
        case .setYearMonthDay(let year, let month, let day):
            store.year = year
            store.month = month
            store.day = day
        }
        return .just(store)
    }
}



