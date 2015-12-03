//
//  ArticleParser.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//
import Alamofire
import SwiftyJSON

class ArticleParser: Parser<Article> {
    override func getParser(responseObject:ResponseObject<Article>) -> ResponseSerializer<Article, NSError> {
        return ResponseSerializer { request, response, data, error in
            
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data else {
                let failureReason = "data is nil"
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let json = JSON(data: validData)
            let article = Article()
            let jarr = json["result"].arrayValue
            let a=jarr.count
            guard a > 0 else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            let subJ = jarr[0]
            article.author = subJ["author"]["nickname"].stringValue
            article.summary = subJ["summary"].stringValue
            article.title = subJ["title"].stringValue
            article.imageUrl = subJ["small_image"].stringValue
            article.date = subJ["date_published"].stringValue
            return .Success(article)
        }
    }
}

//extension Request {
//    static func XMLResponseSerializer() -> ResponseSerializer<Article, NSError> {
//        return ResponseSerializer { request, response, data, error in
//            guard error == nil else { return .Failure(error!) }
//            
//            guard let validData = data else {
//                let failureReason = "Data could not be serialized. Input data was nil."
//                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
//                return .Failure(error)
//            }
//            
//            do {
//                let XML = try ONOXMLDocument(data: validData)
//                return .Success(XML)
//            } catch {
//                return .Failure(error as NSError)
//            }
//        }
//    }
//    
//    public func responseXMLDocument(completionHandler: Response<ONOXMLDocument, NSError> -> Void) -> Self {
//        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
//    }
//}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
