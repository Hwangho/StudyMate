//
//  String+Extension.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/09.
//

import Foundation


extension String {
    func applyPatternOnNumbers() -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
        if self.count < 11 {
            for index in 0 ..<  "XXX-XXX-XXXX".count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(utf16Offset: index, in:  "XXX-XXX-XXXX")
                let patternCharacter =  "XXX-XXX-XXXX"[stringIndex]
                guard patternCharacter != "X" else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
        } else {
            for index in 0 ..<  "XXX-XXXX-XXXX".count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(utf16Offset: index, in:  "XXX-XXXX-XXXX")
                let patternCharacter =  "XXX-XXXX-XXXX"[stringIndex]
                guard patternCharacter != "X" else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
        }
        return pureNumber
    }
    
    func applyoriginalPhoneNumber() -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
            for index in 0 ..<  "XXXXXXXXXX".count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(utf16Offset: index, in:  "XXXXXXXXXX")
                let patternCharacter =  "XXXXXXXXXX"[stringIndex]
                guard patternCharacter != "X" else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
        return pureNumber
    }
    
    
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[a-zA-Z0-9-_.]+@[a-zA-Z0-9-_.]+\\.[a-zA-Z]{2,5}"
//        guard let regex = try? NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive) else { return false }
//        return regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self)) != nil
//    }
    
    var isvalidEmail: Bool {
        let emailRegEx = "[a-zA-Z0-9-_.]+@[a-zA-Z0-9-_.]+\\.[a-zA-Z]{2,5}"
        guard let regex = try? NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive) else { return false }
        return regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self)) != nil
    }
}
