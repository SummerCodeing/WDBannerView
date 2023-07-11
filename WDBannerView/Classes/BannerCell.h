//
//  BannerCell.h
//  BannerView
//
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerCell : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, copy) void (^didClickedCellBlock)(NSInteger tag, BannerCell *cell);
- (void)adjustSubView:(CGRect)superViewBounds;
@end

NS_ASSUME_NONNULL_END
