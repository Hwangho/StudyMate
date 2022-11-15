//
//  LocalStorage.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/13.
//

import Foundation


enum UserDefaultsType: String {
    case verificationID
    case FirebaseidToken
    case FCMToken
}

final class LocalUserDefaults {
    static let shared = LocalUserDefaults()
    
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    
    func value<T>(key: UserDefaultsType) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func set<T>(key: UserDefaultsType, value: T?) {
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(key: UserDefaultsType) {
        self.userDefaults.set(nil, forKey: key.rawValue)
    }

}
