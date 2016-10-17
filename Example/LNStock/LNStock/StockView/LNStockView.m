//
//  LNQuotesView.m
//  Market
//
//  Created by vvusu on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockView.h"
#import "LNStockVC.h"
#import "ViewUtils.h"
#import "LNStockMenuView.h"
#import "LNStockListView.h"
#import "LNStockTitleView.h"
#import "LNStockLodingView.h"
#import "LNStockModel.h"
#import "LNRealModel.h"
#import "LNStockNetwork.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "LNStockHeaderView.h"
#import "NSTimer+LNStock.h"
#import "LNStockOptionView.h"
#import "LNStockFormatter.h"
#import "LNStockLayout.h"
#import <LNChart/LNChartView.h>

@interface LNStockView ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIView *chartBGView;
@property (nonatomic, strong) UIButton *adjustBtn;
@property (nonatomic, strong) LNChartView *topChartView;
@property (nonatomic, strong) LNStockListView *listView;
@property (nonatomic, strong) LNChartView *bottomChartView;
@property (nonatomic, strong) LNStockHeaderView *headerView;
@property (nonatomic, strong) LNStockLodingView *lodingView;
@property (nonatomic, strong) LNStockOptionView *optionView;
@property (nonatomic, strong) LNStockTitleView *stockTitleView;

@property (nonatomic, strong) LNStockHandler *stockInfo;
@property (nonatomic, strong) LNStockLayout *stockLayout;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapTwoGestureRecognizer;
@end

@implementation LNStockView

- (void)dealloc {
    [self stopPollRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark - Init
+ (instancetype)createViewWithCode:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight{
    CGRect frame = CGRectMake(0, 0, kFBaseWidth, kFStockBGH);
    return [LNStockView createViewWithFrame:frame code:code isAstock:isAstock isNight:isNight];
}

+ (instancetype)createViewWithFrame:(CGRect)frame code:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight {
    [LNStockHandler sharedManager].nightMode = isNight;
    if (!isAstock) {
        [LNStockHandler sharedManager].titleType = LNChartTitleType_1H;
        [LNStockHandler sharedManager].chartType = LNStockChartType_Candles;
    }
    return [LNStockView createViewWithCode:code isAstock:isAstock frame:frame];
}

+ (instancetype)createViewWithCode:(NSString *)code isAstock:(BOOL)isAstock frame:(CGRect)frame {
    LNStockView *stockView = [[LNStockView alloc]initWithFrame:frame];
    stockView.stockInfo.priceType = isAstock ? LNStockPriceTypeA : LNStockPriceTypeB;
    stockView.stockInfo.code = code;
    [stockView setupViews];
    return stockView;
}

+ (instancetype)createWithStockInfo:(LNStockHandler *)stockInfo frame:(CGRect)frame {
    LNStockView *stockView = [[LNStockView alloc]initWithFrame:frame];
    stockView.stockInfo = stockInfo;
    [stockView setupViews];
    return stockView;
}

- (void)setupViews {
    _timeInterval = 5.0f;
    self.stockLayout = [[LNStockLayout alloc]init];
    self.stockLayout.stockFrame = self.frame;
    [self.stockLayout defaultSetWithIsAStock:[self.stockInfo isAStock]];
    self.backgroundColor = [UIColor blackColor];
    
    if ([LNStockHandler isVerticalScreen]) { [self addSubview:self.headerView]; } //创建HeaderView
    if ([self.stockInfo isAStock]) { [self addSubview:self.listView]; }           //创建ListView
    [self addSubview:self.quoteTitleView];   //添加titleView
    [self addSubview:self.chartBGView];      //创建chart背景图
    [self addSubview:self.lodingView];       //添加LodingView
    [self setupColors];                      //设置颜色
    [self setupGestureRecognizer];           //注册手势
    [self refreshTitleView];                 //初始化开始请求数据
    [self startPollRequest];                 //开始轮询
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTitleView)
                                                 name:LNQuoteTitleViewNotification
                                               object:nil];
}

- (void)setupGestureRecognizer {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [self.tapGestureRecognizer addTarget:self action:@selector(tapOneAction:)];
    [self.chartBGView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.tapTwoGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    self.tapTwoGestureRecognizer.numberOfTapsRequired = 2;
    [self.tapTwoGestureRecognizer addTarget:self action:@selector(tapTwoAction:)];
    [self.chartBGView addGestureRecognizer:self.tapTwoGestureRecognizer];
}

- (void)setupColors {
    [self.headerView setupColor];
    [self.listView setupColor];
    [self.stockTitleView setupColor];
    self.lodingView.backgroundColor = [LNStockColor chartBG];
    self.topChartView.backgroundColor = [LNStockColor chartBG];
    self.bottomChartView.backgroundColor = [LNStockColor chartBG];
    self.topChartView.gridBackgroundColor = [LNStockColor chartBG];
    self.bottomChartView.gridBackgroundColor = [LNStockColor chartBG];
    self.topChartView.borderColor = [LNStockColor chartBorder];
    self.topChartView.xAxis.gridColor = [LNStockColor chartBorder];
    self.topChartView.leftAxis.gridColor = [LNStockColor chartBorder];
    self.bottomChartView.borderColor = [LNStockColor chartBorder];
    self.bottomChartView.xAxis.gridColor = [LNStockColor chartBorder];
    self.bottomChartView.leftAxis.gridColor = [LNStockColor chartBorder];
    self.topChartView.data.highlighter.labelBGColor = [LNStockColor chartHighlighterLabelBG];
    self.bottomChartView.data.highlighter.labelBGColor = [LNStockColor chartHighlighterLabelBG];
    self.topChartView.data.highlighter.levelLineColor = [LNStockColor chartHighlighterLine];
    self.topChartView.data.highlighter.verticalLineColor = [LNStockColor chartHighlighterLine];
    self.bottomChartView.data.highlighter.levelLineColor = [LNStockColor chartHighlighterLine];
    self.bottomChartView.data.highlighter.verticalLineColor = [LNStockColor chartHighlighterLine];
}

#pragma  mark - Get Set

- (void)setIsGreenUp:(BOOL)isGreenUp {
    _isGreenUp = isGreenUp;
    [LNStockHandler sharedManager].greenUp = _isGreenUp;
    if ([self.stockInfo isAStock]) {
        self.bottomChartView.data.candleSet.greenUp = _isGreenUp;
    }
    self.topChartView.data.candleSet.greenUp = _isGreenUp;
    [self refreshChartData];
}

- (void)setIsNightMode:(BOOL)isNightMode {
    _isNightMode = isNightMode;
    [LNStockHandler sharedManager].nightMode = _isNightMode;
    [self setupColors];
    [self refreshChartData];
}

//headerView
- (LNStockHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LNStockHeaderView alloc]initWithStockInfo:self.stockInfo];
    }
    return _headerView;
}

//创建上部视图
- (LNChartView *)topChartView {
    __weak typeof(self) wself= self;
    if (!_topChartView) {
        _topChartView = [[LNChartView alloc]init];
        _topChartView.frame = CGRectMake(0, 0, _chartBGView.bounds.size.width, _chartBGView.frame.size.height - _stockLayout.bottomChartViewH);
        _topChartView.chartViewType = ChartViewType_Line;
        _topChartView.data.candleSet.greenUp = [LNStockHandler isGreenUp];
        _topChartView.data.lineSet.endFillColor = [LNStockColor chartLineFillEndColor];
        _topChartView.data.lineSet.startFillColor = [LNStockColor chartLineFillStartColor];
        _topChartView.data.candleSet.candleRiseColor = [LNStockColor chartCandleRiseColor];
        _topChartView.data.candleSet.candleFallColor = [LNStockColor chartCandleFallColor];
        _topChartView.limitLine.lineColor = [LNStockColor chartLimitLine];
        _topChartView.data.lineSet.lineColors = @[[LNStockColor chartLine], [LNStockColor chartAVGLine]];
        _topChartView.data.candleSet.MAColors = @[[LNStockColor chartMA1], [LNStockColor chartMA2], [LNStockColor chartMA3], [LNStockColor chartMA4], [LNStockColor chartMA5]];
        
        if ([LNStockHandler isVerticalScreen]) {
            _topChartView.leftAxis.labelPosition = YAxisLabelPositionInsideChart;
            _topChartView.rightAxis.labelPosition = YAxisLabelPositionInsideChart;
            _topChartView.data.highlighter.positionType = HighlightPositionLeftInside;
            [_topChartView removeGestureRecognizer:_topChartView.panGestureRecognizer];
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:15];
        }
        if (![self.stockInfo isAStock]) {
            if (![LNStockHandler isVerticalScreen]) { _topChartView.zoomEnabled = YES; }
            _topChartView.leftAxis.drawLabelsEnabled = NO;
            _topChartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
            _topChartView.rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
            _topChartView.data.highlighter.positionType = HighlightPositionRightOut;
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:45 offsetBottom:30];
        }    
        _topChartView.anctionBlock = ^(LNChartActionType type, LNChartData *data, id empty, BOOL isEnd) {
            switch (type) {
                case LNChartActionType_Pan:
                    [wself.bottomChartView slidingPage:isEnd data:data];
                    break;
                case LNChartActionType_Pinch:
                    [wself.bottomChartView zoomPage:data];
                    break;
                case LNChartActionType_LongPress:
                    [wself.bottomChartView addCrossLine:data.highlighter longPress:empty];
                    [wself changeAdjustButtonHiddenStatus:data.highlighter.isHighlight];
                    wself.stockInfo.longPress = data.highlighter.isHighlight;
                    if (data.highlighter.isHighlight) {
                        [wself.quoteTitleView showInfoViewWithArray:wself.dataArr Index:data.highlighter.index];
                    } else {
                        [wself.quoteTitleView hiddenInfoView];
                    }
                    break;
                case LNChartActionType_LeftAction:  //左拉加載數據回調
                    if ([wself.stockInfo isAStock]) {
                        [wself requestAstockDataWithType:LNStockRequestType_LoadMore];
                    } else {
                        [wself requestBstockDataWithType:LNStockRequestType_LoadMore];
                    }
                    break;
                case LNChartActionType_RightAction: //右拉加载
                    break;
            }
        };
    }
    return _topChartView;
}

//创建底部视图
- (LNChartView *)bottomChartView {
    __weak typeof(self) wself= self;
    if (!_bottomChartView) {
        _bottomChartView = [[LNChartView alloc]init];
        _bottomChartView.frame = CGRectMake(0, CGRectGetMaxY(self.topChartView.frame), self.topChartView.frame.size.width, _stockLayout.bottomChartViewH);
        [self updateBottomChartViewType];
        _bottomChartView.drawInfoEnabled = NO;
        _bottomChartView.data.sizeRatio = 1.0;
        _bottomChartView.data.drawLoadMoreContent = NO;
        _bottomChartView.data.candleSet.greenUp = [LNStockHandler isGreenUp];
        _bottomChartView.data.candleSet.candleRiseColor = [LNStockColor chartCandleRiseColor];
        _bottomChartView.data.candleSet.candleFallColor = [LNStockColor chartCandleFallColor];
        [_bottomChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:45 offsetBottom:0];
        
        if ([LNStockHandler isVerticalScreen]) {
            _bottomChartView.leftAxis.labelPosition = YAxisLabelPositionInsideChart;
            _bottomChartView.rightAxis.labelPosition = YAxisLabelPositionInsideChart;
            _bottomChartView.data.highlighter.positionType = HighlightPositionLeftInside;
            [_bottomChartView removeGestureRecognizer:_bottomChartView.panGestureRecognizer];
            [_bottomChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:0];
        }
        _bottomChartView.anctionBlock = ^(LNChartActionType type, LNChartData *data, id empty, BOOL isEnd) {
            switch (type) {
                case LNChartActionType_Pan:
                    [wself.topChartView slidingPage:isEnd data:data];
                    break;
                case LNChartActionType_Pinch:
                    [wself.topChartView zoomPage:data];
                    break;
                case LNChartActionType_LongPress:
                    [wself.topChartView addCrossLine:data.highlighter longPress:empty];
                    [wself changeAdjustButtonHiddenStatus:data.highlighter.isHighlight];
                    wself.stockInfo.longPress = data.highlighter.isHighlight;
                    if (data.highlighter.isHighlight) {
                        [wself.quoteTitleView showInfoViewWithArray:wself.dataArr Index:data.highlighter.index];
                    } else {
                        [wself.quoteTitleView hiddenInfoView];
                    }
                    break;
                case LNChartActionType_LeftAction:  //左拉加載數據回調
                    if ([wself.stockInfo isAStock]) {
                        [wself requestAstockDataWithType:LNStockRequestType_LoadMore];
                    } else {
                        [wself requestBstockDataWithType:LNStockRequestType_LoadMore];
                    }
                    break;
                case LNChartActionType_RightAction: //右拉加载
                    break;
            }
        };
    }
    return _bottomChartView;
}

- (LNStockTitleView *)quoteTitleView {
    if (!_stockTitleView) {
        __weak typeof(self) wself= self;
        _stockTitleView = [[LNStockTitleView alloc] initWithFrame:CGRectMake(0, _stockLayout.headerViewH, _stockLayout.stockViewW, _stockLayout.titleViewH) stockInfo:self.stockInfo];
        [self refreshStockRealData];
        _stockTitleView.actionBlock = ^(LNStockTitleViewAction type) {
            switch (type) {
                //添加横屏刷新按钮动作
                case LNStockTitleViewAction_Refresh:
                    [wself refreshChartData];
                    break;
                //添加横屏关闭按钮动作
                case LNStockTitleViewAction_Close:
                    [wself tapTwoAction:nil];
                    break;
                //切换titleType刷新数据
                case LNStockTitleViewAction_UpDateTitleType:
                    [wself refreshChartData];
                    break;
                //切换ChartType刷新图像
                case LNStockTitleViewAction_UpDateChartType:
                    [wself refreshChartView];
                    break;
            }
        };
    }
    return _stockTitleView;
}

- (LNStockOptionView *)optionView {
    __weak typeof(self) wself= self;
    if (!_optionView) {
        CGRect rect = CGRectMake(_stockLayout.stockViewW - 60, _stockLayout.titleViewH, 60,_stockLayout.stockViewH - _stockLayout.titleViewH);
        _optionView = [[LNStockOptionView alloc]initWithFrame:rect stockInfo:self.stockInfo];
        _optionView.block = ^(LNOptionViewAction type){
            switch (type) {
                case LNOptionViewAction_Adjust:
                    [wself refreshChartData];
                    break;
                case LNOptionViewAction_Factor:
                    [wself refreshChartData];
                    break;
            }
        };
        if (![LNStockHandler isVerticalScreen]) {
            [self addSubview:_optionView];
        }
    }
    return _optionView;
}

- (UIView *)chartBGView {
    if (!_chartBGView) {
        _chartBGView = [[UIView alloc]init];
        _chartBGView.frame = CGRectMake(0, _stockLayout.titleViewH + _stockLayout.headerViewH, _stockLayout.stockViewW - _stockLayout.listViewW, _stockLayout.stockViewH - _stockLayout.titleViewH - _stockLayout.headerViewH);
        _chartBGView.backgroundColor = [UIColor blackColor];
        [_chartBGView addSubview:self.topChartView];
        if ([self.stockInfo  isAStock]) {
            [_chartBGView addSubview:self.bottomChartView];
        }
    }
    return _chartBGView;
}

- (LNStockLodingView *)lodingView {
    if (!_lodingView) {
        _lodingView = [[LNStockLodingView alloc]initWithFrame:CGRectMake(0, _stockLayout.headerViewH + _stockLayout.titleViewH, _stockLayout.stockViewW, _stockLayout.stockViewH - _stockLayout.titleViewH - _stockLayout.headerViewH)];
    }
    return _lodingView;
}

- (LNStockListView *)listView {
    if (!_listView) {
        _listView = [[LNStockListView alloc]initWithFrame:CGRectMake(_stockLayout.stockViewW - _stockLayout.listViewW, CGRectGetMaxY(self.quoteTitleView.frame), _stockLayout.listViewW, _stockLayout.stockViewH - _stockLayout.titleViewH - _stockLayout.headerViewH)];
        _listView.stockInfo = self.stockInfo;
        [_listView getBuyAndSaleGroupData];
    }
    return _listView;
}

- (UIButton *)adjustBtn {
    if (!_adjustBtn) {
        _adjustBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adjustBtn setFrame: CGRectMake(0, CGRectGetMaxY(_topChartView.frame) - 15, 50, 15)];
        [_adjustBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _adjustBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_adjustBtn setBackgroundColor:[UIColor grayColor]];
        [_adjustBtn addTarget:self action:@selector(adjustButtonAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self.stockInfo isAStock] && [LNStockHandler isVerticalScreen] && [self.stockInfo isStock] ) {
            [self.chartBGView addSubview:_adjustBtn];
        }
    }
    return _adjustBtn;
}

- (LNStockHandler *)stockInfo {
    if (!_stockInfo) {
        _stockInfo = [[LNStockHandler alloc]init];
        [_stockInfo defaultSet];
    }
    return _stockInfo;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - GestureRecognizerAction

- (void)tapOneAction:(UITapGestureRecognizer *)tap {
    //设置竖屏状态
    if ([LNStockHandler isVerticalScreen]) {
        LNStockVC *vc = [LNStockVC initWithStockInfo:self.stockInfo];
        [[self viewController] presentViewController:vc animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LNQuoteTitleViewNotification object:self userInfo:nil];
        if (self.quotesViewBlock) {
            self.quotesViewBlock(LNStockViewActionTypeTapOne);
        }
        [self stopPollRequest];      //切换停止轮询
    }
}

- (void)tapTwoAction:(UITapGestureRecognizer *)tap {
    [LNStockHandler sharedManager].verticalScreen = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:LNQuoteTitleViewNotification object:self userInfo:nil];
    if (self.quotesViewBlock) {
        self.quotesViewBlock(LNStockViewActionTypeTapTwo);
    }
    [self stopPollRequest];          //切换到小图图是停止轮询
}

#pragma mark - NotificationAction

- (void)refreshTitleView {
    [self startPollRequest];         //切换到小图是开始轮询
    [self refreshStockRealData];     //刷新实时行情
    [self refreshChartData];         //切换选中按钮
    [self updateAdjustButtonTitle];  //刷新前后复权Button
    [self.quoteTitleView changeChartTitleViewWithType:[LNStockHandler titleType]];
}

#pragma mark - Animation

- (void)showDealListView {
    self.optionView.hidden = YES;
    if (![self.stockInfo isIndexStock]) {
        self.listView.hidden = NO;
        self.chartBGView.frame = CGRectMake(0, _stockLayout.titleViewH + _stockLayout.headerViewH, _stockLayout.stockViewW - _stockLayout.listViewW, self.chartBGView.bounds.size.height);
        [self updateChartViewFrame];
    }
}

- (void)hiddenDealListView {
    self.listView.hidden = YES;
    if ([LNStockHandler titleType] == LNChartTitleType_5D || [LNStockHandler isVerticalScreen]) {
        self.optionView.hidden = YES;
        self.chartBGView.frame = CGRectMake(0, _stockLayout.titleViewH + _stockLayout.headerViewH, _stockLayout.stockViewW, self.chartBGView.bounds.size.height);
    } else {
        if ([self.stockInfo isIndexStock] && [LNStockHandler titleType] == LNChartTitleType_1m) {
            self.chartBGView.frame = CGRectMake(0, _stockLayout.titleViewH + _stockLayout.headerViewH, _stockLayout.stockViewW, self.chartBGView.bounds.size.height);
        } else {
            self.chartBGView.frame = CGRectMake(0, _stockLayout.titleViewH + _stockLayout.headerViewH, _stockLayout.stockViewW - 60, self.chartBGView.bounds.size.height);
            [self.optionView updateOptionView];
        }
    }
    [self updateChartViewFrame];
}

- (void)updateChartViewFrame {
    [self changeAdjustButtonHiddenStatus:NO];
    self.topChartView.frame = CGRectMake(0, 0, _chartBGView.frame.size.width, _chartBGView.frame.size.height - _stockLayout.bottomChartViewH);
    self.bottomChartView.frame = CGRectMake(0, CGRectGetMaxY(_topChartView.frame), _topChartView.frame.size.width, _stockLayout.bottomChartViewH);
}

#pragma mark - NStimer
- (void)startPollRequest {
    if (!_timer) {
        __weak typeof(self) wself= self;
        self.timer = [NSTimer ln_scheduledTimerWithTimeInterval:_timeInterval repeat:YES block:^{
            [wself refreshStockData];
        }];
    }
}

- (void)stopPollRequest {
    [self.timer invalidate];
    self.timer = nil;
}

//轮询数据
- (void)refreshStockData {
    [self refreshStockRealData];
    if ([self.stockInfo isAStock]) {
        switch ([LNStockHandler titleType]) {
            case LNChartTitleType_1m:
                [self refreshChartTypeMinute];
                if (![self.stockInfo isIndexStock]) {
                    [self.listView getBuyAndSaleGroupData];
                }
                break;
            case LNChartTitleType_5D:
                [self refreshChartTypeFiveDay];
                break;
            default:
                [self requestAstockDataWithType:LNStockRequestType_Refresh];
                break;
        }
    } else {
        [self requestBstockDataWithType:LNStockRequestType_Refresh];
    }
}

#pragma mark - Other

- (void)adjustButtonAction {
    __weak typeof(self) wself= self;
    NSArray *adjustBtnTitles =@[@"不复权",@"前复权",@"后复权"];
    [ViewUtils showActionSheetView:nil controller:[self viewController] titles:adjustBtnTitles completeBlock:^(int index) {
        if (index < adjustBtnTitles.count && index != [LNStockHandler adjustType]) {
            [LNStockHandler sharedManager].adjustType = index;
            [wself updateAdjustButtonTitle];
            [wself refreshChartData];
        }
    }];
}

- (void)updateAdjustButtonTitle {
    NSArray *adjustBtnTitles =@[@"不复权",@"前复权",@"后复权"];
    [self.adjustBtn setTitle:adjustBtnTitles[(long)[LNStockHandler adjustType]] forState:UIControlStateNormal];
}

//找到view的VC控制器
- (UIViewController *)viewController {
    return (UIViewController *)[self findFirstViewContrller:self];
}

- (UIResponder *)findFirstViewContrller:(UIResponder *)responder {
    if (responder && ![responder isKindOfClass:[UIViewController class]]) {
        return [self findFirstViewContrller:[responder nextResponder]];
    }
    return responder;
}

- (void)changeAdjustButtonHiddenStatus:(BOOL)highlight {
    if ([self.stockInfo isAStock]) {
        if (highlight) {
            self.adjustBtn.hidden = YES;
        } else {
            if (![self.stockInfo isStock] ||
                [LNStockHandler titleType] == LNChartTitleType_1m ||
                [LNStockHandler titleType] == LNChartTitleType_5D ||
                [LNStockHandler titleType] == LNChartTitleType_5m ||
                [LNStockHandler titleType] == LNChartTitleType_15m ||
                [LNStockHandler titleType] == LNChartTitleType_30m ||
                [LNStockHandler titleType] == LNChartTitleType_1H
                ) {
                self.adjustBtn.hidden = YES;
            } else {
                self.adjustBtn.hidden = NO;
            }
        }
    }
}

- (void)refreshChartView {
    [self updateTopChartViewType];
    [self refreshChart:[NSMutableArray arrayWithArray:[self getBStockEntityWithArray:self.dataArr]]];
}

- (void)updateTopChartViewType {
    switch ([LNStockHandler chartType]) {
        case LNStockChartType_Line:
            _topChartView.chartViewType = ChartViewType_Line;
            break;
        case LNStockChartType_Candles:
            _topChartView.chartViewType = ChartViewType_Candle;
            break;
        case LNStockChartType_HollowCandle:
            _topChartView.chartViewType = ChartViewType_HollowCandle;
            break;
        case LNStockChartType_Bars:
            _topChartView.chartViewType = ChartViewType_Bars;
            break;
    }
}

- (void)updateBottomChartViewType {
    NSInteger labelCount = 2;
    switch ([LNStockHandler factorType]) {
        case LNStockFactorType_Volume:
            _bottomChartView.chartViewType = ChartViewType_Columnar;
            break;
        case LNStockFactorType_MACD:
            _bottomChartView.chartLegend.contents = @[@"DIFF:",@"DEA:",@"MACD:"];
            _bottomChartView.chartViewType = ChartViewType_MACD;
            _bottomChartView.data.lineSet.lineColors = @[[LNStockColor chartDIFF],[LNStockColor chartDEA],[LNStockColor chartMACD]];
            break;
        case LNStockFactorType_BOLL:
            _bottomChartView.chartLegend.contents = @[@"UPPER:",@"MID:",@"LOWER:"];
            _bottomChartView.chartViewType = ChartViewType_BOLL;
            _bottomChartView.data.candleSet.candleColor = [LNStockColor chartCandleColor];
            _bottomChartView.data.lineSet.lineColors = @[[LNStockColor chartUPPER],[LNStockColor chartMID],[LNStockColor chartLOWER]];
            break;
        case LNStockFactorType_KDJ:
            labelCount = 3;
            _bottomChartView.chartViewType = ChartViewType_Line;
            _bottomChartView.leftAxis.drawGridLinesEnabled = YES;
            _bottomChartView.chartLegend.contents = @[@"K:",@"D:",@"J:"];
            _bottomChartView.data.lineSet.lineColors = @[[LNStockColor chartK],[LNStockColor chartD],[LNStockColor chartJ]];
            break;
        case LNStockFactorType_RSI:
            _bottomChartView.chartLegend.contents = @[@"RSI6:",@"RSI12:",@"RSI24:"];
            _bottomChartView.chartViewType = ChartViewType_Line;
            _bottomChartView.data.lineSet.lineColors = @[[LNStockColor chartRSI6],[LNStockColor chartRSI12],[LNStockColor chartRSI24]];
            break;
        case LNStockFactorType_OBV:
            _bottomChartView.chartLegend.contents = @[@"OBV:"];
            _bottomChartView.chartViewType = ChartViewType_OBV;
            _bottomChartView.data.lineSet.lineColors = @[[LNStockColor chartOBV]];
            break;
        default:
            _bottomChartView.chartViewType = ChartViewType_Line;
            break;
    }
    _bottomChartView.data.lineSet.fillEnabled = NO;
    _bottomChartView.leftAxis.labelCount = labelCount;
}

- (void)updateTopChartViewDateFormatter {
    switch ([LNStockHandler titleType]) {
        case LNChartTitleType_1m:
        case LNChartTitleType_5m:
        case LNChartTitleType_15m:
        case LNChartTitleType_30m:
        case LNChartTitleType_1H:
        case LNChartTitleType_2H:
        case LNChartTitleType_4H:
            if ([LNStockHandler isVerticalScreen]) {
                _topChartView.xAxis.dateFormatter = @"HH:mm";
            } else {
                _topChartView.xAxis.dateFormatter = @"MM-dd-HH:mm";
            }
            break;
        case LNChartTitleType_1D:
        case LNChartTitleType_1W:
        case LNChartTitleType_1M:
            if ([LNStockHandler isVerticalScreen]) {
                _topChartView.xAxis.dateFormatter = @"MM-dd";
            } else {
                _topChartView.xAxis.dateFormatter = @"yyyy-MM-dd";
            }
            break;
        default:
            break;
    }
}

- (void)refreshChart:(NSMutableArray *)dataArr {
    [self.topChartView setupWithData:dataArr];
    self.topChartView.data.precision = [self.stockInfo pricePrecision];
    if ([self.stockInfo isAStock]) {
        [self.bottomChartView setupWithData:dataArr];
        self.bottomChartView.data.precision = [self.stockInfo pricePrecision];
    }
}

- (void)setChartViewSize:(BOOL)isKline {
    if (isKline) {
        if ([LNStockHandler isVerticalScreen]) {
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:15];
            [_bottomChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:0];
        } else {
            [_topChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:0 offsetBottom:15];
            [_bottomChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:0 offsetBottom:0];
        }
    } else {
        if ([LNStockHandler isVerticalScreen]) {
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:15];
            [_bottomChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:0];
        } else {
            [_topChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:45 offsetBottom:15];
            [_bottomChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:45 offsetBottom:0];
        }
    }
}

#pragma mark - Chart Data
//刷新数据
- (void)refreshChartData {
    self.lodingView.hidden = NO;
    //删掉之前的Data
    [self.topChartView.data removeAllDataSet];
    [self.bottomChartView.data removeAllDataSet];
    //必须停止动画时间，会崩溃
    [self.topChartView.chartAction stopAnimation];
    [self.bottomChartView.chartAction stopAnimation];
    if ([self.stockInfo isAStock]) {
        [self hiddenDealListView]; //隐藏五档列表
        self.topChartView.data.lineSet.drawLastPoint = NO;
        switch ([LNStockHandler titleType]) {
            case LNChartTitleType_1m:
                [self showDealListView];
                _topChartView.data.valCount = 241;
                _topChartView.data.lineSet.drawPart = NO;
                _topChartView.xAxis.labelSite = XAxisLabelSiteCenter;
                _bottomChartView.xAxis.labelSite = XAxisLabelSiteCenter;
                _topChartView.data.xVals = [@[@"09:30",@"10:30",@"11:30/13:00",@"14:00",@"15:00"] mutableCopy];
                [self setLineChartView];
                [self refreshChartTypeMinute];
                break;
            case LNChartTitleType_5D:
                _topChartView.data.valCount = 245;
                _topChartView.data.lineSet.drawPart = YES;
                _topChartView.xAxis.dateFormatter = @"MM-dd";
                _topChartView.xAxis.labelSite = XAxisLabelSiteRight;
                _bottomChartView.xAxis.labelSite = XAxisLabelSiteRight;
                [self setLineChartView];
                [self refreshChartTypeFiveDay];
                break;
            case LNChartTitleType_5m:
            case LNChartTitleType_15m:
            case LNChartTitleType_30m:
            case LNChartTitleType_1H:
            case LNChartTitleType_1D:
            case LNChartTitleType_1W:
            case LNChartTitleType_1M:
                [self setChartViewSize:YES];
                _topChartView.chartViewType = ChartViewType_Candle;
                _topChartView.xAxis.labelSite = XAxisLabelSiteCenter;
                _topChartView.data.sizeRatio = 0.85;
                _topChartView.limitLine.drawEnabled = NO;
                _topChartView.rightAxis.drawLabelsEnabled = NO;
                _topChartView.data.highlighter.drawTimeLabel = YES;
                _topChartView.data.highlighter.drawPriceRatio = NO;
                _topChartView.dragEnabled = _topChartView.leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
                _topChartView.zoomEnabled = _topChartView.dragEnabled;
                _topChartView.chartLegend.drawEnabled = _topChartView.dragEnabled;
                
                _bottomChartView.chartViewType = ChartViewType_Columnar;
                _bottomChartView.xAxis.labelSite = XAxisLabelSiteCenter;
                _bottomChartView.chartLegend.drawEnabled = YES;
                _bottomChartView.rightAxis.drawLabelsEnabled = NO;
                _bottomChartView.leftAxis.drawGridLinesEnabled = NO;
                _bottomChartView.dragEnabled = _bottomChartView.leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
                _bottomChartView.zoomEnabled = _bottomChartView.dragEnabled;
                _bottomChartView.leftAxis.drawLabelsEnabled = _bottomChartView.leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
                [self updateTopChartViewDateFormatter];
                [self updateBottomChartViewType];
                [self requestAstockDataWithType:LNStockRequestType_Normal];
                break;
            case LNChartTitleType_NULL:
                break;
            default:
                break;
        }
    } else {
        [self updateTopChartViewType];
        [self updateTopChartViewDateFormatter];
        _topChartView.data.isBStock = YES;
        _topChartView.limitLine.drawTitle = YES;
        _topChartView.limitLine.drawEnabled = YES;
        _topChartView.chartLegend.drawEnabled = YES;
        _topChartView.data.highlighter.positionType = HighlightPositionRightOut;
        [self requestBstockDataWithType:LNStockRequestType_Normal];
    }
}

- (void)setLineChartView {
    [self setChartViewSize:NO];
    _topChartView.data.sizeRatio = 1.0;
    _topChartView.chartViewType = ChartViewType_Line;
    _topChartView.dragEnabled = NO;
    _topChartView.zoomEnabled = NO;
    _topChartView.limitLine.drawEnabled = YES;
    _topChartView.chartLegend.drawEnabled = NO;
    _topChartView.rightAxis.drawLabelsEnabled = YES;
    _topChartView.data.highlighter.drawTimeLabel = NO;
    _topChartView.data.highlighter.drawPriceRatio = YES;
    _bottomChartView.chartViewType = ChartViewType_Columnar;
    _bottomChartView.dragEnabled = NO;
    _bottomChartView.zoomEnabled = NO;
    _bottomChartView.chartLegend.drawEnabled = NO;
    _bottomChartView.rightAxis.drawLabelsEnabled = YES;
    _bottomChartView.rightAxis.drawLabelsEnabled = NO;
    _bottomChartView.leftAxis.drawGridLinesEnabled = NO;
    _bottomChartView.data.valCount = _topChartView.data.valCount;
    _bottomChartView.leftAxis.drawLabelsEnabled = _bottomChartView.leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
}

#pragma mark - A股
//A股和外汇Real接口
- (void)refreshStockRealData {
    __weak typeof(self) wself= self;
    if ([self.stockInfo isAStock] && ![LNStockHandler isVerticalScreen]) { //为了实时刷新横版股票时间用，后期会换
        [self refreshChartTypeMinute];
    }
    [LNStockNetwork getStockRealDataWithCode:self.stockInfo.code isAstock:[self.stockInfo isAStock] block:^(BOOL isSuccess, LNStockModel *model) {
        if (isSuccess) {
            [wself.headerView updateStockData:model];        //刷新横版头部试图
            [wself.stockTitleView refreshTitleView:model];   //刷新titleView
            wself.stockInfo.tradeStatus = model.trade_status;
            wself.stockInfo.stocktype = model.securities_type;
            wself.stockInfo.price_precision = model.price_precision;
            //回调外面面板数据
            if (wself.quotesViewDataBlock) {
                wself.quotesViewDataBlock(model);
            }
        }
    }];
}

- (void)refreshChartTypeMinute {
    __weak typeof(self) wself= self;
    [LNStockNetwork getStockMinuteDataWithStockCode:self.stockInfo.code block:^(BOOL isSuccess, NSArray *response) {
        self.lodingView.hidden = YES;
        if (isSuccess) {
            NSMutableArray *dataSets = [NSMutableArray array];
            //存储最后时间
            wself.stockInfo.currentlyDate = ((LNRealModel *)response.lastObject).date;
            for (LNRealModel *model in response) {
                LNDataSet *entity = [[LNDataSet alloc]init];
                entity.date = model.date;
                entity.volume = model.volume.floatValue;
                entity.preClosePx = model.preClosePx.floatValue;
                //-1 为服务器没有算好值
                if (model.averagePrice.floatValue == -1) {
                    entity.values = @[model.price];
                } else {
                    entity.values = @[model.price,model.averagePrice];
                }
                [dataSets addObject:entity];
            }
            if ([LNStockHandler titleType] == LNChartTitleType_1m) {
                if ([wself.stockInfo isIndexStock]) {
                    [wself hiddenDealListView];
                } else {
                    [wself showDealListView];
                }
                //添加最后一个点是否显示
                wself.topChartView.data.lineSet.drawLastPoint = [wself.stockInfo isTRADE];
                wself.dataArr = [NSMutableArray arrayWithArray:response];
                [wself refreshChart:dataSets];
            }
        } else {
            NSLog(@"%@",response);
        }
    }];
}

- (void)refreshChartTypeFiveDay {
    __weak typeof(self) wself= self;
    [LNStockNetwork getAstockFiveDaysDataWithStockCode:self.stockInfo.code block:^(BOOL isSuccess, id response) {
        wself.lodingView.hidden = YES;
        if (isSuccess) {
            NSMutableArray *dataSets = [NSMutableArray array];
            for (LNRealModel *model in response) {
                LNDataSet *entity = [[LNDataSet alloc]init];
                entity.date = model.date;
                entity.volume = model.volume.floatValue;
                entity.preClosePx = model.preClosePx.floatValue;
                entity.values = @[model.price,model.averagePrice];
                [dataSets addObject:entity];
            }
            if ([LNStockHandler titleType] == LNChartTitleType_5D) {
                wself.dataArr = response;
                [wself refreshChart:dataSets];
            }
        } else {
            NSLog(@"%@",response);
        }
    }];
}

- (void)requestAstockDataWithType:(LNStockRequestType)type {
    NSString *codetype = @"";
    switch ([LNStockHandler titleType]) {
        case LNChartTitleType_5m:
            codetype = @"2";
            break;
        case LNChartTitleType_15m:
            codetype = @"3";
            break;
        case LNChartTitleType_30m:
            codetype = @"4";
            break;
        case LNChartTitleType_1H:
            codetype = @"5";
            break;
        case LNChartTitleType_1D:
            codetype = @"6";
            break;
        case LNChartTitleType_1W:
            codetype = @"7";
            break;
        case LNChartTitleType_1M:
            codetype = @"8";
            break;
        default:
            break;
    }
    __weak typeof(self) wself= self;
    NSString *adjustStr = @"";
    switch ([LNStockHandler adjustType]) {
        case LNStockAdjustType_Normal:
            break;
        case LNStockAdjustType_After:
            adjustStr = @"backward";
            break;
        case LNStockAdjustType_Befor:
            adjustStr = @"forward";
            break;
    }
    
    NSString *endTime = @"0";
    NSMutableArray *dataSets = [NSMutableArray array];
    NSInteger num = [self.topChartView.data computeMaxValCount];
    if (![LNStockHandler isVerticalScreen]) { num = num*2; }
    if (type == LNStockRequestType_Refresh) { num = 5; }
    else if (type == LNStockRequestType_LoadMore) {
        LNRealModel *model = self.dataArr.firstObject;
        NSDateFormatter* dateFormat = [LNStockFormatter sharedInstanceFormatter];
        dateFormat.dateFormat = @"yyyyMMdd";
        switch ([LNStockHandler titleType]) {
            case LNChartTitleType_5m:
            case LNChartTitleType_15m:
            case LNChartTitleType_30m:
            case LNChartTitleType_1H:
                dateFormat.dateFormat = @"yyyyMMddHHmm";
                break;
            default:
                break;
        }
        endTime = [dateFormat stringFromDate:model.date];
    }
    [LNStockNetwork getAstockDataWithStockCode:self.stockInfo.code
                                        adjust:adjustStr
                                          type:codetype
                                           num:[NSString stringWithFormat:@"%ld",(long)num]
                                       endTime:endTime
                                         block:^(BOOL isSuccess, NSArray *response) {
        wself.lodingView.hidden = YES;
        if (isSuccess && response.count > 0) {
            switch (type) {
                case LNStockRequestType_Normal:
                    wself.dataArr = [NSMutableArray arrayWithArray:response];
                    [dataSets addObjectsFromArray:[wself getAStockEntityWithArray:response]];
                    break;
                case LNStockRequestType_Refresh:
                    [wself refreshStockDataWithArray:response];
                    [dataSets addObjectsFromArray:[wself getAStockEntityWithArray:wself.dataArr]];
                    break;
                case LNStockRequestType_LoadMore: {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    [tempArr addObjectsFromArray:response];
                    [tempArr addObjectsFromArray:wself.dataArr];
                    wself.dataArr = tempArr;
                    [dataSets addObjectsFromArray:[wself getAStockEntityWithArray:wself.dataArr]];
                }
                    break;
            }
            if ([LNStockHandler titleType] != LNChartTitleType_1m ||
                [LNStockHandler titleType] != LNChartTitleType_5D) {
                if (type == LNStockRequestType_LoadMore) {
                    [wself.topChartView updataChartData:dataSets];
                    [wself.bottomChartView updataChartData:dataSets];
                } else {
                    [wself refreshChart:dataSets];
                }
                [wself changeAdjustButtonHiddenStatus:[self.stockInfo isLongPress]];
            }
        } else {
            NSLog(@"%@",response);
        }
                                             
         //左拉加载回调
         if (isSuccess && response.count == 0) {
             if (type == LNStockRequestType_LoadMore) {
                 [wself.topChartView updataChartData:dataSets];
                 [wself.bottomChartView updataChartData:dataSets];
             }
         }
    }];
}

- (NSArray *)getAStockEntityWithArray:(NSArray *)arry {
    NSMutableArray *dataSets = [NSMutableArray array];
    for (LNRealModel *model in arry) {
        LNDataSet *entity = [[LNDataSet alloc]init];
        entity.date = model.date;
        entity.volume = model.volume.floatValue;
        if (model.MA1 && model.MA2 && model.MA3) {
            entity.MAValus = @[model.MA1,model.MA2,model.MA3];
        }
        if (model.open && model.high && model.low && model.close) {
            entity.candleValus = @[model.open,model.high,model.low,model.close];  //开 高 低 收
        }
        //MACD
        switch ([LNStockHandler factorType]) {
            case LNStockFactorType_MACD:
                if (model.macd && model.diff && model.dea) {
                    entity.values = @[model.diff,model.dea,model.macd];
                }
                break;
            case LNStockFactorType_BOLL:
                if (model.mid && model.upper && model.lower) {
                    entity.values = @[model.mid,model.upper,model.lower];
                }
                break;
            case LNStockFactorType_KDJ:
                if (model.kdj_k && model.kdj_d && model.kdj_j) {
                    entity.values = @[model.kdj_k,model.kdj_d,model.kdj_j];
                }
                break;
            case LNStockFactorType_RSI:
                if (model.rsi_6 && model.rsi_12 && model.rsi_24) {
                    entity.values = @[model.rsi_6,model.rsi_12,model.rsi_24];
                }
                break;
            case LNStockFactorType_OBV:
                if (model.obv) {
                    entity.values = @[model.obv];
                }
                break;
            default:
                break;
        }
        [dataSets addObject:entity];
    }
    return dataSets;
}

#pragma mark - 外汇

- (void)requestBstockDataWithType:(LNStockRequestType)type {
    __weak typeof(self) wself= self;
    //interval 时间类型。@"1", @"5", @"15", @"30", @"1h",@"2h", @"4h", @"1d", @"1w", @"1M"
    NSString *endTime = @"0";
    NSMutableArray *dataSets = [NSMutableArray array];
    NSInteger num = [self.topChartView.data computeMaxValCount];
    NSString *codetype = [NSString stringWithFormat:@"%ld",(long)[LNStockHandler titleType] + 1];
    if (![LNStockHandler isVerticalScreen]) { num = num*2; }
    if (type == LNStockRequestType_Refresh) { num = 5; }
    else if (type == LNStockRequestType_LoadMore) {
        LNRealModel *model = self.dataArr.firstObject;
        endTime = [NSString stringWithFormat:@"%ld",(long)model.date.timeIntervalSince1970];
    }
    [LNStockNetwork getBstockDataWithStockCode:self.stockInfo.code
                                          type:codetype
                                           num:num
                                       endTime:endTime
                                         block:^(BOOL isSuccess, NSArray *response) {
         wself.lodingView.hidden = YES;
         if (isSuccess && response.count > 0) {
             switch (type) {
                 case LNStockRequestType_Normal:
                     wself.dataArr = [NSMutableArray arrayWithArray:response];
                     [dataSets addObjectsFromArray:[wself getBStockEntityWithArray:response]];
                     break;
                 case LNStockRequestType_Refresh:
                     [wself refreshStockDataWithArray:response];
                     [dataSets addObjectsFromArray:[wself getBStockEntityWithArray:wself.dataArr]];
                     break;
                 case LNStockRequestType_LoadMore: {
                     NSMutableArray *tempArr = [NSMutableArray array];
                     [tempArr addObjectsFromArray:response];
                     [tempArr addObjectsFromArray:wself.dataArr];
                     wself.dataArr = tempArr;
                     [dataSets addObjectsFromArray:[wself getBStockEntityWithArray:wself.dataArr]];
                 }
                     break;
             }
             if (([LNStockHandler titleType] + 1) == codetype.integerValue) {
                 if (type == LNStockRequestType_LoadMore) {
                     [wself.topChartView updataChartData:dataSets];
                 } else {
                     [wself refreshChart:dataSets];
                 }
             }
         } else {
             NSLog(@"%@",response);
         }
          
         //左拉加载回调
         if (isSuccess && response.count == 0) {
             if (type == LNStockRequestType_LoadMore) {
                 [wself.topChartView updataChartData:dataSets];
             }
         }
     }];
}

- (void)refreshStockDataWithArray:(NSArray *)arry {
    LNRealModel *model = self.dataArr.lastObject;
    NSMutableArray *modelArr = [NSMutableArray arrayWithArray:self.dataArr];
    if (model) {
        for (LNRealModel *empty in arry) {
            if (empty.date.timeIntervalSince1970 > model.date.timeIntervalSince1970) {
                [modelArr addObject:empty];
                [modelArr removeObjectAtIndex:0];
            } else if (empty.date.timeIntervalSince1970 == model.date.timeIntervalSince1970){
                [modelArr removeLastObject];
                [modelArr addObject:empty];
            }
        }
    }
    self.dataArr = modelArr;
}

- (NSArray *)getBStockEntityWithArray:(NSArray *)arry {
    NSMutableArray *entityArr = [NSMutableArray array];
    for (LNRealModel *model in arry) {
        LNDataSet *entity = [[LNDataSet alloc]init];
        entity.date = model.date;
        entity.volume = model.volume.floatValue;
        if (model.close) {
            entity.values = @[model.close];
        }
        if (model.open && model.high && model.low && model.close) {
            entity.candleValus = @[model.open,model.high,model.low,model.close];  //开 高 低 收
        }
        [entityArr addObject:entity];
    }
    return entityArr;
}

@end
