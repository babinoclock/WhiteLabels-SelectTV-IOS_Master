//
//  IntroViewController.m
//  SidebarDemo
//
//  Created by Amit Sharma on 26/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "IntroViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "LDProgressView.h"
#import "RabbitTVManager.h"
#import "AppCommon.h"
#import "AppConfig.h"

@interface IntroViewController ()<UIGestureRecognizerDelegate>{//SWRevealViewControllerDelegate
    
    LDProgressView  *progressView;
    NSString        * progressString;
    UILabel         * progressLabel;
    
//    SWRevealViewController * revealViewController;
    
    NSString *portraitHeight;
    NSString *landScapeHeight;
    
    CGSize portraitHeightSize;
    CGSize landScapeHeightSize;
    
    float syncAPIDataCount;
    float currentProgress;
    
    
}
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *progressViews;
@end

@implementation IntroViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    isPortraitFirst=true;
    isLandScapeFirst=true;

    if([COMMON isSpanishLanguage]==YES){
        [self loadArrayTranslations];
    }
    else{
        [COMMON removeHomeStaticArrayList];
        [COMMON removeSideBarStaticArrayList];
    }
    
    //_splashImage.image =[UIImage imageNamed:SplashScreenImageName];
    
    [_splashImage setHidden:YES];
    
    self.view.backgroundColor = GRAY_BG_COLOR;
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SplashScreenImage"]];
    
    [self.navigationController.navigationBar setHidden:YES];
    progressView = [[LDProgressView alloc] init];
    progressLabel = [[UILabel alloc] init];
    [self setUpProgressBar];
   // [self push];        //for quick test
    [self syncMenuData];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    syncAPIDataCount = 14.0f;
    currentProgress = 0.0f;
    [self.view setUserInteractionEnabled:NO];
    
//new
    [self introductionView];
    
}
-(void)loadArrayTranslations{
    [COMMON removeHomeStaticArrayList];
    [COMMON removeSideBarStaticArrayList];
    [self loadHomeTranslation];
    [self loadSideBarMenuTranslation];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //self.revealViewController.delegate = self;
    
   // [self.revealViewController tapGestureRecognizer];
    
    //[self.revealViewController panGestureRecognizer];
   // self.revealViewController.panGestureRecognizer.enabled=NO;
    
}
#pragma  mark - Progress Bar

-(void) setUpProgressBar{
    
    self.progressViews = [NSMutableArray array];
    //progressBAR
    progressView.color              = [UIColor colorWithRed:0.73f green:0.64f blue:0.00f alpha:1.00f];
    progressView.flat               = @YES;
    progressView.progress           = 0;
    progressView.animate            = @YES;
    progressView.showStroke         = @NO;
    progressView.progressInset      = @4;
    progressView.showBackground     = @NO;
    progressView.outerStrokeWidth   = @3;
    progressView.animateDirection = LDAnimateDirectionBackward;
    [self.additionalView addSubview:progressView];
    //progressLABEL
    NSString *currentStr = @"loading...";
    if([COMMON isSpanishLanguage]==YES){
        currentStr = [COMMON getloadingStr];
        if ((NSString *)[NSNull null] == currentStr||currentStr == nil) {
            currentStr = @"loading...";
            currentStr = [self commanSpanishLanguageConvertion:currentStr savingName:LOADING];
        }
    }
    
    progressLabel.text = currentStr;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    [self.additionalView addSubview:progressLabel];
}
#pragma  mark - orientationChanged
-(void) introOrientationChanged:(NSNotification *) note
{
    UIDevice * device = note.object;
    
    switch (device.orientation) {
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

#pragma  mark - Sync

- (void) syncMenuData {
    [[RabbitTVManager sharedManager] getAppMenu:^(AFHTTPRequestOperation * request, id responseObject) {
        saveContentsToFile(responseObject, APP_MENU);
        progressString = @"loading application menu...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingAppMenuStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading application menu...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_APP_MENU];
            }
        }
        [self updateProgress];
        [self syncAllNetworkData];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        progressString = @"loading application menu...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingAppMenuStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading application menu...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_APP_MENU];
            }
        }
        [self updateProgress];
        [self syncAllNetworkData];
    }];
}

- (void) syncAllNetworkData {
    [[RabbitTVManager sharedManager] getAllNetworks:^(AFHTTPRequestOperation * request , id responseObject) {
        saveContentsToFile(responseObject, ALL_NETWORK_LIST);
        progressString = @"loading networks list...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingNetworkListStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading networks list...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_NETWORK_LIST];
            }
        }
        [self updateProgress];
        [self syncGamesData];//syncKidsCategoriesData
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        progressString = @"loading networks list...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingNetworkListStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading networks list...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_NETWORK_LIST];
            }
        }
        [self updateProgress];
        [self syncGamesData];//syncKidsCategoriesData
    }];
}
-(void)syncGamesData{
    
    [[RabbitTVManager sharedManager] getGamesCarouselData:^(AFHTTPRequestOperation * request , id responseObject){
        saveContentsToFile(responseObject, GAMES_CAROUSEL);
        progressString = @"loading games carousel...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingGamesCarouselStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading games carousel...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_GAMES_CAROUSEL];
            }
        }
        [self updateProgress];
        [self syncHomeDetailsData];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        progressString = @"loading games carousel...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingGamesCarouselStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading games carousel...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_GAMES_CAROUSEL];
            }
        }
        [self updateProgress];
        [self syncHomeDetailsData];
    } nPPV:PAY_MODE_ALL];
}

//- (void) syncKidsCategoriesData {
//    [[RabbitTVManager sharedManager] getKidsCategories:^(AFHTTPRequestOperation * request , id responseObject) {
//        saveContentsToFile(responseObject, KIDS_CATEGORIES);
//        progressString = @"loading kids categories...";
//        [self updateProgress];
//        [self syncKidSubCategories:responseObject];
//        
//    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
//        progressString = @"loading kids categories...";
//        [self updateProgress];
//        [self syncHomeDetailsData];
//         //[AppCommon showSimpleAlertWithMessage:@"Error"];
//        
//    }];
//}

//- (void) syncSubscriptionCategoriesData {
//    [[RabbitTVManager sharedManager] getSubscriptionCategories:^(AFHTTPRequestOperation * request, id responseObject) {
//        saveContentsToFile(responseObject, SUBSCRIPTIONS_CATEGORIES);
//        progressString = @"loading subscriptions categories...";
//        [self updateProgress];
//        [self syncSubscriptionSubCategories:responseObject];
//        
//    }];
//}

- (void) syncHomeDetailsData {
    [[RabbitTVManager sharedManager] getHomeDetails:^(AFHTTPRequestOperation *operation, id responseObject) {
        saveContentsToFile(responseObject, CAROUSEL_HOME_PAGE);
        progressString = @"loading home...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingHomeStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading home...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_HOME];
            }
        }
        [self updateProgress];
        [self getOnDemandTopMenu];
    }];
}

-(void) getOnDemandTopMenu{
    [[RabbitTVManager sharedManager] getOnDemandTopMenu:^(AFHTTPRequestOperation *request, id responseObject){
        saveContentsToFile(responseObject, ON_DEMAND_TOP_MENU);
        progressString = @"loading ondemand menu list...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingOnDemandStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading ondemand menu list...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_ON_DEMAND_LIST];
            }

        }
        [self updateProgress];
        [self getAppsCategoryData];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        progressString = @"loading ondemand menu list...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingOnDemandStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading ondemand menu list...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_ON_DEMAND_LIST];
            }
        }
        [self updateProgress];
        [self getAppsCategoryData];
    }];

}
-(void) getAppsCategoryData {
    int nDeviceID = [[NSString stringWithFormat:@"%d",8] intValue];
    
    [[RabbitTVManager sharedManager] getAppsCategory:^(AFHTTPRequestOperation *request, id responseObject){
        saveContentsToFile(responseObject, APP_CATEGORY);
        progressString = @"loading app category...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingAppCategoryStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading app category...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_APP_CATEGORY];
            }
        }
        [self updateProgress];
        [self getSelectTVSubscriptions];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        progressString = @"loading app category...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingAppCategoryStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading app category...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_APP_CATEGORY];
            }
        }
        [self updateProgress];
        [self getSelectTVSubscriptions];
    } nDeviceId:nDeviceID];
    
}

-(void)getSelectTVSubscriptions{
    
    [[RabbitTVManager sharedManager]getSelectTvScriptionItems:^(AFHTTPRequestOperation * request, id responseObject) {
        saveContentsToFile(responseObject, SELECTTVBOX_SUBSCRIPTIONS);
        progressString = @"loading subscriptions list...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingSubscriptionListStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading subscriptions list...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_SUBCRIPTION_LIST];
            }

        }
        [self updateProgress];
        [self syncAllCategoriesData];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [self updateProgress];
        [self syncAllCategoriesData];
    }];
}


- (void) syncAllCategoriesData {
    
    [[RabbitTVManager sharedManager] getAllCategories:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [self getCleanData:[responseObject mutableCopy]];
        saveContentsToFile(responseObject, LIVE_CATEGORIES);
        //[COMMON saveContentsToFile:responseObject withFileName:@"youlive.categories"];
        progressString = @"loading live categories...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingLiveCategoriesStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading live categories...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_LIVE_CATEGORIES];
            }
        }
        [self updateProgress];
        [self syncRadioGenreDetailsData];
    }];
}
- (void) syncRadioGenreDetailsData {
    
    [[RabbitTVManager sharedManager] getRadioGenre:^(AFHTTPRequestOperation * operation, id responseObject) {
        saveContentsToFile(responseObject,RADIO_GENRES);
        progressString = @"loading radio genres...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingRadioGenreStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading radio genres...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_RADIO_GENRES];
            }
        }
        [self updateProgress];
        [self syncRadioLanguageDetailsData];
    }];
    
}
- (void) syncRadioLanguageDetailsData {
    
    [[RabbitTVManager sharedManager] getRadioLanguage:^(AFHTTPRequestOperation * operation, id responseObject) {
        saveContentsToFile(responseObject, RADIO_LANGUAGES);
        progressString = @"loading radio languages...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingRadioLanguageStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading radio languages...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_RADIO_LANGUAGES];
            }
        }
        [self updateProgress];
        [self syncRadioContinentDetailsData];
        
    }];
    
}
- (void) syncRadioContinentDetailsData {
    [[RabbitTVManager sharedManager] getRadioContinent:^(AFHTTPRequestOperation * operation, id responseObject) {
        saveContentsToFile(responseObject, RADIO_CONTINENTS);
        progressString = @"loading radio continents...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON getloadingRadioContinentsStr];
            if ((NSString *)[NSNull null] == progressString||progressString == nil) {
                progressString = @"loading radio continents...";
                progressString = [self commanSpanishLanguageConvertion:progressString savingName:LOADING_RADIO_CONTINENTS];
            }
        }
        [self updateProgress];
        [self syncLatestNews];
    }];
    
}

-(void)loadHomeTranslation{
    NSMutableArray * homeStaticArray = [NSMutableArray new];
    homeStaticArray = [COMMON getHomeStaticArrayList];
    if([homeStaticArray count]==0){
        homeStaticArray = [NSMutableArray arrayWithObjects:@"Channels",@"On-Demand",@"Listen",@"Pay Per View",@"Subscriptions",@"Over the Air Link Sling",@"My Interests",@"My Account",@"Games",@"More",nil];
        [self getStaticTranslatedWordList:@"Home" currentStaticArray:homeStaticArray];
    }
}
-(void)loadSideBarMenuTranslation{
    NSMutableArray * SideMenuStaticArray = [NSMutableArray new];
    SideMenuStaticArray = [COMMON getSideBarStaticArrayList];
    if([SideMenuStaticArray count]==0){
        SideMenuStaticArray = [NSMutableArray arrayWithObjects:@"Home",@"Channels",@"On Demand",@"Pay Per View",@"Subscriptions",@"Radio Stations",@"App Manager",@"My Interests",@"My Account",@"Games",@"More",@"Logout",nil];
        [self getStaticTranslatedWordList:@"SideMenu" currentStaticArray:SideMenuStaticArray];
    }

   
}
-(void)getStaticTranslatedWordList:(NSString *)currentPage currentStaticArray:(NSMutableArray*)commonStaticArray{
    NSMutableArray *tempArray = [NSMutableArray new];

    for(int i=0;i<commonStaticArray.count;i++){
        
        NSString *currentText= [commonStaticArray objectAtIndex:i];
        
        NSString *translatedText= [COMMON stringTranslatingIntoSpanish:currentText];
        
        if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
            translatedText=@"";
        }
        [tempArray addObject:translatedText];
        if([currentPage isEqualToString:@"Home"]){
            [COMMON setHomeStaticArrayList:tempArray];

        }
        else{
            [COMMON setSideBarStaticArrayList:tempArray];
        }
    }
}


-(id) getCleanData:(id)responseObject {
    NSMutableDictionary *currentDictionary;
    for (int i=0; i<[responseObject count]; i++) {
        currentDictionary = [[responseObject objectAtIndex:i] mutableCopy];
        for (NSString *key in [currentDictionary allKeys]) {
            if ([[currentDictionary valueForKey:key] isEqual:[NSNull null]] ||
                [[currentDictionary valueForKey:key] isKindOfClass:[NSNull class]] ||
                [currentDictionary valueForKey:key] == nil) {
                [currentDictionary setValue:@"" forKey:key];
            }
        }
        [responseObject setObject:[currentDictionary copy] atIndex:i];
    }
    return responseObject;
}


//
//- (void) syncKidSubCategories:(id)responseObject {
//    NSMutableArray *categoryArray =[[NSMutableArray alloc] initWithArray: responseObject];
//    for (int i = 0; i<[categoryArray count]; i++) {
//        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:categoryArray[i]];
//        int nID = [dictItem[@"id"] intValue];
//        [[RabbitTVManager sharedManager] getKidSubCategories:^(AFHTTPRequestOperation * request, id responseObject) {
//            NSString *strSubcategoryFile = [NSString stringWithFormat:KIDS_SUB_CATEGORIES,nID];
//            saveContentsToFile(responseObject, strSubcategoryFile);
//            progressString = @"loading kids sub categories...";
//            [self updatePartialCount:(int)[categoryArray count]];
//            if (i == [categoryArray count] - 1) {
//                //[self syncSubscriptionCategoriesData];
//                [self syncHomeDetailsData];
//            }
//        } nID:nID];
//    }
//}

//- (void) syncSubscriptionSubCategories:(id)responseObject {
//    NSMutableArray *categoryArray =[[NSMutableArray alloc] initWithArray: responseObject];
//    for (int i = 0; i<[categoryArray count]; i++) {
//        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:categoryArray[i]];
//        int nID = [dictItem[@"id"] intValue];
//        [[RabbitTVManager sharedManager] getSubscriptionSubCategories:^(AFHTTPRequestOperation * request, id responseObject) {
//            NSString *strSubcategoryFile = [NSString stringWithFormat:SUBSCRIPTIONS_SUB_CATEGORIES,nID];
//            saveContentsToFile(responseObject, strSubcategoryFile);
//            progressString = @"loading subscriptions sub categories...";
//            [self updatePartialCount:(int)[categoryArray count]];
//            if (i == [categoryArray count]-1) {
//                [self syncHomeDetailsData];
//            }
//        } nID:nID];
//    }
//}

//- (void) syncSubscriptionSubCategories:(id)responseObject {
//    NSMutableArray *categoryArray =[[NSMutableArray alloc] initWithArray: responseObject];
//    for (int i = 0; i<[categoryArray count]; i++) {
//        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] initWithDictionary:categoryArray[i]];
//        int nID = [dictItem[@"id"] intValue];
//        [[RabbitTVManager sharedManager] getSubscriptionSubCategories:^(AFHTTPRequestOperation * request, id responseObject) {
//            NSString *strSubcategoryFile = [NSString stringWithFormat:SUBSCRIPTIONS_SUB_CATEGORIES,nID];
//            saveContentsToFile(responseObject, strSubcategoryFile);
//            progressString = @"loading subscriptions sub categories...";
//            [self updatePartialCount:(int)[categoryArray count]];
//            if (i == [categoryArray count]-1) {
//                [self syncHomeDetailsData];
//            }
//        } nID:nID];
//    }
//}

- (void) syncLatestNews{
    
    int nChannelID = 145;
    [[RabbitTVManager sharedManager] getChannels:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *channelId = @"145";
         NSString *strCategoryFile = [NSString stringWithFormat:YOULIVE_CHANNELS,channelId];
        saveContentsToFile(responseObject,strCategoryFile);
        progressString = @"loading latest news...";
        if([COMMON isSpanishLanguage]==YES){
            progressString = [COMMON stringTranslatingIntoSpanish:progressString];
        }
        [self updateProgress];
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
            progressString = @"loading latest news sub categories...";
            if([COMMON isSpanishLanguage]==YES){
                progressString = [COMMON stringTranslatingIntoSpanish:progressString];
            }
            [self updatePartialCount:(int)[categoryArray count]];
            if (i == [categoryArray count]-1) {
                [self push];
            }
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"responseerror%@",error);
            
        } chanID:nChannelID];
    }
}

#pragma mark - Progress Percentage

- (void) updatePartialCount:(int) totalCount {
    currentProgress = currentProgress + (100.0f/syncAPIDataCount)/totalCount;
    [self changeString:progressString];
    [self change:currentProgress];
}

- (void)updateProgress
{
    currentProgress = currentProgress + 100.0f/syncAPIDataCount;
    [self changeString:progressString];
    [self change:currentProgress];
}
- (void)change:(float) floatProgress{
    
    NSLog(@"progress =%lf",floatProgress);
   // for (progressView in self.progressViews) {
        progressView.progress = floatProgress /100;
 // }
}
#pragma mark - Progress String

- (void)changeString:(NSString *) String{
    progressLabel.text = String;
    
}
#pragma mark - commanSpanishLanguageConvertion
-(NSString *)commanSpanishLanguageConvertion:(NSString *)currentText savingName:(NSString *)currentSavingName{
    NSString *translatedText;
    translatedText =  [COMMON stringTranslatingIntoSpanish:currentText];
    if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
        translatedText = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:translatedText forKey:currentSavingName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
        translatedText = currentText;
    }
    return translatedText;
}
#pragma mark - Push

- (void)push{
//    [self.navigationController.navigationBar setHidden:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    SWRevealViewController *sideBar = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    [[self navigationController]pushViewController:sideBar animated:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SWRevealViewController *destinationController= (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
    
//    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    
    [self presentViewController:destinationController animated:NO completion:nil];
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Gesture Delegate Methods
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    
    return YES;//NO
    
}
- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//NO
}

#pragma  mark - rotateViews
-(void) rotateViews:(BOOL) bPortrait{
    CGSize addView = self.additionalView.frame.size;
    CGSize size = self.view.frame.size;
   
    
    if(bPortrait){
        [progressView setHidden:NO];
        [progressLabel setHidden:NO];
        progressView.frame  = CGRectMake(self.additionalView.frame.origin.x , addView.height -50, size.width -40, 22);
       // progressLabel.frame = CGRectMake(self.additionalView.frame.origin.x +5, addView.height -75, size.width -40, 22);
         progressLabel.frame = CGRectMake(self.additionalView.frame.origin.x +5, addView.height -75, size.width -40, 22);
        portraitHeight = [NSString stringWithFormat:@"%f", size.height];
        }
    
    else{
        progressView.frame  = CGRectMake(self.additionalView.frame.origin.x , addView.height -50, size.width -40, 22);
       // progressLabel.frame = CGRectMake(self.additionalView.frame.origin.x +5, addView.height -75, size.width -40, 22);
        progressLabel.frame = CGRectMake(self.additionalView.frame.origin.x +5, addView.height -75, size.width -40, 22);
        portraitHeight = [NSString stringWithFormat:@"%f", size.height];
        
        
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    
}
-(void)introductionView
{
 
    UIImageView *introImgView =[[UIImageView alloc]init];
    
    CGFloat height = 100;
    CGFloat width = 100;
    
    CGFloat Xpos = SCREEN_WIDTH/2 -(width/2);
    CGFloat Ypos = SCREEN_HEIGHT/2 -(height/2);
    
   // introImgView.frame = CGRectMake(CGRectGetMinX(self.view.frame)+10, (self.view.frame.size.height/2)-100 , self.view.frame.size.width - 20, 100);
    
    introImgView.frame = CGRectMake(Xpos, Ypos, width, height);
    //introImgView.backgroundColor = [UIColor redColor];
    introImgView.image =[UIImage imageNamed:splashNewImage];
    [self.view addSubview:introImgView];
    
    
}

@end
