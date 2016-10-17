//
//  SelectViewNew.m
//  SelectView
//
//  Created by Jackie Liu on 16/4/11.
//  Copyright © 2016年 wallstreetcn. All rights reserved.
//

#import "SelectViewNew.h"
#define KWidth [UIScreen mainScreen].bounds.size.width
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
CGFloat const kLimitFloat = 1;
@interface SelectViewNew()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *markViewWidthArray;
@end
@implementation SelectViewNew


- (void) addButtonWithArray:(NSArray *)BtnArray{
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height)];
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.userInteractionEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置滚动边距
    [self addSubview:self.mainScrollView];
//    self.mainScrollView.contentSize = self.;
    self.btnArray = [NSMutableArray arrayWithCapacity:0];
    self.markViewWidthArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger count = BtnArray.count;
    CGFloat width = KWidth/count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(i * width, 10, width, 23);
        [selectBtn setTitle:BtnArray[i] forState:UIControlStateNormal];
        [selectBtn setTitleColor:kUIColorFromRGB(0x8B8B8E) forState:UIControlStateNormal];
        [selectBtn setTitleColor:kUIColorFromRGB(0x4A90E2) forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = i;
        NSDictionary *dic = @{NSFontAttributeName:selectBtn.titleLabel.font};
        CGSize titleSize = [selectBtn.titleLabel.text sizeWithAttributes:dic];
        NSNumber *width = [NSNumber numberWithFloat:titleSize.width];
        [self.markViewWidthArray addObject:width];
        [self.btnArray addObject:selectBtn];
        [self.mainScrollView addSubview:selectBtn];
    }
    UIButton *defaultBtn = self.btnArray[self.selectItem];
    defaultBtn.selected = YES;
    self.selecterMarkView = [[UIView alloc] initWithFrame:CGRectMake(defaultBtn.frame.origin.x+(defaultBtn.frame.size.width-[self.markViewWidthArray[self.selectItem] floatValue])/2, 36, [self.markViewWidthArray[self.selectItem] floatValue], 2)];
    self.selecterMarkView.backgroundColor = kUIColorFromRGB(0x688FDB);
    [self.mainScrollView addSubview:self.selecterMarkView];
}

- (void) buttonDidSelected:(UIButton *)selectButton{
    
    for (NSInteger i = 0; i<self.btnArray.count; i++) {
        UIButton *btn = self.btnArray[i];
        if (btn.tag != selectButton.tag) {
            [btn setSelected:NO];
        }
    }
    self.selectItem = selectButton.tag;
    [selectButton setSelected:YES];
    [self.delegate selecterView:self didSelectedAtItem:self.selectItem];
    NSLog(@"%ld",(long)self.selectItem);
    if (self.markViewType == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.selecterMarkView.frame = CGRectMake(selectButton.frame.origin.x+(selectButton.frame.size.width-[self.markViewWidthArray[self.selectItem] floatValue])/2, 36,[self.markViewWidthArray[self.selectItem] floatValue], 2);
        }];
    }
    if (self.markViewType == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.triangleMarkView.frame = CGRectMake(selectButton.frame.origin.x+(selectButton.frame.size.width-7)/2, 36, 7.5, 4);
        }];
    }
    
    
}

- (instancetype) initWithFrame:(CGRect)frame withArray:(NSArray *)buttonArray selectItem:(NSInteger)selectItem{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.selectItem = selectItem;
        self.markViewType = 0;
        [self addButtonWithArray:buttonArray];
    }
    return self;
}

- (void) setPerButtonWidth:(CGFloat)perButtonWidth{
    if (_perButtonWidth != perButtonWidth && perButtonWidth > kLimitFloat){
        _perButtonWidth = perButtonWidth;
    }
}

- (void) setMinMarkViewWidth:(CGFloat)minMarkViewWidth{
    if (_minMarkViewWidth != minMarkViewWidth && minMarkViewWidth > kLimitFloat) {
        if (self.perButtonWidth > kLimitFloat) {
            if (minMarkViewWidth > self.perButtonWidth ) {
                _minMarkViewWidth = self.perButtonWidth;
            }else {
                _minMarkViewWidth = minMarkViewWidth;
            }
        }else{
            for (NSInteger i = 0; i < self.btnArray.count; i++) {
                UIButton *btn = self.btnArray[i];
                if (minMarkViewWidth > btn.bounds.size.width) {
                    minMarkViewWidth = btn.bounds.size.width;
                }else _minMarkViewWidth = minMarkViewWidth;
            }
        }
    }
}

- (void) setMarkViewType:(SelectMarkViewType)markViewType{
    if (_minMarkViewWidth != markViewType) {
        if (markViewType == 1) {
             UIButton *defaultBtn = self.btnArray[self.selectItem];
            self.triangleMarkView = [[TriangleMarkView alloc] initWithFrame:CGRectMake(defaultBtn.frame.origin.x+(defaultBtn.frame.size.width-7)/2, 36, 7.5, 4)];
            _markViewType = markViewType;
            [self.mainScrollView addSubview:self.triangleMarkView];
            [self.selecterMarkView removeFromSuperview];
        }
    }
}

- (void) reloadData{
    if (self.perButtonWidth > kLimitFloat) {
        self.mainScrollView.contentSize = CGSizeMake(self.btnArray.count*self.perButtonWidth, 35);
        for (NSInteger i = 0; i < self.btnArray.count; i++) {
            UIButton *selectBtn = self.btnArray[i];
            selectBtn.frame = CGRectMake(i*self.perButtonWidth, 0, self.perButtonWidth, 23);
            [self.btnArray replaceObjectAtIndex:i withObject:selectBtn];
        }
        UIButton *selectedBtn = self.btnArray[self.selectItem];
         self.selecterMarkView.frame = CGRectMake(selectedBtn.frame.origin.x + (selectedBtn.bounds.size.width - [self.markViewWidthArray[self.selectItem] floatValue])/2, 36, [self.markViewWidthArray[self.selectItem] floatValue], 2);
    }
    
    if (self.minMarkViewWidth > kLimitFloat) {
        UIButton *selectedBtn = self.btnArray[self.selectItem];
        self.selecterMarkView.frame = CGRectMake(selectedBtn.frame.origin.x + (selectedBtn.frame.size.width - self.minMarkViewWidth)/2, 36, self.minMarkViewWidth, 2);
        [self.markViewWidthArray removeAllObjects];
        for (NSInteger i = 0; i < self.btnArray.count; i++) {
            [self.markViewWidthArray addObject:[NSNumber numberWithFloat:self.minMarkViewWidth]];
        }
    }
    if (self.markViewType == 1) {
        UIButton *defaultBtn = self.btnArray[self.selectItem];
        self.triangleMarkView.frame = CGRectMake(defaultBtn.frame.origin.x+(defaultBtn.frame.size.width-7)/2, 36,  7.5, 4);
        self.triangleMarkView.backgroundColor = [UIColor whiteColor];

    }
    
}




@end
