//
//  UITableViewHeaderFooterView+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/3/29.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Additions.h"

@protocol XTTUITableViewHeaderFooterAdditionProtocol <NSObject>

@optional
- (instancetype)headerFooterWithInfo:(id)info;

- (CGFloat)headerFooterHeightWithInfo:(id)info;

// 在计算高度时指定contentView的宽度约束，不指定的话默认为屏幕宽度
@property (nonatomic) CGFloat headerFooterContentViewWidth;

@end

@interface UITableViewHeaderFooterView (Additions)<XTTUITableViewHeaderFooterAdditionProtocol>

@property (nonatomic, readonly) CGFloat xtt_heightAfterInitialization;

- (CGFloat)xtt_heightAfterInitializationWithContentWidth:(CGFloat)contentViewWidth;

@property (nonatomic, assign) NSInteger xtt_section;
@property (nonatomic, weak) UITableView* xtt_tableView;

@property (nonatomic, copy) void(^xtt_didSelectBlock)(NSInteger section);
@property (nonatomic, copy) void(^xtt_clickEventsBlock)(NSInteger section, id sender);
@property (nonatomic, copy) void(^xtt_clickFlagEventsBlock)(NSInteger section, id sender, int flag);

@end
