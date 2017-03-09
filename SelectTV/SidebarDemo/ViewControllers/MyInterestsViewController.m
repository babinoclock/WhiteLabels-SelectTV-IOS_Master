 //
//  MyInterestsViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MyInterestsViewController.h"

@interface MyInterestsViewController (){
    //Scrolltitle
    UIScrollView   *showHeaderView;
    UIView *backgroundView ;
    UILabel *indicateLabel;
    CGFloat scrollButtonWidth;
    CGFloat scrollButtonWidthTest;
    CGSize stringsize;
    BOOL isScrolled;
    NSInteger visibleSection;
    NSMutableArray *titleDataArray;
    NSMutableArray *scrollTitleHeaderArray;
    
    //POP UP
    
    UIView * showPopUpInnerView;
    UIScrollView * showPopUpFullScrollView;
    UIButton *closePopUpBtn;
    UILabel *popUpTitle;
    UILabel *popTitleLine;
    UILabel *popBtnExtraLine;
    UIButton *popUpPreviousBtn;
    UIButton *popUpNextBtn;
    BOOL isPopUpPreviousClicked;
    BOOL isPopUpNextClicked;
    BOOL isPersonalizedBtnClicked;
    CGRect middleFrame;
    CGFloat middleViewHeight;
    
    //GRID
    NSMutableArray *commonGridArray;
    NSMutableArray *commonPopUpGridArray;
    NSMutableDictionary *userDictList;
    
    
    //UITABLEVIEW
    NSString *pressedFavBtnTitle;
    NSMutableDictionary *userFavListDict;
    NSMutableArray *myInterestsArray;
    NSMutableArray *myMoviesGenersArray;
    NSMutableArray *myTVNetworksArray;
    
    BOOL isMovieGenres;
    BOOL isTVNetworks;
    NSString *currentTopTitle;
    NSString *currentApplanguage;

}

@end

@implementation MyInterestsViewController

@synthesize movieGenreArray,networkGenreArray,popUpTable;

CustomIOS7AlertView *showPopUpView;
int nMyInterestsColumn=3;
int nMyInterestsWidth=107;
int nMyInterestsHeight=200;

BOOL bFavPopUpViewShown = false;

-(void)viewDidLoad
{
    [super viewDidLoad];
    isMovieGenres =YES;
    commonGridArray = [[NSMutableArray alloc]init];
    userDictList = [[NSMutableDictionary alloc]init];
    myInterestsArray =  [[NSMutableArray alloc]init];
    myMoviesGenersArray =  [[NSMutableArray alloc]init];
    myTVNetworksArray =  [[NSMutableArray alloc]init];
    
    userFavListDict = [NSMutableDictionary new];
    scrollTitleHeaderArray  = [NSMutableArray arrayWithObjects: @"Shows", @"Movies", @"Movie Genres", @"Channels", @"TV Networks", @"Video Libraries",nil];
    [self.view endEditing:YES];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    visibleSection = 0;
    [self UserFavListAPI];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    [self loadNavigation];
    [self setOrientation];
    UIImageView *imageView1 = [[UIImageView alloc] init];
    [imageView1 setTintColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    imageView1.image =[[UIImage imageNamed:@"settingIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [_personalizeBtnImage setBackgroundImage:imageView1.image  forState:UIControlStateNormal];
    [_addRemoveBtnImage setBackgroundImage:imageView1.image  forState:UIControlStateNormal];
    
    [_personalizeBtnImage addTarget:self action:@selector(personlizeAction) forControlEvents:UIControlEventTouchUpInside];
    [_personalizeButton addTarget:self action:@selector(personlizeAction) forControlEvents:UIControlEventTouchUpInside];
    [_addRemoveBtnImage addTarget:self action:@selector(personlizeAction) forControlEvents:UIControlEventTouchUpInside];
    [_addRemoveButton addTarget:self action:@selector(personlizeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_personalizeBtnImage setHidden:YES];
    [_personalizeButton setHidden:YES];
    [_addRemoveBtnImage setHidden:YES];
    [_addRemoveButton setHidden:YES];
    
    
    NSLog(@"visibleSectionWillApp%ld",(long)visibleSection);
    
    
}
#pragma mark - UserFavListAPI
-(void)UserFavListAPI{
    [COMMON LoadIcon:self.view];
        [[RabbitTVManager sharedManager] getFavoritesUserList:^(AFHTTPRequestOperation * request, id responseObject) {
        
        {
            //[COMMON setFavListDetails:responseObject];
           // userDictList = responseObject;
            
            saveContentsToFile(responseObject, USER_FAVOURITE_LIST);
            [self reArrangeMethodForArray:responseObject];
            NSLog(@"FavoritesUserList-->%@",responseObject);
            //[self settingButtonsTitle];
            
            userFavListDict = [[COMMON retrieveContentsFromFile:USER_FAVOURITE_LIST dataType:DataTypeDic] mutableCopy];
            myInterestsArray = [[userFavListDict valueForKey:@"shows"]mutableCopy];
            [_myInterestsTable reloadData];
            [COMMON removeLoading];
            
            
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            NSString *errorStr = @"Invalide or expired token, Please Login to Continue";
            [self alertView:errorStr];
            [COMMON removeLoading];
            
        }
    } strAccessToken:[COMMON getUserAccessToken]];
    
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
#pragma mark - logoutForTokenExpired
-(void)logoutForTokenExpired{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [COMMON removeLoginDetails];
    [COMMON removeLoading];
    [self pushToLoginScreen];
}

-(void)settingButtonsTitle{
    [_personalizeBtnImage setHidden:NO];
    [_personalizeButton setHidden:NO];
    [_addRemoveBtnImage setHidden:NO];
    [_addRemoveButton setHidden:NO];
    _personlizeLabel.text = @"PERSONALIZE";
    [_personlizeLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    _personlizeLabel.textColor = [UIColor whiteColor];

    _addRemoveLabel.text = @"ADD/REMOVE";
    [_addRemoveLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    _addRemoveLabel.textColor = [UIColor whiteColor];

//    [_personalizeButton setTitle:@"PERSONALIZE" forState:UIControlStateNormal];
//    _personalizeButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
//    [_personalizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [_addRemoveButton setTitle:@"ADD/REMOVE" forState:UIControlStateNormal];
//    _addRemoveButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
//    [_addRemoveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController * LoginVC = nil;
    LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

-(void)reArrangeMethodForArray:(id)responseObject{
    
    commonGridArray = [NSMutableArray new];
    
    NSMutableArray *responseArray = [NSMutableArray new];
    
    NSMutableArray *titleArray  = [NSMutableArray arrayWithObjects: @"moviegenres", @"tvnetworks",nil];
    
    for( NSString *titleKey in titleArray){
        
        if([titleKey isEqualToString:@"moviegenres"]){
           responseArray= [movieGenreArray mutableCopy];
        }
        if([titleKey isEqualToString:@"tvnetworks"]){
            responseArray= [networkGenreArray mutableCopy];
        }
        commonPopUpGridArray= [NSMutableArray new];
        
        NSMutableArray * checkArray = [[NSMutableArray alloc]init];
        checkArray = [responseObject valueForKey:titleKey];
        checkArray =[self sortingArray:checkArray];
        
        for(NSMutableDictionary *dict in responseArray){
            
            NSString * stringToFind = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            NSMutableDictionary *tempDict = [dict mutableCopy];
            for(NSMutableDictionary * anEntry in checkArray)
            {
                NSString * movieID = [NSString stringWithFormat:@"%@",[anEntry valueForKey:@"id"]];
                
                if([movieID isEqualToString:stringToFind]){
                    
                    [tempDict setObject:@"YES" forKey:@"isSelected"];
                    break;
                }
                else{
                    [tempDict setObject:@"NO" forKey:@"isSelected"];
                }
            }
            
            [commonPopUpGridArray addObject:tempDict];
        }
        if([titleKey isEqualToString:@"moviegenres"]){
            movieGenreArray =[commonPopUpGridArray mutableCopy];
        }
        if([titleKey isEqualToString:@"tvnetworks"]){
            networkGenreArray  = [commonPopUpGridArray mutableCopy];
        }

    }
}

#pragma mark -Used to Sort An Array
-(NSMutableArray*)sortingArray:(NSMutableArray *)responseArray{
    NSMutableArray *sortingArray = [NSMutableArray new];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    sortingArray=(NSMutableArray *)[responseArray sortedArrayUsingDescriptors:descriptors];
    return sortingArray;
}

-(void) loadNavigation{
    currentApplanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr = @"My Interests";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
    [self.navigationController.navigationBar setHidden:NO];
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myInterestsScrolled:) name:@"myInterestsTableScrolled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myInterestsTableFilter:) name:@"myInterestsScrollFromRightView" object:nil];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
}
-(void)setOrientation{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyInterestsOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
}
#pragma mark - orientationChanged
-(void) MyInterestsOrientationChanged:(NSNotification *) note
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
#pragma mark - setTitleScrollBar
-(void)setTitleScrollBar
{
    CGFloat commonWidth;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        commonWidth = [UIScreen mainScreen].bounds.size.width;
    }
    else{
        commonWidth = [UIScreen mainScreen].bounds.size.width;
    }
     showHeaderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, commonWidth, 44)];
    [showHeaderView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
    _headerScroll = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, commonWidth, showHeaderView.frame.size.height)];
    [showHeaderView addSubview:_headerScroll];
    [self.view addSubview:showHeaderView];
    
    
    [_headerScroll setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
    
    _headerScroll.sectionTitles = scrollTitleHeaderArray;
    _headerScroll.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _headerScroll.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _headerScroll.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
   
    _headerScroll.selectionIndicatorColor = [UIColor whiteColor];
    _headerScroll.selectedSegmentIndex = visibleSection;
    
    [_headerScroll addTarget:self action:@selector(segmentedControlChangedValueInterestPage:) forControlEvents:UIControlEventValueChanged];
    
    [_headerScroll setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString;
        
        if (selected) {
        
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
           
            
            
            return attString;
        } else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
            
            return attString;
        }
    }];
    
    if([scrollTitleHeaderArray count]!=0){
        
       [self loadMyInterestData:visibleSection];
        
    }

}
- (void)segmentedControlChangedValueInterestPage:(HMSegmentedControl *)sender {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    visibleSection = sender.selectedSegmentIndex;
    [self loadMyInterestData:visibleSection];

}
-(void)loadMyInterestData:(NSInteger)visibleSectionInterger{
    
    NSString *buttonTitle = [[scrollTitleHeaderArray objectAtIndex:visibleSectionInterger]lowercaseString];
    buttonTitle = [buttonTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    currentTopTitle = [scrollTitleHeaderArray objectAtIndex:visibleSectionInterger];
    
    [self getCurrentTopTitle:currentTopTitle];
    
    //currentTopTitle = [currentTopTitle lowercaseString];
    pressedFavBtnTitle = buttonTitle;
    userFavListDict = [[COMMON retrieveContentsFromFile:USER_FAVOURITE_LIST dataType:DataTypeDic] mutableCopy];
    myInterestsArray = [[userFavListDict valueForKey:buttonTitle]mutableCopy];
    [_myInterestsTable reloadData];
}

- (void)getCurrentTopTitle:(NSString*)currentTopTitleStr{
    
    if([currentTopTitleStr isEqualToString:@"Shows"]){
        currentTopTitle = @"show";
    }
    if([currentTopTitleStr isEqualToString:@"Movies"]){
        currentTopTitle = @"movie";
    }
    if([currentTopTitleStr isEqualToString:@"Movie Genres"]){
        currentTopTitle = @"moviegenre";
    }
    if([currentTopTitleStr isEqualToString:@"Channels"]){
        currentTopTitle = @"channel";
    }
    if([currentTopTitleStr isEqualToString:@"TV Networks"]){
        currentTopTitle = @"network";
    }
    if([currentTopTitleStr isEqualToString:@"Video Libraries"]){
        currentTopTitle = @"videolibrary";
    }
}
#pragma mark - personlizeAction
-(void)personlizeAction{
    commonGridArray = movieGenreArray;
    [self loadPopUp];
}
#pragma mark - loadDropTable
-(void) loadPopUp{
    
    UIDevice* device = [UIDevice currentDevice];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            //230
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-70)];
            nMyInterestsColumn= 4;
        }
        //IPAD
        else{
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-220, self.view.frame.size.height-160)];
            nMyInterestsColumn= 4;
        }
        
    }else{
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, self.view.frame.size.height-150)];
            nMyInterestsColumn= 3;
        }
        //IPAD
        else{
            
            showPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            showPopUpInnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, self.view.frame.size.height-280)];
            nMyInterestsColumn= 3;
        }
    }
    
    popUpTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, showPopUpInnerView.frame.size.width-20, 25)];
    popTitleLine =[[UILabel alloc] initWithFrame:CGRectMake(10, popUpTitle.frame.origin.y+popUpTitle.frame.size.height, showPopUpInnerView.frame.size.width-20, 20)];
    closePopUpBtn  =[[UIButton alloc] initWithFrame:CGRectMake(showPopUpInnerView.frame.size.width-20, 0, 20, 20)];
    CGFloat showPopUpFullScrollViewYpos=popTitleLine.frame.origin.y+popTitleLine.frame.size.height+2;
    showPopUpFullScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, showPopUpFullScrollViewYpos, showPopUpInnerView.frame.size.width, showPopUpInnerView.frame.size.height-(showPopUpFullScrollViewYpos*2))];
    
    CGFloat popUpPreviousBtnYpos = showPopUpFullScrollView.frame.origin.y+showPopUpFullScrollView.frame.size.height+2;
    popUpPreviousBtn = [[UIButton alloc] initWithFrame:CGRectMake(showPopUpInnerView.frame.size.width/5, popUpPreviousBtnYpos, showPopUpInnerView.frame.size.width/3.5, 30)];
    popUpNextBtn = [[UIButton alloc] initWithFrame:CGRectMake(popUpPreviousBtn.frame.origin.x+popUpPreviousBtn.frame.size.width+5, popUpPreviousBtn.frame.origin.y, showPopUpInnerView.frame.size.width/3.5, 30)];
    popBtnExtraLine =[[UILabel alloc] initWithFrame:CGRectMake(20,showPopUpInnerView.frame.size.height-15,  showPopUpInnerView.frame.size.width-40, 15)];
    
    popUpTable =[[UIGridView alloc] initWithFrame:CGRectMake(0,0, showPopUpFullScrollView.frame.size.width, showPopUpFullScrollView.frame.size.height)];
    nMyInterestsWidth = popUpTable.frame.size.width / nMyInterestsColumn;
    nMyInterestsHeight = popUpTable.frame.size.width / nMyInterestsColumn;

    [self setPopUpViews];
    [self setUpSubViews];
}
#pragma mark - setPopUpViews
-(void) setPopUpViews{
    isPopUpPreviousClicked =YES;
    
    NSString *movieString = @"What kind of Movies do you like?";
    popUpTitle.attributedText = [self setAttributedTextForMovies:movieString];
    
    
    [popUpTitle setTextAlignment:NSTextAlignmentCenter];
    UIImage *btnImage = [UIImage imageNamed:@"close_Icon"];
    [closePopUpBtn setImage:btnImage forState:UIControlStateNormal];
    [closePopUpBtn addTarget:self action:@selector(customIOS7dialogDismiss) forControlEvents:UIControlEventTouchUpInside];
    popTitleLine.text = @"(these will be added to the My Interests List)";
    [popTitleLine setTextColor:[UIColor whiteColor]];
    [popTitleLine setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [popTitleLine setTextAlignment:NSTextAlignmentCenter];
    popBtnExtraLine.text = @"Skip this for now";
    [popBtnExtraLine setTextColor:[UIColor whiteColor]];
    [popBtnExtraLine setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [popBtnExtraLine setTextAlignment:NSTextAlignmentCenter];
    popBtnExtraLine.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customIOS7dialogDismiss)];
    [recognizer setNumberOfTapsRequired:1];
    [popBtnExtraLine addGestureRecognizer:recognizer];
    
    [popUpPreviousBtn setTitle:@"PREVIOUS" forState:UIControlStateNormal];
    popUpPreviousBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
    [popUpPreviousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popUpNextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    popUpNextBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
    [popUpNextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popUpPreviousBtn setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5]];
    [popUpNextBtn setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    
    
    [popUpPreviousBtn addTarget:self action:@selector(popUpPreviousBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpNextBtn addTarget:self action:@selector(popUpNextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    popUpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - setAttributedTextForMovies
-(NSMutableAttributedString *)setAttributedTextForMovies:movieString{
    
    NSDictionary *attributes = @ {NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)] };
    NSDictionary *attributes1 = @ {NSForegroundColorAttributeName : [UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]};
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:movieString];
    [attStr addAttributes:attributes  range:[movieString rangeOfString:@"What kind of "]];
    [attStr addAttributes:attributes1 range:[movieString rangeOfString:@"Movies"]];
    [attStr addAttributes:attributes range:[movieString rangeOfString:@" do you like?"]];
    
    return attStr;
}

#pragma mark - setAttributedTextForMovies
-(NSMutableAttributedString *)setAttributedTextForNetworks:networksString{
   
    NSDictionary *attributes = @ {NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)] };
    NSDictionary *attributes1 = @ {NSForegroundColorAttributeName : [UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]};
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:networksString];
    [attStr addAttributes:attributes  range:[networksString rangeOfString:@"What are your favourite "]];
    [attStr addAttributes:attributes1 range:[networksString rangeOfString:@"TV Networks"]];
    [attStr addAttributes:attributes range:[networksString rangeOfString:@"?"]];
    
    
    return attStr;
}

#pragma mark - setUpSubViews
-(void)setUpSubViews{
    
    showPopUpInnerView.backgroundColor = [UIColor blackColor];
    showPopUpFullScrollView.backgroundColor = [UIColor blackColor];
    popUpTable.backgroundColor = [UIColor blackColor];
    showPopUpView.delegate = self;
    [showPopUpInnerView addSubview:popUpTitle];
    [showPopUpInnerView addSubview:popTitleLine];
    [showPopUpInnerView addSubview:popUpPreviousBtn];
    [showPopUpInnerView addSubview:popUpNextBtn];
    [showPopUpInnerView addSubview:popBtnExtraLine];
    [showPopUpInnerView addSubview:closePopUpBtn];
    [showPopUpFullScrollView addSubview:popUpTable];
    [showPopUpInnerView addSubview:showPopUpFullScrollView];
    
    showPopUpFullScrollView.delegate = self;
    popUpTable.uiGridViewDelegate = self;
    [popUpTable setScrollEnabled:YES];
    popUpTable.allowsMultipleSelection=NO;
    popUpTable.allowsSelection=NO;
    
    [showPopUpFullScrollView setScrollEnabled:NO];
    showPopUpFullScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [showPopUpFullScrollView setShowsHorizontalScrollIndicator:YES];
    showPopUpFullScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [showPopUpView setContainerView:showPopUpInnerView];
    [showPopUpView show];
    
    bFavPopUpViewShown = true;

    
}

#pragma mark - customIOS7dialogDismissAction
-(void)customIOS7dialogDismiss{
    
    [showPopUpView close];
    
    if(bFavPopUpViewShown)
    {
        bFavPopUpViewShown = false;
    }
    isPopUpPreviousClicked =NO;
    isPopUpNextClicked =NO;

    isPersonalizedBtnClicked=NO;
    isMovieGenres=YES;
    isTVNetworks=NO;
    [self UserFavListAPI];
    
    
    
}
-(void)popUpPreviousBtnAction{
    if(isTVNetworks==YES){
        NSString *movieString = @"What kind of Movies do you like?";
        popUpTitle.attributedText = [self setAttributedTextForMovies:movieString];
        isTVNetworks=NO;
        isMovieGenres=YES;
        commonGridArray = movieGenreArray;
        [popUpTable reloadData];
        
    }
    
}
-(void)popUpNextBtnAction{
    if(isMovieGenres==YES){
        NSString *networkString= @"What are your favourite TV Networks?";
        popUpTitle.attributedText = [self setAttributedTextForNetworks:networkString];
        isTVNetworks =YES;
        isMovieGenres=NO;
        commonGridArray = networkGenreArray;
        [popUpTable reloadData];
        
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

#pragma mark - UI Grid View Delegate
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return nMyInterestsWidth;
    
}
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return  185;//nMyInterestsHeight
    }
    else{
        
        return 120;
    }
}
- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return nMyInterestsColumn;
    
}
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if([commonGridArray count]!=0){
        return [commonGridArray count];
    }
    else{
        return 0;
    }
    
}
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    //CELL
    myInterestsCell *cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[myInterestsCell alloc] init];
    }
    int nIndex = rowIndex * nMyInterestsColumn + columnIndex;
    if([commonGridArray count]!=0){
        NSDictionary* dictItemData = commonGridArray[nIndex];
        NSString *strChannelName;
        NSString* strPosterUrl;
        
        if(isMovieGenres==YES){
            currentTopTitle = @"moviegenre";
            strChannelName = dictItemData[@"label"];
            [cell.thumbnailView setHidden:NO];
            [cell.thumbnail setHidden:YES];
            [cell.innerLabel setHidden:NO];
            [cell.titleLabel setHidden:YES];
            cell.innerLabel.text = strChannelName;
            cell.thumbnailView.layer.borderWidth = 1.0f;
            cell.thumbnailView.layer.borderColor = [UIColor whiteColor].CGColor;
            }
        if(isTVNetworks==YES){
            currentTopTitle = @"network";
            strChannelName = dictItemData[@"name"];
            strPosterUrl = dictItemData[@"thumbnail"];
            
            if ((NSString *)[NSNull null] == strPosterUrl) {
                strPosterUrl=@"";
            }
            if (strPosterUrl==nil) {
                strPosterUrl=@"";
            }
            [cell.thumbnailView setHidden:YES];
            [cell.thumbnail setHidden:NO];
            [cell.innerLabel setHidden:YES];
            [cell.titleLabel setHidden:NO];
            NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
            [cell.thumbnail setImageWithURL:imageUrl];
             cell.titleLabel.text = strChannelName;
        }
        [cell.tickButton setImage:[UIImage imageNamed:@"tickIcon"] forState:UIControlStateNormal];
        
        NSString *isSelected =dictItemData[@"isSelected"];
        if([isSelected isEqualToString:@"YES"]){
           [cell.tickButton setHidden:NO];
        }
        else{
            [cell.tickButton setHidden:YES];
        }
       
        cell.innerLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        [cell.innerLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        [cell.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        [cell.playIcon setHidden:YES];
        
    }
    return cell;
    
}


- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    myInterestsCell *cellview = currentCell;
    int nIndex = rowIndex * nMyInterestsColumn + colIndex;
    NSMutableDictionary * dictItemData = [commonGridArray[nIndex]mutableCopy];
    NSString *selectedId =[NSString stringWithFormat:@"%@",dictItemData[@"id"]];
    NSString *isSelected =dictItemData[@"isSelected"];
    
    if([isSelected isEqualToString:@"NO"]) {
        [cellview.tickButton setHidden:NO];
        [cellview.tickButton setImage:[UIImage imageNamed:@"tickIcon"] forState:UIControlStateNormal];
        [dictItemData setObject:@"YES" forKey:@"isSelected"];
        [self addFavouriteItem:selectedId];
        if(isMovieGenres==YES){
            if([movieGenreArray count]!=0){
                 [movieGenreArray replaceObjectAtIndex:nIndex withObject:dictItemData];
            }
           
        }
        else if(isTVNetworks==YES){
            if([networkGenreArray count]!=0){
                [networkGenreArray replaceObjectAtIndex:nIndex withObject:dictItemData];
            }
            
        }
        
        
    }
    else {
        [cellview.tickButton setHidden:YES];
        [dictItemData setObject:@"NO" forKey:@"isSelected"];
        [self removeFavouriteItem:selectedId];
        if(isMovieGenres==YES){
            if([movieGenreArray count]!=0){
                [movieGenreArray replaceObjectAtIndex:nIndex withObject:dictItemData];
            }
        }
        else if(isTVNetworks==YES){
            if([networkGenreArray count]!=0){
                [networkGenreArray replaceObjectAtIndex:nIndex withObject:dictItemData];
            }
        }
        
        
    }
    
    [commonGridArray replaceObjectAtIndex:nIndex withObject:dictItemData];
    

}
#pragma mark - Add FavouriteAPI
-(void)addFavouriteItem:(NSString*)selectedID{
    [COMMON LoadIcon:self.view];
    NSLog(@"ACCESS%@,STR%@,ID%d",[COMMON getUserAccessToken],currentTopTitle,[selectedID intValue]);
    [[RabbitTVManager sharedManager]getFavoritesAdd:^(AFHTTPRequestOperation * request, id responseObject) {
        {
            NSLog(@"ADDList-->%@",responseObject);
            [COMMON removeLoading];
            
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            NSLog(@"ADDError-->%@",error);
            [COMMON removeLoading];
        }
    } strAccessToken:[COMMON getUserAccessToken] strEntity:[currentTopTitle lowercaseString] nEntityId:[selectedID intValue]];
}

#pragma mark - Remove FavouriteAPI
-(void)removeFavouriteItem:(NSString*)selectedID{
    [COMMON LoadIcon:self.view];
     NSLog(@"ACCESS%@,STR%@,ID%d",[COMMON getUserAccessToken],currentTopTitle,[selectedID intValue]);
    
    [self getCurrentTopTitle:currentTopTitle];
    
    [[RabbitTVManager sharedManager]getFavoritesRemove:^(AFHTTPRequestOperation * request, id responseObject) {
        {
            NSLog(@"RemoveList-->%@",responseObject);
            [COMMON removeLoading];
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            NSLog(@"RemoveError-->%@",error);
            NSString *errorStr = @"Invalide or expired token, Login to Continue";
            [self alertView:errorStr];
            [COMMON removeLoading];
        }
    } strAccessToken:[COMMON getUserAccessToken] strEntity:[currentTopTitle lowercaseString] nEntityId:[selectedID intValue]];
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger nCount = 0;
    if([myInterestsArray count]!=0){
        nCount = [myInterestsArray count];
    }
    
    return nCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // if (cell == nil) {
        cell = [[FavTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    NSDictionary *dictItem = myInterestsArray[indexPath.section];
    
    NSString* strName =dictItem[@"name"];
    NSString* strDescription = dictItem[@"description"];
    NSString* strPosterUrl= dictItem[@"image"];
    NSString* strRating = dictItem[@"rating"];
    NSString* strRunTime = dictItem[@"runtime"];
    
    
    if ((NSString *)[NSNull null] == strName || strName == nil) {
        strName=@"";
    }
    if ((NSString *)[NSNull null] == strPosterUrl || strPosterUrl == nil) {
        strPosterUrl=@"";
    }
    if ((NSString *)[NSNull null] == strDescription || strDescription == nil) {
        strDescription=@"";
    }
    if ((NSString *)[NSNull null] == strRating || strRating == nil) {
        strRating=@"Not Rated";
    }
    if ((NSString *)[NSNull null] == strRunTime || strRunTime == nil) {
        strRunTime=@"N/A";
    }
    NSURL * urlPoster = [NSURL URLWithString:strPosterUrl];
    [cell.showImageView setImageWithURL:urlPoster];
    cell.showTitle.text =strName;
    cell.showDesp.text =strDescription;
    strRunTime = [NSString stringWithFormat: @"%@", strRunTime];
    
    cell.showRating.text = [NSString stringWithFormat:@"Rating : %@", strRating];
    cell.showRunTime.text = [NSString stringWithFormat:@"Runtime : %@ Minutes", strRunTime];
    [cell.removeBtn addTarget:self action:@selector(removeEntryAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeBtn setTag:indexPath.section];
    [self addBorderToCell:cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma removeEntryAtIndexPathAction
-(void)removeEntryAtIndexPath:(UIButton*)sender{
    NSLog(@"count tag -->%ld",(long)sender.tag);
    NSDictionary *dictItem = myInterestsArray[sender.tag];
    NSString* selectedID =dictItem[@"id"];
    if(selectedID!=nil){
        [self removeFavouriteItem:selectedID];
  
    }
    // NSLog(@"userDictList-->%@",userFavListDict);
    [myInterestsArray removeObjectAtIndex:sender.tag];
    NSMutableArray *tempArray = [myInterestsArray mutableCopy];
    if(pressedFavBtnTitle!=nil){
        [userFavListDict setObject:tempArray forKey:pressedFavBtnTitle];
        saveContentsToFile(userFavListDict, USER_FAVOURITE_LIST);
        [_myInterestsTable reloadData];
    }
}

#pragma mark - addBorderToCell
-(void)addBorderToCell:(UITableViewCell *)cell{
    UIView *leftBorder;
    UIView *rightBorder;
    UIView *topBorder;
    UIView *bottomBorder;
    leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1.5, cell.frame.size.height)];
    rightBorder = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-2.0f, 0, 1.0, cell.frame.size.height)];
    topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,cell.frame.size.width,1.5)];
    bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2.0f, cell.frame.size.width, 1.5)];
    [cell addSubview:leftBorder];
    [cell addSubview:topBorder];
    [cell addSubview:rightBorder];
    [cell addSubview:bottomBorder];
    [leftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [rightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [bottomBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    leftBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                 green:151.0f/255.0f
                                                  blue:151.0f/255.0f
                                                 alpha:1.0f];
    rightBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                  green:151.0f/255.0f
                                                   blue:151.0f/255.0f
                                                  alpha:1.0f];
    topBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                green:151.0f/255.0f
                                                 blue:151.0f/255.0f
                                                alpha:1.0f];
    bottomBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                   green:151.0f/255.0f
                                                    blue:151.0f/255.0f
                                                   alpha:1.0f];
}

#pragma mark -Rotate View
-(void) rotateViews:(BOOL) bPortrait{
    [self setTitleScrollBar];
    if(bFavPopUpViewShown){
        [self customIOS7dialogDismiss];
    }
    if(bPortrait){
        nMyInterestsColumn = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nMyInterestsColumn = 3;
            
        }
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        nMyInterestsWidth = screenWidth / nMyInterestsColumn;
//        nMyInterestsHeight = screenWidth / nMyInterestsColumn;
    }else{
        
        nMyInterestsColumn = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nMyInterestsColumn = 4;
        }
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        nMyInterestsWidth = screenWidth / nMyInterestsColumn;
//        nMyInterestsHeight = screenWidth / nMyInterestsColumn;
    }
    [_myInterestsTable reloadData];
}


#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
