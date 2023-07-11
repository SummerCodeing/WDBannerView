//
//  BannerPageControl.m
//  BannerView
//
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.

#import "BannerPageControl.h"

@implementation BannerPageControl
-(void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    if (self.isCustomType){
       [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
           UIImageView *dotView = (UIImageView *)subview;
           CGSize size = CGSizeMake(9, 6);
           dotView.backgroundColor = [UIColor clearColor];
           [dotView setFrame:CGRectMake(dotView.frame.origin.x, dotView.frame.origin.y, size.width, size.height)];
           if(dotView.subviews.count == 0){
               UIImageView *imageview = [[UIImageView alloc] initWithFrame:dotView.bounds];
               [dotView addSubview:imageview];
           }
           UIImageView *dotImageView = dotView.subviews.firstObject;
           if (idx == currentPage){
               dotImageView.image = self.currentDotImage;
           } else {
               dotImageView.image = self.defaultDotsImage;
           }
       }];
    }
}
@end
