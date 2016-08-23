# Mouse
目前该Demo并没有完善，近期工作较忙，待日后继续完善
使用示例：
        HHSegment *segement =  [HHSegment initSegment];
        segement.titleFont = XTT_UIFont_Font(14);
        segement.hasBorder = YES;
        segement.borderWidth = 1;
        segement.hasMessageDot = YES;
        segement.borderColor = [UIColor xtt_colorWithHexString:@"#505050"];
        segement.selectColor = [UIColor whiteColor];
        segement.titleColor = [UIColor xtt_colorWithHexString:@"#505050"];
        [segement addItems:@[@"消息",@"通知"] size:CGSizeMake(76*2,29) inView:self.view];
        weak(ws)
        segement.segmentClickBlock = ^(HHSegment *view,NSInteger selectedIndex){
            if (selectedIndex == SEGMENTTAG_Message) {
            }else if (selectedIndex == SEGMENTTAG_Notification){
            }
        };
        segement.swipScreenBlock = ^(UIView *segment,UISwipeGestureRecognizer *gesture){
            if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            }else {
            }
        };
        
      回调支持block与delegate，并且下划线与选中背景不能同时显示；
