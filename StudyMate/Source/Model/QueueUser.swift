//
//  QueueUser.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//

import Foundation


// MARK: - FromQueueDB
struct QueueUser: Codable, Hashable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type: Int
    let sesac, background: String
    
    
    enum CodingKeys: String, CodingKey {
        case uid, nick, lat, long, reputation, studylist, reviews, gender, type
        case sesac, background
    }
    
    init(uid: String, nick: String, lat: Double, long: Double, reputation: [Int], studylist: [String], reviews: [String], gender: Int, type: Int, sesac: String, background: String) {
        self.uid = uid
        self.nick = nick
        self.lat = lat
        self.long = long
        self.reputation = reputation
        self.studylist = studylist
        self.reviews = reviews
        self.gender = gender
        self.type = type
        self.sesac = sesac
        self.background = background
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        uid = try values.decode(String.self, forKey: .uid)
        nick =  try values.decode(String.self, forKey: .nick)
        lat =  try values.decode(Double.self, forKey: .lat)
        long =  try values.decode(Double.self, forKey: .long)
        reputation =  try values.decode([Int].self, forKey: .reputation)
        studylist =  try values.decode([String].self, forKey: .studylist)
        reviews =  try values.decode([String].self, forKey: .reviews)
        gender =  try values.decode(Int.self, forKey: .gender)
        type =  try values.decode(Int.self, forKey: .type)

        let imagenumber =  try values.decode(Int.self, forKey: .sesac)
        sesac = imagenumber == 0 ? "sesac_face_1" : "sesac_face_\(imagenumber)"

        let backgroundnumber =  try values.decode(Int.self, forKey: .background)
        background = backgroundnumber == 0 ? "sesac_background_1" : "sesac_background_\(backgroundnumber)"
    }
}
