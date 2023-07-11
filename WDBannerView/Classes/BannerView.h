//
//  BannerView.h
//  BannerView
//  0.0.2
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerCell.h"
#import "BannerPageControl.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,PageType){
    SYSTEM = 0,
    CUSTOM = 1
};
@class BannerView;
@protocol BannnerViewDataSource <NSObject>
@required
-(NSUInteger)numberOfCellsInBannerView:(BannerView *)bannerView;
-(BannerCell *)bannerView:(BannerView *)bannerView cellForRowAtIndexPath:(NSUInteger)index;
@end
@protocol BannnerViewDelegate <NSObject>
@required
-(CGFloat)cellWHRatio:(BannerView *)bannerView;
-(CGSize)sizeForCenterCell:(BannerView *)bannerView;
@optional
-(void)bannerView:(BannerView *)bannerView didSelectCellAtIndex:(NSUInteger)index;
-(void)bannerView:(BannerView *)bannerView scrollToIndex:(NSUInteger)index;
@end
@interface BannerView: UIView
@property (nonatomic, weak)   id <BannnerViewDataSource> dataSource;
@property (nonatomic, weak)   id <BannnerViewDelegate>   delegate;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat leftRightMargin;
@property (nonatomic, assign) CGFloat topBottomMargin;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL isCarousel;
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) PageType pageControlType;
@property (nonatomic, copy)   NSString *currentPageDotImageName;
@property (nonatomic, copy)   NSString *defaultPageDotImageName;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
- (void)reloadData;
- (BannerCell *)dequeueReusableCell;
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
