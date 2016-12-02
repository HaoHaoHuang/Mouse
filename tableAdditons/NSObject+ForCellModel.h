//
//  NSObject+ForCellModel.h
//  TouTiao_student
//
//  Created by haohuang on 16/4/7.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (ForCellModel)

// 配置model
- (void)xtt_configReuseCellClass:(Class)reuseCellClass andIdentifier:(NSString*)reuseIdentifier inTableView:(UITableView*)tableView;

- (Class)xtt_reuseCellClassInTableView:(UITableView*)tableView;
- (NSString*)xtt_reuseIdentifierInTableView:(UITableView*)tableView;

#pragma mark - - 是否使用缓存的cell高度
- (void)xtt_usingHeightCache:(BOOL)usingHeightCache inTableView:(UITableView*)tableView;
- (BOOL)xtt_usingHeightCacheInTableView:(UITableView*)tableView;

#pragma mark - - 高度缓存
- (void)xtt_cacheCellHeight:(CGFloat)cellHeight inTableView:(UITableView*)tableView;

// 默认会返回-1
- (CGFloat)xtt_cellHeightInTableView:(UITableView*)tableView;

// 清理cell的高度缓存
- (void)xtt_clearHeightCacheInTableView:(UITableView*)tableView;

///////////

@end
