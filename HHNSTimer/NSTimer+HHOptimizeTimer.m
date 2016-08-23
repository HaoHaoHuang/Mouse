//
//  NSTimer+HHOptimizeTimer.m
//  Timer循环引用
//
//  Created by huanghao on 16/8/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "NSTimer+HHOptimizeTimer.h"

@implementation NSTimer (HHOptimizeTimer)
+ (NSTimer *)HH_scheduledTimerWithTimeInterval:(NSTimeInterval)time repeats:(BOOL)repeats block:(void (^)())block
{
    return [self scheduledTimerWithTimeInterval:time target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void) blockInvoke:(NSTimer *) timer
{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
