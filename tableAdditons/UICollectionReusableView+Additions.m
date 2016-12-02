//
//  UICollectionReusableView+Additions.m
//  TouTiao_student
//
//  Created by haohuang on 16/4/7.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UICollectionReusableView+Additions.h"
#import <objc/runtime.h>

@implementation UICollectionReusableView (Additions)

- (void)setXtt_section:(NSInteger)xtt_section
{
    objc_setAssociatedObject(self, @selector(xtt_section), @(xtt_section), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)xtt_section
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setXtt_collectionView:(UICollectionView *)xtt_collectionView
{
    objc_setAssociatedObject(self, @selector(xtt_collectionView), xtt_collectionView, OBJC_ASSOCIATION_ASSIGN);
}

- (UICollectionView *)xtt_collectionView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_didSelectBlock:(void (^)(NSInteger))xtt_didSelectBlock
{
    objc_setAssociatedObject(self, @selector(xtt_didSelectBlock), xtt_didSelectBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSInteger))xtt_didSelectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_clickEventsBlock:(void (^)(NSInteger, id))xtt_clickEventsBlock
{
    objc_setAssociatedObject(self, @selector(xtt_clickEventsBlock), xtt_clickEventsBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSInteger, id))xtt_clickEventsBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXtt_clickFlagEventsBlock:(void (^)(NSInteger, id, int))xtt_clickFlagEventsBlock
{
    objc_setAssociatedObject(self, @selector(xtt_clickFlagEventsBlock), xtt_clickFlagEventsBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSInteger, id, int))xtt_clickFlagEventsBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
