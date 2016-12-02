//
//  UICollectionView+Additions.m
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UICollectionView+Additions.h"
#import <objc/runtime.h>
#import "UICollectionViewCell+Additions.h"
#import "UICollectionReusableView+Additions.h"

@interface UICollectionView ()

@property (nonatomic, strong, readonly) NSCache* xtt_calCellCache;

@end

@implementation UICollectionView (Additions)

- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withCallBlock:(void (^)(id))calBlock
{
    UICollectionViewCell* ccell = [self xtt_cellForClass:cellClass];
    if (calBlock) {
        calBlock(ccell);
        return [self xtt_heightForCell:ccell];
    }
    else {
        return 0;
    }
}

- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withInfo:(id)info
{
    UICollectionViewCell* ccell = [self xtt_cellForClass:cellClass];
    if ([ccell respondsToSelector:@selector(cellHeightWithInfo:)]) {
        return [ccell cellHeightWithInfo:info];
    }
    else if ([ccell respondsToSelector:@selector(cellWithInfo:)]) {
        return [self xtt_heightForCell:[ccell cellWithInfo:info]];
    }
    else {
        return 0;
    }
}

- (CGSize)xtt_cellSizeForCellClass:(Class)cellClass withInfo:(id)info
{
    UICollectionViewCell* ccell = [self xtt_cellForClass:cellClass];
    if ([ccell respondsToSelector:@selector(cellSizeWithInfo:)]) {
        return [ccell cellSizeWithInfo:info];
    }
    else if ([ccell respondsToSelector:@selector(cellWithInfo:)]) {
        return [self xtt_sizeForCell:ccell];
    }
    else {
        return CGSizeZero;
    }
}

- (CGFloat)xtt_reuseViewHeightForClass:(Class)reuseViewClass withCallBlock:(void (^)(id))calBlock
{
    UICollectionReusableView* reuseView = [self xtt_reuseViewForClass:reuseViewClass];
    if (calBlock) {
        calBlock(reuseView);
        return [self xtt_heightForReuseView:reuseView];
    }
    else {
        return 0;
    }
}

- (CGFloat)xtt_reuseViewHeightForClass:(Class)reuseViewClass withInfo:(id)info
{
    UICollectionReusableView* reuseView = [self xtt_reuseViewForClass:reuseViewClass];
    if ([reuseView respondsToSelector:@selector(reuseViewHeightWithInfo:)]) {
        return [reuseView reuseViewHeightWithInfo:info];
    }
    else if ([reuseView respondsToSelector:@selector(reuseViewWithInfo:)]) {
        return [self xtt_heightForReuseView:[reuseView reuseViewWithInfo:info]];
    }
    else {
        return 0;
    }
}

#pragma mark - - reusableView
- (UICollectionReusableView*)xtt_reuseViewForClass:(Class)reuseViewClass
{
    UICollectionReusableView* reuseView = [self.xtt_calCellCache objectForKey:reuseViewClass];
    if (!reuseView) {
        reuseView = [[reuseViewClass alloc] initWithFrame:CGRectZero];
        [self.xtt_calCellCache setObject:reuseView forKey:reuseViewClass];
    }
    return reuseView;
}

- (CGFloat)xtt_heightForReuseView:(UICollectionReusableView*)reuseView
{
    [reuseView layoutIfNeeded];
    CGFloat reuseViewHeight = [reuseView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    return reuseViewHeight;
}

#pragma mark - - ccell
- (UICollectionViewCell*)xtt_cellForClass:(Class)cellClass
{
    UICollectionViewCell* ccell = [self.xtt_calCellCache objectForKey:cellClass];
    if (!ccell) {
        ccell = [[cellClass alloc] init];
        [self.xtt_calCellCache setObject:ccell forKey:cellClass];
    }
    return ccell;
}

- (CGFloat)xtt_heightForCell:(UICollectionViewCell*)ccell
{
//    [ccell layoutIfNeeded]; // 在ios7中必须有
//    [ccell.contentView layoutIfNeeded];
//    CGFloat cellHeight = [ccell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//    return cellHeight;
    
    return ccell.xtt_heightAfterInitialization;
}

- (CGSize)xtt_sizeForCell:(UICollectionViewCell*)ccell
{
    [ccell layoutIfNeeded];
    [ccell.contentView layoutIfNeeded];
    CGSize cellSize = [ccell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cellSize;
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

@end
