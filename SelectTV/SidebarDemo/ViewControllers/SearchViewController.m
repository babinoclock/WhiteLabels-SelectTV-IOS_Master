 //
//  SearchViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 30/03/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "SearchViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "Season.h"
#import "Cell.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImage.h"
#import "SearchCell.h"
#import "CustomIOS7AlertView.h"
#import "RabbitTVManager.h"
#import "MBProgressHUD.h"
#import "SearchDetailViewController.h"
#import "PayMovieViewController.h"
#import "SearchRadioViewController.h"
#import "NewShowDetailViewController.h"
#import "NewMovieDetailViewController.h"
#import "New_Land_Cell.h"
#import "OnDemand_Grid_Cell.h"


@interface SearchViewController (){
    
    //Scrolltitle
    UIView *backgroundView ;
    UILabel *indicateLabel;
    CGFloat scrollButtonWidth;
    CGFloat scrollButtonWidthTest;
    CGSize stringsize;
    BOOL isScrolled;
    NSInteger visibleSection;
    NSMutableArray *titleDataArray;
    NSMutableArray *scrollTitleHeaderArray;
    NSMutableArray* arraySeasons;
    NSMutableArray *arrayStreams;
    NSMutableArray *arrayStationSearch;
    NSMutableArray *arrayRadioSearch;
    NSMutableArray *arrayLiveSearchDetails;
   
    
    NSString* strSelectedId;
    NSString* strSelectedType;
    NSString* strSelectedName;
    NSString* strSelectedPosterUrl;
    NSMutableArray * dataSelectedArray;
    NSMutableDictionary * responseDictionaryStation;

    IBOutlet UIView *topView;
    
    CGFloat searchScreenWidth;
    BOOL isMovieType;
    NSMutableArray *titleWithCountArray;
    NSString * currentAppLanguage;
    
}

@end

@implementation SearchViewController

@synthesize showHeaderView,searchTitle,titleTextArray,FullSearchArray,isFromChannel;

int nSearchColumn=3;
int nSearchWidth=107;
int nSearchHeight=200;

-(void)viewDidLoad
{
    [super viewDidLoad];
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
     scrollTitleHeaderArray  = [NSMutableArray arrayWithObjects: @"All", @"TV Shows", @"Movies", @"Actors", @"Channels", @"TV Stations", @"Networks", @"Radio",@"Events", @"Music", @"MoreVideos",nil];
    [self.view endEditing:YES];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNavigation];
    [self setOrientation];
    NSLog(@"visibleSectionWillApp%ld",(long)visibleSection);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
   
}
-(void) loadNavigation{
    [self.navigationController.navigationBar setHidden:NO];
    NSString *NavigationTitle = [NSString stringWithFormat:@"%@\"%@\"", @"Results for ", searchTitle] ;
    self.title = NavigationTitle;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;

}
-(void)setOrientation{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }

}
#pragma mark - orientationChanged
-(void) searchOrientationChanged:(NSNotification *) note
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

#pragma mark - addCountInTitleArray
-(void)addCountInTitleArray{
    
    titleWithCountArray = [NSMutableArray new];
    for(int i = 0; i < [titleTextArray count]; i++)
    {
        
        NSString *titleStr = [titleTextArray objectAtIndex:i] ;
        NSString *countrStr;
        if([titleStr isEqualToString:@"Channels"])
            countrStr = [[FullSearchArray valueForKey:@"station"]objectForKey:@"count"];
         else
            countrStr = [[FullSearchArray valueForKey:titleStr]objectForKey:@"count"];
        NSString *buttonTitle = [[NSString stringWithFormat:@"%@(%@)", titleStr, countrStr] capitalizedString];
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
    _headerScroll.selectedSegmentIndex = visibleSection;
    
    
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
    
    if(visibleSection == 0)
    {
        if([titleTextArray count]!=0){
            NSString *buttonTitle = [titleTextArray objectAtIndex:visibleSection];
            NSMutableArray * resArray = [[FullSearchArray valueForKey:buttonTitle]objectForKey:@"items"];
            [self loadTableDataWithArray:buttonTitle currentArray:resArray];
            
        }
    }

}
#pragma mark - segmentedControlChangedValueSearchPage
- (void)segmentedControlChangedValueSearchPage:(HMSegmentedControl *)sender {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    visibleSection = sender.selectedSegmentIndex;
    
    NSString *buttonTitle = [titleTextArray objectAtIndex:visibleSection];
    if([buttonTitle isEqualToString:@"Channels"])
        buttonTitle = @"station";
    NSMutableArray * resArray = [[FullSearchArray valueForKey:buttonTitle]objectForKey:@"items"];
    [self loadTableDataWithArray:buttonTitle currentArray:resArray];
}
#pragma mark - loadTableDataWithArray

-(void)loadTableDataWithArray:(NSString*)currentTitleStr currentArray:(NSMutableArray*)resArray{
    
    titleDataArray = resArray;
    scrollButtonTitle= currentTitleStr;
    if([scrollButtonTitle isEqualToString:@"show"]||[scrollButtonTitle isEqualToString:@"tvstation"]){
        isMovieType=NO;
    }
    else{
        isMovieType=YES;
    }
    [_searchTable reloadData];
    [self.searchTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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
    return nSearchWidth;
    
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
    return nSearchColumn;
    
}
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if([titleDataArray count]!=0){
         return [titleDataArray count];
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
    
    int nIndex = rowIndex * nSearchColumn + columnIndex;
    if([titleDataArray count]!=0){
        NSDictionary* dictItemData = titleDataArray[nIndex];
        NSMutableArray * dataArray = (NSMutableArray*) dictItemData;
        NSString* strPosterUrl =[dataArray valueForKey:@"image"];
       
        NSString* strCheckImageUrl;
        
        if ((NSString *)[NSNull null] == strPosterUrl) {
            strCheckImageUrl=@"";
        } else {
            strCheckImageUrl= strPosterUrl;
        }
        NSString* strName = [dataArray valueForKey:@"name"];
        NSString* strCheckName;
        
        if ((NSString *)[NSNull null] == strName) {
            strCheckName=@"";
        } else {
            strCheckName= strName;
        }
        
        NSString* stringToFind = @"https://";
        NSString * imageLink = strCheckImageUrl;
        if([imageLink containsString: stringToFind]){
            strCheckImageUrl = imageLink;
           
        }
        else{
            NSString * imageReplaceUrl = [imageLink stringByReplacingOccurrencesOfString:@"//" withString:@"https://"];
            strCheckImageUrl = imageReplaceUrl;
        }
        NSURL* imageUrl = [NSURL URLWithString:strCheckImageUrl];
       /* [cell.thumbnail setImageWithURL:imageUrl];
        [cell.label setText:strCheckName];*/
                
        if([scrollButtonTitle isEqualToString:@"show"]||[scrollButtonTitle isEqualToString:@"tvstation"]){
            [cell.moviePortraitImage setHidden:YES];
            [cell.thumbnail setHidden:NO];
            [cell.landScapeView setHidden:NO];
            [cell.portraitImageView setHidden:YES];
            [cell.portraitView setHidden:YES];
//            if([strCheckImageUrl isEqualToString:@""]){
//                [cell.thumbnail setHidden:YES];
//            }
//            else{
                [cell.thumbnail setHidden:NO];
                [cell.thumbnail setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];
                
            //}
        }
        else{
            [cell.thumbnail setHidden:YES];
            [cell.landScapeView setHidden:YES];
            [cell.portraitView setHidden:NO];
            if([scrollButtonTitle isEqualToString:@"network"]){
                [cell.moviePortraitImage setHidden:YES];
                [cell.portraitImageView setHidden:NO];
//                if([strCheckImageUrl isEqualToString:@""]){
//                    [cell.portraitImageView setHidden:YES];
//                }
                //else{
                    [cell.portraitImageView setHidden:NO];
                    [cell.portraitImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];
                //}
                
            }
            else{
                [cell.moviePortraitImage setHidden:NO];
                [cell.portraitImageView setHidden:YES];
//                if([strCheckImageUrl isEqualToString:@""]){
//                   [cell.moviePortraitImage setHidden:YES];
//                }
//                else{
                    [cell.moviePortraitImage setHidden:NO];
                    [cell.moviePortraitImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];
  
                //}
            }
      
            
        }


        
    }
    return cell;

}
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    int nIndex = rowIndex * nSearchColumn + colIndex;
    NSDictionary* dictItemData = titleDataArray[nIndex];
    dataSelectedArray = (NSMutableArray*) dictItemData;
    strSelectedId =[dataSelectedArray valueForKey:@"id"];
    strSelectedType =[dataSelectedArray valueForKey:@"type"];
    strSelectedName = [dataSelectedArray valueForKey:@"name"];
    NSString * strName =[dataSelectedArray valueForKey:@"name"];
    NSString * strImageUrl  =[dataSelectedArray valueForKey:@"image"];
    
    //Check Name
    if ((NSString *)[NSNull null] == strName) {
        strSelectedName=@"";
    } else {
        strSelectedName= strName;
    }
    
    //checkImage
    if ((NSString *)[NSNull null] == strImageUrl) {
        strSelectedPosterUrl=@"";
    } else {
        strSelectedPosterUrl= strImageUrl;
    }
    NSString* stringToFind = @"https://";
    NSString * imageLink = strSelectedPosterUrl;
    if([imageLink containsString: stringToFind]){
        strSelectedPosterUrl = imageLink;
    }
    else{
        NSString * imageReplaceUrl = [imageLink stringByReplacingOccurrencesOfString:@"//" withString:@"https://"];
        strSelectedPosterUrl = imageReplaceUrl;
    }
   
    //MOVIE
    if([strSelectedType isEqualToString:@"movie"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
       // [self loadMovieDetailPage];
        isSeasonArrayExist=NO;
        //[self loadNewMovieDetailPage];
        [self loadNewShowDetailPage];
    }
    //SHOW
    else if([strSelectedType isEqualToString:@"show"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getShowSeasons:^(AFHTTPRequestOperation * request, id responseObject) {
            arraySeasons = [[NSMutableArray alloc] initWithArray:responseObject];
            if([arraySeasons count] > 0){
               // [self loadSeasonPage];
                isSeasonArrayExist=YES;
                [self loadNewShowDetailPage];
            }
            else if([arraySeasons count] == 0){
               // [self loadShowDetailPage];
                isSeasonArrayExist=NO;
                //[self loadNewMovieDetailPage];
                [self loadNewShowDetailPage];
            }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        } nID:[strSelectedId intValue]];
    }
    //STATION
    else if([strSelectedType isEqualToString:@"station"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getStreams:^(AFHTTPRequestOperation * operation, id responseObject) {
            if ([responseObject count] == 0) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                [AppCommon showSimpleAlertWithMessage:@"Temporarily Videos UnAvailable"];
                
            }
            else{
                responseDictionaryStation = responseObject;
                [self loadStationDetailPage];
            }
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [AppCommon showSimpleAlertWithMessage:@"Temporarily Videos UnAvailable"];
            
        
        } chanID:[strSelectedId intValue]];

    }
    //NETWORK
    else if([strSelectedType isEqualToString:@"network"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self loadSearchDetailPage];
        //[self loadPayMovieDetailPage];
    }
    //RADIO
    else if([strSelectedType isEqualToString:@"radio"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getRadioWithId:^(AFHTTPRequestOperation * operation, id responseObject) {
            arrayRadioSearch = responseObject;
             [self loadRadioDetailPage];
            
        }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
        } nRadioID:[strSelectedId intValue]];
       
    }
    //Live
    else if([strSelectedType isEqualToString:@"live"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getLiveDetails:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayLiveSearchDetails = responseObject;
           [self loadSearchDetailPage];
        } nID:[strSelectedId intValue]];
        
    }
    //TV Station
    else if([strSelectedType isEqualToString:@"tvstation"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getTvStationDetails:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayLiveSearchDetails = responseObject;
            [self loadSearchDetailPage];
        } nID:[strSelectedId intValue]];
        
    }
    //Actor
    else if([strSelectedType isEqualToString:@"actor"]){
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[RabbitTVManager sharedManager] getActorDetails:^(AFHTTPRequestOperation * request, id responseObject) {
            arrayLiveSearchDetails = responseObject;
            [self loadSearchDetailPage];
        } nID:[strSelectedId intValue]];
    }
    
}

#pragma mark -loadPayMovieDetailPagePush
-(void)loadPayMovieDetailPage{
    PayMovieViewController *mPayMovieVC = nil;
    mPayMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMovieViewController"];
    mPayMovieVC.isNetworksView =YES;
    mPayMovieVC.isSearchNetworksView =YES;

    mPayMovieVC.payShowStr = strSelectedName;
    [mPayMovieVC updateNetworkDetailData:[strSelectedId intValue]];
    mPayMovieVC.dropDownNSArray=titleDataArray;
    mPayMovieVC.payHeaderLabelStr=@"TV Networks";
    [self.navigationController pushViewController:mPayMovieVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
#pragma mark -loadPayMovieDetailPagePush
-(void)loadSearchDetailPage{
    
    SearchDetailViewController *searchDetailVC = nil;
    searchDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDetail"];
    if([strSelectedType isEqualToString:@"network"]){
        searchDetailVC.isNetworksView = YES;
        searchDetailVC.isLiveViewDetails =  NO;
        searchDetailVC.dropDownNSArray=titleDataArray;
        searchDetailVC.networkStr = strSelectedName;
        [searchDetailVC updateNetworkDetailData:[strSelectedId intValue]];
    }
    else if([strSelectedType isEqualToString:@"actor"]){
        searchDetailVC.FullActorArray = arrayLiveSearchDetails;
        searchDetailVC.isActorViewDetails = YES;
        searchDetailVC.isNetworksView = NO;
        searchDetailVC.isLiveViewDetails =  NO;
        searchDetailVC.actorPosterUrl = strSelectedPosterUrl;
    }
    else{
        //LIVE , TV STATION
        searchDetailVC.isNetworksView = NO;
        searchDetailVC.isLiveViewDetails =  YES;
        searchDetailVC.liveDetailArray = arrayLiveSearchDetails;
    }
    if(isFromChannel==YES){
        searchDetailVC.isFromChannel =YES;
    }
    else{
        searchDetailVC.isFromChannel =NO;
    }
    searchDetailVC.titleStr = strSelectedType;
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
#pragma mark -loadStationDetailPagePush
- (void) loadStationDetailPage{
    NSDictionary *retDict = (NSDictionary *) responseDictionaryStation;
    NSString* stationID = [NSString stringWithFormat:@"%@", strSelectedId];
    NSDictionary *retChannel = retDict[stationID];
    arrayStreams =  [NSMutableArray arrayWithArray:retChannel[@"videos"]];
    SearchDetailViewController* searchDetailVC = nil;
    searchDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDetail"];
    searchDetailVC.networkStr = @"Channel Videos";
    searchDetailVC.stationDataArray = arrayStreams;
    searchDetailVC.stationNameStr = strSelectedName;
    searchDetailVC.titleStr = strSelectedType;
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
#pragma mark -loadStationDetailPagePush
- (void) loadRadioDetailPage{
    SearchRadioViewController* searchRadioVC = nil;
    searchRadioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchRadio"];
    searchRadioVC.radioDetailArray = arrayRadioSearch;
    searchRadioVC.radioImageUrl=strSelectedPosterUrl;
    [self.navigationController pushViewController:searchRadioVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}
#pragma mark - NEW PUSH
//NEW
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
    if([strSelectedType isEqualToString:@"movie"]){
        [mShowVC setIfMovies:true];
    }
    else{
        [mShowVC setIfMovies:false];
    }
    if(isSeasonArrayExist){
       mShowVC.isEpisode=YES;
       mShowVC.showFullSeasonsArray = arraySeasons;
    }
    else{
        mShowVC.isEpisode=NO;
    }
    
    mShowVC.genreName = strSelectedType;
    mShowVC.isToggledAll=YES;
    
    [self.navigationController pushViewController:mShowVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

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
    if([strSelectedType isEqualToString:@"movie"]){
        [mNewMovieVC setIfMovies:true];
    }
    else{
        [mNewMovieVC setIfMovies:false];
    }

    mNewMovieVC.nID = strSelectedId;
    mNewMovieVC.headerLabelStr = strSelectedName;
    mNewMovieVC.isEpisode=NO;
    mNewMovieVC.genreName = strSelectedType;
    [self.navigationController pushViewController:mNewMovieVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

    
}

#pragma mark -Rotate View
-(void) rotateViews:(BOOL) bPortrait{
    [self setSegmentTitleBar];
    if(bPortrait){
        nSearchColumn = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nSearchColumn = 3;
            
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nSearchWidth = screenWidth / nSearchColumn;
        nSearchHeight = screenWidth / nSearchColumn;
    }else{
        
        nSearchColumn = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nSearchColumn = 4;
        }
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nSearchWidth = screenWidth / nSearchColumn;
        nSearchHeight = screenWidth / nSearchColumn;
    }
    [self.searchTable reloadData];
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}
@end


