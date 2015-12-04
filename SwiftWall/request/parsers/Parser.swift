//
//  BaseParser.swift
//  SwiftWall
//
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

//    usage

//    RequestBuilder().setUrl(url)
//    .setMethod(.GET)
//    .setParams(["retrieve_type": "by_subject","limit": "3","offset": "0"])
//    .setParser(ArticleParser())
//    .setCallBack(callback)
//    .requestAsync()

//class ArticleParser: Parser<Array<Article>> {
//    override func parse(inout responseObject: ResponseObject<Array<Article>>, json:JSON)-> Result<Array<Article>, NSError>{
//        if let jarr = json.array {
//            var articleList = [Article]()
//            let a = jarr.count
//            for var i = 0;i < a;i++ {
//                let article = Article.fromJson(jarr[0])
//                articleList.append(article)
//            }
//            return Result.Success(articleList)
//        }else {
//            responseObject.code = -1
//            return Result.Failure(json["code"].error!)
//        }
//    }
//}

import Alamofire
import SwiftyJSON

class Parser <T> {
    /**
     * 子类需要override这个方法，在此方法中只需要返回Result.Success或者Result.Failure
     */
    func parse(json:JSON)-> Result<T, NSError>{
        let failureReason = "not implemented"
        let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
        return .Failure(error as NSError)
    }
    
    func getParser(inout responseObject: ResponseObject<T>) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer {request, response, data, error in
            return self.firstCheck(&responseObject, request: request, response: response, data: data, error: error)
        }
    }
    
    func firstCheck(inout responseObject: ResponseObject<T>, request:NSURLRequest?, response:NSHTTPURLResponse?, data:NSData?, error:NSError?)-> Result<T, NSError>  {
        if response?.statusCode != nil {
            responseObject.httpCode = (response?.statusCode)!
        }else{
            responseObject.httpCode = -1
        }
        guard error == nil else {
            return Result.Failure(error!)
        }
        guard let validData = data else {
            let failureReason = "data is nil"
            responseObject.error_message = "data is nil"
            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
        let json = JSON(data: validData)
        if let code = json["ok"].bool {
            responseObject.code = Int(code)
            if !code {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason) // TODO
                return .Failure(error)
            } else {
                // code为0 正式进行处理
                return parse(json["result"])
            }
        }else {
            responseObject.code = -1
            return Result.Failure(json["code"].error!)
        }
    }
}