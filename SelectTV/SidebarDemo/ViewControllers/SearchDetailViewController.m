//
//  SearchDetailViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 01/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "Season.h"
#import "Cell.h"
#import "UIImageView+AFNetworking.h"
#import "CustomIOS7AlertView.h"
#import "PlayerViewController.h"
#import "RabbitTVManager.h"
#import "SimpleTableCell.h"
#import "NSString+FontAwesome.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "New_Land_Cell.h"
#import "OnDemand_Grid_Cell.h"

@interface SearchDetailViewController ()<CustomIOS7AlertViewDelegate,YTPlayerViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableAttributedString *aweAttrString;
    NSDictionary *attrRoboFontDict;
    NSDictionary *attrAweSomeDict;
    
  
    NSMutableArray* arraySeasons;
    NSMutableArray* m_ArrayChannels;
    UIView *tvShowView;
    UITableView* tableChannelList;
    CustomIOS7AlertView *channelView;
    NSMutableArray* arrayPayItems;
    NSString *strSelectedId, *strSelectedName,*selectedButtonName;
    NSMutableArray * dataSelectedArray;
   
    
    //Detail Page
    UIScrollView *detailPageScrollView;
    UIView *detailView;
    UILabel *titleLabel;
    UIImageView *starImgView;
    UILabel *descLabel;
    UITextView *descTextView;
    UIImage *image;
    UIImageView *imageView;
    
    //Scrolltitle
    UIView *backgroundView ;
    UILabel *indicateLabel;
    CGFloat scrollButtonWidth;
    CGFloat scrollButtonWidthTest;
    CGSize stringsize;
    BOOL isScrolled;
    NSInteger detailPageVisibleSection;
    NSMutableArray *scrollTitleHeaderArray;
    
    BOOL isSeasonArrayExist;
    
  
    
    //MENU ORIENTATION
    CGFloat port_SearchDetailViewHeight;
    CGFloat land_SearchDetailViewHeight;
    //NEW
    BOOL isMovieType;
    NSMutableArray *titleWithCountArray;
    NSString * currentAppLanguage;
    
    
}
@property (nonatomic,retain) CustomIOS7AlertView* ondemandView;
@property (readwrite) BOOL bDemandSearchShown;
@property (nonatomic, retain) NSString* curVideoUrl;
@property (nonatomic, retain) NSString* curTitle;
@end

@implementation SearchDetailViewController
@synthesize stationNameStr,stationImageUrl,stationDataArray,ondemandView,bDemandSearchShown,curVideoUrl,isLiveViewDetails,liveDetailArray,isActorViewDetails;

@synthesize networkStr,dropDownNSArray,isNetworksView,titleStr;

@synthesize showHeaderView,searchStationTable,titleTextArray,FullActorArray,ActorMoviesArray,ActorShowsArray,actorPosterUrl;

int nStationColumn=3;
int nStationWidth=107;
int nStationHeight=200;

BOOL isNetworkLeftMeunShown = false;

NSString *THUMBNAIL_STATION_URL = @"http://img.youtube.com/vi/";

-(void)viewDidLoad
{
    [super viewDidLoad];
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    [self loadNavigation];
    [self setOrientation];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActorScrolled:) name:@"ActorTableScrolled" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActorTableFilter:) name:@"ActorRightView" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_searchActivityIndicator setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    if(isNetworksView==YES){
        [self setUpFont];
        
        NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:networkStr attributes:attrRoboFontDict];
        [roboAttrString appendAttributedString:aweAttrString];
        _stationName.attributedText = roboAttrString;
        [_stationName setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mySelector:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_stationName addGestureRecognizer:tapRecognizer];
        
    }
    else if(isLiveViewDetails == YES){
        [_stationName setHidden:YES];
        [searchStationTable setHidden:YES];
        
    }
    else if(isActorViewDetails == YES){
        [_stationName setHidden:YES];
        ActorMoviesArray = [FullActorArray valueForKey:@"movies"];
        ActorShowsArray = [FullActorArray valueForKey:@"show"];
    }
    else{
         _stationName.text = stationNameStr;
    }
    bDemandSearchShown = false;
    [channelView close];
}

-(void) loadNavigation{
    if([titleStr isEqualToString:@"station"]){
        self.title = @"Channel Videos";
    }
    else{
        self.title = [titleStr capitalizedString];
    }
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
    
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
- (void)mySelector:(UILabel *)myLabel
{
    [self loadNetworkTableMenu];
    
//    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
//        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2, 280, 250)];
//        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 190)];
//        
//    }else{
//        channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2, 280, 450)];
//        tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 390)];
//        
//    }
    
}
-(void)loadNetworkTableMenu{
    [[RabbitTVManager sharedManager]cancelRequest];
    if(dropDownNSArray == nil) return;
    m_ArrayChannels = (NSMutableArray *) dropDownNSArray;
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-260, self.view.frame.size.height-130)];
        }
        //IPAD
        else{
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-380, self.view.frame.size.height-300)];
        }
        
    }else{
        //IPHONE
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50, self.view.frame.size.height-180)];
        }
        //IPAD
        else{
            channelView = [[CustomIOS7AlertView alloc] initWithFrame:CGRectMake(0, 2,self.view.frame.size.width, self.view.frame.size.height)];
            tableChannelList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height-340)];
        }
    }
    
    
    // tableChannelList.tag = 102;
    tableChannelList.backgroundColor = [UIColor whiteColor];
    channelView.delegate = self;
    tableChannelList.dataSource = self;
    tableChannelList.delegate = self;
    [channelView setContainerView:tableChannelList];
    [channelView show];
    isNetworkLeftMeunShown=true;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [channelView addGestureRecognizer:tapGestureRecognizer];
    channelView.userInteractionEnabled = YES;


}
#pragma mark - updateNetworkDetailData
- (void)updateNetworkDetailData:(int)nNetworkID
{
    int nPPV =PAY_MODE_ALL;
    if(isNetworksView==YES){
        [[RabbitTVManager sharedManager] getNetworkList:^(AFHTTPRequestOperation * request, id responseObject) {
            stationDataArray = [[NSMutableArray alloc] initWithArray:responseObject];
            [searchStationTable reloadData];
        } nID:nNetworkID nPPV:nPPV];
    }
   
}
-(void)loadLiveData{

    NSString* strName,* strImageUrl,* strDesc;
    NSString* strCheckName,*strCheckImageUrl,*strCheckstrDec;
    if(isActorViewDetails ==YES){
        strName       = [FullActorArray valueForKey:@"name"];
        strImageUrl   = actorPosterUrl;
        strDesc       = [FullActorArray valueForKey:@"biography"];
    }
    else{
        strName       = [liveDetailArray valueForKey:@"name"];
        strImageUrl   = [liveDetailArray valueForKey:@"image"];
        strDesc       = [liveDetailArray valueForKey:@"description"];
    }
    if ((NSString *)[NSNull null] == strName) {
        strCheckName=@"";
    } else {
        strCheckName= strName;
    }
    if ((NSString *)[NSNull null] == strImageUrl) {
        strCheckImageUrl=@"";
    } else {
        strCheckImageUrl= strImageUrl;
    }
    if ((NSString *)[NSNull null] == strDesc) {
        strCheckstrDec=@"";
    } else {
        strCheckstrDec= strDesc;
    }
    NSURL *imageURL = [NSURL URLWithString:strCheckImageUrl];
    
    titleLabel.text = strCheckName;
    descTextView.text =strCheckstrDec;
    
    if([strCheckImageUrl  isEqual:@""]){
        [imageView setHidden:NO];
        [starImgView setBackgroundColor:[UIColor colorWithRed:41.0f/255.0f green:41.0f/255.0f blue:41.0f/255.0f alpha:1.0f]];
    }
    else{
        [imageView setHidden:YES];
        [starImgView setHidden:NO];
        [starImgView setImageWithURL:imageURL];
        
    }


}
#pragma mark - setUpDetailView - For Detail Actor Live Music
-(void)setUpDetailView{
    [self.searchActivityIndicator setHidden:true];
    
    CGFloat detailViewYPos;
    
    if(isActorViewDetails==YES){
         detailViewYPos = 44;
    }
    else{
        detailViewYPos = 0;
    }
    detailPageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, detailViewYPos, self.view.frame.size.width, self.view.frame.size.height)];
    detailView=[[UIView alloc]initWithFrame:CGRectMake(0, detailViewYPos, self.view.frame.size.width, self.view.frame.size.height)];
    [detailView setBackgroundColor:[UIColor clearColor]];
    [detailPageScrollView addSubview:detailView];
    [self.view addSubview:detailPageScrollView];
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 30)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(14)]];
     [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
   
    [detailView addSubview:titleLabel];
    
     CGFloat starImgViewWidth   = (starImgView.frame.origin.x+starImgView.frame.size.width+5);
     CGFloat starImgViewHeight  = (starImgView.frame.origin.x+starImgView.frame.size.width+5);
    
     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
         if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
             starImgViewWidth   = (self.view.frame.size.width/2.5);
             starImgViewHeight  = (self.view.frame.size.height/3);
         }
         else{
             starImgViewWidth   = (self.view.frame.size.width/3);
             starImgViewHeight  = (self.view.frame.size.height/1.8);
         }

     }
     else{
         //Port
         if ([UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeLeft && [UIDevice currentDevice].orientation!=UIDeviceOrientationLandscapeRight) {
             starImgViewWidth   = (self.view.frame.size.width/2.5);
             starImgViewHeight  = (self.view.frame.size.height/3);
         }
         //Land
         else{
             starImgViewWidth   = (self.view.frame.size.width/4);
             starImgViewHeight  = (self.view.frame.size.height/1.5);
         }
 
     }
         starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.size.height+20, starImgViewWidth, starImgViewHeight)];
    [starImgView setBackgroundColor:[UIColor whiteColor]];
    
    image = [UIImage imageNamed:@"playIcon"];
    //imageView = [[UIImageView alloc]initWithFrame:CGRectMake(starImgView.frame.origin.x+35,50, 40, 40)];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(starImgView.frame.size.width/2.4,starImgView.frame.size.height/2.4, 40, 40)];
    }
    else{
         imageView = [[UIImageView alloc]initWithFrame:CGRectMake(starImgView.frame.size.width/2.7,starImgView.frame.size.height/2.7, 40, 40)];
    }
    
    imageView.image = image;
    [starImgView addSubview:imageView];
    
    [detailView addSubview:starImgView];
    
    CGFloat descLabelXPos = (starImgView.frame.origin.x+starImgView.frame.size.width+8);
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(descLabelXPos, titleLabel.frame.size.height+20,self.view.frame.size.width/2, 30)];
    [descLabel setBackgroundColor:[UIColor clearColor]];
    [descLabel setTextColor:[UIColor whiteColor]];
    [descLabel setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    [descLabel setTextAlignment:NSTextAlignmentLeft];
    
    if(isActorViewDetails==YES){
        descLabel.text =@"Biography:";
    }
    else{
        descLabel.text =@"Description:";
    }
    [detailView addSubview:descLabel];
    
    NSString *textViewStr;
    if(isActorViewDetails ==YES){
        textViewStr       = [FullActorArray valueForKey:@"biography"];
    }
    else{

        textViewStr       = [liveDetailArray valueForKey:@"description"];
    }
    if ((NSString *)[NSNull null] == textViewStr ||textViewStr==nil) {
        textViewStr=@"";
    }
    
    CGFloat descTextViewXPos = (starImgView.frame.origin.x+starImgView.frame.size.width+8);
    CGFloat descTextViewYPos = (descLabel.frame.origin.y+descLabel.frame.size.height+10);
    
    CGRect textViewRect = [textViewStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width/2-10, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [COMMON getResizeableFont:Roboto_Regular(14)]}
                                                        context:nil];
    NSLog(@"overViewRect-->%f",textViewRect.size.height);
    
     //descTextView= [[UITextView alloc]initWithFrame:CGRectMake(descTextViewXPos,descTextViewYPos, self.view.frame.size.width/2, self.view.frame.size.height/2.8)];
    
    CGRect starImgageRectFrame = starImgView.frame;
    CGFloat starImageYPos = CGRectGetMaxY(starImgageRectFrame);
    starImageYPos = starImageYPos +20;
    
    
    
    //CGFloat normalHeight = self.view.frame.size.height;
    CGFloat textRectStrHeight = textViewRect.size.height+(starImgViewHeight/3);
    CGFloat detailPageScrollViewHeight = self.view.frame.size.height;
    //CGFloat currentTextViewHeight = self.view.frame.size.height/2.8;
    
//    if(normalHeight < textRectStrHeight){
//        detailPageScrollViewHeight = textRectStrHeight;
//    }
//    else{
//        detailPageScrollViewHeight = normalHeight;
//    }
    descTextView= [[UITextView alloc]initWithFrame:CGRectMake(descTextViewXPos,descTextViewYPos, self.view.frame.size.width/2, textRectStrHeight)];
    [descTextView setScrollEnabled:NO];
    [descTextView setEditable:NO];
    [descTextView setBackgroundColor:[UIColor clearColor]];
    [descTextView setTextColor:[UIColor whiteColor]];
    [descTextView setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    [descTextView setTextAlignment:NSTextAlignmentLeft];
    [detailView addSubview:descTextView];
    
    CGRect descTextViewFrame = descTextView.frame;
    CGFloat descTextViewFrameYPos = CGRectGetMaxY(descTextViewFrame);
    descTextViewFrameYPos = descTextViewFrameYPos +20;
    
    
//    if(starImageYPos > descTextViewFrameYPos){
//        detailPageScrollViewHeight = starImageYPos;
//    }
//    else{
        detailPageScrollViewHeight = descTextViewFrameYPos+(starImageYPos/2);
    //}

    
    
    [detailPageScrollView setContentSize:CGSizeMake(0,(detailPageScrollViewHeight+10))];
    
    [self loadLiveData];
    
}

#pragma mark - addCountInTitleArray
-(void)addCountInTitleArray{
    NSInteger arrayCount;
    titleWithCountArray = [NSMutableArray new];
    for(int i = 0; i < [titleTextArray count]; i++)
    {
        NSString *buttonTitleStr = [titleTextArray objectAtIndex:i] ;
        NSString *countrStr,*buttonTitle;
        
        if(![buttonTitleStr isEqualToString:@"actor"]){
            NSMutableArray * tempCountArray = [FullActorArray valueForKey:buttonTitleStr];
            arrayCount =  [tempCountArray count];
            countrStr = [NSString stringWithFormat:@"%ld", (long)arrayCount];
            buttonTitle = [[NSString stringWithFormat:@"%@(%@)", buttonTitleStr, countrStr] capitalizedString];
        }
        else{
            buttonTitle = [[NSString stringWithFormat:@"%@",buttonTitleStr] capitalizedString];
        }
        
        if ((NSString *)[NSNull null] == buttonTitle) {
            buttonTitle=@"";
        }
        [titleWithCountArray addObject:buttonTitle];
        
    }
    if([COMMON isSpanishLanguage]==YES){
        [self getStaticTranslatedWordList:SEARCH_VIEW_WORDS currentStaticArray:titleWithCountArray];
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
    titleWithCountArray = [[COMMON retrieveContentsFromFile:SEARCH_VIEW_WORDS dataType:DataTypeArray] mutableCopy];
    
}

#pragma mark - setSegmentTitleBar
-(void)setSegmentTitleBar{
    NSLog(@"detailPageVisibleSection%ld-->",(long)detailPageVisibleSection);
    titleTextArray = [NSMutableArray arrayWithObjects:@"movies",@"shows",@"actor",nil];
    [self addCountInTitleArray];
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
    _headerScroll.sectionTitles = titleWithCountArray;
    _headerScroll.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _headerScroll.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _headerScroll.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    _headerScroll.selectionIndicatorColor = [UIColor whiteColor];
    _headerScroll.selectedSegmentIndex = detailPageVisibleSection;
    
    
    [_headerScroll addTarget:self action:@selector(segmentedControlChangedValueSearchPage:) forControlEvents:UIControlEventValueChanged];
    
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
    
//    if(detailPageVisibleSection == 0)
//    {
//        if([titleTextArray count]!=0){
//            
//            NSString *buttonTitle = [titleTextArray objectAtIndex:detailPageVisibleSection];
//            NSMutableArray * resArray = [FullActorArray valueForKey:buttonTitle];
//            [self loadTableDataWithArray:buttonTitle currentArray:resArray];
//        }
//    }
    
}
#pragma mark - segmentedControlChangedValueSearchPage
- (void)segmentedControlChangedValueSearchPage:(HMSegmentedControl *)sender {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    detailPageVisibleSection = sender.selectedSegmentIndex;
    
    NSString *buttonTitle = [titleTextArray objectAtIndex:detailPageVisibleSection];
    NSMutableArray * resArray = [FullActorArray valueForKey:buttonTitle];
    [self loadTableDataWithArray:buttonTitle currentArray:resArray];
}
#pragma mark - loadTableDataWithArray

-(void)loadTableDataWithArray:(NSString*)currentTitleStr currentArray:(NSMutableArray*)resArray{
    
    selectedButtonName = currentTitleStr;
    stationDataArray = resArray;
    if(![currentTitleStr isEqualToString:@"actor"]){
        [searchStationTable setHidden:NO];
        [detailPageScrollView setHidden:YES];
        [searchStationTable reloadData];
        [self.searchStationTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    else{
        [searchStationTable setHidden:YES];
        [detailPageScrollView setHidden:NO];
        
    }

    if([selectedButtonName isEqualToString:@"shows"]){
        isMovieType=NO;
    }
    else{
        isMovieType=YES;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nCount = 0;
    nCount = m_ArrayChannels.count;
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
    NSDictionary *dictItem = dropDownNSArray[indexPath.row];
    NSString *strChannelName;
    if(isNetworksView==YES){
        strChannelName = dictItem[@"name"];
    }
    [cell.labelText setText:strChannelName];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictItem = (NSDictionary *) dropDownNSArray[indexPath.row];
    NSString* strID = dictItem[@"id"];
    NSString* strLabel;
    NSLog(@"strID%@",strID);
    NSLog(@"strLabel%@",strLabel);
    if(isNetworksView==YES){
        strLabel = dictItem[@"name"];
        [self updateNetworkDetailData:[strID intValue]];
    }
    isNetworkLeftMeunShown = false;
    [channelView close];
    channelView =nil;
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    NSMutableAttributedString *roboAttrString = [[NSMutableAttributedString alloc]initWithString:strLabel attributes:attrRoboFontDict];
    [roboAttrString appendAttributedString:aweAttrString];
    _stationName.attributedText = roboAttrString;
    networkStr = strLabel;
    
}
#pragma mark - Custom7AlertDialog Delegate
-(void)customIOS7dialogDismiss{
    isNetworkLeftMeunShown = false;
    
    [channelView removeFromSuperview];
    [channelView close];
    channelView = nil;

    [ondemandView removeFromSuperview];
    [ondemandView close];
    ondemandView = nil;
   
}

-(void)setOrientation{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actorOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
}

-(void) actorOrientationChanged:(NSNotification *) note
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

#pragma mark - UI Grid View Delegate
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return nStationWidth;
    
}
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat currentCellHeight = 210;
        if(isMovieType==YES){
            currentCellHeight=210;
        }
        else{
            currentCellHeight=155;
        }
        return currentCellHeight;//return 185;//nSearchHeight;
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
    return nStationColumn;
    
}
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if([stationDataArray count]!=0){
        return [stationDataArray count];
    }
    else{
        return 0;
    }
}
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    //CELL
    
//    New_Land_Cell* cell = [grid dequeueReusableCell];
//    if(cell == nil){
//        cell = [[New_Land_Cell alloc] init];
//    }

    OnDemand_Grid_Cell* cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[OnDemand_Grid_Cell alloc] init];
    }
    int nIndex = rowIndex * nStationColumn + columnIndex;
    if([stationDataArray count]!=0){
        NSDictionary* dictItemData = stationDataArray[nIndex];
        NSMutableArray * dataArray = (NSMutableArray*) dictItemData;
        
        NSString* strName;
        NSString* strUrl;
        NSString* strCheckName;
        if(isNetworksView ==YES){
            strName = [dataArray valueForKey:@"name"];
            strUrl = [dataArray valueForKey:@"poster_url"];
        }
        else if(isActorViewDetails ==YES){
            strName = [dataArray valueForKey:@"name"];
            strUrl = [dataArray valueForKey:@"poster_url"];
        }
        else{
            strName = [dataArray valueForKey:@"title"];
            strUrl = [dataArray valueForKey:@"url"];
        }
        
        if ((NSString *)[NSNull null] == strName) {
            strCheckName=@"";
        } else {
            strCheckName= strName;
        }
        NSString* strCheckImageUrl;
        if ((NSString *)[NSNull null] == strUrl) {
            strCheckImageUrl=@"";
        } else {
            strCheckImageUrl= strUrl;
        }
       

        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_STATION_URL, strCheckImageUrl];
        NSURL *imageURL;
       
        if(isNetworksView ==YES){
            imageURL= [NSURL URLWithString:strCheckImageUrl];
             //[cell.thumbnail setImageWithURL:imageURL];
        }
        else if(isActorViewDetails ==YES){
            imageURL= [NSURL URLWithString:strCheckImageUrl];
           // [cell.thumbnail setImageWithURL:imageURL];
        }

        else{
            imageURL = [NSURL URLWithString:strImageUrl];
             //[cell.thumbnail setImageWithURL:imageURL];
        }
        
        
        if([selectedButtonName isEqualToString:@"movies"]){
            [cell.thumbnail setHidden:YES];
            [cell.landScapeView setHidden:YES];
            [cell.portraitView setHidden:NO];
            [cell.moviePortraitImage setHidden:NO];
//            if(isNetworkImage==YES){
//                [cell.moviePortraitImage setHidden:YES];
//                [cell.portraitImageView setHidden:NO];
//                [cell.portraitImageView setImageWithURL:imageURL];
//            }
//            else{
        
            //}
            [cell.portraitImageView setHidden:YES];
//            if([strCheckImageUrl isEqualToString:@""]){
//                [cell.moviePortraitImage setHidden:YES];
//            }
//            else{
                [cell.moviePortraitImage setHidden:NO];
                //[cell.moviePortraitImage setImageWithURL:imageURL];
                [cell.moviePortraitImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"movie_Loader"]];
           // }
            
        }
        else{
            [cell.moviePortraitImage setHidden:NO];
            [cell.landScapeView setHidden:NO];
            [cell.portraitImageView setHidden:YES];
            [cell.portraitView setHidden:YES];
            [cell.thumbnail setHidden:NO];
//            if([strCheckImageUrl isEqualToString:@""]){
//                [cell.thumbnail setHidden:YES];
//            }
//            else{
                [cell.thumbnail setHidden:NO];
                //[cell.thumbnail setImageWithURL:imageURL];
                [cell.thumbnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"show_Loader"]];
            //}
            
            
        }


        

    }
    return cell;
    
}
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    isNetworkLeftMeunShown = false;
    
    int nIndex = rowIndex * nStationColumn + colIndex;
    NSDictionary* dictItemData = stationDataArray[nIndex];
    dataSelectedArray = (NSMutableArray*) dictItemData;;
    strSelectedId = [dataSelectedArray valueForKey:@"id"];
    strSelectedName = [dataSelectedArray valueForKey:@"name"];
    NSString* strName = [dataSelectedArray valueForKey:@"title"];
    NSString* strUrl;
    NSString* strCheckName;
    if(isNetworksView ==YES){
        
        strUrl = [dataSelectedArray valueForKey:@"poster_url"];
    }
    else if(isActorViewDetails ==YES){
         strUrl = [dataSelectedArray valueForKey:@"poster_url"];
    }
    else{
        strUrl = [dataSelectedArray valueForKey:@"url"];
    }
    
    if ((NSString *)[NSNull null] == strName) {
        strCheckName=@"";
    } else {
        strCheckName= strName;
    }
    NSString* strCheckUrl;
    if ((NSString *)[NSNull null] == strUrl) {
        strCheckUrl=@"";
    } else {
        strCheckUrl= strUrl;
    }
    if(isNetworksView == YES){
        [self loadSeasonData];
        //[self pushToMovieDetailPage];
    }
    else if(isActorViewDetails ==YES){
        if([selectedButtonName isEqualToString:@"movies"]){
            //[self pushToMovieDetailPage];
            //[self loadNewMovieDetailPage];
            isSeasonExist=NO;
            [self loadNewShowDetailPage];
        }
        else{
            //[self pushToShowDetailPage];
            [self loadSeasonData];
        }
    }
    else{
        [self newShowVideoOnDemandDialog:strCheckName URL:strCheckUrl];
    }
 
}
#pragma mark - loadSeasonData
-(void) loadSeasonData{
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        if([arraySeasons count]==0){
            //[self loadNewMovieDetailPage];
            isSeasonExist=NO;
            [self loadNewShowDetailPage];
        }
        else{
            isSeasonExist=YES;
            [self loadNewShowDetailPage];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    } nID:[strSelectedId intValue]];
    
}
#pragma mark - loadNewShowDetailPage
-(void)loadNewShowDetailPage{
    
    NewShowDetailViewController * mShowVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail_ipad"];
    } else {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_showdetail"];
    }
    mShowVC.nID = strSelectedId;
    mShowVC.headerLabelStr = strSelectedName;
   
    if(isSeasonExist){
        mShowVC.isEpisode=YES;
        mShowVC.showFullSeasonsArray = arraySeasons;
    }
    else{
         mShowVC.isEpisode=NO;
    }
    if(isNetworksView==YES){
        [mShowVC setIfMovies:false];
         mShowVC.genreName = networkStr;
    }
    else if(isActorViewDetails==YES){
        if([selectedButtonName isEqualToString:@"movies"]){
             [mShowVC setIfMovies:true];
        }
        else{
             [mShowVC setIfMovies:false];
        }
         mShowVC.genreName = selectedButtonName;
    }
    mShowVC.isToggledAll=YES;
  
    [self.navigationController pushViewController:mShowVC animated:YES];
    
}
//No Seasons
#pragma mark - loadNewMovieDetailPage
-(void)loadNewMovieDetailPage{
    
    NewMovieDetailViewController *mNewMovieVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mNewMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_movie_detail_ipad"];
    } else {
        mNewMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"new_moviedetail_iphone"];
    }
      if(isNetworksView ==YES){
           [mNewMovieVC setIfMovies:false];
           mNewMovieVC.genreName = networkStr;
      }
      else if(isActorViewDetails==YES){
        [mNewMovieVC setIfMovies:true];
          mNewMovieVC.genreName = selectedButtonName;
      }
    mNewMovieVC.nID = strSelectedId;
    mNewMovieVC.headerLabelStr = strSelectedName;
    mNewMovieVC.isEpisode=NO;
   
    [self.navigationController pushViewController:mNewMovieVC animated:YES];
    
}

#pragma mark -pushToShowDetailPage
-(void) pushToShowDetailPage{
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
        arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
        if([arraySeasons count] > 0){
           // [self loadSeasonPage];
        }
        else if([arraySeasons count] == 0){
            //[self loadShowDetailPage];
        }
        
    } nID:[strSelectedId intValue]];
}
#pragma mark -showVideoOnDemandDialog
- (void)showVideoOnDemandDialog:(NSString*)strTitle URL:(NSString*) strUrl
{
    curVideoUrl = strUrl;
    
    UIView* viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 280)];
    [viewContainer setBackgroundColor:[UIColor blackColor]];
    
    UILabel* labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 180, 50)];
    [labelTitle setText:@"Video On-Demand"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setFont:[COMMON getResizeableFont:Roboto_Regular(18)]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel* labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 220, 30)];
    [labelDescription setText:@"You have requested to watch"];
    [labelDescription setTextColor:[UIColor whiteColor]];
    [labelDescription setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    [labelDescription setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView* imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(40, 75, 200, 120)];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_STATION_URL, strUrl];
    NSURL *imageURL = [NSURL URLWithString:strImageUrl];
    [imageThumbnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"noVideoBgIcon"]];
    // [imageThumbnail setImageWithURL:imageURL ];
    
    UILabel* labelVideoName = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 220, 30)];
    [labelVideoName setText:strTitle];
    [labelVideoName setTextColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f]];
    [labelVideoName setFont:[UIFont systemFontOfSize:14]];
    [labelVideoName setTextAlignment:NSTextAlignmentCenter];
    
    UIButton* btnWatch = [[UIButton alloc] initWithFrame:CGRectMake(30, 235, 100, 30)];
    [btnWatch setTitle:@"Watch Now" forState:UIControlStateNormal];
    [btnWatch setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    btnWatch.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [btnWatch setBackgroundColor:[UIColor blackColor]];
    [btnWatch addTarget:self action:@selector(onDemand_watch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(150, 235, 100, 30)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    btnCancel.titleLabel.font =[COMMON getResizeableFont:Roboto_Regular(14)];
    [btnCancel setBackgroundColor:[UIColor blackColor]];
    [btnCancel addTarget:self action:@selector(onDemand_cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewContainer addSubview:labelTitle];
    [viewContainer addSubview:labelDescription];
    [viewContainer addSubview:imageThumbnail];
    [viewContainer addSubview:labelVideoName];
    [viewContainer addSubview:btnWatch];
    [viewContainer addSubview:btnCancel];
    ondemandView = [[CustomIOS7AlertView alloc]initWithFrame:CGRectMake(0, 0, 280, 280)];
    ondemandView.delegate = self;
    [ondemandView setContainerView:viewContainer];
    [ondemandView show];
    bDemandSearchShown = true;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [ondemandView addGestureRecognizer:tapGestureRecognizer];
    ondemandView.userInteractionEnabled = YES;
}
#pragma mark - tapActions
- (void)tapOnPopUpView:(UITapGestureRecognizer *)tap {
    bDemandSearchShown =false;
    isNetworkLeftMeunShown=false;
    
    [channelView removeFromSuperview];
    [channelView close];
    channelView = nil;
    
    [ondemandView removeFromSuperview];
    [ondemandView close];
    ondemandView = nil;
    
}

#pragma mark - showVideoDialogBox
- (void)newShowVideoOnDemandDialog:(NSString*)strTitle URL:(NSString*) strUrl
{
    curVideoUrl = strUrl;
    _curTitle = strTitle;
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
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@/default.jpg", THUMBNAIL_STATION_URL, strUrl];
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
    bDemandSearchShown = true;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPopUpView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [ondemandView addGestureRecognizer:tapGestureRecognizer];
    ondemandView.userInteractionEnabled = YES;

}

-(IBAction) onDemand_watch:(id)sender
{
//    if(![self castVideoFromId:m_nCurVideoID])
//    {
        PlayerViewController* mPlayerVC  =[self.storyboard instantiateViewControllerWithIdentifier:@"playervc"];
        
        [mPlayerVC setURL:curVideoUrl];
        
        [self.navigationController pushViewController:mPlayerVC animated:YES];
   // }
    
    [ondemandView close];
    bDemandSearchShown =false;
}
-(IBAction) onDemand_cancel:(id)sender
{
    [ondemandView close];
    bDemandSearchShown = false;
}
#pragma mark -Back Action
- (IBAction) goBack:(id)sender{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark -Rotate View
-(void) rotateViews:(BOOL) bPortrait{
    NSLog(@"detailPageVisibleSection%ld-->",(long)detailPageVisibleSection);
    
    if(isLiveViewDetails == YES){
        [_stationName setHidden:YES];
        [searchStationTable setHidden:YES];
        [detailPageScrollView removeFromSuperview];
        [self setUpDetailView];
        //[self loadLiveData];
    }
    else if(isActorViewDetails == YES){
        [_stationName setHidden:YES];
        [detailPageScrollView removeFromSuperview];
        [self setUpDetailView];
        [detailPageScrollView setHidden:YES];
        [self setSegmentTitleBar];
        
        NSString *buttonTitle = [titleTextArray objectAtIndex:detailPageVisibleSection];
        NSMutableArray * resArray = [FullActorArray valueForKey:buttonTitle];
        [self loadTableDataWithArray:buttonTitle currentArray:resArray];
    }
    

   
    if(bPortrait){
        port_SearchDetailViewHeight= SCREEN_HEIGHT;
        
        nStationColumn = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nStationColumn = 3;
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nStationWidth = screenWidth / nStationColumn;
        nStationHeight = screenWidth / nStationColumn;
        
        if(port_SearchDetailViewHeight!=land_SearchDetailViewHeight){
            [self onSearchDetailNetworkMenuList:YES];
        }
    }else{
        land_SearchDetailViewHeight = SCREEN_HEIGHT;
        
        nStationColumn = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nStationColumn = 4;
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nStationWidth = screenWidth / nStationColumn;
        nStationHeight = screenWidth / nStationColumn;
        
        if(port_SearchDetailViewHeight!=land_SearchDetailViewHeight){
            [self onSearchDetailNetworkMenuList:NO];
        }
    }
    [searchStationTable reloadData];
}
-(void)onSearchDetailNetworkMenuList:(BOOL)portraitBool{
    
    if(isNetworkLeftMeunShown){
        [channelView removeFromSuperview];
        [channelView close];
        channelView = nil;
        [self loadNetworkTableMenu];
    }
    if(bDemandSearchShown){
        [ondemandView removeFromSuperview];
        [ondemandView close];
        ondemandView = nil;

        [self newShowVideoOnDemandDialog:_curTitle URL:curVideoUrl];
    }
    if(portraitBool==YES){
        land_SearchDetailViewHeight  = port_SearchDetailViewHeight;
    }
    else{
        port_SearchDetailViewHeight  = land_SearchDetailViewHeight;
    }

}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}
@end
