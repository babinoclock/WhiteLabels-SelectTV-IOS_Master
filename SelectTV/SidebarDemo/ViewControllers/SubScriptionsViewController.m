//
//  SubScriptionsViewController.m
//  SidebarDemo
//
//  Created by Panda on 7/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SubScriptionsViewController.h"
#import "UIGridView.h"
#import "RabbitTVManager.h"
#import "SubscriptionCell.h"
#import "PromoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PlusViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "AsyncImage.h"
#import "MBProgressHUD.h"
#import "SearchViewController.h"
#import "PayMovieViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "NkContainerCellView.h"
#import "NKContainerCellTableViewCell.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "New_Land_Cell.h"
#import "LoginViewController.h"
@interface SubScriptionsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    AsyncImage * asyncImage;
    NSMutableArray * arrayItems;
    
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
    
    
    //NEW
    BOOL isLoadedHome;
    BOOL isSeasonArrayExist;
    NSMutableArray* arrayHome;
    NSMutableArray * arrayTitle;
    NSMutableArray * arrayName;
    NSMutableArray * arrayNetworkNames;
    NSMutableArray * arrayTvName;
    NSMutableArray *arraySeasons;
    
    
    //New Home Table
    NSString *strCellSelectionId;
    NSString *strCellSelectionName;
    NSString *strCellSelectionType;
    NSString *strCellSelectionImage;
    
    BOOL isKidSelected;
    
    NSString *currentApplanguage;



}


@end

@implementation SubScriptionsViewController
@synthesize isKid,isKidsMenu,isKidsMenuMovie;
@synthesize isPushedFromSubscriptView;

int nSubColumCount = 2;
int nSubCellWidth = 107;
int nSubCellHeight = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    tempArray = [NSMutableArray new];
    selectedSubscriptArray = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectSubscript:) name:@"didSelectSubscript" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectShowsMovies:) name:@"didSelectItemFromSubscriptionView" object:nil];

    subscriptionCode =@"";
    currentApplanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr;
    if(isKidsMenu == YES){
        titleStr = @"Kids";
    }
    else{
        titleStr = @"SubScriptions";
    }
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    UIDevice* subDevice = [UIDevice currentDevice];
    if(subDevice.orientation == UIDeviceOrientationLandscapeLeft || subDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    

    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromSubcriptionCollectionView:) name:@"didSelectItemFromCollectionView" object:nil ];
    
    if(isKidSelected == true){
        [self.subScriptionIndicator setHidden:true];
        [self.tableView setHidden:NO];
        [_subscriptionScrollView setHidden:YES];
    }
    
    else{
        [self.subscriptionTable setHidden:YES];
        [self.tableView setHidden:NO];
        [self.subScriptionIndicator setHidden:YES];
        [_subscriptionScrollView setHidden:YES];
    }
//    _subscriptionTable.delegate = self;
//    _subscriptionTable.dataSource = self;
//    _subscriptionTable.backgroundColor = [UIColor clearColor];
//    _subscriptionScrollView.backgroundColor = [UIColor blackColor];
    
    
    
//    _subscriptionTable.opaque = NO;
//    _subscriptionTable.backgroundView = nil;
//    _subscriptionTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _subscriptionTable.autoresizesSubviews = true;
    _subscriptionTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    //[_subscriptionTable setBackgroundColor:[UIColor lightGrayColor]];

    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    self.view.backgroundColor = GRAY_BG_COLOR;
    currentCableArray = [NSMutableArray new];
    NSMutableDictionary * currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = [COMMON getLoginDetails];
    loginSubscriptionArray = [NSMutableArray new];
    if([currentUserLoginDetails count]!=0){
        loginSubscriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
    }

    currentSubscriptionArray = [NSMutableArray new];
    
    [self getUserSubscriptions];
    [self.subscriptionTable setHidden:YES];
    [self.tableView setHidden:NO];
    [self.subScriptionIndicator setHidden:YES];
    [_subscriptionScrollView setHidden:YES];

    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    [caurosalArray removeAllObjects];
    [self loadSubScriptionPage];
   
    [_subscriptionTable setHidden:YES];
    [self.tableView setHidden:YES];
    [self.subScriptionIndicator setHidden:true];
    [_subscriptionScrollView setHidden:YES];

}
-(void) viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
   // self.subscriptionTableHeight.constant = self.subscriptionTable.contentSize.height;
    
    //[self.view layoutIfNeeded];
    
}

- (void) didSelectSubscript:(NSNotification *)notification
{
    [self removeSearchView];
    [[RabbitTVManager sharedManager]cancelRequest];
//    NSArray *cellData = [notification object];
    NSDictionary *dictValues = [notification object];
    NSLog(@"values-->%@",selectedSubscriptArray);
    NSMutableDictionary * tempSubCodeDict = [NSMutableDictionary new];
    NSString *cStr;
        isSelectedItem = NO;
        isSelectedItem = [[dictValues valueForKey:@"subscribed"]boolValue];
        NSString *code = [dictValues valueForKey:@"code"];
    NSMutableDictionary *caurosalDict = [NSMutableDictionary new];

    NSString *index = [dictValues objectForKey:@"index"];
    int i=0;
    for(NSDictionary *dictData in caurosalArray) {
        NSString *codeStr = [dictData objectForKey:@"code"];
        if([codeStr isEqualToString:code])
            break;
        i++;
    }
    caurosalDict = [caurosalArray objectAtIndex:i];
    [caurosalDict setObject:[dictValues valueForKey:@"subscribed"] forKey:@"subscribed"];
    if(index<=[caurosalArray count])
        [caurosalArray replaceObjectAtIndex:[index integerValue] withObject:caurosalDict];
    if(isSelectedItem==YES) {
           cStr= [dictValues objectForKey:@"code"];
 
            NSString *imgUrl = [dictValues objectForKey:@"image_url"];
            [tempSubCodeDict setObject:imgUrl forKey:@"image_url"];
            [tempSubCodeDict setObject:code forKey:@"code"];
//            [tempSubCodeDict setObject:[dictValues valueForKey:@"subscribed"] forKey:@"subscribed"];
            [selectedSubscriptArray addObject:tempSubCodeDict];
        } else {
            NSMutableArray *deletionArr = [NSMutableArray new];
            deletionArr = [selectedSubscriptArray mutableCopy];
            int i =0;
            for(id tempDict1 in deletionArr) {
                NSString *codeSelected = [tempDict1 valueForKey:@"code"];
                if([code isEqualToString:codeSelected])
                    [selectedSubscriptArray removeObjectAtIndex:i];
                i++;
            }
        }
}

- (void) didSelectShowsMovies:(NSNotification *)notification {
    NSDictionary *dictValues = [notification object];
    NSString *nameString = [dictValues valueForKey:@"name"];
    NSString *idStr = [dictValues valueForKey:@"id"];
   BOOL isSubscribed = [[dictValues valueForKey:@"subscribed"]boolValue];
    if(isSubscribed)
        [self loadNewMovieDetailPage:nameString andID:idStr];
}

#pragma mark - loadNewMovieDetailPage
-(void)loadNewMovieDetailPage:(NSString *)name andID:(NSString *)strSelectedId{
    
    NewMovieDetailViewController *mNewMovieVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mNewMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_movie_detail_ipad"];
    } else {
        mNewMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_moviedetail_iphone"];
    }
//    if([strSelectedType isEqualToString:@"movie"]){
        [mNewMovieVC setIfMovies:true];
//    }
//    else{
//        [mNewMovieVC setIfMovies:false];
//    }
    
    mNewMovieVC.nID = strSelectedId;
    mNewMovieVC.headerLabelStr = name;
    mNewMovieVC.isEpisode=NO;
    mNewMovieVC.genreName = @"M";
    [self.navigationController pushViewController:mNewMovieVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


- (NSArray *)arrayByEliminatingDuplicatesMaintainingOrder:(NSArray*)array {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:array];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    return arrayWithoutDuplicates;
}

-(void)setSubscriptionArrayBasedOnUserSelection:(NSString*)subscriptionCode1{
    
    [[RabbitTVManager sharedManager]setUserSubscriptions:^(AFHTTPRequestOperation * request, id responseObject) {
        
        NSLog(@"responseObject-->%@",responseObject);
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        
        NSLog(@"error-->%@",error);
    } strAccessToken:[COMMON getUserAccessToken] subscriptionCode:subscriptionCode1];
    
}

-(void)getUserSubscriptions{
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getUserSubscriptions:^(AFHTTPRequestOperation * request, id responseObject) {
        
        NSLog(@"responseObject-->%@",responseObject);
        currentSubscriptionArray = [responseObject mutableCopy];
        [setBtn setHidden:NO];
        [self switchFunctionality];
        [self getCaurosalApi];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        
        NSLog(@"error-->%@",error);
//        [AppCommon showSimpleAlertWithMessage:@"Your access token has been expired"];
        NSString *errorStr = @"Invalide or expired token, Please Login to Continue";
        [self alertView:errorStr];
        [setBtn setHidden:YES];
        [COMMON removeLoading];
        
    } strAccessToken:[COMMON getUserAccessToken]];
    
}

-(void)logoutForTokenExpired{
    
    [COMMON removeLoginDetails];
    [COMMON removeLoading];
    [self pushToLoginScreen];
}
-(void)pushToLoginScreen{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController * LoginVC = nil;
    LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

#pragma mark - alertView
-(void)alertView:(NSString *)errorStr{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                                    message:errorStr
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok",nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Cancel
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        //Ok
        [self logoutForTokenExpired];
        
    }
}

#pragma mark - setUpSearchBarInNavigation
-(void) setUpSearchBarInNavigation {
    searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(5, -5, self.view.frame.size.width-10, 48)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBarView setShowsCancelButton:YES];
    searchBarView.delegate = self;
    [searchBarView setTintColor:[UIColor whiteColor]];
    searchBarView.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
    //searchBarView.backgroundColor = GRAY_BG_COLOR;
    searchBarView.autocorrectionType = UITextAutocorrectionTypeNo;
    for (id subView in ((UIView *)[searchBarView.subviews objectAtIndex:0]).subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            searchTextField = subView;
            searchTextField.keyboardAppearance = UIKeyboardAppearanceLight;
            //[searchTextField setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:116.0f/255.0f blue:203.0f/255.0f alpha:1]];
           // searchTextField.backgroundColor = GRAY_BG_COLOR;
            ///searchTextField.textColor =[UIColor whiteColor];
           // UIColor *color = [UIColor colorWithRed:119.0f/255.0f green:176.0f/255.0f blue:216.0f/255.0f alpha:1];
            searchTextField.textColor =[UIColor whiteColor];
            searchTextField.backgroundColor = [COMMON Common_Screen_BG_Color];
            UIColor *color = [UIColor whiteColor];
            searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search title, actor or movie" attributes:@{NSForegroundColorAttributeName: color}];
            break;
        }
        if([subView isKindOfClass:[UIButton class]]) {
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchString = searchText;
}
#pragma mark - SearchAction in keyboard
-(void)searchClickAction:(id)sender {
    [_searchButton setHidden:NO];
    if(searchString!=nil && ![searchString isEqualToString:@""]) {
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
    
    if(searchString!=nil && ![searchString isEqualToString:@""]) {
        [searchBarView setHidden:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self.view endEditing:YES];
        //[COMMON LoadIcon:self.view];
        [COMMON loadProgressHud];
        [self searchCombined];
    }
    else {
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
- (void)updateData:(NSString *)strID bKid:(BOOL)bKid :(NSInteger)currentIndex
{
    [self.subScriptionIndicator setHidden:false];
    
    arrayHome= [[NSMutableArray alloc]init];
    arrayItems= [[NSMutableArray alloc]init];
    //arrayHome =[[NSUserDefaults standardUserDefaults] valueForKey:HOMEDETAILS];
    arrayName= [[NSMutableArray alloc]init];
    arrayTitle= [[NSMutableArray alloc]init];
    arrayTvName= [[NSMutableArray alloc]init];
    arraySeasons = [[NSMutableArray alloc]init];

   
    if(arrayItems == NULL) {
    }
    else{
        [arrayItems removeAllObjects];
    }
    isKidSelected = bKid;
    if(bKid == true){
        [self.subScriptionIndicator setHidden:true];
        [self.tableView setHidden:NO];
        
        [[RabbitTVManager sharedManager] getKidItems:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayItems = [responseObject mutableCopy];
//            [self.tableView reloadData];
            [self.subscriptionTable setHidden:YES];
            
        } nID:[strID intValue]];
    }else{
        
        NSString * subscriptionID = @"2669";
        
        [[RabbitTVManager sharedManager] getSubScriptionItems:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayItems = [responseObject mutableCopy];
            [self.tableView setHidden:NO];
//            [self.tableView reloadData];
            [self.subscriptionTable setHidden:YES];
        } nID:[subscriptionID intValue]];
        
//        [arrayItems removeAllObjects];
//        [self.subscriptionTable setHidden:NO];
//        [self.tableView setHidden:YES];
//        [self.subScriptionIndicator setHidden:true];
//        [self getTableData:currentIndex];
    }
    

}

#pragma mark - loadSubScriptionPage

-(void)loadSubScriptionPage{
    CGFloat x;
    if(_isSide==NO)
        x =0 ;
    else
        x = 64;
    
    subScriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, x, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //[subScriptionView setBackgroundColor:[UIColor whiteColor]];
   // subScriptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,satelliteView.frame.size.width-10, satelliewViewLabelHeight)];
    titleLabel.text = @"Do you pay for Cable or Satellite TV?";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [satelliteView addSubview:titleLabel];
    
    UILabel * titleSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame),satelliteView.frame.size.width-10, satelliewViewLabelHeight)];
    titleSubLabel.text = @"(We'll use this to customize your viewing options)";
    titleSubLabel.textColor = SKY_BLUE;
    titleSubLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    titleSubLabel.textAlignment = NSTextAlignmentLeft;
    [titleSubLabel setBackgroundColor:[UIColor clearColor]];
    [satelliteView addSubview:titleSubLabel];
    
    [subScriptionView addSubview:satelliteView];
    
    
    UIView *switchView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-switchViewWidth, 15, switchViewWidth, switchViewHeight)];
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, switchViewWidth-10, switchViewWidth-10)];
    [freeSwitch addTarget:self action:@selector(flipSwitchCableSelect:) forControlEvents:UIControlEventTouchUpInside];
    //[freeSwitch setOnTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    
    freeSwitch.transform = CGAffineTransformMakeScale(transFormsize,transFormsize);
    [switchView addSubview:freeSwitch];
    [switchView setBackgroundColor:[UIColor clearColor]];
    [subScriptionView addSubview:switchView];
    
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(satelliteView.frame),SCREEN_WIDTH-5,1.0)];
    topBorder.backgroundColor = [COMMON Common_Light_BG_Color];
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [subScriptionView addSubview:topBorder];
    
    //PREMIUM VIEW
    UIView *premiumView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topBorder.frame)+5,SCREEN_WIDTH,satelliewViewHeight)];
    [premiumView setBackgroundColor:[UIColor clearColor]];
    
    UILabel * premiumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,premiumView.frame.size.width-10, satelliewViewLabelHeight)];
    premiumTitleLabel.text = @"Let's unify all Subscription services you have.";//@"Do you pay for any of these premium online services?";
    premiumTitleLabel.textColor = [UIColor whiteColor];
    premiumTitleLabel.font = [COMMON getResizeableFont:Roboto_Regular(titleFontSize)];
    premiumTitleLabel.textAlignment = NSTextAlignmentLeft;
    [premiumTitleLabel setBackgroundColor:[UIColor clearColor]];
    [premiumView addSubview:premiumTitleLabel];
    
    UILabel * premiumSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(premiumTitleLabel.frame),premiumView.frame.size.width-10, satelliewViewLabelHeight)];
    premiumSubLabel.text = @"Select any that apply.";
    premiumSubLabel.textColor = SKY_BLUE;
    premiumSubLabel.font = [COMMON getResizeableFont:Roboto_Regular(premiumSubLabelFontSize)];
    premiumSubLabel.textAlignment = NSTextAlignmentCenter;
    [premiumSubLabel setBackgroundColor:[UIColor clearColor]];
    [premiumView addSubview:premiumSubLabel];
    
    [subScriptionView addSubview:premiumView];
    
    [self setUpCollectionView:premiumView];
    
    //BOTTOM VIEW
    
    // subscriptionBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,subScriptionView.frame.size.height-140,subScriptionView.frame.size.width,70)];
    
    subscriptionBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_collectionView.frame),SCREEN_WIDTH,SCREEN_HEIGHT-(CGRectGetMaxY(premiumSubLabel.frame)+satelliewViewLabelHeight))];//SCREEN_HEIGHT-130
    
    [subscriptionBottomView setBackgroundColor:[UIColor clearColor]];
    
    [subScriptionView addSubview:subscriptionBottomView];
    
    CGFloat XPos = (SCREEN_WIDTH/2)-100;//160
    
    setBtn = [[UIButton alloc] initWithFrame:CGRectMake(XPos ,10,200, 50)];
    
    [setBtn setTitle:@"OK,I'M Done" forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [setBtn addTarget:self action:@selector(loadSubscriptionsCode) forControlEvents:UIControlEventTouchUpInside];
    [subscriptionBottomView addSubview:setBtn];
    
    
}

- (void) switchFunctionality {
//    NSMutableArray *tempArray1= [NSMutableArray new];
//    NSMutableDictionary * currentUserLoginDetails = [NSMutableDictionary new];
//    currentUserLoginDetails = [COMMON getLoginDetails];
//
//    if([currentUserLoginDetails count]!=0){
//        tempArray1 = [currentUserLoginDetails objectForKey:@"subscriptions"];
//    }
    //NSMutableArray *tempSubArray =
    
    for(id tempDict in currentSubscriptionArray){
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
    
    CGFloat transFormsize = 0.60;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        transFormsize = 0.90;

    freeSwitch.transform = CGAffineTransformMakeScale(transFormsize,transFormsize);

}
-(void)loadSubscriptionsCode {
    NSMutableArray *codeSelectedArray = [NSMutableArray new];
    [codeSelectedArray addObjectsFromArray:selectedSubscriptArray];
    subscriptionCode =@"";
     if(isCableSelected==YES){
         for(NSDictionary *dictTemp in currentSubscriptionArray) {
             NSString *codeString  = [dictTemp valueForKey:@"code"];
             NSString *imgUrl = [dictTemp objectForKey:@"image_url"];
             NSMutableDictionary *codeDict = [NSMutableDictionary new];
             if([codeString isEqualToString:@"CABLE"]) {
                 [codeDict setObject:codeString forKey:@"code"];
                 [codeDict setObject:imgUrl forKey:@"image_url"];
                 [codeSelectedArray addObject:codeDict];
             }
         }
     }
    for(NSDictionary *codeDict in codeSelectedArray) {
        if (subscriptionCode == nil || [subscriptionCode isEqualToString:@""])
            subscriptionCode = [codeDict valueForKey:@"code"];
        else{
            subscriptionCode = [NSString stringWithFormat:@"%@,%@", subscriptionCode, [codeDict valueForKey:@"code"]];
        }
    }
    [self setSubscriptionArrayBasedOnUserSelection:subscriptionCode];

    [self pushToNetworkView];
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
            Xpos = 20;
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
    collectionFrame.origin.x = 10;
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    collectionFrame.origin.y = CGRectGetMaxY(lastView.frame);
    collectionFrame.size.width = SCREEN_WIDTH-20;//(Xpos*2);
    collectionFrame.size.height = SCREEN_HEIGHT - (CGRectGetMaxY(lastView.frame)+130);//Height-50;
    
//    collectionScroll = [[UIScrollView alloc] initWithFrame:collectionFrame];
    _collectionView=[[UITableView alloc] initWithFrame:collectionFrame];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
//    [collectionScroll addSubview:_collectionView];
    
    [subScriptionView addSubview:_collectionView];

}

- (void)getCaurosalApi {
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getUserCaurosalSubsc:^(AFHTTPRequestOperation *request, id responseObjec) {
        NSLog(@"caurosal array-->%@",responseObjec);
        caurosalArray = [NSMutableArray new];

        NSArray *caurosalItems = responseObjec;
        NSLog(@"caurosal array-->%@",currentSubscriptionArray);
        for(NSDictionary *dict in caurosalItems) {
            NSMutableDictionary *tDict = [NSMutableDictionary new];
            tDict = [dict mutableCopy];
            NSArray *moviesArray = [tDict objectForKey:@"movies"];
            if([moviesArray count]!=0) {
                NSString *codeStr = [tDict objectForKey:@"code"];
                for(NSDictionary *dictTemp in currentSubscriptionArray) {
                    NSString *tempCode = [dictTemp objectForKey:@"code"];
                    if([tempCode isEqualToString:codeStr])
                        [tDict setObject:[dictTemp objectForKey:@"subscribed"] forKey:@"subscribed"];
                }
                [caurosalArray addObject:tDict];
            }
        }
        [_collectionView reloadData];
        [COMMON removeLoading];
    }];
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

#pragma mark - getTableData

-(void)getTableData :(NSInteger)currentIndex {
    
    [self.subScriptionIndicator setHidden:false];
    
    arrayHome = [[COMMON retrieveContentsFromFile:SELECTTVBOX_SUBSCRIPTIONS dataType:DataTypeArray] mutableCopy];
    
    if ([arrayHome count] == 0) {
            [[RabbitTVManager sharedManager]getSelectTvScriptionItems:^(AFHTTPRequestOperation * request, id responseObject) {
                arrayHome = responseObject;
                [self removeArrayValues];
                [self loadHomeDetails :currentIndex];
            }
            failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
                                                         }];
        
    }
    else {
         [self removeArrayValues];
        [self loadHomeDetails :currentIndex];
    }
}

-(void)removeArrayValues {
    
    NSMutableArray *tempArray1 = [[NSMutableArray alloc] init];
    tempArray1 = [arrayHome mutableCopy] ;
    for (int i=0;i<tempArray1.count;i++) {
        NSString *string = [[[tempArray valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string isEqualToString:@"Movies"]){
            [arrayHome removeObjectAtIndex:i];
        } else if([string isEqualToString:@"TV Shows"]){
            int j =i;
            j--;
            [arrayHome removeObjectAtIndex:j];
        }
        
    }
}

- (void) loadHomeDetails :(NSInteger)currentIndex {
    
    //arrayName = [[arrayHome valueForKey:@"name"]mutableCopy];
    
    arrayNetworkNames = [[arrayHome objectAtIndex:currentIndex] valueForKey:@"subcategories"];
    arrayTitle = [[arrayNetworkNames valueForKey:@"name"]mutableCopy];
    
    [self.subScriptionIndicator setHidden:false];
    [_subscriptionTable setHidden:NO];
//    self.subscriptionTable.dataSource = self;
//    self.subscriptionTable.delegate = self;
//    [_subscriptionTable reloadData];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - Table view data source
#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if(tableView==self.subscriptionTable) {
//        UIView *headerView;
//        NSString *strChannelName;
//        NSString *strHomeName = arrayTitle[section];
//        NSString *strTitleName = arrayTitle[section];
//        
//        if([strTitleName isEqualToString:@""]){
//            strChannelName = strHomeName;
//        }
//        else{
//            strChannelName = strTitleName;
//        }
//        
//        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[strChannelName dataUsingEncoding:NSUTF8StringEncoding]
//                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
//                                                         documentAttributes:nil
//                                                                      error:nil];
//        strChannelName = [attr string];
//        headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
//        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,headerView.frame.size.width-10,30)];
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        headerLabel.text = strChannelName;
//        [headerLabel setFont:[COMMON getResizeableFont:Roboto_Regular(17)]];
//        headerLabel.textColor=[UIColor whiteColor];
//        headerLabel.backgroundColor = [UIColor blackColor];
//        [headerView addSubview:headerLabel];
//        return headerView;
//    }
    //else
//        if (tableView == _collectionView) {
//        UIView *headerView;
//        NSString *strChannelName;
//        //NSMutableDictionary *dictItem =  appListArrayItems[section];
//       // NSString *strTitleName = dictItem[@"name"];
//        
////        if([strTitleName isEqualToString:@""]||strTitleName==nil||(NSString *)[NSNull null]==strTitleName){
////            strTitleName = @"";
////        }
//        
//        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[strChannelName dataUsingEncoding:NSUTF8StringEncoding]
//                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
//                                                         documentAttributes:nil
//                                                                      error:nil];
//        strChannelName = [attr string];
//        headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,50)];
//        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5,2,headerView.frame.size.width-10,30)];
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        headerLabel.text = [[[caurosalArray valueForKey:@"code"] objectAtIndex:section] capitalizedString];
//        [headerLabel setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
//        headerLabel.textColor=[UIColor whiteColor];//BORDER_BLUE;
//        headerView.backgroundColor = [UIColor clearColor];
//        [headerView addSubview:headerLabel];
//        return headerView;
//    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==_collectionView){
        return 0;
    }
    return 30.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_collectionView) {
        return [caurosalArray count];
    }
    return arrayTitle.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([self isDeviceIpad]==YES){
//        return 160.0;
//
//    }else{
//    if(tableView==_collectionView)
//        return 0.0;
//    else
        //return 160.0;
//    }
    
    return 190.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *appString;
    if(tableView==_collectionView) {
        appString = @"YES";
    }else
        appString = @"NO";
//    if(tableView==_subscriptionTable) {
    NSInteger myIndex = (101 + indexPath.section);
    
        
    NSString *CellIdentifier = [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",(long)myIndex];

    NKContainerCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (nil == cell) {
    cell = [[NKContainerCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appManagerStr :@"SUBSC"];
//        NSDictionary *cellData = [arrayNetworkNames objectAtIndex:[indexPath section]];
        NSDictionary *cellData = [caurosalArray objectAtIndex:[indexPath section]];
    NSMutableArray *dataArray = [NSMutableArray new];
//    [dataArray addObject:cellData];
    NSString *grayUrl = [cellData objectForKey:@"gray_image_url"];
    NSString *imgUrl = [cellData objectForKey:@"image_url"];
    
    BOOL isSubscribed  = [[cellData objectForKey:@"subscribed"]boolValue];
    
    NSString *subs =@"NO";
    if(isSubscribed==YES){
        subs=@"YES";
        
    }
    NSLog(@"subs -->%@",subs);
    
    //NSString *subs = [cellData objectForKey:@"subscribed"];
    NSString *code =[cellData objectForKey:@"code"];
    NSArray * dataArray1 = [cellData objectForKey:@"movies"];
    BOOL subscribed_BOOL = [[cellData valueForKey:@"subscribed"]boolValue];
    if(subscribed_BOOL==YES){
        NSMutableDictionary *codeDict = [NSMutableDictionary new];
        [codeDict setObject:code forKey:@"code"];
        [codeDict setObject:imgUrl forKey:@"image_url"];
        [selectedSubscriptArray addObject:codeDict];
        selectedSubscriptArray = [[self arrayByEliminatingDuplicatesMaintainingOrder:[selectedSubscriptArray copy]] mutableCopy];
    }

    for(NSDictionary *dictValue in dataArray1) {
        NSMutableDictionary *originalDict = [NSMutableDictionary new];
        originalDict = [dictValue mutableCopy];
        [originalDict setObject:grayUrl forKey:@"gray_url"];
        [originalDict setObject:imgUrl forKey:@"image_url"];
        [originalDict setObject:subs forKey:@"subscribed"];
        [originalDict setObject:code forKey:@"code"];
        [originalDict setObject:@"M" forKey:@"type"];
        [dataArray addObject:originalDict];
    }
        NSArray *BlockData = dataArray;
//        [cell setCollectionData:BlockData];
        if([BlockData count]!=0){
            [cell setCollectionImageData:BlockData currentViewStr:@"SubscriptionView"];
        }

    }
//    _subscriptionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
//    }
//    else {
//        static NSString *CellIdentifier = @"SubscriptTableViewCell";//Cell
//      SubscriptTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////        if(cell==nil){
//            cell = [[SubscriptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            NSDictionary *cellData = [caurosalArray objectAtIndex:[indexPath row]];
//            NSArray *moviesArr = [cellData objectForKey:@"movies"];
//            NSURL *imgUrl = [NSURL URLWithString:[cellData objectForKey:@"gray_image_url"] ];
////            [cell.appImage setImageWithURL:imgUrl ];
//    NSData *imageData = [NSData dataWithContentsOfURL:imgUrl];
//    UIImage *image = [UIImage imageWithData:imageData];
//    cell.appImage .image = image;
//            CGFloat xPos =0;
////            int i=0;
//            for(NSDictionary *dict in moviesArr) {
//                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0, 100, 150)];
//                NSURL *imgUrl1= [NSURL URLWithString:[dict objectForKey:@"image"] ];
////                [imageV setImageWithURL:imgUrl1];
//                NSData *imageData = [NSData dataWithContentsOfURL:imgUrl1];
//                UIImage *image = [UIImage imageWithData:imageData];
//                imageV .image = image;
//
//                [cell.mainScroll addSubview:imageV];
//                xPos = imageV.frame.size.width+5;
//            }
//
////        }
//        return cell;
//
//    }
    
}

#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromSubcriptionCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    
    NSLog(@"cellData%@-->",cellData);
    strCellSelectionId = cellData[@"id"];
    strCellSelectionName = cellData[@"name"];
    strCellSelectionType = cellData[@"type"];
    if([strCellSelectionType isEqualToString:@"N"]||[strCellSelectionType isEqualToString:@"L"]){
        [self pushToNetworkView];
    }
    else if([strCellSelectionType isEqualToString:@"M"]){
        isSeasonArrayExist=NO;
        [self loadNewShowDetailPage];
    }
    else if([strCellSelectionType isEqualToString:@"S"]){
        [self loadSeasonData];
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row;
    row = indexPath.row;
    
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    
    return nSubCellWidth;
    
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int) rowIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        if(isKidSelected==YES){
           return nSubCellHeight;
        }
        else{
            return nSubCellHeight;
        }
        
    }
    else
    {
        return 180;
    }
    
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;

        if([arrayItems count]!=0){
            
            nCount = nSubColumCount;
        }
        else{
            nCount = 1;
        }
        return nCount;
    
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return arrayItems.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    SubscriptionCell* cell = [grid dequeueReusableCell];
    
   
    
    if(cell == nil){
        cell = [[SubscriptionCell alloc] init];
    }
   
   
    int nIndex = rowIndex;

    nIndex= rowIndex * nSubColumCount + columnIndex;
    
    
    
    NSDictionary* dictItem = arrayItems[nIndex];
    NSString* strPosterUrl = dictItem[@"image"];
    NSString* strName = dictItem[@"name"];
    NSString* strNameCheck;
    
    if (strName == nil) {
        strNameCheck=@"";
    } else {
        strNameCheck= strName;
    }
    
    NSString* strPosterUrlCheck;
    
    if (strPosterUrl == nil) {
        strPosterUrlCheck=@"";
    } else {
        strPosterUrlCheck= strPosterUrl;
    }
    

//    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, cell.thumbnail.frame.size.width, cell.thumbnail.frame.size.height)];
//    [asyncImage setLoadingImage];
//    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrlCheck]
//                            type:AsyncImageResizeTypeCrop
//                         isCache:YES];
    NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
    
    
    if(isKidSelected == true){
        if(isKidsMenuMovie==YES){
            [cell.thumbnail setHidden:NO];
            [cell.kidsThumbnail setHidden:YES];
            [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
            [cell.label setTextAlignment:NSTextAlignmentCenter];
        }
        else{
            [cell.thumbnail setHidden:YES];
            [cell.kidsThumbnail setHidden:NO];
            [cell.label setTextAlignment:NSTextAlignmentLeft];
            [cell.kidsThumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        }
    }
    else{
        [cell.thumbnail setHidden:NO];
        [cell.kidsThumbnail setHidden:YES];
        [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        [cell.label setTextAlignment:NSTextAlignmentCenter];
    }
    [cell.label setTextAlignment:NSTextAlignmentCenter];
    
   // [cell.thumbnail addSubview:asyncImage];
    [cell.label setText:strNameCheck];
    
    [cell.label setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];

        return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    NSLog(@"%d, %d clicked", rowIndex, colIndex);
    
    int nIndex = nIndex= rowIndex * nSubColumCount + colIndex;

    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSDictionary* dictItem = arrayItems[nIndex];
    strCellSelectionId = dictItem[@"id"];
    strCellSelectionName = dictItem[@"name"];
    if(isKidSelected == true){
        [self loadSeasonData];
    }
    else{
        [self pushToNetworkView];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
}

#pragma mark -pushToNetworkView
-(void) pushToNetworkView{

    if([selectedSubscriptArray count]==0) {
        [AppCommon showSimpleAlertWithMessage:@"Please Select Atleast one element"];
    } else {
        SWRevealViewController *revealviewcontroller = self.revealViewController;
        [revealviewcontroller rightRevealToggle:nil];
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"payMovieNavController"];
        revealviewcontroller.frontViewController = navController;
        PayMovieViewController *mMovieVC = [[navController viewControllers] objectAtIndex:0];
        
        mMovieVC.isNetworksView =YES;
        mMovieVC.payShowStr = strCellSelectionName;
        mMovieVC.genreName = strCellSelectionName;
        //mMovieVC.isSubcriptionView=YES;//NO NEED FOR BACK
        mMovieVC.dropDownNSArray=arrayItems;
        mMovieVC.payHeaderLabelStr=@"My Subscriptions";
        mMovieVC.isPayPerView=NO;
        mMovieVC.isPushedFromSubscriptView=YES;
        if(selectedSubscriptArray!=nil)
              mMovieVC.subcsArray = [selectedSubscriptArray mutableCopy];
        [mMovieVC updateNetworkDetailData:[strCellSelectionId intValue]];
    }
}
#pragma mark -loadSeasonData
-(void) loadSeasonData{
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        if([arraySeasons count]==0){
            isSeasonArrayExist=NO;
            [self loadNewShowDetailPage];
            
        }
        else{
            isSeasonArrayExist=YES;
            [self loadNewShowDetailPage];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nID:[strCellSelectionId intValue]];
    
}
#pragma mark -loadNewShowDetailPage
-(void)loadNewShowDetailPage{
    
    NewShowDetailViewController * mShowVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail_ipad"];
    } else {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail"];
    }
    mShowVC.nID = strCellSelectionId;
    mShowVC.headerLabelStr = strCellSelectionName;
    if(isSeasonArrayExist){
        mShowVC.isEpisode=YES;
        mShowVC.showFullSeasonsArray = arraySeasons;
        [mShowVC setIfMovies:false];
    }
    else{
        mShowVC.isEpisode=NO;
        //        if([strCellSelectionType isEqualToString:@"M"]){
        //             [mShowVC setIfMovies:true];
        //        }
        //        else
        [mShowVC setIfMovies:false];
    }
    mShowVC.isToggledAll=YES;
   // mShowVC.genreName = strCellSelectionType;
    [self.navigationController pushViewController:mShowVC animated:YES];
    
}
-(void)pushToPlusController{
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
#pragma mark - Button Click
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
#pragma mark - orientationChanged
-(void) subOrientationChanged:(NSNotification *) note
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
-(void) rotateViews:(BOOL) bPortrait{
   
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_searchButton setHidden:NO];
    [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
     [self setUpSearchBarInNavigation];
    [self loadSubScriptionPage];
    [_subscriptionTable setHidden:YES];
    [self.tableView setHidden:YES];
    [self.subScriptionIndicator setHidden:true];
    [_subscriptionScrollView setHidden:YES];

    if(bPortrait){
        nSubColumCount = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nSubColumCount = 4;
//            if(isKidSelected==YES){
//                nSubColumCount = 3;
//            }
        }
//        else{
//            nSubColumCount = 2;
//            if(isKidSelected==YES){
//                nSubColumCount = 2;
//            }
//        }
          }
    else{
        nSubColumCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nSubColumCount = 5;
//            if(isKidSelected==YES){
//                nSubColumCount = 4;
//            }
            
        }
//        else{
//            nSubColumCount = 4;
//            if(isKidSelected==YES){
//                nSubColumCount = 3;
//            }
//            
//        }
        
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    nSubCellWidth = screenWidth / nSubColumCount;
    nSubCellHeight = screenWidth / nSubColumCount;
//    [self.tableView reloadData];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self removeSearchView];
    
}
-(void)removeSearchView{
    [self.view endEditing:YES];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [searchTextField resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

@end
