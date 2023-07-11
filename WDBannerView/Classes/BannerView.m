//
//  BannerView.m
//  BannerView
//
//  Created by wangwei on 2019/11/12.
//  Copyright © 2019 WW. All rights reserved.
//

#import "BannerView.h"
@interface BannerView()<UIScrollViewDelegate>
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  NSTimer *timer;
@property (nonatomic, strong)  BannerPageControl *pageControl;
@property (nonatomic, assign)  NSInteger pageCount;
@property (nonatomic, strong)  NSMutableArray *cells;
@property (nonatomic, assign)  NSRange visibleRange;
@property (nonatomic, assign)  NSUInteger orginPageCount;
@property (nonatomic, assign)  NSInteger page;
@property (nonatomic, assign)  CGSize pageSize;
@property (nonatomic, strong)  NSMutableArray *reusableCells;
@end
static NSString *_cellName = @"BannerCell";
@implementation BannerView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initViewAndData];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]){
        [self initViewAndData];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 15, self.frame.size.width, 10);
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    if (_autoScroll){
        [self startTimer];
    }
}
-(void)initViewAndData{
    self.clipsToBounds = YES;
    self.pageCount = 0;
    self.autoScroll = YES;
    self.isCarousel = YES;
    self.leftRightMargin = 20;
    self.topBottomMargin = 30;
    _currentIndex = 0;
    
    _minimumPageAlpha = 0.0;
    self.autoScrollInterval = 2.0;
    
    self.visibleRange = NSMakeRange(0, 0);
    
    self.reusableCells = [[NSMutableArray alloc] initWithCapacity:0];
    self.cells = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.pageControl = [[BannerPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 10)];
    [self addSubview:self.pageControl];
}
-(void)setCurrentPageDotImageName:(NSString *)currentPageDotImageName{
    _currentPageDotImageName = currentPageDotImageName;
    self.pageControl.currentDotImage = [UIImage imageNamed:currentPageDotImageName];
}
-(void)setDefaultPageDotImageName:(NSString *)defaultPageDotImageName{
    _defaultPageDotImageName = defaultPageDotImageName;
    self.pageControl.defaultDotsImage = [UIImage imageNamed:defaultPageDotImageName];
}
-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(void)setPageControlType:(PageType)pageControlType{
    _pageControlType = pageControlType;
    switch (pageControlType) {
        case SYSTEM:
            self.pageControl.isCustomType = false;
            break;
        case CUSTOM:
            self.pageControl.isCustomType = true;
            break;
        default:
            break;
    };
}
- (void)setLeftRightMargin:(CGFloat)leftRightMargin {
    _leftRightMargin = leftRightMargin * 0.5;
    
}
- (void)setTopBottomMargin:(CGFloat)topBottomMargin {
    _topBottomMargin = topBottomMargin * 0.5;
}
- (void)startTimer {
    if (self.orginPageCount > 1 && self.autoScroll && self.isCarousel) {
        if (self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer timerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)scrollToNext {
    self.page ++;
    [_scrollView setContentOffset:CGPointMake(self.page * _pageSize.width, 0) animated:true];
}
- (void)reloadData {
    //移除所有self.scrollView的子控件
    for (UIView *view in self.scrollView.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:_cellName] || [view isKindOfClass:[BannerCell class]]) {
            [view removeFromSuperview];
        }
    }
    [self stopTimer];
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfCellsInBannerView:)]) {
        //获取轮播数量
        self.orginPageCount = [_dataSource numberOfCellsInBannerView:self];
        //获取需要实现轮播的总数量
        if (self.isCarousel) {
            //自动轮播
            _pageCount = self.orginPageCount == 1 ? 1: self.orginPageCount * 3;
        }else {
            _pageCount = self.orginPageCount;
        }
        if (_pageCount == 0) {
            return;
        }
        if (_pageCount <= 1){
            self.pageControl.hidden = true;
        } else {
            self.pageControl.hidden = false;
            if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
                [self.pageControl setNumberOfPages:self.orginPageCount];
            }
        }
    }
    //重置pageWidth
    _pageSize = CGSizeMake(self.bounds.size.width - 4 * self.leftRightMargin,(self.bounds.size.width - 4 * self.leftRightMargin) * [_delegate cellWHRatio:self]);
    if ([self.delegate respondsToSelector:@selector(sizeForCenterCell:)]) {
        _pageSize = [self.delegate sizeForCenterCell:self];
    }
    
    [_reusableCells removeAllObjects];
    _visibleRange = NSMakeRange(0, 0);
    
    //填充cells数组
    [_cells removeAllObjects];
    for (NSInteger index=0; index<_pageCount; index++)
    {
        [_cells addObject:[NSNull null]];
    }
    
    // 重置_scrollView的contentSize
    _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount,0);
    CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _scrollView.center = theCenter;
    if (self.orginPageCount > 1) {
        if (self.isCarousel) {
            //滚到第二组
            [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
            self.page = self.orginPageCount;
            //启动自动轮播
            [self startTimer];
        }else {
            //滚到开始
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            self.page = self.orginPageCount;
        }
    }
    [self setPagesAtContentOffset:_scrollView.contentOffset];//根据当前scrollView的offset设置cell
    
    [self refreshVisibleCellAppearance];//更新各个可见Cell的显示外貌
}
- (void)setPagesAtContentOffset:(CGPoint)offset{
    //计算_visibleRange
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    NSInteger startIndex = 0;
    for (int i =0; i < [_cells count]; i++) {
        if (_pageSize.width * (i +1) > startPoint.x) {
            startIndex = i;
            break;
        }
    }
    
    NSInteger endIndex = startIndex;
    for (NSInteger i = startIndex; i < [_cells count]; i++) {
        //如果都不超过则取最后一个
        if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i+ 2 == [_cells count]) {
            endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
            break;
        }
    }
    //可见页分别向前向后扩展一个，提高效率
    startIndex = MAX(startIndex - 1, 0);
    endIndex = MIN(endIndex + 1, [_cells count] - 1);
    self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        [self setPageAtIndex:i];
    }
    for (int i = 0; i < startIndex; i ++) {
        [self removeCellAtIndex:i];
    }
    for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
        [self removeCellAtIndex:i];
    }
}
- (void)setPageAtIndex:(NSInteger)pageIndex{
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);
    
    BannerCell *cell = [_cells objectAtIndex:pageIndex];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [_dataSource bannerView:self cellForRowAtIndexPath:pageIndex % self.orginPageCount];
        NSAssert(cell!=nil, @"datasource must not return nil");
        [_cells replaceObjectAtIndex:pageIndex withObject:cell];
        
        cell.tag = pageIndex % self.orginPageCount;
        [cell adjustSubView:CGRectMake(0, 0, _pageSize.width, _pageSize.height)];
        
        __weak __typeof(self) weakSelf = self;
        cell.didClickedCellBlock = ^(NSInteger tag, BannerCell * _Nonnull cell) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bannerView:didSelectCellAtIndex:)]) {
                [weakSelf.delegate bannerView:self didSelectCellAtIndex:tag];
            }
        };
        cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
    }
}
- (void)queueReusableCell:(BannerCell *)cell{
    [_reusableCells addObject:cell];
}

- (void)removeCellAtIndex:(NSInteger)index{
    BannerCell *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) {
        return;
    }
    [self queueReusableCell:cell];
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}
- (void)refreshVisibleCellAppearance{
    if (_minimumPageAlpha == 1.0 && self.leftRightMargin == 0 && self.topBottomMargin == 0) {
        return;//无需更新
    }
    CGFloat offset = _scrollView.contentOffset.x;
    for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
        BannerCell *cell = [_cells objectAtIndex:i];
        CGFloat origin = cell.frame.origin.x;
        CGFloat delta = fabs(origin - offset);//
        CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
        if (delta < _pageSize.width) {
            cell.coverView.alpha = (delta / _pageSize.width) * _minimumPageAlpha;
            CGFloat leftRightInset = self.leftRightMargin * delta / _pageSize.width;
            CGFloat topBottomInset = self.topBottomMargin * delta / _pageSize.width;
            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2)/_pageSize.height, 1.0);
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
        } else {
            cell.coverView.alpha = _minimumPageAlpha;
            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-self.leftRightMargin*2)/_pageSize.width,(_pageSize.height-self.topBottomMargin*2)/_pageSize.height, 1.0);
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(self.topBottomMargin, self.leftRightMargin, self.topBottomMargin, self.leftRightMargin));
        }
    }
}
- (BannerCell *)dequeueReusableCell{
    BannerCell *cell = [_reusableCells lastObject];
    if (cell){
        [_reusableCells removeLastObject];
    }
    return cell;
}
-(void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated{
    if (index < _pageCount) {
        //首先停止定时器
        [self stopTimer];
        if (self.isCarousel) {
            self.page = index + self.orginPageCount;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startTimer) object:nil];
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.5];
        }else {
            self.page = index;
        }
        
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.page, 0) animated:animated];
        [self setPagesAtContentOffset:_scrollView.contentOffset];
        [self refreshVisibleCellAppearance];
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x;
        newPoint.y = point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y;
        if ([_scrollView pointInside:newPoint withEvent:event]) {
            return [_scrollView hitTest:newPoint withEvent:event];
        }
        return _scrollView;
    }
    return nil;
}
//MARK:- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.orginPageCount == 0) {
        return;
    }
    //当前的index
    NSInteger pageIndex = pageIndex = (int)round(_scrollView.contentOffset.x / _pageSize.width) % self.orginPageCount;
    
    if (self.isCarousel) {
        //无限轮播
        if (self.orginPageCount > 1) {
            if (scrollView.contentOffset.x / _pageSize.width >= 2 * self.orginPageCount) {
                //中间部分-右边最后一个
                [scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                self.page = self.orginPageCount;
            }
            if (scrollView.contentOffset.x / _pageSize.width <= self.orginPageCount - 1) {
                //中间部分-左边第一个的前一个
                [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _pageSize.width, 0) animated:NO];
                self.page = 2 * self.orginPageCount;
            }
        }else {
            //只有一个数据源
            pageIndex = 0;
            
        }
    }
    
    
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        [self.pageControl setCurrentPage:pageIndex];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:scrollToIndex:)] && _currentIndex != pageIndex && pageIndex >= 0) {
        [_delegate bannerView:self scrollToIndex:pageIndex];
    }
    
    _currentIndex = pageIndex;
}

//MARK:- 将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

//MARK:- 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

//MARK:- 将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.orginPageCount > 1 && self.autoScroll && self.isCarousel) {
        if (self.page == floor(_scrollView.contentOffset.x / _pageSize.width)) {
            self.page = floor(_scrollView.contentOffset.x / _pageSize.width) + 1;
        }else {
            self.page = floor(_scrollView.contentOffset.x / _pageSize.width);
        }
    }
}
//MARK:- 解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

//MARK:- 解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _scrollView.delegate = nil;
}
@end
