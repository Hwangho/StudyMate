//
//  ResponseWrapper.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/16.
//

import Foundation


protocol ModelType: Decodable {
    
}

extension ModelType {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}


struct ResponseWrapper<T: Decodable & Equatable>: ModelType, Decodable {
    var statusCode: Int
    var data: T?
    var error: Error?
    
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decode(Int.self, forKey: .statusCode)
        data = try? values.decode(T.self, forKey: .data)
    }
}






/// response 에 데이터가 없는 경우
struct NoneResponseWrapper<T>: Decodable {
    var statusCode: Int
    var data: T?
    var error: Error?
    
    
    enum CodingKeys: String, CodingKey {
        case statusCode
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decode(Int.self, forKey: .statusCode)
    }
    
}
