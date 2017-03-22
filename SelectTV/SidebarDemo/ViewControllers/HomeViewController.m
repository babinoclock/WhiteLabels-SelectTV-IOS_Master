//
//  HomeViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 01/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "AppDelegate.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "MovieViewController.h"
#import "RabbitTVManager.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewController.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "PayMovieViewController.h"
#import "SearchViewController.h"
#import "NkContainerCellView.h"
#import "NKContainerCellTableViewCell.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "MobileLandingView.h"
#import "OverTheAirViewController.h"
#import "MainViewController.h"
#import "MovieViewController.h"
#import "SubScriptionsViewController.h"
#import "RadioViewController.h"
#import "PayMovieViewController.h"
#import "MyAccountViewController.h"
#import "MyInterestsViewController.h"
#import "GamesViewController.h"
#import "AppDownloadListCell.h"
#import "subscriptionCustomCollectionCell.h"


@interface HomeViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSMutableArray* arrayHome;
    NSArray *m_ArrayChannels;
    NSArray * objects;
    NSArray *images;
    NSMutableArray * arrayTitle;
    NSMutableArray * arrayName;
    NSMutableArray * arrayNetworkNames;
    NSMutableArray * arrayItems;
    NSMutableArray * arrayTvName;
    NSMutableArray * imageArray;
    NSString * channelName;
    NSUserDefaults *userDefaults;
    
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
    
    //New Home Table
    NSString *strCellSelectionId;
    NSString *strCellSelectionName;
    NSString *strCellSelectionType;
    NSString *strCellSelectionImage;
    
    //MOBILE LANDING PAGE
    MobileLandingView *landView;
    //MENU ORIENTATION
    CGFloat port_HomeViewHeight;
    CGFloat land_HomeViewHeight;
    
    NSMutableArray *homeIconArray;
    NSMutableArray * imageIconArray;

    //new change
    UIView *subScriptionView;
    UICollectionView *_collectionView;
    NSMutableArray *loginSubscriptionArray;
    NSMutableArray *currentSubscriptionArray;
    NSMutableArray *currentSubscriptionCodeArray;
    NSMutableArray *currentCableArray;
    BOOL isSelectedItem;
    
    UIView *subscriptionBottomView;
    
    BOOL isCableSelected;
    UISwitch *freeSwitch;

}

@end

@implementation HomeViewController
@synthesize isHomeScreen;

int nMobileLandCount = 2;
int nMobileLandCellWidth = 107;
int nMobileLandCellHeight = 200;

NSArray * appHomeMenuData;

//NETWORKS
NSMutableArray* arrayHomeNetworks;
NSMutableArray * arrayHomeMovies;
NSMutableArray * arrayHomeShows;
NSMutableArray * arrayHomeLives;

BOOL boolLandscape =false;
BOOL boolLandToPort =false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}



#pragma mark - viewDidLoad

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    self.view = [COMMON setBackGroundColor:self.view];
    self.view.backgroundColor = GRAY_BG_COLOR;
    
//    SWRevealViewController *revealviewcontroller = self.revealViewController;
//    
//    if(revealviewcontroller)
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector(revealToggle:)];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
    arrayHome= [[NSMutableArray alloc]init];
    //arrayHome =[[NSUserDefaults standardUserDefaults] valueForKey:HOMEDETAILS];
    arrayName= [[NSMutableArray alloc]init];
    arrayTitle= [[NSMutableArray alloc]init];
    arrayItems= [[NSMutableArray alloc]init];
    arrayTvName= [[NSMutableArray alloc]init];
    arraySeasons = [[NSMutableArray alloc]init];    
    
    isLoadedHome = false;
    

 
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(17)];
    
    //[self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
   
    // [self setNavigationImage];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    //self.navigationItem.title = @"";
  
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFromMobilePage:) name:@"notificationFromMobilePage" object:nil ];

    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];


    //self.view.backgroundColor =[UIColor blackColor];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    homeDevice = [UIDevice currentDevice];
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    [COMMON LoadIcon:self.view];
    [self loadArraysForOnDemand];
    //[self setMobileLandingScreen];
    
    _homeSplash_Logo.image =[UIImage imageNamed:splashLogoImageName];
}



#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    
    _homeSplash_Logo.image =[UIImage imageNamed:splashLogoImageName];
    
    isCableSelected =NO;
    
    [super viewWillAppear:animated];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
     self.view = [COMMON setBackGroundColor:self.view];
    self.view.backgroundColor = GRAY_BG_COLOR;
    
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    
    NSMutableDictionary * currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = [COMMON getLoginDetails];
    loginSubscriptionArray = [NSMutableArray new];
    if([currentUserLoginDetails count]!=0){
        loginSubscriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
    }
    //NSMutableArray *tempSubArray =
    
    
    currentSubscriptionArray = [NSMutableArray new];
    
    currentCableArray = [NSMutableArray new];
    
    for(id tempDict in loginSubscriptionArray){
        
        NSString *appCode = [tempDict valueForKey:@"code"];
        if ((NSString *)[NSNull null] == appCode||appCode == nil) {
            appCode =@"";
        }
        if([appCode isEqualToString:@"CABLE"]){
           // NSString * subscribed = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"subscribed"]];
            //if(subscribed
            isCableSelected = [[tempDict valueForKey:@"subscribed"]boolValue];
            NSString *isSelect =@"NO";
            if(isCableSelected==YES){
                isSelect=@"YES";
            }
            
            NSMutableDictionary * tempSubDict = [NSMutableDictionary new];
            tempSubDict = [tempDict mutableCopy];
            [tempSubDict setObject:isSelect forKey:@"isSelectedItem"];
            [currentCableArray addObject:[tempSubDict mutableCopy]];
        }
        else{
            BOOL subscribed_BOOL = [[tempDict valueForKey:@"subscribed"]boolValue];
            NSString *isSelect =@"NO";
            if(subscribed_BOOL==YES){
                isSelect=@"YES";
            }
            
            NSMutableDictionary * tempSubDict = [NSMutableDictionary new];
            tempSubDict = [tempDict mutableCopy];
            [tempSubDict setObject:isSelect forKey:@"isSelectedItem"];
            [currentSubscriptionArray addObject:[tempSubDict mutableCopy]];
        }
        
    }

    
    
}
#pragma mark - supportAction
- (void)termsAction:(UITapGestureRecognizer *)tap {
    NSString *url= @"http://freecast.s3.amazonaws.com/SelectTV/App/selecttv-tos.html";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}
#pragma mark - supportAction
- (void)supportAction:(UITapGestureRecognizer *)tap {
    NSString *url= @"http://support.freecast.com/";//http://support.selecttv.com/
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

-(void)setMobileLandingScreen{
    [landView removeFromSuperview];
    landView = [MobileLandingView loadView];
    [landView loadMobileLandingData];
    [self.view addSubview:landView];
}
-(void)loadArraysForOnDemand{
    appHomeMenuData = (NSArray *) [COMMON retrieveContentsFromFile:APP_MENU dataType:DataTypeArray];
    
    appHomeMenuData = (NSArray *) [COMMON retrieveContentsFromFile:APP_MENU dataType:DataTypeArray];
    if (appHomeMenuData == NULL) {
        [[RabbitTVManager sharedManager] getAppMenu:^(AFHTTPRequestOperation * request, id responseObject) {
            appHomeMenuData = (NSArray *) responseObject;
            [self parseMenuData];
            [COMMON removeLoading];
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }];
    } else {
        [self parseMenuData];
        [COMMON removeLoading];
    }
    
    arrayHomeNetworks = [COMMON retrieveContentsFromFile:ALL_NETWORK_LIST dataType:DataTypeArray];
    
    if (arrayHomeNetworks == NULL) {
        [[RabbitTVManager sharedManager] getAllNetworks:^(AFHTTPRequestOperation * request , id responseObject) {
            arrayHomeNetworks =  responseObject;
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }];
    }
    
    [[RabbitTVManager sharedManager] getGamesCarouselData:^(AFHTTPRequestOperation *request, id responseObject){
        saveContentsToFile(responseObject, GAMES_CAROUSEL);
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }nPPV:PAY_MODE_ALL ];

}
- (void) parseMenuData
{
    if (appHomeMenuData == nil)
        return;
    
    for(int i = 0; i < appHomeMenuData.count; i++){
        NSDictionary *dict = appHomeMenuData[i];
        
        if(i == 0){
            arrayHomeLives = dict[@"child"];
        }else if(i == 1){
            arrayHomeShows = dict[@"child"];
        }else if(i == 2){
            arrayHomeMovies = dict[@"child"];
        }
    }
}

-(void)setNavigationImage{
    
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH/2, 45)];
   // UIImage *image = [UIImage imageNamed:splashLogoImageName];//@"splash_logo"
    
    UIImage *image = [UIImage imageNamed:splashLogoImageName];//@"splash_logo"

    CGFloat myImageViewXpos;
    CGFloat myImageViewWidth;
    CGFloat myImageViewHeight;
    if ([self isDeviceIpad]==YES){
        myImageViewXpos = myView.frame.size.width/3;
        myImageViewWidth = (myView.frame.size.width)-(myImageViewXpos*2);
        myImageViewHeight=40;
    }
    else{
        myImageViewHeight=37;
        myImageViewXpos =15;//myView.frame.size.width/4;
        myImageViewWidth = (myView.frame.size.width)-30;//(myView.frame.size.width)-(myImageViewXpos*2)
    }
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    myImageView.frame = CGRectMake(myImageViewXpos,-1,myImageViewWidth,myImageViewHeight);
    [myImageView setBackgroundColor:[UIColor clearColor]];
    [myView setBackgroundColor:[UIColor clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;

}

#pragma mark - setUpSearchBarInNavigation
-(void) setUpSearchBarInNavigation{
    searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(5, -5, self.view.frame.size.width-10, 48)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBarView setShowsCancelButton:YES];
    searchBarView.delegate = self;
    [searchBarView setTintColor:[UIColor whiteColor]];
    //searchBarView.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
   // searchBarView.backgroundColor = GRAY_BG_COLOR;
    searchBarView.autocorrectionType = UITextAutocorrectionTypeNo;
    for (id subView in ((UIView *)[searchBarView.subviews objectAtIndex:0]).subviews) {
        //UITextField *searchTextField;
        if ([subView isKindOfClass:[UITextField class]]) {
            searchTextField = subView;
            searchTextField.keyboardAppearance = UIKeyboardAppearanceLight;
            [searchTextField setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:116.0f/255.0f blue:203.0f/255.0f alpha:1]];
            searchTextField.textColor =[UIColor whiteColor];
            searchTextField.backgroundColor = [COMMON Common_Screen_BG_Color];
            UIColor *color = [UIColor whiteColor];
            //searchTextField.textColor =[UIColor whiteColor];
           // UIColor *color = [UIColor colorWithRed:119.0f/255.0f green:176.0f/255.0f blue:216.0f/255.0f alpha:1];
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


#pragma mark - Gesture Delegate Methods

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//no
}

- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//no
}

#pragma mark - orientationChanged
-(void) homeOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            //   case UIDeviceOrientationPortraitUpsideDown:
                 [self rotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
                 [self rotateViews:false];
            break;
            
        default:
            break;
    }
}


-(void)viewDidLayoutSubviews
{
    //[self.collection setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - getTableData

-(void)getTableData
{
        arrayHome = [[COMMON retrieveContentsFromFile:CAROUSEL_HOME_PAGE dataType:DataTypeArray] mutableCopy];

        if ([arrayHome count] == 0) {
            [[RabbitTVManager sharedManager] getHomeDetails:^(AFHTTPRequestOperation *operation, id responseObject) {
                arrayHome = responseObject;
                [self loadHomeDetails];
            }];
        }
        else {
            [self loadHomeDetails];
        }
        
   
}

- (void) loadHomeDetails {
    
    arrayName = [[arrayHome valueForKey:@"name"]mutableCopy];
    arrayTitle = [[arrayHome valueForKey:@"title"]mutableCopy];
    arrayNetworkNames = [[arrayHome objectAtIndex:0] valueForKey:@"items"];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

#pragma mark - loadSubScriptionPage

-(void)loadSubScriptionPage{
    
    
    subScriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //[subScriptionView setBackgroundColor:[UIColor whiteColor]];
    //subScriptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    self.view = [COMMON setBackGroundColor:self.view];
    subScriptionView.backgroundColor = GRAY_BG_COLOR;
    [self setUpTitleLabels];
    [self.view addSubview:subScriptionView];
}

-(void)setUpTitleLabels {
    
    CGFloat switchViewWidth = 50;
    CGFloat transFormsize = 0.60;
    CGFloat titleFontSize = 11;
    CGFloat premiumSubLabelFontSize = 13;
    
    CGFloat satelliewViewHeight = 50;
    CGFloat satelliewViewLabelHeight = 20;
    
    CGFloat switchViewHeight = 30;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        switchViewWidth = 70;
        switchViewHeight = 50;
        transFormsize = 0.90;
        titleFontSize = 14;
        premiumSubLabelFontSize =16;
        satelliewViewHeight = 80;
        satelliewViewLabelHeight = 35;
    }
    
    
    //SATELLITE VIEW
    UIView *satelliteView = [[UIView alloc]initWithFrame:CGRectMake(0,10,SCREEN_WIDTH-switchViewWidth,satelliewViewHeight)];
    [satelliteView setBackgroundColor:[UIColor clearColor]];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,satelliteView.frame.size.width-10, satelliewViewLabelHeight)];
    titleLabel.text = @"Do you pay for Cable or Satellite TV?";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [satelliteView addSubview:titleLabel];
    
    UILabel * titleSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame),satelliteView.frame.size.width-10, satelliewViewLabelHeight)];
    titleSubLabel.text = @"(We'll use this to customize your viewing options)";
    titleSubLabel.textColor = [UIColor whiteColor];
    titleSubLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    titleSubLabel.textAlignment = NSTextAlignmentLeft;
    [titleSubLabel setBackgroundColor:[UIColor clearColor]];
    [satelliteView addSubview:titleSubLabel];
    
    [subScriptionView addSubview:satelliteView];
    
    
    UIView *switchView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-switchViewWidth, 15, switchViewWidth, switchViewHeight)];
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, switchViewWidth-10, switchViewWidth-10)];
    [freeSwitch addTarget:self action:@selector(flipSwitchCableSelect:) forControlEvents:UIControlEventTouchUpInside];
    //[freeSwitch setOnTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    
    NSMutableDictionary * currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = [COMMON getLoginDetails];
    NSMutableArray *tempArray = [NSMutableArray new];
    if([currentUserLoginDetails count]!=0){
        tempArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
    }
    //NSMutableArray *tempSubArray =
    
    for(id tempDict in tempArray){
        NSString *appCode = [tempDict valueForKey:@"code"];
        if ((NSString *)[NSNull null] == appCode||appCode == nil) {
            appCode =@"";
        }
        if([appCode isEqualToString:@"CABLE"]){
            isCableSelected = [[tempDict valueForKey:@"subscribed"]boolValue];
            break;
        }
    }
    if(isCableSelected==YES){
        [freeSwitch setOn:YES];
    }
    else{
        [freeSwitch setOn:NO];
    }
    
    
    freeSwitch.transform = CGAffineTransformMakeScale(transFormsize,transFormsize);
    
    [switchView addSubview:freeSwitch];
    [switchView setBackgroundColor:[UIColor clearColor]];
    [subScriptionView addSubview:switchView];
    
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(satelliteView.frame),SCREEN_WIDTH-5,1.0)];
    topBorder.backgroundColor = [COMMON Common_Light_BG_Color];
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [subScriptionView addSubview:topBorder];
    
    //PREMIUM VIEW
    UIView *premiumView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topBorder.frame)+5,SCREEN_WIDTH,satelliewViewHeight)];
    [premiumView setBackgroundColor:[UIColor clearColor]];
    
    UILabel * premiumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,premiumView.frame.size.width-10, satelliewViewLabelHeight)];
    premiumTitleLabel.text = @"Do you pay for any of these premium online services?";
    premiumTitleLabel.textColor = [UIColor whiteColor];
    premiumTitleLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    premiumTitleLabel.textAlignment = NSTextAlignmentLeft;
    [premiumTitleLabel setBackgroundColor:[UIColor clearColor]];
    [premiumView addSubview:premiumTitleLabel];
    
    UILabel * premiumSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(premiumTitleLabel.frame),premiumView.frame.size.width-10, satelliewViewLabelHeight)];
    premiumSubLabel.text = @"Select any that apply.";
    premiumSubLabel.textColor = [UIColor whiteColor];
    premiumSubLabel.font = [COMMON getResizeableFont:Roboto_Regular(premiumSubLabelFontSize)];
    premiumSubLabel.textAlignment = NSTextAlignmentLeft;
    [premiumSubLabel setBackgroundColor:[UIColor clearColor]];
    [premiumView addSubview:premiumSubLabel];
    
    [subScriptionView addSubview:premiumView];
    
    [self setUpCollectionView:premiumView];
    
    //BOTTOM VIEW
    
   // subscriptionBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,subScriptionView.frame.size.height-140,subScriptionView.frame.size.width,70)];
    
    subscriptionBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-150,SCREEN_WIDTH,100)];
    
    [subscriptionBottomView setBackgroundColor:[UIColor clearColor]];
    
    [subScriptionView addSubview:subscriptionBottomView];
    
    CGFloat XPos = (SCREEN_WIDTH/2)-155;//160
    
    UIButton* setBtn = [[UIButton alloc] initWithFrame:CGRectMake(XPos ,10,150, 50)];
    
    //CGFloat XPos = _collectionView.frame.size.width/2;
    
    //UIButton* setBtn = [[UIButton alloc] initWithFrame:CGRectMake(XPos ,CGRectGetMaxY(_collectionView.frame)+5,_collectionView.frame.size.width-(XPos*2) , 40)];
    [setBtn setTitle:@"Update" forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    [setBtn addTarget:self action:@selector(loadSubscriptionsCode) forControlEvents:UIControlEventTouchUpInside];
    [subscriptionBottomView addSubview:setBtn];
    
    CGFloat XPos1 = CGRectGetMaxX(setBtn.frame)+10; 
    
    UIButton* skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(XPos1 ,10,150, 50)];

    [skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    [skipBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    [skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [subscriptionBottomView addSubview:skipBtn];

    
}
#pragma mark - switch flip action
- (IBAction) flipSwitchCableSelect: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    
    if (onoff.on){
        //FREE
        isCableSelected=YES;
    }
    else {
        //ALL
        isCableSelected = NO;
    }
    
}

-(void)setUpCollectionView:(UIView*)lastView
{
    
    CGFloat Xpos = 30; //35
    CGFloat Height = SCREEN_HEIGHT/1.8;
    
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        Xpos = 30;
        Height = SCREEN_HEIGHT/3;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            Xpos = 70;
            Height = SCREEN_HEIGHT/3;
        }
    }else{
        Xpos = 30;
        Height = SCREEN_HEIGHT/1.8;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            Xpos = 70;
            Height = SCREEN_HEIGHT/1.5;
        }
    }
    CGRect collectionFrame = subScriptionView.frame;
    collectionFrame.origin.x = Xpos;
    collectionFrame.origin.y = CGRectGetMaxY(lastView.frame)+100;
    collectionFrame.size.width = SCREEN_WIDTH-(Xpos*2);
    collectionFrame.size.height = Height;
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lastView.frame)+100, SCREEN_WIDTH-40,Height ) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    CGRect collection = _collectionView.frame;
    collection.origin.y = CGRectGetMaxY(lastView.frame)+ 500;
    _collectionView.frame = collection;
    
    // [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"subscriptionCustomCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"subscriptionCustomCollectionCell"];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [subScriptionView addSubview:_collectionView];
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return  CGSizeMake(120 , 120);
    }
    else{
        return  CGSizeMake(100 , 100);
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [currentSubscriptionArray count];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
     subscriptionCustomCollectionCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"subscriptionCustomCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *dictItem = [currentSubscriptionArray objectAtIndex:indexPath.row];
    NSString *imageUrl = [dictItem valueForKey:@"image_url"];
    NSString *grayImageUrl = [dictItem valueForKey:@"gray_image_url"];
    
    NSString *appName = [dictItem valueForKey:@"name"];
     if ((NSString *)[NSNull null] == grayImageUrl||grayImageUrl == nil) {
         grayImageUrl =@"";
     }
    if ((NSString *)[NSNull null] == imageUrl||imageUrl == nil) {
        imageUrl=@"";
    }
    
    isSelectedItem = [[dictItem valueForKey:@"isSelectedItem"]boolValue];
    [cell.appColorView setHidden:YES];
    
    
    [cell.tickIconImageView setHidden:YES];
    
    if(isSelectedItem==NO){//gray  hulu.png
        
        if([grayImageUrl isEqualToString:@""]){
            if([appName isEqualToString:@"Hulu"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hulu.png"]];
            }
            else if([appName isEqualToString:@"NetFlix"]){
                [cell.appImage setImage:[UIImage imageNamed:@"netflix.png"]];
            }
            else if([appName isEqualToString:@"Amazon"]){
                [cell.appImage setImage:[UIImage imageNamed:@"amazon.png"]];
            }
            else if([appName isEqualToString:@"CBS"]){
                [cell.appImage setImage:[UIImage imageNamed:@"cbs.png"]];
            }else if([appName isEqualToString:@"HBO Now"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hbo.png"]];
            }
            else if([appName isEqualToString:@"ShowTime"]){
                [cell.appImage setImage:[UIImage imageNamed:@"sho.png"]];
            }
            else{
                [cell.appImage setImageWithURL:[NSURL URLWithString:grayImageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
            }
        }
        else{
             [cell.appImage setImageWithURL:[NSURL URLWithString:grayImageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
        }
        

           [cell.tickIconImageView setHidden:YES];
    }
    
    else{
        if([imageUrl isEqualToString:@""]){
            if([appName isEqualToString:@"Hulu"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hulu_active.png"]];
            }
            else if([appName isEqualToString:@"NetFlix"]){
                [cell.appImage setImage:[UIImage imageNamed:@"netflix_active.png"]];
            }
            else if([appName isEqualToString:@"Amazon"]){
                [cell.appImage setImage:[UIImage imageNamed:@"amazon_active.png"]];
            }
            else if([appName isEqualToString:@"CBS"]){
                [cell.appImage setImage:[UIImage imageNamed:@"cbs_active.png"]];
            }else if([appName isEqualToString:@"HBO Now"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hbo_active.png"]];
            }
            else if([appName isEqualToString:@"ShowTime"]){
                [cell.appImage setImage:[UIImage imageNamed:@"sho_active.png"]];
            }
            else{
                [cell.appImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
            }
        }
        
        else{
            [cell.appImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
        }
        
        [cell.tickIconImageView setHidden:NO];
        
    }
    
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
    
    subscriptionCustomCollectionCell* cell = (subscriptionCustomCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableDictionary *tempValue =  [currentSubscriptionArray objectAtIndex:indexPath.row];
    isSelectedItem = [[tempValue valueForKey:@"isSelectedItem"]boolValue];
    
    //NSString *imageUrl = [tempValue valueForKey:@"image_url"];
    NSString *imageUrl = [tempValue valueForKey:@"image_url"];
    NSString *appName = [tempValue valueForKey:@"name"];
    NSString *grayImageUrl = [tempValue valueForKey:@"gray_image_url"];
    if ((NSString *)[NSNull null] == grayImageUrl||grayImageUrl == nil) {
        grayImageUrl =@"";
    }
    if ((NSString *)[NSNull null] == imageUrl||imageUrl == nil) {
        imageUrl=@"";
    }
    
    if(isSelectedItem==YES){  //gray  hulu.png
        [cell.tickIconImageView setHidden:YES];
          if([grayImageUrl isEqualToString:@""]){
              if([appName isEqualToString:@"Hulu"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"hulu.png"]];
              }
              else if([appName isEqualToString:@"NetFlix"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"netflix.png"]];
              }
              else if([appName isEqualToString:@"Amazon"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"amazon.png"]];
              }
              else if([appName isEqualToString:@"CBS"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"cbs.png"]];
              }else if([appName isEqualToString:@"HBO Now"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"hbo.png"]];
              }
              else if([appName isEqualToString:@"ShowTime"]){
                  [cell.appImage setImage:[UIImage imageNamed:@"sho.png"]];
              }
              else{
                  [cell.appImage setImageWithURL:[NSURL URLWithString:grayImageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
              }

          }
        else{
            [cell.appImage setImageWithURL:[NSURL URLWithString:grayImageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
        }
        
        NSMutableDictionary *temp = [NSMutableDictionary new];
        temp = [tempValue mutableCopy];
        [temp setObject:@"NO" forKey:@"isSelectedItem"];
        [currentSubscriptionArray replaceObjectAtIndex:indexPath.row withObject:[temp mutableCopy]];

    }
    //cell.appImage.image = [self convertOriginalImageToBWImage:cell.appImage.image];
    
    else{
         [cell.tickIconImageView setHidden:NO];
        if([imageUrl isEqualToString:@""]){
            if([appName isEqualToString:@"Hulu"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hulu_active.png"]];
            }
            else if([appName isEqualToString:@"NetFlix"]){
                [cell.appImage setImage:[UIImage imageNamed:@"netflix_active.png"]];
            }
            else if([appName isEqualToString:@"Amazon"]){
                [cell.appImage setImage:[UIImage imageNamed:@"amazon_active.png"]];
            }
            else if([appName isEqualToString:@"CBS"]){
                [cell.appImage setImage:[UIImage imageNamed:@"cbs_active.png"]];
            }else if([appName isEqualToString:@"HBO Now"]){
                [cell.appImage setImage:[UIImage imageNamed:@"hbo_active.png"]];
            }
            else if([appName isEqualToString:@"ShowTime"]){
                [cell.appImage setImage:[UIImage imageNamed:@"sho_active.png"]];
            }
            else{
                [cell.appImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
            }

        }
        
        else{
            [cell.appImage setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"portrait_Loader"]];
        }
        
        NSMutableDictionary *temp = [NSMutableDictionary new];
        temp = [tempValue mutableCopy];
        [temp setObject:@"YES" forKey:@"isSelectedItem"];
        [currentSubscriptionArray replaceObjectAtIndex:indexPath.row withObject:[temp mutableCopy]];

    }
    
    //cell.appImage.image = [self convertOriginalImageToBWImage:cell.appImage.image];
    
}
-(void)imageContains{
    
}

-(void)loadSubscriptionsCode{
    
    NSArray *newArray;
    
    if(isCableSelected==YES){
        
        newArray=[[currentSubscriptionArray arrayByAddingObjectsFromArray:currentCableArray]mutableCopy];
        currentSubscriptionArray = [(NSMutableArray*)newArray mutableCopy];
    }
    
     NSLog(@"currentSubscriptionArray-->%@",currentSubscriptionArray);
    
    NSString *subscriptionCode =@"";
    NSMutableArray * tempArray = [NSMutableArray new];
    //tempArray = [currentSubscriptionArray mutableCopy];
    
    NSMutableDictionary * tempSubCodeDict = [NSMutableDictionary new];
    
   // for (int i = 0; i < [currentSubscriptionArray count]; i++) {
    for(id tempDict in currentSubscriptionArray){
        
        tempSubCodeDict = [tempDict mutableCopy];
        
        isSelectedItem = [[tempDict valueForKey:@"isSelectedItem"]boolValue];
        
         if(isSelectedItem==YES){
             if (subscriptionCode == nil || [subscriptionCode isEqualToString:@""])
                 subscriptionCode = [tempDict valueForKey:@"code"];
             else{
                 subscriptionCode = [NSString stringWithFormat:@"%@,%@", subscriptionCode, [tempDict valueForKey:@"code"]];
             }
             [tempArray addObject:[tempSubCodeDict mutableCopy]];
             
         }
    }
    NSLog(@"subscriptionCode-->%@",subscriptionCode);
    NSLog(@"tempArray-->%@",tempArray);
    
    NSMutableDictionary * currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = (NSMutableDictionary*)[COMMON getLoginDetails];
    
    if([tempArray count]!=0){
        NSMutableDictionary *mutableDict = [currentUserLoginDetails mutableCopy];
        [mutableDict setObject:[tempArray mutableCopy] forKey:@"subscriptions"];
        currentUserLoginDetails = [mutableDict mutableCopy];
        [COMMON setLoginDetails:(NSMutableDictionary*)[currentUserLoginDetails mutableCopy]];
    }
   
    NSLog(@"currentUserLoginDetails-->%@",currentUserLoginDetails);
     NSLog(@"subscriptionCode-->%@",subscriptionCode);
    
    [self setSubscriptionArrayBasedOnUserSelection:subscriptionCode];
    
}

-(void)setSubscriptionArrayBasedOnUserSelection:(NSString*)subscriptionCode{
    
    [[RabbitTVManager sharedManager]setUserSubscriptions:^(AFHTTPRequestOperation * request, id responseObject) {
        
        NSLog(@"responseObject-->%@",responseObject);
        
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        
        NSLog(@"error-->%@",error);
        
    } strAccessToken:[COMMON getUserAccessToken] subscriptionCode:subscriptionCode];
    
    [subScriptionView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"MobileDashboard" forKey:MOBILE_DASHBOARD];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self setMobileLandingScreen];
  
}
-(void)skipAction{
    [subScriptionView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"MobileDashboard" forKey:MOBILE_DASHBOARD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setMobileLandingScreen];
}


- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
-(UIImage *)convertOriginalImageToBWImage:(UIImage *)originalImage
{
    UIImage *newImage;
    
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    //    CGContextRef context =  CGBitmapContextCreate(nil, originalImage.size.width * originalImage.scale, originalImage.size.height * originalImage.scale, 8, originalImage.size.width * originalImage.scale, colorSapce, kCGImageAlphaNone);
    
    CGContextRef context =  CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height , 8, 0, colorSapce, kCGImageAlphaNone);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
    CGImageRelease(bwImage);
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
    [resultImage drawInRect:CGRectMake(0.0, 0.0, originalImage.size.width, originalImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}


-(void) rotateViews:(BOOL) bPortrait{
    
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_searchButton setHidden:NO];
    [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
    
    if(bPortrait){
        
        //MOBILE LANDING SCREEN
        port_HomeViewHeight= SCREEN_HEIGHT;
        if(port_HomeViewHeight!=land_HomeViewHeight){
            [self onHomePageRotation:YES];
            
        }
        boolLandscape= false;
       
    }
    
    else{
        //MOBILE LANDING SCREEN
        land_HomeViewHeight= SCREEN_HEIGHT;
        if(port_HomeViewHeight!=land_HomeViewHeight){
            [self onHomePageRotation:NO];
            
        }
        NSLog(@"elseportrait");
        boolLandscape= true;

    }
    
}


-(void)onHomePageRotation:(BOOL)portraitBool{
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"SubscriptionPage" forKey:MOBILE_DASHBOARD];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:MOBILE_DASHBOARD];
    
    if ((NSString *)[NSNull null] == str||str == nil) {
         str=@"";
     }
    if([str isEqualToString:@"MobileDashboard"]){
        [self setMobileLandingScreen];
    }
    else{
        [subScriptionView removeFromSuperview];
//        [self loadSubScriptionPage];
        [self setMobileLandingScreen];//New Aruna
//        [[NSUserDefaults standardUserDefaults] setObject:@"SubscriptionPage" forKey:MOBILE_DASHBOARD];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(portraitBool==YES){
        land_HomeViewHeight  = port_HomeViewHeight;
    }
    else{
        port_HomeViewHeight  = land_HomeViewHeight;
    }
    
    
}

#pragma notificationFromMobilePage

-(void) notificationFromMobilePage:(NSNotification *)notification{
    
    NSDictionary *cellData = [notification object];
    //NSString* currentCellData = cellData[@"homeName"];
    NSString *currentIndex = cellData[@"homeIndex"];
    
    if([currentIndex isEqualToString:@"0"]){
        [self pushToChannelsView];//currentIndex
    }
    if([currentIndex isEqualToString:@"1"]){
        [self pushToOnDemandView];
    }
    if([currentIndex isEqualToString:@"2"]){
        [self pushToRadioPage];
    }
    if([currentIndex isEqualToString:@"3"]){
        [self pushToPayPerView];
    }
    if([currentIndex isEqualToString:@"4"]){
        [self pushToSubscriptionsView];
    }
    if([currentIndex isEqualToString:@"5"]){
        [self pushToOverTheAirScreen];
    }
    if([currentIndex isEqualToString:@"6"]){
        [self pushToMyInterestsView];
    }
    if([currentIndex isEqualToString:@"7"]){
        [self pushToMyAccountView];
    }
    if([currentIndex isEqualToString:@"8"]){
        [self pushToMyGamesView:NO];
    }
    if([currentIndex isEqualToString:@"9"]){
        [self pushToMyGamesView:YES];
    }
    
}

-(void) pushToRadioPage{
    
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"radioNavController"];
    RadioViewController *radioVC;
    radioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RadioViewController"];
    [self.navigationController pushViewController:radioVC animated:YES];
}
#pragma mark - pushToChannelsView
-(void)pushToChannelsView{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"portrait"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc]init];
    [dictItem setObject:@"4760" forKey:@"id"];
    [dictItem setObject:@"Channels" forKey:@"name"];
    NSString* strID = @"4760";//@"328";
    NSString* strTitle = @"Channels";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatestream" object:dictItem];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    MainViewController * mainVC = nil;
    mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainVC.youtubeID = strID;
    mainVC.youtubeTitle =strTitle;
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
#pragma mark - pushToOnDemandView
-(void)pushToOnDemandView{
    NSString* isSibarAppManager =@"NO";
    [COMMON isSideBarAppManager:isSibarAppManager];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"movieNavController"];
    MovieViewController * mMovieVC = nil;
    mMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
    mMovieVC.headerLabelStr=@"On Demand";
    mMovieVC.dropDownTvShowArray= arrayHomeShows;
    mMovieVC.dropDownTvNetworkArray= arrayHomeNetworks;
    mMovieVC.dropDownNSArray= arrayHomeMovies;
    mMovieVC.isLoadIcon= NO;
    mMovieVC.isAppManagerMenu = NO;
    [mMovieVC loadSliderCarouselScreen];
    mMovieVC.isPayPerView=NO;
    [self.navigationController pushViewController:mMovieVC animated:YES];
}
#pragma mark - pushToPayPerView
-(void)pushToPayPerView{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"payMovieNavController"];
    PayMovieViewController * payVC = nil;
    payVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMovieViewController"];
    payVC.dropDownNSArray=arrayHomeMovies;
    payVC.payHeaderLabelStr=@"Pay Per View";
    payVC.payShowStr = @"Movies";
    payVC.isPayPerView=YES;
    [payVC loadSliderCarouselScreen];
     [self.navigationController pushViewController:payVC animated:YES];
}
#pragma mark - pushToSubscriptionsView
-(void)pushToSubscriptionsView{
    
    NSString* strID =@"";
    NSInteger currentInteger = 1;

    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"subnavcontroller"];
    SubScriptionsViewController * mSubVC = nil;
    mSubVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubScriptionsViewController"];
    mSubVC.isKidsMenu = NO;
    mSubVC.isSide = NO;
    [mSubVC updateData:strID bKid:false :currentInteger];
    [self.navigationController pushViewController:mSubVC animated:YES];
}
#pragma mark - pushToMyGamesView
-(void)pushToMyGamesView:(BOOL)currentBool{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"gamesNavController"];
    GamesViewController *gamesVC=nil;
    gamesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GamesViewController"];
    gamesVC.isMoreView = currentBool;
    if(currentBool==YES){
        [gamesVC getMoreDataList];
    }
    [self.navigationController pushViewController:gamesVC animated:YES];
}
#pragma mark - pushToMyInterestsView
-(void)pushToMyInterestsView{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"myInterestsNavController"];
    MyInterestsViewController *myInterestVC;
    myInterestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInterestsViewController"];
    myInterestVC.movieGenreArray = arrayHomeMovies;
    myInterestVC.networkGenreArray = arrayHomeNetworks;
    [self.navigationController pushViewController:myInterestVC animated:YES];
}
#pragma mark - pushToMyAccountView
-(void)pushToMyAccountView{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"myAccountNavController"];
    MyAccountViewController *myAccVC;
    myAccVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
    [self.navigationController pushViewController:myAccVC animated:YES];

}
#pragma mark - pushToOverTheAirScreen
-(void)pushToOverTheAirScreen{
//    SWRevealViewController *revealviewcontroller = self.revealViewController;
//    [revealviewcontroller revealToggle:nil];
//    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"overTheAirNavController"];
//    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"overTheAirNavController"];
//    revealviewcontroller.frontViewController = navController;
//    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
//    OverTheAirViewController *OverTheAirViewController;
//    OverTheAirViewController = [[navController viewControllers] objectAtIndex:0];
    
    OverTheAirViewController * OverTheAirViewController = nil;
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"overTheAirNavController"];
    OverTheAirViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OverTheAirViewController"];
    [self.navigationController pushViewController:OverTheAirViewController animated:YES];
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
