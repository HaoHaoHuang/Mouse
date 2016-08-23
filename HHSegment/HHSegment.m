//
//  HHSegment.m
//  SegmentDemo
//
//  Created by bjhl on 16/8/6.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "HHSegment.h"

// 未选中时字体的颜色
#define KDefault_titleColor          [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f]
// 选中item背景颜色
#define KDefault_selectedItemBgColor     [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f]
// 背景的颜色
#define KDefault_bgColor          [UIColor whiteColor]
// 选中时字体的颜色
#define KDefault_selectColor          [UIColor colorWithRed:233.0/255 green:97.0/255 blue:31.0/255 alpha:1.0f]
// segment标题的默认字体
#define KDefault_titleFont          [UIFont systemFontOfSize:16]
// segment默认不需要下划线
#define KDefault_needBottomLine     NO
// segment默认下划线的颜色
#define KDefault_lineColor         [UIColor redColor]
// 默认下划线滑动时间
#define KDefault_duration           0.5
// 下划线默认高度
#define KDefault_lineHeight         2
// 默认选中下标
#define KDefault_selectedIndex      0
// 默认没有边框
#define KDefault_hasBorder          NO
// 边框颜色
#define KDefault_borderColor          [UIColor colorWithRed:233.0/255 green:97.0/255 blue:31.0/255 alpha:1.0f]
// 边框宽度
#define KDefault_borderWidth         1
// 圆角大小
#define KDefault_cornerRadius        3

@interface HHSegment ()
{
    NSInteger _itemCount;
    UIView *_backView;
    CGRect _segmentFrame;
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    NSInteger _currentPage;
}
// 底部下划线
@property (nonatomic,strong) UIView *bottomLine;
@end

@implementation HHSegment

HHSegment *segment = nil;
+ (instancetype)initSegment
{
    segment = [[self alloc] init];
    return segment;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 初始化
        self.itemArray = [NSMutableArray arrayWithCapacity:0];
        self.duration = KDefault_duration;
        self.lineColor = KDefault_lineColor;
        self.needBottomLine = KDefault_needBottomLine;
        self.titleFont = KDefault_titleFont;
        self.selectColor = KDefault_selectColor;
        self.titleColor = KDefault_titleColor;
        self.hasBorder = KDefault_hasBorder;
        self.backgroundColor = KDefault_bgColor;
        _currentPage = 0;
        
//        [self addObserver:self forKeyPath:@"item.backgroundColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"item.backgroundColor"];
    }
    return self;
}

- (void)addItems:(NSArray *)items frame:(CGRect)frame inView:(UIView *)view
{
    _backView = view;
    _segmentFrame = frame;
    segment.frame = frame;
    [segment addItems:items];
    [view addSubview:segment];
    [self addSwipGestureIn:view];
}

- (void) addItems:(NSArray *)items{
    _itemCount = items.count;
    if (_itemCount == 0) {
        return;
    }
    _itemWidth = segment.frame.size.width / _itemCount;
    _itemHeight = self.needBottomLine ? segment.frame.size.height - KDefault_lineHeight : segment.frame.size.height;
    
    for (NSInteger i=0; i<_itemCount; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(_itemWidth * i, 0, _itemWidth, _itemHeight)];
        item.titleLabel.font = self.titleFont;
        [item setTitle:items[i] forState:UIControlStateNormal];
        [item setTitleColor:self.titleColor forState:UIControlStateNormal];
        [item setTitleColor:self.selectColor forState:UIControlStateSelected];
        item.tag = i;
        [item addTarget:self action:@selector(changeTheSegment:) forControlEvents:UIControlEventTouchUpInside];
        if (self.needBottomLine) {
            if (!_bottomLine) {
                _bottomLine = [[UIView alloc] initWithFrame:CGRectMake((KDefault_selectedIndex < _itemCount ? KDefault_selectedIndex:0) * _itemWidth, _itemHeight, _itemWidth, KDefault_lineHeight)];
                _bottomLine.backgroundColor = (self.lineColor == nil ? self.lineColor:KDefault_lineColor);
                [self addSubview:_bottomLine];
            }
        }
        [self addSubview:item];
        [self.itemArray addObject:item];
        
        if (KDefault_selectedIndex < _itemCount) {
            [self.itemArray[KDefault_selectedIndex] setSelected:YES];
        }else{
            [self.itemArray.firstObject setSelected:YES];
        }
        [self setItemBackGroundColorFor:item];
    }
    [self addBorder];
}

- (void) setItemBackGroundColorFor:(UIButton *)item{
    if (item.selected) {
        item.backgroundColor = KDefault_selectedItemBgColor;
    }else{
        item.backgroundColor = KDefault_bgColor;
    }
}

- (void) addBorder
{
    if (self.hasBorder) {
        self.layer.masksToBounds = YES;
        self.layer.borderColor = self.borderColor ? self.borderColor.CGColor : KDefault_borderColor.CGColor;
        self.layer.borderWidth = self.borderWidth ? self.borderWidth : KDefault_borderWidth;
        self.layer.cornerRadius = self.cornerRadius ? self.cornerRadius : KDefault_cornerRadius;
    }
}

- (void) changeTheSegment:(UIButton *)item
{
    [self selectIndex:item.tag];
    _currentPage = item.tag;
    if ([self.delegate respondsToSelector:@selector(didSelectSegment:AtIndex:)]) {
        [self.delegate didSelectSegment:self AtIndex:item.tag];
    }
    
    if (self.segmentClickBlock) {
        self.segmentClickBlock(self,item.tag);
    }
}

- (void) selectIndex:(NSInteger) index{
    if (self.selectedIndex != index) {
        [self handleSelectItemEventWith:index];
    }
}

- (void) handleSelectItemEventWith:(NSInteger) index
{
    if (index > _itemCount) {
        return;
    }
    
    [self.itemArray[self.selectedIndex] setSelected:NO];
    [self.itemArray[index] setSelected:YES];
    [self setItemBackGroundColorFor:self.itemArray[index]];
    [self setItemBackGroundColorFor:self.itemArray[self.selectedIndex]];
    
    self.selectedIndex = index;
    if (self.needBottomLine) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = weakSelf.bottomLine.frame;
            frame.origin.x = index * _itemWidth;
            weakSelf.bottomLine.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
  
}

- (void) addSwipGestureIn:(UIView *)view
{
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipScreen:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:left];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipScreen:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:right];
}

- (void) swipScreen:(UISwipeGestureRecognizer *) gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"左划");
        // 1、移动segment
        if (_currentPage < _itemCount - 1) {
            _currentPage ++ ;
            [self selectIndex:_currentPage];
        }
        // 3、移动当前view
        
    }else{
        NSLog(@"右划");
        if (_currentPage > 0) {
            _currentPage -- ;
            [self selectIndex:_currentPage];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSString *contextStr = (__bridge NSString *)context;
    if ([contextStr isEqualToString:@"item.backgroundColor"]) {
        
    }
}

@end
















