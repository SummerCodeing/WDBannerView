//
//  BannerCell.m
//  BannerView
//
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.
//

#import "BannerCell.h"

@implementation BannerCell

- (UIImageView *)mainImageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.mainImageView.userInteractionEnabled = true;
        self.coverView.userInteractionEnabled = true;
        [self addSubview:self.imageView];
        [self addSubview:self.coverView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (self.didClickedCellBlock) {
        self.didClickedCellBlock(self.tag, self);
    }
}

- (void)adjustSubView:(CGRect)superViewBounds {
    if (CGRectEqualToRect(self.imageView.frame, superViewBounds))  return;
    self.imageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
}

@end
