/**
 * Created by NashLegend on 2015/10/26 0026.
 */

import Alamofire
import SwiftyJSON

class ContentBooleanParser : Parser<Bool> {
    override func parse(json:JSON)-> Result<Bool, NSError>{
        if let bl = json.bool {
            return Result.Success(bl)
        }else {
            return Result.Failure(json["code"].error!)
        }
    }
}
