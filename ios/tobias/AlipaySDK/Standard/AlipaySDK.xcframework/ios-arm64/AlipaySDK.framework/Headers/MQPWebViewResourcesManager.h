//
//  MQPWebViewPreManager.h
//  AlipaySDK
//
//  Created by intfre on 2025/3/5.
//  Copyright © 2025 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQPWebViewResourcesManager : NSObject
@property (assign, nonatomic) BOOL isEnable;
@property (nonatomic, strong) NSDictionary *nextH5ResourceInfo;

/// H5收银台提速相关，H5资源缓存，更新等
+ (MQPWebViewResourcesManager *)shared;



/// 当前资源版本
- (NSString *)resourcesVersion;



/// 返回当前本地的homeHtmlw文件路径
- (NSString *)localDocumentPath;


/// 从H5资源信息中更新本地H5资源
/// - Parameters:
///   - h5ResourceInfo: H5资源信息
///   - callback: 结果回调
- (void)updateResourcesFileWithH5ResourceInfo:(NSDictionary *)h5ResourceInfo callback:(void(^)(BOOL success,NSString *errCode)) callback;


@end

