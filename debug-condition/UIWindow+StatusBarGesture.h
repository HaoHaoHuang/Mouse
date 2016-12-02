//
//  UIWindow+StatusBarGesture.h
//  XXTT
//
//  Created by haohuang on 16/6/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const TTStatusBarTapOnceNotification;

// 用于debug时环境切换
extern NSString* const TTDebugStatusBarTapNotification;

@interface UIWindow (StatusBarGesture)

+ (void)xtt_enableStatusBarGesture:(BOOL)enable;

@end
