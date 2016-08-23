//
//  NSTimer+HHOptimizeTimer.h
//  Timer循环引用
//
//  Created by huanghao on 16/8/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HHOptimizeTimer)
+(NSTimer *) HH_scheduledTimerWithTimeInterval:(NSTimeInterval) time
                                       repeats:(BOOL) repeats
                                         block:(void(^)())block;
@end
