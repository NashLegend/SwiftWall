// 
// RequestBuilder.swift
// Logon
// 
// Created by xiaoge on 15/12/2.
// Copyright © 2015年 NashLegend. All rights reserved.
// 
import Alamofire

class RequestBuilder<T> {

	var rbRequest = RequestObject<T>();

	var useToken = true;// 是否使用token，默认使用

	/**
	 * 设置请求方法
	 * {@link RequestObject.Method#GET}
	 * {@link RequestObject.Method#POST}
	 * {@link RequestObject.Method#PUT}
	 * {@link RequestObject.Method#DELETE}
	 *
	 * @param method
	 * @return
	 */
	func setMethod(method: Method) -> RequestBuilder<T> {
		rbRequest.method = method;
		return self;
	}

	/**
	 * 设置键值对请求参数，如果之前曾经设置过，则将会清空之前的参数
	 *
	 * @param params
	 * @return
	 */
	func setParams(params: [String: String]) -> RequestBuilder<T> {
		rbRequest.params = params;
		return self;
	}

	/**
	 * 在当前参数的基础上再添加几个键值对请求参数
	 *
	 * @param params
	 * @return
	 */
	func addParams(params: [String: String]) -> RequestBuilder<T> {
		for (ki, nam) in params {
			rbRequest.params[ki] = nam
		}
		return self;
	}

	/**
	 * 在当前参数的基础上添加一条键值对请求参数
	 *
	 * @param key
	 * @param value
	 * @return
	 */
	func addParam(key: String, value: String) -> RequestBuilder<T> {
		rbRequest.params[key] = value;
		return self;
	}

	/**
	 * 如果不设置parser或者callback则不会收到回调
	 *
	 * @param parser
	 * @return
	 */
	func setParser(parser: Parser<T>) -> RequestBuilder<T> {
		rbRequest.parser = parser;
		return self;
	}

	/**
	 * 同步请求不支持重试,上传不支持重试
	 *
	 * @param maxTimes 重试次数，不包括原本的第一次请求
	 * @param interval 请求间隔
	 * @return
	 */
	func setRetry(maxTimes: Int , interval: Int ) -> RequestBuilder<T> {
		if (maxTimes > 0) {
			rbRequest.retryHandler = RetryHandler<T>(maxTimes: maxTimes, span: interval)
		}
		return self;
	}

	/**
	 * 设置请求地址
	 *
	 * @param url
	 * @return
	 */
    func setUrl(url:String)  -> RequestBuilder<T> {
		rbRequest.url = url;
		return self;
	}

	/**
	 * 设置是否使用token，默认为true，即使用token
	 *
	 * @param use
	 * @return
	 */
    func setWithToken(use:Bool) -> RequestBuilder<T> {
		useToken = use;
		return self;
	}

	/**
	 * 上传文件的Key
	 *
	 * @param key
	 * @return
	 */
    func setUploadParamKey(key:String) -> RequestBuilder<T> {
		rbRequest.uploadParamKey = key;
		return self;
	}

	/**
	 * 设置请求成功或者失败后的回调，如果没有parser，将不会回调
	 *
	 * @param callBack
	 * @return
	 */
    func setCallBack(callBack:(result:ResponseObject<T>)->Void ) -> RequestBuilder<T> {
		rbRequest.callBack = callBack;
		return self;
	}

	func addToken() {
		if (useToken) {
            var token:String?
            token = "123"
            //todo
            if token != nil {
                rbRequest.params["token"] = token!
            }
		}
	}

	/**
	 * 异步请求
	 */
	func requestAsync()->Request {
		addToken();
		rbRequest.requestType = RequestType.PLAIN;
		return rbRequest.requestAsync();
	}

}

