//
//  UIView+Masonry_entension.h
//  Masory_entension
//
//  Created by bjhl on 16/8/24.
//  Copyright © 2016年 bjhl. All rights reserved.
// 等间距view

#import <UIKit/UIKit.h>

@interface UIView (Masonry_EquallySpaced)
//
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) distributeSpacingVerticallyWith:(NSArray*)views;

@end
