//
//  CertificationService.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/13.
//

import FirebaseAuth


protocol CertificationServiceprotocool {
    func verifyPhoneNumber(phoneNumber: String)
}

class CertificationService: CertificationServiceprotocool {
    func verifyPhoneNumber(phoneNumber: String)  {
        var value = false
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                
                if let error = error {
                    guard let errorCode = (error as? CustomNSError) else {return}
                    print(errorCode)
                }
                
                Auth.auth().languageCode = "kr"
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
    }
    
    
}
