//
//  ZKLViewController.m
//  ZKLBannerView
//
//  Created by koudaishu on 2018/1/31.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import "ZKLViewController.h"
#import "ZKLBannerView.h"

@interface ZKLViewController ()
@property (nonatomic, strong) ZKLBannerView *bannerView;
@end

@implementation ZKLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bannerView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView cancelTimer];
}


- (ZKLBannerView *)bannerView {
    if (!_bannerView) {
//        图片名字
//        NSArray *imgArr = @[@"welcome1",@"welcome2",@"welcome3",@"welcome4"];
//        图片
//        NSArray *imgArr = @[[UIImage imageNamed:@"welcome1"],
//                            [UIImage imageNamed:@"welcome2"],
//                            [UIImage imageNamed:@"welcome3"],
//                            [UIImage imageNamed:@"welcome4"]];
//        图片url
//        NSArray *imgArr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg",
//                            @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2298568106,2800573255&fm=27&gp=0.jpg",
//                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517381048419&di=78a2e89fafcfeddef5462629e8c0398f&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F130331%2F240460-13033106243430.jpg"];
        
//        图片名字+图片+图片url
        NSArray *imgArr = @[@"welcome1",
                            [UIImage imageNamed:@"welcome2"],
                            @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg"];
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*4/7);
        _bannerView = [[ZKLBannerView alloc] initWithFrame:frame imageList:imgArr];
        _bannerView.autoCycle = YES;
        _bannerView.block = ^(NSInteger index) {
            NSLog(@"%ld",(long)index);
        };
    }
    return _bannerView;
}

@end
