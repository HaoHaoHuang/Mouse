//
//  UICollectionReusableView+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/4/7.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+Additions.h"

@protocol XTTUICollectionReusableViewAdditionProtocol <NSObject>

@optional
- (instancetype)reuseViewWithInfo:(id)info;

- (CGFloat)reuseViewHeightWithInfo:(id)info;

@end


@interface UICollectionReusableView (Additions)<XTTUICollectionReusableViewAdditionProtocol>

@property (nonatomic, assign) NSInteger xtt_section;
@property (nonatomic, weak) UICollectionView* xtt_collectionView;

@property (nonatomic, copy) void(^xtt_didSelectBlock)(NSInteger section);
@property (nonatomic, copy) void(^xtt_clickEventsBlock)(NSInteger section, id sender);
@property (nonatomic, copy) void(^xtt_clickFlagEventsBlock)(NSInteger section, id sender, int flag);

@end
