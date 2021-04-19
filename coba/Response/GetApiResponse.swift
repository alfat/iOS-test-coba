//
//  GetApiResponse.swift
//  coba
//
//  Created by H, Alfatkhu on 16/04/21.
//

import Foundation

struct GetApiResponse {
    let crew : [herostats]
    
    init(json: JSON) throws {
        guard let results = json["results"] as? [JSON] else {throw NetworkingError.badNetworkingRequest}
        let crews = results.count
       print("crews",crews)
    }
}
