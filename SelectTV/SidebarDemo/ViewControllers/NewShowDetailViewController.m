 //
//  NewShowDetailViewController.m
//  SidebarDemo
//
//  Created by Panda on 7/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "NewShowDetailViewController.h"
#import "RabbitTVManager.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "PlusViewController.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "CastCell.h"
#import "Cell.h"
#import "PlusViewController.h"
#import "PromoViewController.h"
#import "CustomIOS7AlertView.h"
#import "RentCell.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "AsyncImage.h"
#import "Land_Cell.h"
#import "New_Land_Cell.h"
#import "NewMovieDetailViewController.h"
#import "LoginViewController.h"
#import "CastCustomCell.h"


@interface NewShowDetailViewController ()<CustomIOS7AlertViewDelegate,UIGridViewDelegate,TTTAttributedLabelDelegate>{
    NSString* strTrailer;
    NSArray *paidItems;
   // NSArray *andriodPaidItems;
    BOOL isFreeButtonClicked;
    BOOL isFirstLandScape;
    AsyncImage *asyncImage;
    
    //APP List
    
    NSMutableArray *appShowAllItems;
    NSMutableArray *appFreeItems;
    NSMutableArray *appPaidItems;
   
    BOOL isSDClicked;
    BOOL isHDClicked;
    BOOL isHDXClicked;

    //POP UP
    UIView * showPopUpInnerView;
    UIScrollView * showPopUpFullScrollView;
    UIButton *closePopUpBtn;
    UILabel *popUpTitle;
    UILabel *popTitleLine;
    UILabel *popBtnExtraLine;
    UIButton *popUpFreeBtn;
    UIButton *popUpShowAllBtn;
    
    UIView *PopUpLeftBorder;
    UIView *PopUpRightBorder;
    UIView *PopUpTopBorder;
    UIView *PopUpBottomBorder;
    BOOL isWatchBtnClicked;
    BOOL isWatchLoaded;
    CGRect middleFrame;
    CGFloat middleViewHeight;
    
    NSString* strDescriptionText;
    CGFloat DespHeight;
    CGFloat textViewHeight;
    
    CGRect  leftFullView;
    CGFloat leftFullViewHeight;
    
    CGRect  topFullView;
    CGFloat topFullViewHeight;
    
    CGRect  topFullLeftViewFrame;
    
    //latestArray
    NSMutableArray *topFourLatestArray;
    NSMutableArray *freeLatestArray;
    
    //Movie
    
    UIView *appListHeaderView;
    UILabel *freeLabel,*rentLabel;
    UILabel *freeRentLabel;
    UIView *appListView;
    UIScrollView *appListScrollView;
    UISwitch *freeSwitch;
    UIButton * deskTopBtn;
    UIButton * iosBtn;
    CGFloat leftBtnsViewHeight;
    CGFloat leftBtnsViewWidth;
    CGFloat bottomViewHeight;
    CGFloat ipadSubViewFloatHeight;
    NSArray *latestArray;

    UIButton * sdBtn,*hdBtn,*hdxBtn;
    
    //ICON
    NSMutableArray *iconArray;
    NSMutableArray *tempIconArray;
    
    //ButtonFrame
    CGRect freeBtnFrame;
    CGRect allEpisodeBtnFrame;
    CGRect allSeasonBtnFrame;
    
    
    BOOL isFreeCountEmpty;
    BOOL isEpisodeNotNeedInFree;
    
    
    //ALERT BOX
    BOOL isAppListPopUpShown;
    UIView *appListInnerPopUpView;
    NSString *currentCarouselID,*currentAppImage,*currentAppLink,*currentAppName,*currentDeepLink;
    
    NSString *addFavEntityName;
    BOOL iPhoneLandScape;
    NSString *freeRentStr;
    BOOL isTrailerHidden;
    
    BOOL isMoreClicked;
    
    BOOL isAddBtnClicked;
    BOOL isWatchBtnActionExecuted;
    NSMutableArray *paidNullArray;
    BOOL isSeasonEpisodes;
    
    BOOL isDespTextEmpty;
    BOOL isCastCountEmpty;
    BOOL isCastCountNotEmpty;
    BOOL isGenreTextEmpty;
    BOOL isLeftViewHidden;
    NSMutableDictionary *currentUserLoginDetails;
    NSMutableArray * subcriptionArray;
    
    
}
@property (nonatomic, retain) NSArray *appsInDevice;

@end

@implementation NewShowDetailViewController
@synthesize mainView,currentShowGridArray,showDetailArray,showNameArray,headerLabelStr,isEpisode,episodeTitle,showEpisodeArray,posterUrlStr,youTubeArray,iPhoneScrollView;
@synthesize nID,genreName,showFullSeasonsArray;
@synthesize showDetailGridView,showLatestGridView;
@synthesize MiddleView,middleScrollView;
@synthesize despLabel,TopFullLeftView,isPushedFromPayPerView,isToggledAll,isToggledFree,ipadSubViewHeight;

int nNewCastCount = 3;
int nNewCastWidth = 160;
int nNewCastHeight = 170;

int nPopUpCastCount = 3;
int nPopUpCastWidth = 120;
int nPopUpCastHeight = 150;

bool s_boolMovies = true;


CustomIOS7AlertView *appListFullPopUpView;

- (void)viewDidLoad {
    [super viewDidLoad];
    isTrailerHidden=NO;
    isMoreClicked=NO;
    isAddBtnClicked=NO;
    isWatchBtnActionExecuted=NO;
    freeBtnFrame = _freeBtn.frame;
    allSeasonBtnFrame = _AllSeasonBtn.frame;
    allEpisodeBtnFrame = _allEpisodesBtn.frame;
    isFreeButtonClicked = NO;
    middleFrame = self.MiddleView.frame;
    middleViewHeight = middleFrame.size.height;
    leftBtnsViewHeight = _leftBtnsView.frame.size.height;
    leftBtnsViewWidth =_leftBtnsView.frame.size.width;
    bottomViewHeight = _BottomFullView.frame.size.height;
    ipadSubViewFloatHeight = _ipadSubView.frame.size.height;
    [_castCollectionView registerNib:[UINib nibWithNibName:@"CastCustomCell" bundle:nil] forCellWithReuseIdentifier:@"CastCustomCell"];

    topFullView = self.TopFullView.frame;
    topFullViewHeight = topFullView.size.height;
    
    leftFullView = self.leftBtnsView.frame;
    leftFullViewHeight = leftFullView.size.height;
    [self setUpNavigation];
//    [middleScrollView setBackgroundColor:[UIColor redColor]];
    asyncImage =[[AsyncImage alloc]init];
    [_LatestEpisodesLabel setHidden:YES];
    [_BottomFullView setHidden:YES];
    [self loadingAllData];
    isFreeClicked=YES;
    isWatchLoaded = NO;
    isOverViewClicked=YES;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self newShowDetailRotateViews:false];
    }else{
        [self newShowDetailRotateViews:true];
    }
    [showDetailGridView setScrollEnabled:NO];
    [iPhoneScrollView setScrollEnabled:YES];
    iPhoneScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [iPhoneScrollView setShowsHorizontalScrollIndicator:YES];
    [MiddleView setBackgroundColor:[UIColor clearColor]];

//    [showDetailGridView setBackgroundColor:[UIColor blueColor ]];
    iPhoneScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _leftViewHeightConstraint.constant =  80;
    [iPhoneScrollView setHidden:YES];
    [self performSelector:@selector(hiddenMethod) withObject:nil afterDelay:2.0];



}
-(void) viewWillAppear:(BOOL)animated{
    currentUserLoginDetails = [NSMutableDictionary new];
    currentUserLoginDetails = [COMMON getLoginDetails];
    subcriptionArray = [NSMutableArray new];
    if([currentUserLoginDetails count]!=0){
        subcriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
    }
    
    [super viewWillAppear:animated];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
     self.view.backgroundColor = GRAY_BG_COLOR;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self setShowScrollHeight];
//    _bottomFullViewHeightConstraint.constant =self.showDetailGridView.frame.size.height+bottomViewHeight;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissAppListPopup];
}
- (void) hiddenMethod {
    [iPhoneScrollView setHidden:NO];
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(currentShowGridArray.count != 0) {
        _gridHeight.constant = showDetailGridView.contentSize.height;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            _bottomFullViewHeightConstraint.constant = self.showDetailGridView.contentSize.height+100;
        else
            _bottomFullViewHeightConstraint.constant =self.showDetailGridView.contentSize.height+_allEpisodesBtn.frame.size.height+30;

//            _bottomFullViewHeightConstraint.constant =self.showDetailGridView.contentSize.height+_watchNowBtn.frame.size.height+_addToFavBtn.frame.size.height+50;

    } else{
        _bottomFullViewHeightConstraint.constant = 0;
    }
    if([self isDeviceIpad]!=YES){
        if(isLeftViewHidden==YES){
            [_leftBtnsView setHidden:YES];
            _leftViewHeightConstraint.constant=0;
            _topFullViewHeightConstraint.constant = topFullViewHeight-leftBtnsViewHeight;
            
        }
    }

    [self.view layoutIfNeeded];

}

- (void) setIfMovies:(BOOL)bMovies
{
    s_boolMovies = bMovies;
}
#pragma mark - setUpNavigation
-(void) setUpNavigation{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = headerLabelStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
}
-(void) loadingAllData{
    self.linksTrailer = [NSMutableArray array];
    self.linksWatchVideo = [NSMutableArray array];
    showFullEpisodesArray = [[NSMutableArray alloc]init];
    [showDetailGridView setBackgroundColor:[UIColor clearColor]];
    [_genreLabel setHidden:YES];
    _tableViewCast.delegate = self;
    _tableViewCast.dataSource = self;
   // _tableViewCast.uiGridViewDelegate = self;
    [_tableViewCast registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CastLandCell"];
    [_tableViewCast setHidden:YES];
    [_castCollectionView setHidden:YES];
    _tableViewCast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableViewCast setBackgroundColor:[UIColor clearColor]];
    
   // [_LatestEpisodesLabel setHidden:YES];
    if(s_boolMovies!=YES){
        if(isEpisode==YES){
            [_LatestEpisodesLabel setHidden:NO];
            if(isPushedFromPayPerView==YES){
                _LatestEpisodesLabel.hidden = YES;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    _middleViewHeightConstraint.constant = 0;
                else
                    _middleViewHeightConstraint.constant = 40;

                [self loadEpisodeData]; //OLY EPISODE AND SEASONS ->PAID
            }
            else{
                if(isToggledFree==YES) {
                    [self loadFreeData];  //WITH FREE  AND SEASON ALONE ->FREE
                }
                else{
                    [self loadFreeData];  //WITH FREE ,EPISODES, AND SEASON ->FREE
                }
            }
        }
    }
    [_leftBtnsView setHidden:YES];
    [self setUpButtonAction];
    [self loadShowData];
    
}
#pragma mark - loadLatestEpisodesVideos
-(void)loadLatestEpisodesVideos{
    
//    CGRect frame = self.middleScrollView.frame;
//    frame.size.height = middleViewHeight-35;
//    [self.middleScrollView setFrame:frame];
    topFourLatestArray = [NSMutableArray new];
    freeLatestArray =[NSMutableArray new];
    for(UIView *view in middleScrollView.subviews){
        [view removeFromSuperview];
    }
    if([currentShowGridArray count]!=0){
        NSInteger nCount = [currentShowGridArray count];
        if(nCount == 0){
            nCount =0;
        }
        else if(nCount < 1){
            nCount =0;
        }
        else if(nCount < 2){
            nCount =1;
        }
        else if(nCount < 3){
            nCount =2;
        }
        else if(nCount < 4){
            nCount =3;
        }
        else if(nCount < 5){
            nCount =4;
        }
        else if(nCount >= 5){
            nCount =4;
        }
        latestArray = [currentShowGridArray subarrayWithRange:NSMakeRange(0, nCount)];
        [self loadLatestScrollViewData:latestArray];
        topFourLatestArray= (NSMutableArray*)latestArray;
        NSInteger initialCount =[currentShowGridArray count];

        for(int i=0;i<nCount;i++){
            if(initialCount==nCount){
                [currentShowGridArray removeAllObjects];
                if(i==nCount-1)
                    [currentShowGridArray removeAllObjects];
                else{
                    [self removeDuplicates];
                }
            } else{
                [self removeDuplicates];
            }
        }
    }
    
    freeLatestArray = currentShowGridArray;
    middleScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [middleScrollView setShowsHorizontalScrollIndicator:YES];
    middleScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}
-(void)removeDuplicates {
    NSMutableSet *seen = [NSMutableSet set];

    for(NSDictionary*filterResults in [currentShowGridArray mutableCopy]){
        if ([latestArray containsObject:filterResults] ) {
            [currentShowGridArray removeObject:filterResults ];
            
        } else {
            [seen addObject:filterResults ];
        }
    }
}
#pragma mark - loadLatestScrollViewData
-(void)loadLatestScrollViewData:(NSArray *)seasonArray{
    CGFloat commonWidth,backgroundViewWidth,titleButtonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    backgroundViewWidth = 5;
    titleButtonWidth = 0;
    UIView *backgroundView;
    CGFloat backgroundWidth,imageViewHeight;
    CGFloat imageViewWidth;
    for(int i = 0; i < [seasonArray count]; i++)
    {
        NSArray *tempArray = [seasonArray objectAtIndex:i];
        
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
        
        //Constant width and height for the image raji changed 6th oct
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            backgroundWidth =213;//180;// 215;//commonWidth/3;
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
            imageViewHeight =119;//102;// 140;//middleScrollView.frame.size.height-60;
            imageViewWidth = backgroundView.frame.size.width;//-20;
        }
        else{
            UIDevice* device = [UIDevice currentDevice];
            
            if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
                backgroundWidth = 180;//commonWidth/3;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
                imageViewHeight = 102;//middleScrollView.frame.size.height/2;
                imageViewWidth = backgroundView.frame.size.width;//-20;
            }
            else{
                backgroundWidth = 180;//commonWidth/2;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 0, backgroundWidth, middleScrollView.frame.size.height)];
                imageViewHeight = 102;//middleScrollView.frame.size.height/2;
                imageViewWidth =backgroundView.frame.size.width;//-20;
            }
        }
        //[backgroundView setBackgroundColor:[UIColor grayColor]];
        
        titleButtonWidth =backgroundViewWidth;
        backgroundViewWidth = backgroundView.frame.origin.x+backgroundView.frame.size.width+5;
        
        UIImageView *episodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, imageViewWidth, imageViewHeight)];
        //[episodeImage setImageWithURL:imageUrl];
        [episodeImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        //[episodeImage setBackgroundColor:[UIColor lightGrayColor]];
        episodeImage.tag = i;
        [episodeImage setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewImageAction:)];
        tapGesture1.numberOfTapsRequired = 1;
        [episodeImage addGestureRecognizer:tapGesture1];
        
        //CGFloat  freeVideoLabelYPos = episodeImage.frame.size.height-25;
        //37episodeImage.frame.size.width/6
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
        UILabel *freeVideoLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, freeVideoLabelYPos,freeVideoLabelWidth , freeVideoLabelHeight)];
        [freeVideoLabel setTextColor:[UIColor whiteColor]];
        [freeVideoLabel setText:@"Free"];
        freeVideoLabel.backgroundColor = FREE_GREEN;
        [freeVideoLabel setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
        freeVideoLabel.textAlignment=NSTextAlignmentCenter;
        [episodeImage addSubview:freeVideoLabel];
        
        
        [backgroundView addSubview:episodeImage];
        
        CGFloat  titleLabelYPos = episodeImage.frame.origin.y+episodeImage.frame.size.height+2;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabelYPos, backgroundView.frame.size.width-20, 30)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:strName];
        [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        titleLabel.numberOfLines=0;
        [backgroundView addSubview:titleLabel];
        
        CGFloat  airDateLabelYPos = titleLabel.frame.origin.y+titleLabel.frame.size.height+2;
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
        [middleScrollView setBounces:NO];
        [middleScrollView addSubview:backgroundView];
        
    }

}
-(void)scrollViewImageAction:(UITapGestureRecognizer *)tap {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    UIImageView *imageView   = (UIImageView *) tap.view;
    NSMutableArray *selectedArray   = [showFullFreeArray objectAtIndex:((UIGestureRecognizer *)tap).view.tag];
    NSInteger selectedIndex = imageView.tag;
    NSLog(@"selectedIndex-->%ld",(long)selectedIndex);
    currentSelectedEpisodeId = [selectedArray valueForKey:@"id"];
    currentSelectedSeasonId = [selectedArray valueForKey:@"season_id"];
    didSelectName =  [selectedArray valueForKey:@"name"];
    [self loadMoviePageLink];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}
#pragma mark - setShowScrollHeight
-(void)setShowScrollHeight{
    if(s_boolMovies){
        _middleViewHeightConstraint.constant = 0;
        [_LatestEpisodesLabel setHidden:YES];
    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
       _topFullViewHeightConstraint.constant = topFullViewHeight-50;
//    if([showFullFreeArray count]==0){
//        _middleViewHeightConstraint.constant = 0;
//        [_LatestEpisodesLabel setHidden:YES];
//        if([self isDeviceIpad]==YES){
//            if(isMoreClicked==NO){
//                if(isTrailerHidden==YES){
//                    _topFullViewHeightConstraint.constant = topFullViewHeight-_watchTrailerBtn.frame.size.height-60;
//                    
//                }else{
//                    _topFullViewHeightConstraint.constant = topFullViewHeight;
//                }
//            }
//
//        }
//        else{
//            if(s_boolMovies){
//                if(isOverViewClicked==YES||isGenreClicked==YES){
//                   // _topFullViewHeightConstraint.constant = topFullViewHeight+leftFullViewHeight;
//                    
//                    //raji below
//                    if(isMoreClicked==NO){
//                        if(isTrailerHidden==YES){
//                            _topFullViewHeightConstraint.constant = topFullViewHeight-_watchTrailerBtn.frame.size.height-60;
//                            
//                        }else{
//                            _topFullViewHeightConstraint.constant = topFullViewHeight;
//                        }
//                    }
//                    else{
//                        _topFullViewHeightConstraint.constant = topFullViewHeight;
//                    }                    
//                }
//            }
//
//            if([currentShowGridArray count]==0 && currentShowGridArray!=nil) {
//                _topFullViewHeightConstraint.constant = topFullViewHeight;
////                _middleViewHeightConstraint.constant = middleScrollView.frame.size.height;
//                _bottomFullViewHeightConstraint.constant = 0;
//            }
//        }
//        [self.view layoutIfNeeded];
//    }
//    else {
//        [_LatestEpisodesLabel setHidden:NO];
//         _middleViewHeightConstraint.constant= middleViewHeight;
//        [self.view layoutIfNeeded];
//    }
    
    if(s_boolMovies){
        _middleViewHeightConstraint.constant = 0;
        [_LatestEpisodesLabel setHidden:YES];
    }
    if([self isDeviceIpad]!=YES){
        if(isLeftViewHidden==YES){
            [_leftBtnsView setHidden:YES];
            _leftViewHeightConstraint.constant=0;
            _topFullViewHeightConstraint.constant = topFullViewHeight-leftBtnsViewHeight;
            
        }
    }
    
    [self.view layoutIfNeeded];
    [showDetailGridView reloadData];
    
    if(currentShowGridArray.count != 0) {
        _gridHeight.constant = showDetailGridView.contentSize.height;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            _bottomFullViewHeightConstraint.constant = self.showDetailGridView.contentSize.height+100;
        else
            _bottomFullViewHeightConstraint.constant =self.showDetailGridView.contentSize.height+_allEpisodesBtn.frame.size.height+30;
        
        //            _bottomFullViewHeightConstraint.constant =self.showDetailGridView.contentSize.height+_watchNowBtn.frame.size.height+_addToFavBtn.frame.size.height+50;
        
    } else{
        _bottomFullViewHeightConstraint.constant = 0;
    }

}
#pragma mark - setUpButtonAction
-(void) setUpButtonAction{
    [_TopFullView setHidden:NO];
    [_BottomFullView setHidden:YES];
    [_watchTrailerBtn setHidden:YES];
    [_watchNowBtn setHidden:YES];
    [_showDetailAddFavBtn setHidden:YES];
    [_addToFavBtn setHidden:YES];
    [_watchTrailerBtn addTarget:self action:@selector(onTrailersShow:) forControlEvents:UIControlEventTouchUpInside];
    [_watchNowBtn addTarget:self action:@selector(isWatchBtnClickedAction) forControlEvents:UIControlEventTouchUpInside];
    [_freeBtn addTarget:self action:@selector(loadfreeBtnItems) forControlEvents:UIControlEventTouchUpInside];
    [_allEpisodesBtn addTarget:self action:@selector(loadAllEpisodesBtnItems) forControlEvents:UIControlEventTouchUpInside];
    [_allEpisodesBtn setBackgroundColor:[UIColor grayColor]];
    [_AllSeasonBtn addTarget:self action:@selector(loadAllSeasonBtnItems) forControlEvents:UIControlEventTouchUpInside];
    [_overViewBtn addTarget:self action:@selector(loadOverView) forControlEvents:UIControlEventTouchUpInside];
    [_castBtn addTarget:self action:@selector(loadCast) forControlEvents:UIControlEventTouchUpInside];
    [_genreBtn addTarget:self action:@selector(loadGenre) forControlEvents:UIControlEventTouchUpInside];
    
    [_watchNowBtn setBackgroundColor:[UIColor clearColor]];
    
    if(s_boolMovies) {
        [_freeBtn setHidden:YES];
        [_allEpisodesBtn setHidden:YES];
        [_AllSeasonBtn setHidden:YES];
        [_watchLatestLabel setHidden:YES];
        [_addToFavBtn setHidden:NO];
         [_watchNowBtn setHidden:YES];
        [_watchNowBtn setBackgroundImage:[UIImage imageNamed:@"orangeBtn"] forState:UIControlStateNormal];
        addFavEntityName = @"movie";
        [_watchNowBtn setTitle:@"Watch Now" forState:UIControlStateNormal];
        [_addToFavBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
        [_addToFavBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [_addToFavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addToFavBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
        [_addToFavBtn addTarget:self action:@selector(addFavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [_freeBtn setTitle:@"Free" forState:UIControlStateNormal];
        [_allEpisodesBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
        [_AllSeasonBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
        [_showDetailAddFavBtn setHidden:NO];
        [_addToFavBtn setHidden:YES];
        addFavEntityName = @"show";
        [_watchNowBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
        [_watchNowBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [_watchNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _watchNowBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
        if([self isDeviceIpad]!=YES){
             [_watchNowBtn setHidden:YES];
            [_showDetailAddFavBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
            [_showDetailAddFavBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
            [_showDetailAddFavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _showDetailAddFavBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
            [_showDetailAddFavBtn addTarget:self action:@selector(addFavBtnAction) forControlEvents:UIControlEventTouchUpInside];
 
        }
        else{
             [_showDetailAddFavBtn setHidden:YES];
             [_watchNowBtn setHidden:NO];
           
        }
    }
    [_freeBtn setBackgroundColor:[UIColor clearColor]];
    [_allEpisodesBtn setBackgroundColor:[UIColor clearColor]];
    [_AllSeasonBtn setBackgroundColor:[UIColor clearColor]];
    [_overViewBtn setBackgroundColor:[UIColor clearColor]];
    [_castBtn setBackgroundColor:[UIColor clearColor]];
    [_genreBtn setBackgroundColor:[UIColor clearColor]];
    [_TopFullView setBackgroundColor:[UIColor clearColor]];
    [_leftBtnsView setBackgroundColor:[UIColor clearColor]];//Change
    [_BottomFullView setBackgroundColor:[UIColor clearColor]];
    [showDetailGridView setBackgroundColor:[UIColor clearColor]];
    [_tableViewCast setBackgroundColor:[UIColor clearColor]];
    [_castCollectionView setBackgroundColor:[UIColor clearColor]];
    [MiddleView setBackgroundColor:[UIColor clearColor]];
    
//    [[_watchTrailerBtn layer] setBorderColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor]];
//    [[_watchTrailerBtn layer] setBorderWidth:1.5];
//    [[_watchTrailerBtn layer] setCornerRadius:2.0f];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CALayer *TopBorder2 = [CALayer layer];
        TopBorder2.frame = CGRectMake(0.0f,  _addedExtraView.frame.size.height-1.0f, _addedExtraView.frame.size.width, 1.5f);
        TopBorder2.backgroundColor = [[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]CGColor];
        [_addedExtraView.layer addSublayer:TopBorder2];
        [_addedExtraView setBackgroundColor:[UIColor clearColor]];
    }
}
#pragma mark - loadOverView
-(void)loadOverView{
    isMoreClicked=NO;
    isOverViewClicked=YES;
    isCastClicked=NO;
    isGenreClicked=NO;
    [self setBorderForLeftButtons];
    [_castCollectionView setHidden:YES];
    
    if(isDespTextEmpty==YES){
        [despLabel setHidden:YES];
        [_genreLabel setHidden:YES];
        [_tableViewCast setHidden:NO];
        [_castCollectionView setHidden:NO];
        [_tableViewCast reloadData];
        [_castCollectionView reloadData];
//        if(isCastCountNotEmpty==YES){
//            
//        }
        if(arrayCast.count!=0){
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
                CGFloat tableHeight;
                [_castCollectionView setScrollEnabled:NO];
                [_castCollectionView setDelegate:self];
                [_castCollectionView setDataSource:self];
                tableHeight = topFullViewHeight - leftBtnsViewHeight;
                _castTableHeight.constant = _castCollectionView.contentSize.height;
                CGFloat leftViewHeight =  _castCollectionView.contentSize.height+_castBtn.frame.size.height;
                _leftViewHeightConstraint.constant =  leftViewHeight;
                CGFloat topHeight = tableHeight + leftViewHeight;
                _topFullViewHeightConstraint.constant = topHeight;
            }
            else {
                [_tableViewCast setScrollEnabled:YES];
                if(isTrailerHidden==YES){
                    _topFullViewHeightConstraint.constant = topFullViewHeight-(_watchTrailerBtn.frame.size.height);
                }
            }
        }

    }
    else if(isCastCountEmpty==YES) {
        [despLabel setHidden:YES];
        [_genreLabel setHidden:NO];
        [_tableViewCast setHidden:YES];
    }
    else {
        [despLabel setHidden:NO];
        [_genreLabel setHidden:YES];
        [_tableViewCast setHidden:YES];
        [self addLessToString];
    }
}
#pragma mark - loadCast
-(void)loadCast {
     isMoreClicked=NO;
    isOverViewClicked=NO;
    isCastClicked=YES;
    isGenreClicked=NO;
    [self setBorderForLeftButtons];
    [despLabel setHidden:YES];
    [_genreLabel setHidden:YES];
    [_tableViewCast setHidden:NO];
    [_castCollectionView setHidden:NO];
    [_tableViewCast reloadData];
    [_castCollectionView reloadData];
    [_tableViewCast scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    if(arrayCast.count!=0){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            CGFloat tableHeight;
            [_castCollectionView setScrollEnabled:NO];
            [_castCollectionView setDelegate:self];
            [_castCollectionView setDataSource:self];
           tableHeight = topFullViewHeight - leftBtnsViewHeight;
            _castTableHeight.constant = _castCollectionView.contentSize.height;
            CGFloat leftViewHeight =  _castCollectionView.contentSize.height+_castBtn.frame.size.height;
            _leftViewHeightConstraint.constant =  leftViewHeight;
            CGFloat topHeight = tableHeight + leftViewHeight;
            if(isPushedFromPayPerView)
             _topFullViewHeightConstraint.constant = topHeight+30;
            else
                _topFullViewHeightConstraint.constant = topHeight;

            
        }
        else {
            [_tableViewCast setScrollEnabled:YES];
            if(isTrailerHidden==YES){
                 _topFullViewHeightConstraint.constant = topFullViewHeight-(_watchTrailerBtn.frame.size.height);
            }
        }
    }
    if(isDespTextEmpty==YES){
        [despLabel setHidden:YES];
        [_genreLabel setHidden:NO];
        [_genreLabel setText:[genreName capitalizedString]];
        [_tableViewCast setHidden:YES];
        [_castCollectionView setHidden:YES];
    }
    else if(isCastCountEmpty==YES){
        [despLabel setHidden:YES];
        [_genreLabel setHidden:NO];
        [_genreLabel setText:[genreName capitalizedString]];
        [_tableViewCast setHidden:YES];
        [_castCollectionView setHidden:YES];
    }
    else{
        [_castCollectionView setHidden:NO];
        [despLabel setHidden:YES];
        [_genreLabel setHidden:YES];
        [_tableViewCast setHidden:NO];
        [_tableViewCast reloadData];
        [_tableViewCast scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        if(arrayCast.count!=0){
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
//                CGFloat tableHeight;
//                [_tableViewCast setScrollEnabled:NO];
//                tableHeight = topFullViewHeight - leftBtnsViewHeight;
//                _castTableHeight.constant = _tableViewCast.contentSize.height;
//                CGFloat leftViewHeight =  _tableViewCast.contentSize.height+_castBtn.frame.size.height;
//                _leftViewHeightConstraint.constant =  leftViewHeight;
//                CGFloat topHeight = tableHeight + leftViewHeight;
//                _topFullViewHeightConstraint.constant = topHeight;//-20;
            }
            else {
                [_tableViewCast setScrollEnabled:YES];
                if(isTrailerHidden==YES){
                    _topFullViewHeightConstraint.constant = topFullViewHeight-(_watchTrailerBtn.frame.size.height);
                }
                else{
                    _topFullViewHeightConstraint.constant = topFullViewHeight;
                }
                
            }
        }else {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
                
                _topFullViewHeightConstraint.constant = topFullViewHeight-leftBtnsViewHeight+_castBtn.frame.size.height+DespHeight;
            else{
                if(isTrailerHidden==YES){
                    _topFullViewHeightConstraint.constant = topFullViewHeight-(_watchTrailerBtn.frame.size.height);
                }
                else{
                    _topFullViewHeightConstraint.constant = topFullViewHeight;
                }
            }
        }

    }
    
       [self.view layoutIfNeeded];
}
#pragma mark - loadGenre
-(void)loadGenre{
    isMoreClicked=NO;
    isOverViewClicked=NO;
    isCastClicked=NO;
    isGenreClicked=YES;
    [self setBorderForLeftButtons];
    [despLabel setHidden:YES];
    [_genreLabel setHidden:NO];
    [_genreLabel setText:[genreName capitalizedString]];
    [_tableViewCast setHidden:YES];
    [_castCollectionView setHidden:YES];
    [_genreLabel setTextAlignment:NSTextAlignmentLeft];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        _leftViewHeightConstraint.constant =  80;
    }
    
    if (_genreLabel.text!=nil) {
        if(isTrailerHidden==YES){
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            {
                CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
        
                _topFullViewHeightConstraint.constant = topOriginalHeight+80;
//                if(s_boolMovies){
//                _topFullViewHeightConstraint.constant = topFullViewHeight;//leftBtnsViewHeight
//                }
//                else {
//                    _topFullViewHeightConstraint.constant = topFullViewHeight;//+_showDetailAddFavBtn.frame.size.height-100;
//                    
//                }

            }
            else{
                     _topFullViewHeightConstraint.constant = topFullViewHeight+_showDetailAddFavBtn.frame.size.height-10;//-(_watchTrailerBtn.frame.size.height);
                }
            
            
        }
        else{
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            {
                CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
                
                _topFullViewHeightConstraint.constant = topOriginalHeight+80;//                if(s_boolMovies){
//                    _topFullViewHeightConstraint.constant = topFullViewHeight;//+leftBtnsViewHeight;//leftBtnsViewHeight//raji
//                }
//                else{
//                    _topFullViewHeightConstraint.constant = topFullViewHeight+_showDetailAddFavBtn.frame.size.height;
//                }
            }
            else{
                _topFullViewHeightConstraint.constant = topFullViewHeight+_showDetailAddFavBtn.frame.size.height;
            }
            
        }
    }
    else {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
        
        _topFullViewHeightConstraint.constant = topOriginalHeight+80;//            if(s_boolMovies){
//                _topFullViewHeightConstraint.constant = topFullViewHeight-70;//+_castBtn.frame.size.height+DespHeight
//            }
//            else{
//                _topFullViewHeightConstraint.constant = topFullViewHeight-leftBtnsViewHeight+_castBtn.frame.size.height+DespHeight;
//            }
        
        }else {
             ipadSubViewHeight.constant = ipadSubViewFloatHeight;
            _topFullViewHeightConstraint.constant = topFullViewHeight;
        }
        
    }
}
#pragma mark - loadfreeBtnItems
-(void)loadfreeBtnItems{
    [COMMON LoadIcon:_BottomFullView];
    isSeasonEpisodes=NO;
    isFreeClicked=YES;
    isAllEpisodesClicked=NO;
    isAllSeasonsClicked=NO;
    [self setBorderForBottomButtons];
    if(isPushedFromPayPerView==YES || isToggledAll==YES){
        if(isFreeCountEmpty==YES){
            currentShowGridArray = showFullEpisodesArray;
        }
        else{
            currentShowGridArray = freeLatestArray;
        }
    }
    else{
         currentShowGridArray = freeLatestArray;
    }
    [self setShowScrollHeight];
     //[showDetailGridView reloadData];
    [COMMON removeLoading];
    
}
#pragma mark - loadAllEpisodesBtnItems
-(void)loadAllEpisodesBtnItems{
    [COMMON LoadIcon:_BottomFullView];
    isFreeClicked=NO;
    isAllEpisodesClicked=YES;
    isAllSeasonsClicked=NO;
    isSeasonEpisodes=NO;
    [self setBorderForBottomButtons];
    if(isFreeCountEmpty==YES||isEpisodeNotNeedInFree==YES){
        if([showFullSeasonsArray count]==0){
            [COMMON removeLoading];
        }
        else{
            currentShowGridArray = showFullSeasonsArray;
            [self setShowScrollHeight];
             //[showDetailGridView reloadData];
            [COMMON removeLoading];
        }
    }
    else{
        if([showFullEpisodesArray count]==0){
            [COMMON removeLoading];
        }
        else{
            currentShowGridArray = showFullEpisodesArray;
            [self setShowScrollHeight];
           // [showDetailGridView reloadData];
            [COMMON removeLoading];
        }
    }
}
#pragma mark - loadAllSeasonBtnItems
-(void)loadAllSeasonBtnItems{
    isSeasonEpisodes=NO;
    [COMMON LoadIcon:_BottomFullView];
    isFreeClicked=NO;
    isAllEpisodesClicked=NO;
    isAllSeasonsClicked=YES;
    [self setBorderForBottomButtons];
    currentShowGridArray = showFullSeasonsArray;
    [self setShowScrollHeight];
   // [showDetailGridView reloadData];
    [COMMON removeLoading];
}
#pragma mark - loadFreeData
-(void)loadFreeData{
    int nPPV;
    if(isPushedFromPayPerView==YES){
        nPPV =PAY_MODE_PAID;
    }
    else{
        nPPV =PAY_MODE_FREE; //ALWAYS PAY MODE IS FREE
    }
    [[RabbitTVManager sharedManager] getShowFreeDetails:^(AFHTTPRequestOperation * request, id responseObject) {
        showFullFreeArray = [[NSMutableArray alloc] initWithArray:responseObject];
        [_TopFullView setHidden:NO];
        
        if([showFullFreeArray count] != 0){
            [_BottomFullView setHidden:NO];
            NSMutableArray *tempSeasonArray = [[NSMutableArray alloc] initWithArray:responseObject];
            currentShowGridArray = tempSeasonArray;
            isFreeButtonClicked = YES;
            [self loadLatestEpisodesVideos];
            [self setShowScrollHeight];//14septraji
            [showDetailGridView reloadData];
            if(isToggledAll==YES){
               [self loadEpisodeData];
            }
            else{
                if([freeLatestArray count]!=0){
                    isEpisodeNotNeedInFree =YES;
                    [_freeBtn setTitle:@"Free" forState:UIControlStateNormal];
                    [_allEpisodesBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
                    [_AllSeasonBtn setTitle:@"" forState:UIControlStateNormal];
                    [_AllSeasonBtn setUserInteractionEnabled:NO];
                }
                else{
                    [self hideBottomViewFreeCountEmpty];
                }
            }
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        else if([showFullFreeArray count] == 0){
            //[_BottomFullView setHidden:NO];
            if(isToggledAll==YES){
                [self loadToggleIsAll];
            }
            else{
                [self hideBottomViewFreeCountEmpty];
            }
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
    }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(isToggledAll==YES){
            [self loadToggleIsAll];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nShowID:[nID intValue] nPPV:nPPV];
}
#pragma  mark - loadToggleIsAll
-(void)loadToggleIsAll{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _middleViewHeightConstraint.constant = 40;//new change raji 24 oct2016
    }
    else{
        _middleViewHeightConstraint.constant = 0;
    }
    
    [_LatestEpisodesLabel setHidden:YES];
    [self loadEpisodeData];
    isFreeCountEmpty=YES;
    [_freeBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
    [_allEpisodesBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
    [_AllSeasonBtn setTitle:@"" forState:UIControlStateNormal];
    [_AllSeasonBtn setUserInteractionEnabled:NO];
}
#pragma  mark - hideBottomViewFreeCountEmpty
-(void)hideBottomViewFreeCountEmpty{
    isFreeClicked=NO;
     [_LatestEpisodesLabel setHidden:NO];
    //[_BottomFullView removeFromSuperview];
    [_addedExtraView setHidden:YES];
    [_watchLatestLabel setHidden:YES];
    [showDetailGridView setHidden:YES];
    [_BottomFullView setHidden:YES];
    [_freeBtn setHidden:YES];
    [_allEpisodesBtn setHidden:YES];
    [_AllSeasonBtn setHidden:YES];
}

#pragma mark - loadEpisodeData
-(void)loadEpisodeData{
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
    [[RabbitTVManager sharedManager]getShowEpisodesWithShowId:^(AFHTTPRequestOperation * request, id responseObject) {
        showFullEpisodesArray = [[NSMutableArray alloc] initWithArray:responseObject];
        [_TopFullView setHidden:NO];
        if([showFullEpisodesArray count]==0){
            [_BottomFullView setHidden:YES];
            [_watchLatestLabel setHidden:YES];
            [COMMON removeLoading];
        }
        else if([currentShowGridArray count]==0 || currentShowGridArray==nil){
            [_BottomFullView setHidden:NO];
            isFreeCountEmpty=YES;
            [self loadfreeBtnItems];
            [_freeBtn setTitle:@"All Episodes" forState:UIControlStateNormal];
            [_allEpisodesBtn setTitle:@"All Seasons" forState:UIControlStateNormal];
            [_AllSeasonBtn setTitle:@"" forState:UIControlStateNormal];
            [_AllSeasonBtn setUserInteractionEnabled:NO];
            [self setShowScrollHeight];
        }
    }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hideBottomViewFreeCountEmpty];
    } nShowID:[nID intValue] nPPV:nPPV];
}
#pragma mark - loadEpisodeDetails
-(void) loadEpisodeDetails{
    int nEpisodeId = self.episodeId.intValue;
    [[RabbitTVManager sharedManager] getEpisodeDetail:^(AFHTTPRequestOperation *request, id responseObject) {
        {
            episodeDetailDictionary = (NSDictionary*) responseObject;
            [self setShowDetail];
        }
    } nID:nEpisodeId];
}
#pragma mark - loadShowData
- (void)loadShowData {
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
    [self performSelector:@selector(removeLoadingIconInShowView) withObject:nil afterDelay:3];
    if(s_boolMovies){
        [[RabbitTVManager sharedManager] getMovieDetail:^(AFHTTPRequestOperation *request, id responseObject) {
            movieDetailDictionary = (NSDictionary*) responseObject;
            [self setMovieDetail];
            [_LatestEpisodesLabel setHidden:YES];
            [_TopFullView setHidden:NO];
            [_BottomFullView setHidden:YES];
            [_watchLatestLabel setHidden:YES];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppCommon showSimpleAlertWithMessage:@"No Data"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        } nMovieID:nMovieID nPPV:nPPV];
    } else {
        [[RabbitTVManager sharedManager] getShowDetail:^(AFHTTPRequestOperation *request , id responseObject) {
            showDetailDictionary = (NSDictionary*) responseObject;
            NSLog(@"showDetailDictionary%@",showDetailDictionary);
            
            [_TopFullView setHidden:NO];
            if(isEpisode==YES){
                //[_BottomFullView setHidden:NO];
            }
            else{
                [_BottomFullView setHidden:YES];
                [_watchLatestLabel setHidden:YES];
            }
            [self setShowDetail];
           
            
        }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppCommon showSimpleAlertWithMessage:@"No Data"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
        }nShowID:nMovieID];
    }
}
-(void)removeLoadingIconInShowView{
    [COMMON removeLoading];
}
#pragma mark - setShowDetail
-(void) setShowDetail{
    self.linksTrailer = (NSMutableArray*)showDetailDictionary[@"trailers"];
    watchTrailerArray = (NSMutableArray*)showDetailDictionary[@"trailers"];
    arrayCast = showDetailDictionary[@"actors"];
    [_tableViewCast reloadData];
    [_castCollectionView reloadData];
    NSString* strName =showDetailDictionary[@"name"];
     NSString* strDescription;;
    
       strDescription = showDetailDictionary[@"description"];
    NSString* strPosterUrl;
     isTrailerHidden=YES;
    [self setShowScrollHeight];
//    if((watchTrailerArray.count)!=0 && watchTrailerArray != (id) [NSNull null]) {
//        if([[watchTrailerArray objectAtIndex:0]isEqual:@""]){
//            [_watchTrailerBtn setHidden:YES];
//            isTrailerHidden=YES;
//            [self setShowScrollHeight];
//        }
//        else{
//            [_watchTrailerBtn setHidden:NO];
//            isTrailerHidden=NO;
//        }
//    }
//    else{
//        [_watchTrailerBtn setHidden:YES];
//        isTrailerHidden=YES;
//        [self setShowScrollHeight];
//
//        
//    }
       strPosterUrl = showDetailDictionary[@"poster_url"];
    NSString* strRating = showDetailDictionary[@"rating"];
    NSMutableDictionary* networkDict = showDetailDictionary[@"network"];
    NSString* strNetwork;
    
    if ((NSMutableDictionary *)[NSNull null] != networkDict){
        strNetwork = [networkDict objectForKey:@"name"];
    }
    else
        strNetwork = @"";
    
    NSString* tempRunTime = showDetailDictionary[@"runtime"];
    NSString *strRunTime = [NSString stringWithFormat: @"%@", tempRunTime];
   
    
    if ((NSString *)[NSNull null] == strDescription || strDescription == nil) {
        strDescription=@"";
    }
    if ((NSString *)[NSNull null] == strRating || strRating == nil) {
        strRating=@"";
    }
    if ((NSString *)[NSNull null] == strRunTime || strRunTime == nil) {
        strRunTime=@"";
    }
//    if ((NSString *)[NSNull null] == strNetwork || strNetwork == nil) {
//        strNetwork=@"";
//    }
    genreName = @"";
    NSURL * urlPoster = [NSURL URLWithString:strPosterUrl];
    [self.showTitle setText:strName];
    
    if([strRunTime isEqualToString:@"0"]||[strRunTime isEqualToString:@""]){
        strRunTime =@"N/A";
    }
    else{
        strRunTime = [NSString stringWithFormat:@"%@Minutes",strRunTime];
    }
    
    NSString *currentNetwork=@"";
    if(![strNetwork isEqualToString:@""]){
        currentNetwork= [NSString stringWithFormat:@"Network: %@",strNetwork];
    }
    NSString *ratingNetworkStr = [NSString stringWithFormat:@"Runtime: %@ %@", strRunTime,currentNetwork];
    
    if(![strRating isEqualToString:@""]){
        [self.runtimeLabel setText:[NSString stringWithFormat:@"%@", strRating]];
        [_runtimeLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:186.0/255.0f alpha:1]];

    }
    [self.runtimeDataLabel setText:ratingNetworkStr];
    _runtimeDataLabel.numberOfLines=0;
    _runtimeLabel.textColor = [UIColor whiteColor];
    _runtimeDataLabel.textColor = [UIColor whiteColor];
    [_runtimeDataLabel setTextAlignment:NSTextAlignmentLeft];
    
    if([strRating isEqualToString:@""]&&[strNetwork isEqualToString:@""]){
        [_runtimeDataLabel setTextAlignment:NSTextAlignmentCenter];
    }
    [_runtimeLabel setTextAlignment:NSTextAlignmentLeft];
     //_runtimeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueBtn.png"]];
   
    [self.showImageView setImageWithURL:urlPoster];
     genreName=@"";
    [self settingUpLeftViewButtons:strDescription];
    
}
#pragma mark - settingUpLeftViewButtons
-(void)settingUpLeftViewButtons:(NSString*)strDescription{
     [_leftBtnsView setHidden:NO];
    if(![strDescription isEqualToString:@""]){
        DespHeight = despLabel.frame.size.height;
        [despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
        despLabel.textColor = [UIColor whiteColor];
        despLabel.numberOfLines=0;
        strDescriptionText = strDescription;
        [despLabel setBackgroundColor:[UIColor clearColor]];
        [self setupStoreTitleLabel];
        [_overViewBtn setTitle:@"Overview" forState:UIControlStateNormal];
        if([arrayCast count]==0){
            if(![genreName isEqualToString:@""]){
                isCastCountEmpty=YES;
                [_castBtn setTitle:@"Genre" forState:UIControlStateNormal];
                [_genreBtn setTitle:@"" forState:UIControlStateNormal];
                [_genreBtn setUserInteractionEnabled:NO];
            }
            else{
                [_castBtn setTitle:@"" forState:UIControlStateNormal];
                [_castBtn setUserInteractionEnabled:NO];
                [_genreBtn setTitle:@"" forState:UIControlStateNormal];
                [_genreBtn setUserInteractionEnabled:NO];
            }
            
            
        }
        if([genreName isEqualToString:@""]){
            [_genreBtn setTitle:@"" forState:UIControlStateNormal];
            [_genreBtn setUserInteractionEnabled:NO];
        }
        
    }
    else{
        if([genreName isEqualToString:@""]){
            [_genreBtn setTitle:@"" forState:UIControlStateNormal];
            [_genreBtn setUserInteractionEnabled:NO];
        }
        if([arrayCast count]==0){
            isCastCountEmpty=YES;
            if(![genreName isEqualToString:@""]){
                [_overViewBtn setTitle:@"Genre" forState:UIControlStateNormal];
                [_genreLabel setText:[genreName capitalizedString]];
                [_castBtn setTitle:@"" forState:UIControlStateNormal];
                [_genreBtn setTitle:@"" forState:UIControlStateNormal];
                [_castBtn setUserInteractionEnabled:NO];
                [_genreBtn setUserInteractionEnabled:NO];
                [despLabel setHidden:YES];
                [_tableViewCast setHidden:YES];
                [_castCollectionView setHidden:YES];
                [_genreLabel setHidden:NO];
            }
            else{
                isLeftViewHidden=YES;
                [_leftBtnsView setHidden:YES];
                if([self isDeviceIpad]!=YES){
                    _leftViewHeightConstraint.constant=0;
                    _topFullViewHeightConstraint.constant = topFullViewHeight-leftBtnsViewHeight;

                }
                
            }
            
            
        }
        else{
            isDespTextEmpty=YES;
            isCastCountNotEmpty=YES;
            [_overViewBtn setTitle:@"Cast" forState:UIControlStateNormal];
            [despLabel setHidden:YES];
            [_tableViewCast setHidden:NO];
            [_tableViewCast reloadData];
            [_castCollectionView setHidden:NO];
            [_castCollectionView reloadData];
           
            if(arrayCast.count!=0){
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
                    CGFloat tableHeight;
                    [_castCollectionView setScrollEnabled:NO];
                    [_castCollectionView setDelegate:self];
                    [_castCollectionView setDataSource:self];
                    tableHeight = topFullViewHeight - leftBtnsViewHeight;
                    _castTableHeight.constant = _castCollectionView.contentSize.height;
                    CGFloat leftViewHeight =  _castCollectionView.contentSize.height+_castBtn.frame.size.height;
                    _leftViewHeightConstraint.constant =  leftViewHeight;
                    CGFloat topHeight = tableHeight + leftViewHeight;
                    _topFullViewHeightConstraint.constant = topHeight;
                }
                else {
                    [_tableViewCast setScrollEnabled:YES];
                    if(isTrailerHidden==YES){
                        _topFullViewHeightConstraint.constant = topFullViewHeight-(_watchTrailerBtn.frame.size.height);
                    }
                }
            }
            if(![genreName isEqualToString:@""]){
                [_castBtn setTitle:@"Genre" forState:UIControlStateNormal];
            }
            else{
                [_castBtn setTitle:@"" forState:UIControlStateNormal];
                [_castBtn setUserInteractionEnabled:NO];
                [_genreLabel setHidden:YES];
            }
            [_genreBtn setTitle:@"" forState:UIControlStateNormal];
            [_genreBtn setUserInteractionEnabled:NO];
            
        }
        
    }

}
#pragma mark - setupStoreTitleLabel
- (void) setupStoreTitleLabel {
    despLabel.delegate = self;
    [self.despLabel setText:strDescriptionText];
    [self.despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
    self.despLabel.numberOfLines = 2;
    NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@" more..." attributes:@{
                                                                                                       NSForegroundColorAttributeName:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1],NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],NSLinkAttributeName : [NSURL URLWithString:@"more..."]}];
    
    [despLabel setAttributedTruncationToken:showMore];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if(isTrailerHidden==YES){
            _topFullViewHeightConstraint.constant = topFullViewHeight - (_watchTrailerBtn.frame.size.height);
        }
        else{
            _topFullViewHeightConstraint.constant = topFullViewHeight;
   
        }
    } else{
        if(s_boolMovies){
             _topFullViewHeightConstraint.constant = topFullViewHeight+_castBtn.frame.size.height+DespHeight;
        }
        else{
            if(isMoreClicked==NO && isOverViewClicked==NO && isCastClicked==YES && isGenreClicked==NO){
            }else
                _topFullViewHeightConstraint.constant = topFullViewHeight-100;//-leftBtnsViewHeight+_castBtn.frame.size.height+DespHeight;
        }

    
    }

   
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"%@ pressed", url);
    if ([[url absoluteString] isEqualToString:@"more..."]) {
        NSLog(@"'Read More'...");
        
        despLabel.numberOfLines = 99;
        
        NSString *despTextWithLess = [NSString stringWithFormat:@"%@ %@",strDescriptionText, @"less..."];//less...
        CGRect rect = [despTextWithLess boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: label.font}
                                                     context:nil];
        _despLabelHeight.constant = rect.size.height+10;
        _leftViewHeightConstraint.constant = rect.size.height+40;

         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
             _leftViewHeightConstraint.constant  = _despLabelHeight.constant + _castBtn.frame.size.height;
             CGFloat contentHeight =  leftBtnsViewHeight+_despLabelHeight.constant+_watchNowBtn.frame.size.height;//+50

             if(topFullViewHeight < contentHeight){
                 CGFloat height = contentHeight - topFullViewHeight;
                 _topFullViewHeightConstraint.constant =_TopFullView.frame.size.height+height;
                
             }else {
                if(isTrailerHidden==YES){
                    _topFullViewHeightConstraint.constant = topFullViewHeight-_watchTrailerBtn.frame.size.height;

                }else
                    _topFullViewHeightConstraint.constant = topFullViewHeight;
             }

         } else {
             CGFloat leftViewHeight = _despLabelHeight.constant + _castBtn.frame.size.height;
             CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
             CGFloat contentHeight = topOriginalHeight + leftViewHeight;
             _leftViewHeightConstraint.constant  = leftViewHeight;//-50;
             if(topFullViewHeight < contentHeight){
                 _leftViewHeightConstraint.constant  = leftViewHeight;//-80;
                 CGFloat height = contentHeight - topFullViewHeight;
                 if(isPushedFromPayPerView)
                     _topFullViewHeightConstraint.constant = topFullViewHeight+height+40;
                 else
                    _topFullViewHeightConstraint.constant =topFullViewHeight+height;
             } else {
                 if(contentHeight < topFullViewHeight) {
                     CGFloat Height1 = topFullViewHeight - contentHeight;
                 _topFullViewHeightConstraint.constant =topFullViewHeight-Height1;//+rect.size.height-50
                 }else
                    _topFullViewHeightConstraint.constant = topFullViewHeight;
             }
         }
        
        isMoreClicked=YES;
        
         [self.view layoutIfNeeded];

        [despLabel setText:despTextWithLess afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            //code
            NSRange linkRange = [[mutableAttributedString string] rangeOfString:@"less..." options:NSCaseInsensitiveSearch];
    //less...
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] range:linkRange];
            [mutableAttributedString addAttribute:NSFontAttributeName value:[COMMON getResizeableFont:Roboto_Regular(11)] range:linkRange];
            [mutableAttributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"less..."] range:linkRange];//less...
            
            return mutableAttributedString;
        }];
        
       //less...
        NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@"less..." attributes:@{
                                                                                                           NSForegroundColorAttributeName:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1],
                                                                                                           NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],
                                                                                                           NSLinkAttributeName : [NSURL URLWithString:@"less..."]
                                                                                                           }];//less...
        
        [despLabel setAttributedTruncationToken:showMore];

    }
    else {
        isMoreClicked=NO;
        [self addLessToString];
    }
}
#pragma mark - addLessToString
-(void)addLessToString{
    despLabel.numberOfLines = 2;
    
    NSAttributedString *showMore = [[NSAttributedString alloc] initWithString:@" more..." attributes:@{
                                                                                                       NSForegroundColorAttributeName:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1],
                                                                                                       NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(11)],
                                                                                                       NSLinkAttributeName : [NSURL URLWithString:@"more..."]
                                                                                                       }];
    
    
     _despLabelHeight.constant =DespHeight;
      [despLabel setAttributedTruncationToken:showMore];
    [despLabel setText:strDescriptionText];
   
    if(despLabel.text!=nil) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            if(isTrailerHidden==YES){
                _topFullViewHeightConstraint.constant = topFullViewHeight - (_watchTrailerBtn.frame.size.height);
            }
            else {
                _topFullViewHeightConstraint.constant = topFullViewHeight;
                
            }
            
        } else{
            CGFloat watchBtnHeight= 0.0f;
            if(isTrailerHidden==YES){
                watchBtnHeight = _watchTrailerBtn.frame.size.height;
            }
            
          _leftViewHeightConstraint.constant = leftFullViewHeight;
            if(s_boolMovies){
                _topFullViewHeightConstraint.constant = topFullViewHeight+_castBtn.frame.size.height+DespHeight+_showDetailAddFavBtn.frame.size.height;
                _leftViewHeightConstraint.constant = 80;
            }
            else{
                CGFloat leftViewHeight =  _castBtn.frame.size.height+40;
                _leftViewHeightConstraint.constant =  leftViewHeight;
                NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_overViewBtn
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1.0
                                                                                     constant:30];
                [_leftBtnsView addConstraint:heightConstraint];

                  CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
                    _topFullViewHeightConstraint.constant = topOriginalHeight+leftViewHeight;

//                _topFullViewHeightConstraint.constant = topFullViewHeight-100;

            }
         
        }
    }
    
      [self.view layoutIfNeeded];
}

#pragma mark - Setting Movie and Show Details
-(void) setMovieDetail{
    
    [self setUpFreePaidAppList];
    
    NSString* strDescription = movieDetailDictionary[@"description"];
    if ((NSString *)[NSNull null] == strDescription || strDescription == nil) {
        strDescription=@"";
    }
    NSString* strPosterUrl = movieDetailDictionary[@"poster_url"];
    NSString* strRating = movieDetailDictionary[@"rating"];
    NSString* tempRunTime = movieDetailDictionary[@"runtime"];
    NSMutableDictionary* networkDict = showDetailDictionary[@"network"];
    NSString* strNetwork;
    
    if ((NSMutableDictionary *)[NSNull null] != networkDict){
        strNetwork = [networkDict objectForKey:@"name"];
    }
    else
        strNetwork = @"";
    NSString *strRunTime = [NSString stringWithFormat: @"%@", tempRunTime];
    NSURL * urlPoster = [NSURL URLWithString:strPosterUrl];
    
    strPosterUrl = movieDetailDictionary[@"poster_url"];
    
    if ((NSString *)[NSNull null] == strRating || strRating == nil) {
        strRating=@"";
    }
    if ((NSString *)[NSNull null] == strRunTime || strRunTime == nil) {
        strRunTime=@"";
    }
    if ((NSString *)[NSNull null] == strNetwork || strNetwork == nil) {
        strNetwork=@"";
    }
    if(isEpisode==YES){
        //[self.labelName setText:episodeTitle];
    }else{
        [_overViewBtn setTitle:@"Overview" forState:UIControlStateNormal];
        [_castBtn setTitle:@"Cast" forState:UIControlStateNormal];
        [_genreBtn setTitle:@"Genre" forState:UIControlStateNormal];
    }
    
    if([strRunTime isEqualToString:@"0"]||[strRunTime isEqualToString:@""]){
        strRunTime =@"N/A";
    }
    else{
        strRunTime = [NSString stringWithFormat:@"%@Minutes",strRunTime];
    }
    NSString *currentNetwork=@"";
    if(![strNetwork isEqualToString:@""]){
        currentNetwork= [NSString stringWithFormat:@"Network: %@",strNetwork];
    }
    NSString *ratingNetworkStr = [NSString stringWithFormat:@"Runtime: %@ %@", strRunTime,currentNetwork];
    [self.runtimeDataLabel setText:ratingNetworkStr];
    if(![strRating isEqualToString:@""]){
        [self.runtimeLabel setText:[NSString stringWithFormat:@"%@", strRating]];
        [_runtimeLabel setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:186.0/255.0f alpha:1]];
   
    }
    _runtimeDataLabel.numberOfLines=0;
    _runtimeLabel.textColor = [UIColor whiteColor];
    _runtimeDataLabel.textColor = [UIColor whiteColor];
    [_runtimeDataLabel setTextAlignment:NSTextAlignmentLeft];
    
    if([strRating isEqualToString:@""]&&[strNetwork isEqualToString:@""]){
        [_runtimeDataLabel setTextAlignment:NSTextAlignmentCenter];
    }
    [_runtimeLabel setTextAlignment:NSTextAlignmentLeft];
    // _runtimeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueBtn.png"]];
    
    [_showImageView setHidden:YES];
    [self.portraitMovieImageView setImageWithURL:urlPoster];
    
    [self.textView setHidden:YES];
    [despLabel setUserInteractionEnabled:YES];
//    despLabel=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(_overViewBtn.frame.origin.x+5, _overViewBtn.frame.size.height+10, _leftBtnsView.frame.size.width-10,40)];
//    [self.leftBtnsView addSubview:despLabel];
    genreName=@"";
    [self settingUpLeftViewButtons:strDescription];
//    DespHeight = despLabel.frame.size.height;
//    [despLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
//    despLabel.textColor = [UIColor whiteColor];
//    despLabel.numberOfLines=0;
//    strDescriptionText = strDescription;
//    
//    [despLabel setBackgroundColor:[UIColor clearColor]];//Change
//    
//    [self setupStoreTitleLabel];
}
#pragma mark - setUpFreePaidAppList
-(void)setUpFreePaidAppList{
    
    self.linksTrailer = (NSMutableArray*)movieDetailDictionary[@"trailers"];
    watchTrailerArray = (NSMutableArray*)movieDetailDictionary[@"trailers"];
    
    if(movieDetailDictionary[@"sources"] != nil  &&
       movieDetailDictionary[@"sources"][@"mobile"] != nil &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"] != nil    &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"free"] != nil ){
        if(isPushedFromPayPerView!=YES){
            appFreeItems = (NSMutableArray *)movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"free"];
        }
    }
    if(movieDetailDictionary[@"sources"] != nil  &&
       movieDetailDictionary[@"sources"][@"mobile"] != nil &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"] != nil    &&
       movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"paid"] != nil ){
        if(isToggledFree!=YES){
            appPaidItems = (NSMutableArray *)movieDetailDictionary[@"sources"][@"mobile"][@"ios"][@"paid"];
        }
    }
    
    NSLog(@"paidItems%@",paidItems);
    arrayCast = movieDetailDictionary[@"actors"];
    [_tableViewCast reloadData];
    [_castCollectionView reloadData];
    if (watchTrailerArray != (id) [NSNull null]) {
        if([watchTrailerArray count]!=0) {
            if([[watchTrailerArray objectAtIndex:0]  isEqual:@""]){
                if(s_boolMovies){
                     [_watchTrailerBtn setHidden:YES];
                }
                else{
                    [_watchTrailerBtn setHidden:NO];
                    [_addToFavBtn setHidden:YES];
                    [_watchTrailerBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
                    [_watchTrailerBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
                    [_watchTrailerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _watchTrailerBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
                    [_watchTrailerBtn addTarget:self action:@selector(addFavBtnAction) forControlEvents:UIControlEventTouchUpInside];
                    isTrailerHidden=YES;
                    [self setShowScrollHeight];
                }
                
            }
            else{
                [_watchTrailerBtn setHidden:NO];
                [[_watchTrailerBtn layer] setBorderColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor]];
                [[_watchTrailerBtn layer] setBorderWidth:1.5];
                [[_watchTrailerBtn layer] setCornerRadius:2.0f];
                isTrailerHidden=NO;
            }
        }
        else{
            [self centreAddToFavBtn];
        }
    }
    else  {
        [self settingUpAddToFavBtn];
    }
    
    if([appFreeItems count]!=0){
        appFreeItems = [self addFreePaidKeyToArray:appFreeItems key:@"free"];
    }
    if([appPaidItems count]!=0){
        appPaidItems = [self addFreePaidKeyToArray:appPaidItems key:@"paid"];
    }

    
    
    appPaidItems =[self checkformatsArrayInAppListMovie:appPaidItems];
    //appFreeItems = appFreeItems;//[self checkformatsArrayInAppListMovie:appFreeItems];
    
    
    if(isPushedFromPayPerView!=YES){
        NSMutableArray * tempFreeArray = [NSMutableArray new];
        if ([appFreeItems count]!=0) {
            if([paidNullArray count]!=0){
                tempFreeArray = [[appFreeItems arrayByAddingObjectsFromArray:paidNullArray] mutableCopy];
                appFreeItems = tempFreeArray;
            }
        }
    }
    
    if([appPaidItems count]!=0|| [appFreeItems count]!=0){
        [_watchNowBtn setHidden:NO];
        
    }
    
//    if([appPaidItems count]!=0){
//        appShowAllItems= appPaidItems;
//        freeRentStr =@"Paid";
//    }
//    else{
//        appShowAllItems= appFreeItems;
//        freeRentStr =@"Free";
//    }
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

#pragma mark - settingUpAddToFavBtn
-(void)settingUpAddToFavBtn{
    if(s_boolMovies){
        //[_watchTrailerBtn setHidden:NO];
    }
    else{
        [_watchTrailerBtn setHidden:NO];
        [_addToFavBtn setHidden:YES];
        [_watchTrailerBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
        [_watchTrailerBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
        [_watchTrailerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _watchTrailerBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
        [_watchTrailerBtn addTarget:self action:@selector(addFavBtnAction) forControlEvents:UIControlEventTouchUpInside];
        isTrailerHidden=YES;
        [self setShowScrollHeight];
    }
   
}
#pragma mark - centreAddToFavBtn
-(void)centreAddToFavBtn{
    if([appFreeItems count]==0 || [appPaidItems count]==0){
        if(s_boolMovies){
        }
        else{
            [_showDetailAddFavBtn setHidden:NO];
            [_watchNowBtn setHidden:YES];
            [_watchTrailerBtn setHidden:YES];
            [_addToFavBtn setHidden:YES];
            [_showDetailAddFavBtn setTitle:@"Add To Favourites" forState:UIControlStateNormal];
            [_showDetailAddFavBtn setBackgroundImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];
            [_showDetailAddFavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _showDetailAddFavBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
            [_showDetailAddFavBtn addTarget:self action:@selector(addFavBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

#pragma mark - checkformatsArrayInAppListMovie
-(NSMutableArray*)checkformatsArrayInAppListMovie:(NSMutableArray *)currentAppListArray{
    
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
                NSLog(@"paidNullArray%@",paidNullArray);
            }
        }
        
    }
    return newListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - onTrailersShow
- (void)onTrailersShow:(id)sender {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TrailerMovieView" owner:self options:nil];
    NSLog(@"subviewArray%@",subviewArray);
    mainView = [subviewArray objectAtIndex:0];
    
    NSLog(@"watchTrailerArray%@",watchTrailerArray);
    if (watchTrailerArray != (id) [NSNull null]) {
        if([watchTrailerArray count]!=0) {
            [self loadTrailerData];
        }
    }
   
}

-(void)loadTrailerData{
    
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
            NSString * trailerLink = [watchTrailerArray objectAtIndex:0];
            
            if([trailerLink containsString:@"youtube"]){
                [self setUpTrailerView];
            }
            else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[watchTrailerArray objectAtIndex:0]]];
               }
        }
    }

}
-(void)setUpTrailerView{
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
#pragma mark - getwatchNow

-(void)loadAppListHeaderView:(NSMutableArray *)appListArray{
    
    for(UIView *view in appListHeaderView.subviews){
        [view removeFromSuperview];
    }
    for(UIView *view in MiddleView.subviews){
        [view removeFromSuperview];
    }
    for(UIView *view in appListView.subviews){
        [view removeFromSuperview];
    }
    for(UIView *view in appListScrollView.subviews){
        [view removeFromSuperview];
    }
    
    CGFloat appListHeaderViewHeight =0.0f;
    CGFloat appListHeaderViewWidth =0.0f;
    CGFloat appListTopBorderWidth =0.0f;
    
    if([self isDeviceIpad]==YES){
        appListHeaderViewHeight = 70;
        appListHeaderViewWidth = SCREEN_WIDTH;
        appListTopBorderWidth =SCREEN_WIDTH;
        //[_leftBtnsView removeFromSuperview];
       
    }
    else{
        appListHeaderViewHeight = 50;
        appListHeaderViewWidth = SCREEN_WIDTH-(_leftBtnsView.frame.origin.x+5);
        appListTopBorderWidth =SCREEN_WIDTH-(_leftBtnsView.frame.origin.x+5);
        for(UIView *view in _leftBtnsView.subviews){
            [view removeFromSuperview];
            
        }
    }
    
    appListHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0, appListHeaderViewWidth,appListHeaderViewHeight)];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        // appListView = [[UIView alloc] initWithFrame:CGRectMake(0, _LatestEpisodesLabel.frame.origin.y, SCREEN_WIDTH,middleViewHeight+20 )];
         appListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,middleViewHeight)];
    }else{
   // appListView = [[UIView alloc] initWithFrame:CGRectMake(0, _watchTrailerBtn.frame.origin.y+_watchTrailerBtn.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT/2.5)];
        //appListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2.5)];
        appListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-(_leftBtnsView.frame.origin.x+5), leftBtnsViewHeight)];
    }
    [MiddleView setBackgroundColor:[UIColor clearColor]];
    [appListView setBackgroundColor:[UIColor clearColor]];
    _middleViewHeightConstraint.constant = middleViewHeight;
    _leftViewHeightConstraint.constant = leftBtnsViewHeight;
    
    if([self isDeviceIpad]==YES){
        [MiddleView addSubview:appListView];
    }
    else{
        [_leftBtnsView addSubview:appListView];
    }
    
    
    CGFloat freeLabelWidth,rentLabelWidth,commonSDBtnWidth,commonSDBtnHeight;
    //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *appListTopBorder;
    appListTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,appListTopBorderWidth,1.5)];
    appListTopBorder.backgroundColor = [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1];
    [appListTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    //[appListView addSubview:appListTopBorder];
    
    UIView *freeRentView = [[UIView alloc]initWithFrame:CGRectMake(0,0, appListHeaderView.frame.size.width/2,50)];
    [freeRentView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat commonLabelYpos=10,freeSwitchYPos=5;
    if([self isDeviceIpad]==YES){
        commonLabelYpos=13;
        freeSwitchYPos=7;
        freeLabelWidth=freeRentView.frame.size.width/3.8;
        rentLabelWidth=freeRentView.frame.size.width/2.4;
        commonSDBtnWidth=45;
        commonSDBtnHeight=30;
 
    }
    else{
        commonLabelYpos=12;
        freeSwitchYPos =5;
        freeLabelWidth=freeRentView.frame.size.width/3.8;
        rentLabelWidth=freeRentView.frame.size.width/2.4;
        commonSDBtnWidth=40;
        commonSDBtnHeight=25;
    }
    
    
    freeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, commonLabelYpos, freeLabelWidth, 20)];
    freeLabel.text = @"FREE";
    [freeLabel setTextAlignment:NSTextAlignmentRight];
    [freeLabel setBackgroundColor:[UIColor clearColor]];
    [freeLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    
    freeRentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, commonLabelYpos, freeRentView.frame.size.width-20, 25)];
    [freeRentLabel setTextAlignment:NSTextAlignmentLeft];
    [freeRentLabel setBackgroundColor:[UIColor clearColor]];
    [freeRentLabel setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    
    
    int installSwitchXPos = (freeLabel.frame.origin.x+freeLabel.frame.size.width);
    freeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(installSwitchXPos, freeSwitchYPos, 30, 40)];
    [freeSwitch addTarget: self action: @selector(flipShowSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [freeSwitch setOnTintColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [freeSwitch setOn:NO];
    
    int rentLabelXPos = (freeSwitch.frame.origin.x+freeSwitch.frame.size.width);
    rentLabel = [[UILabel alloc]initWithFrame:CGRectMake(rentLabelXPos, commonLabelYpos, rentLabelWidth, 20)];
    rentLabel.text = @"BUY/RENT";
    [rentLabel setTextAlignment:NSTextAlignmentLeft];
    [rentLabel setBackgroundColor:[UIColor clearColor]];
    [rentLabel setTextColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1]];
    
    CGFloat btnViewXPos = (freeRentView.frame.origin.x + freeRentView.frame.size.width);
    CGFloat btnViewWidth = 0.0f;
    if([self isDeviceIpad]==YES){
        btnViewWidth= appListHeaderView.frame.size.width/2;//screenWidth/2
    }
    else{
       btnViewWidth = appListHeaderView.frame.size.width/2;
    }
    
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(btnViewXPos,0,btnViewWidth ,50)];
    [btnView setBackgroundColor:[UIColor clearColor]];
    
    sdBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, commonSDBtnWidth, commonSDBtnHeight)];
    [sdBtn setTitle:@"SD" forState:UIControlStateNormal];
    sdBtn.layer.borderWidth = 2.0f;
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    sdBtn.layer.cornerRadius = 2.0f;
    sdBtn.clipsToBounds = YES;
    [sdBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    sdBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    sdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [sdBtn addTarget:self action:@selector(SDShowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat hdBtnXPos = (sdBtn.frame.origin.x + sdBtn.frame.size.width+3);
    hdBtn = [[UIButton alloc]initWithFrame:CGRectMake(hdBtnXPos, 10, commonSDBtnWidth, commonSDBtnHeight)];
    [hdBtn setTitle:@"HD" forState:UIControlStateNormal];
    hdBtn.layer.borderWidth = 2.0f;
    hdBtn.layer.borderColor = [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor;
    hdBtn.layer.cornerRadius = 2.0f;
    hdBtn.clipsToBounds = YES;
    [hdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    hdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [hdBtn addTarget:self action:@selector(HDShowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat hdxBtnXPos = (hdBtn.frame.origin.x + hdBtn.frame.size.width+3);
    hdxBtn = [[UIButton alloc]initWithFrame:CGRectMake(hdxBtnXPos,10, commonSDBtnWidth, commonSDBtnHeight)];
    [hdxBtn setTitle:@"HDX" forState:UIControlStateNormal];
    hdxBtn.layer.borderWidth = 2.0f;
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    hdxBtn.layer.cornerRadius = 2.0f;
    hdxBtn.clipsToBounds = YES;
    [hdxBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    hdxBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(12)];
    hdxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [hdxBtn addTarget:self action:@selector(HDXAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        freeLabel.font = [COMMON getResizeableFont:Roboto_Bold(15)];
        rentLabel.font = [COMMON getResizeableFont:Roboto_Bold(15)];
        [freeRentLabel setFont:[COMMON getResizeableFont:Roboto_Bold(15)]];
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
    [freeRentLabel setHidden:YES];
    
//    
//    [freeRentView setBackgroundColor:[UIColor whiteColor]];
//    [freeLabel setBackgroundColor:[UIColor lightGrayColor]];
//    [rentLabel setBackgroundColor:[UIColor grayColor]];
//    [freeRentLabel setBackgroundColor:[UIColor darkGrayColor]];
//    [appListHeaderView setBackgroundColor:[UIColor redColor]];
    
   
    [appListHeaderView addSubview:freeRentView];
    [appListHeaderView addSubview:btnView];
    [appListView addSubview:appListHeaderView];
    
    CGFloat appListScrollViewYPos = appListHeaderView.frame.size.height;
    appListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, appListScrollViewYPos, appListView.frame.size.width, appListView.frame.size.height -(appListScrollViewYPos))];
    [appListScrollView setBackgroundColor:[UIColor clearColor]];
    [appListView setBackgroundColor:[UIColor clearColor]];
    [appListView addSubview:appListScrollView];
    [appListScrollView setUserInteractionEnabled:YES];
    
    appShowAllItems = appListArray;
    isSDClicked =YES;
    
    if(s_boolMovies){
        if([appShowAllItems count]!=0){
            [_watchNowBtn setHidden:NO];
        }
        else{
            [_watchNowBtn setHidden:YES];
        }
 
    }
    
    [self loadLatestAppListScrollViewData:appShowAllItems];
    
    
}
#pragma mark - checkFormattedPriceForAppBtnShow
-(void)checkFormattedPriceForAppBtnShow{
    BOOL isSD,isHD,isHDX;
    if ((NSMutableArray *)[NSNull null] != appShowAllItems){
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
    
}

#pragma mark - loadLatestAppListScrollViewData
-(void)loadLatestAppListScrollViewData:(NSMutableArray *)latestAppListArray{
    [self checkFormattedPriceForAppBtnShow];
    CGFloat commonWidth,backgroundViewWidth,titleButtonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    backgroundViewWidth = 10;
    titleButtonWidth = 0;
    UIView *backgroundView;
    CGFloat backgroundWidth,imageViewHeight;
    CGFloat imageViewWidth;
    UILabel *titleLabel;
    UILabel *watchNowLabel;;
    
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
    for (UIView *subview in appListScrollView.subviews) {
        [subview removeFromSuperview];
    }
    for(int i = 0; i < [latestAppListArray count]; i++)
    {
        
        NSDictionary *dictItem = latestAppListArray[i];
        NSString *strStreamName = dictItem[@"display_name"];
        NSMutableArray * formats=[dictItem objectForKey:@"formats"];
        NSString * appImageUrl=[dictItem objectForKey:@"image"];
        NSString * appSubcriptionCode;//=[dictItem objectForKey:@"subscription_code"];
        NSString * appKey=[dictItem objectForKey:@"key"];
        if ((NSString *)[NSNull null] == appKey||appKey == nil) {
            appKey=@"free";
        }
        //NSString * appName=[dictItem objectForKey:@"app_name"];
        NSString * strRate;
        if ((NSMutableArray *)[NSNull null] == formats){
            strRate =@"FREE";
            if([freeRentStr isEqualToString:@"Paid"]){
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
//        if ((NSMutableArray *)[NSNull null] == formats){
//            if(![appSubcriptionCode isEqualToString:@""]){
//                subcriptionArray = [currentUserLoginDetails objectForKey:@"subscriptions"];
//                if([subcriptionArray count]!=0){
//                    strRate = [COMMON checkSubscriptionCode:subcriptionArray stringToFind:appSubcriptionCode];
//                    
//                }
//            }
//            if([appSubcriptionCode isEqualToString:@""]){
//                strRate =@"Free Trial";
//            }
//        }
        
        
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            backgroundWidth = 110;//commonWidth/3;
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 3, backgroundWidth, appListScrollView.frame.size.height)];
            imageViewHeight = appListScrollView.frame.size.height-60;
            imageViewWidth = backgroundView.frame.size.width/2.2;//-20;
        }
        else{
            UIDevice* device = [UIDevice currentDevice];
            
            if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
                backgroundWidth = 100;//commonWidth/3;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 3, backgroundWidth, appListScrollView.frame.size.height)];
                imageViewHeight = (appListScrollView.frame.size.height/2)-10;
                imageViewWidth = backgroundView.frame.size.width/2;//-20;
            }
            else{
                backgroundWidth = 100;//commonWidth/2;
                backgroundView = [[UIView alloc]initWithFrame:CGRectMake(backgroundViewWidth, 3, backgroundWidth, appListScrollView.frame.size.height)];
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
            watchNowLabelHeight=20;
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
        [watchNowLabel setText:@"watchnow"];
        watchNowLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"watchNowAppIcon"]];

        [watchNowLabel setTextAlignment:NSTextAlignmentCenter];
        [watchNowLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        
        
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
        //CGFloat  episodeBgImageYPos = 15;//watchNowLabel.frame.origin.y+watchNowLabel.frame.size.height;
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
        [episodeImage setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appShowAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [episodeBgImage addGestureRecognizer:tapGesture];
        [episodeBgImage setUserInteractionEnabled:YES];
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
        
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        
        CGFloat titleLabelHeight;
        if([self isDeviceIpad]==YES){
            titleLabelHeight=30;
        }
        else{
            titleLabelHeight=20;
        }
        CGFloat  titleLabelYPos = episodeBgImage.frame.origin.y+episodeBgImage.frame.size.height+3;
       // titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLabelYPos, backgroundView.frame.size.width-10, titleLabelHeight)];
         titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabelYPos, episodeBgImage.frame.size.width, titleLabelHeight)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:strRate];
        if([strRate containsString:@"BUY"]){
            [titleLabel setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f blue:0.0f/255.0f alpha:1]];
        }
        else{
            [titleLabel setBackgroundColor:[UIColor colorWithRed:19.0f/255.0f green:127.0f/255.0f blue:23.0f/255.0f alpha:1]];
        }
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(10)]];
        titleLabel.numberOfLines=0;
        [backgroundView addSubview:titleLabel];
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appShowAction:)];
        tapGesture2.numberOfTapsRequired = 1;
        [titleLabel addGestureRecognizer:tapGesture2];
        [titleLabel setUserInteractionEnabled:YES];
        
        [appListScrollView setContentSize:CGSizeMake(backgroundViewWidth, appListScrollView.frame.size.height)];
        [appListScrollView addSubview:backgroundView];
        
    }
    
}
#pragma mark - appShowActionInShowDetailPAge
-(void) appShowAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageView   = (UIImageView *) tap.view;
    NSInteger selectedIndex = imageView.tag;
    [self loadAppDataForIndex:selectedIndex];
}
-(void)loadAppDataForIndex:(NSInteger)selectedIndex{
    NSInteger CurrentArrayCount = [appShowAllItems count];
    
    //&& (NSMutableArray *)[NSNull null] == appShowAllItems
    
    if([appShowAllItems count]!=0){
            if(selectedIndex < CurrentArrayCount){
            NSDictionary *dictItem = appShowAllItems[selectedIndex];
            currentCarouselID = dictItem[@"display_name"];
            currentAppImage = dictItem[@"image"];
            currentAppName = dictItem[@"display_name"];
            currentDeepLink = dictItem[@"link"];
            //BOOL app_required = (BOOL)dictItem[@"app_required"];
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
}
#pragma mark - getAppNameWithPackageName
-(void)getAppNameWithPackageName:(NSString *)app_Name
{
    [COMMON LoadIcon:self.view];
    int deviceID = CURRENT_DEVICE_ID;
    [[RabbitTVManager sharedManager]getAppsByName:^(AFHTTPRequestOperation * request, id responseObject) {
        [self checkAppInstalledWithAppSlugName:responseObject];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error){
        [COMMON removeLoading];
    } strAppName:app_Name nDeviceId:deviceID];
}

#pragma mark - checkAppInstalledWithAppSlugName
-(void)checkAppInstalledWithAppSlugName:(NSMutableDictionary *)appResponse{
    //NSString * appPackageName =appResponse[@"package"];
    
    NSString * slug = [appResponse objectForKey:@"slug"];
    slug= [slug stringByReplacingOccurrencesOfString:@"-ios" withString:@":"];
    
    BOOL isOpen = [COMMON checkInstalledApplicationInApp:slug];

    NSMutableDictionary *tempDict;
    if(isOpen ==YES){
        tempDict = [NSMutableDictionary new];
        tempDict = [appResponse mutableCopy];
        [tempDict setObject:@"YES" forKey:@"isInstalled"];
    }
    else{
        tempDict = [NSMutableDictionary new];
        tempDict = [appResponse mutableCopy];
        [tempDict setObject:@"NO" forKey:@"isInstalled"];
    }
    
    
    [self loadAppRelatedPageInShow:tempDict];
}




#pragma mark - loadAppRelatedPageInShow
-(void)loadAppRelatedPageInShow:(NSMutableDictionary *)tempDict{
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
        [self loadNewPopUpInDetailPage];
    }
     [COMMON removeLoading];
}
#pragma mark - loadEpisodeImage
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
#pragma  mark - SDShowAction-HDShowAction-HDXAction
-(void)SDShowAction:(id)sender{
    [sdBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor;
    
    [hdxBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
    isSDClicked  = YES;
    isHDClicked  = NO;
    isHDXClicked = NO;
    [self loadLatestAppListScrollViewData:appShowAllItems];
}
-(void)HDShowAction:(id)sender{
    [sdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor;
    
    [hdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdxBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    isSDClicked  = NO;
    isHDClicked  = YES;
    isHDXClicked = NO;
    [self loadLatestAppListScrollViewData:appShowAllItems];
}
-(void)HDXAction:(id)sender{
    [sdBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    sdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdBtn setTitleColor:[UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    hdBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [hdxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdxBtn.layer.borderColor = [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor;
    isSDClicked  = NO;
    isHDClicked  = NO;
    isHDXClicked = YES;
    [self loadLatestAppListScrollViewData:appShowAllItems];
}
#pragma mark - switch flip action
- (IBAction) flipShowSwitch: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    if (onoff.on){
        //PAID
         freeRentStr =@"Paid";
        appShowAllItems =[[NSMutableArray alloc]init];
        appShowAllItems = appPaidItems;
    }
    else {
        //FREE
         freeRentStr =@"Free";
        appShowAllItems =[[NSMutableArray alloc]init];
        appShowAllItems = appFreeItems;
    }
   [self loadLatestAppListScrollViewData:appShowAllItems];
}
#pragma mark -  getWatchNow
- (void)getwatchNow{
    
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

#pragma mark - UI Grid View
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if(isWatchBtnClicked == YES){
            
            return nPopUpCastWidth-20;
        }
        else{
            return nNewCastWidth-20;
        }
    }
    else{
        if(isWatchBtnClicked == YES){
            
            return nPopUpCastWidth;
        }
        else{
            return nNewCastWidth;
        }
    }
    
    
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    //return nCellHeight;
//    if([currentShowGridArray count]!=0) {

        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
//            CGRect frame = self.showDetailGridView.frame;
//            frame.origin.y = _bottomBtnsView.frame.origin.y+_bottomBtnsView.frame.size.height+8;
//            frame.size.height = showDetailGridView.contentSize.height;
//            [self.showDetailGridView setFrame:frame];
//
//            _bottomFullViewHeightConstraint.constant = self.showDetailGridView.frame.size.height+bottomViewHeight-150;
//            _bottomFullViewHeightConstraint.constant = self.showDetailGridView.contentSize.height+100;
//            [self.view layoutIfNeeded];
//            [self.showDetailGridView setFrame:frame];
            return 230;
        }
        else{
//            CGRect frame = self.showDetailGridView.frame;
//            frame.origin.y = _bottomBtnsView.frame.origin.y+_bottomBtnsView.frame.size.height+8;
//            frame.size.height = showDetailGridView.contentSize.height;
//            [self.showDetailGridView setFrame:frame];
//            _bottomFullViewHeightConstraint.constant =self.showDetailGridView.frame.size.height+bottomViewHeight+230+_watchNowBtn.frame.size.height+_addToFavBtn.frame.size.height;
         //    _bottomFullViewHeightConstraint.constant =self.showDetailGridView.contentSize.height+_watchNowBtn.frame.size.height+_addToFavBtn.frame.size.height+20;
//            [self.view layoutIfNeeded];
            return 160;
            
        }
//    }
    return 0;
}
- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
        return nNewCastCount;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if(currentShowGridArray.count == 0){
        return 0;
    }
    else
        return [currentShowGridArray count];
    
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    New_Land_Cell* cell = [grid dequeueReusableCell];
    
    if(cell == nil){
        cell = [[New_Land_Cell alloc] init];
    }
    if([currentShowGridArray count] == 0){
        [asyncImage removeFromSuperview];
        [cell removeFromSuperview];
    }
    else{
        int nIndex;
        nIndex = rowIndex * nNewCastCount + columnIndex;
        
        NSDictionary* dictItem;
        dictItem = currentShowGridArray[nIndex];
        NSString* strName = dictItem[@"name"];
        NSString* strPosterUrl;
        strPosterUrl = dictItem[@"poster_url"];
        NSString* airDate = dictItem[@"air_date"];
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
        
        if ((NSString *)[NSNull null] == airDate||airDate == nil) {
            airDate=@"";
        }
        NSURL* imageUrl = [NSURL URLWithString:strPosterUrlCheck];
        [cell.portraitImageView setHidden:YES];
        [cell.portraitView setHidden:YES];
        [cell.portraitLabel setHidden:YES];
        [cell.landScapeLabel setHidden:NO];
        [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
        //[cell.thumbnail setImageWithURL:imageUrl];//placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
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
        
        [cell.landScapeLabel setText:strNameCheck];
        if(isFreeClicked==YES){
            
        }
        if(isAllEpisodesClicked==YES||isAllSeasonsClicked==YES||isFreeCountEmpty==YES){
            [cell.freeLabel setHidden:YES];
        } else
            [cell.freeLabel setHidden:NO];

        
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
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    int nIndex = rowIndex * nNewCastCount + colIndex;
    
    int count = (int) [currentShowGridArray count];
    
    NSDictionary* dictItem = currentShowGridArray[nIndex];

    if(nIndex < count){
    didSelectName = dictItem[@"name"];
    //didPosterStr =
    if(isFreeCountEmpty==YES||isEpisodeNotNeedInFree==YES){
        if(isAllSeasonsClicked==YES){
            didSelectSeasonId = dictItem[@"id"];
        }
        else{
            currentSelectedSeasonId = dictItem[@"season_id"];
            currentSelectedEpisodeId = dictItem[@"id"];
        }
        if(isAllEpisodesClicked==YES){
            [self getSeasonData];
            
        }
        if(isFreeClicked==YES){
            //[self loadNewMovieDetailPage];
            [self loadMoviePageLink];
        }
    }
    else{
        if(isAllSeasonsClicked==YES){
            didSelectSeasonId = dictItem[@"id"];
        }
        else{
            currentSelectedSeasonId = dictItem[@"season_id"];
            currentSelectedEpisodeId = dictItem[@"id"];
        }
        if(isAllSeasonsClicked==YES){
            [self getSeasonData];

        }
        if(isFreeClicked==YES||isAllEpisodesClicked==YES){
            //[self loadNewMovieDetailPage];
            [self loadMoviePageLink];
            
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
        seasonParticularEpisodesArray = [[NSMutableArray alloc] initWithArray:responseObject];
        if([seasonParticularEpisodesArray count]==0){
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [AppCommon showSimpleAlertWithMessage:@"No Episodes"];
        }
        else{
            isSeasonEpisodes=YES;
            showFullEpisodesArray = seasonParticularEpisodesArray;
            currentShowGridArray = seasonParticularEpisodesArray;
            //[self setShowScrollHeight];
            [showDetailGridView reloadData];
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
           
            [self setBorderForBottomButtons];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [AppCommon showSimpleAlertWithMessage:@"No Episodes"];
    }nShowID:[nID intValue] nSeasonId:[didSelectSeasonId intValue]nPPV:nPPV];
}
#pragma mark - loadMoviePageLink
-(void)loadMoviePageLink{
//    if(isFreeClicked==YES){
//        isFreeClicked=YES;
//        isAllEpisodesClicked=NO;
//        isAllSeasonsClicked=NO;
//    }
//    else{
//        isFreeClicked=NO;
//        isAllEpisodesClicked=YES;
//        isAllSeasonsClicked=NO;
//    }
    isWatchBtnClicked=NO;
    [self loadNewMovieDetailPage];
    
}
#pragma mark - loadNewMovieDetailPage
-(void)loadNewMovieDetailPage{
    
    NewMovieDetailViewController * mMovieVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_movie_detail_ipad"];
    } else {
        mMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_moviedetail_iphone"];
    }
    mMovieVC.nID = nID;
    mMovieVC.episodeId = currentSelectedEpisodeId;
    mMovieVC.seasonId = currentSelectedSeasonId;
    mMovieVC.headerLabelStr = didSelectName;
    mMovieVC.isEpisode=YES;
    mMovieVC.genreName = genreName;
    
    mMovieVC.allEpisodeArray    =showFullEpisodesArray;
    mMovieVC.allSeasonsArray    =showFullSeasonsArray;
    if(isPushedFromPayPerView==YES){
        mMovieVC.isPushedFromPayPerView=YES;
        
    }
    else{
        mMovieVC.fourLatestArray     =topFourLatestArray;
        mMovieVC.allFreeEpisodeArray = freeLatestArray;
        mMovieVC.isPushedFromPayPerView=NO;
        if(isToggledAll==YES){
            mMovieVC.isToggledAll=YES;
            mMovieVC.isToggledFree=NO;
        }
        else{
            mMovieVC.isToggledAll=NO;
            mMovieVC.isToggledFree=YES;
            
        }
    }
    [mMovieVC setIfMovies:false];
    [self.navigationController pushViewController:mMovieVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
#pragma mark - setBorderForBottomButtons
-(void)setBorderForBottomButtons{
    
    [leftBorder removeFromSuperview];
    [rightBorder removeFromSuperview];
    [topBorder removeFromSuperview];
    [bottomBorder1 removeFromSuperview];
    [bottomBorder2 removeFromSuperview];
    if(isFreeClicked==YES){
        leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, _freeBtn.frame.size.height)];

        
        rightBorder = [[UIView alloc] initWithFrame:CGRectMake(_freeBtn.frame.size.width-1.0f, 0, 1.5, _freeBtn.frame.size.height-1.0f)];
        topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_freeBtn.frame.size.width-0.5f,1.5)];
        bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, _allEpisodesBtn.frame.size.height-2.0f, _allEpisodesBtn.frame.size.width, 1.0)];
        bottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _AllSeasonBtn.frame.size.height-2.0f, _AllSeasonBtn.frame.size.width, 1.0)];
        [self autoMaskingForBottomButtonBorder];
        [_freeBtn addSubview:leftBorder];
        [_freeBtn addSubview:topBorder];
        [_freeBtn addSubview:rightBorder];
        [_allEpisodesBtn addSubview:bottomBorder1];
        [_AllSeasonBtn addSubview:bottomBorder2];
        
    }
    else if(isAllEpisodesClicked ==YES){

        leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, _allEpisodesBtn.frame.size.height-1.0f)];
        rightBorder = [[UIView alloc] initWithFrame:CGRectMake(_allEpisodesBtn.frame.size.width-1.0f, 0, 1.0, _allEpisodesBtn.frame.size.height-1.0f)];
        topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_allEpisodesBtn.frame.size.width-1.0,1.0)];
        
        
        bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _freeBtn.frame.size.height-2.0f, _freeBtn.frame.size.width, 1.0)];
        bottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _AllSeasonBtn.frame.size.height-2.0f, _AllSeasonBtn.frame.size.width, 1.0)];
        [self autoMaskingForBottomButtonBorder];
        [_allEpisodesBtn addSubview:leftBorder];
        [_allEpisodesBtn addSubview:topBorder];
        [_allEpisodesBtn addSubview:rightBorder];
        [_freeBtn addSubview:bottomBorder1];
        [_AllSeasonBtn addSubview:bottomBorder2];
        
    }
    if(isFreeCountEmpty==YES||isEpisodeNotNeedInFree==YES){
        
    }
    else{
         if(isAllSeasonsClicked==YES){

            
             leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0, 1.0, _AllSeasonBtn.frame.size.height-1.0)];
             topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_AllSeasonBtn.frame.size.width-0.5,1.0)];
             rightBorder = [[UIView alloc] initWithFrame:CGRectMake(_AllSeasonBtn.frame.size.width-1.0f, 1, 1.5, _AllSeasonBtn.frame.size.height-1.0)];
           
            bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _allEpisodesBtn.frame.size.height-2.0f, _freeBtn.frame.size.width, 1.0)];
            bottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(1, _allEpisodesBtn.frame.size.height-2.0f, _allEpisodesBtn.frame.size.width, 1.0)];
            [self autoMaskingForBottomButtonBorder];
            [_AllSeasonBtn addSubview:leftBorder];
            [_AllSeasonBtn addSubview:topBorder];
            [_AllSeasonBtn addSubview:rightBorder];
            [_freeBtn addSubview:bottomBorder1];
            [_allEpisodesBtn addSubview:bottomBorder2];
            
        }
 
    }
    leftBorder.backgroundColor = BORDER_BLUE;
    rightBorder.backgroundColor = BORDER_BLUE;
    topBorder.backgroundColor = BORDER_BLUE;
    bottomBorder1.backgroundColor = BORDER_BLUE;
    bottomBorder2.backgroundColor = BORDER_BLUE;
}
-(void) autoMaskingForBottomButtonBorder{
    [leftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [rightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [bottomBorder1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [bottomBorder2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}
-(void) autoMaskingForUpperButtonBorder{
    
    [upperLeftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [upperRightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [upperTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [upperBottomBorder1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [upperBottomBorder2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

#pragma mark - setBorderForLeftButtons
-(void)setBorderForLeftButtons{
    [upperLeftBorder removeFromSuperview];
    [upperRightBorder removeFromSuperview];
    [upperTopBorder removeFromSuperview];
    [upperBottomBorder1 removeFromSuperview];
    [upperBottomBorder2 removeFromSuperview];
    if(isOverViewClicked==YES){
        
        upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0, 1.0, _overViewBtn.frame.size.height)];
        upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_overViewBtn.frame.size.width-1.0f, 0, 1.0, _overViewBtn.frame.size.height-1.0)];
        upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_overViewBtn.frame.size.width-1.0,1.0)];
        
        upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, _castBtn.frame.size.height-2.0f, _castBtn.frame.size.width, 1.0)];
        upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _genreBtn.frame.size.height-2.0f, _genreBtn.frame.size.width, 1.0)];
        [self autoMaskingForUpperButtonBorder];
        [_overViewBtn addSubview:upperLeftBorder];
        [_overViewBtn addSubview:upperRightBorder];
        [_overViewBtn addSubview:upperTopBorder];
        [_castBtn addSubview:upperBottomBorder1];
        [_genreBtn addSubview:upperBottomBorder2];
    }
    else if(isCastClicked ==YES){
        upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1.5, _castBtn.frame.size.height-1.0f)];
        upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,_castBtn.frame.size.width-0.5,1.0)];
        upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_castBtn.frame.size.width, 0, 1.0, _castBtn.frame.size.height-1.0f)];
        upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _overViewBtn.frame.size.height-2.0f, _overViewBtn.frame.size.width, 1.0)];
        upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, _genreBtn.frame.size.height-2.0f, _genreBtn.frame.size.width, 1.0)];
        [self autoMaskingForUpperButtonBorder];
        [_castBtn addSubview:upperLeftBorder];
        [_castBtn addSubview:upperTopBorder];
        [_castBtn addSubview:upperRightBorder];
        [_overViewBtn addSubview:upperBottomBorder1];
        [_genreBtn addSubview:upperBottomBorder2];
    }
    else if(isGenreClicked==YES){
        
        upperRightBorder = [[UIView alloc] initWithFrame:CGRectMake(_genreBtn.frame.size.width-1.0f, 0.5, 1.0, _genreBtn.frame.size.height)];

        upperLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1.5, _genreBtn.frame.size.height-0.5)];
        upperTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0,_genreBtn.frame.size.width-0.5,1.0)];
        upperBottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(1, _overViewBtn.frame.size.height-2.0f, _overViewBtn.frame.size.width, 1.0)];
        upperBottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(1, _castBtn.frame.size.height-2.0f, _castBtn.frame.size.width, 1.0)];
        [self autoMaskingForUpperButtonBorder];
        [_genreBtn addSubview:upperLeftBorder];
        [_genreBtn addSubview:upperTopBorder];
        [_genreBtn addSubview:upperRightBorder];
        [_overViewBtn addSubview:upperBottomBorder1];
        [_castBtn addSubview:upperBottomBorder2];
    }
    upperLeftBorder.backgroundColor = BORDER_BLUE;
    upperTopBorder.backgroundColor = BORDER_BLUE;
    upperRightBorder.backgroundColor = BORDER_BLUE;
    upperBottomBorder1.backgroundColor = BORDER_BLUE;
    upperBottomBorder2.backgroundColor = BORDER_BLUE;
    
}
#pragma mark - goBack
- (IBAction) goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - loadNewPopUpInDetailPage
-(void) loadNewPopUpInDetailPage{
    
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
            iPhoneHeight =300;
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
    appListFullPopUpView.delegate = self;
    [appListInnerPopUpView setBackgroundColor:[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
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
    
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, labelTitleYPos, viewContainer.frame.size.width-60, labelTitleHeight)];
    [labelTitle setText:@"Connecting to App Store..."];
    [labelTitle setTextColor:[UIColor whiteColor]];
    if([self isDeviceIpad]==YES){
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(25)]];
    }
    else{
        [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(18)]];
    }
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
    
    labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(30, labelTitle.frame.origin.y+labelTitle.frame.size.height+5, viewContainer.frame.size.width-60, labelDescriptionHeight)];
    
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
    cancelBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    [cancelBtn addTarget:self action:@selector(dismissAppListPopup) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat installBtnXPos = cancelBtn.frame.origin.x+cancelBtn.frame.size.width+5;
    UIButton* installBtn = [[UIButton alloc] initWithFrame:CGRectMake(installBtnXPos, cancelBtnYPos,cancelBtn.frame.size.width-5, buttonHeight)];
    [installBtn setBackgroundImage:[UIImage imageNamed:@"installBtnImage.png"] forState:UIControlStateNormal];
    NSString *installBtnStr= [NSString stringWithFormat:@"INSTALL %@",[currentAppName capitalizedString]];
    [installBtn setTitle:installBtnStr forState:UIControlStateNormal];
    [installBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    installBtn.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(13)];
    [installBtn addTarget:self action:@selector(installAppDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self performSelector:@selector(installAppDetailAction:) withObject:nil afterDelay:5];
    
    [viewContainer addSubview:labelTitle];
    [viewContainer addSubview:labelDescription];
    [viewContainer addSubview:imageThumbnail];
    [viewContainer addSubview:labelVideoName];
    [viewContainer addSubview:cancelBtn];
    [viewContainer addSubview:installBtn];
    
    
    appListFullPopUpView.delegate = self;
    [appListInnerPopUpView addSubview:viewContainer];
    [appListFullPopUpView setContainerView:appListInnerPopUpView];
    [appListFullPopUpView show];
    isAppListPopUpShown = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [appListFullPopUpView addGestureRecognizer:tapGestureRecognizer];
    appListFullPopUpView.userInteractionEnabled = YES;
}
#pragma mark - tapActions
- (void)tapOnPopUpView:(UITapGestureRecognizer *)tap {
    [self dismissAppListPopup];
    isAppListPopUpShown =NO;
    
    [appListFullPopUpView removeFromSuperview];
    [appListFullPopUpView close];
    appListFullPopUpView = nil;
    
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

#pragma mark - dismissAppListPopup
-(void)dismissAppListPopup {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(installAppDetailAction:)
                                               object:nil];
    
    [appListFullPopUpView removeFromSuperview];
    appListFullPopUpView = nil;
    [appListFullPopUpView close];
    isAppListPopUpShown = NO;
    
    
}
#pragma mark - installAppDetailAction
-(void)installAppDetailAction:(UIButton *)sender
{
    NSString *link =currentAppLink;//Currentdeeplink
    NSURL* linkUrl = [NSURL URLWithString:link];
    
    [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
    
    [appListFullPopUpView removeFromSuperview];
    appListFullPopUpView = nil;
    [appListFullPopUpView close];
    isAppListPopUpShown = NO;
}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    if([[url host] isEqualToString:@"page"]){
//        if([[url path] isEqualToString:@"/page1"]){
//            [self.mainController pushViewController:[[Page1ViewController alloc] init] animated:YES];
//        }
//        return YES;
//    }
//}
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
            [self newShowDetailRotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self newShowDetailRotateViews:false];
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
#pragma mark
-(void) newShowDetailRotateViews:(BOOL) bPortrait{
    topFullLeftViewFrame = TopFullLeftView.frame;
   

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(installAppDetailAction:)
                                               object:nil];
    
    if(isAppListPopUpShown==YES) {
        [appListFullPopUpView removeFromSuperview];
        appListFullPopUpView = nil;
        [appListFullPopUpView close];
        [self loadNewPopUpInDetailPage];

    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if(bPortrait){
        
        nNewCastCount = 2;
        nPopUpCastCount= 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nNewCastCount = 3;
            nPopUpCastCount= 3;
        }
        nNewCastWidth = screenWidth / nNewCastCount;
        nNewCastHeight = screenWidth / nNewCastCount;
        
        CGFloat popUpTableWidth = showPopUpFullScrollView.frame.size.width;
        //        nPopUpCastWidth = (screenWidth-380)/ nPopUpCastCount;
        //        nPopUpCastHeight =(screenWidth-380)/ nPopUpCastCount;
        
        nPopUpCastWidth = popUpTableWidth/ nPopUpCastCount;
        nPopUpCastHeight =popUpTableWidth/ nPopUpCastCount;
        
    }else{
        
       
        nNewCastCount = 3;
        nPopUpCastCount= 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nNewCastCount = 4;
            nPopUpCastCount= 4;
        }
        nNewCastWidth = screenWidth / nNewCastCount;
        nNewCastHeight = screenWidth / nNewCastCount;
        
        CGFloat popUpTableWidth = showPopUpFullScrollView.frame.size.width;
        
        nPopUpCastWidth = popUpTableWidth/ nPopUpCastCount;
        nPopUpCastHeight =popUpTableWidth/ nPopUpCastCount;
        
    }
   
    
    [self setShowScrollHeight];
    [self.showDetailGridView reloadData];
    [_tableViewCast reloadData];
    [_castCollectionView reloadData];
    [_tableViewCast scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self setBorderForLeftButtons];
    if(isEpisode==YES){
        
        [self setBorderForBottomButtons];
    }
    if(isWatchLoaded==YES) {
        NSInteger nCount = [appShowAllItems count];
        if(nCount == 1){
                   }
        else{
            [self loadAppListHeaderView:appShowAllItems];
        }

    }
        if([self isDeviceIpad]!=YES){
            if([currentShowGridArray count]==0) {
                _topFullViewHeightConstraint.constant = topFullViewHeight;
    //            _middleViewHeightConstraint.constant = middleViewHeight;
                _bottomFullViewHeightConstraint.constant = 0;
            }
         }
    if(isMoreClicked==NO && isOverViewClicked==NO && isCastClicked==YES && isGenreClicked==NO){
        [_tableViewCast reloadData];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [_castCollectionView reloadData];
            CGFloat tableHeight;
            tableHeight = topFullViewHeight - leftBtnsViewHeight;
            _castTableHeight.constant = _castCollectionView.contentSize.height;
            CGFloat leftViewHeight =  _castCollectionView.contentSize.height+_castBtn.frame.size.height;
            _leftViewHeightConstraint.constant =  leftViewHeight;
                CGFloat topHeight = tableHeight + leftViewHeight;
            if(isPushedFromPayPerView)
                _topFullViewHeightConstraint.constant = topHeight+30;
            else
                _topFullViewHeightConstraint.constant = topHeight;

        }
    }
    if(isMoreClicked==NO && isOverViewClicked==YES && isCastClicked==NO && isGenreClicked==NO){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
//            [self addLessToString];
//        _leftViewHeightConstraint.constant = 80;
//        CGFloat topOriginalHeight = topFullViewHeight - leftBtnsViewHeight;
//        _topFullViewHeightConstraint.constant = topOriginalHeight+80;
        }
    }
    
   // [_BottomFullView setHidden:NO];
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
        return 0.0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CastLandCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString * strName;
    NSString* strNameCheck;
    if([arrayCast count]== 0){
        strName = @"";
    }else{
        
        strName = [[arrayCast objectAtIndex:indexPath.row]valueForKey:@"name"];
        strName = [strName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
    }
    if ((NSString *)[NSNull null] == strName) {
        strNameCheck=@"";
    } else {
        if (strName == nil) {
            strNameCheck=@"";
        } else {
            strNameCheck= strName;
        }
    }
    cell.backgroundColor =[UIColor clearColor];
    [cell.textLabel setText:strNameCheck];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    cell.textLabel.numberOfLines=0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)addFavBtnAction{
    if(isAddBtnClicked==NO){
        [self addFavouriteItemAPI];
        isAddBtnClicked=YES;
    }
}
-(void)isWatchBtnClickedAction{
    if(isWatchBtnActionExecuted==NO){
        if(s_boolMovies==true){
            //[self getwatchNow];
            isWatchLoaded = YES;
            if([appPaidItems count]==0 && [appFreeItems count]!=0){
                freeRentStr =@"Free";
                NSInteger nCount = [appFreeItems count];
                if(nCount == 1){
                    appShowAllItems =appFreeItems;
                    [self loadAppDataForIndex:0];
                }
                else{
                    [self loadAppListHeaderView:appFreeItems];
                }
            }
            if([appPaidItems count]!=0 && [appFreeItems count]==0){
                freeRentStr =@"Paid";
                NSInteger nCount = [appPaidItems count];
                if(nCount == 1){
                    appShowAllItems =appFreeItems;
                    [self loadAppDataForIndex:0];
                }
                else{
                     [self loadAppListHeaderView:appPaidItems];
                }
               
            }
            
            if([appPaidItems count]!=0 && [appFreeItems count]!=0){
                freeRentStr =@"Free";
                NSInteger nCount = [appFreeItems count];
                if(nCount == 1){
                    appShowAllItems =appFreeItems;
                    [self loadAppDataForIndex:0];
                }
                else{
                    [self loadAppListHeaderView:appFreeItems];
                }

                
            }
            
            if([self isDeviceIpad]!=YES){
                _topFullViewHeightConstraint.constant = topFullViewHeight+appListView.frame.size.height+_addToFavBtn.frame.size.height;
            }
        }
        else{
            isWatchBtnClicked=YES;
            [self addFavouriteItemAPI];
        }

        isWatchBtnActionExecuted=YES;
    }
    
}

#pragma mark - Add FavouriteAPI
-(void)addFavouriteItemAPI{
    [COMMON LoadIcon:self.view];
    NSLog(@"ACCESS%@,STR%@,ID%d",[COMMON getUserAccessToken],addFavEntityName,[nID intValue]);
    
    [[RabbitTVManager sharedManager]getFavoritesAdd:^(AFHTTPRequestOperation * request, id responseObject) {
        {
            [COMMON removeLoading];
            UIAlertView* alertView =[[UIAlertView alloc] init];
            [alertView setTitle:@"Succesfully Added"];
            [alertView addButtonWithTitle:@"Ok"];
            [alertView show];
            
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            [self errorAlertWithErrorDict:error];
            [COMMON removeLoading];
        }
    } strAccessToken:[COMMON getUserAccessToken] strEntity:[addFavEntityName lowercaseString] nEntityId:[nID intValue]];
}
#pragma mark - errorAlertWithErrorDict
-(void)errorAlertWithErrorDict:(NSError *)error{
    //NSDictionary *userInfo = [error userInfo];
    NSString *getError = error.localizedDescription;
    if ((NSString *)[NSNull null] == getError||getError == nil) {
        getError=@"";
    }
    NSString *errorStr = @"Already Added";
    if([getError containsString:@"Duplicate entity"])
    {
        errorStr = @"Already Added to Favourites";//Exception('Duplicate entity',)
        [self alertView:errorStr];
    }
    else{
        errorStr = @"Invalide or expired token, Please Login to Continue";//InvalidTokenException('Invalide or expired token',)
        [self alertView:errorStr];
    }
}
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
       [self isTokenExpired];

    }
}

#pragma mark - isTokenExpired
-(void)isTokenExpired{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [COMMON removeLoginDetails];
        [COMMON removeLoading];
        [self pushToLoginScreen];
}

#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController * LoginVC = nil;
    LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

-(void)customIOS7dialogDismiss{
   
    //    isFreeClicked=YES;
    //    isAllSeasonsClicked=NO;
    //    isAllEpisodesClicked=NO;
    isWatchBtnClicked=NO;
    if(isFreeClicked==YES){
        currentShowGridArray = freeLatestArray;
    }
    else if(isAllEpisodesClicked==YES){
         currentShowGridArray = showFullEpisodesArray;
    }
    else if(isAllSeasonsClicked==YES){
         currentShowGridArray = showFullSeasonsArray;
    }
    [showDetailGridView reloadData];
    
}


-(void)setShowScrollHeightForPopUp{
    //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSInteger height;
    NSInteger count;
    UIDevice* device = [UIDevice currentDevice];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        height= 240;
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            count = 3;
        }
        else {
            count = 3;
        }
    }
    else{
        height= 160;
        
        if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
            count = 2;
        }
        else{
            count = 2;
        }
        
    }
    
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

#pragma mark - UICollectionView Datasource & Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 5.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        return CGSizeMake(SCREEN_WIDTH/3-10, 25);
    else
        return CGSizeMake(SCREEN_WIDTH/2-40, 25);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger nCount = 0;
    if([arrayCast count]!=0){
        nCount = [arrayCast count];
    }
    
    return nCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CastCustomCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CastCustomCell" forIndexPath:indexPath];
    NSString * strName;
    NSString* strNameCheck;
    if([arrayCast count]== 0){
        strName = @"";
    }else{
        
        strName = [[arrayCast objectAtIndex:indexPath.row]valueForKey:@"name"];
        strName = [strName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
    }
    if ((NSString *)[NSNull null] == strName) {
        strNameCheck=@"";
    } else {
        if (strName == nil) {
            strNameCheck=@"";
        } else {
            strNameCheck= strName;
        }
    }
    cell.backgroundColor =[UIColor clearColor];
    [cell.castLabel setText:strNameCheck];
    [cell.castLabel setTextColor:[UIColor whiteColor]];
    [cell.castLabel setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    return cell;
    
}


@end
