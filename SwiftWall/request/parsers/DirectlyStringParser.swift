//
//  DirectlyStringParser.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Alamofire
/// 直接返回请求得到的字符串
class DirectlyStringParser: Parser<String> {
    override func getParser(inout responseObject:ResponseObject<String>) -> ResponseSerializer<String, NSError> {
        
        return ResponseSerializer { request, response, data, error in
            
            if response?.statusCode != nil {
                responseObject.httpCode = (response?.statusCode)!
            }else{
                responseObject.httpCode = -1
            }
            
            var encoding:NSStringEncoding?
            
            guard error == nil else { return .Failure(error!) }
            
            if let response = response where response.statusCode == 204 { return .Success("") }
            
            guard let validData = data else {
                let failureReason = "String could not be serialized. Input data was nil."
                responseObject.error_message = failureReason
                let error = Error.errorWithCode(.StringSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            if let encodingName = response?.textEncodingName where encoding == nil {
                encoding = CFStringConvertEncodingToNSStringEncoding(
                    CFStringConvertIANACharSetNameToEncoding(encodingName)
                )
            }
            
            let actualEncoding = encoding ?? NSISOLatin1StringEncoding
            
            if let string = String(data: validData, encoding: actualEncoding) {
                return .Success(string)
            } else {
                let failureReason = "String could not be serialized with encoding: \(actualEncoding)"
                let error = Error.errorWithCode(.StringSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
        }
    }
}
