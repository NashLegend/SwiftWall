//
//  ArticleAPI.swift
//  SwiftWall
//
//  Created by NashLegend on 15/11/20.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ArticleAPI {
    
    static func getArticleListIndexPage(offset:Int,callback:(result:ResponseObject<Article>)->Void){
        let url = "http://www.guokr.com/apis/minisite/article.json";
        RequestBuilder().setUrl(url)
            .setMethod(.GET)
            .setParams(["retrieve_type": "by_subject","limit": "1","offset": "0"])
            .setParser(ArticleParser())
            .setCallBack(callback)
            .requestAsync()
    }
}
