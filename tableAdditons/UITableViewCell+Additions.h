//
//  UITableViewCell+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Additions.h"

@protocol XTTUITableViewCellAdditionProtocol <NSObject>

@optional
- (instancetype)cellWithInfo:(id)info;

- (CGFloat)cellHeightWithInfo:(id)info;

// 在计算高度时指定contentView的宽度约束，不指定的话默认为屏幕宽度
@property (nonatomic) CGFloat cellContentViewWidth;

@end

@interface UITableViewCell (Additions)<XTTUITableViewCellAdditionProtocol>

@property (nonatomic, readonly) CGFloat xtt_heightAfterInitialization;

- (void)xtt_reloadMySelfWithRowAnimation:(UITableViewRowAnimation)animation;

- (CGFloat)xtt_heightAfterInitializationWithContentWidth:(CGFloat)contentViewWidth;

@property (nonatomic, retain) NSIndexPath* xtt_indexPath;
@property (nonatomic, weak) UITableView* xtt_tableView;

@property (nonatomic, copy) void(^xtt_didSelectBlock)(NSIndexPath* indexPath);
@property (nonatomic, copy) void(^xtt_clickEventsBlock)(NSIndexPath* indexPath, id sender);
@property (nonatomic, copy) void(^xtt_clickFlagEventsBlock)(NSIndexPath* indexPath, id sender, int flag);

@end
