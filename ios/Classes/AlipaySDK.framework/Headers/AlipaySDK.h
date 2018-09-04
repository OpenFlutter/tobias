//
//  AlipaySDK.h
//  AlipaySDK
//
//  Created by antfin on 17-10-24.
//  Copyright (c) 2017年 AntFin. All rights reserved.
//


////////////////////////////////////////////////////////
///////////////// 支付宝标准版本支付SDK ///////////////////
/////////// version:15.5.5  motify:2018.05.09 ///////////
////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "APayAuthInfo.h"

typedef void(^CompletionBlock)(NSDictionary *resultDic);


@interface AlipaySDK : NSObject

/**
 *  创建支付单例服务
 *
 *  @return 返回单例对象
 */
+ (AlipaySDK *)defaultService;

/**
 *  用于设置SDK使用的window，如果没有自行创建window无需设置此接口
 */
@property (nonatomic, weak) UIWindow *targetWindow;

/**
 *  支付接口
 *
 *  @param orderStr       订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param completionBlock 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
 */
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;

/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl        支付结果url
 *  @param completionBlock  支付结果回调
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock;

/**
 *  获取交易token。
 *
 *  @return 交易token，若无则为空。
 */
- (NSString *)fetchTradeToken;

/**
 *  是否已经使用过
 *
 *  @return YES为已经使用过，NO反之
 */
- (BOOL)isLogined;

/**
 *  获取当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion;

/**
 *  測試所用，realse包无效
 *
 *  @param url  测试环境
 */
- (void)setUrl:(NSString *)url;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////h5 拦截支付入口///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  从h5链接中获取订单串并支付接口（自版本15.4.0起，推荐使用该接口）
 *
 *  @param urlStr     拦截的 url string
 *
 *  @return YES为成功获取订单信息并发起支付流程；NO为无法获取订单信息，输入url是普通url
 */
- (BOOL)payInterceptorWithUrl:(NSString *)urlStr
                   fromScheme:(NSString *)schemeStr
                     callback:(CompletionBlock)completionBlock;

/**
 *  从h5链接中获取订单串接口（自版本15.4.0起已废弃，请使用payInterceptorWithUrl...）
 *
 *  @param urlStr     拦截的 url string
 *
 *  @return 获取到的url order info
 */
- (NSString*)fetchOrderInfoFromH5PayUrl:(NSString*)urlStr;


/**
 *  h5链接获取到的订单串支付接口（自版本15.4.0起已废弃，请使用payInterceptorWithUrl...）
 *
 *  @param orderStr       订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param completionBlock 支付结果回调Block
 */
- (void)payUrlOrder:(NSString *)orderStr
         fromScheme:(NSString *)schemeStr
           callback:(CompletionBlock)completionBlock;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////授权2.0//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  快登授权2.0
 *
 *  @param infoStr          授权请求信息字符串
 *  @param schemeStr        调用授权的app注册在info.plist中的scheme
 *  @param completionBlock  授权结果回调，若在授权过程中，调用方应用被系统终止，则此block无效，
 需要调用方在appDelegate中调用processAuth_V2Result:standbyCallback:方法获取授权结果
 */
- (void)auth_V2WithInfo:(NSString *)infoStr
             fromScheme:(NSString *)schemeStr
               callback:(CompletionBlock)completionBlock;

/**
 *  处理授权信息Url
 *
 *  @param resultUrl        钱包返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////授权1.0 (授权1.0接口即将废弃，请使用授权2.0接口)///////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  快登授权
 *  @param authInfo         需授权信息
 *  @param completionBlock  授权结果回调，若在授权过程中，调用方应用被系统终止，则此block无效，
                            需要调用方在appDelegate中调用processAuthResult:standbyCallback:方法获取授权结果
 */
- (void)authWithInfo:(APayAuthInfo *)authInfo
             callback:(CompletionBlock)completionBlock;


/**
 *  处理授权信息Url
 *
 *  @param resultUrl        钱包返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)processAuthResult:(NSURL *)resultUrl
          standbyCallback:(CompletionBlock)completionBlock;


@end
