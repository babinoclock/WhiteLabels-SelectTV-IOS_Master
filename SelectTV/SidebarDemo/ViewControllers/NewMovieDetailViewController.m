//
//  NewMovieDetailViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "NewMovieDetailViewController.h"
#import "RabbitTVManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "CastCell.h"
#import "Cell.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "AsyncImage.h"
#import "Land_Cell.h"
#import "New_Land_Cell.h"
#import "AppListGridCell.h"
#import "UIImage+WebP.h"
#import "CustomIOS7AlertView.h"


@interface NewMovieDetailViewController ()<CustomIOS7AlertViewDelegate,TTTAttributedLabelDelegate>{
    NSString* strTrailer;
    NSArray *paidItems;

    NSMutableArray *appFreeItems;
    NSMutableArray *appPaidItems;
    NSMutableArray *iosAppFreeItems;
    NSMutableArray *iosAppPaidItems;
    BOOL isSDClicked;
    BOOL isHDClicked;
    BOOL isHDXClicked;
    
    
    UIButton * deskTopBtn;
    UIButton * iosBtn;
    
    //NSMutableArray *appFreePaidItems;
    NSMutableArray *appShowAllItems;
    BOOL isFirstLandScape;
    AsyncImage *asyncImage;
    
    CGRect rightTopHalfViewFrame;
    CGFloat rightTopHalfViewHeight;
    
    CGRect IphoneLastViewFrame;
    CGFloat IphoneLastViewHeight;
    
    CGRect appListFrame;
    CGFloat appListScrollHeight;
    CGFloat appListViewHeight;
    

    CGFloat middleViewHeight;
    UIView *appListHeaderView;
    
    BOOL isFreeClicked;
    BOOL isAllEpisodesClicked;
    bool isAllSeasonsClicked;
    
    NSMutableArray *buttonArray;
    NSMutableDictionary *buttonDict;
    
    NSString * currentDesktopImage;
    NSString * currentAndriodImage;
    
    //free and Rent
    UILabel *freeLabel,*rentLabel;
    UILabel *freeRentLabel;
    UISwitch *freeSwitch;
    CGFloat bottomViewHeight;
    CGFloat middleScrollHeight;
    CGFloat middleViewYPos;
    //ICON
    NSMutableArray *iconArray;
    NSMutableArray *tempIconArray;
    
    BOOL isFreeCountEmpty;
    BOOL isEpisodeNotNeedInFree;
    
    //ALERT BOX
    BOOL isAppListPopUpShown;
    UIView *appListInnerPopUpView;
    NSString *currentCarouselID,*currentAppImage,*currentAppLink,*currentAppName,*currentDeepLink;
    
     UIButton * sdBtn,*hdBtn,*hdxBtn;
    
    NSString *freeRentStr;
    BOOL iPhoneLandScape;
    
    CGRect  detailFullView;
    CGFloat detailFullViewHeight;
    
    BOOL isTrailerHidden;
    NSMutableArray *paidNullArray;
    NSMutableDictionary *currentUserLoginDetails;
    NSMutableArray * subcriptionArray;
    
}
//NEW test for apps
@property (nonatomic, retain) NSArray *appsInDeviceMovie;

@property(retain,nonatomic) NSMutableArray* showFullGridArray;

@end
@implementation NewMovieDetailViewController
@synthesize mainView;
@synthesize nID,genreName,isEpisode,isMovie,posterUrlStr;

@synthesize appListView,appListScrollView,middleView,middleScrollView,fourLatestArray,showFullGridArray,allFreeEpisodeArray,allEpisodeArray, allSeasonsArray;

@synthesize despLabel,isPushedFromPayPerView,isToggledAll,isToggledFree;

CustomIOS7AlertView *appListFullPopUpView;

bool m_boolMovies = true;

int nAppCount = 3;
int nAppWidth = 107;
int nAppHeight = 120;

- (void)viewDidLoad {
    //[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [super viewDidLoad];
    
    isFreeClicked =YES;
    
    [_overViewBtn setTitle:@"Free" forState:UIControlStateNormal];
    [_castBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
    [_genreBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
   
    detailFullView = self.detailFullView.frame;
    detailFullViewHeight = detailFullView.size.height;
    
    middleViewHeight = self.middleView.frame.size.height;
    middleViewYPos = self.middleView.frame.origin.y;
    middleScrollHeight = middleScrollView.frame.size.height;
    rightTopHalfViewHeight = self.rightTopHalfView.frame.size.height;
    appListScrollHeight = appListScrollView.frame.size.height;
    appListViewHeight = appListView.frame.size.height;
    IphoneLastViewHeight =  self.lastBottomView.frame.size.height;
    [self setUpNavigation];
    [self arrayMovieAllocation];
    bottomViewHeight = _lastBottomView.frame.size.height;
    asyncImage =[[AsyncImage alloc]init];
    
    [self setUpAllViews];
    [self.iPhoneScrollView setHidden:YES];
    [self.detailFullView setHidden:YES];
    [self.leftTopHalfView setHidden:YES];
    [self.appListView setHidden:YES];
    [self.middleView setHidden:YES];
    [self.lastBottomView setHidden:YES];
    [self loadData];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self NewMovieRotateViews:false];
    }else{
        [self NewMovieRotateViews:true];
    }
    [_appListGridView setBackgroundColor:[UIColor clearColor]];

    [_appListGridView setScrollEnabled:NO];
    [_iPhoneScrollView setScrollEnabled:YES];
    _iPhoneScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [_iPhoneScrollView setShowsHorizontalScrollIndicator:YES];
    _iPhoneScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    if(isPushedFromPayPerView==YES){
        [self setUpEpisodesSeasonBottom];
    }
    else{
        [self setUpFreeData];
    }
    
    [self loadLatestScrollMiddleViewData:fourLatestArray];
    [self setScrollHeight];
    isSDClicked  = YES;
    isHDClicked  = NO;
    isHDXClicked = NO;

}

#pragma mark - setUpFreeData
-(void)setUpFreeData{
    if([allFreeEpisodeArray count]!=0){
        showFullGridArray = [NSMutableArray new];
        showFullGridArray = allFreeEpisodeArray;
        if(isToggledFree==YES){
            isEpisodeNotNeedInFree=YES;
            [_overViewBtn setTitle:@"Free" forState:UIControlStateNormal];
            [_castBtn setTitle:@"Seasons" forState:UIControlStateNormal];
            [_genreBtn setTitle:@"" forState:UIControlStateNormal];
            [_genreBtn setUserInteractionEnabled:NO];
        }
        
    }
    
    if([allFreeEpisodeArray count]==0){
        if(isToggledAll==YES){
            [self setUpEpisodesSeasonBottom];
        }
        else{
            [_lastBottomView setHidden:YES];
            [_lastBottomInnerView setHidden:YES];
        }
        
    }
}

#pragma mark - hideTheBottomViewFreeCountEmpty
-(void)setUpEpisodesSeasonBottom{
    isFreeCountEmpty=YES;
    [self loadfreeBtnItems];
    //isAllEpisodesClicked=YES;
    //[self loadAllEpisodesBtnItems];
    [_overViewBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
    [_castBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
    [_genreBtn setTitle:@"" forState:UIControlStateNormal];
    [_genreBtn setUserInteractionEnabled:NO];
}
-(void) viewWillAppear:(BOOL)animated{
    
    currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = [COMMON getLoginDetails];
    NSLog(@"userLoginDetails%@-->",currentUserLoginDetails);
    subcriptionArray = [NSMutableArray new];
        if([currentUserLoginDetails count]!=0){
            subcriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
        }

    
    [super viewWillAppear:animated];
    //[self loadLatestScrollMiddleViewData:fourLatestArray];
    [_watchLatestLabel setHidden:NO];
    [_overViewBtn setHidden:NO];
    [_castBtn setHidden:NO];
    [_genreBtn setHidden:NO];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
     self.view.backgroundColor = GRAY_BG_COLOR;
    
    //[middleView setBackgroundColor:[UIColor grayColor]];
    //[appListView setBackgroundColor:[UIColor lightGrayColor]];
   // [_detailFullView setBackgroundColor:[UIColor grayColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissMovieDetailAppListPopup];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    
    if([showFullGridArray count]!=0){
        
        [_appListGridView reloadData];
        
        _gridViewHeight.constant = _appListGridView.contentSize.height;

        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            _bottomFullViewHeightConstraint.constant = self.appListGridView.contentSize.height+ 100;//+gridHeight;
            _bottomInnerViewHeightConstraint.constant = self.appListGridView.contentSize.height+100;//+gridHeight;
        }else {
            _bottomFullViewHeightConstraint.constant = _appListGridView.contentSize.height+70;
        }
    } else {
        _bottomFullViewHeightConstraint.constant = 0;
        [_watchLatestLabel setHidden:YES];
        [_overViewBtn setHidden:YES];
        [_castBtn setHidden:YES];
        [_genreBtn setHidden:YES];
    }

    [self.view layoutIfNeeded];
}
#pragma mark - arrayAllocation
-(void)arrayMovieAllocation{
    
    asyncImage =[[AsyncImage alloc]init];
    appPaidItems =[[NSMutableArray alloc]init];
    appFreeItems =[[NSMutableArray alloc]init];
    iosAppFreeItems =[[NSMutableArray alloc]init];
    iosAppPaidItems =[[NSMutableArray alloc]init];
    
}
#pragma mark - setUpNavigation
-(void) setUpNavigation{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = _headerLabelStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    //self.navigationItem.title = _headerLabelStr;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
}

#pragma mark - loadMovieLatestAppListScrollViewData
-(void)loadMovieLatestAppListScrollViewData:(NSMutableArray *)latestArray{
    [self checkFormattedPriceForAppBtn];
    [appListView setHidden:NO];
    CGFloat detailViewHeightBasedOnTrailer=0.0f;
    
    if(isTrailerHidden==YES){
        _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
        detailViewHeightBasedOnTrailer = _topFullViewHeightConstraint.constant;
    }
    else{
        _topFullViewHeightConstraint.constant = detailFullViewHeight;
        detailViewHeightBasedOnTrailer = _topFullViewHeightConstraint.constant;
    }
   // _appListViewHeightConstraint.constant = 0;

    [self.view layoutIfNeeded];
   
    CGFloat commonWidth,backgroundViewWidth,titleButtonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    backgroundViewWidth = 10;
    titleButtonWidth = 0;
    UIView *backgroundView;
    CGFloat backgroundWidth,imageViewHeight;
    CGFloat imageViewWidth;
    UILabel *titleLabel;
    UILabel *watchNowLabel;
    
    for (UIView *subview in appListScrollView.subviews) {
        [subview removeFromSuperview];
    }
    if([appPaidItems count]==0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:YES];
    }
    if([appPaidItems count]!=0 && [appFreeItems count]==0){
        [freeLabel setHidden:YES];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:NO];
        freeRentLabel.text = @"BUY/RENT";
    }
    
    if([appPaidItems count]!=0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:NO];
        [rentLabel setHidden:NO];
        [freeRentLabel setHidden:YES];
    }
    
    for(int i = 0; i < [latestArray count]; i++)
    {
        
        NSDictionary *dictItem = latestArray[i];
        NSString *strStreamName = dictItem[@"display_name"];
        NSMutableArray * formats=[dictItem objectForKey:@"formats"];
        NSString * appImageUrl=[dictItem objectForKey:@"image"];
        NSString * appSubcriptionCode=[dictItem objectForKey:@"subscription_code"];
        NSString * appKey=[dictItem objectForKey:@"key"];
        if ((NSString *)[NSNull null] == appKey||appKey == nil) {
            appKey=@"free";
        }
        //NSString * appName=[dictItem objectForKey:@"app_name"];
        NSString * strRate;
        if ((NSMutableArray *)[NSNull null] == formats){
            strRate =@"FREE";
            if([freeRentStr isEqualToString:@"Paid"]){
                if([latestArray count]<=1){
                    NSLog(@"Change Height");
                    _appListHeightConstraint.constant = 0;
                    _appListViewHeightConstraint.constant = 0;
                    _topFullViewHeightConstraint.constant = detailViewHeightBasedOnTrailer;
                    [appListView setHidden:YES];
                    
                    //[self.view layoutIfNeeded];
                    //[self.view layoutSubviews];
                }
                continue;
            }
            
        }
        else{
            if([formats count]!=0){
                NSString* stringToFind;
                if(isSDClicked==YES){
                    stringToFind = @"SD";
                    strRate = [COMMON checkFormattedPrice:formats stringToFind:stringToFind];
                }
                else if (isHDClicked==YES){
                    stringToFind = @"HD";
                    strRate = [COMMON checkFormattedPrice:formats stringToFind:stringToFind];
                }
                else if (isHDXClicked==YES){
                    stringToFind = @"HDX";
                    strRate = [COMMON checkFormattedPrice:formats stringToFind:stringToFind];
                }
                else{
                    strRate = [NSString stringWithFormat:@"$%@",[[[dictItem objectForKey:@"formats"]objectAtIndex:0]valueForKey:@"price"]];
                }
                
            }
        }
        if ((NSString *)[NSNull null] == strStreamName||strStreamName == nil) {
            strStreamName=@"";
        }
        if ((NSString *)[NSNull null] == strRate) {
            strRate=@"FREE";
        }
        if ((NSString *)[NSNull null] == appSubcriptionCode||appSubcriptionCode == nil) {
            appSubcriptionCode=@"";
        }
        NSLog(@"appSubcriptionCode->%@",appSubcriptionCode);
         if ((NSMutableArray *)[NSNull null] == formats){
             if(![appSubcriptionCode isEqualToString:@""]){
                 subcriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
                 if([subcriptionArray count]!=0){
                     strRate = [COMMON checkSubscriptionCode:subcriptionArray stringToFind:appSubcriptionCode];
                 }
                 
             }
             if([appSubcriptionCode isEqualToString:@""]){
                 strRate =@"Free Trial";
             }
         }
        if([appKey isEqualToString:@"free"]){
            strRate = @"FREE";
        }
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            backgroundWidth = 110;//commonWidth/3;
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, appListScrollView.frame.size.height)];
            imageViewHeight = appListScrollView.frame.size.height-60;
            imageViewWidth = backgroundView.frame.size.width/2.2;//-20;
        }
        else{
            UIDevice* device = [UIDevice currentDevice];
            
            if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
                backgroundWidth = 100;//commonWidth/3;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, appListScrollView.frame.size.height)];
                imageViewHeight = (appListScrollView.frame.size.height/2)-10;
                imageViewWidth = backgroundView.frame.size.width/2;//-20;
            }
            else{
                backgroundWidth = 100;//commonWidth/2;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, appListScrollView.frame.size.height)];
                imageViewHeight = appListScrollView.frame.size.height/2;
                imageViewWidth =backgroundView.frame.size.width/2;//-20;
            }
        }
        
        titleButtonWidth =backgroundViewWidth;
        backgroundViewWidth = backgroundView.frame.origin.x+backgroundView.frame.size.width+5;
        
        CGFloat watchNowLabelHeight;
        CGFloat watchNowLabelWidth;
        if([self isDeviceIpad]==YES){
            watchNowLabelHeight=25;
            watchNowLabelWidth = 100;
        }
        else{
            watchNowLabelHeight=15;
            watchNowLabelWidth = 80;
        }
        watchNowLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, watchNowLabelWidth, watchNowLabelHeight)];
        [watchNowLabel setTextColor:[UIColor whiteColor]];
        CGRect bounds = watchNowLabel.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        watchNowLabel.layer.mask = maskLayer;
        //[watchNowLabel setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:59.0f/255.0f blue:28.0f/255.0f alpha:0.5]];
        [watchNowLabel setText:@"watchnow"];
        watchNowLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"watchNowAppIcon"]];
        
        [watchNowLabel setTextAlignment:NSTextAlignmentCenter];
        [watchNowLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        //[backgroundView addSubview:watchNowLabel];
        
        CGFloat episodeBgImageHeightWidth=0.0f;
        CGFloat  episodeBgImageYPos=0.0f;
        if([self isDeviceIpad]==YES){
            episodeBgImageHeightWidth=100;
            episodeBgImageYPos = 15;
        }
        else{
            episodeBgImageHeightWidth=80;
            episodeBgImageYPos = 12;
        }
        
        //watchNowLabel.frame.origin.y+watchNowLabel.frame.size.height;
        UIImageView *episodeBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, episodeBgImageYPos, episodeBgImageHeightWidth, episodeBgImageHeightWidth)];
        [episodeBgImage setImage:[UIImage imageNamed:@"appBgIcon"]];
        CGFloat episodeImageHeightWidth;
        if([self isDeviceIpad]==YES){
            episodeImageHeightWidth=episodeBgImage.frame.size.height-30;
        }
        else{
            episodeImageHeightWidth=episodeBgImage.frame.size.height-30;
        }
        
        //CGFloat  episodeImageYPos = watchNowLabel.frame.origin.y+watchNowLabel.frame.size.height;
        UIImageView *episodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, episodeImageHeightWidth, episodeImageHeightWidth)];
        //[episodeImage setImageWithURL:imageUrl];
        episodeBgImage.tag = i;
        episodeBgImage.layer.cornerRadius = 8.0;
        episodeBgImage.layer.masksToBounds = YES;
        [episodeBgImage setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [episodeBgImage addGestureRecognizer:tapGesture];
        
        if(![appImageUrl isEqualToString:@""]){
            [self loadEpisodeImage:episodeImage appImageUrl:appImageUrl appName:strStreamName];
        }
        else{
            NSString* fullPath = [[[NSBundle mainBundle] bundlePath]stringByAppendingString:@"/icon_apple.png"];
            [episodeImage setImage:[UIImage imageWithContentsOfFile:fullPath]];
        }
        
        [episodeBgImage addSubview:episodeImage];
        [backgroundView addSubview:episodeBgImage];
        [backgroundView addSubview:watchNowLabel];
        
        CGFloat titleLabelHeight;
        if([self isDeviceIpad]==YES){
            titleLabelHeight=30;
        }
        else{
            titleLabelHeight=20;
        }
        CGFloat  titleLabelYPos = episodeBgImage.frame.origin.y+episodeBgImage.frame.size.height+4;
        //titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLabelYPos, backgroundView.frame.size.width-10, titleLabelHeight)];
         titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabelYPos, episodeBgImage.frame.size.width, titleLabelHeight)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:strRate];
        if([strRate containsString:@"BUY"]){
            [titleLabel setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f blue:0.0f/255.0f alpha:1]];
        }
        else{
           
            if([strRate isEqualToString:@"Subscribed"]){
                [titleLabel setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f blue:0.0f/255.0f alpha:1]];
            }
            else if([strRate isEqualToString:@"Free Trial"]){
                [[titleLabel layer] setBorderColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor]];
                [[titleLabel layer] setBorderWidth:1.5];
                [[titleLabel layer] setCornerRadius:2.0f];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
            }
            else{
                [titleLabel setBackgroundColor:[UIColor colorWithRed:19.0f/255.0f green:127.0f/255.0f blue:23.0f/255.0f alpha:1]];
            }
            
        }
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        titleLabel.numberOfLines=0;
        [backgroundView addSubview:titleLabel];
        
        [appListScrollView setContentSize:CGSizeMake(backgroundViewWidth, appListScrollView.frame.size.height)];
        [appListScrollView addSubview:backgroundView];
        
    }
    
}

-(void)loadEpisodeImage:(UIImageView*)episodeImage appImageUrl:(NSString *)appImageUrl appName:(NSString *)appName{
    if([appImageUrl containsString:@".png" ]|| [appImageUrl containsString: @".jpeg"]|| [appImageUrl containsString: @".jpg" ]){
        NSURL *imageNSURL = [NSURL URLWithString:appImageUrl];
        [episodeImage setImageWithURL:imageNSURL];// placeholderImage:[UIImage imageNamed:@"white_Bg"]];//white_Bg
        
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imageWebp = [NSString stringWithFormat:@"%@image.webp",appName];
        NSString *webPPath = [paths[0] stringByAppendingPathComponent:imageWebp];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:webPPath]){
            
            [episodeImage setImage:[UIImage imageWithWebP:webPPath]];
           
            
        } else {
            
            NSURL *imageURL = [NSURL URLWithString:appImageUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if ([imageData writeToFile:webPPath atomically:YES]) {
                uint64_t fileSize;
                fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:webPPath error:nil] fileSize];
                [UIImage imageWithWebP:webPPath completionBlock:^(UIImage *result) {
                    
                    [episodeImage setImage:result];
                    
                }failureBlock:^(NSError *error) {
                    
                    NSString* fullPath = [[[NSBundle mainBundle] bundlePath]stringByAppendingString:@"/icon_apple.png"];
                    [episodeImage setImage:[UIImage imageWithContentsOfFile:fullPath]];
                    
                    
                }];
            }
        }
    }
    
}

#pragma mark - loadLatestScrollMiddleViewData
-(void)loadLatestScrollMiddleViewData:(NSMutableArray *)latestArray{
    if([latestArray count]!=0){
        [_latestEpisodeLabel setHidden:NO];
    }else
        [_latestEpisodeLabel setHidden:YES];
    CGFloat commonWidth,backgroundViewWidth,titleButtonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    backgroundViewWidth = 5;
    titleButtonWidth = 0;
    UIView *backgroundView;
    CGFloat backgroundWidth,imageViewHeight;
    CGFloat imageViewWidth;
    
    for(int i = 0; i < [latestArray count]; i++)
    {
        NSMutableArray *tempArray = [latestArray objectAtIndex:i];
        
        NSString* strName = [tempArray valueForKey:@"name"];
        NSString* strPosterUrl;
        strPosterUrl = [tempArray valueForKey:@"poster_url"];
        NSString* airDate =[tempArray valueForKey:@"air_date"];
        
        
        if ((NSString *)[NSNull null] == strName||strName == nil) {
            strName=@"";
        }
        if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl == nil) {
            strPosterUrl=@"";
        }
        if ((NSString *)[NSNull null] == airDate||airDate == nil) {
            airDate=@"";
        }
        NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
        
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//            backgroundWidth = commonWidth/3;
//            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
//            imageViewHeight = middleScrollView.frame.size.height-60;
//            imageViewWidth = backgroundView.frame.size.width-20;
//        }
//        else{
//            UIDevice* device = [UIDevice currentDevice];
//            
//            if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
//                backgroundWidth = commonWidth/3;
//                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
//                imageViewHeight = middleScrollView.frame.size.height/2;
//                imageViewWidth = backgroundView.frame.size.width-20;
//            }
//            else{
//                backgroundWidth = commonWidth/2;
//                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
//                imageViewHeight = middleScrollView.frame.size.height/2;
//                imageViewWidth =backgroundView.frame.size.width-20;
//            }
//        }
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            backgroundWidth = 213;//180;//215;//commonWidth/3;
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
            imageViewHeight =119; //102;// 140;//middleScrollView.frame.size.height-60;
            imageViewWidth = backgroundView.frame.size.width;//-20;
        }
        else{
            backgroundWidth = 180;
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
            imageViewHeight =102;
            imageViewWidth = backgroundView.frame.size.width;
        }
        
                
        titleButtonWidth =backgroundViewWidth;
        backgroundViewWidth = backgroundView.frame.origin.x+backgroundView.frame.size.width+5;
        UIImageView *episodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imageViewWidth, imageViewHeight)];
        //[episodeImage setImageWithURL:imageUrl];
        [episodeImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        episodeImage.tag = i;
        [episodeImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(middleEpisodeAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [episodeImage addGestureRecognizer:tapGesture];
        
        
        CGFloat freeVideoLabelYPos,freeVideoLabelWidth,freeVideoLabelHeight;
        if([self isDeviceIpad]==YES){
            freeVideoLabelYPos=episodeImage.frame.size.height-27;
            freeVideoLabelWidth=(episodeImage.frame.size.width/4)-6;
            freeVideoLabelHeight = 20;
        }
        else{
            freeVideoLabelYPos=episodeImage.frame.size.height-25;
            freeVideoLabelWidth=(episodeImage.frame.size.width/4)-2;
            freeVideoLabelHeight=17;
        }
        UILabel *freeVideoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, freeVideoLabelYPos, freeVideoLabelWidth, freeVideoLabelHeight)];
        [freeVideoLabel setTextColor:[UIColor whiteColor]];
        [freeVideoLabel setText:@"Free"];
        [freeVideoLabel setTextAlignment:NSTextAlignmentCenter];
        freeVideoLabel.backgroundColor = FREE_GREEN;
        [freeVideoLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        [episodeImage addSubview:freeVideoLabel];
        
        [backgroundView addSubview:episodeImage];
        
        CGFloat  titleLabelYPos = episodeImage.frame.origin.y+episodeImage.frame.size.height+2;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabelYPos, backgroundView.frame.size.width-20, 30)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:strName];
        [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        titleLabel.numberOfLines=0;
        [backgroundView addSubview:titleLabel];
        
        CGFloat  airDateLabelYPos = titleLabel.frame.origin.y+titleLabel.frame.size.height+1;
        UILabel *airDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, airDateLabelYPos, backgroundView.frame.size.width-20, 30)];
        [airDateLabel setTextColor:[UIColor whiteColor]];
        if (airDate==nil||[airDate isEqual:@""])
            [airDateLabel setText:[NSString stringWithFormat:@"%@", airDate]];
        else {
            NSString *myString = airDate;
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDate *yourDate = [dateFormatter dateFromString:myString];
            dateFormatter.dateFormat = @"MMM. dd, yyyy";//dd-MMM-yyyy
            [airDateLabel setText:[NSString stringWithFormat:@"(%@)", [dateFormatter stringFromDate:yourDate]]];
        }
        [airDateLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        [backgroundView addSubview:airDateLabel];
       
        [middleScrollView setContentSize:CGSizeMake(backgroundViewWidth, middleScrollView.frame.size.height)];
        [middleScrollView addSubview:backgroundView];
        middleScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [middleScrollView setShowsHorizontalScrollIndicator:YES];
        middleScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
    }
    
}

-(void)loadTableHeaderView{
    
    [appListHeaderView removeFromSuperview];
    appListHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,100)];
    [appListHeaderView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *appListTopBorder;
    appListTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,appListView.frame.size.width,1.5)];
   // appListTopBorder.backgroundColor = [COMMON Common_Light_BG_Color];//blue
    
    appListTopBorder.backgroundColor =[COMMON Common_Light_BG_Color];

    
    [appListTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    //[appListView addSubview:appListTopBorder];
    
    
    CGFloat freeRentViewWidth;
    if([self isDeviceIpad]==YES){
        freeRentViewWidth = appListHeaderView.frame.size.width/2.5;
    }
    else{
        freeRentViewWidth = appListHeaderView.frame.size.width/2;
    }
    UIView *freeRentView = [[UIView alloc]initWithFrame:CGRectMake(0,0, freeRentViewWidth,50)];
    [freeRentView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat commonLabelYpos=10,freeSwitchYPos=5;;
    if([self isDeviceIpad]==YES){
        commonLabelYpos=15;
        freeSwitchYPos=9;
        freeLabelWidth=freeRentView.frame.size.width/3.8;
        rentLabelWidth=freeRentView.frame.size.width/2.4;
        commonSDBtnWidth=45;
        commonSDBtnHeight=30;
        
    }
    else{
        commonLabelYpos=12;
        freeSwitchYPos=5;
        freeLabelWidth=freeRentView.frame.size.width/3.8;
        rentLabelWidth=freeRentView.frame.size.width/2.4;
        commonSDBtnWidth=40;
        commonSDBtnHeight=25;
    }

    
    freeLabel = [[UILabel alloc]init];
    
    [freeLabel setFrame:CGRectMake(0, commonLabelYpos, freeLabelWidth, 20)];
    freeLabel.text = @"FREE";
    [freeLabel setTextAlignment:NSTextAlignmentRight];
    [freeLabel setBackgroundColor:[UIColor clearColor]];
    [freeLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [freeLabel setFont:[COMMON getResizeableFont:Roboto_Bold(5)]];
    
    freeRentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, commonLabelYpos, freeRentView.frame.size.width-20, 25)];
    [freeRentLabel setTextAlignment:NSTextAlignmentLeft];
    [freeRentLabel setBackgroundColor:[UIColor clearColor]];
    [freeRentLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];

    
    int installSwitchXPos = (freeLabel.frame.origin.x+freeLabel.frame.size.width);
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(installSwitchXPos, freeSwitchYPos, 30, 40)];
    
    [freeSwitch addTarget: self action: @selector(flipSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [freeSwitch setOnTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [freeSwitch setOn:NO];
    //[freeSwitch sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    int rentLabelXPos = (freeSwitch.frame.origin.x+freeSwitch.frame.size.width);
    rentLabel = [[UILabel alloc]initWithFrame:CGRectMake(rentLabelXPos, commonLabelYpos, rentLabelWidth, 20)];
    rentLabel.text = @"BUY/RENT";
    [rentLabel setTextAlignment:NSTextAlignmentLeft];
    [rentLabel setBackgroundColor:[UIColor clearColor]];
    [rentLabel setTextColor:[COMMON Common_Light_BG_Color]];//[COMMON Common_Light_BG_Color]];
    [rentLabel setFont:[COMMON getResizeableFont:Roboto_Bold(5)]];
    
    CGFloat btnViewXPos = (freeRentView.frame.origin.x + freeRentView.frame.size.width);
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(btnViewXPos,0, screenWidth/2,40)];
    
    sdBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, commonSDBtnWidth, commonSDBtnHeight)];
    [sdBtn setTitle:@"SD" forState:UIControlStateNormal];
    sdBtn.layer.borderWidth = 2.0f;
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;//[COMMON Common_Light_BG_Color].CGColor;
    sdBtn.layer.cornerRadius = 2.0f;
    sdBtn.clipsToBounds = YES;
    //[sdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
     [sdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    
    
    sdBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    sdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [sdBtn addTarget:self action:@selector(SDAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat hdBtnXPos = (sdBtn.frame.origin.x + sdBtn.frame.size.width+2);
    hdBtn = [[UIButton alloc]initWithFrame:CGRectMake(hdBtnXPos, 10, commonSDBtnWidth, commonSDBtnHeight)];
    [hdBtn setTitle:@"HD" forState:UIControlStateNormal];
    hdBtn.layer.borderWidth = 2.0f;
    hdBtn.layer.borderColor =[COMMON Common_Light_BG_Color].CGColor;
    hdBtn.layer.cornerRadius = 2.0f;
    hdBtn.clipsToBounds = YES;
    [hdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    hdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [hdBtn addTarget:self action:@selector(HDAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat hdxBtnXPos = (hdBtn.frame.origin.x + hdBtn.frame.size.width+2);
    hdxBtn = [[UIButton alloc]initWithFrame:CGRectMake(hdxBtnXPos,10, commonSDBtnWidth, commonSDBtnHeight)];
    [hdxBtn setTitle:@"HDX" forState:UIControlStateNormal];
    hdxBtn.layer.borderWidth = 2.0f;
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    hdxBtn.layer.cornerRadius = 2.0f;
    hdxBtn.clipsToBounds = YES;
    [hdxBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    hdxBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    hdxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [hdxBtn addTarget:self action:@selector(HDXAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        freeLabel.font = [COMMON getResizeableFont:Roboto_Bold(17)];
        rentLabel.font = [COMMON getResizeableFont:Roboto_Bold(17)];
        [freeRentLabel setFont:[COMMON getResizeableFont:Roboto_Bold(17)]];
        freeSwitch.transform = CGAffineTransformMakeScale(0.90,0.90);
    }
    else{
        freeLabel.font = [COMMON getResizeableFont:Roboto_Bold(13)];
        rentLabel.font = [COMMON getResizeableFont:Roboto_Bold(13)];
        [freeRentLabel setFont:[COMMON getResizeableFont:Roboto_Bold(13)]];
        freeSwitch.transform = CGAffineTransformMakeScale(0.80,0.80);
    }
    
    [freeRentView addSubview:freeLabel];
    [freeRentView addSubview:freeSwitch];
    [freeRentView addSubview:rentLabel];
    [freeRentView addSubview:freeRentLabel];
    [btnView addSubview:sdBtn];
    [btnView addSubview:hdBtn];
    [btnView addSubview:hdxBtn];
    [sdBtn setHidden:YES];
    [hdBtn setHidden:YES];
    [hdxBtn setHidden:YES];
    [freeLabel setHidden:YES];
    [freeSwitch setHidden:YES];
    [rentLabel setHidden:YES];
    
//    [btnView setBackgroundColor:[UIColor lightGrayColor]];
//    [rentLabel setBackgroundColor:[UIColor grayColor]];
//    [freeLabel setBackgroundColor:[UIColor grayColor]];
//    [appListHeaderView setBackgroundColor:[UIColor redColor]];

    
    [appListHeaderView addSubview:freeRentView];
    [appListHeaderView addSubview:btnView];
    [appListView addSubview:appListHeaderView];
    
    
    
}
#pragma mark - checkFormattedPriceForAppBtn
-(void)checkFormattedPriceForAppBtn{
    BOOL isSD,isHD,isHDX;
    for(NSDictionary * showItems in appShowAllItems){
        NSMutableArray * formats=[showItems objectForKey:@"formats"];
        if ((NSMutableArray *)[NSNull null] != formats){
            for(NSDictionary * anEntry in formats)
            {
                NSString * url = [anEntry objectForKey:@"format"];
                if([url containsString: @"SD"]){
                    isSD=YES;
                    [sdBtn setHidden:NO];
                    
                }
                else if([url containsString: @"HD"]){
                    isHD=YES;
                    [hdBtn setHidden:NO];
                }
                else if([url containsString: @"HDX"]){
                    isHDX=YES;
                    [hdxBtn setHidden:NO];
                }
                else{
                    isSD=NO;isHD=NO;isHDX=NO;
                    [sdBtn setHidden:YES];
                    [hdBtn setHidden:YES];
                    [hdxBtn setHidden:YES];
                }
            }
        }
        else{
            isSD=NO;isHD=NO;isHDX=NO;
            [sdBtn setHidden:YES];
            [hdBtn setHidden:YES];
            [hdxBtn setHidden:YES];
        }
    }
    
}

-(void)SDAction:(id)sender{
    [sdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [COMMON Common_Light_BG_Color].CGColor;
    
    [hdxBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    isSDClicked  = YES;
    isHDClicked  = NO;
    isHDXClicked = NO;
   [self loadMovieLatestAppListScrollViewData:appShowAllItems];
}
-(void)HDAction:(id)sender{
    [sdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [COMMON Common_Light_BG_Color].CGColor;
    
    [hdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdxBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    isSDClicked  = NO;
    isHDClicked  = YES;
    isHDXClicked = NO;
    [self loadMovieLatestAppListScrollViewData:appShowAllItems];
}
-(void)HDXAction:(id)sender{
    [sdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdBtn setTitleColor:[COMMON Common_Light_BG_Color] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [COMMON Common_Light_BG_Color].CGColor;
    isSDClicked  = NO;
    isHDClicked  = NO;
    isHDXClicked = YES;
    [self loadMovieLatestAppListScrollViewData:appShowAllItems];
}

#pragma mark - switch flip action
- (IBAction) flipSwitch: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    if (onoff.on){
        //PAID
        appShowAllItems =[[NSMutableArray alloc]init];
        appShowAllItems = appPaidItems;
        freeRentStr =@"Paid";
        
    }
    else {
        //FREE
        appShowAllItems =[[NSMutableArray alloc]init];
        appShowAllItems = appFreeItems;
        freeRentStr =@"Free";
        
        
    }
    [self loadMovieLatestAppListScrollViewData:appShowAllItems];
}

-(void) setUpAllViews{
    
    [_genreLabel setHidden:YES];
    _castTableView.delegate = self;
    _castTableView.dataSource = self;
    [_castTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CastLandCell"];
    [_castTableView setHidden:YES];
    _castTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_castTableView setBackgroundColor:[UIColor clearColor]];
    
    [_overViewBtn setTitle:@"Free" forState:UIControlStateNormal];
    [_castBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
    [_genreBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
   // [_overViewBtn setUserInteractionEnabled:NO];
   // [_castBtn setUserInteractionEnabled:NO];
    //[_genreBtn setUserInteractionEnabled:NO];
    [_textView setHidden:YES];
    [_castTableView setHidden:YES];
    [_appListGridView setHidden:NO];
    _overViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _castBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _genreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self setUpButtonAction];
    
}
#pragma mark - setUpButtonAction
-(void) setUpButtonAction{
    [_watchTrailerButton addTarget:self action:@selector(onTrailers:) forControlEvents:UIControlEventTouchUpInside];
    [_watchNowButton addTarget:self action:@selector(getMovieWatchNowNewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_watchNowButton setBackgroundImage:[UIImage imageNamed:@"orangeBtn"] forState:UIControlStateNormal];
    [_overViewBtn addTarget:self action:@selector(loadfreeBtnItems) forControlEvents:UIControlEventTouchUpInside];
    [_castBtn addTarget:self action:@selector(loadAllEpisodesBtnItems) forControlEvents:UIControlEventTouchUpInside];
    [_genreBtn addTarget:self action:@selector(loadAllSeasonBtnItems) forControlEvents:UIControlEventTouchUpInside];
    
    [_overViewBtn setBackgroundColor:[UIColor clearColor]];
    [_castBtn setBackgroundColor:[UIColor clearColor]];
    [_genreBtn setBackgroundColor:[UIColor clearColor]];
    
    [[_watchTrailerButton layer] setBorderColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor]];
    [[_watchTrailerButton layer] setBorderWidth:1.5];
    [[_watchTrailerButton layer] setCornerRadius:2.0f];
    [_watchTrailerButton setHidden:YES];
    [_watchNowButton setHidden:YES];
    
}
- (void)getEpisodeData:(int)nShowID seasonId:(int)nSeasonId episodeId:(int)nEpisodeId{
    
    [[RabbitTVManager sharedManager] getShowLinkList:^(AFHTTPRequestOperation * request, id responseObject) {
        showLinkDictionary = (NSDictionary*) responseObject;
        NSLog(@"dictionary%@",showLinkDictionary);
        [self setShowLinkList];
        [self.lastBottomView setHidden:NO];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
    }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.watchNowButton setHidden:YES];
        [self.lastBottomView setHidden:YES];
        // [AppCommon showSimpleAlertWithMessage:@"No Data"];
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nShowID:nShowID nSeasonId:nSeasonId nEpisodeId:nEpisodeId];
}
-(void) setShowLinkList{
    NSLog(@"internal%@",showLinkDictionary[@"internal"]);
    EpisodeArray = [showLinkDictionary[@"internal"]objectForKey:@"paid"];
    NSLog(@"episode dict%@",EpisodeArray);
    NSLog(@"paid%@",showLinkDictionary[@"paid"]);
    if(showLinkDictionary[@"mobile"] != nil  &&
       showLinkDictionary[@"mobile"][@"ios"] != nil &&
       showLinkDictionary[@"mobile"][@"ios"][@"paid"] != nil ){
        paidItems = showLinkDictionary[@"mobile"][@"ios"][@"paid"];
        if(isToggledFree!=YES){
            iosAppPaidItems = (NSMutableArray *)paidItems;
        }
        if([paidItems count]==0){
        }
    }
    if(showLinkDictionary[@"mobile"] != nil  &&
       showLinkDictionary[@"mobile"][@"ios"] != nil &&
       showLinkDictionary[@"mobile"][@"ios"][@"free"] != nil ){
        if(isPushedFromPayPerView!=YES){
            paidItems = showLinkDictionary[@"mobile"][@"ios"][@"free"];
             iosAppFreeItems = (NSMutableArray *)paidItems;
        }
        if([paidItems count]==0){
            
        }
    }
    
    if([iosAppFreeItems count]!=0){
        iosAppFreeItems = [self addFreePaidKeyToArray:iosAppFreeItems key:@"free"];
    }
    if([iosAppPaidItems count]!=0){
         iosAppPaidItems = [self addFreePaidKeyToArray:iosAppPaidItems key:@"paid"];
    }
    
    
    
    //appShowAllItems = appFreeItems;
    appShowAllItems =[[NSMutableArray alloc]init];
    appPaidItems =  [self checkformatsArrayInAppList:iosAppPaidItems];//iosAppPaidItems
    if(isPushedFromPayPerView!=YES){
        NSMutableArray * tempFreeArray = [NSMutableArray new];
        if ([iosAppPaidItems count]!=0) {
            if([paidNullArray count]!=0){
                tempFreeArray = [[iosAppFreeItems arrayByAddingObjectsFromArray:paidNullArray] mutableCopy];
                appFreeItems = tempFreeArray;
            }
            else{
                appFreeItems = iosAppFreeItems;
            }
        }
        else{
            appFreeItems = iosAppFreeItems;//[self checkformatsArrayInAppList:iosAppFreeItems];
            
        }
    }
    
    appShowAllItems = appPaidItems;
    [_appListGridView reloadData];
    NSLog(@"paidItems%@",paidItems);
    
    [appListView setHidden:YES];
    
    [self loadAppListViewDesign];
    
    if([appPaidItems count]==0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:YES];
    }
    if([appPaidItems count]!=0 && [appFreeItems count]==0){
        [freeLabel setHidden:YES];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:NO];
        freeRentLabel.text = @"BUY/RENT";
    }
    
    if([appPaidItems count]!=0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:NO];
        [rentLabel setHidden:NO];
        [freeRentLabel setHidden:YES];
    }
    
  
    if((paidItems.count)!=0){
        if((paidItems.count)!=0 && paidItems != nil){
            
            //[_watchNowButton setHidden:NO];
        }
        else{
            //[_watchNowButton setHidden:YES];
        }
        
    }
    
}
#pragma mark - addFreePaidKeyToArray
-(NSMutableArray*)addFreePaidKeyToArray:(NSMutableArray*)freePadiArray key:(NSString*)key{
    
    NSMutableArray *newListArray = [NSMutableArray new];
    
    for(NSDictionary * tempDict in freePadiArray){
        NSMutableDictionary * freePaidDict = [tempDict mutableCopy];
        [freePaidDict setObject:key forKey:@"key"];
        [newListArray addObject:freePaidDict];
    }
    
    return newListArray;
}


#pragma mark - checkformatsArrayInAppList
-(NSMutableArray*)checkformatsArrayInAppList:(NSMutableArray *)currentAppListArray{

    NSMutableArray *newListArray = [NSMutableArray new];
    paidNullArray = [NSMutableArray new];
    if([currentAppListArray count]!=0){
        for(NSDictionary * showItems in currentAppListArray){
            NSMutableArray * formats=[showItems objectForKey:@"formats"];
            if ((NSMutableArray *)[NSNull null] != formats){
                [newListArray addObject:showItems];
                NSLog(@"showItems%@",showItems);
            }
            else{
                [paidNullArray addObject:showItems];
                NSLog(@"showItems%@",showItems);
            }
        }

    }
    return newListArray;
}

-(void)loadAppListViewDesign{
    
    if(isTrailerHidden==YES){
        _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
    }
    else{
        _topFullViewHeightConstraint.constant = detailFullViewHeight;
    }
    
    
    if([appFreeItems count]==0){
        if([appPaidItems count]!=0){
            appShowAllItems = appPaidItems;
            freeRentStr =@"Paid";
            _appListHeightConstraint.constant = appListScrollHeight;
            _appListViewHeightConstraint.constant = appListViewHeight;
             NSInteger nCount = [appShowAllItems count];
            if(nCount == 1){
                [_watchNowButton setHidden:NO];
                _appListHeightConstraint.constant = 0;
                _appListViewHeightConstraint.constant = 0;
                [appListView setHidden:YES];
            }
            else{
                _watchBtnHeightConstraint.constant = 0;
                [_watchNowButton setHidden:YES];
                 [appListView setHidden:NO];
                [self loadMovieLatestAppListScrollViewData:appShowAllItems];
            }
            
            
        }
        else{
            [_watchNowButton setHidden:YES];
            _appListViewHeightConstraint.constant=0;
            [appListView setHidden:YES];
            
            if(appShowAllItems.count==0) {
                _appListHeightConstraint.constant = 0;
                _appListViewHeightConstraint.constant = 0;
            } else {
                _appListHeightConstraint.constant = appListScrollHeight;
                _appListViewHeightConstraint.constant = appListViewHeight;
            }
        }
    }
    else{
        if([appFreeItems count]!=0 && [appPaidItems count]!=0){
            appShowAllItems = appFreeItems;
            freeRentStr =@"Free";
            _appListHeightConstraint.constant = appListScrollHeight;
            _appListViewHeightConstraint.constant = appListViewHeight;
           // NSInteger nCount = [appShowAllItems count];
            
//            if(nCount == 1){
//                [_watchNowButton setHidden:NO];
//                _appListHeightConstraint.constant = 0;
//                _appListViewHeightConstraint.constant = 0;
//                [appListView setHidden:YES];
//            }
//            else{
             _watchBtnHeightConstraint.constant = 0;
                [_watchNowButton setHidden:YES];
                [appListView setHidden:NO];
                 [self loadMovieLatestAppListScrollViewData:appShowAllItems];
            //}
           
        }
        else if([appFreeItems count]!=0 && [appPaidItems count]==0){
            appShowAllItems = appFreeItems;
            freeRentStr =@"Free";
            _appListHeightConstraint.constant = appListScrollHeight;
            _appListViewHeightConstraint.constant = appListViewHeight;
            NSInteger nCount = [appShowAllItems count];
            if(nCount == 1){
                [_watchNowButton setHidden:NO];
                _appListHeightConstraint.constant = 0;
                _appListViewHeightConstraint.constant = 0;
                [appListView setHidden:YES];
            }
            else{
                 _watchBtnHeightConstraint.constant = 0;
                [_watchNowButton setHidden:YES];
                [appListView setHidden:NO];
                [self loadMovieLatestAppListScrollViewData:appShowAllItems];
            }
            
        }
        else{
             _watchBtnHeightConstraint.constant = 0;
            [_watchNowButton setHidden:YES];
            _appListViewHeightConstraint.constant=0;
            [appListView setHidden:YES];
        }
    }

}
-(void) loadEpisodeDetails{
    int nEpisodeId = self.episodeId.intValue;
    [[RabbitTVManager sharedManager] getEpisodeDetail:^(AFHTTPRequestOperation *request, id responseObject) {
        {
            episodeDetailDictionary = (NSDictionary*) responseObject;
            [self setShowDetail];
        }
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nID:nEpisodeId];
}
- (void) setIfMovies:(BOOL)bMovies
{
    m_boolMovies = bMovies;
}

- (void)loadData {
    int nMovieID = self.nID.intValue;
    int nPPV;
    if(isPushedFromPayPerView==YES){
        nPPV =PAY_MODE_PAID;
    }
    else{
        if(isToggledAll==YES)
            nPPV =PAY_MODE_ALL;
        else
            nPPV =PAY_MODE_FREE;
    }

    [COMMON LoadIcon:self.view];
    [self performSelector:@selector(removeLoadingIconInView) withObject:nil afterDelay:3];
    if(m_boolMovies){
        
        [[RabbitTVManager sharedManager] getMovieDetail:^(AFHTTPRequestOperation *request, id responseObject) {
            movieDetailDictionary = (NSDictionary*) responseObject;
            [self setMovieDetail];
            [self.iPhoneScrollView setHidden:NO];
            [self.detailFullView setHidden:NO];
            [self.leftTopHalfView setHidden:NO];
            [self.middleView setHidden:NO];
            [self.lastBottomView setHidden:NO];
            [self.appListView setHidden:NO];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //[self.watchTrailerButton setHidden:YES];
            [self.iPhoneScrollView setHidden:YES];
            [self.detailFullView setHidden:YES];
            [self.leftTopHalfView setHidden:YES];
            [self.middleView setHidden:YES];
            [self.lastBottomView setHidden:YES];
            [self.appListView setHidden:YES];
            [AppCommon showSimpleAlertWithMessage:@"No Data"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
        } nMovieID:nMovieID nPPV:nPPV];
    }else{
        
        [[RabbitTVManager sharedManager] getShowDetail:^(AFHTTPRequestOperation *request , id responseObject) {
            
            showDetailDictionary = (NSDictionary*) responseObject;
            NSLog(@"showDetailDictionary%@",showDetailDictionary);
            if(isEpisode==YES){
                [self loadEpisodeDetails];
            }else{
                [self setShowDetail];
            }
            [self performSelector:@selector(loadEpisodeDetailFirstTime) withObject:nil afterDelay:1];
            [self.iPhoneScrollView setHidden:NO];
            [self.detailFullView setHidden:NO];
            [self.leftTopHalfView setHidden:NO];
            [self.middleView setHidden:NO];
            //[self.lastBottomView setHidden:NO];
             [self.appListView setHidden:NO];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
        }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //[self.watchTrailerButton setHidden:YES];
            [self.iPhoneScrollView setHidden:YES];
            [self.detailFullView setHidden:YES];
            [self.leftTopHalfView setHidden:YES];
            [self.middleView setHidden:YES];
            [self.lastBottomView setHidden:YES];
            [self.appListView setHidden:YES];
            [AppCommon showSimpleAlertWithMessage:@"No Data"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
        }nShowID:nMovieID];
    }
    
}
-(void)removeLoadingIconInView{
    [COMMON removeLoading];
}
-(void)loadEpisodeDetailFirstTime{
    [self getEpisodeData:[nID intValue] seasonId:[_seasonId intValue] episodeId:[_episodeId intValue]];
    

}
#pragma mark - Setting Movie and Show Details
-(void) setMovieDetail{
    self.linksTrailer = (NSMutableArray*)movieDetailDictionary[@"trailers"];
    watchTrailerArray = (NSMutableArray*)movieDetailDictionary[@"trailers"];
    
    //NSString* strName =movieDetailDictionary[@"name"];
    NSString* strDescription = movieDetailDictionary[@"description"];
    NSString* strPosterUrl = movieDetailDictionary[@"poster_url"];
    NSString* strRating = movieDetailDictionary[@"rating"];
    NSMutableDictionary* networkDict = showDetailDictionary[@"network"];
    NSString* strNetwork;
    
    if ((NSMutableDictionary *)[NSNull null] != networkDict){
        strNetwork = [networkDict objectForKey:@"name"];
    }
    else
        strNetwork = @"";
    NSString *strRunTime = [NSString stringWithFormat: @"%@", movieDetailDictionary[@"runtime"]];
    NSURL * urlPoster = [NSURL URLWithString:strPosterUrl];
    if( movieDetailDictionary[@"sources"] != nil  &&
       movieDetailDictionary[@"sources"][@"mobile"] != nil &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"] != nil    &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"paid"] != nil ){
        paidItems = movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"paid"];
        appPaidItems = (NSMutableArray *)paidItems;
        if([paidItems count]==0){
            if( movieDetailDictionary[@"sources"] != nil  &&
               movieDetailDictionary[@"sources"][@"mobile"] != nil &&
               movieDetailDictionary[@"sources"][@"mobile"][@"ios"] != nil    &&
               movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"free"] != nil ){
                paidItems = movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"free"];
                appFreeItems = (NSMutableArray *)paidItems;
            }
        }
        
        
        // [self setUpButtonAppearence];
    }
    
   // [_watchNowButton setHidden:YES];
    
    if((paidItems.count)!=0){
        if((paidItems.count)!=0 && paidItems != nil){
            
        }
        else{
            
        }
        
    }
    // appShowAllItems = appFreeItems;
    appShowAllItems =[[NSMutableArray alloc]init];
    [appShowAllItems addObjectsFromArray:appFreeItems];
    [appShowAllItems addObjectsFromArray:appPaidItems];
    [_appListGridView reloadData];
    NSLog(@"paidItems%@",paidItems);
    if(![watchTrailerArray isEqual:[NSNull null]])  {
        if((watchTrailerArray.count)!=0 || watchTrailerArray != (id) [NSNull null] ) {//
            if([[watchTrailerArray objectAtIndex:0]  isEqual:@""]){
                [_watchTrailerButton setHidden:YES];
                isTrailerHidden=YES;
            }
            else{
                
                [_watchTrailerButton setHidden:NO];
                isTrailerHidden=YES;
            }
        }
        else{
            [_watchTrailerButton setHidden:YES];
            isTrailerHidden=YES;
        }
    }
     if(isTrailerHidden==YES){
        _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
    }
    else{
        _topFullViewHeightConstraint.constant = detailFullViewHeight;
    }

    strPosterUrl = movieDetailDictionary[@"poster_url"];
    
    
    if ((NSString *)[NSNull null] == strRating || strRating == nil) {
        strRating=@"";
    }
    if ((NSString *)[NSNull null] == strRunTime || strRunTime == nil) {
        strRunTime=@"";
    }
    if([strRunTime isEqualToString:@"0"]||[strRunTime isEqualToString:@""]){
        strRunTime =@"N/A";
    }
    else{
        strRunTime = [NSString stringWithFormat:@"%@Minutes",strRunTime];
    }
    if ((NSString *)[NSNull null] == strDescription || strDescription == nil) {
        strDescription=@"";
    }
    NSString *currentNetwork=@"";
    if(![strNetwork isEqualToString:@""]){
        currentNetwork= [NSString stringWithFormat:@"Network: %@",strNetwork];
    }
    NSString *ratingNetworkStr = [NSString stringWithFormat:@"Runtime: %@ %@", strRunTime,currentNetwork];
    
    [self.runTimeLabel setText:ratingNetworkStr];
    
    if(![strRating isEqualToString:@""]){
        [self.ratingLabel setText:[NSString stringWithFormat:@"%@", strRating]];
       // [_ratingLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:186.0/255.0f alpha:1]];
        [_ratingLabel setBackgroundColor:[COMMON Common_Light_BG_Color]];
        
    }
    _runTimeLabel.textColor = [UIColor whiteColor];
    _ratingLabel.textColor = [UIColor whiteColor];
    [_ratingLabel setTextAlignment:NSTextAlignmentCenter];
    [_ratingLabel setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [_runTimeLabel setTextAlignment:NSTextAlignmentLeft];
    
    if([strRating isEqualToString:@""]&&[strNetwork isEqualToString:@""]){
        [_runTimeLabel setTextAlignment:NSTextAlignmentCenter];
    }

    [_landScapeImageView setHidden:YES];
    [self.portraitImageView setImageWithURL:urlPoster];
    //    if(isEpisode==YES){
    //        [self.landScapeImageView setImageWithURL:urlPoster];
    //
    //    }
    //    else{
    //    }
    
    //[self.episodeTextView setText:[NSString stringWithFormat:@"OverView : %@", strDescription]];
    NSString *overViewText = [NSString stringWithFormat:@"OVERVIEW : %@", strDescription];
    [self setttingUpDespLabel:overViewText];
    
    
}

-(void) setShowDetail{
    
    self.linksTrailer = (NSMutableArray*)showDetailDictionary[@"trailers"];
    watchTrailerArray = (NSMutableArray*)showDetailDictionary[@"trailers"];
    arrayCast = showDetailDictionary[@"actors"];
    //NSString* strName =showDetailDictionary[@"name"];
    NSString* strDescription;
    if(isEpisode==YES){
        strDescription = episodeDetailDictionary[@"description"];
        //if([strDescription isEqualToString:@""])
        //strDescription = showDetailDictionary[@"description"];
    }else{
        strDescription = showDetailDictionary[@"description"];
    }
    
    NSString* strPosterUrl;
    if((watchTrailerArray.count)!=0 && watchTrailerArray != (id) [NSNull null]) {
        if([[watchTrailerArray objectAtIndex:0]  isEqual:@""]){
            
            [_watchTrailerButton setHidden:YES];
            isTrailerHidden=YES;
        }
        else{
            [_watchTrailerButton setHidden:NO];
            isTrailerHidden=NO;
        }
        
    }
    else{
        [_watchTrailerButton setHidden:YES];
        isTrailerHidden=YES;
    }
    if(isEpisode==YES){
        strPosterUrl = episodeDetailDictionary[@"poster_url"];
    }
    else{
        strPosterUrl = showDetailDictionary[@"poster_url"];
    }
    NSString* strRating = showDetailDictionary[@"rating"];
    NSMutableDictionary* networkDict = showDetailDictionary[@"network"];
    NSString* strNetwork;
    
    if ((NSMutableDictionary *)[NSNull null] != networkDict){
        strNetwork = [networkDict objectForKey:@"name"];
    }
    else
        strNetwork = @"";
    NSString *strRunTime = [NSString stringWithFormat: @"%@", showDetailDictionary[@"runtime"]];
    
    if ((NSString *)[NSNull null] == strRating || strRating == nil) {
        strRating=@"";
    } 
    if ((NSString *)[NSNull null] == strRunTime || strRunTime == nil) {
        strRunTime=@"";
    }
    if ((NSString *)[NSNull null] == strNetwork || strNetwork == nil) {
        strNetwork=@"";
    }
    NSURL * urlPoster = [NSURL URLWithString:strPosterUrl];
    
    if([strRunTime isEqualToString:@"0"]||[strRunTime isEqualToString:@""]){
        strRunTime =@"N/A";
    }
    else{
        strRunTime = [NSString stringWithFormat:@"%@Minutes",strRunTime];
    }
    if ((NSString *)[NSNull null] == strDescription || strDescription == nil) {
        strDescription=@"";
    }
    NSString *currentNetwork=@"";
    if(![strNetwork isEqualToString:@""]){
        currentNetwork= [NSString stringWithFormat:@"Network: %@",strNetwork];
    }
    NSString *ratingNetworkStr = [NSString stringWithFormat:@"Runtime: %@ %@", strRunTime,currentNetwork];
    
    [self.runTimeLabel setText:ratingNetworkStr];
    
    if(![strRating isEqualToString:@""]){
        [self.ratingLabel setText:[NSString stringWithFormat:@"%@", strRating]];
        //[_ratingLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:186.0/255.0f alpha:1]];
        [_ratingLabel setBackgroundColor:[COMMON Common_Light_BG_Color]];
    }
    [_ratingLabel setTextAlignment:NSTextAlignmentCenter];
    [_ratingLabel setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    _runTimeLabel.textColor = [UIColor whiteColor];
    _ratingLabel.textColor = [UIColor whiteColor];
    [_runTimeLabel setTextAlignment:NSTextAlignmentLeft];
    
    if([strRating isEqualToString:@""]&&[strNetwork isEqualToString:@""]){
       [_runTimeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
   
    if(isEpisode==YES){
        [self.landScapeImageView setImageWithURL:urlPoster];
        
    }
    else{
        [self.landScapeImageView setImageWithURL:urlPoster];
        
    }
    
   
    NSString *overViewText = [NSString stringWithFormat:@"OVERVIEW : %@", strDescription];
    [self setttingUpDespLabel:overViewText];
    

}

-(void)setttingUpDespLabel:(NSString*)strDescription{
    [despLabel setUserInteractionEnabled:YES];
    
    
    DespHeight = despLabel.frame.size.height;
    [despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
    despLabel.textColor = [UIColor whiteColor];
    despLabel.numberOfLines=0;
    strDescriptionText = strDescription;
    
    [despLabel setBackgroundColor:[UIColor clearColor]];
    
    [self setupStoreTitleLabel];
    
}

#pragma mark - setupStoreTitleLabel
- (void) setupStoreTitleLabel {
    despLabel.delegate = self;
    [self.despLabel setText:strDescriptionText];
    [self.despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
    self.despLabel.numberOfLines = 2;
    NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@" more..." attributes:@{
                                                                                                       NSForegroundColorAttributeName:[COMMON Common_Light_BG_Color],NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],NSLinkAttributeName : [NSURL URLWithString:@"more..."]}];
    
    [despLabel setAttributedTruncationToken:showMore];
     if([self isDeviceIpad]==YES) {
         _rightViewIpadHeightConstraint.constant = DespHeight+10;
     }
     else {
         _rightViewIphoneHeightConstraint.constant = DespHeight+20;
     }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"%@ pressed", url);
    if ([[url absoluteString] isEqualToString:@"more..."]) {
        NSLog(@"'Read More'...");
        
        despLabel.numberOfLines = 99;//0;//99;
        
        NSString *despTextWithLess = [NSString stringWithFormat:@"%@ %@",strDescriptionText, @" less..."];
        CGRect rect = [despTextWithLess boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: label.font}
                                                     context:nil];
        
        
//        CGFloat detailViewHeightBasedOnTrailer=0.0f;
        
//        if(isTrailerHidden==YES){
//            _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
//            detailViewHeightBasedOnTrailer = _topFullViewHeightConstraint.constant;
//        }
//        else{
//            _topFullViewHeightConstraint.constant = detailFullViewHeight;
//            detailViewHeightBasedOnTrailer = _topFullViewHeightConstraint.constant;
//        }
        
        _despLabelHeight.constant = rect.size.height+20;
        _rightViewIpadHeightConstraint.constant = rect.size.height+20;
        
        if([self isDeviceIpad]==YES){
            
            CGFloat contentHeight =   _despLabelHeight.constant + 80;
            if(detailFullViewHeight < contentHeight) {
                CGFloat height = contentHeight - detailFullViewHeight;
                _rightViewIpadHeightConstraint.constant = rect.size.height+50;
                _topFullViewHeightConstraint.constant = detailFullView.size.height+height;
            }
            else{
                if(isTrailerHidden==YES)
                    _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
                else
                   _topFullViewHeightConstraint.constant = detailFullViewHeight;
            }

    
//            if(detailFullViewHeight < contentHeight){
//               
//                _topFullViewHeightConstraint.constant = detailViewHeightBasedOnTrailer + rect.size.height/2;
//                
//            }
//            else{
//                _topFullViewHeightConstraint.constant = detailViewHeightBasedOnTrailer;
//            }
            
        }
        else{
            _despLabelHeight.constant = rect.size.height;
            _rightViewIphoneHeightConstraint.constant =  rect.size.height+20;
  
        }
        

        //[self.view layoutIfNeeded];
        
        
        [despLabel setText:despTextWithLess afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            //code
            NSRange linkRange = [[mutableAttributedString string] rangeOfString:@" less..." options:NSCaseInsensitiveSearch];
            
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[COMMON Common_Light_BG_Color] range:linkRange];
            [mutableAttributedString addAttribute:NSFontAttributeName value:[COMMON getResizeableFont:Roboto_Regular(11)] range:linkRange];
            [mutableAttributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"less..."] range:linkRange];
            
            return mutableAttributedString;
        }];
        
        
        
        NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@" less..." attributes:@{
                                                                                                           NSForegroundColorAttributeName:[COMMON Common_Light_BG_Color],
                                                                                                           NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],
                                                                                                           NSLinkAttributeName : [NSURL URLWithString:@"less..."]
                                                                                                           }];
        

        
        [despLabel setAttributedTruncationToken:showMore];

    }
    else {
        [self addLessToString];
    }
}
#pragma mark - addLessToString
-(void)addLessToString{
    despLabel.numberOfLines = 2;
    NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@" more..." attributes:@{
                                                                                                       NSForegroundColorAttributeName:[COMMON Common_Light_BG_Color],
                                                                                                       NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],
                                                                                                       NSLinkAttributeName : [NSURL URLWithString:@"more..."]
                                                                                                       }];
    
    
    [despLabel setAttributedTruncationToken:showMore];
    [despLabel setText:strDescriptionText];
    
    
    if([self isDeviceIpad]==YES){
        _despLabelHeight.constant = DespHeight;
        _rightViewIpadHeightConstraint.constant = rightTopHalfViewHeight;
        if(isTrailerHidden==YES){
            _topFullViewHeightConstraint.constant = detailFullViewHeight -(_watchTrailerButton.frame.size.height);
        }
        else{
            _topFullViewHeightConstraint.constant = detailFullViewHeight;
        }
    }
    else{
        _despLabelHeight.constant = DespHeight;
        _rightViewIphoneHeightConstraint.constant = DespHeight+15;
        
    }
}


#pragma mark - loadfreeBtnItems
-(void)loadfreeBtnItems{
    [COMMON LoadIcon:_lastBottomView];
    isFreeClicked=YES;
    isAllEpisodesClicked=NO;
    isAllSeasonsClicked=NO;
    [self setBorderForLeftButtons];
    showFullGridArray = [[NSMutableArray alloc]init];
    
    if(isFreeCountEmpty==YES){
        showFullGridArray = allEpisodeArray;
    }
    else{
        showFullGridArray = allFreeEpisodeArray;
    }
    [self setScrollHeight];
    [COMMON removeLoading];
    
}
#pragma mark - loadAllEpisodesBtnItems
-(void)loadAllEpisodesBtnItems{
    [COMMON LoadIcon:_lastBottomView];
    isFreeClicked=NO;
    isAllEpisodesClicked=YES;
    isAllSeasonsClicked=NO;
    [self setBorderForLeftButtons];
    
    if(isFreeCountEmpty==YES){
        if([allEpisodeArray count]==0){
            [COMMON removeLoading];
        }
        else{
            showFullGridArray = [[NSMutableArray alloc]init];
            showFullGridArray = allSeasonsArray;
            [self setScrollHeight];
            [COMMON removeLoading];
        }

    }
    else if(isEpisodeNotNeedInFree==YES){
        showFullGridArray = [[NSMutableArray alloc]init];
        showFullGridArray = allSeasonsArray;
        [self setScrollHeight];
        [COMMON removeLoading];
    }
    
    else{
        if([allEpisodeArray count]==0){
            [COMMON removeLoading];
        }
        else{
            
            showFullGridArray = [[NSMutableArray alloc]init];
            showFullGridArray = allEpisodeArray;
            [self setScrollHeight];
            [COMMON removeLoading];
        }
    }
    
    
    
}
#pragma mark - loadAllSeasonBtnItems
-(void)loadAllSeasonBtnItems{
    [COMMON LoadIcon:_lastBottomView];
    isFreeClicked=NO;
    isAllEpisodesClicked=NO;
    isAllSeasonsClicked=YES;
    [self setBorderForLeftButtons];
   
    showFullGridArray = [[NSMutableArray alloc]init];
    showFullGridArray = allSeasonsArray;
    [self setScrollHeight];
    [COMMON removeLoading];
}
#pragma mark - setScrollHeight
-(void)setScrollHeight{
    
    if([fourLatestArray count]==0){
        
        _middleScrollHeight.constant = 0;
        _middleViewHeightConstraint.constant = 0;
        [middleView setHidden:YES];
        
        
    }
    else{
        //_middleScrollHeight.constant = middleScrollHeight;

        _middleViewHeightConstraint.constant= middleViewHeight;
        [middleView setHidden:NO];

    }
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        _rightViewIphoneHeightConstraint.constant = 0;
//    else
//        _rightViewIphoneHeightConstraint.constant = rightTopHalfViewHeight;
//    _bottomFullViewHeightConstraint.constant = bottomViewHeight+middleScrollView.frame.size.height;
    
//    if([showFullGridArray count]==0){
//        _bottomFullViewHeightConstraint.constant = 0;
//    }
    if([showFullGridArray count]!=0){
        
        [_appListGridView reloadData];
        
        _gridViewHeight.constant = _appListGridView.contentSize.height;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            _bottomFullViewHeightConstraint.constant = self.appListGridView.contentSize.height+ 100;//+gridHeight;
            _bottomInnerViewHeightConstraint.constant = self.appListGridView.contentSize.height+100;//+gridHeight;
        }else {
            _bottomFullViewHeightConstraint.constant = _appListGridView.contentSize.height+70;
        }
    }
    
}


#pragma mark - UI Grid View


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return nAppWidth-20;
    }
    else{
        return nAppWidth;
    }
    
    
}
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
     CGFloat gridHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        gridHeight = 230;
        
//        CGRect frame = self.appListGridView.frame;
//        frame.origin.y =  _castBtn.frame.origin.y+_castBtn.frame.size.height+ 10;
//        frame.size.height = self.appListGridView.contentSize.height;
//        [self.appListGridView setFrame:frame];
//
//        _bottomFullViewHeightConstraint.constant = self.appListGridView.contentSize.height+ bottomViewHeight+5;//+gridHeight;
//        _bottomInnerViewHeightConstraint.constant = self.appListGridView.contentSize.height+ bottomViewHeight+5;//+gridHeight;
        
        return gridHeight;
    }
    else{
        gridHeight = 160;
              
//        CGRect frame = self.appListGridView.frame;
//        frame.origin.y = _castBtn.frame.origin.y+_castBtn.frame.size.height+ 10;
//        frame.size.height =  _appListGridView.contentSize.height;
//        [self.appListGridView setFrame:frame];
//
//        _bottomFullViewHeightConstraint.constant = _appListGridView.frame.size.height+bottomViewHeight+(gridHeight*2)+100;
        
        //[self.view layoutIfNeeded];
        
        return gridHeight;
    }
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return nAppCount;
}
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;
    if([showFullGridArray count]!=0){
        nCount = [showFullGridArray count];
    }
    else{
        nCount = 0;
    }
    return nCount;
}


- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
    New_Land_Cell* cell = [grid dequeueReusableCell];
    
    if(cell == nil){
        cell = [[New_Land_Cell alloc] init];
    }
    if([showFullGridArray count] == 0){
        [asyncImage removeFromSuperview];
        [cell removeFromSuperview];
    }
    else{
        int nIndex;
        
        nIndex = rowIndex * nAppCount + columnIndex;
        
        NSDictionary* dictItem;
        
        dictItem = showFullGridArray[nIndex];
        NSString* strName = dictItem[@"name"];
        NSString* strPosterUrl;
        strPosterUrl = dictItem[@"poster_url"];
        NSString* airDate = dictItem[@"air_date"];
        
        if ((NSString *)[NSNull null] == strName||strName == nil) {
            strName=@"";
        }
        if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl == nil) {
            strPosterUrl=@"";
        }
        if ((NSString *)[NSNull null] == airDate||airDate == nil) {
            airDate=@"";
        }
        NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
        [cell.portraitImageView setHidden:YES];
        [cell.portraitView setHidden:YES];
        [cell.portraitLabel setHidden:YES];
        [cell.landScapeLabel setHidden:NO];
        //[cell.thumbnail setImageWithURL:imageUrl];//placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
        [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        if(isAllSeasonsClicked!=YES){
            if (airDate==nil||[airDate isEqual:@""])
                [cell.airDate setText:[NSString stringWithFormat:@"%@", airDate]];
            else {
                NSString *myString = airDate;
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd";
                NSDate *yourDate = [dateFormatter dateFromString:myString];
                dateFormatter.dateFormat = @"MMM. dd, yyyy";//dd-MMM-yyyy
                [cell.airDate setText:[NSString stringWithFormat:@"(%@)", [dateFormatter stringFromDate:yourDate]]];
            }

            [cell.airDate setHidden:NO];
            [cell.freeLabel setHidden:NO];
        }
        else{
            [cell.freeLabel setHidden:YES];
            [cell.airDate setHidden:YES];
            [cell.airDate setText:@""];
        }
        if(isAllEpisodesClicked==YES||isAllSeasonsClicked==YES||isFreeCountEmpty==YES){
            [cell.freeLabel setHidden:YES];
        }
        else
            [cell.freeLabel setHidden:NO];
        
        [cell.landScapeLabel setText:strName];
        
        [cell.portraitLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        [cell.landScapeLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        [cell.airDate setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [cell.portraitLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
            [cell.landScapeLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        }
        
    }
    
    return cell;
    
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    int nIndex = rowIndex * nAppCount + colIndex;
    
    int count = (int) [showFullGridArray count];
        
    if(nIndex < count){
        NSDictionary* dictItem = showFullGridArray[nIndex];
        if(isAllSeasonsClicked==YES){
            _seasonId = dictItem[@"id"];
        }
        else{
            _episodeId = [NSString stringWithFormat:@"%@",dictItem[@"id"]];
            _seasonId  = [NSString stringWithFormat:@"%@",dictItem[@"season_id"]];
        }
        
        if(isFreeCountEmpty==YES||isEpisodeNotNeedInFree==YES){
            
            if(isAllEpisodesClicked==YES){
                [self getSeasonData];
            }
            else{
                [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
                [self loadEpisodeDetails];
                [self getEpisodeData:[nID intValue] seasonId:[_seasonId intValue] episodeId:[_episodeId intValue]];
                [_iPhoneScrollView setContentOffset:CGPointMake(0,_iPhoneScrollView.frame.origin.x-50
                                                                ) animated:YES];
            }}
        else{
            if(isAllSeasonsClicked==YES){
                [self getSeasonData];
            }
            else{
                [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
                [self loadEpisodeDetails];
                [self getEpisodeData:[nID intValue] seasonId:[_seasonId intValue] episodeId:[_episodeId intValue]];
                [_iPhoneScrollView setContentOffset:CGPointMake(0,_iPhoneScrollView.frame.origin.x-50
                                                                ) animated:YES];
            }
        }

    }
   
    
}
#pragma mark - getSeasonData
-(void)getSeasonData{
    
    int nPPV;
    if(isPushedFromPayPerView==YES){
        nPPV =PAY_MODE_PAID;
    }
    else{
        if(isToggledAll==YES)
            nPPV =PAY_MODE_ALL;
        else
            nPPV =PAY_MODE_FREE;
    }
    [[RabbitTVManager sharedManager]getShowEpisodes:^(AFHTTPRequestOperation * request, id responseObject) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSMutableArray *seasonParticularEpisodesArray = [[NSMutableArray alloc] initWithArray:responseObject];
        if([seasonParticularEpisodesArray count]==0){
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [AppCommon showSimpleAlertWithMessage:@"No Episodes"];
        }
        else{
            showFullGridArray = seasonParticularEpisodesArray;
            [self setScrollHeight];
            if(isFreeCountEmpty==YES||isEpisodeNotNeedInFree==YES){
                isFreeClicked=YES;
                isAllEpisodesClicked =NO;
                isAllSeasonsClicked=NO;
            }
            else{
                isFreeClicked=NO;
                isAllEpisodesClicked =YES;
                isAllSeasonsClicked=NO;
            }
            
            [self setBorderForLeftButtons];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
    }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
         [AppCommon showSimpleAlertWithMessage:@"No Episodes"];
     } nShowID:[nID intValue] nSeasonId:[_seasonId intValue] nPPV:nPPV];
}

-(void)middleEpisodeAction:(UITapGestureRecognizer *)tap {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSMutableArray *selectedArray   = [fourLatestArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag];
   _episodeId = [NSString stringWithFormat:@"%@",[selectedArray valueForKey:@"id"]];
    
    if(![previousEpisodeID isEqualToString:_episodeId]){
        previousEpisodeID =[NSString stringWithFormat:@"%@",_episodeId];
        _seasonId = [selectedArray valueForKey:@"season_id"];
        [self loadEpisodeDetails];
        [self getEpisodeData:[nID intValue] seasonId:[_seasonId intValue] episodeId:[_episodeId intValue]];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [_iPhoneScrollView setContentOffset:CGPointMake(0,_iPhoneScrollView.frame.origin.x-50
                                                        ) animated:YES];
    }
    else{
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
   
    
}
-(void) appAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageView   = (UIImageView *) tap.view;
    NSInteger selectedIndex = imageView.tag;
    [self loadAppDataForIndexInMovieView:selectedIndex];
}
#pragma mark - loadAppDataForIndexInMovieView
-(void)loadAppDataForIndexInMovieView:(NSInteger)selectedIndex{
    
    NSInteger CurrentArrayCount = [appShowAllItems count];
    
    if([appShowAllItems count]!=0){
        if(selectedIndex < CurrentArrayCount){
            NSDictionary *dictItem = appShowAllItems[selectedIndex];
            currentCarouselID = dictItem[@"display_name"];
            currentAppImage = dictItem[@"image"];
            currentAppName = dictItem[@"display_name"];
            currentDeepLink = dictItem[@"link"];
            NSString *appRequired = [NSString stringWithFormat:@"%@",dictItem[@"app_required"]];
            NSLog(@"appRequired%@",appRequired);
            // BOOL app_required = (BOOL)dictItem[@"app_required"];
            
            //BOOL YES 1
            //BOOL NO 0
            if([appRequired isEqualToString:@"0"]){
                if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dictItem[@"link"]]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dictItem[@"link"]]];
                }
            }
            else{
                NSString * url = [dictItem[@"app_download_link"] stringByReplacingOccurrencesOfString:@"itms-apps://" withString:@"http://"];
                currentAppLink = url;
                
                if ((NSString *)[NSNull null] == currentDeepLink||currentDeepLink == nil) {
                    currentDeepLink=@"";
                }
                if ((NSString *)[NSNull null] == currentCarouselID||currentCarouselID == nil) {
                    currentCarouselID=@"";
                }
                if ((NSString *)[NSNull null] == currentAppImage||currentAppImage == nil) {
                    currentAppImage=@"";
                }
                if ((NSString *)[NSNull null] == currentAppName||currentAppName == nil) {
                    currentAppName=@"";
                } if ((NSString *)[NSNull null] == currentAppLink||currentAppLink == nil) {
                    currentAppLink=@"";
                }
                if([currentAppName isEqualToString:@"iTunes"]){
                    NSString *url = [NSString stringWithFormat:@"%@://app/",currentAppName];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
                else{
                    [self getAppNameWithPackageName:currentAppName];
                }
            }
        }
    }
}
#pragma mark - getAppNameWithPackageName
-(void)getAppNameWithPackageName:(NSString *)app_Name
{
    [COMMON LoadIcon:self.view];
    int deviceID = CURRENT_DEVICE_ID;
    [[RabbitTVManager sharedManager]getAppsByName:^(AFHTTPRequestOperation * request, id responseObject) {
        [self checkAppInstalledWithAppSlugName:responseObject];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error){
        //NSMutableDictionary *tempDict = [NSMutableDictionary new];
        //[self checkAppInstalledWithPackageName:@""];
        [AppCommon showSimpleAlertWithMessage:@"Network Error"];
        [COMMON removeLoading];
    } strAppName:app_Name nDeviceId:deviceID];
}

#pragma mark - checkAppInstalledWithAppSlugName
-(void)checkAppInstalledWithAppSlugName:(NSMutableDictionary *)appResponse{
    //NSString * appPackageName=tempDict[@"package"];;
    NSMutableDictionary *tempDict;
    
    NSString * slug = [appResponse objectForKey:@"slug"];
    slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
    
    BOOL isOpen = [COMMON checkInstalledApplicationInApp:slug];
    
        if(isOpen ==YES){
            tempDict = [NSMutableDictionary new];
            tempDict=[appResponse mutableCopy];
            [tempDict setObject:@"YES" forKey:@"isInstalled"];
            
        }
        else{
            tempDict = [NSMutableDictionary new];
            tempDict=[appResponse mutableCopy];
            [tempDict setObject:@"NO" forKey:@"isInstalled"];
        }
        
    
    
    [self loadAppRelatedPage:tempDict];
}

#pragma mark - loadAppRelatedPage
-(void)loadAppRelatedPage:(NSMutableDictionary *)tempDict{
    NSString *isAppInstalled = tempDict[@"isInstalled"];
    //NSString *appPackageName = tempDict[@"package"];
    NSString * url = tempDict[@"link"];
    currentAppLink = url;
    if ((NSString *)[NSNull null] == currentAppLink||currentAppLink == nil) {
        currentAppLink=@"";
    }
    if([isAppInstalled isEqualToString:@"YES"]){
        //currentDeepLink
        NSURL* linkUrl = [NSURL URLWithString:currentDeepLink];
        [[UIApplication sharedApplication] openURL:linkUrl];
        
    }
    else{
        [self loadNewMoviewPopUpInDetailPage];
    }
    [COMMON removeLoading];
}

#pragma mark - goBack
- (IBAction) goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - onTrailers
- (void)onTrailers:(id)sender {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TrailerMovieView" owner:self options:nil];
    NSLog(@"subviewArray%@",subviewArray);
    mainView = [subviewArray objectAtIndex:0];
    
    NSLog(@"watchTrailerArray%@",watchTrailerArray);
    
    if([[watchTrailerArray objectAtIndex:0]  isEqual:@""]){
        NSLog(@"self.linksTrailer%@",self.linksTrailer);
        
        UIAlertView* alertView =[[UIAlertView alloc] init];
        [alertView setTitle:@"Trailer Not Available"];
        [alertView addButtonWithTitle:@"Ok"];
        [alertView show];
    }
    else{
        NSString* stringToFind = @"?";
        NSMutableArray * myArray = [[NSMutableArray alloc]init];
        NSLog(@"epiArray%@",myArray);
        for(NSDictionary * anEntry in watchTrailerArray)
        {
            NSString * url = (NSString*)anEntry;
            if([url containsString: stringToFind]){
                NSLog( @"code true!");
                [myArray insertObject: url atIndex: 0];
                NSLog (@"myArray%@", myArray);
                
            }
            else{
                NSLog( @"code empty!");
            }
            
        }
        if(myArray.count == 0){
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[watchTrailerArray objectAtIndex:0]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[watchTrailerArray objectAtIndex:0]]];
            }
            else
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[watchTrailerArray objectAtIndex:0]]];
            
            
        }
        else{
            
            [mainView setTrailers:self.linksTrailer];
            NSLog(@"self.linksTrailer%@",self.linksTrailer);
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            CGRect frameView = [mainView frame];
            CGFloat widthView = frameView.size.width;
            CGFloat heightView = frameView.size.height;
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                
                widthView = 500;
                heightView = 500;
            }
            
            CGFloat x_Pos = (screenWidth - widthView)/2;
            CGFloat y_Pos = (screenHeight - heightView)/2;
            [self.view addSubview:mainView];
            frameView = CGRectMake(x_Pos, y_Pos, widthView, heightView);
            [mainView setFrame:frameView];
            [mainView startPlay];
        }
        
    }
    
}
#pragma mark - getMovieWatchNow
- (void)getMovieWatchNowNewAction:(id)sender{
    if([appShowAllItems count]!=0){
        NSDictionary *dictItem = appShowAllItems[0];
        currentCarouselID = dictItem[@"display_name"];
        currentAppImage = dictItem[@"image"];
        currentAppName = dictItem[@"display_name"];
        currentDeepLink = dictItem[@"link"];
        //BOOL app_required = dictItem[@"app_required"];
        NSString *appRequired = [NSString stringWithFormat:@"%@",dictItem[@"app_required"]];
        
        //BOOL YES 1
        //BOOL NO 0
        if([appRequired isEqualToString:@"0"]){
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dictItem[@"link"]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dictItem[@"link"]]];
            }
        }
        else{
            NSString * url = [dictItem[@"app_download_link"] stringByReplacingOccurrencesOfString:@"itms-apps://" withString:@"http://"];
            currentAppLink = url;
            
            if ((NSString *)[NSNull null] == currentDeepLink||currentDeepLink == nil) {
                currentDeepLink=@"";
            }
            if ((NSString *)[NSNull null] == currentCarouselID||currentCarouselID == nil) {
                currentCarouselID=@"";
            }
            if ((NSString *)[NSNull null] == currentAppImage||currentAppImage == nil) {
                currentAppImage=@"";
            }
            if ((NSString *)[NSNull null] == currentAppName||currentAppName == nil) {
                currentAppName=@"";
            } if ((NSString *)[NSNull null] == currentAppLink||currentAppLink == nil) {
                currentAppLink=@"";
            }
            if([currentAppName isEqualToString:@"iTunes"]){
                NSString *url = [NSString stringWithFormat:@"%@://app/",currentAppName];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            else{
                [self getAppNameWithPackageName:currentAppName];
            }
            
        }

    }
    
}
#pragma mark - getMovieWatchNow
- (void)getMovieWatchNow:(id)sender{
    
    if((paidItems.count)!=0 && paidItems != nil){
        
        NSDictionary *dictItem = [paidItems objectAtIndex:0];
        NSString *strUrl;
        strUrl= dictItem[@"link"];
        BOOL app_required = dictItem[@"app_required"];
        if( app_required == NO ){
            //link into app_download_link
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dictItem[@"app_download_link"]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dictItem[@"app_download_link"]]];
            }
        }else{
            //link into app_download_link
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dictItem[@"app_download_link"]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dictItem[@"app_download_link"]]];
            }else{
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dictItem[@"app_download_link"]]] ){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dictItem[@"app_download_link"]]];
                }else{
                    NSString * url = [dictItem[@"app_download_link"] stringByReplacingOccurrencesOfString:@"itms-apps://" withString:@"http://"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }
        }
    }
    else{
        UIAlertView* alertView =[[UIAlertView alloc] init];
        [alertView setTitle:@"Video Not Available"];
        [alertView addButtonWithTitle:@"Ok"];
        [alertView show];
    }
}
#pragma mark - setBorderForLeftButtons
-(void)setBorderForLeftButtons{
    [upperLeftBorder removeFromSuperview];
    [upperRightBorder removeFromSuperview];
    [upperTopBorder removeFromSuperview];
    [upperBottomBorder1 removeFromSuperview];
    [upperBottomBorder2 removeFromSuperview];
    if(isFreeClicked==YES){
        upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 0.5, _overViewBtn.frame.size.height)];
        upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_overViewBtn.frame.size.width-1.0,1.0)];
        
        upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_overViewBtn.frame.size.width-1.0f, 0, 1.0, _overViewBtn.frame.size.height-1.0)]; //change
        if([self isDeviceIpad]==YES){
            upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0.5, _castBtn.frame.size.height-2.0f, _castBtn.frame.size.width-1.0, 1.0)];
        }
        else{
         upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, _castBtn.frame.size.height-2.0f, _castBtn.frame.size.width, 1.0)];
        }
        
        
        upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _genreBtn.frame.size.height-2.0f, _genreBtn.frame.size.width, 1.0)];
        [self autoMaskingForUpperButtonBorder];
        [_overViewBtn addSubview:upperLeftBorder];
        [_overViewBtn addSubview:upperRightBorder];
        [_overViewBtn addSubview:upperTopBorder];
        [_castBtn addSubview:upperBottomBorder1];
        [_genreBtn addSubview:upperBottomBorder2];
    }
    else if(isAllEpisodesClicked ==YES){
        upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1.5, _castBtn.frame.size.height-1.0)];
        upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_castBtn.frame.size.width-1.0,1.0)];
        upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_castBtn.frame.size.width-1.0f, 0, 1.0, _castBtn.frame.size.height-1.0)];
         if([self isDeviceIpad]==YES){
             upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _overViewBtn.frame.size.height-2.0f, _overViewBtn.frame.size.width-1.0, 1.0)];
         }
        else{
            upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _overViewBtn.frame.size.height-2.0f, _overViewBtn.frame.size.width, 1.0)];
        }
        
        upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _genreBtn.frame.size.height-2.0f, _genreBtn.frame.size.width, 1.0)];
        [self autoMaskingForUpperButtonBorder];
        [_castBtn addSubview:upperLeftBorder];
        [_castBtn addSubview:upperTopBorder];
        [_castBtn addSubview:upperRightBorder];
        [_overViewBtn addSubview:upperBottomBorder1];
        [_genreBtn addSubview:upperBottomBorder2];
    }
    if(isFreeCountEmpty!=YES){
        if(isAllSeasonsClicked==YES){
            upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, _genreBtn.frame.size.height-1.0)];
            upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_genreBtn.frame.size.width-0.5,1.0)];
           
            upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_genreBtn.frame.size.width-1.0f, 1, 0.5, _genreBtn.frame.size.height-1.0)];
            
            upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _overViewBtn.frame.size.height-2.0f, _overViewBtn.frame.size.width, 1.0)];
            upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(1, _castBtn.frame.size.height-2.0f, _castBtn.frame.size.width, 1.0)];
            [self autoMaskingForUpperButtonBorder];
            [_genreBtn addSubview:upperLeftBorder];
            [_genreBtn addSubview:upperTopBorder];
            [_genreBtn addSubview:upperRightBorder];
            [_overViewBtn addSubview:upperBottomBorder1];
            [_castBtn addSubview:upperBottomBorder2];
        }

    }
    upperLeftBorder.backgroundColor = BORDER_BLUE;
    upperTopBorder.backgroundColor = BORDER_BLUE;
    upperRightBorder.backgroundColor = BORDER_BLUE;
    upperBottomBorder1.backgroundColor = BORDER_BLUE;
    upperBottomBorder2.backgroundColor = BORDER_BLUE;
}
-(void) autoMaskingForUpperButtonBorder{
    
    [upperLeftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [upperRightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [upperTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [upperBottomBorder1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [upperBottomBorder2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

#pragma mark - loadPopUp
-(void) loadNewMoviewPopUpInDetailPage{
    
    [appListFullPopUpView removeFromSuperview];
    [appListInnerPopUpView removeFromSuperview];
    appListFullPopUpView = nil;
    appListInnerPopUpView = nil;
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE LAND
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            appListFullPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            //230
            appListInnerPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-60)];
            iPhoneLandScape =YES;
        }
        //IPAD LAND
        else{
            
            appListFullPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            appListInnerPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-180, self.view.frame.size.height-180)];
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
            appListFullPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            appListInnerPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, self.view.frame.size.height-iPhoneHeight)];//140
            iPhoneLandScape =NO;
            
        }
        //IPAD PORT
        else{
            
            appListFullPopUpView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            appListInnerPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-480)];
        }
    }
    
    [appListInnerPopUpView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    [self setUpAppListViewContainer];
}
-(void) setUpAppListViewContainer{
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
        labelTitleXPos =10;
        labelTitleYPos =5;
        labelDescriptionXPos=10;
        if(IS_IPHONE4||IS_IPHONE5){
            labelTitleHeight = 20;
        }
        else{
            labelTitleHeight = 30;
        }
        labelDescriptionHeight= 40;
        buttonHeight =40;
    }
    viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, appListInnerPopUpView.frame.size.width, appListInnerPopUpView.frame.size.height)];
    
     labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelTitleXPos, labelTitleYPos, viewContainer.frame.size.width-(labelTitleXPos*2), labelTitleHeight)];
    [labelTitle setText:@"Connecting to App Store..."];
    [labelTitle setTextColor:[UIColor whiteColor]];
    if([self isDeviceIpad]==YES){
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(25)]];
    }
    else{
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(18)]];
    }
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    
    labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(labelDescriptionXPos, labelTitle.frame.origin.y+labelTitle.frame.size.height+5, viewContainer.frame.size.width-(labelDescriptionXPos*2), labelDescriptionHeight)];
    
    NSString *labelDescriptionStr= [NSString stringWithFormat:@"%@ requires you to download their app to watch their content.",currentAppName];
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
        [imageThumbnail setImageWithURL:imageNSURL];// placeholderImage:[UIImage imageNamed:@"white_Bg"]];//white_Bg
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
    
    labelVideoName.attributedText = [self setAttributedTextForAppNoteDetail:noteWithAppName];
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
        cancelBtnYPos = imageThumbnail.frame.origin.y+imageThumbnail.frame.size.height+60;
        fontSize=10;
    }
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtnXPos, cancelBtnYPos, (viewContainer.frame.size.width/2)-cancelBtnXPos, buttonHeight)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(fontSize)];
    
    [cancelBtn addTarget:self action:@selector(dismissMovieDetailAppListPopup) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat installBtnXPos = cancelBtn.frame.origin.x+cancelBtn.frame.size.width+5;
    UIButton* installBtn = [[UIButton alloc] initWithFrame:CGRectMake(installBtnXPos, cancelBtnYPos,cancelBtn.frame.size.width-5, buttonHeight)];
    [installBtn setBackgroundImage:[UIImage imageNamed:@"installBtnImage.png"] forState:UIControlStateNormal];
    NSString *installBtnStr= [NSString stringWithFormat:@"INSTALL %@",currentAppName];
    [installBtn setTitle:installBtnStr forState:UIControlStateNormal];
    [installBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    installBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(fontSize)];
    [installBtn addTarget:self action:@selector(installAppMovieDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self performSelector:@selector(installAppMovieDetailAction:) withObject:nil afterDelay:5];
    
    [viewContainer addSubview:labelTitle];
    [viewContainer addSubview:labelDescription];
    [viewContainer addSubview:imageThumbnail];
    [viewContainer addSubview:labelVideoName];
    [viewContainer addSubview:cancelBtn];
    [viewContainer addSubview:installBtn];
    
    [appListInnerPopUpView addSubview:viewContainer];
    appListFullPopUpView.delegate = self;
    [appListFullPopUpView setContainerView:appListInnerPopUpView];
    [appListFullPopUpView show];
    isAppListPopUpShown = YES;
}

#pragma mark - setAttributedTextForAppNoteDetail
-(NSMutableAttributedString *)setAttributedTextForAppNoteDetail:movieString{
    
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

#pragma mark - dismissMovieDetailAppListPopup
-(void)dismissMovieDetailAppListPopup {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(installAppMovieDetailAction:)
                                               object:nil];
    
    [appListFullPopUpView removeFromSuperview];
    appListFullPopUpView = nil;
    [appListFullPopUpView close];
    isAppListPopUpShown = NO;

    
}
#pragma mark - installAppMovieDetailAction
-(void)installAppMovieDetailAction:(UIButton *)sender
{
    NSString *link = currentAppLink ;
    NSURL* linkUrl = [NSURL URLWithString:link];
   
    [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];

    
    [appListFullPopUpView removeFromSuperview];
    appListFullPopUpView = nil;
    [appListFullPopUpView close];
    isAppListPopUpShown = NO;
    
    [self performSelector:@selector(dismissMovieDetailAppListPopup) withObject:nil afterDelay:1];
//    //[NSObject cancelPreviousPerformRequestsWithTarget:self
//                                             selector:@selector(installAppMovieDetailAction:)
//                                               object:nil];
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
            [[UIApplication sharedApplication] openURL:url];
        }
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - showOrientationChanged
-(void) showOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self NewMovieRotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self NewMovieRotateViews:false];
            break;
            
        default:
            break;
    }
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
#pragma mark -Rotate Views
-(void) NewMovieRotateViews:(BOOL) bPortrait{
    [self loadTableHeaderView];
    if([appPaidItems count]==0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:YES];
    }
    if([appPaidItems count]!=0 && [appFreeItems count]==0){
        [freeLabel setHidden:YES];
        [freeSwitch setHidden:YES];
        [rentLabel setHidden:YES];
        [freeRentLabel setHidden:NO];
        freeRentLabel.text = @"BUY/RENT";
    }
    
    if([appPaidItems count]!=0 && [appFreeItems count]!=0){
        [freeLabel setHidden:NO];
        [freeSwitch setHidden:NO];
        [rentLabel setHidden:NO];
        [freeRentLabel setHidden:YES];
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat portraitImageSize;
    if(bPortrait){
        portraitImageSize = ((screenWidth/3)-10);
        nAppCount = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nAppCount = 3;
        }
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nAppWidth = SCREEN_WIDTH / nAppCount;
        nAppHeight = SCREEN_HEIGHT / nAppCount;
    }
    else{
        portraitImageSize = ((screenWidth/2.5)+10);
        nAppCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nAppCount = 4;
        }
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nAppWidth = SCREEN_WIDTH / nAppCount;
        nAppHeight = SCREEN_HEIGHT / nAppCount;
        
    }
    if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        if(isEpisode!=YES){
            [_portraitImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_portraitImageView setFrame: CGRectMake(portraitImageSize, _portraitImageView.frame.origin.y, _portraitImageView.frame.size.width, _portraitImageView.frame.size.height)];
            [_portraitImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                            selector:@selector(installAppMovieDetailAction:)
                                                object:nil];

    if(isAppListPopUpShown==YES) {
        [appListFullPopUpView removeFromSuperview];
        appListFullPopUpView = nil;
        [appListFullPopUpView close];
        [self loadNewMoviewPopUpInDetailPage];
    }
//    if([showFullGridArray count]==0){
//        _bottomFullViewHeightConstraint.constant = 0;
//    }
    
    [self setBorderForLeftButtons];
    [_appListGridView reloadData];
    
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    if([arrayCast count]!=0){
        nCount = [arrayCast count];
    }
    return nCount;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
    
}
-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(arrayCast.count == 0){
        return 0.0;
    }
    else{
        return 0.0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CastLandCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString * strName;
    if([arrayCast count]== 0){
        strName = @"";
    }else{
        
        strName = [[arrayCast objectAtIndex:indexPath.row]valueForKey:@"name"];
        strName = [strName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
    }
    if ((NSString *)[NSNull null] == strName||strName == nil) {
        strName=@"";
    }
    
    cell.backgroundColor =[UIColor clearColor];
    [cell.textLabel setText:strName];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    cell.textLabel.numberOfLines=0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

@end

