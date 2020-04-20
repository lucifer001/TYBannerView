//
//  ViewController.m
//  TYBannerView
//
//  Created by PEND_Q on 2020/4/21.
//  Copyright © 2020 轻舔指尖. All rights reserved.
//

#import "ViewController.h"
#import "TYBannerView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    NSArray *ary = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587413177565&di=076e826196958c58e41d520abb3eda7c&imgtype=0&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D1131668947%2C1681238496%26fm%3D214%26gp%3D0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3250711012,1012072792&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587413211791&di=9699189397484cd784ee626f8b3c0b5c&imgtype=0&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D1098255912%2C893638375%26fm%3D214%26gp%3D0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2222747798,2595429905&fm=26&gp=0.jpg"];
    
    TYBannerView *bannerView = [[TYBannerView alloc] init];
    bannerView.clickIndexBlock = ^(NSInteger index) {
        NSLog(@"%ld", (long)index);
    };
    [self.view addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(145);
        make.left.right.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
    }];
    
    [bannerView updateWithAry:ary];
}


@end
