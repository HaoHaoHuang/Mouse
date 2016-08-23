使用NSTimer可能会碰到循环引用的问题。特别是当类具有NSTimer类型的成员变量，并且需要反复执行计时任务时。例如

_timer = [NSTimer scheduledTimerWithTimeInterval:5.0
target:self
selector:@selector(startCounting) userInfo:nil
repeats:YES];
类有一个成员变量_timer，给_timer设置的target为这个类本身。这样类保留_timer，_timer又保留了这个类，就会出现循环引用的问题，最后导致类无法正确释放。

解决这个问题的方式也很简单，当类的使用者能够确定不需要使用这个计时器时，就调用

[_timer invalidate];
_timer = nil;
这样就打破了保留环，类也可以正确释放。但是，这种依赖于开发者手动调用方法，才能让内存正确释放的方式不是一个非常好的处理方式。所以需要另外一种解决方案。如下所示：

@interface NSTimer (HHOptimizeTimer)
+(NSTimer *) HH_scheduledTimerWithTimeInterval:(NSTimeInterval) time
repeats:(BOOL) repeats
block:(void(^)())block;
@end

@implementation NSTimer (HHOptimizeTimer)
+ (NSTimer *)HH_scheduledTimerWithTimeInterval:(NSTimeInterval)time repeats:(BOOL)repeats block:(void (^)())block
{
return [self scheduledTimerWithTimeInterval:time target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void) blockInvoke:(NSTimer *) timer
{
void (^block)() = timer.userInfo;
if (block) {
block();
}
}
@end

定义一个NSTimer的类别，在类别中定义一个类方法。类方法有一个类型为块的参数（定义的块位于栈上，为了防止块被释放，需要调用copy方法，将块移到堆上）。使用这个类别的方式如下：

__weak ViewController *weakSelf = self;
_timer = [NSTimer HH_scheduledTimerWithTimeInterval:2 repeats:YES block:^{
__strong ViewController *strongSelf = weakSelf;
[strongSelf log];
}];
使用这种方案就可以防止NSTimer对类的保留，从而打破了循环引用的产生。__strong ViewController *strongSelf = weakSelf主要是为了防止执行块的代码时，类被释放了。在类的dealloc方法中，记得调用[_timer invalidate]。
