//
//  ZKLBannerView.m
//  ZKLBannerView
//
//  Created by koudaishu on 2018/1/30.
//  Copyright © 2018年 zkl. All rights reserved.
//

#import "ZKLBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString * const imageCollectionCell = @"imageCollectionCell";

@interface ZKLBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *bannerView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imgList;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ZKLBannerView

- (instancetype)initWithFrame:(CGRect)frame imageList:(NSArray *)imageList {
    if (self = [super initWithFrame:frame]) {
        self.imgList = [imageList copy];
        
        [self addSubview:self.bannerView];
        [self addSubview:self.pageControl];
        
        [self baseConfig];
    }
    return self;
}


#pragma mark - private method
- (void)baseConfig {
    self.duration        = 2.0;
    
    self.pageColor       = [UIColor lightGrayColor];
    self.currentColor    = [UIColor whiteColor];
    self.pageContolType  = PageControlAlignmentTypeCenter;
    self.hidePageControl = NO;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayoutWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize                    = frame.size;
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing          = 0;
    layout.minimumInteritemSpacing     = 0;
    return layout;
}

//自动轮播
- (void)aotuScrolling {

    NSIndexPath *indexPath = nil;
    NSIndexPath *currentIndexPath = [self.bannerView indexPathForItemAtPoint:self.bannerView.contentOffset];

    if (currentIndexPath.item == [self.bannerView numberOfItemsInSection:0]-1) {
        indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }else {
        indexPath = [NSIndexPath indexPathForItem:currentIndexPath.item+1 inSection:0];
    }
    [self.bannerView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionRight
                                    animated:YES];
}

- (void)configTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration
                                                  target:self
                                                selector:@selector(aotuScrolling)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)cancelTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCollectionCell forIndexPath:indexPath];
    id image = self.imgList[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        NSString *headStr = [image substringToIndex:4];
        if ([headStr isEqualToString:@"http"]) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage new]];
        }else {
            cell.imgView.image = [UIImage imageNamed:image];
        }
    }else if ([image isKindOfClass:[UIImage class]]) {
        cell.imgView.image = image;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(indexPath) weakIndexPath = indexPath;
    if (self.block) {
        self.block(weakIndexPath.row);
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width    = self.frame.size.width;
    NSUInteger count = self.imgList.count;
    
    if (scrollView.contentOffset.x == (count-1)*width) {
        [scrollView setContentOffset:CGPointMake(width, 0)];
    }
    if (scrollView.contentOffset.x == 0) {
        [scrollView setContentOffset:CGPointMake((count-2)*width, 0)];
    }
    
    CGPoint point                = scrollView.contentOffset;
    NSUInteger index             = point.x/width;
    self.pageControl.currentPage = index==count-1 ? 0 : index-1;
}

#pragma mark - getters & setters
- (UICollectionView *)bannerView {
    if (!_bannerView) {
        UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutWithFrame:self.frame];
        _bannerView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        
        _bannerView.bounces = NO;
        _bannerView.pagingEnabled = YES;
        _bannerView.showsVerticalScrollIndicator = NO;
        _bannerView.showsHorizontalScrollIndicator = NO;
        
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        [_bannerView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:imageCollectionCell];
    }
    return _bannerView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.imgList.count-2;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = _hidePageControl;
}

- (void)setPageContolType:(PageControlAlignmentType)pageContolType {
    _pageContolType = pageContolType;
    
    CGSize size    = [self.pageControl sizeForNumberOfPages:self.imgList.count];
    
    CGFloat leftSpacing = 15;
    CGFloat bottomSpacing = 30;
    
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height - bottomSpacing;
    
    if (_pageContolType == PageControlAlignmentTypeCenter) {
        self.pageControl.frame = CGRectMake((width-size.width)/2, height, size.width, size.height);
    }else if (_pageContolType == PageControlAlignmentTypeLeft) {
        self.pageControl.frame = CGRectMake(leftSpacing, height, size.width, size.height);
    }else {
        self.pageControl.frame = CGRectMake(width-size.width-leftSpacing, height, size.width, size.height);
    }
}

- (void)setAutoCycle:(BOOL)autoCycle {
    _autoCycle = autoCycle;
    
    [self cancelTimer];
    if (_autoCycle) {
        [self configTimer];
    }
}

- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = _pageColor;
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    self.pageControl.currentPageIndicatorTintColor = _currentColor;
}

- (void)setImgList:(NSArray *)imgList {

    NSMutableArray *tempArr = [imgList mutableCopy];
    [tempArr addObject:imgList.firstObject];
    [tempArr insertObject:[imgList lastObject] atIndex:0];
    _imgList = [tempArr copy];
    
    __weak typeof(self) weakSelf = self;
    [self.bannerView performBatchUpdates:^{
        [weakSelf.bannerView reloadData];
    } completion:^(BOOL finished) {
        [weakSelf.bannerView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }];
}

@end


@implementation ImageCollectionCell

#pragma mark - getters & setters
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}


@end
