//
//  Service.swift
//  coba
//
//  Created by H, Alfatkhu on 16/04/21.
//

import Foundation
import Alamofire

class Service:Model{
    override var _apiName: String {
        get {
            return super.apiName!
        }
        set {
            super._apiName = newValue
        }
    }
}


