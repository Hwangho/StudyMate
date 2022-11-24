//
//  Queue.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/24.
//

import Foundation


// MARK: - MyInfo
struct Queue: Codable, Hashable {
    let fromQueueDB: [QueueUser]
    let fromQueueDBRequested: [QueueUser]
    let fromRecommend: [String]

}
