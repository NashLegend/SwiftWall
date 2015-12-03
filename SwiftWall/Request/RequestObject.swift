// 
// RequestObject.swift
// SwiftWall
// 
// Created by NashLegend on 15/12/2.
// Copyright © 2015年 NashLegend. All rights reserved.
// 

/**
 * Created by NashLegend on 2015/9/23 0023.
 * 网络请求的对象
 */
import Foundation
import Alamofire
import SwiftyJSON

class RequestObject<T>{

	var requestType = RequestType.PLAIN;

	var method = Method.POST;

	var params = [String: String]()

	var url = "";

    var callBack: ((result:ResponseObject<T>)->Void)?

	var parser: Parser<T>?;
    
    var retryHandler:RetryHandler<T>?

	var uploadParamKey = "file";

	var filePath = "";
    
    var responseObject:ResponseObject<T>?

	func copyPartFrom(object: RequestObject) {
		params = object.params;
		method = object.method;
		url = object.url;
		uploadParamKey = object.uploadParamKey;
	}
    
    func getInnerCompletionHandler(responseObject:ResponseObject<T>)->(response:Response<T, NSError>)->Void{
        let innerCompletionHandler = { (response:Response<T, NSError>) in
            //其他参数放在parser里面搞起
            responseObject.ok = response.result.isSuccess
            responseObject.result = response.result.value
            responseObject.error = response.result.error
            self.callBack!(result: responseObject)
        }
        return innerCompletionHandler
    }
    
	/**
	 * 异步请求
	 */
	func requestAsync()->Request {
        responseObject = ResponseObject<T>(request: self)
        if method == .GET {
            return get(url, params: params,parser: parser,completionHandler: getInnerCompletionHandler(responseObject!));
        }else{
            return post(url, params: params,parser: parser,completionHandler: getInnerCompletionHandler(responseObject!));
        }
	}
    
    func get(url:String,params:[String: String],parser:Parser<T>?,completionHandler: Response<T, NSError> -> Void)->Request{
        if parser != nil && callBack != nil {
            return Alamofire.request(.GET, url, parameters: params).response(responseSerializer: parser!.getParser(responseObject!),completionHandler:completionHandler)
        }else{
            return Alamofire.request(.GET, url, parameters: params)
        }
    }
    
    func post(url:String,params:[String: String],parser:Parser<T>?,completionHandler: Response<T, NSError> -> Void)->Request{
        if parser != nil && callBack != nil {
            return Alamofire.request(.POST, url, parameters: params).response(responseSerializer: parser!.getParser(responseObject!),completionHandler:completionHandler)
        }else{
            return Alamofire.request(.POST, url, parameters: params)
        }
    }

	/**
	 * 异步请求出错
	 *
	 * @param e
	 * @param result
	 */
	func onRequestFailure(e: ErrorType, result: ResponseObject<T> ) {
		if (requestType == RequestType.PLAIN
			&& retryHandler != nil
			&& !retryHandler!.isTerminated()
			&& retryHandler!.shouldHandNotifier(e, responseObject: result)) {
			if (retryHandler!.span > 0) {
				//todo 间隔
                requestAsync();
			} else {
				requestAsync();
			}
			retryHandler!.notifyAction();
		} else {
			if (callBack != nil) {
                callBack!(result: result)
			}
		}
	}

	func dump()->String {
		var err = ""
		err += "    params:" + params2String() + "\n"
        err += "    method:" + method.rawValue + "\n"
        err += "    url:" + url + "\n"
		if (requestType == RequestType.UPLOAD) {
			err+="    uploadParamKey:"+uploadParamKey+"\n"
		}
		return err
	}
    
    func params2String()->String{
        var ps = "{";
        for (key,value) in params {
            ps += key + "=" + value + ","
        }
        ps += "}"
        return ps
    }
    
    
}

/**
 * http 请求方法
 */
class RequestType {
	static let PLAIN = 0;
	static let UPLOAD = 1;
	static let DOWNLOAD = 2;
}

class RetryHandler<T> {
	var maxTimes = 0;// 最大重试次数
	var span = 0;// 重试间隔
	var crtTime = 0;// 当前重试次数
	var terminated = false

	init(maxTimes: Int, span: Int) {
		self.maxTimes = maxTimes;
		self.span = span;
	}

	func shouldHandNotifier(exception: ErrorType, responseObject: ResponseObject<T>) -> Bool {
		return responseObject.code != ResponseCode.TOKEN_INVALID
		&& responseObject.code != ResponseCode.SEVER_MAINTAINING
		&& crtTime < maxTimes
        && (responseObject.statusCode<300||responseObject.statusCode>=500)
        && !terminated;
}

func notifyAction(){
    crtTime++;
    if(crtTime >= maxTimes) {
        terminate();
    }
}

func terminate() {
	terminated = true;
}

func isTerminated() -> Bool {
	return terminated;
}
}
