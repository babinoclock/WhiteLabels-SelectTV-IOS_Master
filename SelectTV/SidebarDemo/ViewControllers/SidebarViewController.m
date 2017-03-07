
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//


#import "SidebarViewController.h"
#import "RabbitTVManager.h"
#import "MenuCell.h"
#import "MovieViewController.h"
#import "SimpleTableCell.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "MovieViewController.h"
#import "CustomIOS7AlertView.h"
#import "SubScriptionsViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "AppConfig.h"
#import "HomeViewController.h"
#import "RadioViewController.h"
#import "PayMovieViewController.h"
#import "MyAccountViewController.h"
#import "MyInterestsViewController.h"
#import "GamesViewController.h"
#import "OverTheAirViewController.h"

@interface SidebarViewController () <CustomIOS7AlertViewDelegate,SWRevealViewControllerDelegate>{
    NSString * onDemandTvStr;
    //SWRevealViewController *revealviewcontroller;

    //MENU ORIENTATION
    CGFloat port_SideBarViewHeight;
    CGFloat land_SideBarViewHeight;
    
    NSMutableArray *homeIconArray;
    NSMutableArray * imageArray;
    
    NSString *selectedMenuName;
}

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController


UIView* tvView;
NSMutableArray* m_ArrayCategoriesLeft;
NSMutableArray* m_ArrayChannelsLeft;
NSMutableArray* m_ArrayDemandsLeft;
NSMutableArray* m_ArrayDemandsSubLeft;

CustomIOS7AlertView * channelView;

Boolean bCategoryLoaded = false;

BOOL bMovieShownLeft = false;
BOOL bShowShownLeft = false;
BOOL bKidShownLeft = false;


NSArray * appMenuData;

//NETWORKS
NSMutableArray* arrayNetworks;

//KIDS
NSMutableArray* arrayKidCategoriesLeft;
NSMutableArray* arrayKidMenuCategoriesLeft;
NSMutableArray* arrayKidItemsLeft;
NSMutableArray* arrayKidMenuItemsLeft;
BOOL bKidLoadedLeft = false;

UITableView* tableKidMenuLeft;
NSMutableArray * arrayMovies;
NSMutableArray * arrayShows;
NSMutableArray * arrayLives;

//Root Categories
NSMutableArray* rootCategories;

//Subscriptions

NSMutableArray* arraySubscriptionCategories;
NSMutableArray* arraysubscriptionMenuCategories;
NSMutableArray* arraySubscriptionItems;
NSMutableArray* arraySubscriptionMenuItems;
BOOL bSubscriptionLoaded = false;

NSMutableArray* arraySubscriptionNewMenuItems;
NSMutableArray* arraySubscriptionNewMenuName;


UITableView* tableSubscriptionMenu;

BOOL bAlertCategoryShown = false;
BOOL bAlertShown = false;
BOOL bSubscriptionShown = false;
BOOL bPayPerViewShown = false;
BOOL bKidsShown = false;
BOOL bOnDemandShown = false;
BOOL bOnDemandTvStrShown = false;

BOOL isHiddenView;
BOOL isTvShows;
BOOL isPayPerView;
BOOL isOnDemand;
BOOL isAppManagerMenuClicked;


- (void)viewDidLoad
{
  
    [super viewDidLoad];
    _isSibarAppManager = @"NO";
    
    [self staticSideBarArray];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    isHiddenView=YES;
    
    [self.activityIndicator setHidden:false];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self.tableMenu setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [self.activityIndicator setHidden:true];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SideBarOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
    [self setViews];
    [self loadData];
    
}

# pragma mark View will Appear

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];

    if ([appMenuData count] == 0){
        [self loadData];
    }
    
    [self.tableMenu reloadData];
    self.revealViewController.delegate = self;
//    [self.revealViewController tapGestureRecognizer];
//    [self.revealViewController panGestureRecognizer];
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    [self loadSubcriptionNewData];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
#pragma mark - Gesture Delegate Methods

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//NO
}

- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//NO
}
- (void)setViews
{
   // _freeCastlabel.text= @"FreeCast";
    [_freeCastlabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:16]];
    [_freeCastLogo setImage:[UIImage imageNamed:@"splash_logo"]];//toplogo//splash_logo.png
    if([self isDeviceIpad]==YES){
        [_fullView setBackgroundColor:[UIColor clearColor]];
        [_topView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]]];
        
        
        UIView *freeCastBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        // [freeCastBgView setBackgroundColor:[UIColor redColor]];
        [freeCastBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_bg"]]];
        [_LeftBgView addSubview:freeCastBgView];
        
    }
    else{
        [_topView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]]];
        [_fullView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_bg"]]];
        
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


- (void) loadData
{
    appMenuData = (NSArray *) [COMMON retrieveContentsFromFile:APP_MENU dataType:DataTypeArray];
    if (appMenuData == NULL) {
        [[RabbitTVManager sharedManager] getAppMenu:^(AFHTTPRequestOperation * request, id responseObject) {
            appMenuData = (NSArray *) responseObject;
            
            [self parseMenuData];
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }];
    } else {
        [self parseMenuData];
    }
    
    arrayNetworks = [COMMON retrieveContentsFromFile:ALL_NETWORK_LIST dataType:DataTypeArray];
    
    if (arrayNetworks == NULL) {
        [[RabbitTVManager sharedManager] getAllNetworks:^(AFHTTPRequestOperation * request , id responseObject) {
            arrayNetworks =  responseObject;
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }];
    }
    
//    arraySubscriptionCategories = [[COMMON retrieveContentsFromFile:SUBSCRIPTIONS_CATEGORIES dataType:DataTypeArray] mutableCopy];
//
//    if (arraySubscriptionCategories == NULL) {
//        [[RabbitTVManager sharedManager] getSubscriptionCategories:^(AFHTTPRequestOperation * request, id responseObject) {
//            arraySubscriptionCategories = [responseObject mutableCopy];
//            [self loadSubscriptionItems];
//        }];
//    } else {
//        [self loadSubscriptionItems];
//    }
    
    arrayKidCategoriesLeft = [[COMMON retrieveContentsFromFile:KIDS_CATEGORIES dataType:DataTypeArray] mutableCopy];
    [self removeKidsArrayValues]; //this helps to remove games array
    
    if (arrayKidCategoriesLeft == NULL) {
        [[RabbitTVManager sharedManager] getKidsCategories:^(AFHTTPRequestOperation * request , id responseObject) {
            arrayKidCategoriesLeft = [responseObject mutableCopy];
            [self removeKidsArrayValues];
            arrayKidCategoriesLeft = [self addTitleKeyInKidsLeftArray];

            [self loadKidItemsLeft];
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        }];
    } else {
       
        arrayKidCategoriesLeft = [self addTitleKeyInKidsLeftArray];
        [self loadKidItemsLeft];
    }
}
#pragma mark - removeKidsArrayValues
-(void)removeKidsArrayValues {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [arrayKidCategoriesLeft mutableCopy] ;
    for (int i=0;i<tempArray.count;i++) {
        NSString *string = [[[tempArray valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string isEqualToString:@"GAMES"]){
            [arrayKidCategoriesLeft removeObjectAtIndex:i];
        }
    }
}
#pragma mark - addTitleKeyInKidsLeftArray
-(id)addTitleKeyInKidsLeftArray{
    NSMutableArray *kidsTempArray=[NSMutableArray new];
    for(int j= 0; j < arrayKidCategoriesLeft.count; j++){
        NSMutableDictionary* dictItem = [[NSMutableDictionary alloc] initWithDictionary: arrayKidCategoriesLeft[j]];
        NSString *nameStr = dictItem[@"name"];
        dictItem[@"title"] = [NSString stringWithFormat:@"%@", nameStr];
        [kidsTempArray addObject:dictItem];
    }

    return [kidsTempArray mutableCopy];
}

- (void) loadKidItemsLeft
{
    arrayKidItemsLeft = [[NSMutableArray alloc] init];
    arrayKidMenuCategoriesLeft = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i =0; i < arrayKidCategoriesLeft.count; i++){
            NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:arrayKidCategoriesLeft[i]];
            
            NSString *strID = dictItem[@"id"];
            NSArray *arraySubCategoriesLeft = [self getKidSubCategories:[strID intValue]];
            
            dictItem[@"bParent"] = [NSNumber numberWithBool:true];
            dictItem[@"bOpened"] = [NSNumber numberWithBool:false];
            dictItem[@"index"] = [NSNumber numberWithInteger:i];
            
            [arrayKidMenuCategoriesLeft addObject:dictItem];
            
            if(arraySubCategoriesLeft != nil){
                for(int j= 0; j < arraySubCategoriesLeft.count; j++){
                    NSMutableDictionary* dictItem = [[NSMutableDictionary alloc] initWithDictionary: arraySubCategoriesLeft[j]];
                    dictItem[@"bParent"] = [NSNumber numberWithBool:false];
                    dictItem[@"parentId"] = [NSString stringWithFormat:@"%d", i];
                    [arrayKidItemsLeft addObject:dictItem];
                }
            }
        }
        
        bKidLoadedLeft = true;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void) makeJSONKidMenuItemsLeft
{
    arrayKidMenuItemsLeft = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < arrayKidMenuCategoriesLeft.count; i++){
        NSMutableDictionary *dictItem = arrayKidMenuCategoriesLeft[i];
        BOOL bOpened = [dictItem[@"bOpened"] boolValue];
        
        [arrayKidMenuItemsLeft addObject:dictItem];
        
        if(bOpened == true){
            for(int j =0; j < arrayKidItemsLeft.count; j++){
                NSMutableDictionary * dictKidItem = arrayKidItemsLeft[j];
                NSString *strParentID = dictKidItem[@"parentId"];
                
                if([strParentID intValue] == i){
                    [arrayKidMenuItemsLeft addObject:dictKidItem];
                }
            }
        }
    }
}
NSArray* arrayItemsLeft = nil;


- (NSArray *) getKidSubCategories:(int) nID
{
    arrayItemsLeft = nil;
    
    NSString *strSubcategoryFile = [NSString stringWithFormat:KIDS_SUB_CATEGORIES,nID];
    arrayItemsLeft = [[COMMON retrieveContentsFromFile:strSubcategoryFile dataType:DataTypeArray] mutableCopy];
    if (arrayItemsLeft == NULL) {
        
        [[RabbitTVManager sharedManager] getKidSubCategories:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayItemsLeft = (NSArray* ) responseObject;
            
        } nID:nID];
        
    }

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//        });
//    });
    
//    while(!arrayItemsLeft){
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
    
    return arrayItemsLeft;
}

- (void) loadSubscriptionItems
{
    arraySubscriptionItems = [[NSMutableArray alloc] init];
    arraysubscriptionMenuCategories = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(int i =0; i < arraySubscriptionCategories.count; i++){
            NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:arraySubscriptionCategories[i]];
            
            NSString *strID = dictItem[@"id"];
            NSArray *arraySubCategories = [self getSubscriptionSubCategories:[strID intValue]];
            
            dictItem[@"bParent"] = [NSNumber numberWithBool:true];
            dictItem[@"bOpened"] = [NSNumber numberWithBool:false];
            dictItem[@"index"] = [NSNumber numberWithInteger:i];
            
            [arraysubscriptionMenuCategories addObject:dictItem];
            
            if(arraySubCategories != nil){
                for(int j= 0; j < arraySubCategories.count; j++){
                    NSMutableDictionary* dictItem = [[NSMutableDictionary alloc] initWithDictionary: arraySubCategories[j]];
                    dictItem[@"bParent"] = [NSNumber numberWithBool:false];
                    dictItem[@"parentId"] = [NSString stringWithFormat:@"%d", i];
                    [arraySubscriptionItems addObject:dictItem];
                }
            }
        }
        
        bSubscriptionLoaded = true;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}
NSArray* arraySubItems = nil;

- (NSArray *) getSubscriptionSubCategories:(int) nID
{
    arraySubItems = nil;
    
    NSString *strSubcategoryFile = [NSString stringWithFormat:SUBSCRIPTIONS_SUB_CATEGORIES,nID];
    arraySubItems = [[COMMON retrieveContentsFromFile:strSubcategoryFile dataType:DataTypeArray] mutableCopy];
    if (arraySubItems == NULL) {
        
        [[RabbitTVManager sharedManager] getSubscriptionSubCategories:^(AFHTTPRequestOperation * request, id responseObject) {
            arraySubItems = (NSArray* ) responseObject;
            
        } nID:nID];
        
    }

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//        });
//    });
    
//    while(!arraySubItems){
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
    
    return arraySubItems;
}

- (void) makeJSONSubscriptionMenuItems
{
    arraySubscriptionMenuItems = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < arraysubscriptionMenuCategories.count; i++){
        NSMutableDictionary *dictItem = arraysubscriptionMenuCategories[i];
        BOOL bOpened = [dictItem[@"bOpened"] boolValue];
        
        [arraySubscriptionMenuItems addObject:dictItem];
        
        if(bOpened == true){
            for(int j =0; j < arraySubscriptionItems.count; j++){
                NSMutableDictionary * dictKidItem = arraySubscriptionItems[j];
                NSString *strParentID = dictKidItem[@"parentId"];
                
                if([strParentID intValue] == i){
                    [arraySubscriptionMenuItems addObject:dictKidItem];
                }
            }
        }
    }
}

-(void)loadSubcriptionNewData{
    
    
    arraySubscriptionNewMenuItems = [[COMMON retrieveContentsFromFile:SELECTTVBOX_SUBSCRIPTIONS dataType:DataTypeArray] mutableCopy];
    
    if ([arraySubscriptionNewMenuItems count] == 0) {
        [[RabbitTVManager sharedManager]getSelectTvScriptionItems:^(AFHTTPRequestOperation * request, id responseObject) {
            
            arraySubscriptionNewMenuItems = responseObject;
            [self removeArrayValues];

            arraySubscriptionNewMenuName = [[arraySubscriptionNewMenuItems valueForKey:@"name"]mutableCopy];

            
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
            
        }];
        
    }
    else {
        [self removeArrayValues];

       arraySubscriptionNewMenuName = [[arraySubscriptionNewMenuItems valueForKey:@"name"]mutableCopy];

    }

}

-(void)removeArrayValues {
    
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [arraySubscriptionNewMenuItems mutableCopy] ;
    for (int i=0;i<[tempArray count];i++) {
        NSString *string = [[[[tempArray mutableCopy] valueForKey:@"name"]objectAtIndex:i] mutableCopy];
        if([string isEqualToString:@"Movies"]){
            [[arraySubscriptionNewMenuItems mutableCopy] removeObjectAtIndex:i];
        } else if([string isEqualToString:@"TV Shows"]){
               int j =i;
            j--;
            [[arraySubscriptionNewMenuItems mutableCopy] removeObjectAtIndex:j];
        }

    }
}

- (void) parseMenuData
{
    if (appMenuData == nil)
        return;
    
    for(int i = 0; i < appMenuData.count; i++){
        NSDictionary *dict = appMenuData[i];
        
        if(i == 0){
            arrayLives = dict[@"child"];
        }else if(i == 1){
            arrayShows = dict[@"child"];
        }else if(i == 2){
            arrayMovies = dict[@"child"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//NOT CALLED
- (void) showFirstView
{
    NSDictionary *dictItem = m_ArrayCategoriesLeft[0];
    NSString* strID = dictItem[@"id"];
    
    @try {
        [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
            
            m_ArrayChannelsLeft = (NSMutableArray *)responseObject;
            NSDictionary *dictChannel = m_ArrayChannelsLeft[0];
            NSString* strChannelID;
            NSString* strTitle;
           
            strChannelID = [dictChannel[@"id"] stringValue];
            strTitle = dictChannel[@"name"];
            
        } catID:[strID intValue]];
    }
    @catch (NSException *exception) {
        [self showError:@"Exception when get Channel in SidebarViewController"];
    }
    @finally {
        
    }
    
    
}

- (void) showError:(NSString*)error{
    
    UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark - staticSideBarArray
-(void)staticSideBarArray
{
    if([COMMON isSpanishLanguage]==YES){
        if([[NSUserDefaults standardUserDefaults] valueForKey:SIDE_MENU_TRANSLATED_WORDS]==nil){
            homeIconArray = [NSMutableArray arrayWithObjects:@"Home",@"Channels",@"On Demand",@"Pay Per View",@"My Subscriptions",@"Over the Air",@"Radio Stations",@"App Manager",@"My Interests",@"My Account",@"Games",@"More",@"Logout",nil];
        }
        else
        {
            homeIconArray =[[[NSUserDefaults standardUserDefaults] valueForKey:SIDE_MENU_TRANSLATED_WORDS] mutableCopy];
        }
    }
    else{
        homeIconArray = [NSMutableArray arrayWithObjects:@"Home",@"Channels",@"On Demand",@"Pay Per View",@"MY Subscriptions",@"Over the Air",@"Radio Stations",@"App Manager",@"My Interests",@"My Account",@"Games",@"More",@"Logout",nil];
    }    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // return 60;
    NSInteger nCount = 0;
    
    if(tableView.tag == 100)
    {
        nCount = 60;
    }
    else {
        nCount = 40;
    }
    return nCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSInteger nCount = 0;
    
    if(tableView.tag == 100)
    {
        nCount = homeIconArray.count;
        
    }
    else if(tableView.tag == 101){
        nCount = m_ArrayChannelsLeft.count;
    }
    else if(tableView.tag == 103){
        nCount = arraySubscriptionNewMenuName.count;//arraySubscriptionMenuItems.count;
    }
    else if(tableView.tag == 104){
        nCount = arrayKidMenuItemsLeft.count;
    }
    
    
    
    return nCount;
    //  return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag == 100){
        
        
        
        static NSString *CellIdentifier = @"MenuCell";
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSInteger row = indexPath.row;
        
        if (nil == cell)
        {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        
        NSString *text = nil;
        if (row == 0)
        {
            text = @"Home";
            cell.cellImage.image=[UIImage imageNamed:@"homeIcon"];
        }
        else if (row == 1)
        {
            text = @"Channels";
            cell.cellImage.image=[UIImage imageNamed:@"profileIcon"];
        }
        else if (row == 2)
        {
            text = @"On Demand";
            cell.cellImage.image=[UIImage imageNamed:@"groupIcon"];
        }
//        else if (row == 3)
//        {
//            text = @"Kids";
//            cell.cellImage.image=[UIImage imageNamed:@"emailIcon"];
//        }
        else if (row == 3)
        {
            text = @"Pay Per View";
            cell.cellImage.image=[UIImage imageNamed:@"settingIcon"];
        }
        else if (row == 4)
        {
            text = @"My Subscriptions";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 5) {
            text = @"Over The Air";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 6)
        {
            text = @"Radio Stations";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 7)
        {
            text = @"App Manager";
            cell.cellImage.image=[UIImage imageNamed:@"shareIcon"];
        }
        else if (row == 8)
        {
            text = @"My Interests";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 9)
        {
            text = @"My Account";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        
        else if (row == 10)
        {
            text = @"Games";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 11)
        {
            text = @"More";
            cell.cellImage.image=[UIImage imageNamed:@"faqIcon"];
        }
        else if (row == 12)
        {
            text = @"Logout";
            cell.cellImage.image=[UIImage imageNamed:@"logoutIcon"];
        }
        selectedMenuName = homeIconArray[indexPath.row];
        
        text = homeIconArray[indexPath.row];
        cell.textMenuItem.text = NSLocalizedString(text,nil );
        cell.textMenuItem.textColor = [UIColor whiteColor];
        [cell.textMenuItem setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
        [cell.viewContent setBackgroundColor:[UIColor clearColor]];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
        
    }else if(tableView.tag == 101){
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        NSDictionary *dictItem = m_ArrayChannelsLeft[indexPath.row];
        NSString *strChannelName = dictItem[@"name"];
        [cell.labelText setText:strChannelName];
        cell.labelText.textColor = [UIColor blackColor];
        [cell.labelText setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
        
        
        return cell;
    }
    else if(tableView.tag == 103){
        static NSString *simpleTableIdentifier;
        simpleTableIdentifier = @"SimpleTableCell";
        //SimpleTableCell *cell = (SimpleTableCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        //if(cell == nil)
        SimpleTableCell *cell;
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //NSDictionary *dictItem = arraySubscriptionMenuItems[indexPath.row];
        //NSString *strChannelName = dictItem[@"name"];
        NSString *strChannelName = arraySubscriptionNewMenuName[indexPath.row];
        
        //BOOL bParent = [dictItem[@"bParent"] boolValue];
        [cell.labelText setText:strChannelName];
        cell.labelText.textColor = [UIColor blackColor];
        [cell.labelText setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
        
        
        
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        return cell;
        
        
    }
    else if(tableView.tag == 104){
        static NSString *simpleTableIdentifier;
        simpleTableIdentifier = @"SimpleTableCell";
       
        SimpleTableCell *cell;
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDictionary *dictItem = arrayKidMenuItemsLeft[indexPath.row];
        NSString *strChannelName = dictItem[@"title"];//@"name"
        BOOL bParent = [dictItem[@"bParent"] boolValue];
        strChannelName = [self stringByStrippingHTML:strChannelName];
        
        [cell.labelText setText:strChannelName];
        [cell.labelTextSecondary setText:strChannelName];
        [cell.labelText setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
        [cell.labelTextSecondary setFont:[COMMON getResizeableFont:Roboto_Light(15)]];
        
        if(bParent == true){
            [cell.labelText setTextColor:[UIColor blackColor]];
            [cell.labelTextSecondary setHidden:true];
            [cell.labelText setHidden:false];
        }else{
            [cell.labelTextSecondary setTextColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f]];
            [cell.labelTextSecondary setHidden:false];
            [cell.labelText setHidden:true];
        }
        return cell;
        
    }
    [_tableMenu setSeparatorColor:[UIColor colorWithRed:49.0/255.0f green:73.0/255.0f blue:97.0/255.0f alpha:1]];
    _tableMenu.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return nil;
    
}
#pragma mark - stringByStrippingHTML
-(id)stringByStrippingHTML : (NSString *)titleText{
    NSRange range;
    //NSString *s;// = [[self copy] autorelease];
    while ((range = [titleText rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        titleText = [titleText stringByReplacingCharactersInRange:range withString:@""];
    return titleText;
}
#pragma mark - didSelectRowAtIndexPath
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 100){
        
        NSInteger row = indexPath.row;
        
        if (row == 0)
        {
            [self homePageSelected];
            
        }
        else if (row == 1)
        {
            [self channelsPageSelected];
            
        }
        else if (row == 2)
        {
            _isSibarAppManager =@"NO";
            [COMMON isSideBarAppManager:_isSibarAppManager];
            isAppManagerMenuClicked =NO;
            [self onDemandPageSelected];
        }
//        else if (row == 3)
//        {
//            //KIDS
//            [self showKidListLeft];
//        }
        else if (row == 3)
        {
            //PAY PER VIEW
            isPayPerView=YES;
            isTvShows=NO;
            [self payPerViewListSelected]; //[self showMoviesList];
        }
        else if (row == 4)
        {
            //SUBSCRIPTIONS
            //[self showSubscriptionList];
            NSString* strID =@"";
            NSInteger currentInteger = indexPath.row;
            SWRevealViewController *revealviewcontroller = self.revealViewController;
            [revealviewcontroller revealToggle:nil];
            
            UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"subnavcontroller"];
            revealviewcontroller.frontViewController = navController;
            
            SubScriptionsViewController *mSubVC = [[navController viewControllers] objectAtIndex:0];
            [[AppDelegate sharedAppDelegate] setVcCurrentID:@"subnavcontroller"];
            mSubVC.isKidsMenu = NO;
            mSubVC.isSide = YES;
            [mSubVC updateData:strID bKid:false :currentInteger];
            
            
            [channelView close];
            channelView = nil;
            
            bSubscriptionShown = false;
        }
        else if (row == 5) {
            [self pushToOverTheAirScreen];
        }
        else if (row == 6)
        {
            [self radioPageSelected];
            
        }
        else if (row == 7)
        {
            bPayPerViewShown =false;
            bSubscriptionShown =false;
            bKidsShown = false;
            _isSibarAppManager =@"YES";
            [COMMON isSideBarAppManager:_isSibarAppManager];
            isAppManagerMenuClicked =YES;
            [self onDemandPageSelected];
            //APP MANAGER
         }
        else if (row == 8)
        {
            bPayPerViewShown =false;
            bSubscriptionShown =false;
            bKidsShown = false;
            [self myInterestsSelected];
        }
        else if (row == 9)
        {
            bPayPerViewShown =false;
            bSubscriptionShown =false;
            bKidsShown = false;
            [self myAccountSelected];
        }
        else if (row == 10)
        {
           [self pushToMyGamesView:NO];
        }
        else if (row == 11)
        {
            [self pushToMyGamesView:YES];
        }
        else if (row == 12)
        {
            //LOGOUT
            bPayPerViewShown =false;
            bSubscriptionShown =false;
            bKidsShown = false;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self logoutFunction];
            //exit(0);
        }
            }
    else if(tableView.tag == 101){
        
        //SUBSCRIPTIONS
        [channelView close];
        channelView = nil;
        bAlertShown = false;
        
        //do upating stream table
        NSDictionary *dictItem = m_ArrayChannelsLeft[indexPath.row];
        [self mainSelected:dictItem];
        
        
        
    }
    else if(tableView.tag == 103){
        //SUBSCRIPTIONS

        NSString* strID =@"";
        NSInteger currentInteger = indexPath.row;
        SWRevealViewController *revealviewcontroller = self.revealViewController;
        [revealviewcontroller revealToggle:nil];
        
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"subnavcontroller"];
        revealviewcontroller.frontViewController = navController;
        
        SubScriptionsViewController *mSubVC = [[navController viewControllers] objectAtIndex:0];
        [[AppDelegate sharedAppDelegate] setVcCurrentID:@"subnavcontroller"];
        mSubVC.isKidsMenu = NO;
        [mSubVC updateData:strID bKid:false :currentInteger];
        
        
        [channelView close];
        channelView = nil;
        
        bSubscriptionShown = false;
        

    }
    else if(tableView.tag == 104){
        //KIDS
        NSMutableDictionary* dictMenuItem = arrayKidMenuItemsLeft[indexPath.row];
        BOOL bParent = [dictMenuItem[@"bParent"] boolValue];
        
        if(bParent == true){
            int nIndex = [dictMenuItem[@"index"] intValue];
            NSMutableDictionary* dictCatItem = arrayKidMenuCategoriesLeft[nIndex];
            
            BOOL bOpened = [dictCatItem[@"bOpened"] boolValue];
            bOpened = !bOpened;
            
            dictCatItem[@"bOpened"] = [NSNumber numberWithBool:bOpened];
            
            [self makeJSONKidMenuItemsLeft];
            [tableKidMenuLeft reloadData];
        }else{
            NSDictionary *dictItem = (NSDictionary *) arrayKidMenuItemsLeft[indexPath.row];
            NSString* strID = dictItem[@"id"];
            NSString* titleStr = dictItem[@"title"];
            BOOL parentId = [dictItem[@"parentId"] boolValue];
            
            if ((NSString *)[NSNull null] == titleStr || titleStr == nil) {
                titleStr=@"";
            }
            NSInteger currentInteger = indexPath.row;
            SWRevealViewController *revealviewcontroller = self.revealViewController;
            [revealviewcontroller revealToggle:nil];
            
            UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"subnavcontroller"];
            revealviewcontroller.frontViewController = navController;
            
            SubScriptionsViewController *mSubVC = [[navController viewControllers] objectAtIndex:0];
            [[AppDelegate sharedAppDelegate] setVcCurrentID:@"subnavcontroller"];
            mSubVC.isKid= @"KIDS";
            if(parentId==true){
                 mSubVC.isKidsMenuMovie =YES;
            }
             else
                mSubVC.isKidsMenuMovie =NO;
               
            mSubVC.isKidsMenu = YES;
            [mSubVC updateData:strID bKid:true :currentInteger];
            
            //[channelView dismissWithClickedButtonIndex:0 animated:YES];
            [channelView close];
            bKidShownLeft = false;
            bKidsShown = false;
            
        }
        
    }
    
}
#pragma mark - isTokenExpired
-(void)logoutFunction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [COMMON removeLoginDetails];
    [COMMON removeLoading];
    [self pushToLoginScreen];
}

#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    
    
    // get the view controller you want to push to properly.
    // in this case, I get it from Main.storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [navController setViewControllers: @[vc] animated:NO];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];
    
    

    
//    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//    LoginViewController * LoginVC = nil;
//    LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    [self.navigationController pushViewController:LoginVC animated:YES];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//    self.window.rootViewController = [storyboard instantiateInitialViewController];
//    [self.window makeKeyAndVisible];
}


#pragma mark - homePageSelected
-(void) homePageSelected{
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"homeNavController"];
    revealviewcontroller.frontViewController = navController;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HomeViewController *HomeViewController;
    HomeViewController = [[navController viewControllers] objectAtIndex:0];
}
#pragma mark - channelsPageSelected
-(void) channelsPageSelected{
    
    
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    //CHANNELS
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    
    //do upating stream table
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc]init];
    [dictItem setObject:@"145" forKey:@"id"];
    [dictItem setObject:@"Channels" forKey:@"name"];
    NSString* strID = @"145";//@"4760";//@"328";
    NSString* strTitle = @"Channels";
    if(![[[AppDelegate sharedAppDelegate] vcCurrentID] isEqualToString:@"mainNavController"])
    {
        UINavigationController *navMainController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        revealviewcontroller.frontViewController = navMainController;
        
        MainViewController* mainVC = [navMainController.viewControllers objectAtIndex:0];
        mainVC.youtubeID = strID;
        mainVC.youtubeTitle =strTitle;
        // mainVC.bFullScreen = false;
        //  [mainVC updateChannelData:dictItem];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"portrait"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatestream" object:dictItem];
    }
    
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
}

#pragma mark - onDemandPageSelected
-(void) onDemandPageSelected{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ENTER_FOREGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    //DEMAND
    //[self onDemandList];
    //NSString* strID = @"1";//150
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"movieNavController"];
    
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"movieNavController"];
    
    revealviewcontroller.frontViewController = navController;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    MovieViewController *mMovieVC = [[navController viewControllers] objectAtIndex:0];
    mMovieVC.headerLabelStr=@"On Demand";
    //mMovieVC.tvShowStr = @"Action";
    mMovieVC.dropDownTvShowArray= arrayShows;
    mMovieVC.dropDownTvNetworkArray= arrayNetworks;
    mMovieVC.dropDownNSArray= arrayMovies;
    mMovieVC.isLoadIcon= NO;
    if(isAppManagerMenuClicked==YES){
        mMovieVC.isAppManagerMenu = YES;
    }
    else{
        mMovieVC.isAppManagerMenu = NO;
        //[mMovieVC updateShowData:[strID intValue]];
        [mMovieVC loadSliderCarouselScreen];
    }
    
    mMovieVC.isPayPerView=NO;
    isTvShows=NO;

}
#pragma mark - radioPageSelected
-(void)radioPageSelected{
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"radioNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"radioNavController"];
    revealviewcontroller.frontViewController = navController;
    RadioViewController *radioNavController;
    radioNavController= [[navController viewControllers] objectAtIndex:0];
}
#pragma mark - subscriptionListSelected
-(void)mainSelected:(NSDictionary*)dictItem{
    NSString* strID = dictItem[@"id"];
    NSString* strTitle = dictItem[@"name"];
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    if(![[[AppDelegate sharedAppDelegate] vcCurrentID] isEqualToString:@"mainNavController"])
    {
        
        UINavigationController *navMainController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        revealviewcontroller.frontViewController = navMainController;
        
        MainViewController* mainVC = [navMainController.viewControllers objectAtIndex:0];
        mainVC.youtubeID = strID;
        mainVC.youtubeTitle =strTitle;
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"udpatestream" object:dictItem];
    }
    
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
}
#pragma mark - payPerViewListSelected
-(void)payPerViewListSelected{
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"payMovieNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"payMovieNavController"];
    revealviewcontroller.frontViewController = navController;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    PayMovieViewController  *mMovieVC = [[navController viewControllers] objectAtIndex:0];
    mMovieVC.dropDownNSArray=arrayMovies;
    mMovieVC.payHeaderLabelStr=@"Pay Per View";
    mMovieVC.payShowStr = @"Movies";
    mMovieVC.isPayPerView=YES;
    [mMovieVC loadSliderCarouselScreen];
    //[mMovieVC updateData:[strID intValue] status:4];
    isPayPerView=NO;
}
#pragma mark - myAccountSelected
-(void)myAccountSelected{
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"myAccountNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"myAccountNavController"];
    revealviewcontroller.frontViewController = navController;
    MyAccountViewController *myAccountNavController;
    myAccountNavController= [[navController viewControllers] objectAtIndex:0];
    
}
#pragma mark - myInterestsSelected
-(void)myInterestsSelected{
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    bKidsShown = false;
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"myInterestsNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"myInterestsNavController"];
    revealviewcontroller.frontViewController = navController;
    MyInterestsViewController *myInterestsNavController;
    myInterestsNavController= [[navController viewControllers] objectAtIndex:0];
    myInterestsNavController.movieGenreArray = arrayMovies;
    myInterestsNavController.networkGenreArray = arrayNetworks;
}

#pragma mark - pushToMyGamesView
-(void)pushToMyGamesView:(BOOL)currentBool{
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"gamesNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"gamesNavController"];
    revealviewcontroller.frontViewController = navController;
    GamesViewController *gamesVC;
    gamesVC= [[navController viewControllers] objectAtIndex:0];
    gamesVC.isMoreView = currentBool;
    if(currentBool==YES){
        [gamesVC getMoreDataList];
    }    
}

#pragma mark - pushToOverTheAirScreen
-(void)pushToOverTheAirScreen{
//        SWRevealViewController *revealviewcontroller = self.revealViewController;
//        [revealviewcontroller revealToggle:nil];
//        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"overTheAirNavController"];
//        [[AppDelegate sharedAppDelegate] setVcCurrentID:@"overTheAirNavController"];
//        revealviewcontroller.frontViewController = navController;
//        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
//        OverTheAirViewController *OverTheAirViewController;
//        OverTheAirViewController = [[navController viewControllers] objectAtIndex:0];
    
    
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller revealToggle:nil];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"overTheAirNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"overTheAirNavController"];
    revealviewcontroller.frontViewController = navController;
    MyInterestsViewController *myInterestsNavController;
    myInterestsNavController= [[navController viewControllers] objectAtIndex:0];

    
//    OverTheAirViewController * OverTheAirViewController ;
//    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"overTheAirNavController"];
////      OverTheAirViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OverTheAirViewController"];
//    [self.navigationController pushViewController:navController animated:YES];
}


#pragma mark - TABLE DESIGN
UITableView* tableChannelList;
UIView * tvShowView;
UITableView* tableMovieList;
UITableView* tableSubscriptionList;
UILabel* tvLabel;
UILabel* labelTitle;
UILabel* labelTitleline;


#pragma mark - showCategoryList
- (void) showCategoryList:(id) categoryData
{
    
    m_ArrayCategoriesLeft = (NSMutableArray *) categoryData;
    
    UIDevice* device = [UIDevice currentDevice];
    self.menuVeiw = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil] objectAtIndex:0];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        
        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
        [self.menuVeiw setFrame:CGRectMake(0, 0, 280, 250)];
        
        
    }else{
        
        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 450)];
        [self.menuVeiw setFrame:CGRectMake(0, 0, 280, 450)];
        
    }
    
    self.menuVeiw.delegate =self;
    [self.menuVeiw initWithCategories:m_ArrayCategoriesLeft];
    
    [channelView setContainerView:self.menuVeiw];
    [channelView show];
    
    bAlertCategoryShown = true;
    
}

-(void)showChanelList:(id)chanelList
{
    if(chanelList==nil || [chanelList count] == 0)
    {
        return;
    }else{
        m_ArrayChannelsLeft = (NSMutableArray*)chanelList;
        
    }
    UIDevice* device = [UIDevice currentDevice];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
        
    }else{
        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 450)];
        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 450)];
        
    }
    tableChannelList.tag = 101;
    // tableChannelList.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    tableChannelList.backgroundColor = [UIColor whiteColor];
    
    //[av addSubview:tableView];
    channelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    
    [channelView setContainerView:tableChannelList];
    [channelView show];
    
    bAlertShown = true;
    
}


- (void) showKidListLeft
{
    /*if(arrayKidMenuCategories != nil && arrayKidMenuCategories.count > 0 && arrayKidItems != nil && arrayKidItems.count >0)
     {
     
     }else{
     return;
     }*/
    if(!bKidLoadedLeft) return;
   // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self makeJSONKidMenuItemsLeft];
    m_ArrayChannelsLeft = (NSMutableArray *) arrayKidMenuItemsLeft;
    
    [self loadTableChannnedlList];
    
    tableChannelList.tag = 104;
    
    [tvLabel setText:@"KIDS"];
    
    
    [labelTitle setText:@"Genre"];
    
    [tvShowView addSubview:tvLabel];
    [tvShowView addSubview:labelTitle];
    [tvShowView addSubview:labelTitleline];
    tableKidMenuLeft = tableChannelList;
    [tvShowView addSubview:tableKidMenuLeft];
    [channelView setContainerView:tvShowView];
    [channelView show];
    
    //[channelView setValue:tableView forKey:@"accessoryView"];
    // [channelView setContainerView:tableChannelList];
    
    bKidShownLeft = true;
    bKidsShown = true;
    bPayPerViewShown =false;
    bSubscriptionShown =false;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}




-(void) onRentCancel:(id)sender
{
    NSLog(@"sender%@",sender);
    [channelView close];
    [tvView setHidden:YES];
    isHiddenView=YES;
    
}
-(void) gentre:(id)sender
{
    //[self showMoviesList];
    
}
- (void) executeTVNetworks

{
    if(arrayNetworks == nil)
        return;
    
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    [revealviewcontroller rightRevealToggle:nil];
    
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"movieNavController"];
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"movieNavController"];
    revealviewcontroller.frontViewController = navController;
    
    MovieViewController *mMovieVC = [[navController viewControllers] objectAtIndex:0];
    mMovieVC.tvShowStr = @"TV Networks";
    [mMovieVC updateNetworkData:arrayNetworks];
    
}


- (void) showSubscriptionList
{
    
   // if(!bSubscriptionLoaded) return;
    //[self makeJSONSubscriptionMenuItems];
    
    
    if(!arraySubscriptionNewMenuItems) return;
    
    //arraySubscriptionNewMenuName =  arraySubscriptionNewMenuName;
    
    [self loadTableChannnedlList];
    
    tableChannelList.tag = 103;
    [tvLabel setText:@"SubScriptions"];
    
    [labelTitle setText:@"Genre"];
    
    
    [tvShowView addSubview:tvLabel];
    [tvShowView addSubview:labelTitle];
    [tvShowView addSubview:labelTitleline];
    [tvShowView addSubview:tableChannelList];
    
    tableSubscriptionMenu = tableChannelList;
    [tvShowView addSubview:tableChannelList];
    
    [channelView setContainerView:tvShowView];
    [channelView show];
    
    
    bPayPerViewShown =false;
    bSubscriptionShown =true;
    bKidsShown = false;
    
}
-(void)loadTableChannnedlList{
    UIDevice* device = [UIDevice currentDevice];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-280, screenHeight-130)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, tvShowView.frame.size.width, tvShowView.frame.size.height-60)];
        }
        //IPAD
        else{
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-440, screenHeight-340)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, tvShowView.frame.size.width, tvShowView.frame.size.height-60)];

        }
        
    }else{
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
             tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-50, screenHeight-160)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, tvShowView.frame.size.width, tvShowView.frame.size.height-60)];
        }
        //IPAD
        else{
            
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
            tvShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-260, screenHeight-340)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60,tvShowView.frame.size.width, tvShowView.frame.size.height-60)];
        }
    }
    tableChannelList.backgroundColor = [UIColor whiteColor];
    channelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    tvLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5,tvShowView.frame.size.width, 50)];
    [tvLabel setTextColor:[UIColor blackColor]];
    [tvLabel setFont:[COMMON getResizeableFont:Roboto_Light(14)]];
    [tvLabel setTextAlignment:NSTextAlignmentCenter];
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,tvShowView.frame.size.width-100, 50)];
    [labelTitle setTextColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    [labelTitle setFont:[COMMON getResizeableFont:Roboto_Light(14)]];
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    labelTitleline = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, tvShowView.frame.size.width, 2)];
    [labelTitleline setBackgroundColor:[UIColor colorWithRed:103/255.0f green:200/255.0f blue:246/255.0f alpha:1.0f]];
    [tvShowView setBackgroundColor : [UIColor whiteColor]];
}

#pragma mark - Orientation Change

-(void) SideBarOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
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
        if(bPortrait){
            port_SideBarViewHeight=SCREEN_HEIGHT;
            //self.tableMenu.frame = CGRectMake(0, 0, 320, 568);
            if(port_SideBarViewHeight!=land_SideBarViewHeight){
                [self setSideBarPopUpMenuList:YES];
            }
    
        }else{
            land_SideBarViewHeight= SCREEN_HEIGHT;
            //self.tableMenu.frame = CGRectMake(0, 0, 568, 320);
            if(port_SideBarViewHeight!=land_SideBarViewHeight){
                [self setSideBarPopUpMenuList:NO];
            }
        }
    
    
   
    
}
-(void)setSideBarPopUpMenuList:(BOOL)portraitBool{
    if(bKidsShown){
        [channelView removeFromSuperview];
        [channelView close];
        channelView = nil;
        [self showKidListLeft];
    }
    if(portraitBool==YES){
        land_SideBarViewHeight  = port_SideBarViewHeight;
    }
    else{
        port_SideBarViewHeight  = land_SideBarViewHeight;
    }

}


#pragma mark - Custom7AlertDialog Delegate
-(void)customIOS7dialogDismiss{
    [channelView close];
    
    if(bAlertCategoryShown)
    {
        bAlertCategoryShown = false;
        
    }
    if(bAlertShown)
    {
        bAlertShown = false;
    }
    if(bPayPerViewShown)
    {
        bPayPerViewShown = false;
    }
    if(bKidsShown)
    {
        bKidsShown = false;
    }
    if(bSubscriptionShown)
    {
        bSubscriptionShown = false;
    }
    if(bOnDemandShown)
    {
        bOnDemandShown = false;
    }
    if(bOnDemandTvStrShown)
    {
        bOnDemandTvStrShown = false;
    }
    
}


#pragma mark - MenuView Deleagate
-(void)onDismissMenuView
{
    [channelView close];
    bAlertCategoryShown = false;
   
}
//NOT USED
-(void)onWatchChanel:(NSString*)idCategory{
    
    [channelView close];
    bAlertCategoryShown = false;
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    
    [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self.activityIndicator setHidden:true];
        
        [self showChanelList:responseObject];
    } catID:[idCategory intValue]];
    
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

@end
