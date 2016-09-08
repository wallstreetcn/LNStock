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
#import <LNChart/LNChartView.h>

@interface LNStockView ()
@property (nonatomic, assign) CGFloat stockViewW;
@property (nonatomic, assign) CGFloat stockViewH;
@property (nonatomic, assign) CGFloat listViewW;              //交易列表的宽
@property (nonatomic, assign) CGFloat titleViewH;             //头部视图的高
@property (nonatomic, assign) CGFloat headerViewH;            //头部视图的Y
@property (nonatomic, assign) CGFloat timeInterval;           //轮询刷新的时间
@property (nonatomic, assign) CGFloat bottomChartViewH;       //bottomView的高
@property (nonatomic, strong) NSTimer *timer;                 //定时器
@property (nonatomic, strong) NSMutableArray *dataArr;        //返回Stock数组
@property (nonatomic, strong) UIButton *adjustBtn;            //复权显示Button
@property (nonatomic, strong) UIView *chartBGView;            //图表的父视图
@property (nonatomic, strong) LNStockMenuView *menuView;
@property (nonatomic, strong) LNStockListView *listView;
@property (nonatomic, strong) LNChartView *topChartView;
@property (nonatomic, strong) LNChartView *bottomChartView;
@property (nonatomic, strong) LNStockHeaderView *headerView;
@property (nonatomic, strong) LNStockLodingView *lodingView;
@property (nonatomic, strong) LNStockOptionView *optionView;
@property (nonatomic, strong) LNStockTitleView *stockTitleView;
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
    [LNStockHandler sharedManager].code = code;
    [LNStockHandler sharedManager].nightMode = isNight;
    if (isAstock) {
        [LNStockHandler sharedManager].priceType = LNStockPriceTypeA;
    } else {
        [LNStockHandler sharedManager].priceType = LNStockPriceTypeB;
        [LNStockHandler sharedManager].titleType = LNChartTitleType_5m;
        [LNStockHandler sharedManager].chartType = LNStockChartType_Candles;
    }
    LNStockView *stockView = [[LNStockView alloc]initWithFrame:frame];
    return stockView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupFrame];
    if ([LNStockHandler isVerticalScreen]) { [self addSubview:self.headerView]; }             //创建HeaderView
    if ([LNStockHandler priceType] == LNStockPriceTypeA) { [self addSubview:self.listView]; } //创建ListView
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

- (void)setupFrame {
    _listViewW = 0;
    _headerViewH = 0;
    _bottomChartViewH = 0;
    _titleViewH = kFStockTitleViewH;
    _stockViewW = self.frame.size.width;
    _stockViewH = self.frame.size.height;
   if ([LNStockHandler priceType] == LNStockPriceTypeA) {
       _listViewW = [LNStockHandler isVerticalScreen] ? 100 : 140;
       _headerViewH = [LNStockHandler isVerticalScreen] ? kFStockAHeaderH : 0;
       _titleViewH = [LNStockHandler isVerticalScreen] ? kFStockTitleViewH : 90;
       _bottomChartViewH = (NSInteger)((_stockViewH - _titleViewH - _headerViewH) / 4);
   }
   else {
       _headerViewH = [LNStockHandler isVerticalScreen] ? kFStockBHeaderH : 0;
       _titleViewH = [LNStockHandler isVerticalScreen] ? kFStockTitleViewH : 90;
   }
    _timeInterval = 5.0f;
    self.backgroundColor = [UIColor blackColor];
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
    _topChartView.data.candleSet.greenUp = _isGreenUp;
    [LNStockHandler sharedManager].greenUp = _isGreenUp;
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        _bottomChartView.data.candleSet.greenUp = _isGreenUp;
    }
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
        _headerView = [[LNStockHeaderView alloc]init];
    }
    return _headerView;
}

//创建上部视图
- (LNChartView *)topChartView {
    __weak typeof(self) wself= self;
    if (!_topChartView) {
        _topChartView = [[LNChartView alloc]init];
        _topChartView.frame = CGRectMake(0, 0, _chartBGView.bounds.size.width, _chartBGView.frame.size.height - _bottomChartViewH);
        _topChartView.chartViewType = ChartViewType_Line;
        _topChartView.data.candleSet.candleRiseColor = [LNStockColor chartCandleRiseColor];
        _topChartView.data.candleSet.candleFallColor = [LNStockColor chartCandleFallColor];
        _topChartView.data.lineSet.startFillColor = [LNStockColor chartLineFillStartColor];
        _topChartView.data.lineSet.endFillColor = [LNStockColor chartLineFillEndColor];
        
        if ([LNStockHandler isVerticalScreen]) {
            _topChartView.leftAxis.labelPosition = YAxisLabelPositionInsideChart;
            _topChartView.rightAxis.labelPosition = YAxisLabelPositionInsideChart;
            _topChartView.data.highlighter.positionType = HighlightPositionLeftInside;
            [_topChartView removeGestureRecognizer:_topChartView.panGestureRecognizer];
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:15];
        }
        if ([LNStockHandler priceType] == LNStockPriceTypeB) {
            if (![LNStockHandler isVerticalScreen]) { _topChartView.zoomEnabled = YES; }
            _topChartView.leftAxis.drawLabelsEnabled = NO;
            _topChartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
            _topChartView.rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
            _topChartView.data.highlighter.positionType = HighlightPositionRightOut;
            [_topChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:45 offsetBottom:30];
        }
        _topChartView.highlightBlock = ^(LNChartHighlight *highlight, UILongPressGestureRecognizer *longPress) {
            [wself.bottomChartView addCrossLine:highlight longPress:longPress];
            [wself changeAdjustButtonHiddenStatus:highlight.isHighlight];
            [LNStockHandler sharedManager].longPress = highlight.isHighlight;
            if (highlight.isHighlight) {
                [wself.quoteTitleView showInfoViewWithArray:wself.dataArr Index:highlight.index];
            } else {
                [wself.quoteTitleView hiddenInfoView];
            }
        };
        
        _topChartView.panRecognizerBlock = ^(BOOL isEnded, LNChartData *data) {
            [wself.bottomChartView slidingPage:isEnded data:data];
        };
        
        _topChartView.pinchRecognizerBlock = ^(LNChartData *data) {
            [wself.bottomChartView zoomPage:data];
        };
        
        _topChartView.anctionBlock = ^(){ //動作回調
            [wself requestBstockDataWithType:LNStockRequestType_LoadMore];
        };
    }
    return _topChartView;
}

//创建底部视图
- (LNChartView *)bottomChartView {
    __weak typeof(self) wself= self;
    if (!_bottomChartView) {
        _bottomChartView = [[LNChartView alloc]init];
        _bottomChartView.frame = CGRectMake(0, CGRectGetMaxY(self.topChartView.frame), self.topChartView.frame.size.width, _bottomChartViewH);
        [self updateBottomChartViewType];
        _bottomChartView.data.candleSet.candleRiseColor = [LNStockColor chartCandleRiseColor];
        _bottomChartView.data.candleSet.candleFallColor = [LNStockColor chartCandleFallColor];
        _bottomChartView.drawInfoEnabled = NO;
        _bottomChartView.data.sizeRatio = 1.0;
        _bottomChartView.data.drawLoadMoreContent = NO;
        [_bottomChartView.viewHandler restrainViewPort:45 offsetTop:0 offsetRight:45 offsetBottom:0];
        
        if ([LNStockHandler isVerticalScreen]) {
            _bottomChartView.leftAxis.labelPosition = YAxisLabelPositionInsideChart;
            _bottomChartView.rightAxis.labelPosition = YAxisLabelPositionInsideChart;
            _bottomChartView.data.highlighter.positionType = HighlightPositionLeftInside;
            [_bottomChartView removeGestureRecognizer:_bottomChartView.panGestureRecognizer];
            [_bottomChartView.viewHandler restrainViewPort:0 offsetTop:0 offsetRight:0 offsetBottom:0];
        }
        _bottomChartView.highlightBlock = ^(LNChartHighlight *highlight, UILongPressGestureRecognizer *longPress) {
            [wself.topChartView addCrossLine:highlight longPress:longPress];
            [wself changeAdjustButtonHiddenStatus:highlight.isHighlight];
            [LNStockHandler sharedManager].longPress = highlight.isHighlight;
            if (highlight.isHighlight) {
                [wself.quoteTitleView showInfoViewWithArray:wself.dataArr Index:highlight.index];
            }
            else {
                [wself.quoteTitleView hiddenInfoView];
            }
        };
        
        _bottomChartView.panRecognizerBlock = ^(BOOL isEnded, LNChartData *data) {
            [wself.topChartView slidingPage:isEnded data:data];
        };
        
        _bottomChartView.pinchRecognizerBlock = ^(LNChartData *data) {
            [wself.topChartView zoomPage:data];
        };
        
        _bottomChartView.anctionBlock = ^(){ //動作回調
            [wself requestBstockDataWithType:LNStockRequestType_LoadMore];
        };
    }
    return _bottomChartView;
}

- (LNStockTitleView *)quoteTitleView {
    if (!_stockTitleView) {
        __weak typeof(self) wself= self;
        _stockTitleView = [[LNStockTitleView alloc] initWithFrame:CGRectMake(0, _headerViewH, _stockViewW, _titleViewH)];
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

- (LNStockMenuView *)menuView {
    __weak typeof(self) wself= self;
    if (!_menuView) {
        _menuView = [[LNStockMenuView alloc] initWithFrame:CGRectMake(_stockViewW - 50, _headerViewH + _titleViewH - 10, 50, 100)];
        _menuView.block = ^(NSInteger type){
            [LNStockHandler sharedManager].titleType = type + 1;
            [wself.quoteTitleView setAChartTitleViewLastBtnWithType:[LNStockHandler titleType]];
            [wself.menuView hiddenView];
        };
    }
    return _menuView;
}

- (LNStockOptionView *)optionView {
    __weak typeof(self) wself= self;
    if (!_optionView) {
        _optionView = [[LNStockOptionView alloc]initWithFrame:CGRectMake(_stockViewW - 60, _titleViewH, 60,_stockViewH - _titleViewH)];
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
        _chartBGView.frame = CGRectMake(0, _titleViewH + _headerViewH, _stockViewW - _listViewW, _stockViewH - _titleViewH - _headerViewH);
        _chartBGView.backgroundColor = [UIColor blackColor];
        [_chartBGView addSubview:self.topChartView];
        if ([LNStockHandler priceType] == LNStockPriceTypeA) {
            [_chartBGView addSubview:self.bottomChartView];
        }
    }
    return _chartBGView;
}

- (LNStockLodingView *)lodingView {
    if (!_lodingView) {
        _lodingView = [[LNStockLodingView alloc]initWithFrame:CGRectMake(0, _headerViewH + _titleViewH, _stockViewW, _stockViewH - _titleViewH - _headerViewH)];
    }
    return _lodingView;
}

- (LNStockListView *)listView {
    if (!_listView) {
        _listView = [[LNStockListView alloc]initWithFrame:CGRectMake(_stockViewW - _listViewW, CGRectGetMaxY(self.quoteTitleView.frame), _listViewW, _stockViewH - _titleViewH - _headerViewH)];
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
        if ([LNStockHandler priceType] == LNStockPriceTypeA &&
            [LNStockHandler isVerticalScreen] &&
            ![LNStockHandler isFundStock]) {
            [self.chartBGView addSubview:_adjustBtn];
        }
    }
    return _adjustBtn;
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
        [LNStockHandler sharedManager].verticalScreen = NO;
        LNStockVC *vc = [[LNStockVC alloc]init];
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
    if (![LNStockHandler isIndexStock]) {
        self.listView.hidden = NO;
        self.chartBGView.frame = CGRectMake(0, _titleViewH + _headerViewH, _stockViewW - _listViewW, self.chartBGView.bounds.size.height);
        [self updateChartViewFrame];
    }
}

- (void)hiddenDealListView {
    [self.menuView hiddenView];
    self.listView.hidden = YES;
    if ([LNStockHandler titleType] == LNChartTitleType_5D || [LNStockHandler isVerticalScreen]) {
        self.optionView.hidden = YES;
        self.chartBGView.frame = CGRectMake(0, _titleViewH + _headerViewH, _stockViewW, self.chartBGView.bounds.size.height);
    } else {
        if ([LNStockHandler isIndexStock] && [LNStockHandler titleType] == LNChartTitleType_1m) {
            self.chartBGView.frame = CGRectMake(0, _titleViewH + _headerViewH, _stockViewW, self.chartBGView.bounds.size.height);
        } else {
            self.chartBGView.frame = CGRectMake(0, _titleViewH + _headerViewH, _stockViewW - 60, self.chartBGView.bounds.size.height);
            self.optionView.hidden = NO;
        }
    }
    [self updateChartViewFrame];
}

- (void)updateChartViewFrame {
    [self changeAdjustButtonHiddenStatus:NO];
    self.topChartView.frame = CGRectMake(0, 0, _chartBGView.frame.size.width, _chartBGView.frame.size.height - _bottomChartViewH);
    self.bottomChartView.frame = CGRectMake(0, CGRectGetMaxY(_topChartView.frame), _topChartView.frame.size.width, _bottomChartViewH);
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
    [self refreshStockRealData];  //刷新实时行情
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        switch ([LNStockHandler titleType]) {
            case LNChartTitleType_1m:
                [self refreshChartTypeMinute];
                if (![LNStockHandler isIndexStock]) {
                    [self.listView getBuyAndSaleGroupData];
                }
                break;
            case LNChartTitleType_5D:
                [self refreshChartTypeFiveDay];
                break;
            default:
                [self refreshChartTypeKLine];
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
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        if (highlight) {
            self.adjustBtn.hidden = YES;
        } else {
            if ([LNStockHandler isIndexStock] ||
                [LNStockHandler isFundStock] ||
                [LNStockHandler titleType] == LNChartTitleType_1m ||
                [LNStockHandler titleType] == LNChartTitleType_5D) {
                self.adjustBtn.hidden = YES;
            } else {
                self.adjustBtn.hidden = NO;
            }
        }
    }
}

- (void)refreshChartView {
    [self updateTopChartViewType];
    [self refreshChart:[NSMutableArray arrayWithArray:[self getEntityWithArray:self.dataArr]]];
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
            break;
        case LNStockFactorType_BOLL:
            _bottomChartView.chartLegend.contents = @[@"UPPER:",@"MID:",@"LOWER:"];
            _bottomChartView.chartViewType = ChartViewType_BOLL;
            break;
        case LNStockFactorType_KDJ:
            labelCount = 3;
            _bottomChartView.chartViewType = ChartViewType_Line;
            _bottomChartView.leftAxis.drawGridLinesEnabled = YES;
            _bottomChartView.chartLegend.contents = @[@"K:",@"D:",@"J:"];
            break;
        case LNStockFactorType_RSI:
            _bottomChartView.chartLegend.contents = @[@"RSI6:",@"RSI12:",@"RSI24:"];
            _bottomChartView.chartViewType = ChartViewType_Line;
            break;
        case LNStockFactorType_OBV:
            _bottomChartView.chartLegend.contents = @[@"OBV:"];
            _bottomChartView.chartViewType = ChartViewType_OBV;
            break;
        default:
            _bottomChartView.chartViewType = ChartViewType_Line;
            break;
    }
    _bottomChartView.data.lineSet.lineColors = @[kCHex(0xF0AB0A), kCHex(0xE72589), kCHex(0x05E222)];
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
    self.topChartView.data.precision = [LNStockHandler price_precision];
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        [self.bottomChartView setupWithData:dataArr];
        self.bottomChartView.data.precision = [LNStockHandler price_precision];
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
    [self.topChartView.animator stopAnimation];
    [self.bottomChartView.animator stopAnimation];
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        [self hiddenDealListView]; //隐藏五档列表
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
//            case LNChartTitleType_5m:
//            case LNChartTitleType_15m:
//            case LNChartTitleType_30m:
//            case LNChartTitleType_1H:
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
                [self refreshChartTypeKLine];
                break;
            case LNChartTitleType_NULL: {
                if (self.menuView.showing) {
                    [self.menuView hiddenView];
                } else {
                    self.menuView.showing = YES;
                    [self addSubview:self.menuView];
                }
            }
                break;
            default: {
                //上线后新增分钟线后删掉
                [LNStockHandler sharedManager].titleType = LNChartTitleType_1m;
                [self refreshChartData];
            }
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
    [LNStockNetwork getStockRealDataWithCode:[LNStockHandler code] block:^(BOOL isSuccess, LNStockModel *model) {
        if (isSuccess) {
            [wself.headerView updateStockData:model];        //刷新横版头部试图
            [wself.stockTitleView refreshTitleView:model];   //刷新titleView
            //回调外面面板数据
            if (wself.quotesViewDataBlock) {
                wself.quotesViewDataBlock(model);
            }
        }
    }];
}

- (void)refreshChartTypeMinute {
    __weak typeof(self) wself= self;
    [LNStockNetwork getStockMinuteDataWithStockCode:[LNStockHandler code] block:^(BOOL isSuccess, id response) {
        self.lodingView.hidden = YES;
        if (isSuccess) {
            NSMutableArray *dataSets = [NSMutableArray array];
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
                if ([LNStockHandler isIndexStock]) {
                    [wself hiddenDealListView];
                } else {
                    [wself showDealListView];
                }
                wself.dataArr = response;
                [wself refreshChart:dataSets];
            }
            //存储最后时间
            [LNStockHandler sharedManager].currentlyDate = ((LNRealModel *)wself.dataArr.lastObject).date;
        } else {
            NSLog(@"%@",response);
        }
    }];
}

- (void)refreshChartTypeFiveDay {
    __weak typeof(self) wself= self;
    [LNStockNetwork getAstockFiveDaysDataWithStockCode:[LNStockHandler code] block:^(BOOL isSuccess, id response) {
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

- (void)refreshChartTypeKLine {
    NSString *type = @"";
    switch ([LNStockHandler titleType]) {
        case LNChartTitleType_1D:
            type = @"6";
            break;
        case LNChartTitleType_1W:
            type = @"7";
            break;
        case LNChartTitleType_1M:
            type = @"8";
            break;
        default:
            break;
    } //    NSString *type = @"6";  // 7  8  9
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
    [LNStockNetwork getAstockDataWithStockCode:[LNStockHandler code] adjust:adjustStr type:type block:^(BOOL isSuccess, id response) {
        wself.lodingView.hidden = YES;
        if (isSuccess) {
            NSMutableArray *dataSets = [NSMutableArray array];
            for (LNRealModel *model in response) {
                LNDataSet *entity = [[LNDataSet alloc]init];
                entity.date = model.date;
                entity.volume = model.volume.floatValue;
                entity.MAValus = @[model.MA1,model.MA2,model.MA3];
                entity.candleValus = @[model.open,model.high,model.low,model.close];  //开 高 低 收
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
            
            if ([LNStockHandler titleType] != LNChartTitleType_1m ||
                [LNStockHandler titleType] != LNChartTitleType_5D) {
                wself.dataArr = response;
                [wself refreshChart:dataSets];
                [wself changeAdjustButtonHiddenStatus:[LNStockHandler isLongPress]];
            }
        } else {
            NSLog(@"%@",response);
        }
    }];
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
    if (type == LNStockRequestType_Refresh) { num = 10; }
    else if (type == LNStockRequestType_LoadMore) {
        LNRealModel *model = self.dataArr.firstObject;
        endTime = [NSString stringWithFormat:@"%ld",(long)model.date.timeIntervalSince1970];
    }
    [LNStockNetwork getBstockDataWithStockCode:[LNStockHandler code]
                                          type:codetype
                                           num:num
                                       endTime:endTime
                                         block:^(BOOL isSuccess, NSArray *response) {
         wself.lodingView.hidden = YES;
                                             
         if (isSuccess && response.count > 0) {
             switch (type) {
                 case LNStockRequestType_Normal:
                     wself.dataArr = [NSMutableArray arrayWithArray:response];
                     [dataSets addObjectsFromArray:[wself getEntityWithArray:response]];
                     break;
                 case LNStockRequestType_Refresh:
                     [wself refreshStockDataWithArray:response];
                     [dataSets addObjectsFromArray:[wself getEntityWithArray:wself.dataArr]];
                     break;
                 case LNStockRequestType_LoadMore: {
                     NSMutableArray *tempArr = [NSMutableArray array];
                     [tempArr addObjectsFromArray:response];
                     [tempArr addObjectsFromArray:wself.dataArr];
                     wself.dataArr = tempArr;
                     [dataSets addObjectsFromArray:[wself getEntityWithArray:wself.dataArr]];
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

- (NSArray *)getEntityWithArray:(NSArray *)arry {
    NSMutableArray *entityArr = [NSMutableArray array];
    for (LNRealModel *model in arry) {
        LNDataSet *entity = [[LNDataSet alloc]init];
        entity.date = model.date;
        entity.volume = model.volume.floatValue;
        entity.values = @[model.close];
        entity.candleValus = @[model.open,model.high,model.low,model.close];  //开 高 低 收
        [entityArr addObject:entity];
    }
    return entityArr;
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

@end
