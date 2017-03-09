
//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//


#import "MainViewController.h"
#import "RabbitTVManager.h"
#import "StreamTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CustomIOS7AlertView.h"
#import "PlayerViewController.h"
#import "PlusViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <GoogleCast/GoogleCast.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AppConfig.h"
#import "AppCommon.h"
#import "MBProgressHUD.h"
#import "ChanelManager.h"
#import "MenuCell.h"
#import "SimpleTableCell.h"
#import "AsyncImage.h"
#import "MainContentGridCell.h"
#import "SearchViewController.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "SidebarViewController.h"

//#import <GoogleMobileAds/GADInterstitial.h>
//#import <GoogleMobileAds/GADBannerView.h>



#import "HCYoutubeParser.h"

static NSString * kReceiverAppID;

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource,YTPlayerViewDelegate,CustomIOS7AlertViewDelegate,
GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate, UIActionSheetDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,NIDropDownDelegate,MBProgressHUDDelegate,MenuViewDelegate>
{
    SWRevealViewController *revealviewcontroller;
    
    
    int m_nCurVideoID;
    float m_fVolume;
    float lastDeviceVolume;
    NSString *strCurrentCastingVideoTitle;
    NSString *strCurrentCastingThumbImage;
    int currentNID;
    CGFloat tempPotHeight;
    CGFloat templanHeight;
    
    BOOL isHiddenBannerView;
    BOOL isLandscape;
    BOOL isPortrait;
    BOOL isInCasting;
    BOOL isSelfView;
    BOOL isReloadTable;
    BOOL isnowViewAboveAds;
    
    IBOutlet UIView *animationView;
    IBOutlet UIImageView *castImageView;
    
    UIView *videoContainerView;
    UIView *loadingView;
    UIActivityIndicatorView *indicator;
    UIView *backgroundView ;
    UILabel *indicateLabel;
    CGFloat scrollButtonWidth;
    CGFloat scrollButtonWidthTest;
    CGSize stringsize;
    BOOL isScrolled;
    NSInteger visibleSection;
    NSMutableArray* m_ArrayCategories;
    NSMutableArray* m_ArrayChannels;
    NSMutableArray* m_ArrayChannelsList;
    
    //Root Categories
    NSMutableArray* rootCategories;
//    CustomIOS7AlertView * mainChannelView;
    MainViewController * mainViewController;
    AsyncImage *asyncImage;
    
    //Show & content
    BOOL isShowClicked;
    BOOL isContentClicked;
    NSMutableArray* latestNewsArray;
    
    NSMutableArray *viewsDict;
    NSMutableArray *channelTitleLabelArray;
    NSMutableArray *channelVideoTitleLabelArray;
    NSString *CommonChannelId;
    NSString *previousCommonChannelId;
    NSString *ChannelIdFromTitleAction;
    NSString *ChannelLogoFromTitleAction;
    NSString *ChannelNameFromTitleAction;
    NSString *StreamId;
    NSString *StreamTitle;
    NSString *requestId;
    NSString *setChannelViewScrollId;
    
    NSMutableArray *channelTitleTempArray;
    
    //Topmenu Popuptable
    UIView * tvShowView;
    UITableView* tableChannelList;
    NSMutableArray * myArray;
    NSMutableArray * tvActorArray;
    NSMutableArray * musicalArtistArray;
    NSMutableArray * MovieActorArray;
    NSMutableArray * artistArray;
    NSString *artistMusicalId;


    BOOL isTitleAction;
    BOOL isResChannelNil;
    
    
    NSMutableArray *channelSubCategory;
    NSMutableDictionary *channelTitleDict;
    
    //Search
    UISearchBar *searchBarView;
    BOOL isSearch;
    NSString *searchString;
    NSArray *searchKeysTitle;
    UITextField *searchTextField;
    NSMutableArray *searchResponseArray;
    NSMutableArray *arrayWithCount;

    
    //Height
    float portraitHeightFirst;
    CGSize firstSizeInFull;
    
    //sort
     NSMutableArray *sortedArray;
    //dropdown muicartist
    NIDropDown *dropDown;
    UIButton* selectionButton;
    MBProgressHUD *progressHUD;
    
    //menu view
    UILabel* menuTitle;
    UILabel* menuTitleLine;
    UIButton * menuCancelBtn;
    
    int tableYPosition;
    int tableHeight;
    NSString *tableActorId;
    
    NSMutableArray* arrCategoriesTempArray;
    BOOL isChannelGridClicked;
    
    NSInteger prevTappedTag;
    UIView *previousView;
    NSInteger myIndex;
    
    CGFloat port_heightView;
    CGFloat land_heightView;
    
    //MENU ORIENTATION
    CGFloat port_MainViewHeight;
    CGFloat land_MainViewHeight;
    
    
    MPMoviePlayerController *theMoviPlayer;

    
}

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;

@property (strong, nonatomic) IBOutlet UISlider *playDurationSlider;
@property (strong, nonatomic) IBOutlet UIButton *rewindButton;

@property (strong, nonatomic) IBOutlet UIButton *volumeMuteButton;

@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *volumeDisconnectBotton;
@property (strong, nonatomic) IBOutlet UIButton *volumeCancelBotton;

@property (nonatomic, strong) UISlider *castVolumeSlider;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;

@property (nonatomic, retain) NSMutableArray *arrayStreams;

@property (nonatomic, retain) NSMutableArray *arrayStreamsTemp;

@property (nonatomic, retain) NSMutableArray *arrayPlayList;

@property (nonatomic, retain) NSString* curVideoUrl;
@property (nonatomic, retain) NSString* curTitle;

@property (readwrite) BOOL bDemandShown;
@property (nonatomic,retain) CustomIOS7AlertView* ondemandView;

//Chrome Cast
@property GCKMediaControlChannel *mediaControlChannel;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property(nonatomic, strong) IBOutlet UIButton *googleCastButton;
@property(nonatomic, strong) IBOutlet UIButton *searchButton;
@property(nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property(nonatomic, strong) GCKDeviceManager *deviceManager;
@property(nonatomic, strong) GCKMediaInformation *mediaInformation;
@property(nonatomic, strong) UIImage *btnImage;
@property(nonatomic, strong) UIImage *btnImageSelected;

@property (nonatomic, retain) NSMutableArray *views;

@end

@implementation MainViewController

@synthesize arrayStreams;
@synthesize arrayPlayList;

@synthesize curVideoUrl;
@synthesize curTitle;
@synthesize bDemandShown;
@synthesize ondemandView,showHeaderView,isLoadAgain,showTopView;
@synthesize views;
int nMainColumn=8;
int nMainWidth=50;
int nMainHeight=2;

bool isFirstScrollHeader=YES;

bool isFirstChannelView=YES;

BOOL isFirstTimeChannelView=YES;

NSString *THUMBNAIL_URL = @"http://img.youtube.com/vi/";

static bool m_bFirstTime = true;
static bool nowViewFirstTime = true;
static bool loadedWebView = false;

static bool m_bFirstTimeHeight = true;

BOOL bTitleCagtegoryShown = false;
BOOL bTitleSubCagtegoryShown = false;
BOOL bMenuCategoryShown = false;

bool bFullScreen = false;

NSMutableArray *views;

CustomIOS7AlertView * mainChannelView;

//#define kYoutubeVevoURL      @"http://www.youtube.com/get_video_info?el=vevo&el=embedded&video_id="

-(void)stopVideo{
    
    [self.playerView pauseVideo];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"ca-app-pub-2477673314122306/4815867790";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    //    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    //    // an ad request is made. GADBannerView automatically returns test ads when running on a
    //    // simulator.
    //    request.testDevices = @[
    //                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
    //                            ];
    
    [self.bannerView loadRequest:request];
    // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    isSelfView=YES;
    
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


#pragma mark viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //new color change
    _mainBackgroundImage.image=nil;
    _mainBackgroundImage.backgroundColor = GRAY_BG_COLOR;
    

    isLoaded = false;
    isReloadTable = false;
    isnowViewAboveAds= false;
    isFirstScrollHeader=YES;
    isChannelGridClicked=NO;
    
     
    m_ArrayChannels= [[NSMutableArray alloc]init];
    m_ArrayCategories= [[NSMutableArray alloc]init];
    m_ArrayChannelsList= [[NSMutableArray alloc]init];
    channelSubCategory = [[NSMutableArray alloc] init];
    channelTitleLabelArray = [[NSMutableArray alloc] init];
    channelVideoTitleLabelArray = [[NSMutableArray alloc] init];
    channelTitleDict = [[NSMutableDictionary alloc] init];
    tempPotHeight = 0.0;
    templanHeight = 0.0;
    
    NSLog(@"Google Mobile Ads SDK version.: %@", [GADRequest sdkVersion]);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedPlaybackStartedNotification:)
                                                 name:@"Playback started"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStream:) name:@"updatestream" object:nil];
    //Amit Sharma
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo) name:@"stopVideo" object:nil];
    
    NSString *titleStr = @"Channels";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
    
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    
    
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
  
    //[self.navigationController.navigationBar setBackgroundImage:[UIColor colorWithRed:59.0f/255.0f green:60.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    revealviewcontroller = [[SWRevealViewController alloc]init];
    revealviewcontroller = self.revealViewController;
     self.revealViewController.delegate = self;
    [self.revealViewController tapGestureRecognizer];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
    [self.revealViewController panGestureRecognizer];
    if(revealviewcontroller)
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
     [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
//    [revealviewcontroller revealToggleAnimated:false];
    revealviewcontroller.rightViewController=nil;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainChannelOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self mainRotateViews:false];
    }else{
        [self mainRotateViews:true];
    }
    isCurVideo = false;
    self.playerView.delegate = self;
    [self.playerView stopVideo];
    bDemandShown = false;
    self.tableStreams.tag = 100;
    self.tableStreams.delegate = self;
    self.tableStreams.dataSource = self;
    
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"openTonggle"
     object:self];
    
    //Chrome Cast
    m_nCurVideoID = 0;
    [self initCast];
    m_fVolume = [self getVolume];
    [self setCastSlider];
    [onCastView setHidden:YES];
    
    //Google Ads
    [self performSelector:@selector(hideAds) withObject:nil afterDelay:60.0];
    isInCasting = NO;
    isSelfView=YES;
    videoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 180)];
    videoContainerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:videoContainerView];
    [videoContainerView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrolled:) name:@"tableScrolled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableFilter:) name:@"scrollFromRightView" object:nil];
    // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [mainChannelView close];
    mainChannelView =nil;
    
    //new raji
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:theMoviPlayer];
}


#pragma mark - View Appear and Disappear
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    isFirstChannelView=YES;

    [self.playerView setBackgroundColor:[UIColor clearColor]];
    [self.playerContainer setBackgroundColor:[UIColor clearColor]];
    [self.containerVideoView setBackgroundColor:[UIColor clearColor]];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    self.view.backgroundColor = GRAY_BG_COLOR;
    _mainBackgroundImage.image=nil;
    _mainBackgroundImage.backgroundColor = GRAY_BG_COLOR;
    
    
    bTitleCagtegoryShown = false;
    bTitleSubCagtegoryShown =false;
    bMenuCategoryShown = false;
    [mainChannelView close];
    mainChannelView =nil;
    [COMMON LoadIcon:self.view];
    if(m_bFirstTime == true){
        self.youtubeID =@"145";//@"4760";// @"328";
        self.youtubeTitle = @"Channels";
        [self updateStreamsForTest:[self.youtubeID intValue]];
        //[self updateStreams:[self.youtubeID intValue]];
        m_bFirstTime = false;
        
    }else {
        [self updateStreamsForTest:[self.youtubeID intValue]];
        //[self updateStreams:[self.youtubeID intValue]];
        [self updateTitle:self.youtubeTitle];
    }
    [self.playerView playVideo];
    [self loadTitleMenuBar];
    [_mainLeftBarButton addTarget:self action:@selector(mainLeftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentViewButton setTitle:@"SHOW VIEW" forState:UIControlStateNormal];
    [_showViewButton setTitle:@"CHANNEL VIEW" forState:UIControlStateNormal];
    _showViewButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(12)];
    _contentViewButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(12)];
    
    [_showViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_contentViewButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [_contentViewButton setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    
   // [_showViewButton setTitle:@"SHOW VIEW" forState:UIControlStateNormal];
    //[_contentViewButton setTitle:@"CHANNEL VIEW" forState:UIControlStateNormal];
    [_contentViewButton addTarget:self action:@selector(showStreamTable:) forControlEvents:UIControlEventTouchUpInside];
    [_showViewButton addTarget:self action:@selector(showContentTable:) forControlEvents:UIControlEventTouchUpInside];
    
    //[_contentViewButton setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f]];
   // [_showViewButton setBackgroundColor:[UIColor whiteColor]];
    
    
    [_contentViewButton setBackgroundColor:[UIColor colorWithRed:8.0f/255.0f green:30.0f/255.0f blue:43.0f/255.0f alpha:1.0f]];
    [_showViewButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:94.0f/255.0f alpha:1.0f]];

    
    [newScrollGridView setBackgroundColor:[UIColor clearColor]];
    [self.tableStreams setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f]];
    
    [self.tableStreams setHidden:true];
    [self.tableContent setHidden:true];
    [newScrollGridView setHidden:NO];
    //[newScrollGridView setBackgroundColor:[UIColor grayColor]];


    self.revealViewController.delegate = self;
    
//    [self.revealViewController tapGestureRecognizer];
    
//    [self.revealViewController panGestureRecognizer];

    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    
    
    //new change for landscape video
    ///*
    if([self isDeviceIpad]==YES){
        UIDevice* device = [UIDevice currentDevice];
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            [showHeaderView setHidden:YES];
            [_headerScroll setHidden:YES];
            [_nowView setHidden:YES];
            [_showViewButton setHidden:YES];
            [_contentViewButton setHidden:YES];
            [_bannerView setHidden:YES];
            [self hideViewOnLandscape];
        }
        
    }
    //*/
}
-(void)hideViewOnLandscape{
    //new change for landscape video
    [self.playerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.playerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.playerContainer.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT+10);
        self.playerView.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT+10);
        
    } completion:^(BOOL finished) {
    }];
    [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.playerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    //new
    [showHeaderView setHidden:YES];
    [_headerScroll setHidden:YES];
    [_nowView setHidden:YES];
    [_showViewButton setHidden:YES];
    [_contentViewButton setHidden:YES];
    [_bannerView setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [mainChannelView removeFromSuperview];
    [mainChannelView close];
    mainChannelView = nil;
    
    [ondemandView removeFromSuperview];
    [ondemandView close];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.playerView stopVideo];

}
#pragma mark - setUpSearchBarInNavigation
-(void) setUpSearchBarInNavigation{
    searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(5, -5, self.view.frame.size.width-10, 48)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBarView setShowsCancelButton:YES];
    searchBarView.delegate = self;
    [searchBarView setTintColor:[UIColor whiteColor]];
   // searchBarView.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
    searchBarView.barTintColor =GRAY_BG_COLOR
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
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    [searchTextField becomeFirstResponder];
    [searchBarView setHidden:NO];
    searchBarView.tag =1001;
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
    searchVC.isFromChannel      = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [searchTextField resignFirstResponder];
    return YES;
}

#pragma mark - CONTENT TESTING
- (void)showStreamTable:(id)sender {
//    [_contentViewButton setBackgroundColor:[UIColor whiteColor]];
//    [_showViewButton setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f]];
    
    [_contentViewButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:94.0f/255.0f alpha:1.0f]];
    [_showViewButton setBackgroundColor:[UIColor colorWithRed:8.0f/255.0f green:30.0f/255.0f blue:43.0f/255.0f alpha:1.0f]];
    
    
    [_showViewButton setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    [_contentViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    if([arrayStreams count]==0){
//        if([channelTitleLabelArray count]!=0){
//            NSDictionary *selectedChannelTempDict   = [[channelTitleLabelArray objectAtIndex:0] mutableCopy];
//            [self updateShowViewTable:selectedChannelTempDict];
//        }
//           else{
//               [self updateStreams:[self.youtubeID intValue]];
//           }
//    }
    
    [self.tableStreams setHidden:false];
    [self.tableContent setHidden:true];
    [newScrollGridView setHidden:YES];
}
- (void)showContentTable:(id)sender {
//    [_showViewButton setBackgroundColor:[UIColor whiteColor]];
//    [_contentViewButton setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f]];
    
    [_contentViewButton setBackgroundColor:[UIColor colorWithRed:8.0f/255.0f green:30.0f/255.0f blue:43.0f/255.0f alpha:1.0f]];
    [_showViewButton setBackgroundColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:94.0f/255.0f alpha:1.0f]];
    
    [_showViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_contentViewButton setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    
    
    
    [self.tableStreams setHidden:true];
    [self.tableContent setHidden:true];
    [newScrollGridView setHidden:NO];
    
    //[self setChannelViewScroll];
}

#pragma mark - Gesture Delegate Methods
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
  
    return YES;//NO
}
- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
   return YES;//NO
}
#pragma mark - viewWillDisappear

#pragma mark - loadTitleMenuBar
-(void)loadTitleMenuBar{
    [self.mainActivityIndicator setHidden:false];
    
    m_ArrayCategories = [[COMMON retrieveContentsFromFile:LIVE_CATEGORIES dataType:DataTypeArray] mutableCopy];
    
    if (m_ArrayCategories == NULL) {
        [[RabbitTVManager sharedManager] getAllCategories:^(AFHTTPRequestOperation *operation, id responseObject) {
            m_ArrayCategories = responseObject;
            [self loadAllCategories];
            
            [COMMON removeLoading];
        }];
    } else {
        [self loadAllCategories];
        [COMMON removeLoading];
    }
}
#pragma mark - getFormattedArray
-(NSMutableArray *) getFormattedArray:(NSMutableArray *)categoryArray {
    NSMutableDictionary *currentDictionary;
    for (int i=0; i<[categoryArray count]; i++) {
        currentDictionary = [[categoryArray objectAtIndex:i] mutableCopy];
        for (NSString *key in [currentDictionary allKeys]) {
            if ([[currentDictionary valueForKey:key] isKindOfClass:[NSString class]] && [[currentDictionary valueForKey:key] isEqualToString:@""]) {
                [currentDictionary setValue:[NSNull null] forKey:key];
            }
        }
        [categoryArray replaceObjectAtIndex:i withObject:currentDictionary];
    }
    return categoryArray;
}
#pragma mark - loadAllCategories
- (void) loadAllCategories {
    m_ArrayCategories = [self getFormattedArray:[m_ArrayCategories mutableCopy]];
    if([m_ArrayCategories isKindOfClass:[NSArray class]]){
        [self.mainActivityIndicator setHidden:false];
        //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[ChanelManager sharedChanelManager] initWithJsonData:m_ArrayCategories];
        rootCategories = [[ChanelManager sharedChanelManager] subCatergories:nil];
        [self removalOfPopularArray];
        [self.tableStreams reloadData];
        [self setTitleScrollBar];
    }
    [self.mainActivityIndicator setHidden:true];
}

#pragma mark - removalOfPopularArray
-(void)removalOfPopularArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [rootCategories mutableCopy] ;
    for (int i=0;i<[tempArray count];i++) {
        NSString *string = [[[[tempArray mutableCopy] valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string isEqualToString:@"Popular"]){
            [rootCategories removeObjectAtIndex:i];
        }
        
    }
    
}


#pragma mark - SCROLL HEADER
-(void)setTitleScrollBar{

CGFloat commonWidth;
commonWidth = [UIScreen mainScreen].bounds.size.width;
    NSMutableArray *titleArray =[[NSMutableArray alloc] init];
    if(rootCategories!=nil){
        for(int i = 0; i < [rootCategories count]; i++)
        {
            NSString *buttonTitle = [[rootCategories objectAtIndex:i]valueForKey:@"name"];
                        
            [titleArray addObject:buttonTitle];
            
            NSLog(@"buttonTitleTEST-->%@",buttonTitle);
        }
        NSLog(@"titleArrayTEST-->%@",titleArray);
        showHeaderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, commonWidth, 44)];
       // [showHeaderView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
        _headerScroll = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, commonWidth, showHeaderView.frame.size.height)];
        [showHeaderView addSubview:_headerScroll];
        [self.view addSubview:showHeaderView];
        
        //new color change
       // [_headerScroll setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
        
        showHeaderView.backgroundColor = GRAY_BG_COLOR;
        _headerScroll.backgroundColor = GRAY_BG_COLOR;
        
        _headerScroll.sectionTitles = titleArray;
        _headerScroll.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _headerScroll.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _headerScroll.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        if(isFirstScrollHeader!=YES){
            _headerScroll.selectionIndicatorColor = [UIColor whiteColor];
            _headerScroll.selectedSegmentIndex = visibleSection;
        }else{
            _headerScroll.selectedSegmentIndex = 4;
        }
        
        [_headerScroll addTarget:self action:@selector(segmentedControlChangedValueChannelsPage:) forControlEvents:UIControlEventValueChanged];
        
        [_headerScroll setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            NSAttributedString *attString;
            
            if (selected) {
//                if(isFirstScrollHeader!=YES){
//                    attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
//                    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//                    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
//                }
//                else{
                    attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
                    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
                    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
                //}
                
                
                return attString;
            } else {
                attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
                segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
                segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
                
                return attString;
            }
        }];

    }
    

}

- (void)segmentedControlChangedValueChannelsPage:(HMSegmentedControl *)sender {
    isFirstScrollHeader=NO;
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    visibleSection = sender.selectedSegmentIndex;
    
    bTitleCagtegoryShown = false;
    bMenuCategoryShown = false;
    
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    //[self.view endEditing:YES];
    
    [mainChannelView removeFromSuperview];
    [mainChannelView close];
    mainChannelView = nil;
    [self.menuView removeFromSuperview];
    
    Category* category = rootCategories[visibleSection];
    NSString* strID = [category idCategory];
    NSString* strIdCheck = [NSString stringWithFormat:@"%@",strID];
    
    if(![requestId isEqualToString:strIdCheck]){
        [[RabbitTVManager sharedManager]cancelRequest];
        [mainChannelView close];
        mainChannelView = nil;
        [self onDismissMenuView];
    }
    
    NSMutableArray* arrCategories = [[ChanelManager sharedChanelManager] subCatergories:strID];
    arrCategoriesTempArray = [[NSMutableArray alloc]init];
    arrCategoriesTempArray = arrCategories;
    if([arrCategories count]==0)
    {
        NSString *strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,strID];
        
        onWatchChannelArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];
        if([onWatchChannelArray count]==0){
            [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
                m_ArrayChannelsList =responseObject;
                requestId = [NSString stringWithFormat:@"%@",strID];
                CommonChannelId = strID;
                onWatchChannelArray = m_ArrayChannelsList;
                [self syncChannelData:strID withResponse:responseObject];
                [self showChanelList:m_ArrayChannelsList];
                [self.tableStreams reloadData];
            } catID:[strID intValue]];
        }
        else{
            m_ArrayChannelsList =onWatchChannelArray;
            requestId = [NSString stringWithFormat:@"%@",strID];
            CommonChannelId = strID;
            [self syncChannelData:strID withResponse:onWatchChannelArray];
            [self showChanelList:m_ArrayChannelsList];
            [self.tableStreams reloadData];
            
        }
    }else{
        [self.mainActivityIndicator setHidden:false];
        [self showCategoryList:arrCategories];
        [self.tableStreams reloadData];
    }
    [self.mainActivityIndicator setHidden:true];
}

#pragma mark - loadLatestChannelData
-(void)loadLatestChannelData{
    [newScrollGridView setHidden:NO];
    if(CommonChannelId==nil){
        CommonChannelId =@"145";
        previousCommonChannelId=@"145";
    }
    NSString *strChannelVideoFileName;
    NSLog(@"CommonChannelId-->%@",CommonChannelId);

    strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,CommonChannelId];
    
    latestNewsArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];
    [self loadDataArray:latestNewsArray];
    if ([latestNewsArray count] == 0) {
       // [AppCommon showSimpleAlertWithMessage:@"check Dataload latest"];
        NSLog(@"check here latestNewsArray");
         [self removeIndicator];
    }
    else {
        //NSString *strChannelViewScrollId = [NSString stringWithFormat:@"%@",setChannelViewScrollId];
        NSString *strCommonChannelId;

        strCommonChannelId= [NSString stringWithFormat:@"%@",CommonChannelId];
        
        [self setChannelViewScroll];
        [self removeIndicator];
        [COMMON removeLoading];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self.mainActivityIndicator setHidden:true];
        NSLog(@"check here loadDataArray");
    }
}
#pragma mark - loadDataArray
- (void)loadDataArray:(NSMutableArray*)latestArray{
    NSString* stringToFind = @"-";
    NSMutableArray * checkArray = [[NSMutableArray alloc]init];
    
    for(NSDictionary * anEntry in latestArray)
    {
        NSString * url = [anEntry valueForKey:@"id"];
        NSString *checkCount = [NSString stringWithFormat:@"%@",url];
        if(![checkCount containsString: stringToFind]){
             [checkArray addObject:anEntry];
        }
    }
    latestNewsArray= checkArray;
    NSLog(@"check here stringToFind");
}
#pragma mark - getChannelVideosForCategoryId
-(NSMutableArray *) getChannelVideosForCategoryId:(NSString *) strCategoryId {
    
    NSString *strChannelVideoFileName        = [NSString stringWithFormat:YOULIVE_CHANNELS_SUB_CATEGORIES,strCategoryId];
    NSMutableArray *channelVideosArray       = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeDic] mutableCopy];
    NSLog(@"check here getChannelVideos");
    if (channelVideosArray == NULL) {
         NSLog(@"check here getChannelVideos NULL");
//        [[RabbitTVManager sharedManager] getStreamsLimit:^(AFHTTPRequestOperation * request, id responseObject) {
//            NSLog(@"check");
//            }
//         failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"responseerror%@",error);
//            
//        } chanID:[strCategoryId intValue]];
    }
    return channelVideosArray;
}

//SETTING UP FOR DYNAMIC
#pragma mark - syncChannelData
- (void) syncChannelData:(NSString*)idCategory withResponse:(NSMutableArray *)responseObject{
   
    NSString *strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,idCategory];
   
    latestNewsArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];
    
    if ([latestNewsArray count] == 0) {
         //[self loadDataArray:latestNewsArray];
        isLocal=NO;
        NSString *strCategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS,idCategory];
        saveContentsToFile(responseObject,strCategoryFile);
        [self syncChannelDataSubCategories:responseObject];
        [COMMON removeProgressHud];
        [COMMON removeLoading];
        
    }
    else {
        [self loadDataArray:latestNewsArray];
        isLocal=YES;
        NSString *strChannelViewScrollId = [NSString stringWithFormat:@"%@",setChannelViewScrollId];
        NSString *strCommonChannelId;
        
        strCommonChannelId= [NSString stringWithFormat:@"%@",CommonChannelId];
        if(![strChannelViewScrollId isEqualToString:strCommonChannelId]){
            [self setChannelViewScroll];
        }
        [COMMON removeProgressHud];
        [COMMON removeLoading];
        [self.mainActivityIndicator setHidden:true];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
}
#pragma mark - syncChannelDataArtist
- (void) syncChannelDataArtist:(NSString*)idCategoryLetter withResponse:(NSMutableArray *)responseObject{
    
    NSString *strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,idCategoryLetter];
    
    latestNewsArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];
    
    if ([latestNewsArray count] == 0) {
        isLocal=NO;
        NSString *strCategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS,idCategoryLetter];
        saveContentsToFile(responseObject,strCategoryFile);
        [self syncChannelDataSubCategories:responseObject];
    }
    else {
        [self loadDataArray:latestNewsArray];
        isLocal=YES;
         //NSString *ActorId = [NSString stringWithFormat:@"%@",CommonChannelId];
        NSString *strChannelViewScrollId = [NSString stringWithFormat:@"%@",setChannelViewScrollId];
        NSString *strCommonChannelId;
//        if([ActorId isEqualToString:@"482"]||[ActorId isEqualToString:@"484"]||[ActorId isEqualToString:@"486"]){
//            strCommonChannelId= [NSString stringWithFormat:@"%@",artistMusicalId];
//        }
        //else{
            strCommonChannelId= [NSString stringWithFormat:@"%@",CommonChannelId];
       // }
        if(![strChannelViewScrollId isEqualToString:strCommonChannelId]){
            [self setChannelViewScroll];
        }
        [COMMON removeLoading];
        [self.mainActivityIndicator setHidden:true];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
}
#pragma mark - syncChannelDataSubCategories
- (void) syncChannelDataSubCategories:(id)responseObject {
    NSMutableArray *array;
    array = [[NSMutableArray alloc] init];
    NSMutableArray *categoryArray =[[NSMutableArray alloc] initWithArray:responseObject];
    for (int i = 0; i<[categoryArray count]; i++) {
        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:categoryArray[i]];
        int nChannelID = [dictItem[@"id"] intValue];
        [[RabbitTVManager sharedManager] getStreamsLimit:^(AFHTTPRequestOperation * request, id responseObject) {
            NSString *subCatchannelId =[NSString stringWithFormat:@"%d",nChannelID];;
            NSString *strSubcategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS_SUB_CATEGORIES,subCatchannelId];
            saveContentsToFile(responseObject, strSubcategoryFile);
            
            if (i == [categoryArray count]-1) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadLatestChannelData];
                        videoCountArray = categoryArray;
                        
                    });
                });
                [self.mainActivityIndicator setHidden:true];
                [COMMON removeLoading];
                [COMMON removeProgressHud];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                
            }
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"responseerror%@",error);
            [COMMON removeLoading];
            [COMMON removeProgressHud];
        } chanID:nChannelID];
    }
}

#pragma mark  - CHANNEL VIEW
-(void) addScrollView{
    
}
#pragma mark - setChannelViewScroll
-(void)setChannelViewScroll
{
    NSLog(@"check here setChannelViewScroll");
    setChannelViewScrollId= [NSString stringWithFormat:@"%@",CommonChannelId];
    [newScrollGridView setHidden:NO];
    for(UIView *view in newScrollGridView.subviews){
        [view removeFromSuperview];
    }
//    CGRect showViewButtonFrame = _showViewButton.frame;
//    CGFloat showViewButtonFrameMaxY = CGRectGetMaxY(showViewButtonFrame);
//    
//    [newScrollGridView setTranslatesAutoresizingMaskIntoConstraints:YES];
//    CGRect newScrollGridViewFrame = [newScrollGridView frame];
//    CGFloat widthView = SCREEN_WIDTH;
//    CGFloat heightView = SCREEN_HEIGHT/2;
//    CGFloat x_Pos = 0;
//    CGFloat y_Pos = showViewButtonFrameMaxY;//_showViewButton.frame.origin.y+_showViewButton.frame.size.height;
//    newScrollGridViewFrame = CGRectMake(x_Pos, y_Pos, widthView, heightView);
//    [newScrollGridView setFrame:newScrollGridViewFrame];
    
   
    
//    for(UIView *view in newScrollGridView.subviews){
//         [view removeFromSuperview];
//        if ([view isKindOfClass:[UILabel class]]) {
//            [view removeFromSuperview];
//        }
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            [view removeFromSuperview];
//        }
//        if ([view isKindOfClass:[UIView class]]) {
//            [view removeFromSuperview];
//        }
//        if ([view isKindOfClass:[UIImageView class]]) {
//            [view removeFromSuperview];
//        }
//        
//    }
    
    if([views count]!=0){
        [views removeAllObjects];
    }
    channelTitleTempArray = [NSMutableArray new];
    
    views = [NSMutableArray new];
    UIView *ChannelBackgroundView = [UIView new];
    
    int k =0,m = 0;
    if([channelVideoTitleLabelArray count]!=0){
        [channelVideoTitleLabelArray removeAllObjects];
    }
    if(isTitleAction==NO){
        if([channelTitleLabelArray count]!=0){
            [channelTitleLabelArray removeAllObjects];
        }
    }
    NSString *videoDuration;
    for(int i = 0; i < [latestNewsArray count]; i++)
    {
        NSLog(@"check here for latestNewsArray");
        NSString *strCategoryId;// = [NSString stringWithFormat:@"%@",[[latestNewsArray objectAtIndex:i] objectForKey:@"id"]];
        if(isTitleAction==YES){
            strCategoryId = [NSString stringWithFormat:@"%@",[[channelTitleLabelArray objectAtIndex:i]objectForKey:@"id"]];
        }
        else{
            strCategoryId = [NSString stringWithFormat:@"%@",[[latestNewsArray objectAtIndex:i] objectForKey:@"id"]];
        }
        NSMutableArray *channelVideosArray = [self getChannelVideosForCategoryId:strCategoryId];
        NSMutableArray *channelVideosTitleArray;
        if ([channelVideosArray count] == 0) {
            break;
        }
        else{
            NSDictionary *resDict = (NSDictionary *) channelVideosArray;
            NSDictionary *resChannel = resDict[strCategoryId];
            if(resChannel==nil){
                isResChannelNil=YES;
                break;
            }
            channelVideosTitleArray =  [NSMutableArray arrayWithArray:resChannel[@"videos"]];
            
            if(isFirstChannelView==YES){
                if(i==0){
                    arrayStreams =  [channelVideosTitleArray mutableCopy];
                    //[self loadTableStreamsData];
                    [self performSelector:@selector(loadTableStreamsData) withObject:nil afterDelay:0.5];
                    isFirstChannelView=NO;
                }
            }
            
            videoDuration = resChannel[@"duration"];
//            if(isChannelGridClicked==YES){
//                _arrayStreamsTemp = [NSMutableArray new];
//                _arrayStreamsTemp = channelVideosTitleArray;
//                if ([channelVideosTitleArray count] == 0) {
//                   // [self startPlay];
//                }
//                isChannelGridClicked=NO;
//            }
           
        }
        
        for(int j = 0; j < 16; j++)
        {
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                ChannelBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width/2.5,60)];
            }
            else{
                ChannelBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width -160,40)];
            }
            
            CGFloat ChannelBackgroundViewWidth = ChannelBackgroundView.frame.size.width;
            CGFloat extrawidth=0.0f;

            
            UIImageView *titleImage;
            UILabel *titleLabel;
            UILabel *startTimeLabel;
            UILabel *touchLabel;
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 40, 40)];//widthChannelBackgroundView.frame.size.width -320
            }
            else{
                titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            }
            
            NSString* strPosterUrl;
            NSString* strTitleName;
            NSString* strVideoId;
            NSString* strVideoTitle;
            NSString* strVideoTitleUrl;
            NSString* strCurrentVideoDuration;
            NSString* strStartTime;
            
            if(isTitleAction==YES){
                strPosterUrl = [[channelTitleLabelArray objectAtIndex:i]valueForKey:@"big_logo_url"];
                strTitleName = [[channelTitleLabelArray objectAtIndex:i]valueForKey:@"name"];
            }
            else{
                strPosterUrl = [[latestNewsArray objectAtIndex:i]valueForKey:@"big_logo_url"];
                strTitleName = [[latestNewsArray objectAtIndex:i]valueForKey:@"name"];
            }
            if ([channelVideosTitleArray count] == 0) {
                strVideoTitle = @"";
                strVideoTitleUrl = @"";
                strStartTime=@"my test";
            }
            else{
                if ((NSString *)[NSNull null] == videoDuration) {
                    strVideoTitle = @"No Data";
                    strVideoTitleUrl = @"";
                }
                else
                {
                    
                    if(j==0){
                        [channelTitleTempArray addObject:[channelVideosTitleArray objectAtIndex:j]];
                        
                    }
                    else{
                        //int test = 1-j;
                        
                        strVideoId = [[channelVideosTitleArray objectAtIndex:j-1] valueForKey:@"id"];
                        strVideoTitle = [[channelVideosTitleArray objectAtIndex:j-1] valueForKey:@"title"];
                        strVideoTitleUrl = [[channelVideosTitleArray objectAtIndex:j-1] valueForKey:@"url"];
                        strCurrentVideoDuration = [[channelVideosTitleArray objectAtIndex:j-1] valueForKey:@"duration"];
                        strStartTime = [[channelVideosTitleArray objectAtIndex:j-1] valueForKey:@"time"];
                        //strCurrentVideoDuration
                        
                    }
                    
                    if ((NSString *)[NSNull null] == strCurrentVideoDuration || strCurrentVideoDuration==nil) {
                        strCurrentVideoDuration=@"";
                    }
                    extrawidth = (([strCurrentVideoDuration intValue]/60)*2);//(([strCurrentVideoDuration intValue]/60)*4)
                    CGRect frame = ChannelBackgroundView.frame;
                    frame.size.width = ChannelBackgroundViewWidth + extrawidth;
                    [ChannelBackgroundView setFrame:frame];

                }
            }
            if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl==nil) {
                strPosterUrl=@"";
            }
            if ((NSString *)[NSNull null] == strTitleName||strTitleName==nil) {
                strTitleName=@"";
            }
            if ((NSString *)[NSNull null] == strVideoId||strVideoId==nil) {
                strVideoId=@"";
            }
            if ((NSString *)[NSNull null] == strVideoTitle||strVideoTitle==nil) {
                strVideoTitle=@"";
            }
            if ((NSString *)[NSNull null] == strVideoTitleUrl||strVideoTitleUrl==nil) {
                strVideoTitleUrl=@"";
            }
            //strStartTime
            if ((NSString *)[NSNull null] == strStartTime||strStartTime==nil) {
                strStartTime=@"";
            }
            
            asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0, 0,titleImage.frame.size.width, titleImage.frame.size.height)];
            [asyncImage setLoadingImage];
            [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                                    type:AsyncImageResizeTypeCrop
                                 isCache:YES];
            
            if(j==0){
                
                touchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ChannelBackgroundView.frame.size.width, ChannelBackgroundView.frame.size.height)];
                
                CGFloat titleLabelXPos = titleImage.frame.origin.x+titleImage.frame.size.width+8;
                titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(titleLabelXPos, 0, ChannelBackgroundView.frame.size.width-(titleLabelXPos), ChannelBackgroundView.frame.size.height)];
                titleLabel.text = strTitleName;
                titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(12)];
                [titleImage addSubview:asyncImage];
               
                if ([latestNewsArray count] == 0) {
                }
                else{
                    if([channelTitleLabelArray count] > [latestNewsArray count]){
                        [channelTitleLabelArray removeLastObject];
                    }
                    else{
                        [channelTitleLabelArray addObject:[latestNewsArray objectAtIndex:i]];
                        
                    }
                    touchLabel.tag = m;
                }
                ChannelBackgroundView.tag = m;
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionLeftTitle:)];
                tapGestureRecognizer.numberOfTapsRequired = 1;
                [ChannelBackgroundView addGestureRecognizer:tapGestureRecognizer];
                ChannelBackgroundView.userInteractionEnabled = YES;
                
                if(i==0 & j==0){
                    myIndex=0;
                    previousView = ChannelBackgroundView;
                    //new clor change
                    //ChannelBackgroundView.backgroundColor=[UIColor colorWithRed:15.0f/255.0f green:95.0f/255.0f blue:166.0f/255.0f alpha:1];
                    ChannelBackgroundView.backgroundColor = [UIColor lightGrayColor];
                    //[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
                }
                
                else{
                    //ChannelBackgroundView.backgroundColor=[UIColor blackColor];
                   //ChannelBackgroundView.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:74.0f/255.0f blue:124.0f/255.0f alpha:1];
                    
                     ChannelBackgroundView.backgroundColor = GRAY_BG_COLOR;
                }
                 titleLabel.textAlignment = NSTextAlignmentLeft;
                
            }
            else{
                
                touchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ChannelBackgroundView.frame.size.width, ChannelBackgroundView.frame.size.height)];
                touchLabel.text = strVideoTitle;
                
                titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, ChannelBackgroundView.frame.size.width-16, ChannelBackgroundView.frame.size.height/2)];
                titleLabel.text = strVideoTitle;
                [titleImage setHidden:YES];
                titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(11)];
                
                
                startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, titleLabel.frame.size.height, ChannelBackgroundView.frame.size.width-16, ChannelBackgroundView.frame.size.height/2)];
                NSLog(@"TEST NULL-->%@",strStartTime);
                startTimeLabel.text = [NSString stringWithFormat:@"Start Time: %@",strStartTime];
                startTimeLabel.font = [COMMON getResizeableFont:Roboto_Light(10)];
               // ChannelBackgroundView.backgroundColor=[UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1];//old
               //ChannelBackgroundView.backgroundColor=[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:94.0f/255.0f alpha:1];//new
                //start [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:94.0f/255.0f alpha:1.0f]
                if ([channelVideosTitleArray count] == 0) {
                }
                else{
                    [channelVideoTitleLabelArray addObject:strVideoTitleUrl];
                    touchLabel.tag = k;
                    k++;
                }
                if(StreamTitle == strVideoTitle){
                    //ChannelBackgroundView.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
                    ChannelBackgroundView.backgroundColor = GRAY_BG_COLOR;
                }
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionVideoTitle:)];
                tapGestureRecognizer.numberOfTapsRequired = 1;
                [touchLabel addGestureRecognizer:tapGestureRecognizer];
                touchLabel.userInteractionEnabled = YES;
                 titleLabel.textAlignment = NSTextAlignmentLeft;
                
            }
            startTimeLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.numberOfLines = 0;
            startTimeLabel.numberOfLines = 0;
            titleLabel.textColor = [UIColor whiteColor];
            startTimeLabel.textColor = [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];
           
            touchLabel.textColor = [UIColor clearColor];
            [touchLabel setBackgroundColor:[UIColor clearColor]];
            [ChannelBackgroundView addSubview:titleLabel];
            [ChannelBackgroundView addSubview:startTimeLabel];
            [ChannelBackgroundView addSubview:touchLabel];
            [ChannelBackgroundView addSubview:titleImage];
            ChannelBackgroundView.layer.borderWidth =0.8;
           // ChannelBackgroundView.layer.borderColor =[UIColor colorWithRed:0.0f/255.0f green:74.0f/255.0f blue:124.0f/255.0f alpha:1.5].CGColor;
            ChannelBackgroundView.layer.borderColor =[UIColor colorWithRed:139.0f/255.0f green:143.0f/255.0f blue:144.0f/255.0f alpha:1.0f] .CGColor;
            [views addObject:ChannelBackgroundView];
            
            
        }
        m++;
        
    }
    [self setScrollToChannel:ChannelBackgroundView];

    
}

#pragma mark - setScrollToChannel
-(void) setScrollToChannel:(UIView*)ChannelBackgroundView{
    
   
   UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(newScrollGridView.frame.origin.x, 0, newScrollGridView.frame.size.width, newScrollGridView.frame.size.height)];
   // UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(newScrollGridView.frame.origin.x, 0, SCREEN_WIDTH, (SCREEN_HEIGHT/2))];

    scroll.decelerationRate = UIScrollViewDecelerationRateFast;
    scroll.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    newScrollGridView.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    scroll.pagingEnabled = NO;
    int separationX = 0;
    int separationY = 0;
    int numberOfViews = (int) self.views.count;
    int column = 16;
    int row = (numberOfViews % column == 0)? (numberOfViews/column) : ((numberOfViews/column) + 1);
    int count = 1;
    int xMax = 0;
    int yMax = 0;
    CGFloat maxX =0.0f;
    CGRect channelFrame;
    for (int i = 1; i <= row; i++) {
        maxX = 0.0f;
        for (int j = 1; j <= column; j++) {
            if (count <= numberOfViews) {
                ChannelBackgroundView = (UIView*)[self.views objectAtIndex:count-1];
                int x = (j-1)*ChannelBackgroundView.frame.size.width + separationX;
                int y = (i-1)*ChannelBackgroundView.frame.size.height + separationY;
                xMax = (xMax>x)?xMax:x;
                yMax = (yMax>y)?yMax:y;
                [scroll addSubview:ChannelBackgroundView];
               // ChannelBackgroundView.frame= CGRectMake(x, y, ChannelBackgroundView.frame.size.width, ChannelBackgroundView.frame.size.height);
//                int tempX = j-1;
//                if(tempX==0){
//                    maxX = 0.0f;
//                }
                channelFrame = ChannelBackgroundView.frame;
                ChannelBackgroundView.frame= CGRectMake(maxX, y, ChannelBackgroundView.frame.size.width, ChannelBackgroundView.frame.size.height);
                
                maxX = CGRectGetMaxX(channelFrame)+maxX;
            } else {
                break;
            }
            count++;
        }
    }
    scroll.directionalLockEnabled = YES;
    CGRect contentRect = CGRectZero;
        for (UIView *view in scroll.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        CGFloat scrollWidth  = contentRect.size.width;
    
        if(isHiddenBannerView==YES){
            scroll.contentSize = CGSizeMake(scrollWidth, yMax + ChannelBackgroundView.frame.size.height);
    
        }else{
            scroll.contentSize = CGSizeMake(scrollWidth, yMax + ChannelBackgroundView.frame.size.height+50);
        }
    
    [newScrollGridView addSubview:scroll];
    isTitleAction=NO;
    isResChannelNil = NO;

    
}


#pragma mark - tapActions
- (void)tapActionLeftTitle:(UITapGestureRecognizer *)tap {
    NSLog(@"tap-->%@",tap);
    isFirstChannelView=YES;
    //UILabel *currentLabel   = (UILabel *) tap.view;
    UIView *currentView  = (UIView *) tap.view;
    //NSMutableArray *selectedArray   = [channelTitleLabelArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag];
    NSInteger selectedIndex = currentView.tag;
    
    if(prevTappedTag!=selectedIndex){
         previousView.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:74.0f/255.0f blue:124.0f/255.0f alpha:1];
        
    }
    
    prevTappedTag = selectedIndex;
    previousView  = (UIView *) tap.view;
    isTitleAction =YES;
    
    
    //UIView *ChannelBackgroundView = (UIView*)[self.views objectAtIndex:selectedIndex];
    //UIView *prevView  = (UIView *) prevTappedTag;
    //[channelTitleLabelArray removeObjectAtIndex:selectedIndex];
    //[channelTitleLabelArray insertObject:selectedArray atIndex:0];
    
    NSDictionary *selectedChannelTempDict   = [[channelTitleLabelArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag] mutableCopy];
    [self updateShowViewTable:selectedChannelTempDict];
    
    //new clor change
   // currentView.backgroundColor=[UIColor colorWithRed:15.0f/255.0f green:95.0f/255.0f blue:166.0f/255.0f alpha:1];
    currentView.backgroundColor= GRAY_BG_COLOR;
    
  //  NSLog(@"channelTitleTempArray-->%@",channelTitleTempArray);
   // NSMutableDictionary *selectedTempDict   = [[channelTitleTempArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag] mutableCopy];
    
//    isChannelGridClicked=YES;
//    if(isChannelGridClicked==YES){
//        _arrayStreamsTemp = [NSMutableArray new];
//        [_arrayStreamsTemp addObject:selectedTempDict];
//        if ([_arrayStreamsTemp count] != 0) {
//            if(myIndex!=selectedIndex){
//                //[self startPlay];
//                
//                myIndex = selectedIndex;
//            }
//            
//        }
//        isChannelGridClicked=NO;
//    }

    //isChannelGridClicked=YES;
    //[self setChannelViewScroll];
}
-(void)updateShowViewTable:(NSDictionary *)selectedChannelTempDict{
    int nID = [[selectedChannelTempDict valueForKey:@"id"] intValue];
    
    NSString* title = selectedChannelTempDict[@"name"];
    
    isChannelGridClicked=NO;
     //[self updateStreams:nID];
    [self updateTitle:title];
    
    
    NSString *strCategoryId =[NSString stringWithFormat:@"%@",[selectedChannelTempDict valueForKey:@"id"]];
    
    NSMutableArray *channelVideosArray = [self getChannelVideosForCategoryId:strCategoryId];
    
    NSDictionary *retDict = (NSDictionary *) channelVideosArray;
    NSString* strID = [NSString stringWithFormat:@"%d", nID];
    NSDictionary *retChannel = retDict[strID];
    arrayStreams =  [NSMutableArray arrayWithArray:retChannel[@"videos"]]; //
    
    [self.tableStreams reloadData];

    if(self.playerView != nil)
    {
        [self.playerView stopVideo];
        
    }

    [self startPlay];
    [COMMON removeLoading];
    
}
- (void)tapActionVideoTitle:(UITapGestureRecognizer *)tap {
    
    UILabel *currentLabel = (UILabel *) tap.view;
    NSString *strStreamName= currentLabel.text;
    NSString *strUrl = [channelVideoTitleLabelArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag];
    [self showVideoOnDemandDialog:strStreamName URL:strUrl];
    
}
-(void)loadTableStreamsData{
    [self.tableStreams reloadData];
    
    if(self.playerView != nil)
    {
        [self.playerView stopVideo];
    }
    
    [self startPlay];
    isFirstChannelView=NO;
}

#pragma mark - Custom7AlertDialog Delegate

-(void)customIOS7dialogDismiss{
    [mainChannelView close];
    if(bTitleCagtegoryShown)
    {
        bTitleCagtegoryShown = false;
        
    }
    if(bTitleSubCagtegoryShown)
    {
        bTitleSubCagtegoryShown = false;
        
    }
    if(bMenuCategoryShown)
    {
        bMenuCategoryShown = false;
        
    }
}
#pragma mark - MenuView Deleagate
-(void)onDismissMenuView
{
    [mainChannelView close];
    bTitleCagtegoryShown = false;
    bTitleSubCagtegoryShown =false;
    bMenuCategoryShown = false;
}

-(void)mainLeftBarButtonAction{
    bTitleCagtegoryShown = false;
    bTitleSubCagtegoryShown =false;
    bMenuCategoryShown = false;
    [mainChannelView close];
    mainChannelView =nil;
    [self.playerView stopVideo];
    [self.mainActivityIndicator setHidden:true];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
}
-(void)onWatchChanel:(NSString*)idCategory{
    NSLog(@"idCategory-->%@",idCategory);
    [mainChannelView close];
    bTitleCagtegoryShown = false;
    bTitleSubCagtegoryShown =false;
    bMenuCategoryShown = false;
    onWatchChannelId = [NSString stringWithFormat:@"%@",idCategory];
    CommonChannelId = idCategory;
    
    //[self.mainActivityIndicator setHidden:false];
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    //[COMMON LoadIcon:self.view];
    if([m_ArrayCategories count]>1)
        [COMMON loadProgressHud];
    NSString *strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,idCategory];
    
    onWatchChannelArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];

         if([onWatchChannelArray count]==0){
            [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
                musicalArtistArray = responseObject;
                onWatchChannelArray =responseObject;
                [self loadChannelTableList];
            } catID:[idCategory intValue]];
        }
        else{
            //[self performSelector:@selector(loadChannelTableList) withObject:nil afterDelay:0.3];
             [self loadChannelTableList];
        }
    
}
-(void)loadChannelTableList{
    [self syncChannelData:CommonChannelId withResponse:onWatchChannelArray];
    [self performSelector:@selector(loadChannelTableArrayInDelay) withObject:nil afterDelay:0.3];
}
-(void)loadChannelTableArrayInDelay{
    [self showChanelList:onWatchChannelArray];
    [COMMON removeProgressHud];
    [COMMON removeLoading];
}

#pragma mark - TopMenuTablePopUp
-(void)showChanelList:(id)chanelList
{
    //NSString *ActorId = [NSString stringWithFormat:@"%@",CommonChannelId];
    if(chanelList==nil || [chanelList count] == 0)
    {
        return;
    }else{
        m_ArrayChannels = (NSMutableArray*)chanelList;
        
    }
    
    UIDevice* device = [UIDevice currentDevice];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-280, screenHeight-100)];
        }
        else{
            mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-420, screenHeight-280)];
        }

            tableYPosition = 60;
            tableHeight = tvShowView.frame.size.height-tableYPosition;//190;
        
        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, tableYPosition, tvShowView.frame.size.width, tableHeight)];
    }else{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-50, screenHeight-180)];
        }
        else{
            mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-300, screenHeight-360)];
        }

            tableYPosition = 60;
            tableHeight = tvShowView.frame.size.height-tableYPosition;//390;
      
        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, tableYPosition, tvShowView.frame.size.width, tableHeight)];

    }

        tableChannelList.tag = 101;
    
    
    tableChannelList.backgroundColor = [UIColor whiteColor];
    mainChannelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    UILabel* tvLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,tvShowView.frame.size.width, 50)];
    [tvLabel setTextColor:[UIColor blackColor]];
    [tvLabel setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
    [tvLabel setTextAlignment:NSTextAlignmentCenter];
    [tvLabel setBackgroundColor:[UIColor clearColor]];
    UILabel* labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,tvShowView.frame.size.width-30, 50)];
    [labelTitle setText:@"Channels"];//new change //Genre
    [labelTitle setTextColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    [labelTitle setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    UILabel* labelTitleline = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, tvShowView.frame.size.width, 2)];
    [labelTitleline setBackgroundColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 57, tvShowView.frame.size.width, 25)];
    //[selectionButton setBackgroundColor:[UIColor blueColor]];
    [selectionButton setTitle:@"   A" forState:UIControlStateNormal];
     selectionButton.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [selectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectionButton addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
//    if([ActorId isEqualToString:@"482"]||[ActorId isEqualToString:@"484"]||[ActorId isEqualToString:@"486"]){
//        [selectionButton setHidden:NO];
//    }
   // else{
        [selectionButton setHidden:YES];
    //}
    
    [tvShowView setBackgroundColor : [UIColor whiteColor]];
    [tvShowView addSubview:tvLabel];
    [tvShowView addSubview:labelTitle];
    [tvShowView addSubview:labelTitleline];
    [tvShowView addSubview:selectionButton];
    [tvShowView addSubview:tableChannelList];
    [mainChannelView setContainerView:tvShowView];
    [mainChannelView show];
    
    bTitleCagtegoryShown = false;
    bMenuCategoryShown = true;
}
#pragma mark - checkLetterAMusic
-(void) checkLetterArtist:(NSString *)letterString{
    NSString *selectedLetter = letterString;
    NSString* stringToFind = @".";
    myArray = [[NSMutableArray alloc]init];
    
    for(NSDictionary * anEntry in musicalArtistArray)
    {
        NSString * name = [anEntry valueForKey:@"name"];
        NSString *checkCount = [NSString stringWithFormat:@"%@",name];
        NSMutableString *checkstr = [NSMutableString stringWithFormat:@"%@",name];
        if(![checkCount containsString: stringToFind]){
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                          @"([0-9]+)" options:0 error:nil];
            
            [regex replaceMatchesInString:checkstr options:0 range:NSMakeRange(0, [checkstr length]) withTemplate:@"A"];
            NSMutableDictionary *resultDict = [anEntry mutableCopy];
            [resultDict setObject:checkstr forKey:@"name"];
            NSString* stringFirstLetter =[checkstr substringToIndex:1];
            
            if([selectedLetter isEqualToString:stringFirstLetter]){
                [myArray addObject:resultDict];
            }
        }
    }
    [self sortingArray:myArray];
     myArray = sortedArray;
}
- (IBAction)selectClicked:(id)sender {
    
    NSArray * alphaArray = [[NSArray alloc] init];
    alphaArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"I", @"J", @"K",
            @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",nil];
   
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :alphaArray  :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
#pragma mark - niDropDownDelegateMethod
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
   
    NSString *selectedLetter = selectionButton.titleLabel.text;
    
    [self checkLetterArtist:selectedLetter];
    
    
    m_ArrayChannels = myArray;
    NSString *catIdLetter = [NSString stringWithFormat:@"%@%@",CommonChannelId,selectedLetter];
    artistMusicalId = catIdLetter;
    if(!([m_ArrayChannels count]==0)){
       [self syncChannelDataArtist:catIdLetter withResponse:m_ArrayChannels];
    }
    tableChannelList.tag = 101;
    [tableChannelList reloadData];
    NSString * string = [NSString stringWithFormat:@"  %@",selectedLetter];
    [selectionButton setTitle:string forState:UIControlStateNormal];
    selectionButton.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [selectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
}
-(void)rel{
    dropDown = nil;
}

#pragma mark -Used to Sort An Array
-(void) sortingArray:(NSMutableArray *)responseObject{
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    sortedArray=(NSMutableArray *)[responseObject sortedArrayUsingDescriptors:descriptors];
}

#pragma mark - Other
- (void) showCategoryList:(id) categoryData
{
    [[RabbitTVManager sharedManager]cancelRequest];
    m_ArrayCategories = (NSMutableArray *) categoryData;
    UIDevice* device = [UIDevice currentDevice];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if([categoryData count]==1) {
//        Category* chanel = [m_ArrayCategories firstObject];
//        NSString* idCategory = [chanel idCategory];
//        NSMutableArray* arrCategories = [[ChanelManager sharedChanelManager] subCatergories:idCategory];
//        if([arrCategories count]==0)
//        {
            [COMMON loadProgressHud];
//            [self onWatchChanel:idCategory];
//            return;
//        }
        
        [self performSelector:@selector(loadcategoryList) withObject:nil afterDelay:0.80];
    } else {
        self.menuView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil] objectAtIndex:0];

        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
             if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                 mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                // [self.menuView setFrame:CGRectMake(0, 0, 280, 250)];
                 [self.menuView setFrame:CGRectMake(0, 0, screenWidth-280, screenHeight-100)];
             }
             else{
                 mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                 [self.menuView setFrame:CGRectMake(0, 0, screenWidth-420, screenHeight-280)];
             }
        }else{
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                 mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
              [self.menuView setFrame:CGRectMake(0, 0, screenWidth-50, screenHeight-180)];        }
            else{
                mainChannelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                [self.menuView setFrame:CGRectMake(0, 0, screenWidth-300, screenHeight-360)];
            }
        }

        [self.menuView initWithCategories:m_ArrayCategories];
    }
    self.menuView.delegate =self;

    mainChannelView.delegate = self;

    menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 4,_menuView.frame.size.width-10, 50)];
    [menuTitle setTextColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    [menuTitle setText:@"Sub Categories"];
    [menuTitle setFont:[COMMON getResizeableFont:Roboto_Light(14)]];
    [menuTitle setTextAlignment:NSTextAlignmentLeft];
    menuTitleLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, _menuView.frame.size.width, 2)];
    [menuTitleLine setBackgroundColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    
    menuCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((_menuView.frame.size.width-_menuView.frame.size.width/4),_menuView.frame.size.height-50, _menuView.frame.size.width/4, 50)];
    [menuCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [menuCancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    menuCancelBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [menuCancelBtn setBackgroundColor:[UIColor clearColor]];
    menuCancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [menuCancelBtn addTarget:_menuView action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:menuTitle];
    [self.menuView addSubview:menuTitleLine];
    [self.menuView addSubview:menuCancelBtn];

    [mainChannelView setContainerView:self.menuView];
    [mainChannelView show];

    bTitleCagtegoryShown = true;
    bMenuCategoryShown = false;
    
}

- (void)loadcategoryList {
    Category* chanel = [m_ArrayCategories firstObject];
    NSString* idCategory = [chanel idCategory];
    NSMutableArray* arrCategories = [[ChanelManager sharedChanelManager] subCatergories:idCategory];
    if([arrCategories count]==0)
    {
        [self onWatchChanel:idCategory];
        [COMMON removeProgressHud];

        return;
    }

}
- (void) setPlayView{
    
    _playDurationSlider.minimumValue = 0.0f;
    _playDurationSlider.maximumValue = 100.0f;
    _playDurationSlider.value = 0.0f;
    _playDurationSlider.continuous = YES;
    [_rewindButton setImage:[UIImage imageNamed:@"reloadButton.png"] forState:UIControlStateNormal];
    [_playPauseButton setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [_playPauseButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)playAction:(id)sender
{
    UIButton *buttonSender = (UIButton *)sender;
    _playPauseButton = buttonSender;
    [_playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
}
#pragma mark - hideAds
- (void) hideAds{
    [_bannerView setHidden:YES];
    isHiddenBannerView=YES;
    [self.tableStreams reloadData];
    //[self setChannelViewScroll];
    
}
#pragma mark - setCastSlider
- (void) setCastSlider{
    
    onCastView.layer.borderColor = [UIColor whiteColor].CGColor;
    onCastView.layer.borderWidth = 2.0f;
    [_volumeLabel setText:@"Volume"];
    [_volumeLabel setTextColor:[UIColor whiteColor]];
    [_volumeLabel setFont:[UIFont systemFontOfSize:15]];
    self.volumeSlider.minimumValue = 0.0f;
    self.volumeSlider.maximumValue = 100.0f;
    self.volumeSlider.value = 0.0f;
    self.volumeSlider.continuous = YES;
    UIImage *maximumImage ;
    maximumImage = [UIImage imageNamed:@"slider-metal-trackBackground.png"];
    maximumImage = [maximumImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    UIImage *minimumImage ;
    minimumImage = [UIImage imageNamed:@"slider-metal-track.png"];
    minimumImage = [minimumImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [self.volumeSlider setMinimumTrackImage:minimumImage forState:UIControlStateNormal];
    [self.volumeSlider setMaximumTrackImage:maximumImage forState:UIControlStateNormal];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-metal-handle-highlighted.png"];
    [self.volumeSlider setThumbImage:thumbImage
                            forState:UIControlStateNormal];
    //set this to true if you want the changes in the sliders value
    //to generate continuous update events
    [self.volumeSlider setContinuous:false];
    //attach action so that you can listen for changes in value
    [self.volumeSlider addTarget:self
                          action:@selector(getSliderValue:)
                forControlEvents:UIControlEventTouchDragInside];
    
    [_volumeDisconnectBotton addTarget:self
                                action:@selector(disConnectCasting:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [_volumeCancelBotton addTarget:self
                            action:@selector(cancelCastView:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_volumeMuteButton addTarget:self
                          action:@selector(setMute:)
                forControlEvents:UIControlEventTouchUpInside];
    
    //add the slider to the view
    // [onCastView addSubview:self.volumeSlider];
    
}
#pragma mark - hideOnCastView

-(void) cancelCastView:(id)sender{
    
    [onCastView setHidden:YES];
    
}
-(void) disConnectCasting:(id)sender{
    NSLog(@"Disconnecting device:%@", self.selectedDevice.friendlyName);
    // New way of doing things: We're not going to stop the applicaton. We're just going
    // to leave it.
    [_deviceManager leaveApplication];
    [_deviceManager disconnect];
    [self deviceDisconnected];
    [self updateButtonStates];
    [onCastView setHidden:YES];
}
#pragma mark - setMute
- (void) setMute:(id) sender {
    if (_deviceManager
        || _deviceManager.connectionState == GCKConnectionStateConnected) {
        if (!_deviceManager.deviceMuted) {
            lastDeviceVolume = _deviceManager.deviceVolume;
            [_deviceManager setMuted:YES];
            
            [_volumeMuteButton setImage:[UIImage imageNamed:@"volume_mute"] forState:UIControlStateNormal];
        } else {
            [_deviceManager setMuted:NO];
            [_volumeMuteButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - getSliderValue
- (void) getSliderValue:(UISlider *)paramSender{
    
    if ([paramSender isEqual:self.volumeSlider]){
        float newValue = paramSender.value /10;
        paramSender.value = floor(newValue) * 10;
        
        if (_deviceManager
            || _deviceManager.connectionState == GCKConnectionStateConnected) {
            [_deviceManager setVolume:newValue/10];
        }
        if (newValue > 0) {
            [_deviceManager setMuted:NO];
            [_volumeMuteButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
        } else {
            [_deviceManager setMuted:YES];
            [_volumeMuteButton setImage:[UIImage imageNamed:@"volume_mute"] forState:UIControlStateNormal];
        }
    }
    NSLog(@"Current value of slider is %f", paramSender.value);
    
}

#pragma mark - Other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - fullScreenTouched
-(IBAction) fullScreenTouched:(id)sender
{
    
    if(bFullScreen == true){
        CGSize size = self.view.frame.size;
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        if(whichHeight==0) {
            float Height;
            Height = (170/504.0)*self.view.frame.size.height;
            
            self.playerContainer.frame = CGRectMake(0, 45, size.width, Height);
            self.nowView.frame = CGRectMake(0, Height+45, size.width, 50);
            bFullScreen = false;
            [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
            
        }
        else{
            self.playerContainer.frame = CGRectMake(0, 45, size.width, whichHeight);
            self.nowView.frame = CGRectMake(0, whichHeight+45, size.width, 50);
            bFullScreen = false;
            [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
            
        }
        
        
    }else{
        whichHeight = self.playerContainer.frame.size.height;
        CGSize size = self.view.frame.size;
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.playerContainer.frame = CGRectMake(0, 0, size.width, size.height-100);
        self.nowView.frame = CGRectMake(0, size.height-100, size.width, 50);
        isnowViewAboveAds=true;
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        bFullScreen = true;
    }
}
# pragma mark channel test

- (void)updateChannelData:(NSDictionary *)dictItem
{
    isCurVideo = true;
    NSDictionary* dicInfo = dictItem;
    int nID = [[dicInfo valueForKey:@"id"] intValue];
    NSString* title = dicInfo[@"name"];
    [self updateStreams:nID];
    [self updateTitle:title];
    
}
#pragma mark - Stream Update Module
- (void) loadStream: (NSNotification*) notification
{
    isCurVideo = true;
    if(isReloadTable==true){
        [self.tableStreams scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    NSDictionary* dicInfo = (NSDictionary*)notification.object;
    int nID = [[dicInfo valueForKey:@"id"] intValue];
    NSString* title = dicInfo[@"name"];
    //[self updateStreams:nID];
    
    [self updateStreamsForTest:nID];
    [self updateTitle:title];
}

- (void) updateStreams:(int)nChannelID
{
    if(bFullScreen == YES)
    {
        [self fullScreenTouched:nil];
    }
    
    NSString* strID = [NSString stringWithFormat:@"%d", nChannelID];
    
    @try {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [self.mainActivityIndicator setHidden:true];
        }
        else{
            if(nowViewFirstTime ==true){
                [self.nowView setHidden:YES];
                nowViewFirstTime=false;
            }
            if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
                [self.mainActivityIndicator setHidden:false];
            }
            else
                [self.mainActivityIndicator setHidden:true];
        }
        
        [self.mainActivityIndicator setHidden:false];
        NSLog(@"check here loadStreams");
        NSLog(@"check here loadStreams nChannelID-->%d",nChannelID);
        
        [[RabbitTVManager sharedManager] getStreams:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"check here getStreams");
            NSDictionary *retDict = (NSDictionary *) responseObject;
            NSDictionary *retChannel = retDict[strID];
            arrayStreams =  [NSMutableArray arrayWithArray:retChannel[@"videos"]]; //
            
            if([arrayStreams count]==0){
                [self updateStreams:nChannelID];
                 NSLog(@"check here updateStreams");
                return;
            }
            //[self showAlert];
            [self.tableStreams reloadData];
            [self.view setHidden:NO];
           // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [self.mainActivityIndicator setHidden:true];
    
            if(self.playerView != nil)
            {
                [self.playerView stopVideo];
                
               // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                [self.mainActivityIndicator setHidden:true];
                
            }
            [self.nowView setHidden:NO];
            [self startPlay];
            [COMMON removeLoading];
           
            
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"check here getStreams failed");
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSString* strError;
            strError= [NSString stringWithFormat:@"Channel = %@ , Get Stream Error",strID];
            [AppCommon showSimpleAlertWithMessage:@"No Internet Connection available. Kindly check your Internet"];
            [self.mainActivityIndicator setHidden:true];
            [COMMON removeLoading];
        } chanID:nChannelID];
        
    }
    @catch (NSException *exception) {
        NSLog(@"check here getStreams @catch");
    }
    @finally {
        NSLog(@"check here getStreams @finally");
    }
}

-(void)updateStreamsForTest:(int)nChannelID{
    if(bFullScreen == YES)
    {
        [self fullScreenTouched:nil];
    }
    
    //NSString* strID = [NSString stringWithFormat:@"%d", nChannelID];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.mainActivityIndicator setHidden:true];
    }
    else{
        [self.nowView setHidden:NO];
        if(nowViewFirstTime ==true){
            //[self.nowView setHidden:YES];
            nowViewFirstTime=false;
        }
        if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
            [self.mainActivityIndicator setHidden:false];
        }
        else
            [self.mainActivityIndicator setHidden:true];
    }
    
    [self.mainActivityIndicator setHidden:false];
    NSLog(@"check here loadStreams");
    NSLog(@"check here loadStreams nChannelID-->%d",nChannelID);
    if([arrayStreams count]==0){
        
        NSLog(@"check here updateStreams");
        return;
    }
    //[self showAlert];
    [self.tableStreams reloadData];
    [self.view setHidden:NO];
    // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self.mainActivityIndicator setHidden:true];
    
    //[self.playerView stopVideo];
    
    if(self.playerView != nil)
    {
        [self.playerView stopVideo];
        
        // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self.mainActivityIndicator setHidden:true];
        
    }
    [self.nowView setHidden:NO];
    [self startPlay];
    [COMMON removeLoading];
    
    @try {
        


    }
    @catch (NSException *exception) {
        NSLog(@"check here getStreams @catch");
    }
    @finally {
        NSLog(@"check here getStreams @finally");
    }

}

#pragma mark - Video Playing Module

- (void) startPlay
{
    [self setInformation:0];
    
    if([arrayStreams count]==0){
        //  [self showError:@"Error when starting stream, stream is zero"];
        return;
    }
    NSDictionary* dictItem;
    
    dictItem = arrayStreams[0];
    
    
    NSString* strUrl = dictItem[@"url"];
    
    //Chrome Cast
    BOOL isCast;
    isCast= [self castVideoFromId:0];
    
    //NEWLY Changing showinfo @1 to @0  to hide video info(title) and ShareIcon
    //Changing controls @1 to @0 to hide controls
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay":@1,
                                 @"showinfo" : @0,
                                 @"rel" : @0,
                                 @"controls" : @0,
                                 @"origin" : @"https://www.example.com", // this is critical
                                 @"modestbranding" : @1,
                                 @"autohide":@1,
                                 @"wmode" : @"transparent",
                                 @"hd" : @1,
       
                                 };
    ///hide
    
//    @"autohide":@1,
//    @"wmode" : @"transparent",
//    @"hd" : @1
    
//tried
    //    @"fs" : @0,
    //    @"disablekb": @0,
    //    @"nologo" :@1

//modestbranding=1&rel=0&title=&autohide=1&wmode=transparent&hd=1


    /*NSDictionary *playerVars;
     if(isCast)
     {
     playerVars = @{
     @"playsinline" : @1,
     @"autoplay":@0,
     @"showinfo" : @1,
     @"rel" : @0,
     @"controls" : @1,
     @"origin" : @"https://www.example.com", // this is critical
     @"modestbranding" : @1
     };
     
     }
     else
     {
     playerVars = @{
     @"playsinline" : @1,
     @"autoplay":@1,
     @"showinfo" : @1,
     @"rel" : @0,
     @"controls" : @1,
     @"origin" : @"https://www.example.com", // this is critical
     @"modestbranding" : @1
     };
     }*/
    
    if( isCurVideo == false)
    {
        [self.playerView loadWithVideoId:strUrl playerVars:playerVars];
    }
    else
    {
        [self.playerView cueVideoById:strUrl startSeconds:[self getTimeOffset] suggestedQuality:kYTPlaybackQualityMedium];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            //if(!isCast)
            [self.playerView playVideo];
        });
        
    }
    
    //[self.playerView setHidden:isCast];
    loadedWebView = YES;
}


- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
    
    if ([self getTimeOffset]>0) {
        
        [self.playerView seekToSeconds:[self getTimeOffset] allowSeekAhead:FALSE];
    }
    
}

- (long) getTimeOffset
{
    
    if(arrayStreams == nil || [arrayStreams count] == 0){
        return 0;
    }
    
    
    long unixTime = 0;
    long curTime = 0;
    
    NSDictionary *dictFirstStream;
    dictFirstStream = arrayStreams[0];
    
    NSString* strUnixTime = dictFirstStream[@"unix_time"];
    unixTime = [strUnixTime intValue];
    curTime = [self timeStamp];
    
    long timeOffset = curTime - unixTime;
    
    if(timeOffset > 0)
        return timeOffset;
    else
        return 0;
}

- (long) getTimeOffsetFromID:(int)nID
{

    if(arrayStreams == nil || [arrayStreams count] == 0 || [arrayStreams count] <= nID){
         return 0;
    }
    
    
    long unixTime = 0;
    long curTime = 0;
    
    NSDictionary *dictFirstStream;
    
    dictFirstStream = arrayStreams[nID];

    
    NSString* strUnixTime = dictFirstStream[@"unix_time"];
    unixTime = [strUnixTime intValue];
    curTime = [self timeStamp];
    
    long timeOffset = curTime - unixTime;
    
    if(timeOffset > 0)
        return timeOffset;
    else
        return 0;
}

- (long) timeStamp{
    long timestamp =[[NSDate date] timeIntervalSince1970];
    return  timestamp;
}

#pragma mark - Setup AutoLayot VideoView
-(void)setVideoviewAuto
{
    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    // Width constraint
    [self.containerVideoView addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.containerVideoView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f
                                                                         constant:0]];
    
    // Height constraint
    [self.containerVideoView addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.containerVideoView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0f
                                                                         constant:0]];
    
    // Center horizontally
    [self.containerVideoView addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.containerVideoView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:0.0]];
    
    // Center vertically
    [self.containerVideoView addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.containerVideoView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];
}
#pragma mark - Video view Delegate
- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
    
    [self.playerView playVideo];
    
}

- (void) playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    
    switch (state) {
            
        case kYTPlayerStatePlaying:
            
            break;
            
        case kYTPlayerStateEnded:
            
            [arrayStreams removeObjectAtIndex:0];
            [self.tableStreams reloadData];
            
            [self startPlay];
            
            break;
            
        default:
            break;
            
    }
    
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    UIAlertView* alertView =[[UIAlertView alloc] init];
    [alertView setTitle:@"Video Error"];
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}


- (void) setInformation:(int) nID
{
    if([arrayStreams count]==0){
        //   [self showError:@"Error when showing information of video, Stream is zero"];
        return;
    }
    
    NSDictionary* dictItem;
    
    dictItem = arrayStreams[nID];
    
    
    
    NSString * strTitle,*strTime,*strUrl,*strId;
    strTitle= dictItem[@"title"];
    strTime = dictItem[@"time"];
    strUrl = dictItem[@"url"];
    strId = dictItem[@"id"];
    StreamId = strId;
    StreamTitle= strTitle;
     NSLog(@"StreamTitle%@",StreamTitle);
    [self.textStreamTitle setFont:[COMMON getResizeableFont:OpenSans_Bold(10)]];
    
    
    if([strTitle isEqualToString:@""] || strTitle==nil)
    {
        UIAlertView* alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Please check stream"];
        [alertView addButtonWithTitle:@"Ok"];
        [alertView show];
        
        [self.textStreamTitle setText:@"Error"];
        [self.textStreamTime setText:@"Error"];
        
        
    }else if([strTime isEqualToString:@""] || strTitle == nil)
    {
        UIAlertView* alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Please check stream"];
        [alertView addButtonWithTitle:@"Ok"];
        [alertView show];
        [self.textStreamTitle setText:@"Error"];
        [self.textStreamTime setText:@"Error"];
        
    }
    
    [self.textStreamTitle setText:strTitle];
    // [self.textStreamTime setText:strTime];
    
    //NOW PLAYING VIEW
    
    NSString *startLabel =@"Start Time: ";
    UIFont *startFont = [COMMON getResizeableFont:Arial(10)];//[UIFont fontWithName:@"Arial" size:10];
    UIColor *startColor = [UIColor colorWithRed:109.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
    NSDictionary *startAttributes = @{NSFontAttributeName:startFont, NSForegroundColorAttributeName:startColor};
    NSMutableAttributedString *stAttrString = [[NSMutableAttributedString alloc] initWithString:startLabel attributes: startAttributes];
    
    UIFont *timeFont = [COMMON getResizeableFont:OpenSans_Bold(10)];//[UIFont fontWithName:@"OpenSans-Bold" size:8];
    UIColor *timeColor = [UIColor colorWithRed:46.0f/255.0f green:46.0f/255.0f blue:46.0f/255.0f alpha:1.0];
    NSDictionary *timeAttributes = @{NSFontAttributeName:timeFont, NSForegroundColorAttributeName:timeColor};
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc]initWithString:strTime attributes:timeAttributes];
    [stAttrString appendAttributedString:timeAttrString];
    
    self.textStreamTime.attributedText = stAttrString;
    
    [self.nowPlayLabel setText:@"NOW PLAYING!"];
    self.nowPlayLabel.layer.borderColor = [UIColor colorWithRed:108.0f/255.0f green:108.0f/255.0f blue:108.0f/255.0f alpha:1.0].CGColor;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.nowPlayLabel setFont:[COMMON getResizeableFont:Arial_Bold(8)]];
        self.nowPlayLabel.layer.borderWidth = 1.5;
    }
    else{
        if ([COMMON getCurrentDevice]==iPhone6Plus ){
           [self.nowPlayLabel setFont:[COMMON getResizeableFont:Arial_Bold(8)]];
        }
        else{
            [self.nowPlayLabel setFont:[COMMON getResizeableFont:Arial_Bold(10)]];
        }
        self.nowPlayLabel.layer.borderWidth = 1.0;
    }
    
}

- (void) updateTitle:(NSString *)strTitle
{
    self.title = strTitle;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
}

- (void) setItemInformation:(int)nStreamId
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger nCount = 0;
    
    if(tableView.tag == 100)
    {
        nCount = 60;
        
    }
    else if(tableView.tag == 101){
        nCount = 40;
    }
    
    //        return 60;
    return nCount;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    // return arrayStreams.count;
    
    NSInteger nCount = 0;
    
    if(tableView.tag == 100)
    {
        nCount = arrayStreams.count;
        
    }
    else if(tableView.tag == 101){
        nCount = m_ArrayChannels.count;
    }
    
    return nCount;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag == 100){
        
        
        static NSString *simpleTableIdentifier = @"StreamTableViewCell";
        StreamTableViewCell *cell = (StreamTableViewCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        
        NSDictionary *dictItem = arrayStreams[indexPath.row];
        NSString *strStreamName = dictItem[@"title"];
        NSString *strTime = dictItem[@"time"];
        NSString *strUrl = dictItem[@"url"];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_URL, strUrl];
        NSURL *imageURL = [NSURL URLWithString:strImageUrl];
        
        
        
        [cell.imageThumbnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
        //cell.labelStreamName.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0];
         cell.labelStreamName.textColor = [UIColor whiteColor];
        [cell.labelStreamName setText:strStreamName];
        [cell.labelStreamName setFont:[COMMON getResizeableFont:Arial(12)]];//[UIFont fontWithName:@"Arial-Regular" size:2]];
        //Table Start
        NSString* startLabel = @"Start Time: ";
        UIFont *startFont = [COMMON getResizeableFont:Roboto_Light(12)];
        //UIColor *startColor = [UIColor colorWithRed:109.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        UIColor *startColor = [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];
        NSDictionary *startAttributes = @{NSFontAttributeName:startFont, NSForegroundColorAttributeName:startColor};
        NSMutableAttributedString *stAttrString = [[NSMutableAttributedString alloc] initWithString:startLabel attributes: startAttributes];
        
        UIFont *timeFont = [COMMON getResizeableFont:Roboto_Light(11)];
        UIColor *timeColor = [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];
        NSDictionary *timeAttributes = @{NSFontAttributeName:timeFont, NSForegroundColorAttributeName:timeColor};
        NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc]initWithString:strTime attributes:timeAttributes];
        
        [stAttrString appendAttributedString:timeAttrString];
        
        cell.startLabel.attributedText = stAttrString;
        
        if(isHiddenBannerView==NO){
            [self.tableStreams setContentInset:UIEdgeInsetsMake(0,0,50,0)];
        }
        else{
            [self.tableStreams setContentInset:UIEdgeInsetsMake(0,0,3,0)];
        }
        
       [cell.contentView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
        [cell setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
        //[self.tableStreams setSeparatorColor:[UIColor colorWithRed:33.0/255.0f green:33.0/255.0f blue:33.0/255.0f alpha:1]];
         [self.tableStreams setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
        //[self.tableStreams setSeparatorColor:[UIColor colorWithRed:0.0/255.0f green:74.0/255.0f blue:125.0/255.0f alpha:1]];
        [self.tableStreams setSeparatorColor:[UIColor colorWithRed:9.0f/255.0f green:63.0f/255.0f blue:104.0f/255.0f alpha:1]];
        
        
        
        return cell;
    }
    else if(tableView.tag == 101){
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
        NSString *strChannelName = dictItem[@"name"];
        //NSString *strUrl = dictItem[@"logo_url"];
        
        [cell.labelText setText:strChannelName];
        
        //        asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(cell.menuImage.frame.origin.x, cell.menuImage.frame.origin.y, cell.menuImage.frame.size.width, cell.menuImage.frame.size.height)];
        //
        //        [asyncImage setLoadingImage];
        //        [asyncImage loadImageFromURL:[NSURL URLWithString:strUrl]
        //                                type:AsyncImageResizeTypeAspectRatio
        //                             isCache:YES];
        //        asyncImage.layer.cornerRadius = 15.0;
        //        asyncImage.layer.masksToBounds = YES;
        // [cell.menuImage addSubview:asyncImage];
        
        [cell.labelText setFont:[COMMON getResizeableFont:Roboto_Light(12)]];
        
        return cell;
        
    }
    else if(tableView.tag == 102){
        
    }
    
    return nil;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bTitleCagtegoryShown = false;
    bMenuCategoryShown = false;
    isFirstChannelView=YES;
    if(tableView.tag == 100)
    {
        NSDictionary *dictItem = arrayStreams[indexPath.row];
        NSString *strStreamName = dictItem[@"title"];
        NSString *strUrl = dictItem[@"url"];
        
        m_nCurVideoID =(int) indexPath.row;
        [self showVideoOnDemandDialog:strStreamName URL:strUrl];
    }
    else if(tableView.tag == 101){
        
        [mainChannelView close];
        mainChannelView = nil;
        
        NSDictionary *dictItem = m_ArrayChannels[indexPath.row];
        popUpIndex = indexPath.row;
        NSString* strID, * strTitle;
        strID= dictItem[@"id"];
        strTitle = dictItem[@"name"];
        popUpSelectionId = strID;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatestream" object:dictItem];
       
        isReloadTable = true;
        
        if(isLocal==YES){
            [self loadSelectionData];
        }
        else{
            if([videoCountArray count]==[channelTitleLabelArray count]){
                [self loadSelectionData];
            }
        }
        
    }
}
-(void)loadSelectionData{
    [self loadDataArray:m_ArrayChannels];
    m_ArrayChannels = latestNewsArray;
    NSMutableArray *loadChannelArray = [m_ArrayChannels mutableCopy];
    NSString *stringToFind = @"-";
    
    NSString *checkStr =[NSString stringWithFormat:@"%@",popUpSelectionId];
    
    if(![checkStr containsString:stringToFind]){
        NSMutableArray *selectedArray   = [loadChannelArray objectAtIndex:popUpIndex];
        isTitleAction = NO;
        [loadChannelArray removeObjectAtIndex:popUpIndex];
        [loadChannelArray insertObject:selectedArray atIndex:0];
        latestNewsArray = loadChannelArray;
        [self setChannelViewScroll];
    }

}
#pragma mark - showVideoDialogBox
- (void)showVideoOnDemandDialog:(NSString*)strTitle URL:(NSString*) strUrl
{
    curVideoUrl = strUrl;
    curTitle = strTitle;
    UIView* viewContainer;
    UILabel* labelTitle;
    UILabel* labelDescription;
    UIImageView* imageThumbnail;
    UILabel* labelVideoName;
    UIView* viewInnerContainer;
    

    UIDevice* device = [UIDevice currentDevice];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //LAND
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            ondemandView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            viewInnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-280, screenHeight-80)];
        }
        else{
            ondemandView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            viewInnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-420, screenHeight-280)];
        }
        
    }else{
        // POR
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            ondemandView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            viewInnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-50, screenHeight/2)];
        }
        else{
            ondemandView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            viewInnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-260, screenHeight/2)];
        }
    }
    
    CGFloat buttonHeight,labelTitleXPos,labelTitleHeight,labelDescriptionHeight,imageThumbnailHeight,labelVideoNameHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        labelTitleXPos =8;
        labelTitleHeight = 20;
        labelDescriptionHeight= 20;
        buttonHeight =30;
        imageThumbnailHeight=viewContainer.frame.size.height/3;
        labelVideoNameHeight =20;
       
    }
    else{
        labelTitleXPos=10;
        labelTitleHeight = 50;
        labelDescriptionHeight = 30;
        buttonHeight = 50;
        imageThumbnailHeight=viewContainer.frame.size.height/1.8;
        labelVideoNameHeight=40;
        
    }
    
    
    viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewInnerContainer.frame.size.width, viewInnerContainer.frame.size.height)];
    [viewInnerContainer setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, labelTitleXPos, viewContainer.frame.size.width-20, labelTitleHeight)];
    [labelTitle setText:@"VIDEO ON-DEMAND"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(17)]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    
     labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, labelTitle.frame.origin.y+labelTitle.frame.size.height, viewContainer.frame.size.width-20, labelDescriptionHeight)];
    [labelDescription setText:@"You have requested to watch"];
    [labelDescription setTextColor:[UIColor whiteColor]];
    [labelDescription setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [labelDescription setTextAlignment:NSTextAlignmentCenter];
    
    imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(40, labelDescription.frame.origin.y+labelDescription.frame.size.height, viewContainer.frame.size.width-80, viewContainer.frame.size.height/1.8)];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_URL, strUrl];
     //[imageThumbnail setBackgroundColor:[UIColor blueColor]];
    NSURL *imageURL = [NSURL URLWithString:strImageUrl];
    [imageThumbnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
    [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
     //[imageThumbnail setImageWithURL:imageURL ];
    
    labelVideoName = [[UILabel alloc] initWithFrame:CGRectMake(30, imageThumbnail.frame.origin.y+imageThumbnail.frame.size.height, viewContainer.frame.size.width-60, labelVideoNameHeight)];
    labelVideoName.numberOfLines = 0;
   // [labelVideoName setBackgroundColor:[UIColor redColor]];
    [labelVideoName setText:strTitle];
    [labelVideoName setTextColor:[UIColor whiteColor]];
    [labelVideoName setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [labelVideoName setTextAlignment:NSTextAlignmentCenter];
    
    
    
    UIButton* btnWatch = [[UIButton alloc] initWithFrame:CGRectMake(20, labelVideoName.frame.origin.y+labelVideoName.frame.size.height+5, (viewContainer.frame.size.width/2)-20, buttonHeight)];
    [btnWatch setTitle:@"WATCH NOW!" forState:UIControlStateNormal];
    [btnWatch setBackgroundImage:[UIImage imageNamed:@"orangeBtn.png"] forState:UIControlStateNormal];
    [btnWatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnWatch.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(15)];
   
    [btnWatch addTarget:self action:@selector(onDemand_watch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat btnCancelXPos = btnWatch.frame.origin.x+btnWatch.frame.size.width+5;
    UIButton* btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnCancelXPos, labelVideoName.frame.origin.y+labelVideoName.frame.size.height+5,btnWatch.frame.size.width-5, buttonHeight)];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(15)];
    
    [btnCancel addTarget:self action:@selector(onDemand_cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewContainer addSubview:labelTitle];
    [viewContainer addSubview:labelDescription];
    [viewContainer addSubview:imageThumbnail];
    [viewContainer addSubview:labelVideoName];
    [viewContainer addSubview:btnWatch];
    [viewContainer addSubview:btnCancel];
    [viewInnerContainer addSubview :viewContainer];

    ondemandView.delegate = self;
    [ondemandView setContainerView:viewInnerContainer];
    [ondemandView show];
    bDemandShown = true;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [ondemandView addGestureRecognizer:tapGestureRecognizer];
    ondemandView.userInteractionEnabled = YES;
}
#pragma mark - tapActions
- (void)tapOnPopUpView:(UITapGestureRecognizer *)tap {
    bDemandShown =false;
    bTitleCagtegoryShown = false;
    bMenuCategoryShown = false;

    [mainChannelView removeFromSuperview];
    [mainChannelView close];
    mainChannelView = nil;
    
    [ondemandView removeFromSuperview];
    [ondemandView close];
    ondemandView = nil;
    
}

-(IBAction) onDemand_watch:(id)sender
{
    if(![self castVideoFromId:m_nCurVideoID])
    {
        PlayerViewController* mPlayerVC  =[self.storyboard instantiateViewControllerWithIdentifier:@"playervc"];
        
        [mPlayerVC setURL:curVideoUrl];
        
        [self.navigationController pushViewController:mPlayerVC animated:YES];
    }
    
    [ondemandView close];
    bDemandShown =false;
}

-(IBAction) onDemand_cancel:(id)sender
{
    [ondemandView close];
    bDemandShown = false;
}
#pragma mark - mainChannelOrientationChanged
-(void) mainChannelOrientationChanged:(NSNotification *) note
{
    NSLog(@"Orientation  has changed: %ld", (long) note.object);
    UIDevice * devie = note.object;
   
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            //   case UIDeviceOrientationPortraitUpsideDown:
            [self mainRotateViews:true];
            [self mainRotateViewsLandscape:false];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self mainRotateViews:false];
            [self mainRotateViewsLandscape:true];
            break;
            
        default:
            break;
    }
}

-(void) mainRotateViewsLandscape:(BOOL)bLandscape{
    
    if(bLandscape){
        if(isLandscape==YES){
        }
       
        [searchBarView setHidden:YES];
    }
    else{
        
        
    }
   
    
}

-(void) mainRotateViews:(BOOL) bPortrait{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_searchButton setHidden:NO];
    [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
   
    //old
    //[self setTitleScrollBar];
    
    //new
    /*
     //[self setTitleScrollBar];
     */
    
    [self setUpSearchBarInNavigation];
  
    [self.view endEditing:YES];
  
     NSLog(@"SCREEN_HEIGHT=%f",SCREEN_HEIGHT);
    NSLog(@"SCREEN_WIDTH=%f",SCREEN_WIDTH);
    
    CGRect showViewButtonFrame = _showViewButton.frame;
    //CGFloat showViewButtonFrameMaxY = CGRectGetMaxY(showViewButtonFrame);
  
    CGFloat widthView = SCREEN_WIDTH;
    CGFloat heightView = SCREEN_HEIGHT/2;

     NSLog(@"widthView=%f",widthView);
     NSLog(@"heightView=%f",heightView);
    
    NSLog(@"origin X=>%f",newScrollGridView.frame.origin.x);
     NSLog(@"origin Y=>%f",newScrollGridView.frame.origin.y);
    NSLog(@"widthView=>%f",newScrollGridView.frame.size.width);
    NSLog(@"heightView=>%f",newScrollGridView.frame.size.height);

    
    if(bPortrait){
        //new change for landscape video
        
        //BOOL portrait = [[NSUserDefaults standardUserDefaults] boolForKey:@"portrait"];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"portrait"];
        [[NSUserDefaults standardUserDefaults] synchronize];

//        if (!portrait) {
//            //Your Launch Code
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"portrait"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.showHeaderView setHidden:NO];
        [self.showTopView setHidden:NO];
        [self.nowView setHidden:NO];
        [self.headerScroll setHidden:NO];
        [_showViewButton setHidden:NO];
        [_contentViewButton setHidden:NO];
        [self.playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        //
       
        port_heightView = SCREEN_HEIGHT;
        port_MainViewHeight=SCREEN_HEIGHT;
        
        if(port_MainViewHeight!=land_MainViewHeight){
            [self onChannelViewTopMenuList:YES];
        }
        
        nMainColumn = 8;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        nMainWidth = screenWidth / nMainColumn;
        nMainHeight = screenWidth / nMainColumn;
        [searchBarView setHidden:YES];
        [_searchButton setHidden:NO];
       
        //[showHeaderView setHidden:NO];
        if(bFullScreen == FALSE){
            //whichHeight = (170/504.0)*self.view.frame.size.height;
            whichHeight = (170/504.0)*screenHeight;
            NSLog(@"height=%f",whichHeight);
            CGSize size = self.view.frame.size;
            if(m_bFirstTimeHeight == true){
                portraitHeightFirst = whichHeight;
                m_bFirstTimeHeight = false;
            }
                [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
                self.playerContainer.frame = CGRectMake(0, 45, size.width, whichHeight);
                self.nowView.frame = CGRectMake(0, whichHeight+45, size.width, 50);
                
            
            [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
            isLandscape=YES;
            
            
        }else{
            CGSize size = self.view.frame.size;
         
            [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
            
            //fullscreen
            if(isnowViewAboveAds==true){
                self.playerContainer.frame = CGRectMake(0, 45, size.width, size.height-145);
                self.nowView.frame = CGRectMake(0, size.height +90, size.width, 50);
                isnowViewAboveAds=false;
                
            }
            else{
                self.playerContainer.frame = CGRectMake(0, 45, size.width, size.height-145);
                self.nowView.frame = CGRectMake(0, size.height +90, size.width, 50);
            }
            [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        }
       
        
    }else{
        
        //Old
        /*
    
        land_heightView = SCREEN_HEIGHT;
        land_MainViewHeight=SCREEN_HEIGHT;

        if(port_MainViewHeight!=land_MainViewHeight){
            [self onChannelViewTopMenuList:NO];
        }

       
        nMainColumn = 8;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nMainWidth = screenWidth / nMainColumn;
        nMainHeight = screenWidth / nMainColumn;
        
        [searchBarView setHidden:YES];
        [_searchButton setHidden:NO];
        
        CGSize size = self.view.frame.size;
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.playerContainer.frame = CGRectMake(0 , 30, size.width, size.height+20 - self.navigationController.navigationBar.frame.size.height);
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        isnowViewAboveAds=true;
        
        
        
        //// hide above for new code 
         */
        
        
        //new change for landscape video
       // /*
        
        
        nMainColumn = 8;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nMainWidth = screenWidth / nMainColumn;
        nMainHeight = screenWidth / nMainColumn;
        
        [searchBarView setHidden:YES];
        [_searchButton setHidden:NO];
        //When opening in landscape
        [self.navigationController.navigationBar setHidden:true];
        
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.playerView setTranslatesAutoresizingMaskIntoConstraints:YES];
         isnowViewAboveAds=true;
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.playerContainer.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT+10);
            self.playerView.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT+10);
            
        } completion:^(BOOL finished) {
        }];
       
        [self.playerContainer setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.playerView setTranslatesAutoresizingMaskIntoConstraints:YES];
       
        //new
        [showHeaderView setHidden:YES];
        [_headerScroll setHidden:YES];
        [_nowView setHidden:YES];
        [_showViewButton setHidden:YES];
        [_contentViewButton setHidden:YES];
        [_bannerView setHidden:YES];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        [mainChannelView removeFromSuperview];
        [mainChannelView close];
        mainChannelView = nil;
        
        [ondemandView removeFromSuperview];
        [ondemandView close];
        
        //new change for landscape video
        BOOL portrait = [[NSUserDefaults standardUserDefaults] boolForKey:@"portrait"];
        
        
        if(portrait==YES){
            
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(loadVideoWhenAppInLandscapeModeForFirstTime) withObject:nil afterDelay:0.50];
                    
                });
            });
            
            land_heightView = SCREEN_HEIGHT;
            land_MainViewHeight=SCREEN_HEIGHT;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"portrait"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
       // */
        
    }
   
}

#pragma mark - loadVideoWhenAppInLandscapeModeForFirstTime
-(void)loadVideoWhenAppInLandscapeModeForFirstTime{
    
    if(CommonChannelId==nil){
        CommonChannelId =@"145";
        previousCommonChannelId=@"145";
    }
    NSString *strChannelVideoFileName     = [NSString stringWithFormat:YOULIVE_CHANNELS,CommonChannelId];
    
    latestNewsArray = [[COMMON retrieveContentsFromFile:strChannelVideoFileName dataType:DataTypeArray] mutableCopy];
    [self loadDataArray:latestNewsArray];
    
    
    
    NSLog(@"check here for latestNewsArray");
    if([latestNewsArray count]!=0){
        
        NSDictionary *temp= [latestNewsArray objectAtIndex:0];
        [self updateShowViewTable:temp];
    }
    
}




- (void) hidecontrol {
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:theMoviPlayer];
    [theMoviPlayer setControlStyle:MPMovieControlStyleFullscreen];
    
}

-(void)onChannelViewTopMenuList:(BOOL)portraitBool{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        _onCastTopConstraint.constant = SCREEN_HEIGHT/2.5;
        if(isHiddenBannerView==YES)
            [_bannerView setHidden:YES];
        else
            [_bannerView setHidden:NO];
    }
    else{
        if(IS_IPHONE4||IS_IPHONE5){
          _onCastTopConstraint.constant = 170;
        }
        else{
            _onCastTopConstraint.constant = 180;
        }
        
        UIDevice* device = [UIDevice currentDevice];
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            [_bannerView setHidden:YES];
        }
        else{
            if(isHiddenBannerView==YES)
                [_bannerView setHidden:YES];
            else
                [_bannerView setHidden:NO];
        }
    }
    
    if(bTitleCagtegoryShown){
        [mainChannelView removeFromSuperview];
        [mainChannelView close];
        mainChannelView = nil;
        [self showCategoryList:arrCategoriesTempArray];
        
    }
    
    if(bMenuCategoryShown){
        [mainChannelView removeFromSuperview];
        [mainChannelView close];
        mainChannelView = nil;
        [self showChanelList:onWatchChannelArray];
    }
    
    if(bDemandShown){
        [ondemandView removeFromSuperview];
        [ondemandView close];
        [self showVideoOnDemandDialog:curTitle URL:curVideoUrl];
    }
   // if ([latestNewsArray count] == 0) { //if(port_heightView != land_heightView){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if(isFirstTimeChannelView==YES){
                    for(UIView *view in newScrollGridView.subviews){
                        [view removeFromSuperview];
                    }
                    [self LoadIndicator:newScrollGridView];
                    [newScrollGridView setHidden:NO];
                    [self performSelector:@selector(loadLatestChannelData) withObject:nil afterDelay:0.80];
                    isFirstTimeChannelView=NO;
                    NSLog(@"if");
                }
                else{
                    NSLog(@"else");
                    for(UIView *view in newScrollGridView.subviews){
                        [view removeFromSuperview];
                    }
                    [self LoadIndicator:newScrollGridView];
                    [newScrollGridView setHidden:NO];
                    [self performSelector:@selector(loadLatestChannelData) withObject:nil afterDelay:0.50];
                    NSLog(@"condition");
                   
                }
                
            });
        });
   // }
    
    if(portraitBool==YES){
        land_MainViewHeight  = port_MainViewHeight;
    }
    else{
        port_MainViewHeight  = land_MainViewHeight;
    }


}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}

-(void)LoadIndicator:(UIView *)view
{
    [self removeIndicator];

   loadingView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width-50)/2, (view.frame.size.height-50)/2, 80, 80)];
    [loadingView.layer setCornerRadius:5.0];
    [loadingView setBackgroundColor:[UIColor clearColor]];
    [loadingView.layer setMasksToBounds:YES];
    [self.view setUserInteractionEnabled:YES]; 
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake(1, 1, 60, 60)];
    [indicator setHidesWhenStopped:YES];
    [indicator startAnimating];
    [loadingView addSubview:indicator];
    [view addSubview:loadingView];
}

-(void)removeIndicator {
    [indicator stopAnimating];
    [loadingView removeFromSuperview];
}
- (void)SingleTap:(UITapGestureRecognizer *)recognizer {

    [showTopView removeFromSuperview];
    [UIView animateWithDuration:3.0
                     animations:^{
                         showHeaderView.transform = CGAffineTransformIdentity;
                         showHeaderView.transform = CGAffineTransformMakeTranslation(0,0);
                     }
                     completion:^(BOOL finished) {
                         //[showHeaderView setHidden:YES];
                     }];
}
#pragma mark - Volume
-(float)getVolume
{
    /*MPVolumeView *volumeView = [[MPVolumeView alloc] init];
     for (UIView *view in [volumeView subviews]){
     if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
     UISlider* volumeViewSlider = (UISlider*)view;
     return volumeViewSlider.value;
     //break;
     }
     }*/
    //return 0;
    return [MPMusicPlayerController applicationMusicPlayer].volume;
}

-(void)setVolume:(float)fVolume
{
    /*MPVolumeView *volumeView = [[MPVolumeView alloc] init];
     for (UIView *view in [volumeView subviews]){
     if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
     UISlider* volumeViewSlider = (UISlider*)view;
     volumeViewSlider.value = fVolume;
     [volumeViewSlider performSelector:@selector(_commitVolumeChange)];
     break;
     }
     }*/
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:fVolume];
}

#pragma mark - Chrome Cast
- (IBAction)onCast:(id)sender {
    
    
    if (!_deviceManager
        || _deviceManager.connectionState != GCKConnectionStateConnected) {
        
        [self chooseDevice];
        
    }
    else {
        
        _volumeLabel.text = strCurrentCastingVideoTitle;
        
        NSLog(@"Device Volume  = %f",_deviceManager.deviceVolume);
        self.volumeSlider.value = _deviceManager.deviceVolume * 100;
        
        [onCastView setHidden:NO];
        
    }
    
}
-(void) initCast
{
    // You can add your own app id here that you get by registering with the Google Cast SDK
    // Developer Console https://cast.google.com/publish
    kReceiverAppID=kGCKMediaDefaultReceiverApplicationID;
    
    // Create images for Google Cast button.
    self.btnImage = [UIImage imageNamed:@"cast_Off"];
    self.btnImageSelected = [UIImage imageNamed:@"cast_On_Three"];
    
    // Initially hide Cast button.
    //	self.navigationItem.rightBarButtonItems = @[];
    
    _googleCastButton.hidden = YES;  //myself changed to No for test
    
    // Establish filter criteria.
    GCKFilterCriteria *filterCriteria = [GCKFilterCriteria
                                         criteriaForAvailableApplicationWithID:kReceiverAppID];
    // Initialize device scanner.
    self.deviceScanner = [[GCKDeviceScanner alloc] initWithFilterCriteria:filterCriteria];
    
    [_deviceScanner addListener:self];
    [_deviceScanner startScan];
}

//Choose Device Action (Originally button's action)
- (void)chooseDevice{
    if (_selectedDevice == nil) {
        // [START showing-devices]
        // Choose device.
        UIActionSheet *sheet =
        [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Connect to device", nil)
                                    delegate:self
                           cancelButtonTitle:nil
                      destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        for (GCKDevice *device in _deviceScanner.devices) {
            [sheet addButtonWithTitle:device.friendlyName];
        }
        
        // [START_EXCLUDE]
        // Further customizations
        [sheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        // [END_EXCLUDE]
        
        // Show device selection.
        [sheet showInView:self.view];
    } else {
        // Gather stats from device.
        [self updateStatsFromDevice];
        
        NSString *mediaTitle = [_mediaInformation.metadata stringForKey:kGCKMetadataKeyTitle];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        sheet.title = _selectedDevice.friendlyName;
        sheet.delegate = self;
        if (mediaTitle != nil) {
            [sheet addButtonWithTitle:mediaTitle];
        }
        
        // Offer disconnect option.
        [sheet addButtonWithTitle:@"Disconnect"];
        [sheet addButtonWithTitle:@"Cancel"];
        sheet.destructiveButtonIndex = (mediaTitle != nil ? 1 : 0);
        sheet.cancelButtonIndex = (mediaTitle != nil ? 2 : 1);
        
        [sheet showInView:self.view];
    }
}

- (void)updateStatsFromDevice {
    
    if (_mediaControlChannel &&
        _deviceManager.connectionState == GCKConnectionStateConnected) {
        _mediaInformation = _mediaControlChannel.mediaStatus.mediaInformation;
    }
}

- (void)connectToDevice {
    if (_selectedDevice == nil) {
        return;
    }
    
    self.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:_selectedDevice
                           clientPackageName:[NSBundle mainBundle].bundleIdentifier];
    self.deviceManager.delegate = self;
    [_deviceManager connect];
}

- (void)deviceDisconnected {
    [self.playerView setHidden:NO];
    if (m_fVolume == 0) {
        m_fVolume = [self getVolume];
    }
    [self setVolume:m_fVolume];
    [self disconnectXCDMoviePlayer];
    [_googleCastButton setImage:[UIImage imageNamed:@"cast_Off"] forState:UIControlStateNormal];
    self.mediaControlChannel = nil;
    self.deviceManager = nil;
    self.selectedDevice = nil;
}

- (void) disconnectXCDMoviePlayer {
    if (self.videoPlayerViewController!=nil) {
        [self.videoPlayerViewController.moviePlayer stop];
        self.videoPlayerViewController = nil;
    }
}
- (void)updateButtonStates {
    if (_deviceScanner && _deviceScanner.devices.count > 0) {
        // Show the Cast button.
        //self.navigationItem.rightBarButtonItems = @[_googleCastButton];
        _googleCastButton.hidden = NO;
        
        if (_deviceManager && _deviceManager.connectionState == GCKConnectionStateConnected) {
            // Show the Cast button in the enabled state.
            [_googleCastButton setTintColor:[UIColor blueColor]];
            
            [_googleCastButton setImage:[UIImage imageNamed:@"cast_On_Three"] forState:UIControlStateNormal];
        } else {
            // Show the Cast button in the disabled state.
            [_googleCastButton setTintColor:[UIColor grayColor]];
            [_googleCastButton setImage:[UIImage imageNamed:@"cast_Off"] forState:UIControlStateNormal];
            
        }
    } else {
        //Don't show cast button.
        //self.navigationItem.rightBarButtonItems = @[];
        _googleCastButton.hidden = YES;
    }
}

//returns YES if cast is available, NO if can't cast
-(BOOL) castVideoFromId:(int)nID
{
    
    if (!_deviceManager
        || _deviceManager.connectionState != GCKConnectionStateConnected) {
        [self.playerView setHidden:NO];
        if (m_fVolume == 0) {
            m_fVolume = [self getVolume];
        }
        if (isInCasting) {
            [self setVolume:m_fVolume];
        }
        isInCasting = NO;
        return NO;
    }
    
    if([arrayStreams count]==0 || [arrayStreams count] <= nID || nID < 0 ){
        //  [self showError:@"Error when starting stream, stream is zero"];
        return NO;
    }
    
    NSDictionary* dictItem;
    
    dictItem = arrayStreams[nID];
    

    NSString* strUrl = dictItem[@"url"];
    
    NSString *strTitle = dictItem[@"title"];
    
    strCurrentCastingVideoTitle = strTitle;
    
    //    strUrl = @"YQHsXMglC9A";
    
    
    NSString *sThumbURL = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_URL, strUrl];
    
    strCurrentCastingThumbImage = sThumbURL;
    
    currentNID = nID;
    
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", strUrl]]];
    NSString *sUrlVideo;
    if(videos.count > 0)
    {
        sUrlVideo = [videos objectForKey:@"hd720"];
        if(!sUrlVideo)
            sUrlVideo = [videos objectForKey:@"hd"];
        if(!sUrlVideo)
            sUrlVideo = [videos objectForKey:@"medium"];
    }
    
    
    if(videos.count <= 0 || sUrlVideo == nil)
    {
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self selector:@selector(moviePlayerNowPlayingMovieDidChange:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
        
        [self disconnectXCDMoviePlayer];
        
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:strUrl];
        [self.videoPlayerViewController presentInView:videoContainerView];
        
        [self.videoPlayerViewController.moviePlayer prepareToPlay];
        
        //[self.playerView playVideo];
        /*[self setVolume:m_fVolume];
         [self.playerView setHidden:NO];
         [self deviceDisconnected];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, You can't cast this video." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         isInCasting = NO;
         
         return NO;*/
        
        /*[self castYoutuveVideoWithURL:strTitle
         subTitle:nil
         urlThumb:sThumbURL
         urlVideo:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", strUrl]
         timeOffset:(int)[self getTimeOffsetFromID:nID]];*/
        
        
    }
    [self castVideoWithTitle:strTitle subTitle:nil urlThumb:sThumbURL urlVideo:sUrlVideo timeOffset:(int)[self getTimeOffsetFromID:nID]];
    
    return YES;
}- (void) moviePlayerNowPlayingMovieDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = notification.object;
    NSLog(@"Now Playing %@", moviePlayerController.contentURL);
    
    [self castVideoWithTitle:strCurrentCastingVideoTitle subTitle:nil urlThumb:strCurrentCastingThumbImage urlVideo:[moviePlayerController.contentURL absoluteString] timeOffset:(int)[self getTimeOffsetFromID:currentNID]];
    
    [self disconnectXCDMoviePlayer];
    
    isInCasting = YES;
    
}

//Cast Video Action (Originally button's action)
- (void) castYoutuveVideoWithURL:(NSString *)sTitle subTitle:(NSString *)sSubTitle urlThumb:(NSString *)sThumbURL urlVideo:(NSString *)sVideoURL timeOffset:(int)nTimeOffset{
    NSLog(@"Cast Video");
    
    // Show alert if not connected.
    if (!_deviceManager
        || _deviceManager.connectionState != GCKConnectionStateConnected) {
        /*UIAlertController *alert =
         [UIAlertController alertControllerWithTitle:@"Not Connected"
         message:@"Please connect to Cast device"
         preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
         style:UIAlertActionStyleDefault
         handler:nil];
         [alert addAction:action];
         [self presentViewController:alert animated:YES completion:nil];*/
        return;
        
    }
    
    // Define media metadata.
    // [START media-metadata]
    GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
    
    if(sTitle)
        [metadata setString:sTitle forKey:kGCKMetadataKeyTitle];
    
    if(sSubTitle)
        [metadata setString:sSubTitle forKey:kGCKMetadataKeySubtitle];
    
    if(sThumbURL)
    {
        [metadata addImage:[[GCKImage alloc] initWithURL: [[NSURL alloc] initWithString:sThumbURL] width:480 height:360]];
    }
    // [END media-metadata]
    
    // Define Media information.
    // [START load-media]
    if(sVideoURL)
    {
        
        GCKMediaInformation *mediaInformation = [[GCKMediaInformation alloc] initWithContentID:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", sVideoURL]
                                                                                    streamType:GCKMediaStreamTypeUnknown
                                                                                   contentType:@"text/html"
                                                                                      metadata:metadata
                                                                                streamDuration:0
                                                                                    customData:nil];
        //        GCKMediaInformation *mediaInformation = [[GCKMediaInformation alloc] initWithContentID:sVideoURL
        //                                                                                    streamType:GCKMediaStreamTypeNone
        //                                                                                   contentType:@"video/mp4"
        //                                                                                      metadata:metadata
        //                                                                                streamDuration:0
        //                                                                                    customData:nil];
        // Cast the video.
        [_mediaControlChannel loadMedia:mediaInformation autoplay:YES playPosition:nTimeOffset];
    }
    
    // [END load-media]
    
    float fVolume = [self getVolume];
    if(fVolume > 0.0f)
        m_fVolume = fVolume;
    [self setVolume:0.0f];
    [self.playerView setHidden:YES];
    
    isInCasting = YES;
    
}


//Cast Video Action (Originally button's action)
- (void) castVideoWithTitle:(NSString *)sTitle subTitle:(NSString *)sSubTitle urlThumb:(NSString *)sThumbURL urlVideo:(NSString *)sVideoURL timeOffset:(int)nTimeOffset{
    NSLog(@"Cast Video");
    
    // Show alert if not connected.
    if (!_deviceManager
        || _deviceManager.connectionState != GCKConnectionStateConnected) {
        /*UIAlertController *alert =
         [UIAlertController alertControllerWithTitle:@"Not Connected"
         message:@"Please connect to Cast device"
         preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
         style:UIAlertActionStyleDefault
         handler:nil];
         [alert addAction:action];
         [self presentViewController:alert animated:YES completion:nil];*/
        return;
        
    }
    
    // Define media metadata.
    // [START media-metadata]
    GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
    
    if(sTitle)
        [metadata setString:sTitle forKey:kGCKMetadataKeyTitle];
    
    if(sSubTitle)
        [metadata setString:sSubTitle forKey:kGCKMetadataKeySubtitle];
    
    if(sThumbURL)
    {
        [metadata addImage:[[GCKImage alloc] initWithURL: [[NSURL alloc] initWithString:sThumbURL] width:480 height:360]];
    }
    // [END media-metadata]
    
    // Define Media information.
    // [START load-media]
    if(sVideoURL)
    {
        GCKMediaInformation *mediaInformation = [[GCKMediaInformation alloc] initWithContentID:sVideoURL
                                                                                    streamType:GCKMediaStreamTypeNone
                                                                                   contentType:@"video/mp4"
                                                                                      metadata:metadata
                                                                                streamDuration:0
                                                                                    customData:nil];
        // Cast the video.
        [_mediaControlChannel loadMedia:mediaInformation autoplay:YES playPosition:nTimeOffset];
    }
    
    // [END load-media]
    
    float fVolume = [self getVolume];
    if(fVolume > 0.0f)
        m_fVolume = fVolume;
    [self setVolume:0.0f];
    [self.playerView setHidden:YES];
    
    isInCasting = YES;
    
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"device found!! %@", device.friendlyName);
    [self updateButtonStates];
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    [self updateButtonStates];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_selectedDevice == nil) {
        if (buttonIndex < _deviceScanner.devices.count) {
            self.selectedDevice = _deviceScanner.devices[buttonIndex];
            NSLog(@"Selecting device:%@", _selectedDevice.friendlyName);
            [self connectToDevice];
        }
    } else {
        if (buttonIndex == 1) {  //Disconnect button
            NSLog(@"Disconnecting device:%@", self.selectedDevice.friendlyName);
            // New way of doing things: We're not going to stop the applicaton. We're just going
            // to leave it.
            [_deviceManager leaveApplication];
            [_deviceManager disconnect];
            
            [self deviceDisconnected];
            [self updateButtonStates];
        } else if (buttonIndex == 0) {
            // Join the existing session.
            
        }
    }
}

#pragma mark - GCKDeviceManagerDelegate

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    NSLog(@"connected to %@!", _selectedDevice.friendlyName);
    
    [self updateButtonStates];
    [_deviceManager launchApplication:kReceiverAppID];
}

// [START media-control-channel]
- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication {
    
    NSLog(@"application has launched");
    self.mediaControlChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaControlChannel.delegate = self;
    [_deviceManager addChannel:self.mediaControlChannel];
    // [START_EXCLUDE silent]
    [_mediaControlChannel requestStatus];
    //[END_EXCLUDE silent]
    
    /*[self castVideoWithTitle:@"Big Buck Bunny (2008)" subTitle:@"Big Buck Bunny tells the story of a giant rabbit with a heart bigger than "
     "himself. When one sunny day three rodents rudely harass him, something "
     "snaps... and the rabbit ain't no bunny anymore! In the typical cartoon "
     "tradition he prepares the nasty rodents a comical revenge." urlThumb:@"https://commondatastorage.googleapis.com/"
     "gtv-videos-bucket/sample/images/BigBuckBunny.jpg" urlVideo:@"https://commondatastorage.googleapis.com/gtv-v   ideos-bucket/sample/BigBuckBunny.mp4"];*/
    
    [self castVideoFromId:0];
}
// [END media-control-channel]

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(GCKError *)error {
    NSLog(@"Received notification that device disconnected");
    if (error != nil) {
        [self showError:error];
    }
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    self.applicationMetadata = applicationMetadata;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}

#pragma mark - misc
- (void)showError:(NSError *)error {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Error"
                                        message:error.description
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide) {               // Menu will get revealed
        self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
//        self.interactivePopGestureRecognizer.enabled = NO;        // Prevents the iOS7's pan gesture
        self.view.userInteractionEnabled = NO;       // Disable the topViewController's interaction
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        self.tapGestureRecognizer.enabled = NO;
//        self.interactivePopGestureRecognizer.enabled = YES;
        self.view.userInteractionEnabled = YES;
    }
}
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}
//TESTING

- (void) syncLatestNews{
    
    int nChannelID = 145;
    [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *channelId = @"145";
        NSString *strCategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS,channelId];
        saveContentsToFile(responseObject,strCategoryFile);
        
        [self syncLatestNewsSubCategories:responseObject];
        
    } catID:nChannelID];
    
}
- (void) syncLatestNewsSubCategories:(id)responseObject {
    NSMutableArray *categoryArray =[[NSMutableArray alloc] initWithArray:responseObject];
    for (int i = 0; i<[categoryArray count]; i++) {
        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:categoryArray[i]];
        int nChannelID = [dictItem[@"id"] intValue];
        [[RabbitTVManager sharedManager] getStreamsLimit:^(AFHTTPRequestOperation * request, id responseObject) {
            NSString *subCatchannelId =[NSString stringWithFormat:@"%d",nChannelID];
            NSString *strSubcategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS_SUB_CATEGORIES,subCatchannelId];
            saveContentsToFile(responseObject, strSubcategoryFile);
            
            if (i == [categoryArray count]-1) {
                
            }
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"responseerror%@",error);
            
        } chanID:nChannelID];
    }
}

@end
