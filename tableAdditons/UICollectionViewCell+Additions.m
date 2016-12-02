//
//  UICollectionViewCell+Additions.m
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UICollectionViewCell+Additions.h"
#import <objc/runtime.h>

@implementation UICollectionViewCell (Additions)

- (CGFloat)xtt_heightAfterInitialization
{
    [self layoutIfNeeded]; // 在ios7中必须有
    [self.contentView layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return cellHeight;
}

- (void)setXtt_collectionView:(UICollectionView *)xtt_collectionView
{
    objc_setAssociatedObject(self, @selector(xtt_collectionView), xtt_collectionView, OBJC_ASSOCIATION_ASSIGN);
}

- (UICollectionView *)xtt_collectionView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_indexPath:(NSIndexPath *)xtt_indexPath
{
    objc_setAssociatedObject(self, @selector(xtt_indexPath), xtt_indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)xtt_indexPath
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_didSelectBlock:(void (^)(NSIndexPath *))xtt_didSelectBlock
{
    objc_setAssociatedObject(self, @selector(xtt_didSelectBlock), xtt_didSelectBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSIndexPath *))xtt_didSelectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_clickFlagEventsBlock:(void (^)(NSIndexPath *, id, int))xtt_clickFlagEventsBlock
{
    objc_setAssociatedObject(self, @selector(xtt_clickFlagEventsBlock), xtt_clickFlagEventsBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSIndexPath*, id, int))xtt_clickFlagEventsBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dealloc
{
    
}

@end
