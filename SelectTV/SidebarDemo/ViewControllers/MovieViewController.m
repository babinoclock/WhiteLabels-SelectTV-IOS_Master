//
//  MapViewController.m
//  SidebarDemo
//
//  Created by Simon on 30/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MovieViewController.h"
#import "UIGridView.h"
#import "Cell.h"
#import "Land_Cell.h"
#import "New_Land_Cell.h"
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
#import "AppDownloadTableViewCell.h"
#import "UIImage+WebP.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "SWRevealViewController.h"
#import "PayMovieViewController.h"
#import "AppDownloadListCell.h"
#import "SidebarViewController.h"
#import "NKContainerCellTableViewCell.h"
#import "OnDemandSliderCarouselView.h"
#import "OnDemand_Grid_Cell.h"
#import "appManagerStaticCustomCollectionCell.h"



@interface MovieViewController () <CustomIOS7AlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SWRevealViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    SWRevealViewController *revealviewcontroller;
    SidebarViewController *sideBar;
    AsyncImage *asyncImage;
    NSMutableAttributedString *aweAttrString;
    NSMutableAttributedString *aweBackArrowAttrString;
    NSDictionary *attrRoboFontDict;
    NSDictionary *attrAweSomeDict;
    NSString *didSelectId;
    NSString *didSelectName;
    NSDictionary *didSelectedDict;
    NSMutableArray *categoryListArray;
    UIView * showPopUpInnerView;
    CGFloat iPhoneCellHeight;
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
    
    //title MenuScroll
    UIScrollView   *showHeaderView;
    UIView *backgroundView ;
    UILabel *indicateLabel;
    CGFloat scrollButtonWidth;
    CGFloat scrollButtonWidthTest;
    UIButton *closePopUpBtn;

    CGSize stringsize;
    BOOL isScrolled;
    NSInteger visibleSection;
    NSInteger appVisibleSection;
    NSInteger appAdditionInteger;
    NSArray *headerTitleArray;
    NSMutableArray *tempTitleArray;
    BOOL isAppListShown;
    
    BOOL isAppListFirstTimeHidden;
    BOOL isPopUpClicked;
    
    UITapGestureRecognizer *cellTapRecognizer;
    
    NSString *description;
    
    CGFloat port_heightView;
    CGFloat land_heightView;
    BOOL isGetAppsListDataClicked;
    
    NSInteger segmentTag;
    NSString *currentCarouselID,*currentAppImage,*currentAppLink,*currentAppName;
    BOOL iPhoneLandScape;
    BOOL isOnDemandCarousel;
    
    
    float xslider;
    NSInteger jslider;
    UIImageView            *infoImage;
    UIView                 *pgDtView;
    UIImageView            *pageImageView;
    UIImageView            *blkdot;
    NSMutableArray         *ImageArray;
    NSString               *pull;
    
    NSMutableArray *sliderImageArray;
    
    //NETWORK
    UIView * networkView;
    UIGridView *networkTableView;
    UIView * topView;
    CGRect originalTableViewFrame;
    NSString *currentNetworkID;
    NSMutableArray *currentNetworkDetailArray;
    
    NSMutableDictionary *currentNetworkDict;
    
    //MENU ORIENTATION
    CGFloat port_MovieViewHeight;
    CGFloat land_MovieViewHeight;
    
    UIScrollView *fullSlideScrollView;
    BOOL isMovieType;
    BOOL isAllFreeSwitch;
    int commonPPV;
    NSString *commonSlug;
    NSString *commonID;
    NSString *commonWeekStr;
    NSString *commonType;
    
    NSString *currentTopTitle;
    
    NSMutableArray *dropdownSpainshTVShowsArray;
    NSMutableArray *dropdownSpainshMoviesArray;
    NSMutableArray *dropdownSpainshPrimeWeekdayArray;
    
    BOOL isDecadeSpanish;
    BOOL isCategorySpanish;
    BOOL isRatingSpanish;
    BOOL isTVMovieGenreSpanish;
    
    //NEW
    NSMutableArray *currentSliderViewAllArray;
    BOOL isWillDisAppear;
    BOOL isTimerLoaded;
    
    int appManagerCategoryId;
    int appManagerDeviceId;
    NSTimer *timer;
    BOOL isTimerInAppManager;
    BOOL isAddActionCalled;
    
    //new change
    NSArray *essentials;
    NSArray *broadcast;
    NSArray *cable;
    NSArray *subscriptions;
    NSArray *movies;
    NSArray *other;
    NSArray *appCollectionStaticArray;
    
    
    BOOL isVideoLinkTapped;
    UIView * itemDetailBgView;
    
    BOOL appManagerDoneClicked;

}
//AppInfo
@property (nonatomic) NSInteger schemeType;
@property (nonatomic, retain) NSArray *publicURLSchemes;
@property (nonatomic, retain) NSArray *privateURLSchemes;

//NEW test for apps
@property (nonatomic, retain) NSArray *apps;

@end

@implementation MovieViewController
@synthesize isPayPerView,isPayPerViewStr,tvShowStr,tvShowLabel,headerLabelStr,isNetworksView;
@synthesize  dropDownNSArray, dropDownTvShowArray, dropDownTvNetworkArray,primeWeekDayArray,primeRightViewAllArray,sportsDataArray;

@synthesize onDemandSliderView,onDemandSliderTableView;

@synthesize isLoadIcon,okDoneBtn,isAppManagerMenu;

//NEW
@synthesize dropDownTvShowStaticArray,dropDownMoviesStaticArray;

NSMutableArray* arrayItems;
NSMutableArray* appListArrayItems;
NSMutableArray* arrayShows;
NSMutableArray* arraySeasons;
NSMutableArray* arrayItemsTemp;

NSMutableArray* arrayItemsPopUp;

static int CATEGORY_SHOW = 0;
static int CATEGORY_MOVIES = 1;
static int CATEGORY_NETWORK = 2;

int nCategory;
int mainCategory;

int nColumCount = 2;
int nCellWidth = 107;
int nCellHeight = 200;


CustomIOS7AlertView *movieChannelView;

CustomIOS7AlertView *showPopUpView;

bool isSeasonArray;
BOOL isNetworkUrl;

BOOL isPopUpClicked = false;

BOOL bTvMenuShown = false;
BOOL bNetworkShown = false;
BOOL bMovieShown = false;
BOOL bPrimeLeftMenuShown = false;
//SUB
BOOL bTvMenuByNetwork =false;
BOOL bTvMenuByCategory =false;
BOOL bTvMenuByGenre =false;
BOOL bTvMenuByDecade =false;

//SUB
BOOL bMovieMenuByGenre =false;
BOOL bMovieMenuByRating =false;
BOOL bAppPopUpShown = false;
BOOL isFirstTime =true;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadStaticArrayForAppManager];

    
    visibleSection =0;
    appVisibleSection=0;
    appAdditionInteger=1000;
    
    appManagerDoneClicked =NO;
    
    //new change raji
    isVideoClosed =NO;
    isiPhoneViewPage=NO;
    
    originalTableViewFrame = _tableView.frame;
    iPhoneCellHeight = 110;
    [_tableView setHidden:YES];
    commonPPV = PAY_MODE_FREE;
    isAddActionCalled=NO;
    
    //new chnage hidding for the static app manager
   // [self getAppsCategoryData];
   
    [self setUpManualArray];
    
    
    [self setUpManualNotification];
    
    
    
    [self setUpNavigationAndOrientation];
    
    [movieChannelView close];
     movieChannelView = nil;
   
    [self setUpFont];
    [self setUpViews];
    [self setAllFreeViewInOnDemand];
    

    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    
    revealviewcontroller.rightViewController=nil;
    
    [self videoViewAndAppManagerView];//have to give in did load
}
#pragma mark - setUpManualArray
-(void)setUpManualArray{
    asyncImage =[[AsyncImage alloc]init];
    appTitleArray = [[NSMutableArray alloc]init];
    installedArray = [[NSMutableArray alloc]init];
    notInstalledArray = [[NSMutableArray alloc]init];
    appInstalledArray = [[NSMutableArray alloc]init];
    primeRightViewAllArray = [[NSMutableArray alloc]init];
    sportsDataArray = [[NSMutableArray alloc]init];
    isPopUpClicked = false;
    
    // onDemandSliderView.translatesAutoresizingMaskIntoConstraints = YES;
    
    dropDownTvShowStaticArray = [[NSMutableArray alloc] initWithObjects:@"TV Shows", @"by Network",@"by Category",@"by Genre",@"by Decade", nil];
    dropDownMoviesStaticArray = [[NSMutableArray alloc] initWithObjects:@"Movies", @"by Genre",@"by Rating", nil];
    primeWeekDayArray = [[NSMutableArray alloc] initWithObjects:@"Monday", @"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    if([COMMON isSpanishLanguage]==YES){
        [self setArrayforSpainsh];
    }
    
}
#pragma mark - setUpManualNotification
-(void)setUpManualNotification{
    
    //APP MANAGER
    
    NSString * isValidStr = [COMMON getAppManagerManualNotification];
    
    if ((NSString *)[NSNull null] == isValidStr||isValidStr == nil) {
        isValidStr =@"YES";
    }
    if([isValidStr isEqualToString:@"YES"]){
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionViewForMovie:) name:@"didSelectItemFromCollectionViewForMovie" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemInCellAppManager:) name:@"didSelectItemInCellAppManager" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAddAction:) name:@"didSelectAddAction" object:nil ];//didSelectAddAction
        
    }
    
    //if(isAppManagerMenu==NO){}
        
        //ON DEMAND
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionViewForOnDemand:) name:@"didSelectItemFromCollectionViewForOnDemand" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewAllOption:) name:@"sliderViewAllOption" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewWatchNowAction:) name:@"sliderViewWatchNowAction" object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeSearchViewBar" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSearchView) name:@"removeSearchViewBar" object:nil];
    
    
    [COMMON setAppManagerManualNotification:@"NO"];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
//    if(isFirstTime==false){
//        [self dismissPopup];
//    }
    
    //[onDemandSliderView removeFromSuperview];
   
    [super viewWillAppear:animated];
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    bAppPopUpShown= false;
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"YES"]){
        [showPopUpInnerView removeFromSuperview];
        [showPopUpView removeFromSuperview];
        showPopUpInnerView = nil;
        showPopUpView = nil;
        NSString *titleStr = @"App Manager";
        
        if([COMMON isSpanishLanguage]==YES){
            titleStr = [COMMON getAppManagerStr];
            if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
                titleStr = @"App Manager";
                titleStr =  [COMMON stringTranslatingIntoSpanish:titleStr];
                [[NSUserDefaults standardUserDefaults] setObject:titleStr forKey:APP_MANAGER];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        if(appManagerDoneClicked==YES){
            NSString *titleStr = @"On Demand";
            if([COMMON isSpanishLanguage]==YES){
                titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
            }
        }
        self.navigationItem.title =titleStr;
        isAppListShown = YES;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [_searchButton setHidden:YES];
        isDownloadAppViewHidden=NO;
        [_playerBgView setHidden:YES];
        [_playerBgView removeFromSuperview];
        [downloadView setHidden:NO];
    }

    if(isDownloadAppViewHidden==YES){
        [_searchButton setHidden:NO];
    }
    else{
        [_searchButton setHidden:YES];
    }
    self.revealViewController.delegate = self;
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
   
    
}
-(void)loadStaticArrayForAppManager{
    
    [self loadEssentialsArray];
    [self loadBroadCastArray];
     [self loadCableArray];
     [self loadMoviesArray];
     [self loadOtherArray];
    [self loadSubScriptionArray];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [self dismissPopup];
    if(isDownloadAppViewHidden==YES){
        [_searchButton setHidden:NO];
    }
    else{
        [_searchButton setHidden:YES];
    }
    [super viewWillDisappear:animated];
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectAddAction" object:nil];
    
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionViewForMovie" object:nil];
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemInCellAppManager" object:nil];
    
    
    [self.playerView stopVideo];
//    isInstalledClicked=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.playerView stopVideo];
}
#pragma mark - setUpNavigationAndOrientation
-(void)setUpNavigationAndOrientation{
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.navigationItem.title = headerLabelStr;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    // self.edgesForExtendedLayout=UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieViewOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self onDemandMovieRotateViews:false];
    }else{
        [self onDemandMovieRotateViews:true];
    }
    
}
#pragma mark - videoViewAndAppManagerView
-(void)videoViewAndAppManagerView{
    //For Testing the Demo Vieo Played or not
    NSString *videoPlayed = [COMMON getDemoVideoPlayed];
    if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil) {
        
        [self addOnDemandPlayerView];
        [onDemandSliderView setHidden:YES];
        isDownloadAppViewHidden=NO;
        isAppListShown = YES;
        [_searchButton setHidden:YES];
        
    }
    else{
        [self.playerBgView setHidden:YES];
        [downloadView setHidden:YES];
        isDownloadAppViewHidden=YES;
        isPopUpClicked = false;
        isAppListShown = NO;
        NSString *titleStr = headerLabelStr;
        if([COMMON isSpanishLanguage]==YES){
            titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
        }
        self.navigationItem.title = titleStr;
        UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
        [_searchButton setHidden:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"YES"]){
        isTimerLoaded=YES;
        
        //new change
        [onDemandSliderView setHidden:YES];
        [showPopUpInnerView setHidden:YES];
        [showPopUpView setHidden:YES];
        
        //old
        //[onDemandSliderView removeFromSuperview];
       // [showPopUpInnerView removeFromSuperview];
        //[showPopUpView removeFromSuperview];
        //showPopUpInnerView = nil;
        //showPopUpView = nil;
        NSString *titleStr = @"App Manager";
        if([COMMON isSpanishLanguage]==YES){
            titleStr = [COMMON getAppManagerStr];
            if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
                titleStr = @"App Manager";
                titleStr =  [COMMON stringTranslatingIntoSpanish:titleStr];
                [[NSUserDefaults standardUserDefaults] setObject:titleStr forKey:APP_MANAGER];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        if(appManagerDoneClicked==YES){
            NSString *titleStr = @"On Demand";
            if([COMMON isSpanishLanguage]==YES){
                titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
            }
        }
        self.navigationItem.title =titleStr;
        isAppListShown = YES;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [_searchButton setHidden:YES];
        isDownloadAppViewHidden=NO;
        [_playerBgView setHidden:YES];
        [_playerBgView removeFromSuperview];
        [downloadView setHidden:NO];
    }
    
}
#pragma mark - setArrayforSpainsh
-(void)setArrayforSpainsh{
    dropdownSpainshTVShowsArray = [NSMutableArray new];
    dropdownSpainshMoviesArray= [NSMutableArray new];
    dropdownSpainshPrimeWeekdayArray = [NSMutableArray new];
    dropdownSpainshTVShowsArray = [[COMMON retrieveContentsFromFile:ON_TV_SHOWS_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    dropdownSpainshMoviesArray = [[COMMON retrieveContentsFromFile:ON_MOVIES_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    dropdownSpainshPrimeWeekdayArray = [[COMMON retrieveContentsFromFile:ON_PRIME_WEEKDAYS_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    if([dropdownSpainshTVShowsArray count]==0){
        
        [self getStaticTranslatedWordList:ON_TV_SHOWS_STATIC_WORDS currentStaticArray:(NSMutableArray*)dropDownTvShowStaticArray];
         dropdownSpainshTVShowsArray = [[COMMON retrieveContentsFromFile:ON_TV_SHOWS_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    }
    if([dropdownSpainshMoviesArray count]==0){
        [self getStaticTranslatedWordList:ON_MOVIES_STATIC_WORDS currentStaticArray:(NSMutableArray*)dropDownMoviesStaticArray];
         dropdownSpainshMoviesArray = [[COMMON retrieveContentsFromFile:ON_MOVIES_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    }
    if([dropdownSpainshPrimeWeekdayArray count]==0){
        [self getStaticTranslatedWordList:ON_PRIME_WEEKDAYS_STATIC_WORDS currentStaticArray:(NSMutableArray*)primeWeekDayArray];
         dropdownSpainshPrimeWeekdayArray = [[COMMON retrieveContentsFromFile:ON_PRIME_WEEKDAYS_STATIC_WORDS dataType:DataTypeArray] mutableCopy];
    }

}
#pragma mark - setAllFreeViewInOnDemand
-(void)setAllFreeViewInOnDemand{
    CGFloat allLabelWidth,freeLabelWidth;
    //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [_allFreeView setBackgroundColor:[UIColor clearColor]];
    
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        allLabelWidth=_allFreeView.frame.size.width/5.5+10;
        freeLabelWidth=_allFreeView.frame.size.width/3;
        
    }
    else{
        allLabelWidth=_allFreeView.frame.size.width/4;
        freeLabelWidth=_allFreeView.frame.size.width/2.6;
        
    }
    
    allLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, allLabelWidth, 20)];
    
    NSString * AllStr = @"ALL";
//    if([COMMON isSpanishLanguage]==YES){
//        AllStr = [COMMON getAllStr];
//        if ((NSString *)[NSNull null] == AllStr||AllStr == nil) {
//            AllStr = @"ALL";
//            AllStr =  [COMMON stringTranslatingIntoSpanish:AllStr];
//            [[NSUserDefaults standardUserDefaults] setObject:AllStr forKey:ALL];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }
    allLabel.text = AllStr;
    //[allLabel setBackgroundColor:[UIColor grayColor]];
    [allLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    //[allLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    CGRect allLabelFrame = allLabel.frame;
    CGFloat allLabelFrameMaxX = CGRectGetMaxX(allLabelFrame);
    
    int installSwitchXPos = allLabelFrameMaxX-5;//(allLabel.frame.origin.x+allLabel.frame.size.width);
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(installSwitchXPos, 0, 30, 30)];
    [freeSwitch addTarget: self action: @selector(flipAllFreeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    //[freeSwitch setOnTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [freeSwitch setOn:YES];
    // [freeSwitch setBackgroundColor:[UIColor redColor]];
    
    
    CGRect freeSwitchFrame = freeSwitch.frame;
    CGFloat freeSwitchFrameMaxX = CGRectGetMaxX(freeSwitchFrame);
    int freeLabelXPos;  //(freeSwitch.frame.origin.x+freeSwitch.frame.size.width);
    if([self isDeviceIpad]==YES){
        freeLabelXPos = freeSwitchFrameMaxX-8;
    }
    else{
         freeLabelXPos = freeSwitchFrameMaxX-5;
    }
    
    freeLabel = [[UILabel alloc]initWithFrame:CGRectMake(freeLabelXPos, 5, freeLabelWidth, 20)];
    NSString * freeLabelStr = @"Free";
//    if([COMMON isSpanishLanguage]==YES){
//        freeLabelStr = [COMMON getFreeStr];
//        if ((NSString *)[NSNull null] == freeLabelStr||freeLabelStr == nil) {
//            freeLabelStr = @"Free";
//            freeLabelStr =  [COMMON stringTranslatingIntoSpanish:freeLabelStr];
//            [[NSUserDefaults standardUserDefaults] setObject:freeLabelStr  forKey:FREE];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }
    
    freeLabel.text = [freeLabelStr uppercaseString];
   
    [freeLabel setTextColor:[UIColor whiteColor]];
    //[freeLabel setBackgroundColor:[UIColor lightGrayColor]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        allLabel.font = [COMMON getResizeableFont:Roboto_Bold(10)];
        freeLabel.font = [COMMON getResizeableFont:Roboto_Bold(10)];
        freeSwitch.transform = CGAffineTransformMakeScale(0.80,0.80);
        [allLabel setTextAlignment:NSTextAlignmentLeft];
        [freeLabel setTextAlignment:NSTextAlignmentRight];
    }
    else{
        allLabel.font = [COMMON getResizeableFont:Roboto_Bold(10)];
        freeLabel.font = [COMMON getResizeableFont:Roboto_Bold(10)];
        freeSwitch.transform = CGAffineTransformMakeScale(0.60,0.60);
        [allLabel setTextAlignment:NSTextAlignmentRight];
        [freeLabel setTextAlignment:NSTextAlignmentLeft];

    }
    UITapGestureRecognizer *tapFree=[[UITapGestureRecognizer alloc] initWithTarget:self    action:@selector(tapFreeAction:)];
    [tapFree setNumberOfTapsRequired:1];
    [freeLabel addGestureRecognizer:tapFree];
    [freeLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapAll=[[UITapGestureRecognizer alloc] initWithTarget:self    action:@selector(tapAllAction:)];
    [tapAll setNumberOfTapsRequired:1];
    [allLabel addGestureRecognizer:tapAll];
    [allLabel setUserInteractionEnabled:YES];
    [_allFreeView addSubview:allLabel];
    [_allFreeView addSubview:freeSwitch];
    [_allFreeView addSubview:freeLabel];
    
}
#pragma mark - switch flip action
- (IBAction) flipAllFreeSwitch: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    isAllFreeSwitch=YES;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    NSLog(@"currentScrollTitle-->%@",currentScrollTitle);
   
    if (onoff.on){
        //FREE
        [allLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
        [freeLabel setTextColor:[UIColor whiteColor]];
        commonPPV = PAY_MODE_FREE;
        
    }
    else {
        //ALL
        [freeLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
        [allLabel setTextColor:[UIColor whiteColor]];
        commonPPV = PAY_MODE_ALL;
    }
    
    [self loadApiAgainBasedOnSwitchSelection];
}
- (void)tapFreeAction:(id)sender {
    isAllFreeSwitch=YES;
    [allLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    [freeLabel setTextColor:[UIColor whiteColor]];
    [freeSwitch setOn:YES animated:YES];
    commonPPV = PAY_MODE_FREE;
    [self loadApiAgainBasedOnSwitchSelection];

}
- (void)tapAllAction:(id)sender {
    isAllFreeSwitch=YES;
    [freeLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    [allLabel setTextColor:[UIColor whiteColor]];
    [freeSwitch setOn:NO animated:YES];
    commonPPV = PAY_MODE_ALL;
    [self loadApiAgainBasedOnSwitchSelection];

}
#pragma mark - loadApiAgainBasedOnSwitchSelection
-(void)loadApiAgainBasedOnSwitchSelection{
    //genreName = currentScrollTitle;
    if([currentScrollTitle isEqualToString:@"Featured"]){
        if(isClickedSliderViewAll==YES){
            [COMMON LoadIcon:self.view];
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else if(isClickedCollectionSlider==YES){
            if([commonType isEqualToString:@"N"]){
                [self updateNetworkDetailData:[commonID intValue]];
            }
        }
        else{
            if(isNetworkViewAllSelection==YES){
                [self updateNetworkDetailData:[commonID intValue]];
            }
            else{
                [self getTopTitleAllData];
            }
            
        }
    }
    else if([currentScrollTitle isEqualToString:@"TV Shows"]){
        if(isClickedSliderViewAll==YES){
            [COMMON LoadIcon:self.view];
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else if(isClickedCollectionSlider==YES){
            if([commonType isEqualToString:@"N"]){
                [self updateNetworkDetailData:[commonID intValue]];
            }
        }
        else{
            [self loadForTVShows];
        }
       
    }
    else if([currentScrollTitle isEqualToString:@"Primetime"]){
        
        if(isClickedSliderViewAll==YES){
            [COMMON LoadIcon:self.view];
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else{
            if(isClickedPrimeLeftMenu==YES){
                
                [self loadPrimeCarouselData:commonWeekStr];
            }
            else{
//                NSString* primeStrID = commonID;
//                int nPrimeID = [primeStrID intValue];
//                [self loadPrimeViewAll:nPrimeID];
                [self getPrimeTimeData];
            }
        }
        
    }
    else if([currentScrollTitle isEqualToString:@"Networks"]){
         [self updateNetworkDetailData:[commonID intValue]];
       
    }
    else if([currentScrollTitle isEqualToString:@"Movies"]){
        if(isClickedSliderViewAll==YES){
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else{
            [self loadForMovies];
        }
        
    }
    else if([currentScrollTitle isEqualToString:@"Web Originals"]){
        if(isClickedSliderViewAll==YES){
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else{
            [self getWebCarouselsData];
        }
        
    }
    else if([currentScrollTitle isEqualToString:@"Kids"]){
        if(isClickedSliderViewAll==YES){
            [self loadSliderViewAllAPIWithCarouselID:commonID nPPv:commonPPV];
        }
        else{
            [self getKidsCarouselsData];
        }
        
    }
}
#pragma mark - loadForTVShows
-(void)loadForTVShows{
    if(isOnTvShowClick==true){
        if([genreName isEqualToString:@"TV Shows"]){
            [self getTvShowTitleData];
            
        }
        else if([genreName isEqualToString:@"by Network"]){
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            [self updateNetworkDetailData:[commonID intValue]];
        }
        
        else if([genreName isEqualToString:@"by Category"]){
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            [self loadOnDemandCategoryCarouselsByID:[commonID intValue]];
            
        }
        else if([genreName isEqualToString:@"by Genre"]){
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            [self updateShowData:[commonID intValue]];
            
        }
        else if([genreName isEqualToString:@"by Decade"]){
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            [self loadOnDemandDecadeByID:[commonID intValue]];
        }
        
    }
    else if(isOnNetworksClick==true){
        
        [self updateNetworkDetailData:[commonID intValue]];
    }
    else if(isOnGenreClick==true){
        
        [self updateShowData:[commonID intValue]];
        
    }
    else if(isOnCategoryClick==true){
        
        [self loadOnDemandCategoryCarouselsByID:[commonID intValue]];
        
    }
    else if(isOnDecadeClick==true){
        
        [self loadOnDemandDecadeByID:[commonID intValue]];
    }
    else{
        //[self updateData:[commonID intValue] status:8];
        [self getTvShowTitleData];
    }

}
#pragma mark - loadForMovies
-(void)loadForMovies{
    if(isOnMoivesClick==true){
        if([genreName isEqualToString:@"Movies"]){
            [self getMoviesData];
        }
        else if([genreName isEqualToString:@"by Genre"]){
            [self updateData:[commonID intValue] status:8];
            
        }
        else if([genreName isEqualToString:@"by Rating"]){
            [self loadMoviesRatingData:commonSlug];
            
        }
    }
    else if(isOnMoivesGenreClick==true){
        
        [self updateData:[commonID intValue] status:8];
        
    }
    else if(isOnMoivesRatingClick==true){
        [self loadMoviesRatingData:commonSlug];
    }
    else{
        [self getMoviesData];
    }

}
#pragma mark - SCROLL HEADER
-(void)setScrollHeader {
    
    [self  getOnDemandTopMenuList];
   
    CGFloat commonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    
    int size = (_tvMovieView.frame.size.height);
    NSLog(@"SIZE %d--->",size);

    
    //titleArray =[[NSMutableArray alloc] initWithObjects:@"TV SHOWS", @"MOVIES",@"PRIME TIME",@"WEB ORIGINALS",@"KIDS", nil];//@"SPORTS", nil];
    
    
    _headerScroll = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, commonWidth, _tvMovieView.frame.size.height)];
        [_tvMovieView addSubview:_headerScroll];
    
    [_headerScroll setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];

     _headerScroll.sectionTitles = titleArray;
    _headerScroll.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _headerScroll.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    _headerScroll.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _headerScroll.selectionIndicatorColor = [UIColor whiteColor];

    [_headerScroll addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _headerScroll.selectedSegmentIndex = visibleSection;

    [_headerScroll setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString;

        if (selected) {
            
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        } else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        }
    }];
    
    [self performSelector:@selector(loadSegmentPosition) withObject:self afterDelay:0.5];
    
    
    
//    [_headerScroll setIndexChangeBlock:^(NSInteger index) {
//       
//        NSLog(@"setIndexChangeBlock %ld ", index);
//
//    }];
}
-(void)loadSegmentPosition{
    [_headerScroll setSelectedSegmentIndex:visibleSection animated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender {
     [self removeSearchView];
    [arrayItems removeAllObjects];
    [[RabbitTVManager sharedManager]cancelRequest];
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    visibleSection = sender.selectedSegmentIndex;
    
    NSInteger currentCount = [topTitleArray count];
    
    if(visibleSection<currentCount){
        NSMutableDictionary *dictItem = [topTitleArray objectAtIndex:visibleSection];
        
        NSString *currentTitle =dictItem[@"page"];
        currentScrollTitle =dictItem[@"name"];
        
        // NSMutableArray * onDemandTopArray = [NSMutableArray arrayWithObjects:@"Featured",@"TV Shows",@"Prime Time",@"Networks",@"Movies",@"Web Originals",@"Kids",@"International",nil];
        
        if([currentTitle isEqualToString:@"all"]){
            genreName = @"Featured";
            currentTopTitle = genreName;
            [self getTopTitleAllData];
        }
        else if([currentTitle isEqualToString:@"tv-shows"]){
            genreName = @"TV Shows";
            currentTopTitle = genreName;
            isMovieType=NO;
            [self getTvShowTitleData];
        }
        else if([currentTitle isEqualToString:@"primetime"]){
            genreName = @"Prime Time";
            currentTopTitle = genreName;
            [self getPrimeTimeData];
        }
        else if([currentTitle isEqualToString:@"tv-networks"]){
            genreName = @"Networks";
            currentTopTitle = genreName;
            [self getNetworkData];
        }
        else if([currentTitle isEqualToString:@"movies"]){
            genreName = @"Movies";
            currentTopTitle = genreName;
            [self getMoviesData];
        }
        else if([currentTitle isEqualToString:@"web-originals"]){
            genreName = @"Web Originals";
            currentTopTitle = genreName;
            [self getWebCarouselsData];
        }
        else if([currentTitle isEqualToString:@"kids"]){
            genreName = @"Kids";
            currentTopTitle = genreName;
            [self getKidsCarouselsData];
        }
        else if([currentTitle isEqualToString:@"International"]){
            genreName = @"International";
            currentTopTitle = genreName;
            //[self getWebCarouselsData];
        }
        NSLog(@"Selected dictItem %@",dictItem);
    }
    
}
#pragma mark - getTopTitleAllData
-(void)getTopTitleAllData{
    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    isClickedTv=NO;
    isClickedMovie=NO;
    isClickedPrime=NO;
    isClickedWebOriginal=NO;
    isClickedKids = NO;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    if(isVideoClosed==NO)
        [self getOnDemandFirstCarousels];
}
#pragma mark - getTopTitleAllData
-(void)getTvShowTitleData{
    [_tvListLabel setHidden:NO];
    [tvShowLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    NSString *strTvShows = @"TV Shows";
    
    if([COMMON isSpanishLanguage]==YES){
        strTvShows = [COMMON getTvShowsStr];
        if ((NSString *)[NSNull null] == strTvShows||strTvShows == nil) {
            strTvShows = @"TV Shows";
            strTvShows =  [COMMON stringTranslatingIntoSpanish:strTvShows];
            [[NSUserDefaults standardUserDefaults] setObject:strTvShows  forKey:TV_SHOWS];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
    
    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strTvShows attributes:attrRoboFontDict];
    [roboAttrString appendAttributedString:aweAttrString];
    _tvListLabel.attributedText = roboAttrString;

    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    isClickedTv=YES;
    isClickedMovie=NO;
    isClickedPrime=NO;
    isClickedWebOriginal=NO;
    isClickedKids = NO;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [self loadTVShowData];
}
-(void)getPrimeTimeData{
    [_tvListLabel setHidden:NO];
    [tvShowLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    
    isMovieListData=NO;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    NSString* weekDayStr = [self extractDayFromDate];
    NSString* weekDayLowerStr;
    
    NSString *currentWeek;
    int currentIndex;
    if([COMMON isSpanishLanguage]==YES){
        int i=0;
        for(i=0;i<=[dropdownSpainshPrimeWeekdayArray count];i++){
            NSString * currentWeekStr = dropdownSpainshPrimeWeekdayArray[i];
                if([currentWeekStr isEqualToString:weekDayStr])
                {
                    currentIndex=i;
                    break;
                }
        }
        currentWeek = primeWeekDayArray[i];
        weekDayLowerStr = [currentWeek substringToIndex:3];
        
    }
    else{
        weekDayLowerStr = [weekDayStr substringToIndex:3];
    }
    
    if ((NSString *)[NSNull null] == weekDayStr||weekDayStr == nil) {
        weekDayStr = @"";
    }
    if ((NSString *)[NSNull null] == weekDayLowerStr||weekDayLowerStr == nil) {
        weekDayLowerStr = @"";
    }
    
    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:weekDayStr attributes:attrRoboFontDict];
    [roboAttrString appendAttributedString:aweAttrString];
    _tvListLabel.attributedText = roboAttrString;
    
    isClickedTv=NO;
    isClickedMovie=NO;
    isClickedPrime=YES;
    isClickedWebOriginal=NO;
    isClickedKids = NO;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [self loadPrimeCarouselData:[weekDayLowerStr lowercaseString]];
}
-(void)getNetworkData{
    
    [tvShowLabel setHidden:NO];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:NO];//loading view and table in on demand view
    for(UIView *view in onDemandSliderView.subviews){
        [view removeFromSuperview];
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }

    [_tableView setHidden:NO];
    isMovieListData=NO;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    isClickedTv=NO;
    isClickedMovie=NO;
    isClickedPrime=NO;
    isClickedWebOriginal=NO;
    isClickedKids = NO;
    isClickedNetwork=YES;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    
//    NSDictionary *dictItem = dropDownTvNetworkArray[0];
//    NSString *networkStr = dictItem[@"name"];
//    genreName = networkStr;
//    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:networkStr attributes:attrRoboFontDict];
//    [roboAttrString appendAttributedString:aweAttrString];
//    tvShowLabel.attributedText = roboAttrString;
//    NSString * strID = dictItem[@"id"];
//    currentNetworkID = strID;
//    commonID = strID;
//    [self updateNetworkDetailData:[strID intValue]];
   
    [sliderImageArray removeAllObjects];
    [topTitleCarouselArray removeAllObjects];
    for(UIView *view in onDemandSliderView.subviews){
        [view removeFromSuperview];
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }
    
    //NEW CHANGE RAJI
    [self loadAllNewtorksList];
}
-(void)loadAllNewtorksList{
    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [sliderImageArray removeAllObjects];
    [topTitleCarouselArray removeAllObjects];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:NO];
    isCarouselImage=NO;
    isPosterImage=NO;
    isThumbnailImage=YES;
    isMovieListData=YES;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    nCategory = CATEGORY_NETWORK;
    isMovieType=NO;
    arrayItems = [dropDownTvNetworkArray mutableCopy];
    [self.tableView reloadData];
    [_tableView setHidden:NO];
   

}

-(void)loadNetworkImageAndDetails{
    
   // [self getNetworkDetailWithNewtorkID:[currentNetworkID intValue]];
    
    [sliderImageArray removeAllObjects];
    [topTitleCarouselArray removeAllObjects];
    //[arrayItems removeAllObjects];
    for(UIView *view in onDemandSliderView.subviews){
        [view removeFromSuperview];
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }
    if([currentNetworkDict count]!=0){
        [self getUpImageLabelsForNetworkMenu];
    }
    
    //CGFloat commonOnDemandHeight = onDemandSliderView.frame.size.height;
    //[networkView setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];//_tvMovieView.frame.size.height+tvShowLabel.frame.size.height+2
    // [networkView setBackgroundColor:[UIColor clearColor]];
  
    
}
-(void)getNetworkDetailWithNewtorkID:(int)networkID{
    //[COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    [[RabbitTVManager sharedManager]getNetworkDetails:^(AFHTTPRequestOperation *request, id responseObject) {
        //NEW CHANGE RAJI
        if(isClickedNetwork ==YES||[currentScrollTitle isEqualToString:@"Featured"]){
            if(isClickedCollectionSlider==NO){
                isClickedNetworkBackOptions=YES;
                [tvShowLabel setHidden:NO];
                NSString *strBackArrow = [NSString stringWithFormat:@"%@ BACK", @" \uf177"];
                aweBackArrowAttrString = [[NSMutableAttributedString alloc] initWithString:strBackArrow attributes:attrAweSomeDict];
                tvShowLabel.attributedText = aweBackArrowAttrString;
            }            
        }
        currentNetworkDict =[NSMutableDictionary new];
        currentNetworkDict = [responseObject mutableCopy];
        [onDemandSliderView setHidden:NO];
        [self getUpImageLabelsForNetworkMenu];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
    
        [onDemandSliderView setHidden:YES];
        [_tableView setHidden:NO];
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    } nID:networkID];
}

-(void)getUpImageLabelsForNetworkMenu{
    
    for(UIView *view in onDemandSliderView.subviews){
        [view removeFromSuperview];
    }
    
    for(UIView *view in fullSlideScrollView.subviews){
        
        [view removeFromSuperview];
    }
    
    for(UIView *view in networkView.subviews){
       
        [view removeFromSuperview];
    }
    
    networkView = [UIView new];
    
    CGFloat networkImageYPos;
    CGFloat networkImageWidth;
    CGFloat networkImageHeightValue = 0.0f;
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        networkImageYPos = 20;
        networkImageWidth = SCREEN_WIDTH/4;
        networkImageHeightValue=  SCREEN_HEIGHT/1.5;
    }
    else{
        networkImageYPos = 60;
        networkImageWidth = SCREEN_WIDTH/3;
        if([self isDeviceIpad]==YES){
            networkImageHeightValue=  SCREEN_HEIGHT/2;
        }
        else{
            networkImageHeightValue= SCREEN_HEIGHT/2.2;
  
        }
    }
    
     NSString *imageUrl = [currentNetworkDict valueForKey:@"image"];
    
    //INITIAL
    UIImageView *networkImage;
    UILabel *overViewLabel,*overViewData,*sloganLabel, *sloganData,*HeadQuartersLabel,*HeadQuartersData, *launchDateLabel,*launchDateData;
    
    
    
    CGFloat networkImageHeight = networkImageHeightValue-(networkImageYPos);
    networkImage = [UIImageView new];
    [networkImage setFrame:CGRectMake(20,10, networkImageWidth, networkImageHeight)];
    //[networkImage setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f]];
    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, networkImage.frame.size.width, networkImage.frame.size.height-20)];
    [asyncImage setLoadingImage];
    [asyncImage loadImageFromURL:[NSURL URLWithString:imageUrl]
                                type:AsyncImageResizeTypeRatio
                             isCache:YES];
    [networkImage addSubview:asyncImage];
    //[networkImage setImageWithURL:[NSURL URLWithString:imageUrl]];
   
    //Overview
    NSString *overViewLabelStr = @"Overview :";
    CGSize overViewLabelSize = [overViewLabelStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(20)] }];
    CGFloat overViewLabelXPos = networkImage.frame.origin.x+networkImage.frame.size.width+5;
    CGFloat overViewLabelWidth = overViewLabelSize.width+10; //networkImageWidth;
    overViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(overViewLabelXPos, 10, overViewLabelWidth, 30)];
    [overViewLabel setText:overViewLabelStr];
    [overViewLabel setTextColor:[UIColor whiteColor]];
    [overViewLabel setBackgroundColor:[UIColor clearColor]];
    if([self isDeviceIpad]==YES){
        [overViewLabel setFont:[COMMON getResizeableFont:Roboto_Regular(20)]];
    }
    else{
        [overViewLabel setFont:[COMMON getResizeableFont:Roboto_Regular(18)]];
    }
    [overViewLabel setTextAlignment:NSTextAlignmentLeft];
    
    //overViewData Label
    
    NSString *overViewDataStr = [currentNetworkDict valueForKey:@"description"];;
   // CGSize overViewDataSize = [overViewDataStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(15)] }];
    CGRect networkImageFrame = networkImage.frame;
    CGFloat networkImageMaxX = CGRectGetMaxX(networkImageFrame);
    CGRect overViewLabelFrame = overViewLabel.frame;
    CGFloat overViewLabelMaxY = CGRectGetMaxY(overViewLabelFrame);
    CGFloat overViewDataXPos = networkImage.frame.origin.x+networkImage.frame.size.width+5;
    CGFloat overViewDataYPos = overViewLabelMaxY+2;
    CGFloat overViewDataWidth =(SCREEN_WIDTH) - (networkImageMaxX);
    CGFloat overViewDataHeight=0.0f;
    
    overViewDataHeight =(SCREEN_HEIGHT/2.5)-10;//networkImageWidth;
    overViewData = [[UILabel alloc] initWithFrame:CGRectMake(overViewDataXPos, overViewDataYPos, overViewDataWidth-10, overViewDataHeight)];
    overViewData.numberOfLines=0;
    [overViewData setTextColor:[UIColor whiteColor]];
    [overViewData setBackgroundColor:[UIColor clearColor]];
    [overViewData setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [overViewData setTextAlignment:NSTextAlignmentLeft];
    
    CGRect overViewRect = [overViewDataStr boundingRectWithSize:CGSizeMake(overViewDataWidth-10, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: overViewData.font}
                                                         context:nil];
    NSLog(@"overViewRect-->%f",overViewRect.size.height);
    
    CGRect overViewDataFrame = overViewData.frame;
    overViewDataFrame.size.height = overViewRect.size.height;//networkView.frame.size.height+dataSize.height;
    [overViewData setFrame:overViewDataFrame];
    [overViewData setText:overViewDataStr];
    
    //Slogan
    CGFloat sloganLabelXPos = networkImage.frame.origin.x+networkImage.frame.size.width+5;
    CGFloat sloganLabelYPos =  overViewData.frame.origin.y+overViewData.frame.size.height+2;//(networkView.frame.size.height/2)+overViewLabel.frame.size.height;//overViewLabel.frame.origin.y+overViewLabel.frame.size.height;
    int commonNetworkFontSize = 0;
     if([self isDeviceIpad]==YES){
         commonNetworkFontSize = 15;
     }
     else{
         commonNetworkFontSize = 11;
     }
    NSString *sloganLabelStr = @"Slogan:";
    CGSize sloganLabelStrSize = [sloganLabelStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)] }];
    
    CGFloat sloganLabelWidth = sloganLabelStrSize.width+10;//networkImageWidth;// - (networkImage.frame.size.width);
    sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(sloganLabelXPos, sloganLabelYPos, sloganLabelWidth, 30)];
    [sloganLabel setText:sloganLabelStr];
    sloganLabel.numberOfLines=0;
    [sloganLabel setTextColor:[UIColor whiteColor]];
    [sloganLabel setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    [sloganLabel setTextAlignment:NSTextAlignmentLeft];
    [sloganLabel setBackgroundColor:[UIColor clearColor]];

    // sloganData
    NSString *sloganDataText = [currentNetworkDict valueForKey:@"slogan"];
    CGRect sloganLabelFrame = sloganLabel.frame;
    CGFloat sloganLabelMaxX = CGRectGetMaxX(sloganLabelFrame);
    CGFloat sloganDataXPos = sloganLabel.frame.origin.x+sloganLabel.frame.size.width;
    CGFloat sloganDataYPos = overViewData.frame.origin.y+overViewData.frame.size.height;
   // CGFloat sloganDataYPos = (networkView.frame.size.height/2)+overViewLabel.frame.size.height;
    CGFloat sloganDataWidth = SCREEN_WIDTH - (sloganLabelMaxX);//(networkView.frame.size.width) - (sloganLabelMaxX);
    sloganData = [[UILabel alloc] initWithFrame:CGRectMake(sloganDataXPos, sloganDataYPos, sloganDataWidth-10, 30)];
    [sloganData setText:sloganDataText];
    sloganData.numberOfLines=0;
    [sloganData setTextColor:[UIColor whiteColor]];
    [sloganData setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    [sloganData setTextAlignment:NSTextAlignmentLeft];
  
    //Headquarters
    CGFloat HeadQuartersLabelXPos = networkImage.frame.origin.x+networkImage.frame.size.width+5;
    CGFloat HeadQuartersLabelYPos = sloganData.frame.origin.y+sloganData.frame.size.height+5;
    NSString *HeadQuartersLabelStr = @"Headquarters:";
    CGSize HeadQuartersLabelSize = [HeadQuartersLabelStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)] }];
    CGFloat HeadQuartersLabelWidth = HeadQuartersLabelSize.width+5;//networkImageWidth;
    HeadQuartersLabel = [[UILabel alloc] initWithFrame:CGRectMake(HeadQuartersLabelXPos, HeadQuartersLabelYPos, HeadQuartersLabelWidth, 40)];
    [HeadQuartersLabel setText:HeadQuartersLabelStr];
    [HeadQuartersLabel setTextColor:[UIColor whiteColor]];
    [HeadQuartersLabel setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    HeadQuartersLabel.numberOfLines=0;
    [HeadQuartersLabel setTextAlignment:NSTextAlignmentLeft];
  
    // HeadQuartersData
    NSString *headquartersDataText = [currentNetworkDict valueForKey:@"headquarters"];
    CGRect HeadQuartersLabelFrame = HeadQuartersLabel.frame;
    CGFloat HeadQuartersLabelMaxX = CGRectGetMaxX(HeadQuartersLabelFrame);
    CGFloat HeadQuartersDataXPos = HeadQuartersLabel.frame.origin.x+HeadQuartersLabel.frame.size.width;
    CGFloat HeadQuartersDataYPos = HeadQuartersLabel.frame.origin.y;
    CGFloat HeadQuartersDataWidth = (SCREEN_WIDTH)-(HeadQuartersLabelMaxX);//(networkView.frame.size.width)-(HeadQuartersLabelMaxX);
    
    HeadQuartersData  = [[UILabel alloc] initWithFrame:CGRectMake(HeadQuartersDataXPos, HeadQuartersDataYPos, HeadQuartersDataWidth-10, 40)];
    [HeadQuartersData setText:headquartersDataText];
    [HeadQuartersData setTextColor:[UIColor whiteColor]];
    HeadQuartersData.numberOfLines=0;
    [HeadQuartersData setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    [HeadQuartersData setTextAlignment:NSTextAlignmentLeft];
    
    //Launch Date:
    CGFloat launchDateLabelXPos = networkImage.frame.origin.x+networkImage.frame.size.width+5;
    CGFloat launchDateLabelYPos = HeadQuartersLabel.frame.origin.y+HeadQuartersLabel.frame.size.height+8;
    NSString *launchDateLabelStr = @"Launch Date:";
    CGSize launchDateLabelSize = [HeadQuartersLabelStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)] }];
    CGFloat launchDateLabelWidth = launchDateLabelSize.width+5;//networkImageWidth// - (networkImage.frame.size.width);
    launchDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(launchDateLabelXPos, launchDateLabelYPos, launchDateLabelWidth, 25)];
    [launchDateLabel setText:launchDateLabelStr];
    [launchDateLabel setTextColor:[UIColor whiteColor]];
    [launchDateLabel setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    [launchDateLabel setTextAlignment:NSTextAlignmentLeft];
    
    // launchDateData
    NSString *launchDataText = [currentNetworkDict valueForKey:@"start_time"];
    CGRect launchDateLabelFrame = launchDateLabel.frame;
    CGFloat launchDateLabelMaxX = CGRectGetMaxX(launchDateLabelFrame);
    CGFloat launchDateDataXPos = launchDateLabel.frame.origin.x+launchDateLabel.frame.size.width;
    CGFloat launchDateDataYPos = launchDateLabel.frame.origin.y;
    CGFloat launchDateDataWidth = SCREEN_WIDTH-(launchDateLabelMaxX);//networkView.frame.size.width-(launchDateDataMaxX);
    launchDateData = [[UILabel alloc] initWithFrame:CGRectMake(launchDateDataXPos, launchDateDataYPos, launchDateDataWidth-10, 25)];
    [launchDateData setText:launchDataText];
    [launchDateData setTextColor:[UIColor whiteColor]];
    
    [launchDateData setFont:[COMMON getResizeableFont:Roboto_Regular(commonNetworkFontSize)]];
    [launchDateData setTextAlignment:NSTextAlignmentLeft];
    
    CGRect launchDateDataFrame = launchDateData.frame;
    CGFloat launchDateDataMaxY = CGRectGetMaxY(launchDateDataFrame);
    
    CGRect networkViewDataFrame = networkView.frame;
    networkViewDataFrame.origin.x=0;
    networkViewDataFrame.origin.y=0;
    networkViewDataFrame.size.width = SCREEN_WIDTH;
    networkViewDataFrame.size.height = launchDateDataMaxY+10;//networkView.frame.size.height+dataSize.height;
    [networkView setFrame:networkViewDataFrame];
    
    //[networkView setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    
    [networkView addSubview:networkImage];
    [networkView addSubview:overViewLabel];
    [networkView addSubview:overViewData];
    [networkView addSubview:sloganLabel];
    [networkView addSubview:sloganData];
    [networkView addSubview:HeadQuartersLabel];
    [networkView addSubview:HeadQuartersData];
    [networkView addSubview:launchDateLabel];
    [networkView addSubview:launchDateData];
   
    [networkView setHidden:NO];
    
    [networkView setBackgroundColor:[UIColor clearColor]];
    
    [self setNetworksScrollAndTableHeight];
    
}
#pragma mark - setNetworksScrollAndTableHeight
-(void)setNetworksScrollAndTableHeight{
    [self setNetworkTableViewFrame];
    
//    CGFloat networkCellHeight;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        networkCellHeight= 0;
//    }
//    else{
//        UIDevice* device = [UIDevice currentDevice];
//        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
//            networkCellHeight= 50;
//        }
//        else{
//            networkCellHeight= 160;
//        }
//        
//    }
//    [fullSlideScrollView setContentSize:CGSizeMake(0,(networkView.frame.size.height+networkTableView.frame.size.height+networkCellHeight))];
//    [networkTableView reloadData];
    
    //[networkTableView reloadData];
    //[fullSlideScrollView setContentSize:CGSizeMake(0,(networkView.frame.size.height+networkTableView.contentSize.height+networkCellHeight))];
}

-(void)setNetworkTableViewFrame
{
    CGRect networkViewFrame = networkView.frame;
    CGFloat networkViewFrameY = CGRectGetMaxY(networkViewFrame);
    
    //networkTableView
    CGFloat networkTableYPos = networkViewFrameY+50;//networkView.frame.size.height;
    
    NSInteger cellCount = arrayItems.count;
    NSInteger oddCount=0;
    if (cellCount % 2){
        //odd
        oddCount =1;
    }
    else{
        //even
        if(cellCount<nColumCount){
            oddCount =1;
        }
    }
    
    NSInteger networkTableHeight = 0;
    networkTableHeight = (arrayItems.count/nColumCount);
    
    
   // CGRect networkTableFrame = networkTableView.frame;
    CGFloat networkCellHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        networkCellHeight= 155;
    }
    else{
        networkCellHeight= 140;
    }
    
    if(nColumCount==2||nColumCount==4){
        networkTableHeight =networkTableHeight+oddCount;
    }
    else if(nColumCount==3||nColumCount==5){
        networkTableHeight = networkTableHeight+oddCount;
    }
    
    //networkTableFrame.size.height = (networkTableHeight*networkCellHeight)+networkCellHeight;
   // [networkTableView setFrame:networkTableFrame];

    networkTableView = [[UIGridView alloc] initWithFrame:CGRectMake(0,networkTableYPos,SCREEN_WIDTH,(networkTableHeight*networkCellHeight)+0)];
    networkTableView.uiGridViewDelegate = self;
    networkTableView.bounces = NO;
    networkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    networkTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [networkTableView setBackgroundColor:[UIColor clearColor]];
    
    
    fullSlideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fullSlideScrollView.delegate=self;
    fullSlideScrollView.scrollEnabled=YES;
    networkTableView.scrollEnabled=NO;
    [fullSlideScrollView addSubview:networkView];
    [fullSlideScrollView addSubview:networkTableView];
    [onDemandSliderView addSubview:fullSlideScrollView];
    
    CGRect networkTableViewFrame = networkTableView.frame;
    CGFloat networkTableViewFrameY = CGRectGetMaxY(networkTableViewFrame);
    
   // CGFloat networkCellHeight;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        networkCellHeight= 0;
//    }
//    else{
//        UIDevice* device = [UIDevice currentDevice];
//        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
//            networkCellHeight= 50;
//        }
//        else{
//            networkCellHeight= 160;
//        }
//
//    }
    
    [fullSlideScrollView setContentSize:CGSizeMake(0,(networkTableViewFrameY+networkCellHeight))];

    
    //[fullSlideScrollView setContentSize:CGSizeMake(0,(networkView.frame.size.height+networkTableView.frame.size.height+networkCellHeight))];
    [networkTableView reloadData];

   
}


-(void)getMoviesData{
   
    [_tvListLabel setHidden:NO];
    [tvShowLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    
    nCategory = CATEGORY_MOVIES;
    mainCategory = CATEGORY_MOVIES;
    
    NSString * moviesStr = @"Movies";
    if([COMMON isSpanishLanguage]==YES){
        moviesStr = [COMMON getMoviesStr];
        if ((NSString *)[NSNull null] == moviesStr||moviesStr == nil) {
             moviesStr = @"Movies";
            moviesStr =  [COMMON stringTranslatingIntoSpanish:moviesStr];
            [[NSUserDefaults standardUserDefaults] setObject:moviesStr  forKey:MOVIES];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:moviesStr attributes:attrRoboFontDict];
    [roboAttrString appendAttributedString:aweAttrString];
    _tvListLabel.attributedText = roboAttrString;
    
    isMovieListData=NO;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    isClickedTv=NO;
    isClickedMovie=YES;
    isClickedPrime=NO;
    isClickedWebOriginal=NO;
    isClickedKids = NO;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [self loadMoviesData];
}

-(void)getWebCarouselsData{
    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    
    isMovieListData=NO;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    isClickedTv=NO;
    isClickedMovie=YES;
    isClickedPrime=NO;
    isClickedWebOriginal=YES;
    isClickedKids = NO;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [self loadOnDemandWebOriginalData];
}
-(void)getKidsCarouselsData{
    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    
    isMovieListData=NO;
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    isClickedTv=NO;
    isClickedMovie=YES;
    isClickedPrime=NO;
    isClickedWebOriginal=NO;
    isClickedKids = YES;
    isClickedNetwork=NO;
    isClickedSliderViewAll=NO;
    isClickedCollectionSlider=NO;
    [self loadOnDemandKidsData];
}
#pragma mark - loadSliderCarouselScreen
-(void)loadSliderCarouselScreen{
    [tvShowLabel setHidden:YES];
    [_tvListLabel setHidden:YES];
    [_tvNetworkListLabel setHidden:YES];
    commonPPV = PAY_MODE_FREE;
    currentScrollTitle = @"Featured";
    currentTopTitle = @"Featured";
    
    [COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [onDemandSliderView setHidden:YES];
    [_appDownloadTableView setHidden:YES];
    [_tableView setHidden:YES];
    [onDemandSliderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]]];
    if([COMMON isSpanishLanguage]==YES){
        [self getOnDemandSpanishGenreForMovies];
        [self getOnDemandSpanishGenreForTVShows];
    }
    [self getOnDemandTopMenuList];
    [self getOnDemandFirstCarousels];
    [self getOnDemandCategoryMenuList];
    [self getOnDemandMoviesRatingMenuList];
    [self getOnDemandDecadeMenuList];
}
#pragma mark - getOnDemandTopMenuList
-(void)getOnDemandTopMenuList{
    
    topTitleArray = [NSMutableArray new];
    topTitleArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_TOP_MENU dataType:DataTypeArray] mutableCopy];
    [self removalOfExtraArray];
    if ([topTitleArray count] == 0) {
        [[RabbitTVManager sharedManager] getOnDemandTopMenu:^(AFHTTPRequestOperation *request, id responseObject){
            topTitleArray = [NSMutableArray new];
            topTitleArray = [responseObject mutableCopy];
            [self removalOfExtraArray];
            titleArray = [topTitleArray  valueForKey:@"name"];
            [COMMON removeLoading];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [COMMON removeLoading];
        } ];
    }
    else{
         titleArray = [topTitleArray  valueForKey:@"name"];
    }
    
    if([COMMON isSpanishLanguage]==YES){
        NSMutableArray *tempArray = [NSMutableArray new];
        tempArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_TOP_MENU_WORDS dataType:DataTypeArray] mutableCopy];
        
        if ([tempArray count] == 0) {
            [self getStaticTranslatedWordList:ON_DEMAND_TOP_MENU_WORDS currentStaticArray:(NSMutableArray*)titleArray];
            tempArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_TOP_MENU_WORDS dataType:DataTypeArray] mutableCopy];
            titleArray =tempArray;
        }
        else{
            titleArray =tempArray;
        }

    }

}

#pragma mark - removalOfExtraArray
-(void)removalOfExtraArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [topTitleArray mutableCopy] ;
    for (int i=0;i<[tempArray count];i++) {
        NSString *string = [[[[tempArray mutableCopy] valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string isEqualToString:@"World"]){
            [topTitleArray removeObjectAtIndex:i];
        }
    }
}
#pragma mark - getOnDemandCategoryMenuList
-(void)getOnDemandCategoryMenuList{
    [[RabbitTVManager sharedManager]getOnDemandTvShowsCategory:^(AFHTTPRequestOperation *request, id responseObject) {
        onDemandTvShowsCategory =[NSMutableArray new];
        onDemandTvShowsCategory = [responseObject mutableCopy];
        isCategorySpanish=YES;
        isDecadeSpanish=NO;
        isRatingSpanish=NO;
        isTVMovieGenreSpanish=NO;
        if([COMMON isSpanishLanguage]==YES){
            NSMutableArray *tempArray = [NSMutableArray new];
            tempArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_CATEGORY_WORDS dataType:DataTypeArray] mutableCopy];
            if ([tempArray count] == 0) {
                [self getTranslationArrayOfOnDemand:ON_DEMAND_CATEGORY_WORDS currentStaticArray:onDemandTvShowsDecades];
                onDemandTvShowsCategory = [[COMMON retrieveContentsFromFile:ON_DEMAND_CATEGORY_WORDS dataType:DataTypeArray] mutableCopy];
            }
            else{
                onDemandTvShowsCategory = tempArray;
            }
        }
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
        
    }];
}
#pragma mark - getOnDemandMoviesRatingMenuList
-(void)getOnDemandMoviesRatingMenuList{
    [[RabbitTVManager sharedManager]getOnDemandMoviesRating:^(AFHTTPRequestOperation *request, id responseObject) {
        onDemandMoviesRating =[NSMutableArray new];
        onDemandMoviesRating = [responseObject mutableCopy];
        isCategorySpanish=NO;
        isDecadeSpanish=NO;
        isRatingSpanish=YES;
        isTVMovieGenreSpanish=NO;
        if([COMMON isSpanishLanguage]==YES){
            NSMutableArray *tempArray = [NSMutableArray new];
            tempArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_RATING_WORDS dataType:DataTypeArray] mutableCopy];
            if ([tempArray count] == 0) {
                [self getTranslationArrayOfOnDemand:ON_DEMAND_RATING_WORDS currentStaticArray:onDemandTvShowsDecades];
                onDemandMoviesRating = [[COMMON retrieveContentsFromFile:ON_DEMAND_RATING_WORDS dataType:DataTypeArray] mutableCopy];
            }
            else{
                onDemandMoviesRating = tempArray;
            }
        }
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
    }];
}


#pragma mark - getOnDemandDecadeMenuList
-(void)getOnDemandDecadeMenuList{
    [[RabbitTVManager sharedManager]getOnDemandTvShowsDecades:^(AFHTTPRequestOperation *request, id responseObject) {
        onDemandTvShowsDecades =[NSMutableArray new];
        onDemandTvShowsDecades = [responseObject mutableCopy];
        isCategorySpanish=NO;
        isDecadeSpanish=YES;
        isRatingSpanish=NO;
        isTVMovieGenreSpanish=NO;
        if([COMMON isSpanishLanguage]==YES){
            NSMutableArray *tempArray = [NSMutableArray new];
            tempArray = [[COMMON retrieveContentsFromFile:ON_DEMAND_DECADE_WORDS dataType:DataTypeArray] mutableCopy];
            if ([tempArray count] == 0) {
                [self getTranslationArrayOfOnDemand:ON_DEMAND_DECADE_WORDS currentStaticArray:onDemandTvShowsDecades];
                onDemandTvShowsDecades = [[COMMON retrieveContentsFromFile:ON_DEMAND_DECADE_WORDS dataType:DataTypeArray] mutableCopy];
            }
            else{
                onDemandTvShowsDecades = tempArray;
            }
        }
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
    }];
}
-(void)getOnDemandSpanishGenreForMovies{
    
    //NSLog(@"dropDownNSArray-->%@",dropDownNSArray);
    isTVMovieGenreSpanish=YES;
    isCategorySpanish=NO;
    isDecadeSpanish=NO;
    isRatingSpanish=NO;
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
-(void)getOnDemandSpanishGenreForTVShows{
    
    isTVMovieGenreSpanish=YES;
    isCategorySpanish=NO;
    isDecadeSpanish=NO;
    isRatingSpanish=NO;
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_TV_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
    
    if ([tempArray count] == 0) {
       [self getTranslationArrayOfOnDemand:COMMON_SPANISH_TV_GENRE_WORDS currentStaticArray:dropDownTvShowArray];
        
        tempArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_TV_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
        dropDownTvShowArray =tempArray;
    }
    else{
        dropDownTvShowArray =tempArray;
    }

}

-(void)getTranslationArrayOfOnDemand:(NSString *)currentPage currentStaticArray:(NSMutableArray*)commonStaticArray{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString * currentEnglishText;
    NSString *translatedText;
    
    NSString *valueStr=@"name";
    if(isTVMovieGenreSpanish==YES){
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
    
    onDemandTvShowsCategory = [[COMMON retrieveContentsFromFile:ON_DEMAND_CATEGORY_WORDS dataType:DataTypeArray] mutableCopy];
    onDemandMoviesRating = [[COMMON retrieveContentsFromFile:ON_DEMAND_RATING_WORDS dataType:DataTypeArray] mutableCopy];
    onDemandTvShowsDecades = [[COMMON retrieveContentsFromFile:ON_DEMAND_DECADE_WORDS dataType:DataTypeArray] mutableCopy];
    dropDownTvShowArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_TV_GENRE_WORDS dataType:DataTypeArray] mutableCopy];
    dropDownNSArray = [[COMMON retrieveContentsFromFile:COMMON_SPANISH_MOVIE_GENRE_WORDS dataType:DataTypeArray] mutableCopy];

}

#pragma mark - getOnDemandFirstCarousels
-(void)getOnDemandFirstCarousels{
     genreName =@"Featured";
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager] getOnDemandCarousels:^(AFHTTPRequestOperation *request, id responseObject){
        [COMMON LoadIcon:self.view];
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self getOnDemandFirstSliderImageArray:[topTitleCarouselArray mutableCopy]];
        //[COMMON removeLoading];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
         [COMMON removeLoading];
        
    }nPPV:nPPV];
    
}
-(void)removeViewForFailureCondition{
    for(UIView *view in onDemandSliderView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:YES];
    [COMMON removeLoading];
}
#pragma mark - removalOfEmptyCarouselArray
-(void)removalOfEmptyCarouselArray{
    BOOL IsEmptyAvailable;
    NSMutableArray *tempArray = [NSMutableArray new];
    NSMutableArray *tempTopTitleCarouselArray = [NSMutableArray new];
    tempArray = [topTitleCarouselArray mutableCopy] ;
    for (int i=0;i<[tempArray count];i++) {
        NSMutableArray * tempCarouselArray = [[[tempArray mutableCopy] objectAtIndex:i] mutableCopy];
        NSMutableArray * itemsTempArray = [[[[tempArray mutableCopy] valueForKey:@"items"]objectAtIndex:i] mutableCopy];
        if([itemsTempArray count]==0){
            NSLog(@"EMPTY ");
            IsEmptyAvailable=YES;
        }
        else{
            IsEmptyAvailable=NO;
            [tempTopTitleCarouselArray addObject:[tempCarouselArray mutableCopy]];
        }
       
    }
    topTitleCarouselArray = tempTopTitleCarouselArray;
    //NSLog(@"ITEMS FINAL %@-->",tempTopTitleCarouselArray);
    
}
#pragma mark - getSliderImage
-(void)getOnDemandFirstSliderImageArray:(id)topTitleCarouselListArray{
   
    [[RabbitTVManager sharedManager] getOnDemandSlider:^(AFHTTPRequestOperation *request, id responseObject){
        //_appDownloadTableView.tag = 1000;
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
        [COMMON removeLoading];
    }];
}

#pragma mark - loadSliderCarouselDesign
-(void)loadSliderCarouselDesign:(id)sliderArrayForImages carouselArray:(id)topTitleCarouselListArray {
    
    if ((NSString *)[NSNull null] == currentTopTitle||currentTopTitle == nil) {
        currentTopTitle=@"Featured";
    }
    for(UIView *view in onDemandSliderView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
    }
    [onDemandSliderView setHidden:NO];
    [_tableView setHidden:YES];
    OnDemandSliderCarouselView *slider = [OnDemandSliderCarouselView loadView];
    [slider loadSliderShowImages:sliderArrayForImages carouselArray:topTitleCarouselListArray currentViewStr:@"OnDemandView" currentTitleStr:currentTopTitle];
    [onDemandSliderView addSubview:slider];
    
    [self performSelector:@selector(removeLoadingIcopnFromView) withObject:nil afterDelay:1.5];
}
-(void)removeLoadingIcopnFromView{
    [COMMON removeLoading];
}
#pragma mark - loadTVShowData
-(void)loadTVShowData{
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getOnDemandTvShowsCarousels:^(AFHTTPRequestOperation *request, id responseObject) {
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadTVShowSliderImageData:[topTitleCarouselArray mutableCopy]];
        [COMMON removeLoading];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
        [COMMON removeLoading];
    } nPPV:nPPV];
}
#pragma mark - loadTVShowData
-(void)loadTVShowSliderImageData:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getOnDemandTvShowsSlider:^(AFHTTPRequestOperation *request, id responseObject) {
        // _appDownloadTableView.tag = 1000;
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
    }];
}

#pragma mark - loadOnDemandCategoryCarouselsByID
-(void)loadOnDemandCategoryCarouselsByID:(int)categoryID{
    [COMMON LoadIcon:self.view];
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager]getOnDemandTvShowsCarouselsByCategoryID:^(AFHTTPRequestOperation *request, id responseObject) {
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadOnDemandCategorySliderImageByID:categoryID carouselArray:topTitleCarouselArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
        [COMMON removeLoading];
    } categoryID:categoryID nPPV:nPPV];
}

#pragma mark - loadOnDemandCategorySliderImageByID
-(void)loadOnDemandCategorySliderImageByID:(int)categoryID carouselArray:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getOnDemandTvShowsSliderByCategoryID:^(AFHTTPRequestOperation *request, id responseObject) {
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
        [self removeViewForFailureCondition];
    } categoryID:categoryID];

}
#pragma mark - loadOnDemandCategoryCarouselsByID
-(void)loadOnDemandDecadeByID:(int)decadeID{
    [COMMON LoadIcon:self.view];
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager]getOnDemandTvShowsByDecadeID:^(AFHTTPRequestOperation *request, id responseObject) {
         [arrayItems removeAllObjects];
        arrayItems =[responseObject mutableCopy];
        isPosterImage=NO;
        isThumbnailImage=NO;
        isCarouselImage=YES;
        [_tableView setHidden:NO];
        [onDemandSliderView setHidden:YES];
        [self.tableView reloadData];
        [COMMON removeLoading];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
        [self removeViewForFailureCondition];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } decadeID:decadeID nPPV:nPPV];
}
#pragma mark - loadPrimeCarouselData
-(void)loadPrimeCarouselData:(NSString*)weekDay{
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [[RabbitTVManager sharedManager] getPrimeTimeData:^(AFHTTPRequestOperation * request, id responseObject) {
        isCarouselImage=YES;
        isPosterImage=NO;
        isThumbnailImage=NO;
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadPrimeSliderImage:weekDay carouselArray:topTitleCarouselArray];
       
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [_tableView setHidden:YES];
       // [AppCommon showSimpleAlertWithMessage:@"No Data"];
       
        [COMMON removeLoading];
        [self removeViewForFailureCondition];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nWeekday:weekDay nPPV:nPPV];
    
}
#pragma mark - loadPrimeSliderImage
-(void)loadPrimeSliderImage:(NSString *)weekDay carouselArray:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getOnDemandPrimeTimeSliderImageByWeek:^(AFHTTPRequestOperation * request, id responseObject) {
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
    }  Weekday:weekDay];
    
}
#pragma mark - loadMoviesData
-(void)loadMoviesData{
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];

    [[RabbitTVManager sharedManager]getOnDemandMoviesCarousels:^(AFHTTPRequestOperation *request, id responseObject) {
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadMoviesSliderImageData:[topTitleCarouselArray mutableCopy]];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
        [self removeViewForFailureCondition];
    } nPPV:nPPV];
}
#pragma mark - loadMoviesSliderImageData
-(void)loadMoviesSliderImageData:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getOnDemandMoviesSlider:^(AFHTTPRequestOperation *request, id responseObject) {
        // _appDownloadTableView.tag = 1000;
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
        [COMMON removeLoading];
    }];
}
#pragma mark - loadOnDemandWebOriginalData
-(void)loadOnDemandWebOriginalData{
   // int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager] getWebOriginalCarouselData:^(AFHTTPRequestOperation * request, id responseObject) {
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadWebOriginalSliderImageData:[topTitleCarouselArray mutableCopy]];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
       // [AppCommon showSimpleAlertWithMessage:@"No Data"];
        [self removeViewForFailureCondition];
        [COMMON removeLoading];
    }nPPV:nPPV];
  
}
#pragma mark - loadWebOriginalSliderImageData
-(void)loadWebOriginalSliderImageData:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getWebOriginalSliderData:^(AFHTTPRequestOperation *request, id responseObject) {
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
        
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
         [COMMON removeLoading];
    }];
}
#pragma mark - loadOnDemandKidsData
-(void)loadOnDemandKidsData{
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager] getKidsCarouselsData:^(AFHTTPRequestOperation * request, id responseObject) {
        topTitleCarouselArray = [NSMutableArray new];
        topTitleCarouselArray =[responseObject mutableCopy];
        [self removalOfEmptyCarouselArray];
        [self loadKidsSliderImageData:[topTitleCarouselArray mutableCopy]];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
       // [AppCommon showSimpleAlertWithMessage:@"No Data"];
        [self removeViewForFailureCondition];
         [COMMON removeLoading];
    }nPPV:nPPV];
    
}
#pragma mark - loadKidsSliderImageData
-(void)loadKidsSliderImageData:(id)topTitleCarouselListArray{
    
    [[RabbitTVManager sharedManager]getKidsSliderData:^(AFHTTPRequestOperation *request, id responseObject) {
        sliderImageArray = [NSMutableArray new];
        sliderImageArray =[responseObject mutableCopy];
        [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselListArray];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self removeViewForFailureCondition];
         [COMMON removeLoading];
    }];
}

//new change 6 March 2017 raji
-(void)getUpStaticAppManager{
    
    headerTitleArray = @[@"Essentials",@"Broadcast",@"Cable",@"Subscriptions",@"Movies",@"Others"];
    if(isAppManagerMenu==YES){
        if([arrayItems count] != 0){
            [arrayItems removeAllObjects];
        }
    }
    else{
        if([appListArrayItems count] != 0){
            [appListArrayItems removeAllObjects];
        }
        NSString *videoPlayed = [COMMON getDemoVideoPlayed];
        if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil) {
        }
    }
  
    //appStaticArray =
    
    
}
-(void)loadEssentialsArray{
    essentials = [NSArray new];
    
    essentials =  @[@{@"name" :@"ABC - Live TV Full Episodes",
                      @"ipa"  :@"https://itunes.apple.com/us/app/watch-abc/id364191819?mt=8",
                      @"logo" :@"ABC.png",
                      },
                    @{@"name" :@"NBC News",
                      @"ipa"  :@"https://itunes.apple.com/us/app/nbc-watch-now-stream-full/id442839435?mt=8",
                      @"logo" :@"NBC.png"
                      },
                    @{@"name" :@"CBS",
                      @"ipa"  :@"https://itunes.apple.com/us/app/cbs/id530168168?mt=8",
                      @"logo" :@"CBS.png"
                      },
                    @{@"name" :@"CRANCKLE",
                      @"ipa"  :@"https://itunes.apple.com/en/app/crackle-movies-tv/id377951542?mt=8",
                      @"logo" :@"CRANCKLE.png"
                      },
                    @{@"name" :@"FOX",
                      @"ipa"  :@"https://itunes.apple.com/us/app/fox-now/id571096102?mt=8",
                      @"logo" :@"FOX.png"
                      },
                    @{@"name" :@"Popcorn-Flix",
                      @"ipa"  :@"https://itunes.apple.com/in/app/popcornflix-free-movies/id493605531?mt=8",
                      @"logo" :@"Popcorn-Flix.png"
                      },
                    @{@"name" :@"Netflix",
                      @"ipa"  :@"https://itunes.apple.com/us/app/netflix/id363590051?mt=8",
                      @"logo" :@"Netflix.png"
                      },
                    @{@"name" :@"PBS",
                      @"ipa"  :@"https://itunes.apple.com/us/app/pbs-video/id398349296?mt=8%22",
                      @"logo" :@"PBS.png"
                      }
                    ];
}
-(void)loadBroadCastArray{
    broadcast = [NSArray new];
    
    broadcast =  @[@{@"name" :@"ABC - Live TV Full Episodes",
                      @"ipa"  :@"https://itunes.apple.com/us/app/watch-abc/id364191819?mt=8",
                      @"logo" :@"ABC.png",
                      },
                    @{@"name" :@"CBS",
                      @"ipa"  :@"https://itunes.apple.com/us/app/cbs/id530168168?mt=8",
                      @"logo" :@"CBS.png"
                      },
                    @{@"name" :@"CW",
                      @"ipa"  :@"https://itunes.apple.com/us/app/the-cw/id491730359?mt=8",
                      @"logo" :@"CW.png"
                      },
                    @{@"name" :@"FOX",
                      @"ipa"  :@"https://itunes.apple.com/us/app/fox-now/id571096102?mt=8",
                      @"logo" :@"FOX.png"
                      },
                    @{@"name" :@"NBC",
                      @"ipa"  :@"https://itunes.apple.com/us/app/nbc-watch-now-stream-full/id442839435?mt=8",
                      @"logo" :@"NBC.png"
                      },
                    @{@"name" :@"PBS",
                      @"ipa"  :@"https://itunes.apple.com/us/app/pbs-video/id398349296?mt=8",//%22
                      @"logo" :@"PBS.png"
                      }
                    ];
}

-(void)loadCableArray{
    cable = [NSArray new];
    
    cable =   @[@{@"name":@"A_E",
                 @"ipa"  :@"https://itunes.apple.com/us/app/a-e/id571711580?mt=8",
                 @"logo" :@"A_E.png",
                 },
               @{@"name" :@"AMC",
                 @"ipa"  :@"https://itunes.apple.com/us/app/amc/id1025120568?mt=8",
                 @"logo" :@"AMC.png"
                 },
               @{@"name" :@"Cartoon-Network",
                 @"ipa"  :@"https://itunes.apple.com/us/app/cartoon-network-app-watch/id404593641?mt=8",
                 @"logo" :@"Cartoon-Network.png"
                 },
               @{@"name" :@"Comedy-Central",
                 @"ipa"  :@"https://itunes.apple.com/us/app/comedy-central/id799551807?mt=8",
                 @"logo" :@"Comedy-Central.png"
                 },
               @{@"name" :@"Disney-Channel",
                 @"ipa"  :@"https://itunes.apple.com/us/app/watch-disney-channel/id529997671?mt=8",
                 @"logo" :@"Disney-Channel.png"
                 },
               @{@"name" :@"Disney-Junior",
                 @"ipa"  :@"https://itunes.apple.com/gb/app/disney-junior-play/id665235489?mt=8",
                 @"logo" :@"Disney-Junior.png"
                 },
                @{@"name" :@"Epix",
                  @"ipa"  :@"https://itunes.apple.com/us/app/epix/id430018488?mt=8",
                  @"logo" :@"Epix.png"
                  },
                @{@"name" :@"FX-Networks",
                  @"ipa"  :@"https://itunes.apple.com/us/app/fxnow/id767268733?mt=8",
                  @"logo" :@"FX-Networks.png"
                  },
                @{@"name" :@"HGTV",
                  @"ipa"  :@"https://itunes.apple.com/us/app/hgtv-watch/id376038666?mt=8",
                  @"logo" :@"HGTV.png"
                  },
                @{@"name" :@"HISTORY",
                  @"ipa"  :@"https://itunes.apple.com/us/app/history/id576009463?mt=8",
                  @"logo" :@"HISTORY.png"
                  },
                @{@"name" :@"IFC",
                  @"ipa"  :@"https://itunes.apple.com/us/app/watch-ifc/id1061473874?mt=8",
                  @"logo" :@"IFC.png"
                  },
                @{@"name" : @"Lifetime",
                  @"ipa"  : @"https://itunes.apple.com/us/app/lifetime/id579966222?mt=8",
                  @"logo" : @"lifetime.png"
                  },
                @{@"name" : @"MAX GO",
                  @"ipa"  : @"https://itunes.apple.com/us/app/max-go/id453560335?mt=8",
                  @"logo" : @"MAX-GO.png"
                    
                    },
                @{@"name" : @"MTV",
                  @"ipa"  : @"https://itunes.apple.com/us/app/mtv/id422366403?mt=8",
                  @"logo" : @"MTV.png"
                    },
                @{
                    @"name" : @"Nick Studio",
                    @"ipa"  : @"https://itunes.apple.com/us/app/nick/id596133590?mt=8",
                    @"logo" : @"Nick.png"
                    },
                @{
                    @"name" : @"Nick Studio",
                    @"ipa"  : @"https://itunes.apple.com/us/app/nick/id596133590?mt=8",
                    @"logo" : @"Nick-Jr.png"

                    },
                @{
                    @"name" : @"Red Bull TV",
                    @"ipa"  : @"https://itunes.apple.com/in/app/red-bull-tv/id364269164?mt=8",
                    @"logo" : @"Redbull-TV.png"
                    
                    },
                @{ @"name"  : @"Spike",
                    @"ipa"  : @"https://itunes.apple.com/us/app/spike-tv/id906788127?mt=8",
                    @"logo" : @"Spike.png"
                   },
                 @{
                    @"name"  : @"STARZ",
                    @"ipa"  : @"https://itunes.apple.com/us/app/starz/id550221096?mt=8",
                    @"logo" : @"Starz.png"
                    },
                @{
                    @"name"  : @"tbs",
                    @"ipa"  : @"https://itunes.apple.com/us/app/watch-tbs/id462780547?mt=8",
                    @"logo" : @"TBS.png"
                    },

                @{
                    @"name"  :@"Watch TNT",
                    @"ipa"  : @"https://itunes.apple.com/us/app/watch-tnt/id460494135?mt=8",
                    @"logo" : @"TNT.png"

                    },
               
                @{
                    @"name"  : @"USA NOW",
                    @"ipa"  : @"https://itunes.apple.com/us/app/usa-now/id661695783?mt=8",
                    @"logo" : @"USA.png"
                    },

                @{
                    @"name"  : @"Watch VH1 TV",
                    @"ipa"  : @"https://itunes.apple.com/us/app/vh1/id413522634?mt=8",
                    @"logo" : @"VH1.png"
                    },
                @{
                    @"name"  : @"VICELAND",
                    @"ipa"  : @"https://itunes.apple.com/us/app/viceland/id1075922366?mt=8",
                    @"logo" : @"Viceland.png"

                    },
                @{
                    @"name"  : @"XFINITY TV",
                    @"ipa"  : @"https://itunes.apple.com/us/app/xfinity-tv/id731629156?mt=8",
                    @"logo" : @"Xfinity.png"
                    }

               ];
}

-(void)loadMoviesArray{
    movies = [NSArray new];
    
    movies =   @[ @{@"name" :@"CRANCKLE",
                    @"ipa"  :@"https://itunes.apple.com/en/app/crackle-movies-tv/id377951542?mt=8",
                    @"logo" :@"CRANCKLE.png"
                    },
                  @{@"name" :@"Epix",
                    @"ipa"  :@"https://itunes.apple.com/us/app/epix/id430018488?mt=8",
                    @"logo" :@"Epix.png"
                    },
                  @{@"name" :@"HULU",
                    @"ipa"  :@"https://itunes.apple.com/us/app/hulu/id376510438?mt=8",
                    @"logo" :@"hulu.png"
                    },
                  @{@"name" :@"Popcorn-Flix",
                    @"ipa"  :@"https://itunes.apple.com/in/app/popcornflix-free-movies/id493605531?mt=8",
                    @"logo" :@"Popcorn-Flix.png"
                    },
                  @{@"name" :@"Vudu",
                    @"ipa"  :@"https://itunes.apple.com/us/app/vudu-movies-tv/id487285735?mt=8",
                    @"logo" :@"Vudu.png"
                    },];
}

-(void)loadOtherArray{
    other = [NSArray new];
    
    other =   @[ @{@"name" :@"IMDB",
                    @"ipa"  :@"https://itunes.apple.com/us/app/imdb-movies-tv/id342792525?mt=8",
                    @"logo" :@"imdb-app-image.png"
                    },
                 
                  @{@"name" :@"Fox Sports",
                    @"ipa"  :@"https://itunes.apple.com/us/app/fox-sports-go/id711074743?mt=8",
                    @"logo" :@"fox-sports-go-app.png"
                    },
                  @{@"name" :@"SURE Universal Remote",
                    @"ipa"  :@"https://itunes.apple.com/us/app/sure-universal-remote/id1097801576?mt=8",
                    @"logo" :@"92013291.png"
                    },];
}

-(void)loadSubScriptionArray{
    subscriptions = [NSArray new];
    
    subscriptions = @[ @{@"name" :@"IMDB",
                   @"ipa"  :@"https://itunes.apple.com/us/app/imdb-movies-tv/id342792525?mt=8",
                   @"logo" :@"amazon-prime.png"
                   },
                 @{@"name" :@"Fox Sports",
                   @"ipa"  :@"https://itunes.apple.com/us/app/fox-sports-go/id711074743?mt=8",
                   @"logo" :@"fox-sports-go-app.png"
                   },
                 @{@"name" :@"SURE Universal Remote",
                   @"ipa"  :@"https://itunes.apple.com/us/app/sure-universal-remote/id1097801576?mt=8",
                   @"logo" :@"92013291.png"
                   },];
}

/*
 @{
 @"name"  : @"Watch truTV",
 @"ipa"  : @"",
 @"logo" : @"TruTV.png"
 },
 @{@"name" :@"Kodi",
 @"ipa"  :@"",
 @"logo" :@"kodi-11-300x3001.png"
 },
 @{@"name" :@"Samsung",
 @"ipa"  :@"",
 @"logo" :@"vr--app-image.png"
 },*/

-(void)setUpNewStaticDownloadAppView{
 
    [self getUpStaticAppManager];
 
    isAppListShown = YES;
 
    [subScriptionView removeFromSuperview];
    [appHeaderScrollView removeFromSuperview];
    [appHeaderLabel removeFromSuperview];
    
    
    appHeaderScrollView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,40)];
    [downloadView addSubview:appHeaderScrollView];
    
    
    [appHeaderScrollView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
    
    
    appHeaderScrollView.sectionTitles = headerTitleArray;//menuArray;
    appHeaderScrollView.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    appHeaderScrollView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    appHeaderScrollView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    appHeaderScrollView.selectionIndicatorColor = [UIColor whiteColor];
    
    [appHeaderScrollView addTarget:self action:@selector(appNewStaticListSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    appHeaderScrollView.selectedSegmentIndex = appVisibleSection;
    
    [appHeaderScrollView setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString;
        
        if (selected) {
            
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        } else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        }
    }];
    
    
    
    appHeaderLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,appHeaderScrollView.frame.size.height+5,SCREEN_WIDTH,30)];
    appHeaderLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *appHeaderLabelStr = @"Fast Download";
    if([COMMON isSpanishLanguage]==YES){
        appHeaderLabelStr = [COMMON getAppManagetTopTitleStr];
        if ((NSString *)[NSNull null] == appHeaderLabelStr||appHeaderLabelStr == nil) {
            appHeaderLabelStr = @"Fast Download";
            appHeaderLabelStr =  [COMMON stringTranslatingIntoSpanish:appHeaderLabelStr];
            [[NSUserDefaults standardUserDefaults] setObject:appHeaderLabelStr forKey:APP_MANAGER_TOP_TITLE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    appHeaderLabel.text = appHeaderLabelStr ;
    [appHeaderLabel setFont:[COMMON getResizeableFont:Roboto_Regular(19)]];
    appHeaderLabel.textColor=[UIColor whiteColor];
    [appHeaderLabel  setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    
    
    [downloadView addSubview:appHeaderLabel];
    
    
    UILabel *subTitle= [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(appHeaderLabel.frame),SCREEN_WIDTH,30)];
    subTitle.textAlignment = NSTextAlignmentCenter;
    
    subTitle.text = @"" ;
    
  //  [downloadView addSubview:subTitle];
    
    
    NSString * appManagerStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([appManagerStr  isEqualToString: @"NO"]){
        NSString *videoPlayed = [COMMON getDemoVideoPlayed];
        if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil){
            [downloadView setHidden:YES];
            if(isVideoClosed==YES && isiPhoneViewPage==YES){
                [self getOnDemandAppsForUser];
            }
        }
        else{
            [downloadView setHidden:NO];
        }
    }
    
    
    NSString *titleStr = @"App Manager";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON getAppManagerStr];
        if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
            titleStr = @"App Manager";
            titleStr =  [COMMON stringTranslatingIntoSpanish:titleStr];
            [[NSUserDefaults standardUserDefaults] setObject:titleStr forKey:APP_MANAGER];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if(appManagerDoneClicked==YES){
        NSString *titleStr = @"On Demand";
        if([COMMON isSpanishLanguage]==YES){
            titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
        }
    }
    self.navigationItem.title =titleStr;
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(13)],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"YES"]){
        [_mainLeftBarButton setHidden:NO];
        [_searchButton setHidden:NO];
    } else {
        [_mainLeftBarButton setHidden:NO];
        [_searchButton setHidden:YES];
    }
    
    [collectionHeader removeFromSuperview];
    [collectionFooter removeFromSuperview];
    
    CGFloat latelFontSize = 10;
    CGFloat collectionHeaderHeight = 60;
    CGFloat labelHeight = 40;
    CGFloat subLabelHeight = 20;
    if([self isDeviceIpad]==YES){
        latelFontSize =14;
        labelHeight =70;
        collectionHeaderHeight = 100;
        subLabelHeight = 30;
    }
    
    UIDevice* device = [UIDevice currentDevice];
    

    collectionHeader  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(appHeaderLabel.frame), SCREEN_WIDTH, collectionHeaderHeight)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, labelHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text= @"Our SmartGuide helps you unify and manager over\n 1 million FREE TV shows and movies available online.";
    label.font = [COMMON getResizeableFont:Roboto_Regular(latelFontSize)];
    label.numberOfLines =0;
   
    UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), SCREEN_WIDTH-40, subLabelHeight)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.textColor = [UIColor whiteColor];
    subLabel.textAlignment = NSTextAlignmentCenter;
    // subLabel.text= @"Need Help? Watch this Video";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Need Help? "
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Watch this Video"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                          NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    
    //[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"tring"]];
    
    subLabel.attributedText = attributedString;
    subLabel.font = [COMMON getResizeableFont:Roboto_Regular(latelFontSize)];
    
    [collectionHeader addSubview:label];
    [collectionHeader addSubview:subLabel];
    
    subLabel.tag =102;
    
     UITapGestureRecognizer *tapVideo=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapVideoAction)];
    [tapVideo setNumberOfTapsRequired:1];
    tapVideo.numberOfTapsRequired = 1;
    tapVideo.numberOfTouchesRequired = 1;
    [subLabel addGestureRecognizer:tapVideo];
    [subLabel setUserInteractionEnabled:YES];
    [collectionHeader setUserInteractionEnabled:YES];
    
    collectionHeader.backgroundColor = [UIColor clearColor];
    
    [downloadView addSubview:collectionHeader];
    
    [downloadView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    
    subScriptionView = [[UIView alloc]init];
    
    CGFloat footerLabelFontSize = 10;
    CGFloat collectionFooterHeight = 70;
    CGFloat footerLabelHeight = 40;
    CGFloat doneBtnHeight = 30;
    CGFloat subHeightExtra = 150;
    
    if([self isDeviceIpad]==YES){
        footerLabelFontSize = 14;
        footerLabelHeight =50;
        collectionFooterHeight = 120;
        doneBtnHeight = 50;
        subHeightExtra =200;
        
    }
    
    CGFloat collectionHeaderMaxY = CGRectGetMaxY(collectionHeader.frame);
    
    CGFloat subHeight = SCREEN_HEIGHT - (collectionHeaderMaxY + collectionFooterHeight+self.navigationController.navigationBar.frame.size.height+30);
    
    if([self isDeviceIpad]==YES){
        
        subHeight = SCREEN_HEIGHT - collectionHeaderMaxY - subHeightExtra;
    }
    else{
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            subHeight = SCREEN_HEIGHT - (collectionHeaderMaxY + collectionFooterHeight+self.navigationController.navigationBar.frame.size.height+10);
        }
    }
    
    //CGRectGetMaxY(appHeaderLabel.frame)
    
    [subScriptionView setFrame:CGRectMake(0, CGRectGetMaxY(collectionHeader.frame),SCREEN_WIDTH , subHeight)];
    
    [subScriptionView setBackgroundColor:[UIColor clearColor]];
    
    [self setUpCollectionView:subScriptionView];
    
    [downloadView addSubview:subScriptionView];
    
    [okDoneBtn setTitle:@"OK, I'm done!" forState:UIControlStateNormal];
    okDoneBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(15)];
    [okDoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okDoneBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [okDoneBtn addTarget:self action:@selector(hideDownloadView) forControlEvents:UIControlEventTouchUpInside];
    
    [okDoneBtn setHidden:YES];
   /*
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str1 isEqualToString: @"YES"]){
        [okDoneBtn setHidden:YES];
    }else {
        _appDownloadTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [okDoneBtn setHidden:NO];
    }
    */
    
    [_appDownloadTableView setHidden:YES];
   
    collectionFooter  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subScriptionView.frame),SCREEN_WIDTH , collectionFooterHeight)];
    
    UILabel *footerLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, footerLabelHeight)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    //footerLabel.text= @"Note: You Must Check the  \"Unknown Sources \" box in \n Securcity or Application section of \"Settings\" Menu ";
    footerLabel.numberOfLines=0;
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.font = [COMMON getResizeableFont:Roboto_Regular(footerLabelFontSize)];
    [collectionFooter addSubview:footerLabel];
    
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] init];
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"Note: "
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(footerLabelFontSize)]}]];
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"You Must Check the  \"Unknown Sources \" box in \n Securcity or Application section of \"Settings\" Menu "
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                                                                          NSBackgroundColorAttributeName: [UIColor clearColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Regular(footerLabelFontSize)]}]];
    
    footerLabel.attributedText = attributedString1;
    
    CGFloat btnWidth = 100;
    CGFloat btnXPos = SCREEN_WIDTH/2-50;
    CGFloat btnYPos = CGRectGetMaxY(label.frame);
    
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnXPos, btnYPos, btnWidth, doneBtnHeight)];
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(latelFontSize)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(hideStaticView) forControlEvents:UIControlEventTouchUpInside];
    [collectionFooter addSubview:doneBtn];
    [collectionFooter addSubview:footerLabel];
    
   
    if([appManagerStr  isEqualToString: @"NO"]){
       [doneBtn setHidden:NO];
    }
    else{
      [doneBtn setHidden:YES];
    }
    [doneBtn setHidden:NO];
    
    collectionFooter.backgroundColor = [UIColor clearColor];
    
    [downloadView addSubview:collectionFooter];
    
    NSString *currentSelectionStr;
    currentSelectionStr = [headerTitleArray objectAtIndex:appVisibleSection];
    
    [self currentString:currentSelectionStr];
  
}

#pragma mark - setUpDownloadAppView
-(void)setUpDownloadAppView{
    isAppListShown = YES;
    
    [appHeaderScrollView removeFromSuperview];
    [appHeaderLabel removeFromSuperview];
   
    
    appHeaderScrollView = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,40)];
    [downloadView addSubview:appHeaderScrollView];
    
    
    [appHeaderScrollView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
    
    appHeaderScrollView.sectionTitles = headerTitleArray;//menuArray;
    appHeaderScrollView.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    appHeaderScrollView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    appHeaderScrollView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    appHeaderScrollView.selectionIndicatorColor = [UIColor whiteColor];
    
    [appHeaderScrollView addTarget:self action:@selector(appListSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    appHeaderScrollView.selectedSegmentIndex = appVisibleSection;
    
    [appHeaderScrollView setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString;
        
        if (selected) {
            
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        } else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        }
    }];
    
    
    
    appHeaderLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,appHeaderScrollView.frame.size.height+3,SCREEN_WIDTH,30)];
    appHeaderLabel.textAlignment = NSTextAlignmentCenter;

    NSString *appHeaderLabelStr = @"Top Video Plugins Required to Play Your Favourite Shows";
    if([COMMON isSpanishLanguage]==YES){
        appHeaderLabelStr = [COMMON getAppManagetTopTitleStr];
        if ((NSString *)[NSNull null] == appHeaderLabelStr||appHeaderLabelStr == nil) {
            appHeaderLabelStr = @"Top Video Plugins Required to Play Your Favourite Shows";
            appHeaderLabelStr =  [COMMON stringTranslatingIntoSpanish:appHeaderLabelStr];
            [[NSUserDefaults standardUserDefaults] setObject:appHeaderLabelStr forKey:APP_MANAGER_TOP_TITLE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
   
    appHeaderLabel.text = appHeaderLabelStr ;
    [appHeaderLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    appHeaderLabel.textColor=[UIColor whiteColor];
    [appHeaderLabel  setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    [downloadView addSubview:appHeaderLabel];
    
    NSString * appManagerStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([appManagerStr  isEqualToString: @"NO"]){
        NSString *videoPlayed = [COMMON getDemoVideoPlayed];
        if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil){
            [downloadView setHidden:YES];
            if(isVideoClosed==YES && isiPhoneViewPage==YES){
                [self getOnDemandAppsForUser];
            }
        }
        else{
            [downloadView setHidden:NO];
        }
    }
   
    
    NSString *titleStr = @"App Manager";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON getAppManagerStr];
        if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
            titleStr = @"App Manager";
            titleStr =  [COMMON stringTranslatingIntoSpanish:titleStr];
            [[NSUserDefaults standardUserDefaults] setObject:titleStr forKey:APP_MANAGER];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if(appManagerDoneClicked==YES){
        NSString *titleStr = @"On Demand";
        if([COMMON isSpanishLanguage]==YES){
            titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
        }
    }
    self.navigationItem.title =titleStr;
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(13)],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"YES"]){
        [_mainLeftBarButton setHidden:NO];
        [_searchButton setHidden:NO];
    } else {
        [_mainLeftBarButton setHidden:NO];
        [_searchButton setHidden:YES];
    }
    
    
    [downloadView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    _appDownloadTableView.tag = 111;
    _appDownloadTableView.backgroundColor = [UIColor clearColor];
    _appDownloadTableView.delegate = self;
    _appDownloadTableView.dataSource = self;
    _appDownloadTableView.bounces = YES;
    _appDownloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _appDownloadTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [okDoneBtn setTitle:@"OK, I'm done!" forState:UIControlStateNormal];
    okDoneBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(15)];
    [okDoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okDoneBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [okDoneBtn addTarget:self action:@selector(hideDownloadView) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str1 isEqualToString: @"YES"]){
        [okDoneBtn setHidden:YES];
        
         //CGRect appHeaderLabelFrame = appHeaderLabel.frame;
         //CGFloat appHeaderLabelFrameMaxY = CGRectGetMaxY(appHeaderLabelFrame);
        
//        _appDownloadTableView.translatesAutoresizingMaskIntoConstraints = YES;
//        CGRect appDownloadFrame = _appDownloadTableView.frame;
//        appDownloadFrame.size.width = SCREEN_WIDTH;
//        appDownloadFrame.size.height = downloadView.frame.size.height-appHeaderLabel.frame.size.height;
//        [_appDownloadTableView setFrame:appDownloadFrame];
    }else {
        _appDownloadTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [okDoneBtn setHidden:NO];
        
    }
    
    
//    if([str1 isEqualToString: @"YES"]){
//        if(isTimerLoaded==YES){
//            [self loadAppManagerTimerTable];
//            isTimerLoaded=NO;
//        }
//        
//    }
    
    if(isVideoClosed==YES && isiPhoneViewPage==YES){
        
    }
    else{
        
    }
    NSString * foreground = [[NSUserDefaults standardUserDefaults] objectForKey:ENTER_FOREGROUND];
    
    if([foreground isEqualToString:@"ENTER_FOREGROUND"]){
        segmentTag = appAdditionInteger*(appVisibleSection+6);
        appAdditionInteger = appAdditionInteger+1000;
        appAdditionInteger++;
        NSString *categoryID;
        int nDeviceID = [[NSString stringWithFormat:@"%d",CURRENT_DEVICE_ID] intValue];
        
        NSInteger currentCount = [categoryListArray count];
        if(appVisibleSection<currentCount){
            categoryID = [[categoryListArray objectAtIndex:appVisibleSection] valueForKey:@"id"];
            appManagerDeviceId = nDeviceID;
            appManagerCategoryId = [categoryID intValue];
            [self getAppsListData:appManagerDeviceId forCategory:appManagerCategoryId];
        }
       
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ENTER_FOREGROUND];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
//    if(isWillDisAppear==YES){
//        [self loadAppManagerList];
//        isWillDisAppear=NO;
//    }
   
}
-(void)loadAppManagerList{
    [appListArrayItems removeAllObjects];
    [[RabbitTVManager sharedManager]cancelRequest];
    
    segmentTag = appAdditionInteger*(appVisibleSection+6);
    appAdditionInteger = appAdditionInteger+1000;
    appAdditionInteger++;
    [_appDownloadTableView setHidden:YES];
    NSString *categoryID;
    int nDeviceID = [[NSString stringWithFormat:@"%d",CURRENT_DEVICE_ID] intValue];
    NSInteger currentCount = [categoryListArray count];
    if(appVisibleSection<currentCount){
        categoryID = [[categoryListArray objectAtIndex:appVisibleSection] valueForKey:@"id"];
        appManagerDeviceId = nDeviceID;
        appManagerCategoryId = [categoryID intValue];
        int categoryId = [categoryID intValue];
        [appTitleArray removeAllObjects];
        
        [self getAppsListData:nDeviceID forCategory:categoryId];
    }
    
}
- (void)appNewStaticListSegmentedControlChangedValue:(HMSegmentedControl *)sender {
    
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    
    NSString *currentSelectionStr;
    currentSelectionStr = [headerTitleArray objectAtIndex:sender.selectedSegmentIndex];
    //    headerTitleArray = @[@"Essentials",@"Broadcast",@"Cable",@"Subscriptions",@"Movies",@"Others"];

    appVisibleSection = sender.selectedSegmentIndex;
    [self currentString:currentSelectionStr];
    
}
-(void)currentString:(NSString*)currentSelectionStr{
    if([currentSelectionStr isEqualToString:@"Essentials"]){
        appCollectionStaticArray = essentials;
        [_collectionView reloadData];
    }
    if([currentSelectionStr isEqualToString:@"Broadcast"]){
        appCollectionStaticArray = broadcast;
        [_collectionView reloadData];
    }
    if([currentSelectionStr isEqualToString:@"Cable"]){
        appCollectionStaticArray = cable;
        [_collectionView reloadData];
    }if([currentSelectionStr isEqualToString:@"Subscriptions"]){
        appCollectionStaticArray = subscriptions;
        [_collectionView reloadData];
    }if([currentSelectionStr isEqualToString:@"Movies"]){
        appCollectionStaticArray = movies;
        [_collectionView reloadData];
    }if([currentSelectionStr isEqualToString:@"Others"]){
        appCollectionStaticArray = other;
        [_collectionView reloadData];
    }
}
#pragma mark - appListSegmentedControlChangedValue
- (void)appListSegmentedControlChangedValue:(HMSegmentedControl *)sender {
     [self removeSearchView];
    [appListArrayItems removeAllObjects];
    [[RabbitTVManager sharedManager]cancelRequest];
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    
    appVisibleSection = sender.selectedSegmentIndex;
    segmentTag = appAdditionInteger*(appVisibleSection+5);
    appAdditionInteger = appAdditionInteger+1000;
    appAdditionInteger++;
    
    [_appDownloadTableView setHidden:YES];
    NSString *categoryID;
    int nDeviceID = [[NSString stringWithFormat:@"%d",CURRENT_DEVICE_ID] intValue];
    NSInteger currentCount = [categoryListArray count];
    
    if(appVisibleSection<currentCount){
        categoryID = [[categoryListArray objectAtIndex:sender.selectedSegmentIndex] valueForKey:@"id"];
        int categoryId = [categoryID intValue];
        appManagerDeviceId = nDeviceID;
        appManagerCategoryId = categoryId;
        [appTitleArray removeAllObjects];
        
        [self getAppsListData:nDeviceID forCategory:categoryId];
    }
    
    
}

-(void)addOnDemandPlayerView{
    
    [_playerBgView setHidden:NO];
    [_playerView setHidden:NO];
    
    self.playerView.delegate = self;
    [self.playerView setBackgroundColor:[UIColor blackColor]];
    [_playerBgView setBackgroundColor:[UIColor blackColor]];

   //new link https://youtu.be/mIqzgd0yse0
    
    NSString* m_strVideoUrl = @"mIqzgd0yse0";
    
    //@"EN6sXw41Lis";//@"PLNT1r49jsn3niUNZcxO1Vyj86oxuxmi7R";//@"K0kvNDE0lNw";//@"TeUt1aK-Fic";
    
    //NEWLY Changing showinfo @1 to @0  to hide video info(title) and ShareIcon
    //Changing controls @1 to @0 to hide controls
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay":@1,
                                 @"showinfo" : @0,//raji
                                 @"rel" : @0,
                                 @"controls" : @0,
                                 @"origin" : @"https://www.example.com", // this is critical
                                 @"modestbranding" : @1
                                 };
    //[self. playerView loadWithPlaylistId:@"PLNT1r49jsn3niUNZcxO1Vyj86oxuxmi7R"];//playlist id
    
    [self.playerView loadWithVideoId:m_strVideoUrl playerVars:playerVars];
    [self.playerView playVideo];
    
    [_playerViewContinueBtn setFrame:CGRectMake(_playerViewContinueBtn.frame.origin.x, _playerViewContinueBtn.frame.origin.y-10, _playerViewContinueBtn.frame.size.width, _playerViewContinueBtn.frame.size.height+10)];
    
     [_playerViewContinueBtn setTitle:@"Continue" forState:UIControlStateNormal];
     //[_playerViewContinueBtn setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
     [_playerViewContinueBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    _playerViewContinueBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(13)];
    [_playerViewContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _playerViewContinueBtn.layer.cornerRadius = 4.0f;
    _playerViewContinueBtn.clipsToBounds = YES;
    [_playerViewContinueBtn addTarget:self action:@selector(continueBtnHideAction) forControlEvents:UIControlEventTouchUpInside];
   

}
-(void)continueBtnHideAction{
   
    [self getOnDemandAppsForUser];
    
    //[_playerBgView removeFromSuperview];
//    [downloadView setBackgroundColor:[UIColor whiteColor]];
   // [[NSUserDefaults standardUserDefaults] setObject:@"isVideoPlayed" forKey:DEMO_VIDEO_PLAYED];
  //  [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)continueActionForAppPage{
    
    isVideoClosed =NO;
    isiPhoneViewPage=NO;
    [_playerBgView setHidden:YES];
    [_playerBgView removeFromSuperview];
    [downloadView setHidden:NO];
    [[NSUserDefaults standardUserDefaults] setObject:@"isVideoPlayed" forKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


#pragma mark - getOnDemandAppsForUser
-(void)getOnDemandAppsForUser{
    [iPhoneView removeFromSuperview];
    
    [self.playerView stopVideo];
    [self.playerView setHidden:YES];
    [_playerBgView setHidden:NO];
    [downloadView setHidden:YES];
  
    isVideoClosed =YES;
    isiPhoneViewPage=YES;
    
    iPhoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _playerBgView.frame.size.width, _playerBgView.frame.size.height)];
    
    iPhoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    CGFloat topViewXPos;
    CGFloat topViewYPos;
    CGFloat topViewWidth;
    CGFloat topViewHeight;
       UIDevice* device = [UIDevice currentDevice];
    
    if([self isDeviceIpad]==YES){
        topViewWidth= _playerBgView.frame.size.width/2.2;
        topViewHeight = _playerBgView.frame.size.height/1.5;
        
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            
            topViewWidth= _playerBgView.frame.size.width/2.5;
        }

    }
    else{
        
        topViewWidth= _playerBgView.frame.size.width/1.7;
        topViewHeight = _playerBgView.frame.size.height/1.8;
        
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            
            topViewWidth= _playerBgView.frame.size.width/2.9;
            topViewHeight = _playerBgView.frame.size.height/1.6;
        }
    }
    
    topViewXPos = (_playerBgView.frame.size.width/2)-(topViewWidth/2);
    topViewYPos = _playerBgView.frame.size.height-topViewHeight;
   
    
    //[topImageView setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
    
    UIImageView *iPhoneIconImageView = [[UIImageView alloc]init]; //]WithFrame:CGRectMake(40, CGRectGetMaxY(titleLabel.frame)+10, _playerBgView.frame.size.width-80, _playerBgView.frame.size.height/2)];
                                        
    [iPhoneIconImageView setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
    [iPhoneIconImageView setImage:[UIImage imageNamed:@"iPhone_Icon"]];
    
    CGFloat titleLabelHeight = 80;
    CGFloat titleLabelYPos = 80;
    CGFloat titleLabelXPos = 8;
    
    CGFloat headerTitleXpos = 8;
    CGFloat headerTitleYpos = 0.0;
    
    CGFloat fontSize = 18;
    CGFloat headerTitleFontSize = 22;
    if(IS_IPHONE4||IS_IPHONE5){
        fontSize = 14;
        headerTitleFontSize = 20;
    }
    
    if([self isDeviceIpad]==YES){
        
        headerTitleYpos = 80;
        titleLabelXPos = 40;
        titleLabelYPos = 80;//iPhoneIconImageView.frame.origin.y-(titleLabelHeight*2);
        
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
           titleLabelYPos = iPhoneIconImageView.frame.origin.y-(titleLabelHeight*2);
        }
    }
    else{
         fontSize = 14;
         titleLabelYPos = 30;
         if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
              titleLabelYPos = 20;
              titleLabelYPos = 80;
         }
    }
    
    UILabel * headerTitle  = [[UILabel alloc]initWithFrame:CGRectMake(headerTitleXpos, 10,_playerBgView.frame.size.width-(titleLabelXPos*2) , 30)];
    headerTitle.text =@"App Setup Wizard";
    [headerTitle setTextColor:[UIColor whiteColor]];
    [headerTitle setBackgroundColor:[UIColor clearColor]];
    headerTitle.numberOfLines = 0;
    [headerTitle setFont:[COMMON getResizeableFont:Roboto_Bold(headerTitleFontSize)]];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    titleLabelYPos = CGRectGetMaxY(headerTitle.frame)+5;
    
    UILabel * titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelXPos, titleLabelYPos,_playerBgView.frame.size.width-(titleLabelXPos*2) , titleLabelHeight)];
    titleLabel.text =@"Now let's get your device set up for On Demand.\n Click continue to get started";
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.numberOfLines = 0;
    [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(fontSize)]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIButton* continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(_playerViewContinueBtn.frame.origin.x, _playerViewContinueBtn.frame.origin.y-10, _playerViewContinueBtn.frame.size.width, _playerViewContinueBtn.frame.size.height+10)];
   // [continueBtn setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [continueBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    
    [continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
    continueBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(13)];
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueBtn.layer.cornerRadius = 4.0f;
    continueBtn.clipsToBounds = YES;
    
    [continueBtn addTarget:self action:@selector(continueActionForAppPage) forControlEvents:UIControlEventTouchUpInside];
    
    [iPhoneView addSubview:headerTitle];
    [iPhoneView addSubview:titleLabel];
    [iPhoneView addSubview:continueBtn];
    [iPhoneView addSubview:iPhoneIconImageView];
    [_playerBgView addSubview:iPhoneView];
    
}

/* old code
-(void)continueBtnHideAction:(id)sender{
    [self.playerView stopVideo];
    
    [_playerBgView setHidden:YES];
    [_playerBgView removeFromSuperview];
    [downloadView setHidden:NO];
    //    [downloadView setBackgroundColor:[UIColor whiteColor]];
    [[NSUserDefaults standardUserDefaults] setObject:@"isVideoPlayed" forKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 */


- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    [self.playerView playVideo];
    
}

- (void) playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    switch (state) {
            
        case kYTPlayerStatePlaying:
            
            break;
            
        case kYTPlayerStateEnded:
            //new
        
            if(isVideoLinkTapped==NO){
                [_playerView setHidden:YES];
                [self continueBtnHideAction];
            }
        
            //old
            //[_playerBgView removeFromSuperview];
            //[downloadView setHidden:NO];
            //[[NSUserDefaults standardUserDefaults] setObject:@"isVideoPlayed" forKey:DEMO_VIDEO_PLAYED];
            //[[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
            
    }

}

#pragma mark - hideDownloadView
-(void)hideDownloadView{
    isAppListShown = NO;
    
    [arrayItems removeAllObjects];
    arrayItems = nil;
    [_appDownloadTableView setHidden:YES];
//    [_appDownloadCollectionView setHidden:YES];

    
    if([arrayItems count]==0){
        arrayItems = arrayItemsTemp;
    }
    //[self.tableView setHidden:NO];
    //[self.tableView reloadData];
    
    for(UIView *view in downloadView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIView");
        }
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
            NSLog(@"UITableView");
        }
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            NSLog(@"UIButton");
        }
        if ([view isKindOfClass:[_appDownloadTableView class]]) {
            [view removeFromSuperview];
            NSLog(@"UIGridView");
        }
        
    }
    
    for(UIView *view in _appDownloadTableView.subviews){
        if ([view isKindOfClass:[AppDownloadListCell class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIGridViewCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    [downloadView removeFromSuperview];
    [appHeaderScrollView removeFromSuperview];
    [appHeaderLabel removeFromSuperview];
    [_appDownloadTableView removeFromSuperview];
    [okDoneBtn removeFromSuperview];
    [_playerBgView setHidden:YES];
    [_playerView setHidden:YES];
    [_mainLeftBarButton setHidden:NO];
    [_searchButton setHidden:NO];
    [_searchButton setBackgroundColor:[UIColor clearColor]];
    [_searchButton setBackgroundImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    NSString *titleStr = headerLabelStr;
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.navigationItem.title = titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(15)],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
   
    //_tableView.tag = 100;
    isAppListFirstTimeHidden =YES;
    isDownloadAppViewHidden=YES;
    iPhoneCellHeight = 160;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    nCellWidth = screenWidth / nColumCount;
    nCellHeight = screenWidth / nColumCount;
    
   // [onDemandSliderView setHidden:NO];
//    [self.tableView reloadData];
//    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//    
//    if([arrayItems count]==0){
//        NSString *strID = @"1";//150
//        [self updateShowData:[strID intValue]];
//    }
    
}
#pragma mark - switch flip action
- (IBAction) flip: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    if (onoff.on){
        
        //not installed
        //isInstalledClicked=NO;
        //appTitleArray=notInstalledArray;
        if([appTitleArray count]==0){
           // appTitleFullArray = appTitleArray;
        }
        [_appDownloadTableView reloadData];
//        [_appDownloadCollectionView reloadData];
        [installedLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
        [notIntalledLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    }
    else {
        //installed
        //isInstalledClicked=YES;
        //installedArray=appTitleArray;
        //[self loadAppInstalledListArrayBundleIdentifier];
        
        [installedLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
        [notIntalledLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
       // [sender setThumbTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    }
}

#pragma mark -  loadAppInstalledListArraySlugName
-(void) loadAppInstalledListArraySlugName{
    appInstalledArray = [NSMutableArray new];
    NSString *boolString;
    for(NSMutableDictionary * anEntry in appTitleArray)
    {
        NSMutableDictionary * temp1;
        //NSString * url = [anEntry objectForKey:@"package"];//@"dramafeverhd";//dramafever-premium";//
        
        NSString * slug = [anEntry objectForKey:@"slug"];
        slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
        if([slug isEqualToString:@"a-e:"]){
           slug =  @"aetvplus:";
        }
        if([slug isEqualToString:@"cartoon-network:"]){
            slug =  @"cartoonnetwork:";
        }
        
        BOOL isOpen = [COMMON checkInstalledApplicationInApp:slug];
        
        if(isOpen ==YES){
            isInstalledClicked = YES;
            boolString = @"YES";
            temp1 = [NSMutableDictionary new];
            temp1=[anEntry mutableCopy];
            [temp1 setObject:boolString forKey:@"isInstalled"];
            [temp1 setObject:slug forKey:@"bundleIdentifier"];
        }
        else{
            isInstalledClicked = NO;
            boolString = @"NO";
            temp1 = [NSMutableDictionary new];
            temp1=[anEntry mutableCopy];
            [temp1 setObject:@"NO" forKey:@"isInstalled"];
            [temp1 setObject:slug forKey:@"bundleIdentifier"];
        }
        
        if((temp1!= nil)&&(temp1.count!=0))
            [appInstalledArray addObject:temp1];
    }
    appTitleArray=[appInstalledArray mutableCopy];
    
    appListArrayItems=[appInstalledArray mutableCopy];
    [_appDownloadTableView reloadData];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}

-(BOOL)checkInstalledApplicationInApp:(NSString*)urlStr{
    
    NSURL* linkUrl = [NSURL URLWithString:urlStr];
    
    if([[UIApplication sharedApplication] canOpenURL:linkUrl] ){
            return YES;
    }
    
    else{
         return NO;
    }

}



#pragma mark - getAppsListData

-(void)getAppsCategoryData {
    
    int nDeviceID = [[NSString stringWithFormat:@"%d",8] intValue];
    
    categoryListArray  =[[NSMutableArray alloc] init];
    tempTitleArray = [[NSMutableArray alloc] init];

    tempTitleArray = [[COMMON retrieveContentsFromFile:APP_CATEGORY dataType:DataTypeArray] mutableCopy];
    
    if ([tempTitleArray count] == 0) {
        [[RabbitTVManager sharedManager] getAppsCategory:^(AFHTTPRequestOperation *request, id responseObject){
            tempTitleArray = [responseObject mutableCopy];
            
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        } nDeviceId:nDeviceID];

    }
    
        for(int i=0;i<[tempTitleArray count];i++) {
            NSArray *temp = [tempTitleArray objectAtIndex:i];
            NSString *titleString = [temp valueForKey:@"name"];
            if([titleString isEqualToString:@"* Recommended"])
                [ categoryListArray insertObject:temp  atIndex:0];
            [categoryListArray addObject:temp];
        }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:categoryListArray];
    NSArray *HMTitleArray = [[orderedSet array] mutableCopy];
    
    tempTitleArray = [(NSMutableArray *)HMTitleArray mutableCopy];
    categoryListArray = [tempTitleArray mutableCopy];
    
    headerTitleArray = [[tempTitleArray mutableCopy] valueForKey:@"name"];
    
    if([COMMON isSpanishLanguage]==YES){
        NSMutableArray *tempArray = [NSMutableArray new];
        tempArray = [[COMMON retrieveContentsFromFile:APP_MANAGER_TOP_MENU dataType:DataTypeArray] mutableCopy];
        
        if ([tempArray count] == 0) {
            [self getStaticTranslatedWordList:APP_MANAGER_TOP_MENU currentStaticArray:(NSMutableArray*)headerTitleArray];
            tempArray = [[COMMON retrieveContentsFromFile:APP_MANAGER_TOP_MENU dataType:DataTypeArray] mutableCopy];
            headerTitleArray =(NSArray *)tempArray;
            
        }
        else{
            headerTitleArray =(NSArray *)tempArray;
        }

    }
    else{
        headerTitleArray = [tempTitleArray valueForKey:@"name"];
    }
    
    
    NSString *ID = [[tempTitleArray firstObject] valueForKey:@"id"];
    int categoryId = [ID intValue];
    
    if(isAppManagerMenu==YES){
        if([arrayItems count] != 0){
            [arrayItems removeAllObjects];
        }
        [self getAppsListData:nDeviceID forCategory:categoryId];
    }
    else{
        if([appListArrayItems count] != 0){
            [appListArrayItems removeAllObjects];
        }
        NSString *videoPlayed = [COMMON getDemoVideoPlayed];
        if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil) {
          [self getAppsListData:nDeviceID forCategory:categoryId];
        }
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

#pragma  mark - getAppsListData
-(void) getAppsListData:(int)deviceId
                forCategory:(int)categoryId{
    
    [COMMON LoadIcon:self.view];
    
    //[appTitleArray removeAllObjects];//hiden for timer method
    //[appListArrayItems removeAllObjects]; //hiden for timer method
    
//    if([appTitleArray count]== 0) {
    
        [[RabbitTVManager sharedManager] getAppsListCarouselsByCategory:^(AFHTTPRequestOperation *request, id responseObject) {
            
            [appTitleArray removeAllObjects];//hiden for timer method
            [appListArrayItems removeAllObjects];
            [appInstalledArray removeAllObjects];
            
            isGetAppsListDataClicked=YES;//carousel
             appTitleArray = [responseObject mutableCopy];//[[responseObject valueForKey:@"carousel"]mutableCopy];
            //appTitleFullArray = [responseObject mutableCopy];
           // appListArrayItems = [responseObject mutableCopy];//[[responseObject
            [self removalOfEmptyCarouselInAPPListArray];
            //[self loadAppInstalledListArray];
            
            //[_appDownloadTableView reloadData];
            [_appDownloadTableView setHidden:NO];
            [COMMON removeLoading];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
//            if(isTimerInAppManager==YES){
//                [self performSelector:@selector(reStartAppManagerTimerTable) withObject:nil afterDelay:3.0];
//                isTimerInAppManager=NO;
//            }
            
        } failureBlock:^(AFHTTPRequestOperation *request, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [COMMON removeLoading];
        } DeviceId:deviceId Category:categoryId];
 
//    }
//    else{
//        isGetAppsListDataClicked=YES;
//        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
//    }
    
    
}
#pragma mark - removalOfEmptyCarouselArray
-(void)removalOfEmptyCarouselInAPPListArray{
    BOOL IsEmptyAvailable;
    NSMutableArray *tempArray = [NSMutableArray new];
    NSMutableArray *tempTopTitleCarouselArray = [NSMutableArray new];
    tempArray = [appTitleArray mutableCopy] ;
    for (int i=0;i<[tempArray count];i++) {
        NSMutableArray * tempCarouselArray = [[[tempArray mutableCopy] objectAtIndex:i] mutableCopy];
        NSMutableArray * itemsTempArray = [[[[tempCarouselArray mutableCopy] valueForKey:@"carousel"]valueForKey:@"items"] mutableCopy];
          //NSMutableArray * itemsTempArray1 = [[[[tempCarouselArray mutableCopy] valueForKey:@"items"]objectAtIndex:i] mutableCopy];
        if([itemsTempArray count]==0){
            NSLog(@"EMPTY ");
            IsEmptyAvailable=YES;
        }
        else{
            IsEmptyAvailable=NO;
            [tempTopTitleCarouselArray addObject:[tempCarouselArray mutableCopy]];
        }
        
    }
    appTitleArray = [tempTopTitleCarouselArray mutableCopy];
    //NSLog(@"ITEMS FINAL %@-->",tempTopTitleCarouselArray);
    if(appTitleArray!=nil){
         [self loadAppInstalledListArraySlugName];
    }
   
    
}
#pragma mark - setUpFont
-(void)setUpFont{
   
    NSString *strDropDownArrow= [NSString stringWithFormat:@"%@", @" \uf0d7"]; // sort  \f0dc fa-caret-down "\f0d7" //\f107
    
    NSString *strBackArrow = [NSString stringWithFormat:@"%@", @" \uf177"]; //back Arrow
    
    attrRoboFontDict = @{
                         NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(10)],
                         NSForegroundColorAttributeName : [UIColor whiteColor]
                                       };
    attrAweSomeDict = @{
                        NSFontAttributeName : [UIFont fontWithName:@"FontAwesome" size:17],
                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                      };
    aweAttrString = [[NSMutableAttributedString alloc] initWithString:strDropDownArrow attributes:attrAweSomeDict];
    
    aweBackArrowAttrString = [[NSMutableAttributedString alloc] initWithString:strBackArrow attributes:attrAweSomeDict];
}
#pragma mark - setUpViews
-(void) setUpViews{
    
     self.tvMovieView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]];
    //[_tvMovieView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]]];
    
  
    if ((NSString *)[NSNull null] == tvShowStr) {
        if (tvShowStr == nil) {
            tvShowStr=@"";
        }
    }
    
    NSString *strNetwork=@"Select Networks";
    NSString *strAllFree=@"ALL";
    NSString *strTvShows = @"TV Shows";
    
    if([COMMON isSpanishLanguage]==YES){
        strTvShows = [COMMON getTvShowsStr];
        if ((NSString *)[NSNull null] == strTvShows||strTvShows == nil) {
            strTvShows = @"TV Shows";
            strTvShows =  [COMMON stringTranslatingIntoSpanish:strTvShows];
            [[NSUserDefaults standardUserDefaults] setObject:strTvShows forKey:TV_SHOWS];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strTvShows attributes:attrRoboFontDict];
    NSMutableAttributedString *roboAttrString1 = [[NSMutableAttributedString alloc]initWithString:strNetwork attributes:attrRoboFontDict];
    NSMutableAttributedString *roboAttrString2 = [[NSMutableAttributedString alloc]initWithString:strAllFree attributes:attrRoboFontDict];
    [roboAttrString appendAttributedString:aweAttrString];
    [roboAttrString1 appendAttributedString:aweAttrString];
    [roboAttrString2 appendAttributedString:aweAttrString];
    
    _tvListLabel.attributedText = roboAttrString;
    _tvNetworkListLabel.attributedText = roboAttrString1;
    tvShowLabel.attributedText = roboAttrString;
    _allFreeListLabel.attributedText = roboAttrString2;
   
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        [self.tvListLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
//        [self.tvNetworkListLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
//
//    }
//    else{
//        [self.tvListLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.tvNetworkListLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    }
    
    [tvShowLabel setBackgroundColor:[UIColor clearColor]];
    [_tvListLabel setBackgroundColor:[UIColor clearColor]];
    [_tvNetworkListLabel setBackgroundColor:[UIColor clearColor]];
   
    UITapGestureRecognizer *tvListLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mySelectorTvShow:)];
    tvListLabelTap.numberOfTapsRequired = 1;
    tvListLabelTap.numberOfTouchesRequired = 1;
    [_tvListLabel addGestureRecognizer:tvListLabelTap];
    [_tvListLabel setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myMovieSelector:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [tvShowLabel addGestureRecognizer:tapRecognizer];
    [tvShowLabel setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tvNetworkListLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mySelectorNetwork:)];
    tvNetworkListLabelTap.numberOfTapsRequired = 1;
    tvNetworkListLabelTap.numberOfTouchesRequired = 1;
    [_tvNetworkListLabel addGestureRecognizer:tvNetworkListLabelTap];
    [_tvNetworkListLabel setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *allFreeListLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myAllFreeAction:)];
    allFreeListLabelTap.numberOfTapsRequired = 1;
    allFreeListLabelTap.numberOfTouchesRequired = 1;
    [_allFreeListLabel addGestureRecognizer:allFreeListLabelTap];
    [_allFreeListLabel setUserInteractionEnabled:YES];
    
    //[self setUpBorder];
    //_tvNetworkListLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
}
#pragma mark - setUpBorder
-(void) setUpBorder{
    //Bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.tvListLabel.frame.size.height - 1, self.tvListLabel.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvListLabel.layer addSublayer:bottomBorder];
    //Bottom border
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.tvListLabel.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvListLabel.layer addSublayer:topBorder];
    
    //right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.tvListLabel.frame.size.width-1, 0.0f, 1.0f, self.tvListLabel.frame.size.height);
    rightBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvListLabel.layer addSublayer:rightBorder];
    //left border
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f,0.0f, 1.0f, self.tvListLabel.frame.size.height);
    leftBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvListLabel.layer addSublayer:leftBorder];
    
    //Bottom border _tvNetworkListLabel
    CALayer *bottomTvNetwork = [CALayer layer];
    bottomTvNetwork.frame = CGRectMake(0.0f, self.tvNetworkListLabel.frame.size.height - 1, self.tvNetworkListLabel.frame.size.width, 1.0f);
    bottomTvNetwork.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvNetworkListLabel.layer addSublayer:bottomTvNetwork];
    
    //right border
    CALayer *rightTvNetwork = [CALayer layer];
    rightTvNetwork.frame = CGRectMake(self.tvNetworkListLabel.frame.size.width-1, 20.0f, 1.0f, self.tvNetworkListLabel.frame.size.height-20);
    rightTvNetwork.backgroundColor = [UIColor whiteColor].CGColor;
    [_tvNetworkListLabel.layer addSublayer:rightTvNetwork];
    
    //Bottom border tvShowLabel
    CALayer *bottomTvShow = [CALayer layer];
    bottomTvShow.frame = CGRectMake(0.0f, self.tvShowLabel.frame.size.height - 1, self.tvShowLabel.frame.size.width, 1.0f);
    bottomTvShow.backgroundColor = [UIColor whiteColor].CGColor;
    [tvShowLabel.layer addSublayer:bottomTvShow];
    
    //right border
    CALayer *rightTvShow = [CALayer layer];
    rightTvShow.frame = CGRectMake(self.tvShowLabel.frame.size.width-1, 20.0f, 1.0f, self.tvShowLabel.frame.size.height-20);
    rightTvShow.backgroundColor = [UIColor whiteColor].CGColor;
    [tvShowLabel.layer addSublayer:rightTvShow];
}

#pragma mark - loadNewPopUp
-(void) loadNewPopUp{
    
    [showPopUpInnerView removeFromSuperview];
    [showPopUpView removeFromSuperview];
    showPopUpInnerView = nil;
    showPopUpView = nil;

    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE LAND
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            //230
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-60)];
            iPhoneLandScape =YES;
        }
        //IPAD LAND
        else{
            
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-180, self.view.frame.size.height-200)];
//             showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, self.view.frame.size.height-250)];
        }
        
    }else{
        //IPHONE PORT
        int iPhoneHeight=0;
        if(IS_IPHONE4||IS_IPHONE5){
            iPhoneHeight =230;
        }
        else if(IS_IPHONE6_Plus){
            iPhoneHeight =300;
        }
        else{
            iPhoneHeight =285;
        }
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, self.view.frame.size.height-iPhoneHeight)];//140
            iPhoneLandScape =NO;

        }
        //IPAD PORT
        else{
            
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-480)];
        }
    }
    
    [showPopUpInnerView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    [self setUpAppListViewContainer];
}

-(void)setUpAppListViewContainer{

    UIView* viewContainer;
    UILabel* labelTitle;
    UILabel* labelDescription;
    UIImageView* imageThumbnail;
    UILabel* labelVideoName;
    
    
    CGFloat buttonHeight,labelTitleXPos,labelTitleYPos,labelDescriptionXPos,labelTitleHeight,labelDescriptionHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        labelTitleXPos =30;
        labelTitleYPos =40;
        labelDescriptionXPos=30;
        labelTitleHeight = 40;
        labelDescriptionHeight= 50;
        buttonHeight =60;
        //imageThumbnailHeight=viewContainer.frame.size.height/3;
    }
    else{
        if(IS_IPHONE4||IS_IPHONE5){
           labelTitleHeight = 20;
        }
        else{
            labelTitleHeight = 30;
        }
        labelDescriptionHeight= 40;
        labelTitleXPos =10;
        labelTitleYPos =5;
        labelDescriptionXPos=10;
        buttonHeight =40;
    }
    viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, showPopUpInnerView.frame.size.width, showPopUpInnerView.frame.size.height)];
    
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelTitleXPos, labelTitleYPos, viewContainer.frame.size.width-(labelTitleXPos*2), labelTitleHeight)];
    [labelTitle setText:@"Connecting to App Store..."];
    [labelTitle setTextColor:[UIColor whiteColor]];
    if([self isDeviceIpad]==YES){
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(25)]];
 
    }
    else{
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(16)]];
  
    }
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    
    labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(labelDescriptionXPos, labelTitle.frame.origin.y+labelTitle.frame.size.height+5, viewContainer.frame.size.width-(labelDescriptionXPos*2), labelDescriptionHeight)];
    
    NSString *labelDescriptionStr= [NSString stringWithFormat:@"%@ requires you to download their app to watch their content.",currentAppName];
    labelDescription.numberOfLines = 0;
    [labelDescription setText:labelDescriptionStr];
    [labelDescription setTextColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f]];
    [labelDescription setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [labelDescription setTextAlignment:NSTextAlignmentLeft];
    labelDescription.numberOfLines = 0;
    
    CGFloat imageThumbnailXPos, imageThumbnailYPos,imageThumbnailHeight;
    
    if([self isDeviceIpad]==YES){
        imageThumbnailXPos = labelDescription.frame.origin.x +40;
        imageThumbnailYPos = labelDescription.frame.origin.y +labelDescription.frame.size.height+40;
        imageThumbnailHeight = viewContainer.frame.size.width/4;
    }
    else{
        imageThumbnailXPos = labelDescription.frame.origin.x +5;
        if(iPhoneLandScape==YES){
            imageThumbnailYPos = labelDescription.frame.origin.y +labelDescription.frame.size.height+5;
            imageThumbnailHeight = viewContainer.frame.size.height/2.5;

        }
        else{
            imageThumbnailYPos = labelDescription.frame.origin.y +labelDescription.frame.size.height+30;
            imageThumbnailHeight = viewContainer.frame.size.width/4;

        }
    }
    
    imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(imageThumbnailXPos, imageThumbnailYPos, viewContainer.frame.size.width/4,imageThumbnailHeight)];
    [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
    if ((NSString *)[NSNull null] == currentAppImage||currentAppImage == nil) {
        currentAppImage=@"";
    }
    if([currentAppImage containsString:@".png" ]|| [currentAppImage containsString: @".jpeg"]|| [currentAppImage containsString: @".jpg" ]){
        NSURL *imageNSURL = [NSURL URLWithString:currentAppImage];
        [imageThumbnail setImageWithURL:imageNSURL placeholderImage:[UIImage imageNamed:@"white_Bg"]];//white_Bg
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imageWebp = [NSString stringWithFormat:@"%@image.webp",currentCarouselID];
        NSString *webPPath = [paths[0] stringByAppendingPathComponent:imageWebp];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:webPPath]){
            [imageThumbnail setImage:[UIImage imageWithWebP:webPPath]];
            
        } else {
            
            NSURL *imageURL = [NSURL URLWithString:currentAppImage];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if ([imageData writeToFile:webPPath atomically:YES]) {
                uint64_t fileSize;
                fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:webPPath error:nil] fileSize];
                [UIImage imageWithWebP:webPPath completionBlock:^(UIImage *result) {
                    [imageThumbnail setImage:result];
                }failureBlock:^(NSError *error) {
                    NSLog(@"error%@", error.localizedDescription);
                    [imageThumbnail setImage:[UIImage imageWithWebP:webPPath]];
                }];
            }
        }
    }
    
    CGFloat labelVideoNameXPos,labelVideoNameYPos,labelVideoNameHeight,labelVideoNameWidth;
    
    if([self isDeviceIpad]==YES){
        labelVideoNameXPos = imageThumbnail.frame.origin.x +imageThumbnail.frame.size.width +30;
        labelVideoNameHeight = imageThumbnail.frame.size.height/2;
        labelVideoNameWidth = viewContainer.frame.size.width/2;
        labelVideoNameYPos = imageThumbnail.frame.origin.y+20;
    }
    else{
        labelVideoNameXPos = imageThumbnail.frame.origin.x +imageThumbnail.frame.size.width +10;
        labelVideoNameWidth = viewContainer.frame.size.width - labelVideoNameXPos;
        labelVideoNameYPos = imageThumbnail.frame.origin.y;
        if(iPhoneLandScape==YES){
            labelVideoNameHeight = imageThumbnail.frame.size.height;
        }
        else{
            labelVideoNameHeight = imageThumbnail.frame.size.height;
        }
        
    }
    labelVideoName = [[UILabel alloc] initWithFrame:CGRectMake(labelVideoNameXPos,labelVideoNameYPos, labelVideoNameWidth , labelVideoNameHeight)];
    labelVideoName.numberOfLines = 0;
    
    NSString *noteWithAppName= [NSString stringWithFormat:@"Note: After have downloaded the %@ app, please return to our app to continue.",currentAppName];
    labelVideoName.attributedText = [self setAttributedTextForAppNote:noteWithAppName];
    [labelVideoName setTextAlignment:NSTextAlignmentLeft];
    
    CGFloat cancelBtnXPos,cancelBtnYPos;
    int fontSize;
    if(iPhoneLandScape==YES){
        cancelBtnXPos =20;
        cancelBtnYPos = imageThumbnail.frame.origin.y+imageThumbnail.frame.size.height+10;
        fontSize =13;
    }
    else{
        cancelBtnXPos=10;
         if([self isDeviceIpad]==YES){
             cancelBtnYPos = imageThumbnail.frame.origin.y+imageThumbnail.frame.size.height+60;
         }else
             cancelBtnYPos = imageThumbnail.frame.origin.y+imageThumbnail.frame.size.height+30;
        
        fontSize=10;
    }
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtnXPos, cancelBtnYPos, (viewContainer.frame.size.width/2)-cancelBtnXPos, buttonHeight)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    
    [cancelBtn addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat installBtnXPos = cancelBtn.frame.origin.x+cancelBtn.frame.size.width+5;
    UIButton* installBtn = [[UIButton alloc] initWithFrame:CGRectMake(installBtnXPos, cancelBtnYPos,cancelBtn.frame.size.width-5, buttonHeight)];
    [installBtn setBackgroundImage:[UIImage imageNamed:@"installBtnImage.png"] forState:UIControlStateNormal];
    NSString *installBtnStr= [NSString stringWithFormat:@"INSTALL %@",currentAppName];
    [installBtn setTitle:installBtnStr forState:UIControlStateNormal];
    [installBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    installBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    [installBtn addTarget:self action:@selector(installAction) forControlEvents:UIControlEventTouchUpInside];
    
    //[self performSelector:@selector(installAction) withObject:nil afterDelay:5.0];
    
    [viewContainer addSubview:labelTitle];
    [viewContainer addSubview:labelDescription];
    [viewContainer addSubview:imageThumbnail];
    [viewContainer addSubview:labelVideoName];
    [viewContainer addSubview:cancelBtn];
    [viewContainer addSubview:installBtn];
    
    [showPopUpInnerView addSubview:viewContainer];
    showPopUpView.delegate = self;
    [showPopUpView setContainerView:showPopUpInnerView];
    [showPopUpView show];
    bAppPopUpShown= true;
    isPopUpClicked = true;

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [showPopUpView addGestureRecognizer:tapGestureRecognizer];
    showPopUpView.userInteractionEnabled = YES;
}
#pragma mark - tapActions
- (void)tapOnPopUpView:(UITapGestureRecognizer *)tap {
    //UIView *currentView = (UIView*)tap.view;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self dismissPopup];
    bAppPopUpShown =false;
    isPopUpClicked = false;
    
    [showPopUpView removeFromSuperview];
    [showPopUpView close];
    showPopUpView = nil;
    
}

#pragma mark - dismissPopup
-(void)dismissPopup {

    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [showPopUpView close];
    [showPopUpView removeFromSuperview];
    showPopUpView = nil;
    isAppListShown=YES;
    isPopUpClicked = false;
    bAppPopUpShown=false;
    isAddActionCalled=NO;
    //[_appDownloadTableView reloadData];
    
}
#pragma mark - setAttributedTextForAppNote
-(NSMutableAttributedString *)setAttributedTextForAppNote:movieString{
    
    NSString *noteWithAppName= [NSString stringWithFormat:@"After have downloaded the %@ app, please",currentAppName];
    
    NSDictionary *attributes = @ {NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)] };
    NSDictionary *attributes1 = @ {NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Regular(14)]};
    NSDictionary *attributes2 = @ {NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Regular(14)]};
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:movieString];
    [attStr addAttributes:attributes  range:[movieString rangeOfString:@"Note: "]];
    [attStr addAttributes:attributes1 range:[movieString rangeOfString:noteWithAppName]];
    [attStr addAttributes:attributes2 range:[movieString rangeOfString:@"return to our app"]];
    [attStr addAttributes:attributes1 range:[movieString rangeOfString:@" to continue."]];
    
    return attStr;
}
#pragma mark - loadPopuUpWithImageDetails
-(void)loadPopuUpWithImageDetails{
    UIScrollView *popUpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, showPopUpInnerView.frame.size.width-(closePopUpBtn.frame.size.width), showPopUpInnerView.frame.size.height)];
    
    popUpScroll.bounces= NO;
    popUpScroll.directionalLockEnabled =YES;
    
    UIImageView *networkImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,20,100, 100)];
    UILabel *overViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(networkImage.frame.size.width+20+15, 20, showPopUpInnerView.frame.size.width-(closePopUpBtn.frame.size.width)-30, 30)];
    overViewLabel.text = @"OVERVIEW";
    overViewLabel.textAlignment = NSTextAlignmentLeft;
    [overViewLabel setTextColor:[UIColor whiteColor]];
    [overViewLabel setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
    
    //CGFloat networkImageYPos = overViewLabel.frame.origin.y+overViewLabel.frame.size.height;
    
    CGFloat despLabelXPos = networkImage.frame.origin.x+networkImage.frame.size.width+15;
    CGFloat despLabelYPos = overViewLabel.frame.origin.y+overViewLabel.frame.size.height+10;
    UILabel *despLabel = [[UILabel alloc] initWithFrame:CGRectMake(despLabelXPos,despLabelYPos , (showPopUpInnerView.frame.size.width-despLabelXPos),150 )];//(showPopUpInnerView.frame.size.height/3)-(networkImageYPos+50)
    despLabel.textAlignment = NSTextAlignmentLeft;
    //CGFloat despLabelHeight = despLabel.frame.size.height;
    [despLabel setTextColor:[UIColor whiteColor]];
    [despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    despLabel.numberOfLines =0;
    
    CGFloat networkTableYPos = despLabelYPos+networkImage.frame.origin.y+networkImage.frame.size.height+5;
    UIGridView * networkTable = [[UIGridView alloc] initWithFrame:CGRectMake(0,networkTableYPos,popUpScroll.frame.size.width,(popUpScroll.frame.size.height-networkTableYPos))];
    
    networkTable.uiGridViewDelegate = self;
    networkTable.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    
    networkTable.bounces = NO;
    networkTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    networkTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    CGFloat networkTableWidth = popUpScroll.frame.size.width-20;

    nCellWidth = networkTableWidth / nColumCount;
    nCellHeight = 150;//appDownloadTableViewWidth / nColumCount;
    if(didSelectedDict.count==0){
        CGRect frame = networkTable.frame;
        frame.origin.y = networkImage.frame.origin.y;
        networkTable.frame = frame;
        [self.view layoutIfNeeded];
    }
    NSString* appImageUrl = didSelectedDict[@"image"];
    NSString* appDescp      = didSelectedDict[@"description"];
    
    //NSString* appID = didSelectedDict[@"id"];
    
    if ((NSString *)[NSNull null] == appImageUrl) {
        appImageUrl=@"";
    } else {
        if (appImageUrl == nil) {
            appImageUrl=@"";
        }
    }
    if ((NSString *)[NSNull null] == appDescp) {
        appDescp=@"";
    } else {
        if (appDescp == nil) {
            appDescp=@"";
        }
    }
    

    NSURL *imageNSURL = [NSURL URLWithString:appImageUrl];
    [networkImage setImageWithURL:imageNSURL];// placeholderImage:[UIImage imageNamed:@"white_Bg"]];
    
    despLabel.text = [NSString stringWithFormat:@"%@",appDescp];
    
    isAppListShown = NO;
   
    isMovieListData=NO;
   
    [networkTable reloadData];
    [networkTable setScrollEnabled:NO];
    CGRect frame = networkTable.frame;
    frame.size.height = networkTable.contentSize.height;
    networkTable.frame = frame;
    [self.view layoutIfNeeded];
    

    [popUpScroll addSubview:overViewLabel];
    [popUpScroll addSubview:networkImage];
    [popUpScroll addSubview:despLabel];
    [popUpScroll addSubview:networkTable];
    
    [showPopUpInnerView addSubview:popUpScroll];
    [networkTable reloadData];
    
    CGFloat scrollContentHeight;
    if(didSelectedDict.count!=0) {
       scrollContentHeight = networkTable.contentSize.height + networkImage.frame.size.height+100;
    }else {
       scrollContentHeight = networkTable.contentSize.height+50;
    }
    [popUpScroll setContentSize:CGSizeMake(showPopUpInnerView.frame.size.width, scrollContentHeight)];
     [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

}


#pragma mark - extractDayFromDate
-(NSString *) extractDayFromDate {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    return [[calender weekdaySymbols] objectAtIndex:([component weekday]-2)];
    
}
- (NSString *) convertDateToDateString :(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"hh mm" options:0 locale:locale];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:locale];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(void)loadPrimeViewAll:(int)nID{
    

     //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager]getWholeViewAll:^(AFHTTPRequestOperation * request, id responseObject) {
        isCarouselImage=YES;
        isPosterImage=NO;
        isThumbnailImage=NO;
        arrayItems = [responseObject mutableCopy];
        [self.tableView reloadData];
        [_tableView setHidden:NO];
       
        NSLog(@"PRIME%@-->",responseObject);
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
       
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nID:nID nPPV:nPPV];
    
}


-(void) loadWebOriginalData{
    [COMMON LoadIcon:self.view];

    [self.tableView setHidden:YES];
    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        [self.tableView reloadData];
    }
    //int nPPV =PAY_MODE_ALL;
    int nPPV = commonPPV;
    
    [[RabbitTVManager sharedManager] getWebOriginalCarouselData:^(AFHTTPRequestOperation * request, id responseObject) {
        webCarouselArray =[NSMutableArray new];
        webCarouselArray = responseObject;
        NSMutableArray * dataArray = [webCarouselArray objectAtIndex:0];
        
        
        isCarouselImage=YES;
        isPosterImage=NO;
        isThumbnailImage=NO;
        arrayItems = [[dataArray valueForKey:@"items"] mutableCopy];
        [_tableView setHidden:NO];
        [self.tableView reloadData];
        [COMMON removeLoading];
       
       
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [_tableView setHidden:YES];
        //[AppCommon showSimpleAlertWithMessage:@"No Data"];
       
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }nPPV:nPPV];
}


#pragma mark - removeKidsArrayValues
-(void)removeOnDemandKidsArrayValues {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [webCarouselArray mutableCopy] ;
    for (int i=0;i<tempArray.count;i++) {
        NSString *string = [[[tempArray valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string containsString:@"Games"]){
            [webCarouselArray removeObjectAtIndex:i];
        }
    }
}


-(void)loadSportsData{
    [COMMON LoadIcon:self.view];

    [_tableView setHidden:NO];

    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        [self.tableView reloadData];
        
    }
    nCategory = 5;
    //int nPPV =PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager] getSportsData:^(AFHTTPRequestOperation * request, id responseObject) {
        sportsDataArray = [responseObject mutableCopy];
        NSMutableArray * dataArray = [sportsDataArray objectAtIndex:0];
        arrayItems = [[dataArray valueForKey:@"items"] mutableCopy];
        [_tableView setHidden:NO];
        [self.tableView reloadData];
        [COMMON removeLoading];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [_tableView setHidden:YES];
        //[AppCommon showSimpleAlertWithMessage:@"No Data"];
       
        [COMMON removeLoading];

    }nPPV:nPPV];
}


#pragma mark - myMovieSelector Action
- (void)myMovieSelector:(UILabel *)myLabel
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
//    if(isClickedNetwork==YES){
//        [self myNetworkLeftMenuData];
//    }
    if(isClickedNetworkBackOptions==YES){
        nCategory = CATEGORY_NETWORK;
        [tvShowLabel setHidden:YES];
        isClickedNetworkBackOptions=NO;
        [networkView setHidden:YES];
        [networkTableView setHidden:YES];
        if([currentScrollTitle isEqualToString:@"Featured"]){
        //if([commonType isEqualToString:@"N"]||[commonType isEqualToString:@"network"]){
                nCategory = CATEGORY_NETWORK;
                isMovieType=NO;
                isNetworkViewAll = YES;
                [self loadSliderViewAllDataWithViews];
        }
        else{
             [self loadAllNewtorksList];
        }
    }
}

#pragma mark - mySelectorTvShow Action
- (void)mySelectorTvShow:(UILabel *)myLabel
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[RabbitTVManager sharedManager]cancelRequest];
    if(isClickedPrime==YES){
       
        [self myPrimeLeftMenuData];
        isClickedPrimeLeftMenu =YES;
        isClickedPrimeRightMenu = NO;

    }
    if(isClickedTv==YES){
         [self myTvShowMenuData];//NEW
    }
    else if(isClickedMovie==YES){
        [self myMoviesMenuData];//NEW
    }
}
#pragma mark - myNetworkMenuData
-(void) myNetworkLeftMenuData{
    
    if(dropDownTvNetworkArray == nil) return;
    m_ArrayChannels =  dropDownTvNetworkArray;
    isOnTvShowClick = false;
    isOnNetworksClick = true;
    isPayPerView=NO;
    isNetworksView=NO;
    
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = true;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
}


#pragma mark - myTvShowMenuData
-(void)myTvShowMenuData{
    if(dropDownTvShowStaticArray == nil) return;
    m_ArrayChannels =  dropDownTvShowStaticArray;
    isOnTvShowClick = true;
    isOnNetworksClick = false;
    isPayPerView=NO;
    isNetworksView=NO;
    isMovieListData=NO;
    //_tvNetworkListLabel.text = @"Select Networks";
//    NSMutableAttributedString *roboAttrString1 = [[NSMutableAttributedString alloc]initWithString:@"Select Networks" attributes:attrRoboFontDict];
//    [roboAttrString1 appendAttributedString:aweAttrString];
//    _tvNetworkListLabel.attributedText = roboAttrString1;
    
    bTvMenuShown = true;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];

}

#pragma mark - myMoviesMenuData
-(void)myMoviesMenuData{
    if(dropDownMoviesStaticArray == nil) return;
    m_ArrayChannels =  dropDownMoviesStaticArray;
    isOnMoivesClick = true;
    isOnMoivesGenreClick = false;
    isOnMoivesRatingClick= false;
    
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = true;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    
    [self loadDropTable];
    
}


#pragma mark - myPrimeLeftMenuData
-(void)myPrimeLeftMenuData{
    if(primeWeekDayArray == nil) return;
    m_ArrayChannels =  primeWeekDayArray;

    NSMutableAttributedString *roboAttrString1 = [[NSMutableAttributedString alloc]initWithString:@"WeekDay" attributes:attrRoboFontDict];
    [roboAttrString1 appendAttributedString:aweAttrString];
    _tvNetworkListLabel.attributedText = roboAttrString1;
    bTvMenuShown = false;
    bPrimeLeftMenuShown = true;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
    
}




//NEW
#pragma mark - mySelectorNetwork Action
- (void)mySelectorNetwork:(UILabel *)myLabel
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[RabbitTVManager sharedManager]cancelRequest];
//    if(isClickedPrime==YES){
//        [self myPrimeRightMenuData];
//    }
    if(isClickedTvShowGenre==YES){
        [self myGenreMenuData];
    }else if(isClickedTvShowCategory==YES){
        [self myCategoryMenuData];
    }
    else if(isClickedTvShowDecade==YES){
        [self myDecadeMenuData];
    }
    else if(isClickedMoviesGenre==YES){
        [self myMovieGenreMenuData];
    }
    else if(isClickedMoviesRating==YES){
        [self myMovieRatingMenuData];
    }
    else if(isClickedTvShowNetwork==YES){
        [self myNetworkMenuData];
  
    }
}

-(void)myMovieGenreMenuData{
    if(dropDownNSArray == nil) return;
    m_ArrayChannels =  dropDownNSArray;
    isOnMoivesClick =NO;
    isOnMoivesGenreClick =YES;
    isOnMoivesRatingClick =NO;
    
    
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =true;
    bMovieMenuByRating =false;
    [self loadDropTable];
    
}
-(void)myMovieRatingMenuData{
    if(onDemandMoviesRating == nil) return;
    m_ArrayChannels =  onDemandMoviesRating;
    isOnMoivesClick =NO;
    isOnMoivesGenreClick =NO;
    isOnMoivesRatingClick =YES;
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =true;
    [self loadDropTable];
    
}


-(void)myDecadeMenuData{
    if(onDemandTvShowsDecades == nil) return;
    m_ArrayChannels =  onDemandTvShowsDecades;
    isOnTvShowClick = false;
    isOnNetworksClick = false;
    isOnGenreClick =false;
    isOnCategoryClick =false;
    isOnDecadeClick = true;
    isPayPerView=NO;
    isNetworksView=NO;

    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =true;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
    
}

-(void)myCategoryMenuData{
    if(onDemandTvShowsCategory == nil) return;
    m_ArrayChannels =  onDemandTvShowsCategory;
    isOnTvShowClick = false;
    isOnNetworksClick = false;
    isOnGenreClick =false;
    isOnCategoryClick =true;
    isOnDecadeClick = false;
    isPayPerView=NO;
    isNetworksView=NO;

    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =true;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
 
}
#pragma mark - myGenreMenuData
-(void) myGenreMenuData{
    
    if(dropDownTvShowArray == nil) return;
    m_ArrayChannels =  dropDownTvShowArray;
    isOnTvShowClick = false;
    isOnNetworksClick = false;
    isOnGenreClick =true;
    isOnCategoryClick =false;
    isOnDecadeClick = false;
    isPayPerView=NO;
    isNetworksView=NO;

    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =true;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
}

#pragma mark - myNetworkMenuData
-(void) myNetworkMenuData{
    
    if(dropDownTvNetworkArray == nil) return;
    m_ArrayChannels =  dropDownTvNetworkArray;
    isOnTvShowClick = false;
    isOnNetworksClick = true;
    isPayPerView=NO;
    isNetworksView=NO;

    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    bTvMenuByNetwork =true;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    [self loadDropTable];
}

#pragma mark - myAllFreeAction
- (void)myAllFreeAction:(UILabel *)myLabel
{
}
#pragma mark - loadDropTable
-(void) loadDropTable{
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            movieChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-260, self.view.frame.size.height-130)];
        }
        //IPAD
        else{
            movieChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-380, self.view.frame.size.height-300)];
        }
        
    }else{
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            movieChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, self.view.frame.size.height-180)];
        }
        //IPAD
        else{
            movieChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height-340)];
        }
    }
    if(isClickedPrime==YES){
        tableChannelList.tag = 102;
    }
    else if(isClickedMovie==YES){
        tableChannelList.tag = 201;
    }
    else if(isClickedNetwork==YES){
        tableChannelList.tag = 202;
    }
    else{
        tableChannelList.tag = 101;

    }
    tableChannelList.backgroundColor = [UIColor whiteColor];
    movieChannelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    [movieChannelView setContainerView:tableChannelList];
    [movieChannelView show];
}


#pragma mark - Table view data source

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [cell setBackgroundColor:[UIColor clearColor]];
//}
#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     if(tableView.tag==111){
         UIView *headerView;
         NSString *strChannelName;
         NSMutableDictionary *dictItem =  appListArrayItems[section];
         NSString *strTitleName = dictItem[@"name"];
         
         if([strTitleName isEqualToString:@""]||strTitleName==nil||(NSString *)[NSNull null]==strTitleName){
             strTitleName = @"";
         }
         
         NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[strChannelName dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                               NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                          documentAttributes:nil
                                                                       error:nil];
         strChannelName = [attr string];
         headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
         UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2,headerView.frame.size.width-10,30)];
         headerLabel.textAlignment = NSTextAlignmentLeft;
         headerLabel.text = strTitleName;
         [headerLabel setFont:[COMMON getResizeableFont:Roboto_Regular(17)]];
         headerLabel.textColor=[UIColor whiteColor];//BORDER_BLUE;
         headerLabel.backgroundColor = [UIColor clearColor];
         [headerView addSubview:headerLabel];
         return headerView;

     }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==200){
        return 40.0;
    }
    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(tableView.tag==200) {
        return appListArrayItems.count;
    }
    else if(tableView.tag==111) {
        return appListArrayItems.count;
    }else
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==111){
//        NSMutableDictionary *dictItem =  appListArrayItems[indexPath.section];
//        NSLog(@"dictItem%@-->",dictItem);
         NSLog(@"indexPath%ld-->",(long)[indexPath section]);
        if([appListArrayItems count]!=0){
            NSDictionary *cellData = [appListArrayItems objectAtIndex:[indexPath section]] ;
            NSArray *BlockData = [[cellData objectForKey:@"carousel"]objectForKey:@"items"];
            if([BlockData count]!=0){
                NSString *type =[[BlockData objectAtIndex:0]valueForKey:@"type"];
                if([type isEqualToString:@"M"]){
                    return 190.0;
                }
                else {
                    return 150.0;
                }
                
            }
            else{
                return 190.0;
            }
        }
        else{
            return 0.0;//190
        }
        
        //return 150.0;//195.0f

    }
    
    else if(tableView.tag==200)
        return 160.0;
    else
         return 40.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nCount = 0;
    if(tableView.tag==111) {
        nCount = 1;
    }
    else if(tableView.tag==200) {
        nCount = 1;
    }else
      nCount = m_ArrayChannels.count;
    
    return nCount;
 
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

      if(tableView.tag==111){
    
        NSInteger myIndex = (segmentTag + indexPath.section);
      
//        NSString *CellIdentifier = [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",(long)indexPath.section];
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",(long)myIndex];
        NKContainerCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *BlockData;
        NSMutableArray *BlockItems = [NSMutableArray new];
        if (nil == cell) {
             [COMMON LoadIcon:self.view];
            cell = [[NKContainerCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appManagerStr :@"YES"];
            if([appListArrayItems count]!=0){
                NSDictionary *cellData = [[appListArrayItems valueForKey:@"carousel"]objectAtIndex:[indexPath section]] ;
                NSString *appID = [[appListArrayItems valueForKey:@"id"]objectAtIndex:[indexPath section]];
                NSString *appImage = [[appListArrayItems valueForKey:@"image"]objectAtIndex:[indexPath section]];
                NSString *appLink = [[appListArrayItems valueForKey:@"link"]objectAtIndex:[indexPath section]];
                NSString *appName = [[appListArrayItems valueForKey:@"name"]objectAtIndex:[indexPath section]];
                NSString *appSlug = [[appListArrayItems valueForKey:@"slug"]objectAtIndex:[indexPath section]];
                NSString *appInstallCheck = [[appListArrayItems valueForKey:@"isInstalled"]objectAtIndex:[indexPath section]];
                NSString *appPackageName = [[appListArrayItems valueForKey:@"package"]objectAtIndex:[indexPath section]];
                NSString *appSlugName = [[appListArrayItems valueForKey:@"slug"]objectAtIndex:[indexPath section]];
                
                if ((NSString *)[NSNull null] == appID||appID == nil) {
                    appID=@"";
                }
                if ((NSString *)[NSNull null] == appImage||appImage == nil) {
                    appImage=@"";
                }
                if ((NSString *)[NSNull null] == appLink||appLink == nil) {
                    appLink=@"";
                } if ((NSString *)[NSNull null] == appName||appName == nil) {
                    appName=@"";
                }
                if ((NSString *)[NSNull null] == appSlug||appSlug == nil) {
                    appSlug=@"";
                }
                if ((NSString *)[NSNull null] == appInstallCheck||appInstallCheck == nil) {
                    appInstallCheck=@"";
                }
                if ((NSString *)[NSNull null] == appPackageName||appPackageName == nil) {
                    appPackageName=@"";
                }
                
                BlockData = [[cellData objectForKey:@"items"] mutableCopy];
                
//                if ((NSArray *)[NSNull null] == BlockData||BlockData == nil) {
//                    BlockData=@[];
//                }
                if([BlockData count]!=0){
                    for(int i=0;i<[BlockData count];i++){
                        
                        NSDictionary *tempDict = [BlockData objectAtIndex:i];
                        NSMutableDictionary *blockTemp = [(NSMutableDictionary*)tempDict mutableCopy];
                        
                        [blockTemp setValue:appID forKey:@"app_id"];
                        [blockTemp setValue:appImage forKey:@"app_image"];
                        [blockTemp setValue:appLink forKey:@"app_link"];
                        [blockTemp setValue:appName forKey:@"app_name"];
                        [blockTemp setValue:appSlug forKey:@"app_slug"];
                        [blockTemp setValue:appInstallCheck forKey:@"isInstalled"];
                        [blockTemp setValue:appPackageName forKey:@"package"];
                        [blockTemp setValue:appSlugName forKey:@"slug"];
                        [BlockItems addObject:blockTemp];
                        
                        NSInteger index = [indexPath section];
                        NSLog(@"index%ld-->",(long)index);
                        if (i == [BlockData count] - 1) {
                            [self performSelector:@selector(hideProgressHUD:) withObject:nil afterDelay:2];
                        }
                    }
                }
               
            }
            
            BlockData = (NSArray*)BlockItems;
            if([BlockData count]!=0){
                [cell setCollectionImageData:BlockData currentViewStr:@"MovieViewAppManager"];
            }
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [self performSelector:@selector(hideProgressHUD:) withObject:nil afterDelay:2];
        return cell;
    }
      else if(tableView.tag==201){
          static NSString *simpleTableIdentifier = @"SimpleTableCell";
          SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
          if(cell == nil){
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
          }
          NSString *strChannelName;
          
          if(isOnMoivesClick==YES){
              strChannelName = m_ArrayChannels[indexPath.row];
              if([COMMON isSpanishLanguage]==YES){
                  strChannelName = dropdownSpainshMoviesArray[indexPath.row];
              }
              if ((NSString *)[NSNull null] == strChannelName||strChannelName == nil) {
                  strChannelName=m_ArrayChannels[indexPath.row];
              }
          }
          else if(isOnMoivesGenreClick==true){
              NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
              strChannelName = dictItem[@"label"];
              if([COMMON isSpanishLanguage]==YES){
                  strChannelName = dictItem[SPANISH_TEXT];
              }
          }
          else if(isOnMoivesRatingClick==true){
              NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
              strChannelName = dictItem[@"name"];
              if([COMMON isSpanishLanguage]==YES){
                  strChannelName = dictItem[SPANISH_TEXT];
              }
             
        }
         
          [cell.labelText setText:strChannelName];
          return cell;
          
      }
      else if(tableView.tag==202){
          static NSString *simpleTableIdentifier = @"SimpleTableCell";
          SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
          if(cell == nil){
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
          }
          NSString *strChannelName;
          if(isClickedNetwork ==YES){
              NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
              strChannelName = dictItem[@"name"];
            }
          [cell.labelText setText:strChannelName];
          return cell;
      }
    
      else if(tableView.tag==101){
         static NSString *simpleTableIdentifier = @"SimpleTableCell";
         SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
         if(cell == nil){
             NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
             cell = [nib objectAtIndex:0];
         }
         
         
         NSString *strChannelName;
         if(isNetworksView==YES){
             NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
             strChannelName = dictItem[@"name"];
         }
        
         else{
             if(isOnTvShowClick==true){
                 strChannelName = m_ArrayChannels[indexPath.row];
                if([COMMON isSpanishLanguage]==YES){
                     strChannelName = dropdownSpainshTVShowsArray[indexPath.row];
                 }
                 if ((NSString *)[NSNull null] == strChannelName||strChannelName == nil) {
                     strChannelName=m_ArrayChannels[indexPath.row];
                 }
             }
             else if(isOnNetworksClick==true){
                 NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
                 strChannelName = dictItem[@"name"];
             }
             else if(isOnGenreClick==true){
                 NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
                 strChannelName = dictItem[@"label"];
                 if([COMMON isSpanishLanguage]==YES){
                     strChannelName = dictItem[SPANISH_TEXT];
                 }
             }
             else if(isOnCategoryClick==true){
                 NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
                 strChannelName = dictItem[@"name"];
                 if([COMMON isSpanishLanguage]==YES){
                     strChannelName = dictItem[SPANISH_TEXT];
                 }

             }
             else if(isOnDecadeClick==true){
                 NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
                  strChannelName = dictItem[@"name"];
                 if([COMMON isSpanishLanguage]==YES){
                     strChannelName = dictItem[SPANISH_TEXT];
                 }
                
             }
             
         }
         
         //    NSString *strChannelName = dictItem[@"label"];
         [cell.labelText setText:strChannelName];
         return cell;
 
     }
    else if(tableView.tag==102){
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if(isClickedPrimeLeftMenu==YES){
            NSString * currentText= m_ArrayChannels[indexPath.row];
            if([COMMON isSpanishLanguage]==YES){
                currentText = dropdownSpainshPrimeWeekdayArray[indexPath.row];
            }
            if ((NSString *)[NSNull null] == currentText||currentText == nil) {
                currentText=m_ArrayChannels[indexPath.row];
            }
            [cell.labelText setText:currentText];
    
        }
        else{
            NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
            NSString * strChannelName = dictItem[@"name"];

            [cell.labelText setText:strChannelName];

        }
        
        return cell;

    }
    
    return nil;
}
#pragma mark - hideProgressHUD
-(void)hideProgressHUD:(id)sender{
    [COMMON removeLoading];
     [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  

    if(tableView.tag == 111){

    }
    else if(tableView.tag == 112){
        
    }
    else if(tableView.tag==201){
        NSString *strLabel;
        if(isOnMoivesClick==true){
            strLabel =  m_ArrayChannels[indexPath.row];
            genreName = strLabel;
            NSString *currentLabel =  m_ArrayChannels[indexPath.row];
            if([COMMON isSpanishLanguage]==YES){
                currentLabel = dropdownSpainshTVShowsArray[indexPath.row];
            }
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }

            if ((NSString *)[NSNull null] == currentLabel||currentLabel == nil) {
                currentLabel=@"";
            }

            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:currentLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            _tvListLabel.attributedText = roboAttrString;
            
            if([strLabel isEqualToString:@"Movies"]){
                isMovieType=YES;
                isClickedMovie=YES;
                isClickedTvShowCategory=NO;
                isClickedTvShowGenre=NO;
                isClickedTvShowDecade=NO;
                isClickedMoviesGenre=NO;
                isClickedMoviesRating=NO;
                isClickedTvShowNetwork=NO;
                [_tvNetworkListLabel setHidden:YES];
                [onDemandSliderView setHidden:NO];
                [_tableView setHidden:YES];
                isClickedSliderViewAll=NO;
                isClickedCollectionSlider=NO;
                [self getMoviesData];
            }
            else if([strLabel isEqualToString:@"by Genre"]){
                isMovieType=YES;
                isClickedTvShowCategory=NO;
                isClickedTvShowGenre=NO;
                isClickedTvShowDecade=NO;
                isClickedMoviesGenre=YES;
                isClickedMoviesRating=NO;
                isClickedTvShowNetwork=NO;
                isClickedSliderViewAll=NO;
                isClickedCollectionSlider=NO;
                isMovieListData=YES;
                [_tvNetworkListLabel setHidden:NO];
                NSDictionary *dictItem =  dropDownNSArray[0];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"label"];
                if([COMMON isSpanishLanguage]==YES){
                    strLabel = dictItem[SPANISH_TEXT];
                 }
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }
                
                commonID = strID;
                [self updateData:[strID intValue] status:8];
                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
            }
            else if([strLabel isEqualToString:@"by Rating"]){
                isMovieType=YES;
                isClickedTvShowCategory=NO;
                isClickedTvShowGenre=NO;
                isClickedTvShowDecade=NO;
                isClickedMoviesGenre=NO;
                isClickedMoviesRating=YES;
                isClickedTvShowNetwork=NO;
                isClickedSliderViewAll=NO;
                isClickedCollectionSlider=NO;
                isMovieListData=YES;
                [_tvNetworkListLabel setHidden:NO];
                NSDictionary *dictItem =  onDemandMoviesRating[0];
                strLabel = dictItem[@"name"];
                if([COMMON isSpanishLanguage]==YES){
                    strLabel = dictItem[SPANISH_TEXT];
                }
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                NSString *slug  = dictItem[@"slug"];
                commonSlug = slug;
                [self loadMoviesRatingData:slug];
                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
            }
        }
        else if(isOnMoivesGenreClick==true){
            NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
            NSString * strID = dictItem[@"id"];
            strLabel = dictItem[@"label"];
            if([COMMON isSpanishLanguage]==YES){
                strLabel =  dictItem[SPANISH_TEXT];

            }
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            commonID = strID;
            [self updateData:[strID intValue] status:8];
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            _tvNetworkListLabel.attributedText = roboAttrString;
        }
        else if(isOnMoivesRatingClick==true){
            NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
           // NSString * strID = dictItem[@"id"];
            strLabel = dictItem[@"name"];
            if([COMMON isSpanishLanguage]==YES){
                strLabel = dictItem[SPANISH_TEXT];
            }
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            _tvNetworkListLabel.attributedText = roboAttrString;
            NSString *slug  = dictItem[@"slug"];
            commonSlug = slug;
            [self loadMoviesRatingData:slug];
        }
        bTvMenuShown = false;
        bPrimeLeftMenuShown = false;
        bNetworkShown = false;
        bMovieShown = false;
        bTvMenuByNetwork =false;
        bTvMenuByCategory =false;
        bTvMenuByGenre =false;
        bTvMenuByDecade =false;
        bMovieMenuByGenre =false;
        bMovieMenuByRating =false;
        [movieChannelView close];
        movieChannelView =nil;
        

    }
    else if(tableView.tag==202){
        NSString *strLabel;
        if(isClickedNetwork==YES){
            NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
            strLabel = dictItem[@"name"];
            genreName = strLabel;
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            tvShowLabel.attributedText = roboAttrString;
            
            NSString * strID = dictItem[@"id"];
            currentNetworkID = strID;
            commonID = strID;
            [self updateNetworkDetailData:[strID intValue]];
            
        }
        bTvMenuShown = false;
        bPrimeLeftMenuShown = false;
        bNetworkShown = false;
        bMovieShown = false;
        bTvMenuByNetwork =false;
        bTvMenuByCategory =false;
        bTvMenuByGenre =false;
        bTvMenuByDecade =false;
        bMovieMenuByGenre =false;
        bMovieMenuByRating =false;
        [movieChannelView close];
        movieChannelView =nil;
        
    }
    else if(tableView.tag==101){
        
        
        NSString * strLabel;
        
        if(isPayPerView==YES){
            NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
            NSString * strID = dictItem[@"id"];
            commonID = strID;
            strLabel = dictItem[@"label"];
            genreName = strLabel;
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            [self updateData:[strID intValue] status:4];
            //tvShowLabel.text = strLabel;
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            tvShowLabel.attributedText = roboAttrString;
        }
        else if(isNetworksView==YES){
            NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
            NSString * strID = dictItem[@"id"];
            commonID = strID;
            strLabel = dictItem[@"name"];
            genreName = strLabel;
            [self updateNetworkDetailData:[strID intValue]];
            // tvShowLabel.text = strLabel;
            if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                strLabel=@"";
            }
            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            tvShowLabel.attributedText = roboAttrString;
        }
        else{
            if(isOnTvShowClick==true){
                NSString *strLabel =  m_ArrayChannels[indexPath.row];
                NSString *currentLabel =  m_ArrayChannels[indexPath.row];
                genreName = strLabel;
                //[self updateShowData:[strID intValue]];
                //_tvListLabel.text =strLabel;
                if([COMMON isSpanishLanguage]==YES){
                    currentLabel = dropdownSpainshTVShowsArray[indexPath.row];
                }
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }
                if ((NSString *)[NSNull null] == currentLabel||currentLabel == nil) {
                    currentLabel=@"";
                }
                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:currentLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvListLabel.attributedText = roboAttrString;
                
                if([strLabel isEqualToString:@"TV Shows"]){
                    isClickedTvShowCategory=NO;
                    isClickedTvShowGenre=NO;
                    isClickedTvShowDecade=NO;
                    isClickedMoviesGenre=NO;
                    isClickedMoviesRating=NO;
                    isClickedTvShowNetwork=NO;
                    [_tvNetworkListLabel setHidden:YES];
                    [onDemandSliderView setHidden:NO];
                    [_tableView setHidden:YES];
                    [self getTvShowTitleData];
                    //[self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselArray];
                    
                }
                else if([strLabel isEqualToString:@"by Network"]){
                    isMovieType=NO;
                    isClickedTvShowCategory=NO;
                    isClickedTvShowGenre=NO;
                    isClickedTvShowDecade=NO;
                    isClickedMoviesGenre=NO;
                    isClickedMoviesRating=NO;
                    isClickedTvShowNetwork=YES;
                    [_tvNetworkListLabel setHidden:NO];
                    NSDictionary *dictItem =  dropDownTvNetworkArray[0];
                    NSString * strID = dictItem[@"id"];
                    strLabel = dictItem[@"name"];
                    commonID = strID;
                    if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                        strLabel=@"";
                    }
                    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                    [roboAttrString appendAttributedString:aweAttrString];
                    _tvNetworkListLabel.attributedText = roboAttrString;
                    
                    [self updateNetworkDetailData:[strID intValue]];
                    [sliderImageArray removeAllObjects];
                    [topTitleCarouselArray removeAllObjects];
                    
                }
                
                else if([strLabel isEqualToString:@"by Category"]){
                    NSDictionary *dictItem =  onDemandTvShowsCategory[0];
                    NSString * strID = dictItem[@"id"];
                    strLabel = dictItem[@"name"];
                    if([COMMON isSpanishLanguage]==YES){
                        strLabel = dictItem[SPANISH_TEXT];
                    }
                    currentTopTitle = strLabel;
                    commonID = strID;
                    isMovieType=NO;
                    isClickedTvShowCategory=YES;
                    isClickedTvShowGenre=NO;
                    isClickedTvShowDecade=NO;
                    isClickedMoviesGenre=NO;
                    isClickedMoviesRating=NO;
                    isClickedTvShowNetwork=NO;
                    [_tvNetworkListLabel setHidden:NO];
                    if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                        strLabel=@"";
                    }

                    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                    [roboAttrString appendAttributedString:aweAttrString];
                    _tvNetworkListLabel.attributedText = roboAttrString;
                    
                    [self loadOnDemandCategoryCarouselsByID:[strID intValue]];
                    [sliderImageArray removeAllObjects];
                    [topTitleCarouselArray removeAllObjects];
                    
                }
                else if([strLabel isEqualToString:@"by Genre"]){
                    [sliderImageArray removeAllObjects];
                    [topTitleCarouselArray removeAllObjects];
                    NSDictionary *dictItem = dropDownTvShowArray[0];
                    NSString * strID = dictItem[@"id"];
                    commonID = strID;
                    strLabel = dictItem[@"label"];
                    if([COMMON isSpanishLanguage]==YES){
                        strLabel = dictItem[SPANISH_TEXT];
                    }
                    //genreName = strLabel;
                    [self updateShowData:[strID intValue]];
                    [_tvNetworkListLabel setHidden:NO];
                    isMovieType=NO;
                    isClickedTvShowCategory=NO;
                    isClickedTvShowGenre=YES;
                    isClickedTvShowDecade=NO;
                    isClickedMoviesGenre=NO;
                    isClickedMoviesRating=NO;
                    isClickedTvShowNetwork=NO;
                    if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                        strLabel=@"";
                    }

                    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                    [roboAttrString appendAttributedString:aweAttrString];
                    _tvNetworkListLabel.attributedText = roboAttrString;
                    
                }
                else if([strLabel isEqualToString:@"by Decade"]){
                    [sliderImageArray removeAllObjects];
                    [topTitleCarouselArray removeAllObjects];
                    NSDictionary *dictItem =  onDemandTvShowsDecades[0];
                    NSString * strID = dictItem[@"id"];
                    strLabel = dictItem[@"name"];
                    if([COMMON isSpanishLanguage]==YES){
                        strLabel = dictItem[SPANISH_TEXT];
                    }
                    commonID = strID;
                    currentTopTitle = strLabel;
                    [self loadOnDemandDecadeByID:[strID intValue]];
                    [_tvNetworkListLabel setHidden:NO];
                    isMovieType=NO;
                    isClickedTvShowCategory=NO;
                    isClickedTvShowGenre=NO;
                    isClickedTvShowDecade=YES;
                    isClickedMoviesGenre=NO;
                    isClickedMoviesRating=NO;
                    isClickedTvShowNetwork=NO;
                    if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                        strLabel=@"";
                    }

                    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                    [roboAttrString appendAttributedString:aweAttrString];
                    _tvNetworkListLabel.attributedText = roboAttrString;
                    
                }
                
                
            }
            else if(isOnNetworksClick==true){
                NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"name"];
                commonID = strID;
                genreName = strLabel;
                [self updateNetworkDetailData:[strID intValue]];
                //_tvNetworkListLabel.text = strLabel;
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
            }
            else if(isOnGenreClick==true){
                NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"label"];
                if([COMMON isSpanishLanguage]==YES){
                    strLabel = dictItem[SPANISH_TEXT];
                }
                commonID = strID;
                genreName = strLabel;
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                [self updateShowData:[strID intValue]];
                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
            }
            else if(isOnCategoryClick==true){
                NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"name"];
                commonID = strID;
                genreName = strLabel;
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                if([COMMON isSpanishLanguage]==YES){
                    strLabel = dictItem[SPANISH_TEXT];
                }
                currentTopTitle = strLabel;
                CGSize strLabelSize = [strLabel sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(16)] }];
                CGRect tvNetworkListLabel = _tvNetworkListLabel.frame;
                CGFloat tvNetworkListLabelWidth;
                tvNetworkListLabelWidth = strLabelSize.width+10;
                [_tvNetworkListLabel setFrame:tvNetworkListLabel];
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }
                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
                [self loadOnDemandCategoryCarouselsByID:[strID intValue]];

            }
            else if(isOnDecadeClick==true){
                NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"name"];
                if([COMMON isSpanishLanguage]==YES){
                    strLabel = dictItem[SPANISH_TEXT];
                }
                commonID = strID;
                genreName = strLabel;
                currentTopTitle = strLabel;
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                _tvNetworkListLabel.attributedText = roboAttrString;
                [self loadOnDemandDecadeByID:[strID intValue]];
            }
            else{
                NSDictionary *dictItem = (NSDictionary *) m_ArrayChannels[indexPath.row];
                NSString * strID = dictItem[@"id"];
                strLabel = dictItem[@"label"];
                commonID = strID;
                genreName = strLabel;
                [self updateData:[strID intValue] status:8];
                if ((NSString *)[NSNull null] == strLabel||strLabel == nil) {
                    strLabel=@"";
                }

                NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
                [roboAttrString appendAttributedString:aweAttrString];
                tvShowLabel.attributedText = roboAttrString;
                
            }
            
        }
        bTvMenuShown = false;
        bPrimeLeftMenuShown = false;
        bNetworkShown = false;
        bMovieShown = false;
        bTvMenuByNetwork =false;
        bTvMenuByCategory =false;
        bTvMenuByGenre =false;
        bTvMenuByDecade =false;
        bMovieMenuByGenre =false;
        bMovieMenuByRating =false;
        [movieChannelView close];
        movieChannelView =nil;
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        //tvShowLabel.text = strLabel;

    }
    else if(tableView.tag==102){
        if(isClickedPrimeLeftMenu==YES){
            NSString *weekDayStr = m_ArrayChannels[indexPath.row];
            primeWeekStr = m_ArrayChannels[indexPath.row];
            weekDayStr = [weekDayStr lowercaseString];
            weekDayStr=[weekDayStr substringToIndex:3];
            commonWeekStr =  weekDayStr;
            [self loadPrimeCarouselData:weekDayStr];
            if ((NSString *)[NSNull null] == primeWeekStr||primeWeekStr == nil) {
                primeWeekStr=@"";
            }

            NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:primeWeekStr attributes:attrRoboFontDict];
            [roboAttrString appendAttributedString:aweAttrString];
            _tvListLabel.attributedText = roboAttrString;
        }
        else{
            NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
            NSString* primeStrID = dictItem[@"id"];
            commonID = primeStrID;
            int nPrimeID = [primeStrID intValue];
            [self loadPrimeViewAll:nPrimeID];
        }
        
       
        bTvMenuShown = false;
        bPrimeLeftMenuShown = false;
        bNetworkShown = false;
        bMovieShown = false;
        bTvMenuByNetwork =false;
        bTvMenuByCategory =false;
        bTvMenuByGenre =false;
        bTvMenuByDecade =false;
        bMovieMenuByGenre =false;
        bMovieMenuByRating =false;
        [movieChannelView close];
        movieChannelView =nil;
    }
 
}
#pragma mark - loadMoviesRatingData
-(void)loadMoviesRatingData:(NSString *)ratingString{
   // int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getOnDemandMoviesRatingDetails:^(AFHTTPRequestOperation * request, id responseObject) {
       
        arrayItems = [responseObject mutableCopy];
        nCategory = CATEGORY_MOVIES;
        mainCategory = CATEGORY_MOVIES;
        isPosterImage=YES;
        isCarouselImage=NO;
        isThumbnailImage=NO;
        isMovieListData=YES;
        [onDemandSliderView setHidden:YES];
        [_tableView setHidden:NO];
        [self.tableView reloadData];
        [COMMON removeLoading];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];

    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];

    } strRating:ratingString nPPV:nPPV];
}

#pragma mark - NSNotification to select table AddAction

- (void) didSelectAddAction:(NSNotification *)notification
{
     [self removeSearchView];
    NSDictionary *cellData = [notification object];
    currentCarouselID = cellData[@"app_id"];
    currentAppImage = cellData[@"app_image"];
    currentAppLink = cellData[@"app_link"];
    currentAppName = cellData[@"app_name"];
    NSString *isAppInstalled = cellData[@"isInstalled"];
    //NSString *appPackageName = cellData[@"package"];
    NSString * slug = [cellData objectForKey:@"slug"];
    slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
    if([isAppInstalled isEqualToString:@"YES"]){
        NSString *url = [NSString stringWithFormat:@"%@://app/",slug];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        isAddActionCalled=NO;
    }
    else{
        if(!isAddActionCalled){
            isAddActionCalled=YES;
            [self loadNewPopUp];
        }
    }
}


#pragma mark - NSNotification to select table cell & network Action

- (void) didSelectItemFromCollectionViewForMovie:(NSNotification *)notification
{
    [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    [COMMON LoadIcon:self.view];
    NSDictionary *cellData = [notification object];

    currentCarouselID = cellData[@"app_id"];
    currentAppImage = cellData[@"app_image"];
    currentAppLink = cellData[@"app_link"];
    currentAppName = cellData[@"app_name"];
    NSString *isAppInstalled = cellData[@"isInstalled"];
    //NSString *appPackageName = cellData[@"package"];
    NSString * slug = [cellData objectForKey:@"slug"];
    slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
    if([isAppInstalled isEqualToString:@"YES"]){
        
        NSString *url = [NSString stringWithFormat:@"%@://app/",slug];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        isAddActionCalled=NO;
        
    }
    else{
         if(!isAddActionCalled){
             isAddActionCalled=YES;
             [self loadNewPopUp];

         }
        
    }
    [COMMON removeLoading];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

    //[self loadNetworkDescription:currentNetworkId currentCarouselId:currentCarouselID];
    
    
}
- (void) didSelectItemInCellAppManager:(NSNotification *)notification
{
     [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    [COMMON LoadIcon:self.view];
    NSDictionary *cellData = [notification object];
    
    currentCarouselID = cellData[@"app_id"];
    currentAppImage = cellData[@"app_image"];
    currentAppLink = cellData[@"app_link"];
    currentAppName = cellData[@"app_name"];
    NSString *type = cellData[@"type"];
    NSString *currentShowMovieID = cellData[@"id"];
    NSString *currentShowMovieName = cellData[@"name"];
    if ((NSString *)[NSNull null] == currentShowMovieID||currentShowMovieID == nil) {
        currentShowMovieID=@"";
    }

    if ((NSString *)[NSNull null] == currentShowMovieName||currentShowMovieName == nil) {
        currentShowMovieName=@"";
    }

    didSelectId = currentShowMovieID;
    didSelectName = currentShowMovieName;
    NSLog(@"type%@",type);
    
    
    kidsType =type;
    commonType = type;
    commonID = didSelectId;
    
    NSString *isAppInstalled = cellData[@"isInstalled"];
    NSString * slug = [cellData objectForKey:@"slug"];
    slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
    if([isAppInstalled isEqualToString:@"YES"]){
        isAddActionCalled=NO;
        
        if([type isEqualToString:@"M"]){
            nCategory = CATEGORY_MOVIES;
            mainCategory = CATEGORY_MOVIES;
            isSeasonArray=NO;
            [self loadNewShowDetailPage];
        }
        else if([type isEqualToString:@"S"]){
            nCategory = CATEGORY_SHOW;
            [self loadShowDetailAPIOnSelect];
        }        
    }
    else{
         if(isAddActionCalled==NO){
             isAddActionCalled=YES;
             [self loadNewPopUp];
         }
        
        
    }
    [COMMON removeLoading];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


-(void) didSelectItemFromCollectionViewForOnDemand:(NSNotification *)notification
{
     [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    [COMMON LoadIcon:self.view];
    ////[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSDictionary *cellData = [notification object];
    nCategory = 9;
    mainCategory = 9;
    didSelectId = cellData[@"id"];
    NSString *type = cellData[@"type"];
    kidsType =type;
    commonType = type;
    commonID = didSelectId;
    isClickedCollectionSlider =YES;
    isClickedSliderViewAll=NO;
    didSelectName = cellData[@"name"];
    
    if([type isEqualToString:@"M"]){
        isSeasonArray=NO;
        [self loadNewShowDetailPage];
    }
    else if([type isEqualToString:@"S"]){
        [self loadShowDetailAPIOnSelect];
    }
    else if([type isEqualToString:@"N"]){
        [self updateNetworkDetailData:[didSelectId intValue]];
        
    }
    else{
        [COMMON removeLoading];
    }
    
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];


    //[self loadNetworkDescription:currentNetworkId currentCarouselId:currentCarouselID];
    
    
}
-(void)sliderViewAllOption:(NSNotification *)notification
{
     [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
    [COMMON LoadIcon:self.view];
    NSMutableDictionary *cellData = [notification object];
    NSString *carouselId = cellData[@"carouselId"];
    commonID = carouselId;
    NSString *type = cellData[@"type"];
    commonType = type;
    
    if([type isEqualToString:@"N"]||[type isEqualToString:@"network"]){
        nCategory = CATEGORY_NETWORK;
        isMovieType=NO;
        if([currentScrollTitle isEqualToString:@"Featured"]||[currentScrollTitle isEqualToString:@"TV Shows"]){
            isNetworkViewAll = YES;
        }
    }
    else if([type isEqualToString:@"M"]||[type isEqualToString:@"movie"]){
        
        nCategory = CATEGORY_MOVIES;
        mainCategory = CATEGORY_MOVIES;
        isMovieType=YES;
    }
    else if([type isEqualToString:@"L"]){
        nCategory = 101;
        mainCategory = 102;
        isMovieType=NO;
        
    }
    else{
        nCategory = CATEGORY_SHOW;
        isMovieType=NO;
    }
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [self loadSliderViewAllAPIWithCarouselID:carouselId nPPv:nPPV];
    
}
#pragma mark - loadSliderViewAllAPIWithCarouselID
-(void)loadSliderViewAllAPIWithCarouselID:(NSString*)carouselId nPPv:(int)nPPV{
    [[RabbitTVManager sharedManager]getWholeViewAll:^(AFHTTPRequestOperation * request, id responseObject) {
        currentSliderViewAllArray = [NSMutableArray new];
        currentSliderViewAllArray = responseObject;
        [self loadSliderViewAllDataWithViews];
        [COMMON removeLoading];
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [COMMON removeLoading];
    } nID:[carouselId intValue]  nPPV:nPPV];

}
-(void)loadSliderViewAllDataWithViews{
    [sliderImageArray removeAllObjects];
    [topTitleCarouselArray removeAllObjects];
    [onDemandSliderView setHidden:YES];
    [_tableView setHidden:NO];
    isCarouselImage=YES;
    isPosterImage=NO;
    isThumbnailImage=NO;
    isMovieListData=YES;
    isClickedSliderViewAll=YES;
    isClickedCollectionSlider=NO;
    arrayItems = [currentSliderViewAllArray mutableCopy];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_tableView setHidden:NO];
   
}
-(void)sliderViewWatchNowAction:(NSNotification *)notification
{
     [self removeSearchView];
    
    [[RabbitTVManager sharedManager]cancelRequest];
    
    NSMutableDictionary *cellData = [notification object];
    nCategory = 9;
    mainCategory = 9;
    NSString * sliderID = cellData[@"id"];
   
    isClickedSliderWatch =YES;
    isClickedCollectionSlider=NO;
    didSelectName = cellData[@"name"];
    
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getOnDemandSliderEntityDetails:^(AFHTTPRequestOperation * request, id responseObject) {
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        didSelectId = responseObject[@"entity_id"];
        NSString *type = responseObject[@"type"];
        kidsType =type;
        commonType = type;
        if([type isEqualToString:@"movie"]){
            
            isSeasonArray=NO;
            [self loadNewShowDetailPage];
        }
        else if([type isEqualToString:@"show"]){
            [self loadShowDetailAPIOnSelect];
        }
        [COMMON removeLoading];
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } slideID:[sliderID intValue]];
    
    
}

#pragma mark - installAction
-(void)installAction
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self dismissPopup];
    
    [[RabbitTVManager sharedManager]cancelRequest];
    NSString *link = currentAppLink ;
    NSURL* linkUrl = [NSURL URLWithString:link];
    [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
    
    [showPopUpView close];
    [showPopUpView removeFromSuperview];
    isAppListShown=YES;
    isPopUpClicked = false;
    bAppPopUpShown=false;
    [_appDownloadTableView reloadData];
    
    isFirstTime=false;
}
#pragma mark - loadApplicationPAge
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    if([url scheme]!=NULL){
        if([[UIApplication sharedApplication] canOpenURL:url] ){
            isWillDisAppear=YES;
            [[UIApplication sharedApplication] openURL:url];
        }
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - Custom7AlertDialog Delegate
-(void)customIOS7dialogDismiss{
    bTvMenuShown = false;
    bPrimeLeftMenuShown = false;
    bNetworkShown = false;
    bMovieShown = false;
    
    bTvMenuByNetwork =false;
    bTvMenuByCategory =false;
    bTvMenuByGenre =false;
    bTvMenuByDecade =false;
    
    bMovieMenuByGenre =false;
    bMovieMenuByRating =false;
    bAppPopUpShown= false;
    isFirstTime = false;
   
    [movieChannelView close];
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
        searchKeysTitle =[[responseObject allKeys] sortedArrayUsingSelector:@selector(compare:)];
        if([searchKeysTitle count]!=0){
            arrayWithCount =  [[NSMutableArray alloc]init];
            for(int i = 0; i < [searchKeysTitle count]; i++)
            {
                NSString *titleStr = [searchKeysTitle objectAtIndex:i] ;
                NSString *countrStr = [[searchResponseArray valueForKey:titleStr]objectForKey:@"count"];
                NSString *checkCount = [NSString stringWithFormat:@"%@",countrStr];
                if(![checkCount isEqualToString:@"0"]){
                    [arrayWithCount addObject:titleStr];
                }
            }
            if([arrayWithCount count]!=0){
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
- (void)updateData:(int)nChannelID status:(int)nStatus{
    [COMMON LoadIcon:self.view];

    
    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        [self.tableView reloadData];
    }
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    nCategory = CATEGORY_MOVIES;
    mainCategory = CATEGORY_MOVIES;
    
    [[RabbitTVManager sharedManager] getMovieListbyGenre:^(AFHTTPRequestOperation * request, id responseObject) {
      
        arrayItems = [responseObject mutableCopy];
        isMovieType=YES;
        isPosterImage=YES;
        isCarouselImage=NO;
        isThumbnailImage=NO;
        isClickedSliderViewAll=NO;
        isMovieListData=YES;
        if(isClickedNetwork==YES){
            [onDemandSliderView setHidden:NO];
            [_tableView setHidden:YES];
            //[self setNetworksScrollAndTableHeight];
            [networkTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }
        else{
            [networkTableView removeFromSuperview];
            [onDemandSliderView setHidden:YES];
            [_tableView setHidden:NO];
            [self.tableView reloadData];
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }        
        [COMMON removeLoading];
       
    } nID:nChannelID nStatus:nStatus nPPV:nPPV];
    
}

- (void)updateShowData:(int)nChannelID
{
//    NSString *videoPlayed = [COMMON getDemoVideoPlayed];
//    if(![videoPlayed isEqualToString:@"isVideoPlayed"]||videoPlayed==nil) {
//        isDownloadAppViewHidden=NO;
//        
//        
//    }
//    else{
//        
//        isDownloadAppViewHidden=YES;
//    }
//    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
//    if([str  isEqualToString: @"YES"]){
//        
//        isDownloadAppViewHidden=NO;
//    }

    if(isLoadIcon==YES){
        [COMMON LoadIcon:self.view];
        isLoadIcon =YES;
    }
    else{
        isLoadIcon =YES;
    }
    
    [self.tableView setHidden:YES];
    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        [self.tableView reloadData];

    }
    

    nCategory = CATEGORY_SHOW;
    //int nPPV = PAY_MODE_ALL;
    int nPPV = commonPPV;
    [[RabbitTVManager sharedManager] getShowListByGenre:^(AFHTTPRequestOperation * request, id responseObject) {
        isMovieType=NO;
        if(isAppListShown==YES){
            arrayItemsTemp = [NSMutableArray new];
            arrayItemsTemp = [responseObject mutableCopy];
            [COMMON removeLoading];
            }
        else{
            arrayItems = [responseObject mutableCopy];
            [onDemandSliderView setHidden:YES];
            isPosterImage=YES;
            isThumbnailImage=NO;
            isCarouselImage=NO;
            [self.tableView setHidden:NO];
            [self.tableView reloadData];
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
             [COMMON removeLoading];
        }
        [COMMON removeLoading];
       

        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
    } nID:nChannelID nPPV:(int)nPPV];
    
    
}

- (void)updateNetworkData:(NSMutableArray*) networks
{
    
    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        
    }
    nCategory = CATEGORY_NETWORK;
    arrayItems = [networks mutableCopy];
    isCarouselImage=NO;
    isPosterImage=NO;
    isThumbnailImage=YES;
    [COMMON removeLoading];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)updateNetworkDetailData:(int)nNetworkID
{
    if(isClickedNetwork==YES){
        for(UIView *view in fullSlideScrollView.subviews){
            if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UITableView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
    if(arrayItems.count==0){
    }
    else{
        [arrayItems removeAllObjects];
        
    }
    mainCategory = CATEGORY_NETWORK;
    nCategory = CATEGORY_MOVIES;
    
    [COMMON LoadIcon:self.view];
    currentNetworkDict =[NSMutableDictionary new];
    int nPPV = commonPPV;////int nPPV = PAY_MODE_ALL;
    [[RabbitTVManager sharedManager] getNetworkList:^(AFHTTPRequestOperation * request, id responseObject) {
        isMovieType=NO;
        arrayItems = [responseObject mutableCopy];
        isClickedSliderViewAll=NO;
        
        if([arrayItems count] ==0){
            nCategory = CATEGORY_NETWORK;
            [self getNetworkDetailWithNewtorkID:nNetworkID];//NEW CHANGE RAJI
            //[self updateData:nNetworkID status:4]; //OLD

        }
        else{
            isCarouselImage=NO;
            isPosterImage=YES;
            isThumbnailImage=NO;
            isClickedSliderViewAll=NO;
            isMovieListData=NO;
//            if(isClickedNetwork==YES){
//                [onDemandSliderView setHidden:NO];
//                [_tableView setHidden:YES];
//                [self getNetworkDetailWithNewtorkID:[currentNetworkID intValue]];
//                //[self setNetworksScrollAndTableHeight];
//                
//            }
//            else{
//                [onDemandSliderView setHidden:YES];
//                [_tableView setHidden:NO];
//                [self.tableView reloadData];
//                [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
//            }
            [sliderImageArray removeAllObjects];
            [topTitleCarouselArray removeAllObjects];
            //[arrayItems removeAllObjects];
            for(UIView *view in onDemandSliderView.subviews){
                [view removeFromSuperview];
                if ([view isKindOfClass:[UIView class]]) {
                    [view removeFromSuperview];
                }
            }
           
            [_tableView setHidden:YES];
            [self getNetworkDetailWithNewtorkID:nNetworkID];
            
        }
       
    } nID:nNetworkID nPPV:nPPV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - UI Grid View
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return nCellWidth;
        
        
    }
    else{
//        if(IS_IPHONE4||IS_IPHONE5){
//            return nCellWidth-100;
//        }
//        else{
//            return nCellWidth;
//        }
        return nCellWidth;
        
    }
    
    
}
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
  //return nCellHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat currentCellHeight = 210;
        if(isClickedSliderViewAll==YES){
            if(isMovieType==YES){
                currentCellHeight=210;
            }
            else{
                currentCellHeight=155;
            }
        }
        else{
            if(isMovieType==YES){
                currentCellHeight=210;
            }
            else{
                currentCellHeight=155;
            }
        }
        
        return currentCellHeight;//185//155
       
    }
    else{
        
        CGFloat currentCellHeight = 160;
        if(isMovieType==YES){
            currentCellHeight=160;
        }
        else{
            currentCellHeight=140;
        }
        return currentCellHeight;//160
        
    }
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;
    
    if([arrayItems count]!=0){
        
        nCount = nColumCount;
    }
    else{
        nCount = 1;
    }
    return nCount;
    
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;
    
    if([arrayItems count]!=0){
        nCount = [arrayItems count];
    }
    else{
        nCount = 0;
    }
    
    
    return nCount;
}



- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
   
    int nIndex;
    
    OnDemand_Grid_Cell* cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[OnDemand_Grid_Cell alloc] init];
    }
    
    if([arrayItems count] == 0){
        [arrayItems removeAllObjects];
    }
    
    else{
        nIndex= rowIndex * nColumCount + columnIndex;
        
        NSDictionary* dictItem;
        NSString * strName, *strPosterUrl;
        
        dictItem = arrayItems[nIndex];
        
        strName = dictItem[@"name"];

        if(isThumbnailImage ==YES){
            
            strPosterUrl = dictItem[@"thumbnail"];
            
        }
        else if(isPosterImage==YES){
            strPosterUrl = dictItem[@"poster_url"];
        }
        else if(isCarouselImage==YES){
            strPosterUrl = dictItem[@"carousel_image"];
        }
        else{
            
            strPosterUrl = dictItem[@"poster_url"];
        }
        
        if ((NSString *)[NSNull null] == strName||strName == nil) {
            strName=@"";
        }
                
        if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl == nil) {
            strPosterUrl=@"";
        }
        
        if(isClickedKids==YES){
            NSString* type = dictItem[@"type"];
            if([type isEqualToString:@"M"]){
                isMovieListData=YES;
            }
            else if([type isEqualToString:@"S"]){
                isMovieListData=NO;
            }
            
        }
        BOOL isNetworkImage=NO;
        if(isClickedSliderViewAll==YES){
            NSString* type = dictItem[@"type"];
            if([type isEqualToString:@"N"]){
                isMovieListData=YES;
                isNetworkImage=YES;
            }
            else if([type isEqualToString:@"M"]){
                isMovieListData=YES;
                isNetworkImage=NO;
                
            }
            else{
                isMovieListData=NO;
                isNetworkImage=NO;
            }
        }
        if(isClickedNetwork==YES){
            isNetworkImage=YES;
        }
        
        NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
        
        if(isMovieListData==YES){
            [cell.thumbnail setHidden:YES];
            [cell.landScapeView setHidden:YES];
            [cell.portraitView setHidden:NO];
            if(isNetworkImage==YES){
               [cell.moviePortraitImage setHidden:YES];
                [cell.portraitImageView setHidden:NO];
                [cell.portraitImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];//portrait_Loader
            }
            else{
                [cell.moviePortraitImage setHidden:NO];
                [cell.portraitImageView setHidden:YES];
                [cell.moviePortraitImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];
            }
        }
        else{
            [cell.moviePortraitImage setHidden:YES];
            [cell.thumbnail setHidden:NO];
            [cell.landScapeView setHidden:NO];
            [cell.portraitImageView setHidden:YES];
            [cell.portraitView setHidden:YES];
            [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];//landscape_Loader
        }
       
        return cell;
    }
    return nil;
}
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    
    
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
   // 
    [COMMON LoadIcon:self.view];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    int nIndex = rowIndex * nColumCount + colIndex;
    NSDictionary* dictItem;
    
    //NSInteger currentArrayCount = [arrayItems count];
    
    if([arrayItems count]!=0){
        if(nIndex )
        
        dictItem = arrayItems[nIndex];
        //    if(isClickedSliderViewAll==YES){
        //        NSString* type = dictItem[@"type"];
        //        if([type isEqualToString:@"N"]){
        //            nCategory = CATEGORY_NETWORK;
        //
        //        }
        //
        //    }
        if([currentScrollTitle isEqualToString:@"Featured"]||[currentScrollTitle isEqualToString:@"TV Shows"]){
            if(isNetworkViewAll==YES){
                isNetworkViewAll = NO;
                isNetworkViewAllSelection =YES;
            }
        }
        
        didSelectId = dictItem[@"id"];
        didSelectName = dictItem[@"name"];
        NSLog(@"showID%@",dictItem[@"id"]);
        [showPopUpView removeFromSuperview];
        showPopUpView = nil;
        isPopUpClicked=false;
        [showPopUpView close];
        
        if(nCategory == CATEGORY_MOVIES){
            if(mainCategory == CATEGORY_NETWORK){
                [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
                    arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
                    if([arraySeasons count]==0){
                        [self loadNewShowDetailPage];
                        isSeasonArray=NO;
                        
                    }
                    else{
                        isSeasonArray=YES;
                        [self loadNewShowDetailPage];
                    }
                    
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                } nID:[didSelectId intValue]];
            }
            else{
                isSeasonArray=NO;
                [self loadNewShowDetailPage];
                
                [COMMON removeLoading];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            }
        }
        else if(nCategory == CATEGORY_SHOW){
            [self loadShowDetailAPIOnSelect];
        }
        else if(nCategory == CATEGORY_NETWORK){
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [COMMON removeLoading];
            NSDictionary* dictItem = arrayItems[nIndex];
            NSString* nID = dictItem[@"id"];
            commonID = nID;
            [self updateNetworkDetailData:[nID intValue]];
        }
        else if(isClickedPrime==YES) {
            [self loadShowDetailAPIOnSelect];
        }
        else if(isClickedWebOriginal==YES){
            [self loadShowDetailAPIOnSelect];
        }
        else if(isClickedKids ==YES){
            NSDictionary* dictItem = arrayItems[nIndex];
            NSString* type = dictItem[@"type"];
            kidsType = type;
            if([type isEqualToString:@"M"]){
                isSeasonArray=NO;
                [self loadNewShowDetailPage];
            }
            else if([type isEqualToString:@"S"]){
                [self loadShowDetailAPIOnSelect];
            }
            else{
                [COMMON removeLoading];
            }
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        else{
            [COMMON removeLoading];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
    }
   
    
    

}
#pragma mark - loadShowDetailAPIOnSelect
-(void)loadShowDetailAPIOnSelect{
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        if([arraySeasons count] != 0){
            isSeasonArray=YES;
            [self loadNewShowDetailPage];
            [COMMON removeLoading];
           
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        else if([arraySeasons count] == 0){
            isSeasonArray=NO;
            [self loadNewShowDetailPage];
           
            [COMMON removeLoading];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
    } nID:[didSelectId intValue]];
}
#pragma mark - loadNewShowDetailPage
-(void)loadNewShowDetailPage{
    [self removeSearchView];
    
    NewShowDetailViewController * mShowVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail_ipad"];
    } else {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail"];
    }
    mShowVC.nID = didSelectId;
    mShowVC.headerLabelStr = didSelectName;
    if(mainCategory == CATEGORY_NETWORK){
        [mShowVC setIfMovies:false];
    }
    else if(nCategory == CATEGORY_SHOW){
        [mShowVC setIfMovies:false];
    }
    else if(isClickedPrime==YES){
        [mShowVC setIfMovies:false];
    }
    else if(isClickedWebOriginal==YES||isClickedKids==YES||isClickedCollectionSlider==YES||isClickedSliderWatch==YES){
        if([kidsType isEqualToString:@"movie"]||[kidsType isEqualToString:@"M"]){
            [mShowVC setIfMovies:true];
        }
        else if([kidsType isEqualToString:@"show"]||[kidsType isEqualToString:@"S"]){
            [mShowVC setIfMovies:false];
    }    }
    else{
        [mShowVC setIfMovies:true];
    }
    if(isSeasonArray){
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
    mShowVC.isPushedFromPayPerView=NO;
    if(commonPPV ==PAY_MODE_FREE){
        mShowVC.isToggledFree=YES;
        mShowVC.isToggledAll=NO;
    }
    else{
        mShowVC.isToggledFree=NO;
        mShowVC.isToggledAll=YES;
    }
    [self.navigationController pushViewController:mShowVC animated:YES];
   
    [COMMON removeLoading];
    if([currentScrollTitle isEqualToString:@"Featured"]||[currentScrollTitle isEqualToString:@"TV Shows"])
    {
        if([commonType isEqualToString:@"N"]){
           
        }
        else{
            if(isClickedCollectionSlider ==YES){
                isClickedCollectionSlider = NO;
            }
        }
    }
   // isClickedCollectionSlider=NO;
    //isClickedSliderViewAll=NO;
    
    //isClickedSliderWatch=NO;
}
- (void) setMovieShowBasedOnType:(NSString *)kidsType{
}

#pragma mark - MovieViewOrientationChanged
-(void) MovieViewOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self onDemandMovieRotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self onDemandMovieRotateViews:false];
            break;
            
        default:
            break;
    }
}
#pragma mark - onDemandMovieRotateViews
-(void) onDemandMovieRotateViews:(BOOL) bPortrait{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if(isAppListFirstTimeHidden==YES){
         isAppListFirstTimeHidden=NO ;
    }
    //onDemandSliderView.translatesAutoresizingMaskIntoConstraints = YES;
    if(bPortrait){
        
        port_heightView = SCREEN_HEIGHT;
        port_MovieViewHeight = SCREEN_HEIGHT;
        nColumCount = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nColumCount = 4;
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nCellWidth = screenWidth / nColumCount;
        nCellHeight = screenWidth / nColumCount;
        
        if(port_MovieViewHeight!=land_MovieViewHeight){
            [self onDemandLeftAndRightMenuList:YES];

        }

    }else{
        land_heightView = SCREEN_HEIGHT;
        
        land_MovieViewHeight = SCREEN_HEIGHT;
        
        
        nColumCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nColumCount = 5;
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nCellWidth = screenWidth / nColumCount;
        nCellHeight = screenWidth / nColumCount;
        if(port_MovieViewHeight!=land_MovieViewHeight){
             [self onDemandLeftAndRightMenuList:NO];
        }
    }
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"NO"]){
        //[self setUpSearchBarInNavigation];  //this code added in onDemandLeftAndRightMenuList
        //[self setScrollHeader];
    }
    else{
        [_searchButton setHidden:NO];
        [_searchButton removeFromSuperview];
    }
    
    
    if(isDownloadAppViewHidden==NO){
        
       // [self setUpDownloadAppView];
        
        //new change
        [self setUpNewStaticDownloadAppView];
    }
    if(isDownloadAppViewHidden==YES){
        //[self hideDownloadView];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [_searchButton setHidden:NO];
        [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
    }
    
    
}
-(void)onDemandLeftAndRightMenuList:(BOOL)portraitBool{
    
   
    
    if(isClickedNetwork==YES){
        [self loadNetworkImageAndDetails];
    }
    if([currentScrollTitle isEqualToString:@"Featured"]){
        if(isClickedCollectionSlider==YES){
            if([commonType isEqualToString:@"N"]||[commonType isEqualToString:@"network"]){
                 [self loadNetworkImageAndDetails];
                
            }
        }
        if(isNetworkViewAllSelection==YES){
             [self loadNetworkImageAndDetails];
        }
        
    }
    if([currentScrollTitle isEqualToString:@"TV Shows"]){
        if(isOnTvShowClick==YES){
            if([genreName isEqualToString:@"by Network"]){
                [self loadNetworkImageAndDetails];
            }
        }
        else if(isOnNetworksClick==YES){
            [self loadNetworkImageAndDetails];
        }
    }
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"APPMANAGER"];
    if([str  isEqualToString: @"NO"]){
        if([sliderImageArray count]!=0||[topTitleCarouselArray count]!=0){
            //_appDownloadTableView.tag = 1000;
            [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselArray];
        }
    }
    else{
        if(appManagerDoneClicked==YES){
            if([sliderImageArray count]!=0||[topTitleCarouselArray count]!=0){
                //_appDownloadTableView.tag = 1000;
                [self loadSliderCarouselDesign:sliderImageArray carouselArray:topTitleCarouselArray];
            }
        }
    }
    
    if(isAppListShown!=YES){
        [self.tableView reloadData];
        
    }
    
    if(isPopUpClicked) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [showPopUpView removeFromSuperview];
        showPopUpView = nil;
        [showPopUpView close];
        [self loadNewPopUp];
        
    }
    
    if(bTvMenuShown){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myTvShowMenuData];
    }
    
    if(bPrimeLeftMenuShown){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myPrimeLeftMenuData];
    }
    if(bNetworkShown){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myNetworkLeftMenuData];
    }
    if(bMovieShown){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myMoviesMenuData];
    }
    if(bTvMenuByNetwork){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myNetworkMenuData];
    }
    if(bTvMenuByCategory){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myCategoryMenuData];
    }
    if(bTvMenuByGenre){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myGenreMenuData];
    }
    if(bTvMenuByDecade){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myDecadeMenuData];
    }
    
    if(bMovieMenuByGenre){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myMovieGenreMenuData];
    }
    if(bMovieMenuByRating){
        [movieChannelView removeFromSuperview];
        [movieChannelView close];
        movieChannelView = nil;
        [self myMovieRatingMenuData];
    }
    if([str  isEqualToString: @"NO"]){
        [self setUpSearchBarInNavigation];
        [self setScrollHeader];
    }
    else{
        [_searchButton setHidden:NO];
        [_searchButton removeFromSuperview];
        if(appManagerDoneClicked==YES){
            [self setUpSearchBarInNavigation];
            [self setScrollHeader];
        }
    }
    
    if(portraitBool==YES){
         land_MovieViewHeight  = port_MovieViewHeight;
    }
    else{
         port_MovieViewHeight  = land_MovieViewHeight;
    }
    
    if(isVideoLinkTapped==YES){
        [self tapVideoAction];
    }

}
#pragma mark - Naviagion Bar Click

- (IBAction)onPlusClick:(id)sender {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        
        PlusViewController *plusVC = [storyboard instantiateViewControllerWithIdentifier:@"PlusViewController"];
        [self.navigationController presentViewController:plusVC animated:YES completion:nil];
        return;
        
    }
    PlusViewController *plusViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"plusviewcontroller"];
    [self.navigationController presentViewController:plusViewController animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}
-(void)removeSearchView{
    [self.view endEditing:YES];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//DropDown
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Gesture Delegate Methods
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    
    return YES;
}
- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

-(void)setUpCollectionView:(UIView*)lastView
{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
   // layout.headerReferenceSize = CGSizeMake(_collectionView.frame.size.width, 100);
    
    //layout.footerReferenceSize = CGSizeMake(_collectionView.frame.size.width, 100);
    
    CGFloat collectionXPos = 10;
    if([self isDeviceIpad]==YES){
         collectionXPos = 60;
    }
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(collectionXPos, 10, subScriptionView.frame.size.width-(collectionXPos*2),subScriptionView.frame.size.height-20)collectionViewLayout:layout];
  
     [_collectionView setCollectionViewLayout:layout];
    
   // CGRect collection = _collectionView.frame;
   // collection.origin.y = CGRectGetMaxY(lastView.frame)+ 500;
   // _collectionView.frame = collection;
    
    // [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    if([self isDeviceIpad]==YES){
        [_collectionView registerNib:[UINib nibWithNibName:@"appManagerStaticCustomCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"appManagerStaticCustomCollectionCell"];
    }
    else{
        [_collectionView registerNib:[UINib nibWithNibName:@"appManagerStaticCustomCollectionCell_IPhone" bundle:nil] forCellWithReuseIdentifier:@"appManagerStaticCustomCollectionCell_IPhone"];
    }
    
    
    
  //  [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
 //   [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [subScriptionView addSubview:_collectionView];
    
    NSString *currentSelectionStr;
    currentSelectionStr = [headerTitleArray objectAtIndex:appVisibleSection];
    
    [self currentString:currentSelectionStr];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIDevice* device = [UIDevice currentDevice];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
         CGFloat cellWidth = collectionView.frame.size.width/2 -50;
        
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            cellWidth = (collectionView.frame.size.width/3) -20;
        }
        return  CGSizeMake(cellWidth , 85);
    }
    else{
        CGFloat cellWidth;// = collectionView.frame.size.width;
        cellWidth = (collectionView.frame.size.width/2)-5;
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
             cellWidth = (collectionView.frame.size.width/3)-5;
        }
         return  CGSizeMake(cellWidth , 65);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [appCollectionStaticArray count];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    appManagerStaticCustomCollectionCell  *cell;
    
    if([self isDeviceIpad]==YES){
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"appManagerStaticCustomCollectionCell" forIndexPath:indexPath];
    }
    else{
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"appManagerStaticCustomCollectionCell_IPhone" forIndexPath:indexPath];
    }
    
   
    
    NSMutableDictionary *tempValue =  [appCollectionStaticArray objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [tempValue valueForKey:@"logo"];
    
    //NSString *ipaLink = [tempValue valueForKey:@"ipa"];
    
   // NSString *appName =  @"Hulu"; //[dictItem valueForKey:@"name"];
   
    if ((NSString *)[NSNull null] == imageUrl||imageUrl == nil) {
        imageUrl=@"";
    }
    
    isSelectedItem = NO;//[[dictItem valueForKey:@"isSelectedItem"]boolValue];
    [cell.installBtn setHidden:NO];
    
    [cell.installBtn setTitle:@"Install" forState:UIControlStateNormal];
    [cell.installBtn setBackgroundImage:[UIImage imageNamed:@"AddButton.png"] forState:UIControlStateNormal];
    
    
    [cell.appImage setImage:[UIImage imageNamed:imageUrl]];
    
    cell.installBtn.tag = indexPath.row;
    
    [cell.installBtn addTarget:self action:@selector(instalStaticAppAction:) forControlEvents:UIControlEventTouchUpInside];
    
  //  [cell.appImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
    
    
    // [cell.appImage setImage:[self convertToGreyscale:cell.appImage.image]];
    
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:cell.appImage.bounds
                              byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(8, 8)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame =cell.appImage.bounds;
    maskLayer.path = maskPath.CGPath;
    //cell.appImage.layer.mask = maskLayer;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSMutableDictionary *tempValue =  [appCollectionStaticArray objectAtIndex:indexPath.row];
    
   // NSString *imageUrl = [tempValue valueForKey:@"logo"];
    
    NSString *ipaLink = [tempValue valueForKey:@"ipa"];
    
    NSURL* linkUrl = [NSURL URLWithString:ipaLink];

    [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
}
-(void)instalStaticAppAction:(UIButton*)sender{
    
    NSInteger currentIndedx = sender.tag;
    
    NSMutableDictionary *tempValue =  [appCollectionStaticArray objectAtIndex:currentIndedx];
    NSString *ipaLink = [tempValue valueForKey:@"ipa"];
    
    NSURL* linkUrl = [NSURL URLWithString:ipaLink];
    [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
    
    
}

- (void)tapVideoAction{
    isVideoLinkTapped=YES;
    
    UIDevice* device = [UIDevice currentDevice];
    
    CGFloat itemDetailBgViewXpos= 10;
    CGFloat itemDetailBgViewYpos= 10;
    
    CGFloat itemDetailsViewXYPos = 20;
    CGFloat extraSpace = 90;
    
    if([self isDeviceIpad]==YES){
        itemDetailBgViewXpos= 40;
        itemDetailBgViewYpos= 70;
        itemDetailsViewXYPos =40;
        extraSpace = 5;
    }
    else{
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            extraSpace = 60;
        }
    }
    
    [subScriptionView setHidden:YES];
    
    [itemDetailBgView removeFromSuperview];
    
    itemDetailBgView = [[UIView alloc] initWithFrame:CGRectMake(itemDetailBgViewXpos, itemDetailBgViewYpos, SCREEN_WIDTH-(itemDetailBgViewXpos*2), SCREEN_HEIGHT-(itemDetailBgViewYpos*2)-extraSpace)];
    
    itemDetailBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    UIView *itemDetailsView = [[UIView alloc] initWithFrame:CGRectMake(itemDetailsViewXYPos, itemDetailsViewXYPos, itemDetailBgView.frame.size.width-(itemDetailsViewXYPos*2), itemDetailBgView.frame.size.height-(itemDetailsViewXYPos*2))];
    
    YTPlayerView *  newPlayer = [[YTPlayerView alloc]initWithFrame:CGRectMake(0, 0, itemDetailsView.frame.size.width, itemDetailsView.frame.size.height)];
    newPlayer.delegate = self;
    
   
    [newPlayer setBackgroundColor:[UIColor blackColor]];
    [itemDetailsView setBackgroundColor:[UIColor blackColor]];
    [itemDetailBgView setUserInteractionEnabled:YES];
    
    NSString* m_strVideoUrl = @"mIqzgd0yse0";
    
   
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay":@1,
                                 @"showinfo" : @0,//raji
                                 @"rel" : @0,
                                 @"controls" : @0,
                                 @"origin" : @"https://www.example.com", // this is critical
                                 @"modestbranding" : @1
                                 };
    //[self. playerView loadWithPlaylistId:@"PLNT1r49jsn3niUNZcxO1Vyj86oxuxmi7R"];//playlist id
    
    [newPlayer loadWithVideoId:m_strVideoUrl playerVars:playerVars];
    [newPlayer playVideo];
    
  //  UIButton* closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemDetailsView.frame.origin.x + (itemDetailsView.frame.size.width-25), itemDetailsView.frame.origin.y - 25, 40, 40)];
    
    
    CGFloat BtnXPos= CGRectGetMaxX(itemDetailBgView.frame)-50;
    if([self isDeviceIpad]==YES){
        BtnXPos= CGRectGetMaxX(itemDetailBgView.frame)-80;
    }
   
    UIButton* closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(BtnXPos, 0, 40, 40)];
    
    [closeBtn setTag:101];
    [closeBtn addTarget:self
                 action:@selector(closeItemDetailsView)
       forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage imageNamed:@"close_Icon"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [closeBtn setBackgroundImage:image forState:UIControlStateNormal];
    //[closeBtn setImage:image forState:UIControlStateNormal];
    [closeBtn setTintColor:[UIColor whiteColor]];
    
   // [closeBtn setBackgroundColor:[UIColor blackColor]];
    
    [itemDetailsView addSubview:newPlayer];
    
    [itemDetailBgView addSubview:itemDetailsView];
    [itemDetailBgView addSubview:closeBtn];
    
    [self.view addSubview:itemDetailBgView];
    
}
-(void)closeItemDetailsView{
    isVideoLinkTapped=NO;
    
    [subScriptionView setHidden:NO];
    
    [itemDetailBgView removeFromSuperview];
}

-(void)hideStaticView{
    
    [self closeItemDetailsView];
    appManagerDoneClicked=YES;
    [downloadView removeFromSuperview];
    [_playerBgView removeFromSuperview];
    [subScriptionView removeFromSuperview];
    [onDemandSliderView setHidden:NO];
    [self hideDownloadView];
    [self loadSliderCarouselScreen];
    [self setUpSearchBarInNavigation];
    [self setScrollHeader];
    [[NSUserDefaults standardUserDefaults] setObject:@"isVideoPlayed" forKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
