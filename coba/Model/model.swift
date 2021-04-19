//
//  model.swift
//  coba
//
//  Created by H, Alfatkhu on 16/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import SQLite


@objc protocol ModelDelegate: class {
    @objc optional func starting(model:Model)
    @objc optional func cancelForModel(model:Model)
    
    @objc func modeldoneWithData(model:Model, result:Any)
    @objc func modelfailedWithError(model:Model, error:NSError)
}

class Model: NSObject {
    weak var delegate: ModelDelegate?
    var apiName: String?
    public internal(set) var _apiName: String {
        get {
            return self.apiName!
        }
        set {
            self.apiName = newValue
        }
    }
    
    func createURL() -> String {
        return "https://api.opendota.com/api/herostats"
    }
    
    
    func fetchWithDelegate(_delegate: ModelDelegate) {
        delegate = _delegate
        // All three of these calls are equivalent
        AF.request(self.createURL(), method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.value {
                _delegate.modeldoneWithData(model: self, result: json)
            }
            else {
                _delegate.modelfailedWithError(model: self, error: NSError(domain: self.createURL(), code: 500, userInfo: nil))
            }
        }
    }
}
