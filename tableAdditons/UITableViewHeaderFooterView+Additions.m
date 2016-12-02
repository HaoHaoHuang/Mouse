//
//  UITableViewHeaderFooterView+Additions.m
//  TouTiao_student
//
//  Created by haohuang on 16/3/29.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "UITableViewHeaderFooterView+Additions.h"
#import <objc/runtime.h>

@implementation UITableViewHeaderFooterView (Additions)

- (CGFloat)xtt_heightAfterInitialization
{
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    if ([self respondsToSelector:@selector(headerFooterContentViewWidth)]) {
        CGFloat customWidth = self.headerFooterContentViewWidth;
        contentWidth = customWidth < CGFLOAT_MIN ? contentWidth : customWidth;
    }
    return [self xtt_heightAfterInitializationWithContentWidth:contentWidth];
}

- (CGFloat)xtt_heightAfterInitializationWithContentWidth:(CGFloat)contentViewWidth
{
    [self xtt_remakeConstraitsWithContentWidth:contentViewWidth];
    [self layoutIfNeeded];
    CGFloat hfHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return hfHeight;
}

- (void)xtt_remakeConstraitsWithContentWidth:(CGFloat)contentViewWidth
{
    CGFloat sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    __weak typeof(self) ws = self;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        ws.contentView.translatesAutoresizingMaskIntoConstraints = (sysVersion > 9.9);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(contentViewWidth);
    }];
}

- (void)xtt_tryAddWidthConstraintWithContentWidth:(CGFloat)contentViewWidth
{
    CGFloat sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    NSLayoutConstraint* widthConstraint = objc_getAssociatedObject(self, __func__);
    
    // 约束的宽度发生改变的情况
    if (widthConstraint && ABS(widthConstraint.constant - contentViewWidth) > 0.12) {
        if (sysVersion < 7.9) {
            [self.contentView removeConstraint:widthConstraint];
        }
        else {
            widthConstraint.active = NO;
        }
        widthConstraint = nil;
    }
    
    // 约束还没创建的情况
    if (!widthConstraint) {
        widthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:contentViewWidth];
        objc_setAssociatedObject(self, __func__, widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (sysVersion < 7.9) {
        [self.contentView removeConstraint:widthConstraint];
        [self.contentView addConstraint:widthConstraint];
    }
    else {
        widthConstraint.active = NO;
        widthConstraint.active = YES;
    }
}

- (void)setXtt_section:(NSInteger)xtt_section
{
    objc_setAssociatedObject(self, @selector(xtt_section), @(xtt_section), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)xtt_section
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setXtt_tableView:(UITableView *)xtt_tableView
{
    objc_setAssociatedObject(self, @selector(xtt_tableView), xtt_tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)xtt_tableView
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
