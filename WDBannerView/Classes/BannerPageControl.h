//
//  BannerPageControl.h
//  BannerView
//
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerPageControl : UIPageControl
@property (nonatomic, assign) BOOL isCustomType;
@property (nonatomic, strong) UIImage *defaultDotsImage;
@property (nonatomic, strong) UIImage *currentDotImage;
@end

NS_ASSUME_NONNULL_END
