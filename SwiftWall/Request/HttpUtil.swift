//
//  HttpUtil.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Alamofire
import SwiftyJSON

class HttpUtil {
    
    static func get<T>(url:String,params:[String: String],parser:Parser<T>?,completionHandler: Response<T, NSError> -> Void){
        Alamofire.request(.GET, url, parameters: params).response(responseSerializer: parser!.getParser(),completionHandler:completionHandler)
    }
    
    static func post<T>(url:String,params:[String: String],parser:Parser<T>?,completionHandler: Response<T, NSError> -> Void){
        Alamofire.request(.POST, url, parameters: params).response(responseSerializer: parser!.getParser(),completionHandler:completionHandler)
    }
    
}
















