//
//  NSObject+PerformOnce.h
//  XXTT
//
//  Created by haohuang on 16/6/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformOnce)

@property (nonatomic, copy, readonly) BOOL(^xtt_hasPerformOnce)(const void *onceToken);

- (BOOL)xtt_hasPerformOnceToken:(const void *)onceToken;

// 防止方法重复连续调用
- (BOOL)xtt_disablePerformForToken:(const void *)token;
- (void)xtt_enablePerformForToken:(const void *)token;

// 添加标志量
- (BOOL)xtt_availableForToken:(const void*)token;
- (void)xtt_makeAvailableForToken:(const void*)token;
- (void)xtt_makeUnavailableForToken:(const void*)token;

@end
