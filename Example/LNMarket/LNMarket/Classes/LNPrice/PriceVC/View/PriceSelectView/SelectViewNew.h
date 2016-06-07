//
//  SelectViewNew.h
//  SelectView
//
//  Created by Jackie Liu on 16/4/11.
//  Copyright © 2016年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriangleMarkView.h"
typedef enum{
    DefaultType = 0,
    TriangleType = 1
}SelectMarkViewType;
@class SelectViewNew;
@protocol SelectViewDelegate  <NSObject>

- (void) selecterView:(SelectViewNew *)selecterView didSelectedAtItem:(NSInteger)selectItem;
@end

@interface SelectViewNew : UIView

@property (nonatomic, assign) NSInteger selectItem;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView * selecterMarkView;
@property (nonatomic, strong) TriangleMarkView *triangleMarkView;
//可从外部传来每个按钮的宽度
@property (nonatomic, assign) CGFloat perButtonWidth;
//selecterMarkView最小宽度
@property (nonatomic, assign) CGFloat minMarkViewWidth;
//下标类型
@property (nonatomic, assign) SelectMarkViewType markViewType;
@property (nonatomic, assign) id<SelectViewDelegate> delegate;


- (instancetype) initWithFrame:(CGRect)frame withArray:(NSArray *)buttonArray selectItem:(NSInteger)selectItem;
//设置 perButtonWidth和minMarkViewWidth 可调用刷新UI
- (void) reloadData;

@end
