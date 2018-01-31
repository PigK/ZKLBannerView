//
//  ZKLBannerView.h
//  ZKLBannerView
//
//  Created by koudaishu on 2018/1/30.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageControlAlignmentType) {
    PageControlAlignmentTypeLeft,
    PageControlAlignmentTypeCenter,
    PageControlAlignmentTypeRight
};

typedef void(^BannerViewBlock)(NSInteger index);

@interface ZKLBannerView : UIView

@property (nonatomic, assign) BOOL hidePageControl;//默认不隐藏
@property (nonatomic, assign) PageControlAlignmentType pageContolType; //默认居中
@property (nonatomic, strong) UIColor *currentColor;//默认灰色
@property (nonatomic, strong) UIColor *pageColor;//默认白色

@property (nonatomic, assign) BOOL autoCycle;//默认不自动轮播
@property (nonatomic, assign) CGFloat duration;//默认2秒

@property (nonatomic, copy) BannerViewBlock block;

- (instancetype)initWithFrame:(CGRect)frame imageList:(NSArray *)imageList;
- (void)cancelTimer;
@end



@interface ImageCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@end
