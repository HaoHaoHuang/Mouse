//
//  HHCustomNavController.m
//  CustomNavGationPop
//
//  Created by 黄浩 on 2016/12/29.
//  Copyright © 2016年 黄浩. All rights reserved.
//

#import "HHCustomNavController.h"

#define HH_ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define HH_SlideScale   0.5
#define HH_SlideRange  HH_ScreenWidth * HH_SlideScale

@interface UINavigationController ()
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end

@interface HHCustomNavController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation HHCustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.interactivePopGestureRecognizer];
}

- (UIGestureRecognizer *)interactivePopGestureRecognizer
{
    if (!_panGestureRecognizer) {
        UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)[super interactivePopGestureRecognizer];
        if (edgePanGestureRecognizer && edgePanGestureRecognizer.delegate) {
            NSMutableArray *_targets = [edgePanGestureRecognizer valueForKey:@"_targets"];
            id gestureRecognizerTarget = [_targets firstObject];
            id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
            SEL popHandler = NSSelectorFromString(@"handleNavigationTransition:");
            _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:popHandler];
            _panGestureRecognizer.delegate = self;
            [self.view addGestureRecognizer:_panGestureRecognizer];
        }else{
            _panGestureRecognizer = edgePanGestureRecognizer;
            _panGestureRecognizer = nil;
        }
    }
    return _panGestureRecognizer;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        CGPoint point = [touch locationInView:self.view];
        // 在这里定义滑动pop范围
        return point.x < HH_SlideRange;
    }else if([self.superclass instancesRespondToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]){
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
