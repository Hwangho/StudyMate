//
//  CertificationService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/13.
//

import FirebaseAuth

import RxCocoa
import RxSwift



protocol CertificationServiceprotocool {
    func verifyPhoneNumber(phoneNumber: String) -> Single<String>
}

class CertificationService: CertificationServiceprotocool {
    
    func verifyPhoneNumber(phoneNumber: String) -> Single<String> {

        return Single<String>.create { single in
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                Auth.auth().languageCode = "kr"

                if let verificationID = verificationID {
                    single(.success(verificationID))
                    return
                }
            }
            
            return Disposables.create()
        }

    }
    
    
    func verifyMessagingNumber(certificationNumber: String) {
        let verificationID: String? = LocalUserDefaults.shared.value(key: .verificationID)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: certificationNumber
        )
        
        Auth.auth().signIn(with: credential) { authData, error in
            
            if let error = error {
                guard let errorCode = (error as? NSError)?.code else {return}
                print("errorCode: \(errorCode)")
            }
            
            print(authData)
            
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print(error)
                    return
                }
                
                LocalUserDefaults.shared.set(key: .FirebaseidToken, value: idToken)
            }
        }
    }
    
}




struct FireBaseError{
    
    enum ErrorType: Int, Error {
        case ERROR_WEB_CONTEXT_ALREADY_PRESENTED = 17057
        case ERROR_INVALID_VERIFICATION_CODE = 17044
    }
    
    func printNumber(_ number: Int) throws -> Bool {
        
        guard number == 17057 else {
            throw ErrorType.ERROR_WEB_CONTEXT_ALREADY_PRESENTED
        }
        print("StatusCode: \(number)")
        return true
    }
}

