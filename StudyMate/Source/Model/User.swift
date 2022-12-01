//
//  User.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/15.
//

import Foundation


struct User: Codable, Hashable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int         //0: 여자, 1: 남자
    let study: String?
    let comment: [String]
    let reputation: [Int]
    let sesac: String
    let sesacCollection: [Int]
    let background: String
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String
    
    let queue: QueueUser

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        v =  try values.decode(Int.self, forKey: .v)
        uid =  try values.decode(String.self, forKey: .uid)
        phoneNumber =  try values.decode(String.self, forKey: .phoneNumber)
        email =  try values.decode(String.self, forKey: .email)
        fcMtoken =  try values.decode(String.self, forKey: .fcMtoken)
        nick =  try values.decode(String.self, forKey: .nick)
        birth =  try values.decode(String.self, forKey: .birth)
        gender =  try values.decode(Int.self, forKey: .gender)
        study =  try? values.decode(String.self, forKey: .study)
        comment =  try values.decode([String].self, forKey: .comment)
        reputation =  try values.decode([Int].self, forKey: .reputation)

        let imagenumber =  try values.decode(Int.self, forKey: .sesac)
        sesac = imagenumber == 0 ? "sesac_face_1" : "sesac_face_\(imagenumber)"
        
        sesacCollection =  try values.decode([Int].self, forKey: .sesacCollection)
        let backgroundnumber =  try values.decode(Int.self, forKey: .background)
        background = backgroundnumber == 0 ? "sesac_background_1" : "sesac_background_\(backgroundnumber)"
        
        backgroundCollection =  try values.decode([Int].self, forKey: .backgroundCollection)
        purchaseToken =  try values.decode([String].self, forKey: .purchaseToken)
        transactionID =  try values.decode([String].self, forKey: .transactionID)
        
        reviewedBefore =  try values.decode([String].self, forKey: .reviewedBefore)
        reportedNum =  try values.decode(Int.self, forKey: .reportedNum)
        reportedUser =  try values.decode([String].self, forKey: .reportedUser)
        dodgepenalty =  try values.decode(Int.self, forKey: .dodgepenalty)
        dodgeNum =  try values.decode(Int.self, forKey: .dodgeNum)
        ageMin =  try values.decode(Int.self, forKey: .ageMin)
        ageMax =  try values.decode(Int.self, forKey: .ageMax)
        searchable =  try values.decode(Int.self, forKey: .searchable)
        createdAt =  try values.decode(String.self, forKey: .createdAt)
        
        queue = QueueUser(uid: id,
                          nick: nick,
                          lat: 0,
                          long: 0,
                          reputation: reputation,
                          studylist: [],
                          reviews: comment,
                          gender: gender,
                          type: 0,
                          sesac: sesac,
                          background: background)
    }
    
}
