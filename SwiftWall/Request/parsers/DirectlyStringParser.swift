//
//  DirectlyStringParser.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//
import Alamofire

class DirectlyStringParser: Parser<String> {
    override func getParser(responseObject:ResponseObject<String>) -> ResponseSerializer<String, NSError> {
        return ResponseSerializer { request, response, data, error in
            return .Failure(error! as NSError)
        }
    }
}
