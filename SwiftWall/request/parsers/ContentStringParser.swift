//
//  StringParser.swift
//  ShipperClientIOS
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ContentStringParser : Parser<String> {
    override func parse(json:JSON)  -> Result<String, NSError>  {
        return Result.Success(json.stringValue)
    }
}

