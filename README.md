# TYBannerView

循环轮播图Banner

- 无限循环
- 3个UIImageView实现
- Masonry布局

效果：

![](./TYBanner.png)

使用：

```objective-c
   
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

```



项目内使用的三方（可根据项目替换）：

- [SDWebImage](https://github.com/SDWebImage/SDWebImage)
- [Masonry](https://github.com/SnapKit/Masonry)
- [TYTimer](https://github.com/lucifer001/TYTimer)
- [TAPageControl](https://github.com/TanguyAladenise/TAPageControl)

