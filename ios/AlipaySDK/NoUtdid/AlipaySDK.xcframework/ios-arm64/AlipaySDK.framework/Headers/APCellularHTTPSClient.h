//
//  APCellularConnectionUtil.h
//  AlipaySDK
//
//  Created by intfre on 2025/9/11.
//  Copyright © 2025 Alipay. All rights reserved.
//

// CellularHttpClient.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * 定义请求完成后的回调 Block。
 * @param data 响应体数据，如果请求失败则为 nil。
 * @param response HTTP响应对象，包含状态码和头信息，如果请求失败则为 nil。
 * @param error 如果请求过程中发生错误，则为具体的错误信息。
 */
typedef void (^CellularRequestCompletionHandler)(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error);




@interface APCellularRequest : NSObject

/// 请求的URL
@property (nonatomic, strong) NSURL *url;

/// HTTP方法 (e.g., "GET", "POST"). 默认为 "GET".
@property (nonatomic, copy) NSString *httpMethod;

/// 请求体数据，对于GET请求通常为nil
@property (nonatomic, strong, nullable) NSData *httpBody;

/// 请求头字典
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;

/**
 * 便利初始化方法，用于创建一个简单的GET请求。
 * @param url 请求的URL。
 */
- (instancetype)initWithURL:(NSURL *)url;

@end


/**
 * 一个专门用于通过蜂窝网络强制发送HTTPS请求的客户端。
 *
 * 注意：此类不处理HTTP重定向、Cookie、缓存等高级功能。
 * 它仅用于在Wi-Fi和蜂窝网络同时可用时，强制通过蜂窝网络进行简单的GET请求。
 */
@interface APCellularHTTPSClient : NSObject

/**
 * 发送一个HTTPS GET请求，并强制其通过蜂窝网络。
 *
 * @param request 要请求的URL，必须是https协议。
 * @param completionHandler 请求完成后的回调。
 */
- (void)sendRequest:(APCellularRequest *)request completion:(CellularRequestCompletionHandler)completionHandler;

/**
 * 取消当前正在进行的请求。
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
