/**
 * Created by NashLegend on 2015/10/13 0013.
 * 返回一个json 的数字
 */

import Foundation
import Alamofire
import SwiftyJSON

class ContentNumberParser : Parser<NSNumber> {
    override func parse(json:JSON) -> Result<NSNumber, NSError>  {
        if let nm = json.number {
            return Result.Success(nm)
        }else {
            return Result.Failure(json["code"].error!)
        }
    }
}
