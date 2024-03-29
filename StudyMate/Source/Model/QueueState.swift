//
//  QueueState.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/25.
//

import Foundation


// MARK: - QueueState
struct QueueState: Codable, Equatable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
    
    enum CodingKeys: String, CodingKey {
        case dodged, matched, reviewed
        case matchedNick, matchedUid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dodged = try values.decode(Int.self, forKey: .dodged)
        matched = try values.decode(Int.self, forKey: .matched)
        reviewed = try values.decode(Int.self, forKey: .reviewed)
        matchedNick = try values.decodeIfPresent(String.self, forKey: .matchedNick) ?? ""
        matchedUid = try values.decodeIfPresent(String.self, forKey: .matchedUid) ?? ""
    }
    
}
