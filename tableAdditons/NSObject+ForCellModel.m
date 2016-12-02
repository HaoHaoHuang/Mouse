//
//  NSObject+ForCellModel.m
//  TouTiao_student
//
//  Created by haohuang on 16/4/7.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "NSObject+ForCellModel.h"
#import <objc/runtime.h>

@interface NSObject()

@property (nonatomic, strong, readonly) NSMutableDictionary* xtt_cellHeightCache;
@property (nonatomic, strong, readonly) NSMutableDictionary* xtt_usingHeightCacheStorage;

@property (nonatomic, strong, readonly) NSMutableDictionary* xtt_cellClassStorage;
@property (nonatomic, strong, readonly) NSMutableDictionary* xtt_reuseIdentifierStorage;

@end

@implementation NSObject (ForCellModel)

#pragma mark - - model配置
- (void)xtt_configReuseCellClass:(Class)reuseCellClass andIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView
{
    [self.xtt_cellClassStorage setValue:reuseCellClass forKey:[self xtt_storageKeyForTableView:tableView]];
    [self.xtt_reuseIdentifierStorage setValue:reuseIdentifier forKey:[self xtt_storageKeyForTableView:tableView]];
}

- (Class)xtt_reuseCellClassInTableView:(UITableView *)tableView
{
    return [self.xtt_cellClassStorage objectForKey:[self xtt_storageKeyForTableView:tableView]];
}

- (NSString*)xtt_reuseIdentifierInTableView:(UITableView*)tableView
{
    return [self.xtt_reuseIdentifierStorage valueForKey:[self xtt_storageKeyForTableView:tableView]];
}

#pragma mark - - 是否使用缓存的cell高度
- (void)xtt_usingHeightCache:(BOOL)usingHeightCache inTableView:(UITableView *)tableView
{
    NSString* key = [self xtt_cacheKeyOfTableView:tableView];
    [self.xtt_usingHeightCacheStorage setValue:@(usingHeightCache) forKey:key];
}

- (BOOL)xtt_usingHeightCacheInTableView:(UITableView *)tableView
{
    NSString* key = [self xtt_cacheKeyOfTableView:tableView];
    NSNumber* usingObj = [self.xtt_usingHeightCacheStorage valueForKey:key];
    return usingObj ? [usingObj boolValue] : NO;
}

#pragma mark - - 高度缓存
- (void)xtt_cacheCellHeight:(CGFloat)cellHeight inTableView:(UITableView *)tableView
{
    NSString* key = [self xtt_cacheKeyOfTableView:tableView];
    [self.xtt_cellHeightCache setValue:@(cellHeight) forKey:key];
}

- (CGFloat)xtt_cellHeightInTableView:(UITableView *)tableView
{
    NSString* key = [self xtt_cacheKeyOfTableView:tableView];
    NSNumber* cellHeight = [self.xtt_cellHeightCache valueForKey:key];
    if (!cellHeight) {
        return -1;
    }
    else {
        return [cellHeight floatValue];
    }
}

- (void)xtt_clearHeightCacheInTableView:(UITableView *)tableView
{
    NSString* key = [self xtt_cacheKeyOfTableView:tableView];
    [self.xtt_cellHeightCache setValue:nil forKey:key];
}

#pragma mark - - private
- (NSString*)xtt_cacheKeyOfTableView:(UITableView*)tableView
{
    NSString* reuseID = [self xtt_reuseIdentifierInTableView:tableView];
    NSString* key = [NSString stringWithFormat:@"%p-%@", tableView, reuseID];
    return key;
}

- (NSString*)xtt_storageKeyForTableView:(UITableView*)tableView
{
    NSString* key = [NSString stringWithFormat:@"%p", tableView];
    return key;
}

- (NSMutableDictionary *)xtt_cellHeightCache
{
    NSMutableDictionary* cellHeightCache = objc_getAssociatedObject(self, _cmd);
    if (!cellHeightCache) {
        cellHeightCache = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, _cmd, cellHeightCache, OBJC_ASSOCIATION_RETAIN);
    }
    return cellHeightCache;
}

- (NSMutableDictionary *)xtt_usingHeightCacheStorage
{
    NSMutableDictionary* usingStorage = objc_getAssociatedObject(self, _cmd);
    if (!usingStorage) {
        usingStorage = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, _cmd, usingStorage, OBJC_ASSOCIATION_RETAIN);
    }
    return usingStorage;
}

- (NSMutableDictionary *)xtt_cellClassStorage
{
    NSMutableDictionary* mDic = objc_getAssociatedObject(self, _cmd);
    if (!mDic) {
        mDic = [NSMutableDictionary dictionaryWithCapacity:6];
        objc_setAssociatedObject(self, _cmd, mDic, OBJC_ASSOCIATION_RETAIN);
    }
    return mDic;
}

- (NSMutableDictionary *)xtt_reuseIdentifierStorage
{
    NSMutableDictionary* mDic = objc_getAssociatedObject(self, _cmd);
    if (!mDic) {
        mDic = [NSMutableDictionary dictionaryWithCapacity:6];
        objc_setAssociatedObject(self, _cmd, mDic, OBJC_ASSOCIATION_RETAIN);
    }
    return mDic;
}

@end
