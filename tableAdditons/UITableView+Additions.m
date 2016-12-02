//
//  UITableView+Additions.m
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UITableView+Additions.h"
#import <objc/runtime.h>
#import "UITableViewCell+Additions.h"
#import "UITableViewHeaderFooterView+Additions.h"

@interface UITableView ()

@property (nonatomic, strong, readonly) NSCache* xtt_calCellCache;

@end

@implementation UITableView (Additions)

- (void)setXtt_cacheDelegate:(id<XTTUITableViewCacheDelegate>)xtt_cacheDelegate
{
    objc_setAssociatedObject(self, @selector(xtt_cacheDelegate), xtt_cacheDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<XTTUITableViewCacheDelegate>)xtt_cacheDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - - cal cell height
- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withCallBlock:(void (^)(id))calBlock
{
    UITableViewCell* cell = [self xtt_cellForClass:cellClass];
    if (calBlock) {
        calBlock(cell);
        return [self xtt_heightForCell:cell];
    }
    else {
        return 0;
    }
}

- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withInfo:(id)info
{
    CGFloat cellHeight;
    if ([info xtt_usingHeightCacheInTableView:self]) {
        CGFloat cellHeight = [info xtt_cellHeightInTableView:self];
        if (cellHeight >= 0) {
            return cellHeight;
        }
    }
    
    UITableViewCell* cell = [self xtt_cellForClass:cellClass];
    if ([cell respondsToSelector:@selector(cellHeightWithInfo:)]) {
        cellHeight = [cell cellHeightWithInfo:info];
    }
    else if ([cell respondsToSelector:@selector(cellWithInfo:)]) {
        cellHeight = [self xtt_heightForCell:[cell cellWithInfo:info]];
    }
    else {
        cellHeight = 0;
    }
    [info xtt_cacheCellHeight:cellHeight inTableView:self];
    return cellHeight;
}

#pragma mark - - cal header footer height
- (CGFloat)xtt_headerFooterHeightForClass:(Class)headerFooterClass withCallBlock:(void (^)(id))calBlock
{
    UITableViewHeaderFooterView* hfView = [self xtt_headerFooterForClass:headerFooterClass];
    if (calBlock) {
        calBlock(hfView);
        return [self xtt_heightForHeaderFooter:hfView];
    }
    else {
        return 0;
    }
}

- (CGFloat)xtt_headerFooterHeightForClass:(Class)headerFooterClass withInfo:(id)info
{
    UITableViewHeaderFooterView* hfView = [self xtt_headerFooterForClass:headerFooterClass];
    if ([hfView respondsToSelector:@selector(headerFooterHeightWithInfo:)]) {
        return [hfView headerFooterHeightWithInfo:info];
    }
    else if ([hfView respondsToSelector:@selector(headerFooterWithInfo:)]) {
        return [self xtt_heightForHeaderFooter:[hfView headerFooterWithInfo:info]];
    }
    else {
        return 0;
    }
}

#pragma mark - - private

#pragma mark - - cell
- (UITableViewCell*)xtt_cellForClass:(Class)cellClass
{
    UITableViewCell* cell = [self.xtt_calCellCache objectForKey:cellClass];
    if (!cell) {
        cell = [[cellClass alloc] init];
        [self.xtt_calCellCache setObject:cell forKey:cellClass];
    }
    return cell;
}

- (CGFloat)xtt_heightForCell:(UITableViewCell*)cell
{
//    [cell layoutIfNeeded]; // 在ios7中必须有
//    [cell.contentView layoutIfNeeded];
//    CGFloat cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//    return cellHeight;
    
    return cell.xtt_heightAfterInitialization;
}

#pragma mark - - header footer
- (UITableViewHeaderFooterView*)xtt_headerFooterForClass:(Class)headerFooterClass
{
    UITableViewHeaderFooterView* hfView = [self.xtt_calCellCache objectForKey:headerFooterClass];
    if (!hfView) {
        hfView = [[headerFooterClass alloc] initWithReuseIdentifier:nil];
        [self.xtt_calCellCache setObject:hfView forKey:headerFooterClass];
    }
    return hfView;
}

- (CGFloat)xtt_heightForHeaderFooter:(UITableViewHeaderFooterView*)hfView
{
//    [hfView.contentView layoutIfNeeded];
//    CGFloat hfHeight = [hfView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//    return hfHeight;
    
    return [hfView xtt_heightAfterInitialization];
}

#pragma mark - -

- (NSCache *)xtt_calCellCache
{
    NSCache* calCellCache = objc_getAssociatedObject(self, _cmd);
    if (!calCellCache) {
        calCellCache = [[NSCache alloc] init];
        objc_setAssociatedObject(self, _cmd, calCellCache, OBJC_ASSOCIATION_RETAIN);
    }
    return calCellCache;
}

/////////////////////////////
/////////////////////////////
/////////////////////////////

#pragma mark - - 快捷创建tableView的系列方法

- (void)xtt_registerClassWithCellModels:(NSArray *)cellModels modelConfigBlock:(void (^)(UITableView*, id))configBlock
{
    for (id model in cellModels) {
        configBlock(self, model);
        [model xtt_clearHeightCacheInTableView:self]; // tabelView重新加载时默认清空高度缓存
        [model xtt_usingHeightCache:YES inTableView:self]; // 默认情况下使用高度缓存
        Class modelCellClass = [model xtt_reuseCellClassInTableView:self];
        NSString* modelCellID = [model xtt_reuseIdentifierInTableView:self];
        [self registerClass:modelCellClass forCellReuseIdentifier:modelCellID];
    }
}

//- (CGFloat)xtt_cellHeightWithCellModels:(NSArray *)cellModels forRow:(NSInteger)row
//{
//    NSObject* model = cellModels[row];
//    [model xtt_usingHeightCache:[self usingHeightCacheForRow:row] inTableView:self];
//    return [self xtt_cellHeightWithModel:model];
//}
//
//- (UITableViewCell *)xtt_cellWithCellModels:(NSArray *)cellModels forRow:(NSInteger)row
//{
//    NSObject* model = cellModels[row];
//    NSString* reuseID = [model xtt_reuseIdentifierInTableView:self];
//    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:reuseID];
//    cell.xtt_tableView = self;
//    cell.xtt_indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    return [cell cellWithInfo:model];
//}

- (NSObject*)xtt_modelOfCellModels:(NSArray *)cellModels atIndexPath:(NSIndexPath *)indexPath
{
    NSObject* model = nil;
    if ([[cellModels firstObject] isKindOfClass:[NSArray class]]) {
        model = cellModels[indexPath.section][indexPath.row];
    }
    else {
        model = cellModels[indexPath.row];
    }
    return model;
}

- (UITableViewCell*)xtt_rawCellOfCellModel:(NSObject*)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseID = [cellModel xtt_reuseIdentifierInTableView:self];
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.xtt_tableView = self;
    cell.xtt_indexPath = indexPath;
    return cell;
}

- (CGFloat)xtt_cellHeightWithCellModels:(NSArray *)cellModels forIndexPath:(NSIndexPath *)indexPath
{
    NSObject* model = [self xtt_modelOfCellModels:cellModels atIndexPath:indexPath];
    [model xtt_usingHeightCache:[self xtt_usingHeightCacheForRowAtIndexPath:indexPath] inTableView:self];
    return [self xtt_cellHeightWithModel:model];
}

- (UITableViewCell *)xtt_cellWithCellModels:(NSArray *)cellModels forIndexPath:(NSIndexPath *)indexPath
{
    NSObject* model = [self xtt_modelOfCellModels:cellModels atIndexPath:indexPath];
    UITableViewCell* cell = [self xtt_rawCellOfCellModel:model atIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(cellWithInfo:)]) {
        return [cell cellWithInfo:model];
    }
    else {
        return cell;
    }
}

- (CGFloat)xtt_cellHeightWithModel:(NSObject*)model
{
    // 不使用缓存，或者没有缓存的时候
    Class cellClass = [model xtt_reuseCellClassInTableView:self];
    CGFloat cellHeight = [self xtt_cellHeightForCellClass:cellClass withInfo:model];
    return cellHeight;
}

- (__kindof UITableViewCell*)xtt_rawCalculateCellForModel:(NSObject *)model
{
    Class cellClass = [model xtt_reuseCellClassInTableView:self];
    UITableViewCell* cell = [self xtt_cellForClass:cellClass];
    return cell;
}

- (__kindof UITableViewCell*)xtt_rawCellWithCellModels:(NSArray*)cellModels forIndexPath:(NSIndexPath*)indexPath;
{
    NSObject* model = [self xtt_modelOfCellModels:cellModels atIndexPath:indexPath];
    UITableViewCell* cell = [self xtt_rawCellOfCellModel:model atIndexPath:indexPath];
    return cell;
}

//- (BOOL)usingHeightCacheForRow:(NSInteger)row
//{
//    if ([self.cacheDelegate respondsToSelector:@selector(tableView:usingHeightCacheForRow:)]) {
//        return [self.cacheDelegate tableView:self usingHeightCacheForRow:row];
//    }
//    else {
//        return [self usingHeightCacheForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//    }
//}

- (BOOL)xtt_usingHeightCacheForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.xtt_cacheDelegate respondsToSelector:@selector(tableView:usingHeightCacheForRowAtIndexPath:)]) {
        return [self.xtt_cacheDelegate tableView:self usingHeightCacheForRowAtIndexPath:indexPath];
    }
    else {
        return YES; // 默认情况下使用高度缓存
    }
}

@end
