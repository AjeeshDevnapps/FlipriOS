//
//  PlaceTypeRouter.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 30/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation
import Alamofire

class PlaceRouter {
    func getPlaceTypes(completion: ((_ types:PlaceTypes?,_ error:Error?) -> Void)?) {
        Alamofire.request(Router.getPlaceTypes).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    do {
                        let placeTypes = try JSONDecoder().decode(PlaceTypes.self, from: data)
                        completion?(placeTypes, nil)
                    } catch let error {
                        completion?(nil, error)
                    }
                }
            case .failure(let error):
                if let serverError = User.serverError(response: response) {
                    completion?(nil, serverError)
                } else {
                    completion?(nil, error)
                }
            }
        }
    }
}
