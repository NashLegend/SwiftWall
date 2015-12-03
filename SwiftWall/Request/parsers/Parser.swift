//
//  BaseParser.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Alamofire

class Parser <T> {
    
    func getParser(responseObject:ResponseObject<T>) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            return .Failure(error! as NSError)
        }
    }
}