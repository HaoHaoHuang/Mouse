//
//  UICollectionView+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Additions)

- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withCallBlock:(void(^)(id calCell))calBlock;

// 该方法会根据cell是否实现了cellHeightWithInfo方法，会返回其计算出的高度。
// 如果cell没有实现cellHeightWithInfo，而实现了cellWithInfo，则会通过cellWihtInfo进行高度计算并返回。
// 如果cell以上两个方法都没有实现，则返回高度0
- (CGFloat)xtt_cellHeightForCellClass:(Class)cellClass withInfo:(id)info;

- (CGSize)xtt_cellSizeForCellClass:(Class)cellClass withInfo:(id)info;

- (CGFloat)xtt_reuseViewHeightForClass:(Class)reuseViewClass withCallBlock:(void(^)(id calCell))calBlock;
- (CGFloat)xtt_reuseViewHeightForClass:(Class)reuseViewClass withInfo:(id)info;

@end
