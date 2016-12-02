//
//  UIWindow+StatusBarGesture.m
//  XXTT
//
//  Created by haohuang on 16/6/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UIWindow+StatusBarGesture.h"
#import "NSObject+XTTResponder.h"
#import <objc/runtime.h>


static UITapGestureRecognizer* xtt_tapGesture = nil;
static UITapGestureRecognizer* xtt_debugTapGesture = nil;


NSString* const TTStatusBarTapOnceNotification = @"TTStatusBarTapOnceNotification";
NSString* const TTDebugStatusBarTapNotification = @"TTDebugStatusBarTapNotification";

@implementation UIWindow (StatusBarGesture)
/*
- (BOOL)_isScrollingEnabledForView:(UIScrollView*)testView
{
    if ([testView isKindOfClass:[UIScrollView class]]) {
        [testView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}
 */

+ (void)load
{
    Method orisetWindowLevelMethod = class_getInstanceMethod([self class], @selector(setWindowLevel:));
    Method newsetWindowLevelMethod = class_getInstanceMethod([self class], @selector(tt_setWindowLevel:));
    method_exchangeImplementations(orisetWindowLevelMethod, newsetWindowLevelMethod);
}

- (void)tt_setWindowLevel:(UIWindowLevel)windowLevel
{
    [self tt_setWindowLevel:windowLevel];
    
    if (windowLevel == UIWindowLevelStatusBar) {
        
        if (!xtt_tapGesture) {
            xtt_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xtt_statusBarTapped:)];
            [self addGestureRecognizer:xtt_tapGesture];
        }
        
#if !defined(XTT_FINAL_RELEASE)
        if (!xtt_debugTapGesture) {
            xtt_debugTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xtt_debugStatusBarTapped:)];
            xtt_debugTapGesture.numberOfTapsRequired = 5;
            [self addGestureRecognizer:xtt_debugTapGesture];
            
//            [xtt_tapGesture requireGestureRecognizerToFail:xtt_debugTapGesture];
        }
#endif
        
#ifdef _TARGET_ORIGIN_XXTT_SDK_
        [UIWindow xtt_enableStatusBarGesture:NO];
#endif
    }
}

- (void)xtt_statusBarTapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"statusBarTapped");
    [self xtt_scrollViewScrollToTop];
    [[NSNotificationCenter defaultCenter] postNotificationName:TTStatusBarTapOnceNotification object:nil];
}

- (void)xtt_debugStatusBarTapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"statusBarMutiTapped");
    [[NSNotificationCenter defaultCenter] postNotificationName:TTDebugStatusBarTapNotification object:nil];
}

+ (void)xtt_enableStatusBarGesture:(BOOL)enable
{
    xtt_tapGesture.enabled = enable;
    xtt_debugTapGesture.enabled = enable;
}

@end
