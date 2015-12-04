//
//  BaseModelParser.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/4.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseModelParser : Parser<BaseModel> {
    override func parse(json:JSON)  -> Result<BaseModel, NSError>  {
        //所有Model都有fromJson方法的话，那么每个类都有一个Parser并且每个Parser只有一句话xxx.fromJson，那样太无聊了
        //所以最好写在一个统一的BaseModelParser里面，然而有两个问题：
        //一：BaseModelParser继承了Parser，而其类型不能使用T:BaseModelParser了，只能使用一个指定的实体类了，这样就不能一个Parser返回多种类型
        //二：不能保证所有的BaseModelParser的subclass都继承了fromJson，swift没有强制，使用protocol也没用，并且也不能强制子类返回子类自己的类型
        //要解决这个问题，难道只能反射+强转？
        return Result.Failure(json["code"].error!)
    }
}
