//
//  ResponseObject.swift
//  SwiftWall
//
//  Created by NashLegend on 15/12/2.
//  Copyright © 2015年 NashLegend. All rights reserved.
//

/**
 * Created by NashLegend on 2014/9/23 0023
 * 网络请求返回的数据，默认为错误结果
 */

import Foundation

class ResponseObject<T> {
    unowned var requestObject:RequestObject<T>//一个ResponseObject必定有一个RequestObject
    var ok:Bool = false
    var httpCode = -1;//http code，200，201，302，304，404，500等
    var error:NSError?
    var error_type = ResponseError.UNKNOWN_ERROR;//请求错误，断网，服务器错误等等
    var error_message = "";//其他错误的error_message，如NPE
    var code = ResponseCode.NONE;//json中返回的code
    var result:T? //网络请求返回的结果(已经parse过的)
    
    init(request:RequestObject<T>){
        self.requestObject = request
    }
    
    /**
    *  从一个ResponseObject中复制一部分，类型可能不一样，但是其他参数一样，用于ResponseObject类型转换
    *
    *  @param object object description
    */
    func copyPartFrom(object:ResponseObject) {
        requestObject = RequestObject<T>();
        requestObject.copyPartFrom(object.requestObject);
        httpCode = object.httpCode;
        error_type = object.error_type;
        error_message = object.error_message;
        code = object.code;
    }
    
    func toString()->String {
        return result == nil ? "" : String(result)
    }
    
    func dump()->String {
        var err = ""
        err+="ok:"+String(ok)+"\n";
        err+="statusCode:"+String(httpCode)+"\n"
        err+="error:"+String(error_type)+"\n"
        err+="error_message:"+error_message+"\n"
        err+="code:"+String(code)+"\n"
        err+="result:"+String(result)+"\n"
        err+="requestObject:\n"+requestObject.dump()
        return err
    }
    
}

