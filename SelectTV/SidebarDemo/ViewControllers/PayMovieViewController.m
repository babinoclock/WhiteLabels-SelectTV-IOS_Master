//
//  PayMovieViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 26/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "PayMovieViewController.h"
#import "MovieViewController.h"
#import "UIGridView.h"
#import "Cell.h"
#import "RabbitTVManager.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewController.h"
#import "PlusViewController.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "MenuCell.h"
#import "SimpleTableCell.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "AsyncImage.h"
#import "NSString+FontAwesome.h"
#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "New_Land_Cell.h"
#import "OnDemandSliderCarouselView.h"
#import "OnDemand_Grid_Cell.h"
#import "SubScriptionsViewController.h"
#import "AppDelegate.h"

@interface PayMovieViewController ()<CustomIOS7AlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SWRevealViewControllerDelegate>{
    
    SWRevealViewController *revealviewcontroller;
    
    NSMutableAttributedString *aweAttrString;
    NSDictionary *attrRoboFontDict;
    NSDictionary *attrAweSomeDict;
    AppDelegate *appDelegate;
    //SEARCH
    UIToolbar               *keyboardToolbar;
    UIBarButtonItem         *spaceBarItem;
    UIBarButtonItem         *doneBarItem;
    
    UISearchBar *searchBarView;
    BOOL isSearch;
    NSString *searchString;
    NSArray *searchKeysTitle;
    UITextField *searchTextField;
    NSMutableArray *searchResponseArray;
    NSMutableArray *arrayWithCount;
    
    //Slider and Carousel
    NSMutableArray *sliderImageArray;
    NSMutableArray *topTitleCarouselArray;
    NSMutableArray *payPerViewStaticArray;
    NSMutableArray *perPerViewRatingArray;
    
    BOOL isPerPerViewMovie;
    BOOL isPerPerViewGenre;
    BOOL isPerPerViewRating;
    BOOL isPerPerViewShows;
    
   
    BOOL isStaticPayPerMenuClick;
    BOOL isRatingClick;
    BOOL isGenreClick;
    
    BOOL isCarouselImage;
    
    //MENU ORIENTATION
    CGFloat port_PPViewHeight;
    CGFloat land_PPViewHeight;
    
    BOOL isMovieType;
    
    NSString *currentSelectedStr;
    
    NSString * currentAppLanguage;
    NSMutableArray *PayPerViewSpainshStaticArray;
    
    BOOL isSpanishMovieGenre;
    BOOL isSpanishRating;
    
 
}

@end

@implementation PayMovieViewController
@synthesize payHeaderLabelStr,payLabel,payShowStr,dropDownNSArray,isPayPerView,isNetworksView;
@synthesize genreName;
@synthesize payPerRightMenuLabel;

@synthesize isSubcriptionView,isPushedFromSubscriptView;

NSMutableArray* arrayPayItems;
NSMutableArray* arrayShows;
NSMutableArray* arraySeasons;
static int CATEGORY_SHOW_PAY = 0;
static int CATEGORY_MOVIES_PAY = 1;
static int CATEGORY_NETWORK_PAY = 2;

int nPayCategory;
int mainPayCategory;

int nPayCount = 3;
int nPayWidth = 107;//107
int nPayHeight = 200;//140

CustomIOS7AlertView * payChannelView;
bool isSeasonArray;
BOOL isNetworkUrl;

bool bPayMovieNetworkShown= false;
bool bPayMovieStaticShown= false;
bool bPayGenreShown= false;
bool bPayRatingShown= false;

NSMutableArray* m_ArrayChannels;
static NSArray * arrayMovies;
UIView *tvShowView;
UITableView* tableChannelList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    bPayMovieNetworkShown = true;
    appDelegate.isSubscriptPage = @"NO";
    isLandscape = NO;
    isShowsClicked = YES;
    selectedCaurosalIndex = 0;
     payPerViewStaticArray = [[NSMutableArray alloc] initWithObjects:@"Movies", @"By Genre",@"By Rating",@"TV Shows", nil];
     currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    movieArray = [NSMutableArray new];
    showArray = [NSMutableArray new];
    if([COMMON isSpanishLanguage]==YES){
        [self setUpStaticSpainshArray];
    }
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr =payHeaderLabelStr;
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    
    self.navigationItem.title = titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];

    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayMovieOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self payPerViewRotateViews:false];
    }else{
        [self payPerViewRotateViews:true];
    }
//    if(isPayPerView==YES)
//        [arrayPayItems removeAllObjects];
    [payChannelView close];
    payChannelView = nil;
    [self setUpFont];
    //payLabel.text = payShowStr;
    if(isPayPerView==YES)  {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewInPayPerView:) name:@"didSelectItemFromCollectionViewForPayPerView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewAllOptionPayPerView:) name:@"sliderViewAllOptionPayPerView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewWatchNowActionPayPerView:) name:@"sliderViewWatchNowActionPayPerView" object:nil];
    }
    
    NSString *payStr = payShowStr;
    if([COMMON isSpanishLanguage]==YES){
        payStr =  [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    if ((NSString *)[NSNull null] == payStr||payStr == nil) {
        payStr = payShowStr;
    }
    if(payStr!=nil) {
        NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:payStr attributes:attrRoboFontDict];
        [roboAttrString appendAttributedString:aweAttrString];
        payLabel.attributedText = roboAttrString;
    }
    
//    NSString *strNetwork=@"Select";
    NSString *strNetwork;
    if([COMMON isSpanishLanguage]==YES){
        strNetwork =  [COMMON stringTranslatingIntoSpanish:strNetwork];
    }
    if ((NSString *)[NSNull null] == strNetwork||strNetwork == nil) {
//        strNetwork=@"Select";
    }
    if(strNetwork!=nil) {
        NSMutableAttributedString *roboAttrString1 = [[NSMutableAttributedString alloc]initWithString:strNetwork attributes:attrRoboFontDict];
        [roboAttrString1 appendAttributedString:aweAttrString];
        payPerRightMenuLabel.attributedText = roboAttrString1;
    }
    
    if(isPayPerView==NO) {
//        [self loadMovieLatestAppListScrollViewData];
         [payLabel setUserInteractionEnabled:NO];
        [self getSubscription:0];
        [_payTableView reloadData];
    } else {
        [payLabel setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftSelector:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [payLabel addGestureRecognizer:tapRecognizer];
         strNetwork=@"";
        [payPerRightMenuLabel setHidden:YES];
//        [payPerRightMenuLabel setUserInteractionEnabled:YES];
        [payPerRightMenuLabel setUserInteractionEnabled:NO];
        UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myRightSelector:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [payPerRightMenuLabel addGestureRecognizer:tapRecognizer1];

    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
     self.view.backgroundColor = GRAY_BG_COLOR;
    
    [self.payMovieActivityIndicator setHidden:true];
    bPayMovieNetworkShown= false;
    bPayMovieStaticShown=false;
    bPayGenreShown= false;
    bPayRatingShown= false;
    
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    
    if(_isSearchNetworksView){
        UIImage *buttonImage = [UIImage imageNamed:@"backIcon"];
        [_mainLeftBarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [_mainLeftBarButton addTarget:self action:@selector(mainLeftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setHidden:YES];
    }
//    else if(isSubcriptionView){
//        
//        UIImage *buttonImage = [UIImage imageNamed:@"backIcon"];
//        [_mainLeftBarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//        [_mainLeftBarButton addTarget:self action:@selector(mainLeftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [_searchButton setHidden:YES];
//        
//    }
    else{
        UIImage *buttonImage;
        buttonImage = [UIImage imageNamed:@"menuIcon"];
        [_mainLeftBarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [_mainLeftBarButton addTarget:revealviewcontroller action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void) viewWillDisappear:(BOOL)animated {
    [self.payMovieActivityIndicator setHidden:false];
}

-(void)setUpStaticSpainshArray {
    PayPerViewSpainshStaticArray = [NSMutableArray new];
    PayPerViewSpainshStaticArray = [[COMMON retrieveContentsFromFile:ON_PAY_PER_VIEW_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    if([PayPerViewSpainshStaticArray count]==0){
        [self getStaticTranslatedWordList:ON_PAY_PER_VIEW_STATIC_WORDS currentStaticArray:(NSMutableArray*)payPerViewStaticArray];
        PayPerViewSpainshStaticArray = [[COMMON retrieveContentsFromFile:ON_PAY_PER_VIEW_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
        
    }
    
}
#pragma  mark - getStaticTranslatedWordList
-(void)getStaticTranslatedWordList:(NSString *)currentPage currentStaticArray:(NSMutableArray*)commonStaticArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for(int i=0;i<commonStaticArray.count;i++){
        
        NSString * currentEnglishText = [commonStaticArray objectAtIndex:i];
        NSString *translatedText = [COMMON stringTranslatingIntoSpanish:currentEnglishText];
        
        if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
            translatedText=@"";
        }
        if([translatedText isEqualToString:@""]){
            translatedText = currentEnglishText;
        }
        
        [tempArray addObject:translatedText];
        saveContentsToFile(tempArray, currentPage);
        
    }
}

-(void)mainLeftBarButtonAction{
    
    if(_isSearchNetworksView){
         [self.navigationController popViewControllerAnimated:YES];
    }
    if(isSubcriptionView){
        [self.navigationController popViewControllerAnimated:YES];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
    }
    
}
-(void)setUpFont{
    NSString *strArrow;
    strArrow= [NSString stringWithFormat:@"%@", @" \uf0d7"]; // sort  \f0dc fa-caret-down "\f0d7" //\f107
    attrRoboFontDict = @{
                         NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(10)],
                         NSForegroundColorAttributeName : [UIColor whiteColor]
                         };
    attrAweSomeDict = @{
                        NSFontAttributeName : [UIFont fontWithName:@"FontAwesome" size:17],
                        NSForegroundColorAttributeName : [UIColor whiteColor]
                        };
    aweAttrString = [[NSMutableAttributedString alloc] initWithString:strArrow attributes: attrAweSomeDict];
    
}


#pragma mark - loadSliderCarouselScreen
-(void)loadSliderCarouselScreen{
    
    isPerPerViewMovie=YES;
    isPerPerViewGenre=NO;
    isPerPerViewRating=NO;
    isPerPerViewShows=NO;
    
    [_payPerSliderView setHidden:NO];
    [_payTableView setHidden:YES];
   // [_payPerSliderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]]];
    
    _payPerSliderView.backgroundColor = GRAY_BG_COLOR;
    genreName = @"Movies";
    currentSelectedStr =@"Movies";
    if([COMMON isSpanishLanguage]==YES){
        [self getPayPerViewGenreForMoviesTVShows];
    }
    
    [self getPayPerViewFirstMovieCarousels];
    [self getPayPerViewRatingMenuList];
}
#pragma mark - getPayPerViewFirstMovieCarousels
-(void)getPayPerViewFirstMovieCarousels{
    nPayCategory = CATEGORY_MOVIES_PAY;
    int nPPV = PAY_MODE_PAID;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager] getPayPerViewMoviesCarousels:^(AFHTTPRequestOperation *request, id responseObject){
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self getPayPerViewFirstMovieSliderImageArray:[topTitleCarouselArray mutableCopy]];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    }nPPV:nPPV];
    
}

#pragma mark - getPayPerViewFirstMovieSliderImageArray
-(void)getPayPerViewFirstMovieSliderImageArray:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager] getPayPerViewMoviesSlider:^(AFHTTPRequestOperation *request, id responseObject){
        //_appDownloadTableView.tag = 1000;
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
         [COMMON removeLoading];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
         [COMMON removeLoading];
    }];
}

#pragma mark - loadSliderCarouselDesign
-(void)loadSliderCarouselDesign:(id)sliderArrayForImages carouselArray:(id)topTitleCarouselListArray{
    
    for(UIView *view in _payPerSliderView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }
    [_payPerSliderView setHidden:NO];
    [_payTableView setHidden:YES];
    
    OnDemandSliderCarouselView *slider = [OnDemandSliderCarouselView loadView];
    [slider loadSliderShowImages:sliderArrayForImages carouselArray:topTitleCarouselListArray currentViewStr:@"PayPerView" currentTitleStr:currentSelectedStr];
    [_payPerSliderView addSubview:slider];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [COMMON removeLoading];
}


#pragma mark - getPayPerViewFirstMovieCarousels
-(void)getPayPerViewShowsCarousels{
    nPayCategory = CATEGORY_SHOW_PAY;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager] getPayPerViewShowsCarousels:^(AFHTTPRequestOperation *request, id responseObject){
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self getPayPerViewShowsSliderImageArray:[topTitleCarouselArray mutableCopy]];
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    }];
    
}

#pragma mark - getPayPerViewFirstMovieSliderImageArray
-(void)getPayPerViewShowsSliderImageArray:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager] getPayPerViewShowsSlider:^(AFHTTPRequestOperation *request, id responseObject){
        //_appDownloadTableView.tag = 1000;
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    }];
}

#pragma mark - getOnDemandMoviesRatingMenuList
-(void)getPayPerViewRatingMenuList{
    [[RabbitTVManager sharedManager]getOnDemandMoviesRating:^(AFHTTPRequestOperation *request, id responseObject) {
        perPerViewRatingArray =[NSMutableArray new];
        perPerViewRatingArray = [responseObject mutableCopy];
        isSpanishMovieGenre=NO;
        isSpanishRating=YES;
        if([COMMON isSpanishLanguage]==YES){
            NSMutableArray *tempArray = [NSMutableArray new];
            tempArray = [[COMMON retrieveContentsFromFile:ON_PAY_PER_VIEW_RATING_WORDS dataType:DataTypeArray] mutableCopy];
            if ([tempArray count] == 0) {
                [self getTranslationArrayOfOnDemand:ON_PAY_PER_VIEW_RATING_WORDS currentStaticArray:perPerViewRatingArray];
                
                tempArray = [[COMMON retrieveContentsFromFile:ON_PAY_PER_VIEW_RATING_WORDS dataType:DataTypeArray] mutableCopy];
                perPerViewRatingArray =tempArray;
            }
            else{
                perPerViewRatingArray =tempArray;
            }
        }
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
    }];
}
-(void)getPayPerViewGenreForMoviesTVShows{
    
    NSLog(@"dropDownNSArray-->%@",dropDownNSArray);
    isSpanishMovieGenre=YES;
    isSpanishRating=NO;
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_MOVIE_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
    
    if ([tempArray count] == 0) {
        [self getTranslationArrayOfOnDemand:COMMON_SPANISH_MOVIE_GENRE_WORDS currentStaticArray:dropDownNSArray];

        tempArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_MOVIE_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
        dropDownNSArray =tempArray;
    }
    else{
        dropDownNSArray =tempArray;
    }

}

-(void)getTranslationArrayOfOnDemand:(NSString *)currentPage currentStaticArray:(NSMutableArray*)commonStaticArray{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString * currentEnglishText;
    NSString *translatedText;
    
    NSString *valueStr=@"name";
    if(isSpanishMovieGenre==YES){
        valueStr=@"label";
    }
    
    if([commonStaticArray count]!=0){
        for(NSMutableDictionary * anEntryDict in [commonStaticArray mutableCopy])
        {
            NSString *englishTextInDict = [anEntryDict valueForKey:valueStr];
            
            if([englishTextInDict isEqualToString: currentEnglishText]){
                translatedText = [anEntryDict valueForKey:SPANISH_TEXT];
                
                break;
            }
            else{
                translatedText = [COMMON stringTranslatingIntoSpanish:englishTextInDict];
            }
            
            if ((NSString *)[NSNull null] == currentEnglishText||currentEnglishText == nil) {
                currentEnglishText=@"";
            }
            if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
                translatedText=@"";
            }
            if([translatedText isEqualToString:@""]){
                translatedText = currentEnglishText;
            }
            
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
            myDictionary = [anEntryDict mutableCopy];
            [myDictionary setValue:translatedText forKey:SPANISH_TEXT];
            [tempArray addObject:myDictionary];
            
            NSLog(@"tempArray%@",tempArray);
            saveContentsToFile(tempArray, currentPage);
            
        }
        
    }
        
    perPerViewRatingArray = [[COMMON retrieveContentsFromFile:ON_PAY_PER_VIEW_RATING_WORDS dataType:DataTypeArray] mutableCopy];
    
    dropDownNSArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_MOVIE_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
}


#pragma mark - LABEL ACTIONS
- (void)myLeftSelector:(UILabel *)myLabel
{
    [[RabbitTVManager sharedManager]cancelRequest];
    
    if(isPerPerViewMovie==YES){
        [self loadPayMovieStaticMenuData];
    }
    else{
        [self loadPayMovieNetworkMenuData];
    }
    
    
}
- (void)myRightSelector:(UILabel *)myLabel
{
    [[RabbitTVManager sharedManager]cancelRequest];
    if(isPerPerViewGenre==YES){
        [self loadPayPerGenreMenuData];
    }
    else if(isPerPerViewRating==YES){
        [self loadPayPerRatingMenuData];
    }
    
    
}

#pragma mark - loadPayMovieStaticMenuData
-(void) loadPayMovieNetworkMenuData{
    if(dropDownNSArray == nil) return;
    m_ArrayChannels = (NSMutableArray *) dropDownNSArray;
    [self loadPayMovieTableList];
    
    bPayMovieNetworkShown = true;
    bPayMovieStaticShown=false;
    bPayGenreShown= false;
    bPayRatingShown= false;
}

#pragma mark - loadPayMovieStaticMenuData
-(void) loadPayMovieStaticMenuData{
    if(payPerViewStaticArray == nil) return;
    m_ArrayChannels = (NSMutableArray *) payPerViewStaticArray;
    isStaticPayPerMenuClick=true;
    isGenreClick = false;
    isRatingClick=false;
    [self loadPayMovieTableList];
    
    bPayMovieNetworkShown = false;
    bPayMovieStaticShown=true;
    bPayGenreShown= false;
    bPayRatingShown= false;
}
#pragma mark - loadPayPerRatingMenuData
-(void)loadPayPerGenreMenuData{
    if(dropDownNSArray == nil) return;
    m_ArrayChannels = (NSMutableArray *) dropDownNSArray;
    isStaticPayPerMenuClick=false;
    isGenreClick = true;
    isRatingClick=false;
    [self loadPayMovieTableList];
    
    bPayMovieNetworkShown = false;
    bPayMovieStaticShown=false;
    bPayGenreShown= true;
    bPayRatingShown= false;
    
}

#pragma mark - loadPayPerRatingMenuData
-(void)loadPayPerRatingMenuData{
    if(perPerViewRatingArray == nil) return;
    m_ArrayChannels = (NSMutableArray *) perPerViewRatingArray;
    isStaticPayPerMenuClick=false;
    isGenreClick = false;
    isRatingClick=true;
    [self loadPayMovieTableList];
    
    bPayMovieNetworkShown = false;
    bPayMovieStaticShown=false;
    bPayGenreShown= false;
    bPayRatingShown= true;
    
}


-(void)loadPayMovieTableList{
    
    UIDevice* device = [UIDevice currentDevice];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            payChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-260, self.view.frame.size.height-130)];
        }
        //IPAD
        else{
            payChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-380, self.view.frame.size.height-300)];
        }
        
    }else{
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            payChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, self.view.frame.size.height-180)];
        }
        //IPAD
        else{
            payChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height-340)];
        }
    }
    if(isPerPerViewMovie==YES){
        tableChannelList.tag = 102;
    }
    else{
        tableChannelList.tag = 101;
    }

    // tableChannelList.tag = 102;
    tableChannelList.backgroundColor = [UIColor whiteColor];
    payChannelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    [payChannelView setContainerView:tableChannelList];
    [payChannelView show];

}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nCount = 0;
    nCount = m_ArrayChannels.count;
//    nCount = _subcsArray.count;

    return nCount;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *strChannelName;
    
     if(tableView.tag==101){
        NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
//         NSDictionary *dictItem = (NSDictionary *) _subcsArray[indexPath.row];

        
        if(isNetworksView==YES){
            strChannelName = dictItem[@"name"];
        }
        else{
            strChannelName = dictItem[@"label"];
            
        }
    }
    
    else if(tableView.tag==102){
        if(isStaticPayPerMenuClick==YES){
            strChannelName = m_ArrayChannels[indexPath.row];
            strChannelName = m_ArrayChannels[indexPath.row];
            if([COMMON isSpanishLanguage]==YES){
                strChannelName = PayPerViewSpainshStaticArray[indexPath.row];
            }
            if ((NSString *)[NSNull null] == strChannelName||strChannelName == nil) {
                strChannelName=m_ArrayChannels[indexPath.row];
            }
        }
        else if(isGenreClick==YES){
            NSDictionary *dictItem = (NSDictionary *)m_ArrayChannels[indexPath.row];
            strChannelName = dictItem[@"label"];
            if([COMMON isSpanishLanguage]==YES){
                strChannelName = dictItem[SPANISH_TEXT];
            }
        }

        else if(isRatingClick==YES){
            NSDictionary *dictItem =(NSDictionary *) m_ArrayChannels[indexPath.row];
            strChannelName = dictItem[@"name"];
            if([COMMON isSpanishLanguage]==YES){
                strChannelName = dictItem[SPANISH_TEXT];
            }
        }
    } else if (tableView.tag==501) {
        
    }
    
        [cell.labelText setText:strChannelName];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSearchView];
    
    [self.payMovieActivityIndicator setHidden:false];
    
    
    NSString* strLabel;
    NSString* strID;

    if(tableView.tag==101){
        NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
        strID = dictItem[@"id"];
        if(isPayPerView==YES){
            strLabel = dictItem[@"label"];
            [self updateData:[strID intValue] status:4];
            
        }
        else if(isNetworksView==YES){
            strLabel = dictItem[@"name"];
            [self updateNetworkDetailData:[strID intValue]];
        }
        else{
            strLabel = dictItem[@"label"];
            [self updateShowData:[strID intValue]];
            
        }
        if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
            strLabel=@"";
        }
        NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
        [roboAttrString appendAttributedString:aweAttrString];
        payLabel.attributedText = roboAttrString;


    }
    else if(tableView.tag==102){
        if(isStaticPayPerMenuClick==YES){
            strLabel = m_ArrayChannels[indexPath.row];
            NSString *currentStr = m_ArrayChannels[indexPath.row];
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            if([COMMON isSpanishLanguage]==YES){
                currentStr = PayPerViewSpainshStaticArray[indexPath.row];
            }
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                currentStr=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:currentStr attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            payLabel.attributedText = roboAttrString;
            [self tableSeletedStaticActions:strLabel];
        }
        else if(isGenreClick==YES){
            NSDictionary *dictItem = (NSDictionary *)m_ArrayChannels[indexPath.row];
            strLabel = dictItem[@"label"];
            if([COMMON isSpanishLanguage]==YES){
                strLabel = dictItem[SPANISH_TEXT];
            }
            strID = dictItem[@"id"];
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            [self updateData:[strID intValue] status:4];
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            payPerRightMenuLabel.attributedText = roboAttrString;
        }
        
        else if(isRatingClick==YES){
            NSDictionary *dictItem =(NSDictionary *) m_ArrayChannels[indexPath.row];
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            strLabel = dictItem[@"name"];
            if([COMMON isSpanishLanguage]==YES){
                strLabel = dictItem[SPANISH_TEXT];
            }
            strID = dictItem[@"slug"];
            NSString *slug  = dictItem[@"slug"];
            [self loadMoviesRatingData:slug];
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            payPerRightMenuLabel.attributedText = roboAttrString;
        }
    }
     genreName = strLabel;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
   // payLabel.text = strLabel;
    
    bPayMovieNetworkShown = false;
    bPayMovieStaticShown=false;
    bPayGenreShown= false;
    bPayRatingShown= false;
    [payChannelView close];
    payChannelView =nil;
    
}
-(void)tableSeletedStaticActions:(NSString *)selectedStr{
    if([selectedStr isEqualToString:@"Movies"]){
         [arrayPayItems removeAllObjects];
        isPerPerViewMovie=YES;
        isPerPerViewGenre=NO;
        isPerPerViewRating=NO;
         isPerPerViewShows=NO;
        isMovieType=YES;
        currentSelectedStr =@"Movies";
        for(UIView *view in _payPerSliderView.subviews){
            if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
                NSLog(@"UIView");
            }
        }
        [_payPerSliderView setHidden:NO];
        [_payTableView setHidden:YES];
        [payPerRightMenuLabel setHidden:YES];
        [self getPayPerViewFirstMovieCarousels];
        
    }
    else if([selectedStr isEqualToString:@"By Genre"]){
        [sliderImageArray removeAllObjects];
        [topTitleCarouselArray removeAllObjects];
        [arrayPayItems removeAllObjects];
        isPerPerViewGenre=YES;
        isPerPerViewRating=NO;
         isPerPerViewShows=NO;
        isMovieType=YES;
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
        if(isPayPerView==NO) {
            [payPerRightMenuLabel setHidden:YES];
        }else
            [payPerRightMenuLabel setHidden:NO];
        NSDictionary *dictItem =  dropDownNSArray[0];
        NSString *genreStr  = dictItem[@"label"];
        if([COMMON isSpanishLanguage]==YES){
            genreStr = dictItem[SPANISH_TEXT];
            if ((NSString *)[NSNull null] == genreStr||genreStr == nil) {
                genreStr  = dictItem[@"label"];
            }
            
        }
        if ((NSString *)[NSNull null] == genreStr||genreStr == nil) {
            genreStr=@"";
        }
        
        NSString *strID = dictItem[@"id"];
        [self updateData:[strID intValue] status:4];
        NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:genreStr attributes:attrRoboFontDict];
        [roboAttrString appendAttributedString:aweAttrString];
        payPerRightMenuLabel.attributedText = roboAttrString;

        
    }
    else if([selectedStr isEqualToString:@"By Rating"]){
        [sliderImageArray removeAllObjects];
        [topTitleCarouselArray removeAllObjects];
        [arrayPayItems removeAllObjects];
        isPerPerViewGenre=NO;
        isPerPerViewRating=YES;
        isPerPerViewShows=NO;
        isMovieType=YES;
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
         if(isPayPerView==NO)
             [payPerRightMenuLabel setHidden:YES];
        else
            [payPerRightMenuLabel setHidden:NO];
        NSDictionary *dictItem =  perPerViewRatingArray[0];
        NSString *slug  = dictItem[@"slug"];
        NSString *ratingStr  = dictItem[@"name"];
        if([COMMON isSpanishLanguage]==YES){
            ratingStr = dictItem[SPANISH_TEXT];
            if ((NSString *)[NSNull null] == ratingStr||ratingStr == nil) {
                ratingStr  = dictItem[@"name"];
            }
            
        }
        if ((NSString *)[NSNull null] == ratingStr||ratingStr == nil) {
            ratingStr=@"";
        }
        [self loadMoviesRatingData:slug];
        NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:ratingStr attributes:attrRoboFontDict];
        [roboAttrString appendAttributedString:aweAttrString];
        payPerRightMenuLabel.attributedText = roboAttrString;
    }
    else if([selectedStr isEqualToString:@"TV Shows"]){
        currentSelectedStr =@"TV Shows";
        [sliderImageArray removeAllObjects];
        [topTitleCarouselArray removeAllObjects];
        [arrayPayItems removeAllObjects];
        isPerPerViewMovie=YES;
        isPerPerViewGenre=NO;
        isPerPerViewRating=NO;
        isPerPerViewShows=YES;
        isMovieType=NO;
        for(UIView *view in _payPerSliderView.subviews){
            if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
                NSLog(@"UIView");
            }
        }
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:YES];
        [payPerRightMenuLabel setHidden:YES];
        [self getPayPerViewShowsCarousels];
    }
    
}
-(void)loadMoviesRatingData:(NSString *)ratingString{
    int nPPV = PAY_MODE_PAID;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getOnDemandMoviesRatingDetails:^(AFHTTPRequestOperation * request, id responseObject) {
        arrayPayItems = [responseObject mutableCopy];
         nPayCategory = CATEGORY_MOVIES_PAY;
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
        [self.payTableView reloadData];
        [COMMON removeLoading];
        [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self.payMovieActivityIndicator setHidden:true];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [self.payMovieActivityIndicator setHidden:true];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
        
    } strRating:ratingString nPPV:nPPV];
}
#pragma mark - Custom7AlertDialog Delegate
-(void)customIOS7dialogDismiss{
    bPayMovieNetworkShown= false;
    bPayMovieStaticShown=false;
    bPayGenreShown= false;
    bPayRatingShown= false;
    [payChannelView close];
}

#pragma mark - setUpSearchBarInNavigation
-(void) setUpSearchBarInNavigation{
    searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(5, -5, self.view.frame.size.width-10, 48)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBarView setShowsCancelButton:YES];
    searchBarView.delegate = self;
    [searchBarView setTintColor:[UIColor whiteColor]];
    searchBarView.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
    searchBarView.autocorrectionType = UITextAutocorrectionTypeNo;
    for (id subView in ((UIView *)[searchBarView.subviews objectAtIndex:0]).subviews) {
        //UITextField *searchTextField;
        if ([subView isKindOfClass:[UITextField class]]) {
            searchTextField = subView;
            searchTextField.keyboardAppearance = UIKeyboardAppearanceLight;
            [searchTextField setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:116.0f/255.0f blue:203.0f/255.0f alpha:1]];
            searchTextField.textColor =[UIColor whiteColor];
            UIColor *color = [UIColor colorWithRed:119.0f/255.0f green:176.0f/255.0f blue:216.0f/255.0f alpha:1];
            searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search title, actor or movie" attributes:@{NSForegroundColorAttributeName: color}];
            break;
        }
        if([subView isKindOfClass:[UIButton class]]){
            
            UIButton* cancelBtn = (UIButton*)subView;
            cancelBtn.frame=CGRectMake(cancelBtn.frame.origin.x, cancelBtn.frame.origin.x, 30, 30);
            [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(searchBarCancel:) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn setEnabled:YES];
        }
    }
    for(UIView *subView in [searchBarView subviews]) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setReturnKeyType: UIReturnKeySearch];
        } else {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setReturnKeyType: UIReturnKeySearch];
                }
            }
        }
    }
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"close_Icon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"close_Icon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateHighlighted];
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:116.0f/255.0f blue:203.0f/255.0f alpha:1]];
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    spaceBarItem    = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:nil
                                                                   action:nil];
    doneBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Search"
                                                  style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(searchClickAction:)];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem,doneBarItem, nil]];
    searchTextField.inputAccessoryView = keyboardToolbar;
    searchBarView.delegate=self;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //Add a blank character to hack search button enable
    searchBar.showsCancelButton = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
    searchTextField.text =@"";
    searchString =@"";
    // [searchTextField becomeFirstResponder];
    
}
#pragma mark - SearchIconClickAction
-(IBAction)searchAction:(id)sender{
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    //[_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    [searchTextField becomeFirstResponder];
    [searchBarView setHidden:NO];
    searchBarView.tag=1001;
    [self.navigationController.navigationBar addSubview:searchBarView];
    [_searchButton setHidden:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchString = searchText;
}
#pragma mark - SearchAction in keyboard
-(void)searchClickAction:(id)sender{
    
    [_searchButton setHidden:NO];
    
    if(searchString!=nil && ![searchString isEqualToString:@""]){
        [searchBarView setHidden:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self.view endEditing:YES];
        //[COMMON LoadIcon:self.view];
        [COMMON loadProgressHud];
        [self searchCombined];
    }
    else{
        [COMMON removeProgressHud];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [AppCommon showSimpleAlertWithMessage:@"Please Enter Any Keyword to Search"];
        [_searchButton setHidden:NO];
        [searchBarView setHidden:YES];
        [self.view endEditing:YES];
        [COMMON removeLoading];
        
    }
    
}
#pragma mark - searchCombined
-(void) searchCombined{
    
    [[RabbitTVManager sharedManager] getSearch: ^(AFHTTPRequestOperation * operation, id responseObject) {
        searchResponseArray = responseObject;
        NSLog(@"responseSearch->%@",responseObject);
        NSMutableArray *searchKeyValueArr = [NSMutableArray new];
        searchKeysTitle = [[responseObject allKeys] sortedArrayUsingSelector:@selector(compare:)];
        if([searchKeysTitle count]!=0){
            arrayWithCount =  [[NSMutableArray alloc]init];
            for(int i = 0; i < [searchKeysTitle count]; i++)
            {
                NSString *titleStr = [searchKeysTitle objectAtIndex:i] ;
                NSString *countrStr = [[searchResponseArray valueForKey:titleStr]objectForKey:@"count"];
                NSString *checkCount = [NSString stringWithFormat:@"%@",countrStr];
                if(![checkCount isEqualToString:@"0"]){
                    [searchKeyValueArr addObject:titleStr];
                }
            }
            if([searchKeyValueArr count]!=0){
                for (int i = 0; i<[searchKeyValueArr count]; i++) {
                    NSString *keyString = [searchKeyValueArr objectAtIndex:i];
                    if([keyString isEqualToString:@"station"])
                        keyString = @"Channels";
                    [arrayWithCount addObject:keyString];
                }

                [self pushToSearchViewController];
            }
            else{
                [COMMON removeProgressHud];
                NSString *dataNotExist = [NSString stringWithFormat:@"No Result for '%@'",searchString];
                [AppCommon showSimpleAlertWithMessage:dataNotExist];
            }
            
        }
        [COMMON removeProgressHud];
        [COMMON removeLoading];
    } searchString:searchString];
    
}
# pragma Subscription Api

-(void) appAction:(UITapGestureRecognizer *)tap{
    [m_ArrayChannels removeAllObjects];
    UIImageView *imageView   = (UIImageView *) tap.view;
    NSInteger selectedIndex = imageView.tag;
    selectedCaurosalIndex = selectedIndex;
    episodeImage.layer.masksToBounds = NO;
    episodeImage.layer.cornerRadius = 0.0;
    [episodeImage.layer setBorderWidth: 0.0];

    for (UIImageView *img in [HeaderScroll subviews]) {
        NSUInteger tag = img.tag;
        if(selectedIndex == tag) {
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = 0.0;
            [img.layer setBorderColor: [[UIColor yellowColor] CGColor]];
            [img.layer setBorderWidth: 4.0];
        } else {
            img.layer.masksToBounds = NO;
            img.layer.cornerRadius = 0.0;
            [img.layer setBorderWidth: 0.0];
        }
    }
    movieArray = [NSMutableArray new];
    showArray = [NSMutableArray new];

    [self getSubscription:selectedIndex];
    [self performSelector:@selector(showAction) withObject:nil afterDelay:1.0];

}

- (void )getSubscription:(NSInteger)index {
    [COMMON loadProgressHud];
    NSString *codeString;
    if([_subcsArray count]!=0){
        codeString = [[_subcsArray objectAtIndex:index] valueForKey:@"code"];
//        [arrayPayItems removeAllObjects];
        arrayPayItems = [NSMutableArray new];
    }else
        codeString =@"";
    [[RabbitTVManager sharedManager] getUserSubscriptionsWithCodeValue:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"object Values-->%@",responseObject);
        [m_ArrayChannels removeAllObjects];
        movieArray = [responseObject valueForKey:@"movies"];
        if([movieArray count]==0 || movieArray==nil) {
            [movieButton setUserInteractionEnabled:NO];
        }else {
            [movieButton setUserInteractionEnabled:YES];
        }
        showArray = [responseObject valueForKey:@"shows"];
        if([showArray count]==0|| showArray==nil) {
            [showButton setUserInteractionEnabled:NO];
        } else {
            [showButton setUserInteractionEnabled:YES];
        }
        arrayPayItems = [responseObject valueForKey:@"shows"];
        isSubscription = YES;
        isCarouselImage =NO;
        isNetworkUrl = NO;
        isMovieType=NO;
        [_payTableView reloadData];
        [self performSelector:@selector(reloadGridData) withObject:nil afterDelay:1.0];
        [COMMON removeProgressHud];
    } failureBlock:^(AFHTTPRequestOperation *operation, id Error) {
         [COMMON removeProgressHud];
    } codeValue:codeString];
}

- (void)reloadGridData {
    [_payTableView reloadData];
}
-(void) searchByType{
    [[RabbitTVManager sharedManager] getSearchFindByType:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSLog(@"responseByType%@",responseObject);
        
    } searchString:searchString searchTypeStr:@"actor"];
}
- (void)searchBarCancel:(id)sender{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarPush{
    
    [_searchButton setHidden:NO];
    
    if(searchString!=nil && ![searchString isEqualToString:@""]){
        [searchBarView setHidden:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self.view endEditing:YES];
        //[COMMON LoadIcon:self.view];
        [COMMON loadProgressHud];
        [self searchCombined];
    }
    else{
        [AppCommon showSimpleAlertWithMessage:@"Please Enter Any Keyword to Search"];
        [_searchButton setHidden:YES];
        [COMMON removeLoading];
        [COMMON removeProgressHud];
    }
    
}
-(void) pushToSearchViewController{
    [COMMON removeProgressHud];
    [_searchButton setHidden:NO];
    [searchBarView setHidden:YES];
    SearchViewController * searchVC = nil;
    searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"searchView"];
    searchVC.FullSearchArray    = searchResponseArray;
    searchVC.titleTextArray     = arrayWithCount;
    searchVC.searchTitle        = searchString;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [searchTextField resignFirstResponder];
    return YES;
}

#pragma mark - updateData
- (void)updateData:(int)nChannelID status:(int)nStatus{
    [COMMON LoadIcon:self.view];
    int nPPV = PAY_MODE_PAID;
    nPayCategory = CATEGORY_MOVIES_PAY;
    mainPayCategory = CATEGORY_MOVIES_PAY;
    [self.payMovieActivityIndicator setHidden:false];
    [[RabbitTVManager sharedManager] getMovieListbyGenre:^(AFHTTPRequestOperation * request, id responseObject) {
        //arrayMovies = [(NSMutableArray*) responseObject mutableCopy];
        isMovieType=NO;
        [COMMON removeLoading];
        isMovieType=YES;
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
        arrayPayItems = [[NSMutableArray alloc]initWithArray:responseObject];
        [self.payTableView reloadData];
        [self.payMovieActivityIndicator setHidden:true];
    } nID:nChannelID nStatus:nStatus nPPV:nPPV];
    
}
#pragma mark - updateShowData
- (void)updateShowData:(int)nChannelID
{
    [COMMON LoadIcon:self.view];
    [self.payMovieActivityIndicator setHidden:false];
    nPayCategory = CATEGORY_SHOW_PAY;
    int nPPV = PAY_MODE_PAID;
    
    [[RabbitTVManager sharedManager] getShowListByGenre:^(AFHTTPRequestOperation * request, id responseObject) {
        arrayPayItems = [[NSMutableArray alloc]initWithArray:responseObject];
        isMovieType=NO;
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
        [self.payTableView reloadData];
        [COMMON removeLoading];
        NSLog(@"showresponseObject%@",responseObject);
        
        [self.payMovieActivityIndicator setHidden:true];
        
    } nID:nChannelID nPPV:(int)nPPV];
    [payChannelView close];
    
}
#pragma mark - getShowSeasons
- (void)getShowSeasons:(int)nshowID
{
    
    [self.payMovieActivityIndicator setHidden:false];
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        [self.payTableView reloadData];
        [self.payMovieActivityIndicator setHidden:true];
        NSLog(@"arraySeasons%@",responseObject);
        isSeasonArray=YES;
        
    } nID:nshowID];
}
#pragma mark - updateNetworkData
- (void)updateNetworkData:(NSArray*) networks
{
    nPayCategory = CATEGORY_NETWORK_PAY;
    arrayPayItems = [[NSMutableArray alloc] initWithArray:networks];
    isNetworkUrl =YES;
    isCarouselImage=NO;
    [_payPerSliderView setHidden:YES];
    [_payTableView setHidden:NO];
    [self.payTableView reloadData];
}

#pragma mark - updateNetworkDetailData
- (void)updateNetworkDetailData:(int)nNetworkID
{
    [COMMON LoadIcon:self.view];
    //mainPayCategory = CATEGORY_NETWORK_PAY;
    //nPayCategory = CATEGORY_MOVIES_PAY;
    nPayCategory = CATEGORY_SHOW_PAY;
    [self.payMovieActivityIndicator setHidden:false];
    int nPPV = PAY_MODE_PAID;
    if(isPushedFromSubscriptView==YES){
        nPPV = PAY_MODE_ALL;
    }
    else{
        nPPV = PAY_MODE_PAID;
    }
    
    [[RabbitTVManager sharedManager] getNetworkList:^(AFHTTPRequestOperation * request, id responseObject) {
        arrayPayItems = [[NSMutableArray alloc] initWithArray:responseObject];
        isMovieType=NO;
        if([arrayPayItems count] ==0) {
            nPayCategory = CATEGORY_NETWORK_PAY;
            [_payPerSliderView setHidden:YES];
            [_payTableView setHidden:NO];
            [self updateData:nNetworkID status:4];
            [self.payMovieActivityIndicator setHidden:true];
             [COMMON removeLoading];
        }
        else{
            isNetworkUrl = NO;
            isCarouselImage=NO;
            [_payPerSliderView setHidden:YES];
            [_payTableView setHidden:NO];
            [self.payTableView reloadData];
           [self.payMovieActivityIndicator setHidden:true];
             [COMMON removeLoading];
        }
        
    } nID:nNetworkID nPPV:nPPV];
}
#pragma mark - sliderViewInPayPerView
-(void) sliderViewInPayPerView:(NSNotification *)notification
{
    [self removeSearchView];
    
    [[RabbitTVManager sharedManager]cancelRequest];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSDictionary *cellData = [notification object];
    
   
    didSelectId = cellData[@"id"];
    NSString *type = cellData[@"type"];
  
    didSelectName = cellData[@"name"];
    
    if([type isEqualToString:@"M"]){
        
        nPayCategory = CATEGORY_MOVIES_PAY;
        mainPayCategory = CATEGORY_MOVIES_PAY;
        isSeasonExist=NO;
        [self loadNewShowDetailPage];
    }
    else if([type isEqualToString:@"S"]){
        nPayCategory = CATEGORY_SHOW_PAY;
        mainPayCategory = CATEGORY_SHOW_PAY;
        [self checkSeasonExists:didSelectId];
    }
    else if([type isEqualToString:@"N"]){
        [self updateNetworkDetailData:[didSelectId intValue]];
        
    }
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    
    //[self loadNetworkDescription:currentNetworkId currentCarouselId:currentCarouselID];
    
    
}
#pragma mark - sliderViewAllOptionPayPerView
-(void) sliderViewAllOptionPayPerView:(NSNotification *)notification
{
    [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    NSMutableDictionary *cellData = [notification object];
    NSString *carouselId = cellData[@"carouselId"];
    
    NSString *type = cellData[@"type"];
    
    if([type isEqualToString:@"N"]||[type isEqualToString:@"network"]){
        nPayCategory = CATEGORY_NETWORK_PAY;
        isMovieType=NO;
    }
    else if([type isEqualToString:@"M"]||[type isEqualToString:@"movie"]){
        nPayCategory = CATEGORY_MOVIES_PAY;
        isMovieType=YES;
    }
    else{
        nPayCategory = CATEGORY_SHOW_PAY;
        isMovieType=NO;
    }

     int nPPV = PAY_MODE_PAID;
    
    [[RabbitTVManager sharedManager]getWholeViewAll:^(AFHTTPRequestOperation * request, id responseObject) {
        NSLog(@"PRIME%@-->",responseObject);
        [sliderImageArray removeAllObjects];
        [topTitleCarouselArray removeAllObjects];
        [_payPerSliderView setHidden:YES];
        [_payTableView setHidden:NO];
        isCarouselImage=YES;
        arrayPayItems = [responseObject mutableCopy];
        [self.payTableView reloadData];
        [_payTableView setHidden:NO];
        
        [self.payMovieActivityIndicator setHidden:true];
        NSLog(@"PRIME%@-->",responseObject);
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nID:[carouselId intValue] nPPV:nPPV];
}


#pragma mark - sliderViewWatchNowActionPayPerView
-(void)sliderViewWatchNowActionPayPerView:(NSNotification *)notification
{
    [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    NSMutableDictionary *cellData = [notification object];
    
    NSString * sliderID = cellData[@"id"];
    
    didSelectName = cellData[@"name"];
    
    [[RabbitTVManager sharedManager]getOnDemandSliderEntityDetails:^(AFHTTPRequestOperation * request, id responseObject) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        didSelectId = responseObject[@"entity_id"];
        NSString *type = responseObject[@"type"];
        
        if([type isEqualToString:@"movie"]){
            nPayCategory = CATEGORY_MOVIES_PAY;
            mainPayCategory = CATEGORY_MOVIES_PAY;
            [self loadNewShowDetailPage];
        }
        else if([type isEqualToString:@"show"]){
            nPayCategory = CATEGORY_SHOW_PAY;
            mainPayCategory = CATEGORY_SHOW_PAY;
            [self loadNewShowDetailPage];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } slideID:[sliderID intValue]];
    
   [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

#pragma mark - isDeviceIpad
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - GridView Delegate
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    
//    if(isLandscape) {
//        if([self isDeviceIpad])
//            return nPayWidth;
//        return  110;
//    }
    return nPayWidth;
    
}
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    //return nCellHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat currentCellHeight = 210;
        
            if(isMovieType==YES){
                currentCellHeight=210;
            }
            else{
                currentCellHeight=155;
            }
        if(isSubscription==YES) {
            currentCellHeight = 120.0;
        }
        if(isLandscape) {
            currentCellHeight = 210.0;
        }

        return currentCellHeight;//nPayHeight;185//155
    }
    else{
        CGFloat currentCellHeight = 160;
        if(isMovieType==YES){
            currentCellHeight=160;
        }
        else{
            currentCellHeight=140;
        }
        if(isSubscription==YES) {
            currentCellHeight = 120.0;
        }
        if(isLandscape) {
            currentCellHeight = 160.0;
        }

        return currentCellHeight;//160
        
    }
}
- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    if(isLandscape) {
        if([self isDeviceIpad])
            return nPayCount;
       else
            return 3;
    } else
        return nPayCount;
}
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if([_subcsArray count]==0)
        return 0;
    return [arrayPayItems count];

}
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
    //CELL
   // New_Land_Cell* cell = [grid dequeueReusableCell];
    OnDemand_Grid_Cell* cell = [grid dequeueReusableCell];
    if(cell == nil) {
        cell = [[OnDemand_Grid_Cell alloc] init];
    }
    if([arrayPayItems count] == 0){
        [arrayPayItems removeAllObjects];
    }
    else {
        
        int nIndex = rowIndex * nPayCount + columnIndex;
        
        // NSLog(@"Array count = %lu, index = %d", (unsigned long)arrayPayItems.count, nIndex);
        NSDictionary* dictItem = arrayPayItems[nIndex];
        NSString* strPosterUrl;
        if(isNetworkUrl ==YES){
            
            strPosterUrl = dictItem[@"thumbnail"];
        }
        else if(isCarouselImage==YES){
            strPosterUrl = dictItem[@"carousel_image"];
        }
        else if(isSubscription==YES){
            strPosterUrl = dictItem[@"image"];
        }else{
        
            strPosterUrl = dictItem[@"poster_url"];
        }
        
        //NSString* strName = dictItem[@"name"];
        NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
        
        
        if(isPayPerView==YES || isLandscape==YES){
            
            if(isPerPerViewShows==YES){
                [cell.moviePortraitImage setHidden:YES];
                [cell.thumbnail setHidden:NO];
                [cell.landScapeView setHidden:NO];
                [cell.portraitImageView setHidden:YES];
                [cell.portraitView setHidden:YES];
                //[cell.thumbnail setImageWithURL:imageUrl];
                [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
            }
            else{
                [cell.thumbnail setHidden:YES];
                [cell.landScapeView setHidden:YES];
                [cell.portraitView setHidden:NO];
                [cell.moviePortraitImage setHidden:NO];
                [cell.portraitImageView setHidden:YES];
               // [cell.moviePortraitImage setImageWithURL:imageUrl];
                [cell.moviePortraitImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];
            }
        }
        
        else{
            [cell.moviePortraitImage setHidden:YES];
            [cell.thumbnail setHidden:NO];
            [cell.landScapeView setHidden:NO];
            [cell.portraitImageView setHidden:YES];
            [cell.portraitView setHidden:YES];
            //[cell.thumbnail setImageWithURL:imageUrl];
            [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
            
        }

        
       /* [cell.thumbnail setImageWithURL:imageUrl ];//placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
        [cell.label setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        [cell.label setText:strName];*/
//        [cell.freeLabel setHidden:YES];
//
//        if(isPayPerView==YES){
//            [cell.portraitLabel setHidden:YES];
//            [cell.landScapeLabel setHidden:YES];
//            [cell.thumbnail setHidden:YES];
//            [cell.landScapeView setHidden:YES];
//            [cell.portraitView setHidden:NO];
//            [cell.portraitImageView setHidden:NO];
//            [cell.portraitImageView setImageWithURL:imageUrl];
//            [cell.portraitLabel setText:strName];
//
//        }
//        else{
//            [cell.portraitLabel setHidden:YES];
//            [cell.landScapeLabel setHidden:YES];
//            [cell.thumbnail setHidden:NO];
//            [cell.landScapeView setHidden:NO];
//            [cell.portraitImageView setHidden:YES];
//            [cell.portraitView setHidden:YES];
//            [cell.thumbnail setImageWithURL:imageUrl];
//            [cell.landScapeLabel setText:strName];
//        }
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//            [cell.portraitLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
//            [cell.landScapeLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
//        }
    }
    
    return cell;
    
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    bPayMovieNetworkShown = false;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self.payMovieActivityIndicator setHidden:false];

    int nIndex = rowIndex * nPayCount + colIndex;
    NSDictionary* dictItem = arrayPayItems[nIndex];
    NSString* showId = dictItem[@"id"];
    didSelectId = dictItem[@"id"];
    didSelectName= dictItem[@"name"];
    
    NSLog(@"showID%@",dictItem[@"id"]);
    if(nPayCategory == CATEGORY_MOVIES_PAY){
         isSeasonExist=NO;
        [self loadNewShowDetailPage];
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
    else if(nPayCategory == CATEGORY_SHOW_PAY){
        [self.payMovieActivityIndicator setHidden:false];
        
        [self checkSeasonExists:showId];
        
    }else if(nPayCategory == CATEGORY_NETWORK_PAY){
        [self.payMovieActivityIndicator setHidden:true];
        int nIndex = rowIndex * nPayCount + colIndex;
        NSDictionary* dictItem = arrayPayItems[nIndex];
        NSString* nID = dictItem[@"id"];
        [self updateNetworkDetailData:[nID intValue]];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
}
#pragma mark - checkSeasonExists
-(void)checkSeasonExists:showId{
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        [self.payMovieActivityIndicator setHidden:true];
        if([arraySeasons count] > 0) {
            isSeasonExist=YES;
            [self loadNewShowDetailPage];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        else if([arraySeasons count] == 0){
            [self.payMovieActivityIndicator setHidden:true];
            isSeasonExist=NO;
            [self loadNewShowDetailPage];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
    } nID:[showId intValue]];
}
#pragma mark - NEW PUSH
//NEW
#pragma mark - loadNewShowDetailPage
-(void)loadNewShowDetailPage {
    [COMMON LoadIcon:self.view];
    NewShowDetailViewController * mShowVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail_ipad"];
    } else {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail"];
    }
    mShowVC.nID = didSelectId;
    mShowVC.headerLabelStr = didSelectName;
    if(mainPayCategory == CATEGORY_NETWORK_PAY){
        [mShowVC setIfMovies:false];
    }
    else if(nPayCategory == CATEGORY_SHOW_PAY){
        [mShowVC setIfMovies:false];
    }
    else{
        [mShowVC setIfMovies:true];
    }
    if(isSeasonExist){
        mShowVC.isEpisode=YES;
        mShowVC.showFullSeasonsArray = arraySeasons;
    }
    else{
        
        mShowVC.isEpisode=NO;
    }
    if(genreName==nil){
        genreName=@"";
    }
    mShowVC.genreName = genreName;
    if(isPushedFromSubscriptView==YES){
        mShowVC.isPushedFromPayPerView=NO;
        mShowVC.isToggledAll=YES;
    }
    else{
        mShowVC.isPushedFromPayPerView=YES;
    }
    
    [self.navigationController pushViewController:mShowVC animated:YES];
    [COMMON removeLoading];
}

#pragma mark - orientationChanged
-(void) PayMovieOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self payPerViewRotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self payPerViewRotateViews:false];
            break;
            
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
   // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}
-(void)removeSearchView{
    [self.view endEditing:YES];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - rotateViews

-(void) payPerViewRotateViews:(BOOL) bPortrait{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(isPayPerView==NO) {
        [self loadMovieLatestAppListScrollViewData];
    }
        [_searchButton setHidden:NO];
    [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
    [self setUpSearchBarInNavigation];
    
    if([sliderImageArray count]!=0||[topTitleCarouselArray count]!=0){
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselArray];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
    if(bPortrait){
        port_PPViewHeight = SCREEN_HEIGHT;

        nPayCount = 2;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nPayCount = 4;
            
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nPayWidth = screenWidth / nPayCount;
        nPayHeight = screenWidth / nPayCount;
        
        if(port_PPViewHeight!=land_PPViewHeight){
            [self onPayPerViewLeftMenuList:YES];
        }
    }else{
        land_PPViewHeight = SCREEN_HEIGHT;
        nPayCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nPayCount = 5;
            
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nPayWidth = screenWidth / nPayCount;
        nPayHeight = screenWidth / nPayCount;
        
        if(port_PPViewHeight!=land_PPViewHeight){
            [self onPayPerViewLeftMenuList:NO];
        }
        
    }
    [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.payTableView reloadData];
}
-(void)onPayPerViewLeftMenuList:(BOOL)portraitBool{
    if(bPayMovieNetworkShown) {
        bPayMovieNetworkShown= false;
        [payChannelView removeFromSuperview];
        [payChannelView close];
        payChannelView = nil;
        [self loadPayMovieNetworkMenuData];
    }
    if(bPayMovieStaticShown) {
        [payChannelView removeFromSuperview];
        [payChannelView close];
        payChannelView = nil;
        [self loadPayMovieStaticMenuData];
    }
    if(bPayGenreShown) {
        [payChannelView removeFromSuperview];
        [payChannelView close];
        payChannelView = nil;
        [self loadPayPerGenreMenuData];
    }
    if(bPayRatingShown) {
        [payChannelView removeFromSuperview];
        [payChannelView close];
        payChannelView = nil;
        [self loadPayPerRatingMenuData];
    }
    if(portraitBool==YES){
        land_PPViewHeight  = port_PPViewHeight;
    }
    else{
        port_PPViewHeight  = land_PPViewHeight;
    }

}
-(void)loadMovieLatestAppListScrollViewData{
    for(UIView *views in [_caurosalView subviews]) {
        [views removeFromSuperview];
    }
    HeaderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _caurosalView.frame.size.height-50)];
    UIView *movieShowView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(HeaderScroll.frame), _caurosalView.frame.size.width-20, 50)];
    showButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];//CGRectMake(CGRectGetMaxX(movieButton.frame), 0, 150, 50)
    movieButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(showButton.frame), 0, 100, 50)];
    [movieButton setTitle:@"Movies" forState:UIControlStateNormal];
    [showButton setTitle:@"Shows" forState:UIControlStateNormal];
    manageLabel = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(movieButton.frame), 0, SCREEN_WIDTH-220, 50)];
//    [manageLabel setBackgroundColor:[UIColor lightGrayColor]];
    CGFloat X1Pos;
    if([self isDeviceIpad]) {
        X1Pos = SCREEN_WIDTH-200;
    } else {
        X1Pos = CGRectGetMaxX(movieButton.frame)+20;

    }
    [manageLabel setUserInteractionEnabled:YES];
    [movieShowView setUserInteractionEnabled:YES];
    [_caurosalView setUserInteractionEnabled:YES];
    UIButton *manageButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [manageButton setFrame:CGRectMake(X1Pos, CGRectGetMaxY(_caurosalView.frame)-50, 150, 50)];
    [manageButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(16)]];
    [manageButton setTitle:@"Manage +" forState:UIControlStateNormal];
//    [manageButton setBackgroundColor:[UIColor redColor]];
    [manageButton setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
//    [manageButton setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subscriptionAction:)];
//    letterTapRecognizer.numberOfTapsRequired = 1;
//    [manageLabel addGestureRecognizer:letterTapRecognizer];
    if([_subcsArray count]==0) {
        [HeaderScroll setHidden:YES];
        [movieShowView setHidden:YES];
    } else {
        [HeaderScroll setHidden:NO];
        [movieShowView setHidden:NO];
    }

    [manageButton addTarget:self
                     action:@selector(subscriptionAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [movieButton addTarget:self
                 action:@selector(movieAction)
       forControlEvents:UIControlEventTouchUpInside];
    [showButton addTarget:self
                    action:@selector(showAction)
          forControlEvents:UIControlEventTouchUpInside];
    [movieShowView addSubview:movieButton];
    [movieShowView addSubview:showButton];
    [self.view addSubview:manageButton];
    [movieShowView addSubview:manageLabel];
    [_caurosalView addSubview:movieShowView];
     [_caurosalView addSubview:HeaderScroll];

//    UIView *backgroundView;
    CGFloat xPos = 10;
    for(int i = 0; i < [_subcsArray count]; i++) {
        episodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 15, 60, 60)];
        //[episodeImage setImageWithURL:imageUrl];
        episodeImage.tag = i;
        if(i==selectedCaurosalIndex) {
            episodeImage.layer.masksToBounds = YES;
            episodeImage.layer.cornerRadius = 0.0;
            [episodeImage.layer setBorderColor: [[UIColor yellowColor] CGColor]];
            [episodeImage.layer setBorderWidth: 4.0];
        }
        [episodeImage setUserInteractionEnabled:YES];
        NSString *urlString = [[_subcsArray valueForKey:@"image_url"] objectAtIndex:i];
        NSURL *imgUrl=[NSURL URLWithString:urlString];
         [episodeImage setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"white_Bg"]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [episodeImage setUserInteractionEnabled:YES];
        [episodeImage addGestureRecognizer:tapGesture];
        [HeaderScroll addSubview:episodeImage];
        xPos += episodeImage.frame.size.width+15;
    }
    if(isShowsClicked)
        [self performSelector:@selector(showAction) withObject:nil afterDelay:1.0];
    else
        [self performSelector:@selector(movieAction) withObject:nil afterDelay:1.0];

if([self isDeviceIpad])
    [HeaderScroll setContentSize:CGSizeMake((episodeImage.frame.size.width)*[_subcsArray count], HeaderScroll.frame.size.height)];
    else
        [HeaderScroll setContentSize:CGSizeMake((episodeImage.frame.size.width)*[_subcsArray count]+200, HeaderScroll.frame.size.height)];
 
}

- (void)movieAction {
    isShowsClicked = NO;
     nPayCategory = CATEGORY_MOVIES_PAY;
    [upperLeftBorder removeFromSuperview];
    [upperRightBorder removeFromSuperview];
    [upperTopBorder removeFromSuperview];
    [upperBottomBorder1 removeFromSuperview];
    [upperBottomBorder2 removeFromSuperview];
    isLandscape = YES;
    appDelegate.isSubscriptPage = @"NO";
    upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, movieButton.frame.size.height)];
    upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(movieButton.frame.size.width-1.0f, 0, 1.0, movieButton.frame.size.height-1.0)];
    upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,movieButton.frame.size.width-1.0,1.0)];
    
    upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, showButton.frame.size.height-2.0f, showButton.frame.size.width, 1.0)];
    upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, showButton.frame.size.height-2.0f, showButton.frame.size.width, 1.0)];
    [self autoMaskingForUpperButtonBorder];
    [movieButton addSubview:upperLeftBorder];
    [movieButton addSubview:upperRightBorder];
    [movieButton addSubview:upperTopBorder];
    [showButton addSubview:upperBottomBorder1];
    [showButton addSubview:upperBottomBorder2];
//    [showButton addSubview:upperTopBorder];
//    [showButton addSubview:upperRightBorder];
    
   UIView *upperBottom = [[UIView alloc] initWithFrame:CGRectMake(0, manageLabel.frame.size.height-2.0f, manageLabel.frame.size.width, 1.0)];
    [upperBottom setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [manageLabel addSubview:upperBottom];
    
    UIView* Border = [[UIView alloc] initWithFrame:CGRectMake(1, 0,movieButton.frame.size.width-1.0,1.0)];
    UIView*LeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, movieButton.frame.size.height)];

    [Border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [LeftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    
    [showButton addSubview:Border];
    [showButton addSubview:LeftBorder];

    upperLeftBorder.backgroundColor = [UIColor whiteColor];
    upperRightBorder.backgroundColor = [UIColor whiteColor];
    upperTopBorder.backgroundColor = [UIColor whiteColor];
    upperBottomBorder1.backgroundColor = [UIColor whiteColor];
    upperBottomBorder2.backgroundColor = [UIColor whiteColor];
    upperBottom.backgroundColor = [UIColor whiteColor];
    Border.backgroundColor = BORDER_BLUE;
    LeftBorder.backgroundColor = BORDER_BLUE;

    [showButton setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [movieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [movieButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    [showButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    arrayPayItems = [movieArray mutableCopy];
    [_payTableView reloadData];
}

-(void) autoMaskingForUpperButtonBorder{
    
    [upperLeftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [upperRightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [upperTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [upperBottomBorder1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [upperBottomBorder2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}


- (void)showAction {
    isShowsClicked = YES;
     nPayCategory = CATEGORY_SHOW_PAY;
    [upperLeftBorder removeFromSuperview];
    [upperRightBorder removeFromSuperview];
    [upperTopBorder removeFromSuperview];
    [upperBottomBorder1 removeFromSuperview];
    [upperBottomBorder2 removeFromSuperview];
    isLandscape = NO;
    upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, movieButton.frame.size.height)];
    upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(movieButton.frame.size.width-1.0f, 0, 1.0, movieButton.frame.size.height-1.0)];
    upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,movieButton.frame.size.width-1.0,1.0)];
    
    upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, showButton.frame.size.height-2.0f, showButton.frame.size.width, 1.0)];
    upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, showButton.frame.size.height-2.0f, showButton.frame.size.width, 1.0)];
    [self autoMaskingForUpperButtonBorder];
    [showButton addSubview:upperLeftBorder];
    [showButton addSubview:upperRightBorder];
    [showButton addSubview:upperTopBorder];
    [movieButton addSubview:upperBottomBorder1];
    [movieButton addSubview:upperBottomBorder2];
//    [movieButton addSubview:upperTopBorder];
//    [movieButton addSubview:upperLeftBorder];
    UIView *upperBottom = [[UIView alloc] initWithFrame:CGRectMake(0, manageLabel.frame.size.height-2.0f, manageLabel.frame.size.width, 1.0)];
    [upperBottom setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [manageLabel addSubview:upperBottom];
   UIView * TopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,movieButton.frame.size.width-1.0,1.0)];
     UIView *RightBorder = [[UIView alloc] initWithFrame:CGRectMake(movieButton.frame.size.width-1.0f, 0, 1.0, movieButton.frame.size.height-1.0)];
    [TopBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [RightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    
    [movieButton addSubview:TopBorder];
    [movieButton addSubview:RightBorder];
    upperLeftBorder.backgroundColor = [UIColor whiteColor];
    upperRightBorder.backgroundColor = [UIColor whiteColor];
    upperTopBorder.backgroundColor = [UIColor whiteColor];
    upperBottomBorder1.backgroundColor = [UIColor whiteColor];
    upperBottomBorder2.backgroundColor = [UIColor whiteColor];
    TopBorder.backgroundColor = BORDER_BLUE;
    RightBorder.backgroundColor = BORDER_BLUE;

    upperBottom.backgroundColor = [UIColor whiteColor];
    [movieButton setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [movieButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    [showButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];

    arrayPayItems = [showArray mutableCopy];
    [_payTableView reloadData];
}
- (void) subscriptionAction:(id)sender {
    appDelegate.isSubscriptPage = @"NO";
    SWRevealViewController *revealviewcontroller1 = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    [revealviewcontroller revealToggleAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"subnavcontroller"];
    revealviewcontroller1.frontViewController = navController;
    
    SubScriptionsViewController *mSubVC = [[navController viewControllers] objectAtIndex:0];
//    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"subnavcontroller"];
    mSubVC.isKidsMenu = NO;
    mSubVC.isSide = YES;

}
-(IBAction)reloadingAction:(UIButton *)sender{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}
@end
