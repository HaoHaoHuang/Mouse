//
//  UITableView+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+ForCellModel.h"

@protocol XTTUITableViewCacheDelegate <NSObject>

@optional
// 用于通过方法 - (CGFloat)xtt_cellHeightWithCellModels:(NSArray*)cellModels forIndexPath:(NSIndexPath*)indexPath; 返回cell高度时，决定是否使用缓存。
- (BOOL)tableView:(UITableView*)tableView usingHeightCacheForRowAtIndexPath:(NSIndexPath*)indexPath;

//// 用于通过方法 - (CGFloat)xtt_cellHeightWithCellModels:(NSArray*)cellModels forRow:(NSInteger)row; 返回cell高度时，决定是否使用缓存。
//- (BOOL)tableView:(UITableView*)tableView usingHeightCacheForRow:(NSInteger)row;

@end

@interface UITableView (Additions)

@property (nonatomic, weak) id<XTTUITableViewCacheDelegate> xtt_cacheDelegate;

// 该方法任何情况下都不会使用高度缓存
- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withCallBlock:(void(^)(id calCell))calBlock;

// 如果对model设置了可以使用高度缓存，则该方法返回缓存的高度
- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withInfo:(id)info;

// 如果已经对model对应的cellClass进行了配置，则可以直接调用此方法获取cell高度
// 如果对model设置了可以使用高度缓存，则该方法返回缓存的高度
- (CGFloat)xtt_cellHeightWithModel:(NSObject*)model;

// 如果已经对model对应的cellClass进行了配置，则可以调用该方法获取model所对应的用于计算高度的cell
// 特别注意：返回的cell尚未通过model计算高度
- (__kindof UITableViewCell*)xtt_rawCalculateCellForModel:(NSObject*)model;

// 如果已经对model对应的cellClass进行了配置，则可以调用该方法获取model所对应的用于显示的cell
// 特别注意：返回的cell尚未通过model进行赋值。
- (__kindof UITableViewCell*)xtt_rawCellWithCellModels:(NSArray*)cellModels forIndexPath:(NSIndexPath*)indexPath;

- (CGFloat)xtt_headerFooterHeightForClass:(Class)headerFooterClass withCallBlock:(void(^)(id calCell))calBlock;
- (CGFloat)xtt_headerFooterHeightForClass:(Class)headerFooterClass withInfo:(id)info;


#pragma mark - - 快捷创建tableView的系列方法
#pragma mark - 使用以下方法的条件：
// 对于计算高度，需要实现cell的cellHeightWithInfo:或者cellWithInfo:方法
// 对于创建cell，必须要实现cell的cellWithInfo:方法
// 最重要的是，在configBlock中需要对model调用 xtt_configReuseCellClass: andIdentifier: inTableView:进行配置
// 考虑到tableView数据源的添加和删除操作，该方法建议在 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 中调用
- (void)xtt_registerClassWithCellModels:(NSArray *)cellModels modelConfigBlock:(void (^)(UITableView* tableView, id model))configBlock;

// 计算高度之后，默认情况下不缓存

//// 一维数组的情况下时调用
//- (CGFloat)xtt_cellHeightWithCellModels:(NSArray*)cellModels forRow:(NSInteger)row;
//- (UITableViewCell*)xtt_cellWithCellModels:(NSArray*)cellModels forRow:(NSInteger)row;

// 二位数组时调用，但是如果检测到不是二维数组，则按照一维数组的情况处理
- (CGFloat)xtt_cellHeightWithCellModels:(NSArray*)cellModels forIndexPath:(NSIndexPath*)indexPath;
- (__kindof UITableViewCell*)xtt_cellWithCellModels:(NSArray*)cellModels forIndexPath:(NSIndexPath*)indexPath;


@end
