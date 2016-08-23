//
//  HHSegment.h
//  SegmentDemo
//
//  Created by bjhl on 16/8/6.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHSegment;

typedef void (^HHSegmentClickBlock)(HHSegment *view,NSInteger selectedIndex);

@protocol HHSegmentDelegate <NSObject>

@optional
/**
 *  创建segment的类需要实现的协议方法，可选
 *
 *  @param selection 选中的下标
 */
-(void)didSelectSegment:(HHSegment *)segment AtIndex:(NSInteger)selectedIndex;

@end

@interface HHSegment : UIView
/**
 *  点击回调的block
 */
@property (nonatomic,copy) HHSegmentClickBlock segmentClickBlock;
/**
 * 当前类的代理对象，把要实现选择segment的类的对象设置成代理
 */
@property (nonatomic,weak) id <HHSegmentDelegate> delegate;
/**
 * 自定义选中下标
 */
@property (nonatomic,assign) NSInteger selectedIndex;
/**
 *  segment的字体颜色，不设置的话采用默认值
 */
@property (nonatomic,strong) UIColor *titleColor;
/**
 *  segment的选中字体颜色，不设置的话采用默认值
 */
@property (nonatomic,strong) UIColor *selectColor;
/**
 *  被选中item背景颜色
 */
@property (nonatomic,strong) UIColor *selectedItemBgColor;
/**
 *  未选中item背景颜色（也就是整个SegmentView的背景）
 */
@property (nonatomic,strong) UIColor *bgColor;
/**
 *  segment标题的字体，不设置的采用默认值
 */
@property (nonatomic,strong) UIFont *titleFont;
/**
 *  segment是否需要下划线，默认no
 */
@property (nonatomic,assign) BOOL needBottomLine;
/**
 *  segment下划线的颜色
 */
@property (nonatomic,strong) UIColor *lineColor;
/**
 *  segment下划线滑动的时间，不设置的采用默认值
 */
@property (nonatomic,assign) CGFloat duration;
/**
 *  标题数组
 */
@property (nonatomic,strong) NSMutableArray *itemArray;
/**
 *  是否包含圆角边界，注意：包括圆角，则应该不包含底部横线了
 */
@property (nonatomic,assign) BOOL hasBorder;
/**
 *  边界颜色
 */
@property (nonatomic,strong) UIColor *borderColor;
/**
 *  边界宽度
 */
@property (nonatomic,assign) CGFloat borderWidth;
/**
 *  圆角大小
 */
@property (nonatomic,assign) CGFloat cornerRadius;


/**
 *  初始化segment对象
 *
 *  @return 返回创建的对象
 */
+(instancetype )initSegment;
/**
 *  要添加的item
 *
 *  @param items item数组
 *  @param frame item位置
 *  @param view  要添加item的view
 */
-(void)addItems:(NSArray *)items frame:(CGRect )frame inView:(UIView *)view;
@end




















