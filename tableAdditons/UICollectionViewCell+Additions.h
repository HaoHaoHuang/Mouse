//
//  UICollectionViewCell+Additions.h
//  TouTiao_student
//
//  Created by haohuang on 16/3/23.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+Additions.h"

@protocol XTTUICollectionViewCellAdditonProtocol <NSObject>

@optional
- (instancetype)cellWithInfo:(id)info;

- (CGFloat)cellHeightWithInfo:(id)info;

- (CGSize)cellSizeWithInfo:(id)info;

@end

@interface UICollectionViewCell (Additions)<XTTUICollectionViewCellAdditonProtocol>

@property (nonatomic, readonly) CGFloat xtt_heightAfterInitialization;

@property (nonatomic, weak) UICollectionView* xtt_collectionView;
@property (nonatomic, retain) NSIndexPath* xtt_indexPath;

@property (nonatomic, copy) void(^xtt_didSelectBlock)(NSIndexPath* indexPath);
@property (nonatomic, copy) void(^xtt_clickFlagEventsBlock)(NSIndexPath* indexPath, id sender, int flag);

@end
