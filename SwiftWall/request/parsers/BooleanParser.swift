/**
 * Created by NashLegend on 2015/10/6 0006.
 * 简单的判断是否返回code为0，只要是0，就会进入onResponse，否则进入onFailure.
 * 因此onResponse处肯定为true
 */

import Alamofire
import SwiftyJSON

class BooleanParser : Parser<Bool> {
    override func firstCheck(inout responseObject: ResponseObject<Bool>, request:NSURLRequest?, response:NSHTTPURLResponse?, data:NSData?, error:NSError?)-> Result<Bool, NSError>  {
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
            responseObject.error_message = failureReason
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
                return Result.Success(true)
            }
        }else {
            responseObject.code = ResponseCode.NONE
            return Result.Failure(json["code"].error!)
        }
    }
    
}
