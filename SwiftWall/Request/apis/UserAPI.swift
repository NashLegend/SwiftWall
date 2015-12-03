//
//  UserAPI.swift
//  Logon
//
//  Created by xiaoge on 15/11/19.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPI {
    static func login(res:(s1:String)->Void){
        Alamofire.request(.POST, "http://alpha.xiaoge.co/driver/login", parameters: ["phone": "18610857609","password": "123456789"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let j = response.result.value {
                    let json = JSON(j)
                    
                    print(json["code"])
                    print(json["message"])
                }
        }
    }
}
