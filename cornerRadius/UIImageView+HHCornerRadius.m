//
//  UIImageView+HHCornerRadius.m
//  Tools
//
//  Created by 黄浩 on 2015/5/28.
//  Copyright © 2015年 黄浩. All rights reserved.
//

#import "UIImageView+HHCornerRadius.h"
#import <objc/runtime.h>

@interface UIImage (cornerRadius)
@property (nonatomic, assign) BOOL aliCornerRadius;

@end

@implementation UIImage (cornerRadius)

- (BOOL)aliCornerRadius
{
    return objc_getAssociatedObject(self, @selector(aliCornerRadius));
}

- (void)setAliCornerRadius:(BOOL)aliCornerRadius
{
    objc_setAssociatedObject(self, @selector(aliCornerRadius), @(aliCornerRadius), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface HHImageObserver : NSObject

@property (nonatomic,strong) UIImageView *originImageView;
@property (nonatomic,strong) UIImage *originImage;
@property (nonatomic,assign) CGFloat cornerRadius;

- (instancetype)initWithImageView:(UIImageView *)imageView;

@end

@implementation HHImageObserver

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius || cornerRadius <= 0) {
        return;
    }
    _cornerRadius = cornerRadius;
    [self updateImageView];
}

- (instancetype)initWithImageView:(UIImageView *)imageView
{
    if (self = [super init]) {
        self.originImageView = imageView;
        [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        [imageView addObserver:self forKeyPath:@"contentMode" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[@"new"];
        if (![newImage isKindOfClass:[UIImage class]] || newImage.aliCornerRadius) {
            return;
        }
        // 添加圆角
        [self updateImageView];
    }
    if ([keyPath isEqualToString:@"contentMode"]) {
        self.originImageView.image = self.originImage;
    }
}

- (void) updateImageView{
    self.originImage = self.originImageView.image;
    if (!self.originImage) {
        return;
    }
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.originImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    if (currnetContext) {
        CGContextAddPath(currnetContext, [UIBezierPath bezierPathWithRoundedRect:self.originImageView.bounds cornerRadius:self.cornerRadius].CGPath);
        CGContextClip(currnetContext);
        [self.originImageView.layer renderInContext:currnetContext];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if ([image isKindOfClass:[UIImage class]]) {
        image.aliCornerRadius = YES;
        self.originImageView.image = image;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImageView];
        });
    }
}

- (void)dealloc
{
    [self.originImageView removeObserver:self forKeyPath:@"image"];
    [self.originImageView removeObserver:self forKeyPath:@"contentMode"];
}

@end

@interface UIImageView ()

@property (nonatomic, strong) HHImageObserver *imageObserver;
@end

@implementation UIImageView (HHCornerRadius)

- (CGFloat)cornerRadius
{
    return self.imageObserver.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius > 0) {
        self.imageObserver.cornerRadius = cornerRadius;
    }
}

- (HHImageObserver *) imageObserver
{
    HHImageObserver *imageObserver = objc_getAssociatedObject(self, @selector(imageObserver));
    if (!imageObserver) {
        imageObserver = [[HHImageObserver alloc] initWithImageView:self];
        objc_setAssociatedObject(self, @selector(imageObserver), imageObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageObserver;
}

@end
