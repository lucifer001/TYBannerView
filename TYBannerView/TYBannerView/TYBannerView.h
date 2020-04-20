//
//  XBanner.h
//  ProjectX
//
//  Created by PEND_Q on 2019/11/7.
//  Copyright © 2019 轻舔指尖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYBannerView : UIView

@property (copy, nonatomic) void(^clickIndexBlock)(NSInteger index);

- (void)updateWithAry:(NSArray * _Nullable)ary;

@end

NS_ASSUME_NONNULL_END
