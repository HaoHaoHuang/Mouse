//
//  NSObject+PerformOnce.m
//  XXTT
//
//  Created by haohuang on 16/6/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "NSObject+PerformOnce.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableDictionary* performOnce_mBlockPerfomTokens;
@property (nonatomic, strong, readonly) NSMutableSet* xtt_availabilityTokens;

@end

@implementation NSObject (PerformOnce)

- (BOOL)xtt_hasPerformOnceToken:(const void *)onceToken
{
    id onceFlag = objc_getAssociatedObject(self, onceToken);
    if (!onceFlag) {
        objc_setAssociatedObject(self, onceToken, @"onceFlag", OBJC_ASSOCIATION_RETAIN);
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL (^)(const void *))xtt_hasPerformOnce
{
    BOOL (^onceBlock)(const void *) = objc_getAssociatedObject(self, __func__);
    if (!onceBlock) {
        
        __weak typeof(self) ws = self;
        onceBlock = ^BOOL (const void* onceToken) {
            return [ws xtt_hasPerformOnceToken:onceToken];
        };
        objc_setAssociatedObject(self, __func__, onceBlock, OBJC_ASSOCIATION_COPY);
    }
    return onceBlock;
}

- (BOOL)xtt_disablePerformForToken:(const void *)token
{
    NSString* tokenStr = [NSString stringWithFormat:@"%s", token];
    NSNumber* disableValue = [self.performOnce_mBlockPerfomTokens valueForKey:tokenStr];
    if (!disableValue) {
        disableValue = @(YES);
        [self.performOnce_mBlockPerfomTokens setValue:disableValue forKey:tokenStr];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)xtt_enablePerformForToken:(const void *)token
{
    NSString* tokenStr = [NSString stringWithFormat:@"%s", token];
    [self.performOnce_mBlockPerfomTokens removeObjectForKey:tokenStr];
}

- (NSMutableDictionary *)performOnce_mBlockPerfomTokens
{
    NSMutableDictionary* mDic = objc_getAssociatedObject(self, _cmd);
    if (!mDic) {
        mDic = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, _cmd, mDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mDic;
}

- (BOOL)xtt_availableForToken:(const void *)token
{
    NSString* tokenStr = [NSString stringWithFormat:@"%s", token];
    return [self.xtt_availabilityTokens containsObject:tokenStr];
}

- (void)xtt_makeAvailableForToken:(const void *)token
{
    NSString* tokenStr = [NSString stringWithFormat:@"%s", token];
    [self.xtt_availabilityTokens addObject:tokenStr];
}

- (void)xtt_makeUnavailableForToken:(const void *)token
{
    NSString* tokenStr = [NSString stringWithFormat:@"%s", token];
    [self.xtt_availabilityTokens removeObject:tokenStr];
}

- (NSMutableSet *)xtt_availabilityTokens
{
    NSMutableSet* mSet = objc_getAssociatedObject(self, _cmd);
    if (!mSet) {
        mSet = [NSMutableSet setWithCapacity:1];
        objc_setAssociatedObject(self, _cmd, mSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mSet;
}

@end
