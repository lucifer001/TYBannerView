//
//  TYGCDTimer.m
//  TYTimer
//
//  Created by PEND_Q on 2020/4/20.
//  Copyright © 2020 轻舔指尖. All rights reserved.
//

#import "TYGCDTimer.h"

static char * const queue_name = "com.timer.queue.name.ty";

@implementation TYGCDTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semphore_;
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semphore_ = dispatch_semaphore_create(1);
    });
}

+ (void)scheduledTimer:(NSString *)timerId
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async
                  task:(dispatch_block_t)task
{
    if (timerId.length == 0 ||
        !task ||
        start < 0 ||
        (interval <= 0 && repeats)) return;
    
    [[self class] stopTimer:timerId];
    
    dispatch_queue_t queue = async ? dispatch_queue_create(queue_name, NULL) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(start * NSEC_PER_SEC)), (uint64_t)(interval * NSEC_PER_SEC), 0);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [[self class] stopTimer:timerId];
        }
    });
    
    dispatch_resume(timer);
    
    dispatch_semaphore_wait(semphore_, DISPATCH_TIME_FOREVER);
    timers_[timerId] = timer;
    dispatch_semaphore_signal(semphore_);
}

+ (void)stopTimer:(NSString *)timerId
{
    if (timerId.length == 0) {
        return;
    }
    dispatch_semaphore_wait(semphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[timerId];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:timerId];
    }
    dispatch_semaphore_signal(semphore_);
}

@end
