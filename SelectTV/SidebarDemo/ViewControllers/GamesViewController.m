//
//  GamesViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 23/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "GamesViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "SubscriptionCell.h"
#import "AsyncImage.h"
#import "LoginViewController.h"


@interface GamesViewController ()<UIGridViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSString * currentApplanguage;
}
@end
@implementation GamesViewController
@synthesize isMoreView,isLogout;
int nGamesColumCount = 2;
int nGamesCellWidth = 107;
int nGamesCellHeight = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(isLogout==YES){
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//        LoginViewController * LoginVC = nil;
//        LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.navigationController pushViewController:LoginVC animated:YES];
//    }
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
   // self.view = [COMMON setBackGroundColor:self.view];
    self.view.backgroundColor = GRAY_BG_COLOR;
    
    currentApplanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * titleStr;   
    if(isMoreView==YES){
     titleStr = @"More";
        [_topSegmentView removeFromSuperview];
        [_carouselTableView removeFromSuperview];
        [_gamesGirdTable setHidden:NO];
    }
    else{
      titleStr=@"Games";
      [_gamesGirdTable setHidden:YES];
      [_carouselTableView setHidden:NO];
    }
    if([COMMON isSpanishLanguage]==YES){
        if([titleStr isEqualToString:@"Games"]){
            titleStr = [COMMON getGamesNavTitleStr];
            if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
                titleStr =@"Games";
                titleStr = [self commanSpanishLanguageConvertion:titleStr savingName:GAMES_TITLE];
            }
        }
        else{
            titleStr = [COMMON getMoreNavTitleStr];
            if ((NSString *)[NSNull null] == titleStr||titleStr == nil) {
                titleStr =@"More";
                titleStr = [self commanSpanishLanguageConvertion:titleStr savingName:MORE_TITLE];
            }
        }
        
    }
    self.navigationItem.title = titleStr;
    [_gamesGirdTable setBackgroundColor:[UIColor clearColor]];
    [_carouselTableView setBackgroundColor:[UIColor clearColor]];
    
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor=[COMMON Common_Gray_BG_Color];
    self.navigationController.navigationBar.tintColor = [COMMON Common_Gray_BG_Color];;
    self.navigationController.navigationBar.barTintColor = [COMMON Common_Gray_BG_Color];;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesViewOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UIDevice* homeDevice = [UIDevice currentDevice];
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self gamesRotateViews:false];
    }else{
        [self gamesRotateViews:true];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionViewForGamesView:) name:@"didSelectItemFromCollectionViewForGamesView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewAllOptionGames:) name:@"sliderViewAllOptionGamesView" object:nil];
    

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

#pragma mark - SCROLL HEADER
-(void)setScrollHeader {
    
   
    [self getGamesTopMenuList];
    CGFloat commonWidth;
    commonWidth = [UIScreen mainScreen].bounds.size.width;
    [_gamesHeaderScroll removeFromSuperview];
    

   // titleArray =[[NSMutableArray alloc] initWithObjects:@"TV SHOWS", @"MOVIES",@"PRIME TIME",@"WEB ORIGINALS",@"KIDS", nil];//@"SPORTS", nil];
    _gamesHeaderScroll = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, commonWidth, _topSegmentView.frame.size.height)];
    [_topSegmentView addSubview:_gamesHeaderScroll];
    
    //[_gamesHeaderScroll setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1]];
    _gamesHeaderScroll.backgroundColor = [COMMON Common_Gray_BG_Color];;
    
    _gamesHeaderScroll.sectionTitles = titleArray;
    _gamesHeaderScroll.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _gamesHeaderScroll.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    _gamesHeaderScroll.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _gamesHeaderScroll.selectionIndicatorColor = [UIColor whiteColor];
    
    [_gamesHeaderScroll addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _gamesHeaderScroll.selectedSegmentIndex = visibleSection;
    
    [_gamesHeaderScroll setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString;
        
        if (selected) {
            
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        } else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [COMMON Common_Light_BG_Color],NSFontAttributeName:[COMMON getResizeableFont:Roboto_Bold(14)]}];
            
            return attString;
        }
    }];
    
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender {
    
    [[RabbitTVManager sharedManager]cancelRequest];
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)sender.selectedSegmentIndex);
    visibleSection = sender.selectedSegmentIndex;
    if(visibleSection==0){
        [_gamesGirdTable setHidden:YES];
        [_carouselTableView setHidden:NO];
        [_carouselTableView reloadData];
    }
    else{
        NSInteger currentID = visibleSection - 1;
        NSString *carouselId = [[topTitleCarouselArray objectAtIndex:currentID] valueForKey:@"id"];
        //NSMutableDictionary *dictItem = [topTitleCarouselArray objectAtIndex:currentID];
        [_gamesGirdTable setHidden:NO];
        [_carouselTableView setHidden:YES];
        [self loadViewAllData:carouselId];
    }
}
#pragma mark - getOnDemandTopMenuList
-(void)getGamesTopMenuList{
    [COMMON LoadIcon:self.view];
    int nPPV = PAY_MODE_ALL;
    topTitleCarouselArray = [NSMutableArray new];
    topTitleCarouselArray = [[COMMON retrieveContentsFromFile:GAMES_CAROUSEL dataType:DataTypeArray] mutableCopy];
    
    if ([topTitleCarouselArray count] == 0) {
        [[RabbitTVManager sharedManager] getGamesCarouselData:^(AFHTTPRequestOperation *request, id responseObject){
            saveContentsToFile(responseObject, GAMES_CAROUSEL);
            topTitleCarouselArray = [NSMutableArray new];
            topTitleCarouselArray = [responseObject mutableCopy];
            [self addingGames];
            [COMMON removeLoading];
            [_carouselTableView reloadData];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [COMMON removeLoading];
        }nPPV:nPPV ];
        
    }
    else{
        [self addingGames];
        [_carouselTableView reloadData];
        [COMMON removeLoading];
    }
    
    
}
#pragma mark - removalOfExtraArray
-(void)addingGames{
    titleArray = [topTitleCarouselArray  valueForKey:@"name"];
    NSArray *newArray=[[NSArray alloc]initWithObjects:@"Games",nil];
    titleArray = [NSMutableArray arrayWithArray:[newArray arrayByAddingObjectsFromArray:titleArray]];
    
    if([COMMON isSpanishLanguage]==YES){
        NSMutableArray *tempArray = [NSMutableArray new];
        tempArray   = [[COMMON retrieveContentsFromFile:GAMES_TOP_MENU_WORDS dataType:DataTypeArray] mutableCopy];
        if([tempArray count]==0){
            [self getStaticTranslatedWordList:GAMES_TOP_MENU_WORDS currentStaticArray:titleArray];
        }
        else{
            titleArray = tempArray;
        }
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
    titleArray = [[COMMON retrieveContentsFromFile:GAMES_TOP_MENU_WORDS dataType:DataTypeArray] mutableCopy];
    
}
#pragma mark - getMoreDataList
-(void)getMoreDataList{
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getGamesMoreList:^(AFHTTPRequestOperation * request, id responseObject) {
        gamesGridItemsArray = responseObject;
        [_gamesGirdTable setHidden:NO];
        [_carouselTableView setHidden:YES];
        [_gamesGirdTable reloadData];
        [COMMON removeLoading];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
        [_gamesGirdTable setHidden:YES];
        [_carouselTableView setHidden:YES];
    }];
}

#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    NSString *strChannelName;
    NSMutableDictionary *dictItem =  topTitleCarouselArray[section];
   // NSString *carouselId = dictItem[@"id"];
    NSString *strHeaderTitle = dictItem[@"title"];
    NSString *strHeaderName = dictItem[@"name"];
    
    if([strHeaderTitle isEqualToString:@""]||strHeaderTitle==nil||(NSString *)[NSNull null]==strHeaderTitle){
        strHeaderTitle = @"";
    }
    if([strHeaderName isEqualToString:@""]||strHeaderName==nil||(NSString *)[NSNull null]==strHeaderName){
        strHeaderName = @"";
    }
    
    if([strHeaderTitle isEqualToString:@""]){
        strChannelName = strHeaderName;
    }
    else{
        strChannelName = strHeaderTitle;
    }
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[strChannelName dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    strChannelName = [attr string];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,headerView.frame.size.width/2,30)];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = strChannelName;
    
    headerLabel.textColor=[UIColor whiteColor];//BORDER_BLUE;
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    
    UILabel *viewAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-(130),2,130,30)];
    viewAllLabel.textAlignment = NSTextAlignmentLeft;
    NSString *viewAllStr = @"VIEW ALL";
    if([COMMON isSpanishLanguage]==YES){
        viewAllStr = [COMMON getViewAllStr];
        if ((NSString *)[NSNull null] == viewAllStr||viewAllStr == nil) {
            viewAllStr =@"VIEW ALL";
            viewAllStr = [self commanSpanishLanguageConvertion:viewAllStr savingName:VIEW_ALL];
        }
    }
     viewAllLabel.text = viewAllStr;
    viewAllLabel.textColor =[UIColor whiteColor]; //BORDER_BLUE;
    viewAllLabel.backgroundColor = [UIColor clearColor];
    viewAllLabel.tag = section;//[carouselId intValue];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [headerLabel setFont:[COMMON getResizeableFont:Roboto_Regular(17)]];
        [viewAllLabel setFont:[COMMON getResizeableFont:Roboto_Regular(17)]];
        
    }
    else{
        [headerLabel setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
        [viewAllLabel setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
        
    }
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gamesViewallAction:)];
    tapGesture2.delegate=self;
    tapGesture2.numberOfTapsRequired = 1;
    [viewAllLabel addGestureRecognizer:tapGesture2];
    [viewAllLabel setUserInteractionEnabled:YES];
    [headerView addSubview:viewAllLabel];
    [headerView setUserInteractionEnabled:YES];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([topTitleCarouselArray count]!=0){
        return topTitleCarouselArray.count;
    }
    else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 195.0;//170//160
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nCount = 0;
    nCount = 1;
    return nCount;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",(long)indexPath.section];
    NKContainerCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *BlockData;
    if (nil == cell) {

        cell = [[NKContainerCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appManagerStr :@"NO"];
        
        NSDictionary *cellData = [topTitleCarouselArray objectAtIndex:[indexPath section]] ;
        BlockData = [cellData objectForKey:@"items"];
        
        [cell setCollectionImageData:BlockData currentViewStr:@"GamesView"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
    
    
}
#pragma mark - gamesViewallAction
-(void)gamesViewallAction:(UITapGestureRecognizer *)tap {
    UILabel *currentLabel   = (UILabel *) tap.view;
    NSInteger selectedIndex = currentLabel.tag;
    
    NSMutableDictionary *dictItem =  topTitleCarouselArray[selectedIndex];
    NSString *carouselId = dictItem[@"id"];
    //NSString *strHeaderTitle = dictItem[@"title"];
    NSMutableArray *itemsArray = dictItem[@"items"];
    NSString *type;
    if([itemsArray count]!=0){
        type = [[itemsArray objectAtIndex:0]valueForKey:@"type"];
    }
    if ((NSString *)[NSNull null] == type||type == nil) {
        type=@"";
    }
    
    NSMutableDictionary *viewAllData = [NSMutableDictionary new];
    // NSString *carouselId = [NSString stringWithFormat:@"%ld",(long)selectedIndex];
    [viewAllData setValue:carouselId forKey:@"carouselId"];
    [viewAllData setValue:type forKey:@"type"];
    
    [self loadViewAllData:carouselId];
    
}
#pragma mark - loadViewAllData
-(void) loadViewAllData:(NSString*)carouselId{
    int nPPV = PAY_MODE_ALL;
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]getWholeViewAll:^(AFHTTPRequestOperation * request, id responseObject) {
        gamesGridItemsArray = responseObject;
        [_gamesGirdTable setHidden:NO];
        [_carouselTableView setHidden:YES];
        [_gamesGirdTable reloadData];
        [COMMON removeLoading];
    }failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
        [_gamesGirdTable setHidden:YES];
        [_carouselTableView setHidden:YES];
    } nID:[carouselId intValue] nPPV:nPPV];

}

#pragma mark - UIGridView Delegate

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return nGamesCellWidth;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 200;
    }
    else{
        return 195;
    }
}
- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;
    
    if([gamesGridItemsArray count]!=0){
        
        nCount = nGamesColumCount;
    }
    else{
        nCount = 1;
    }
    return nCount;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return gamesGridItemsArray.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    SubscriptionCell* cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[SubscriptionCell alloc] init];
    }
    
    int nIndex = rowIndex;
    nIndex= rowIndex * nGamesColumCount + columnIndex;
    NSDictionary* dictItem = gamesGridItemsArray[nIndex];
    NSString* strPosterUrl;
    NSString* strName;
    if(isMoreView==YES){
         strPosterUrl = dictItem[@"image"];
    }
    else{
         strPosterUrl = dictItem[@"carousel_image"];
    }
    strName = dictItem[@"name"];
   
    
    if ((NSString *)[NSNull null] == strName||strName == nil) {
        strName=@"";
    }
    if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl == nil) {
        strPosterUrl=@"";
    }
    
    AsyncImage * asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, cell.thumbnail.frame.size.width-10, cell.thumbnail.frame.size.height-10)];
    [asyncImage setLoadingImage];
    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                            type:AsyncImageResizeTypeCrop
                         isCache:YES];
  //  NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
    
    [cell.bgView setHidden:YES];
    [cell.thumbnail setHidden:NO];
    [cell.kidsThumbnail setHidden:YES];
    //[cell.thumbnail setImageWithURL:imageUrl];
    [cell.thumbnail addSubview:asyncImage];
    [cell.label setTextAlignment:NSTextAlignmentCenter];
    [cell.label setText:strName];
    [cell.label setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    [self.gamesGirdTable setContentInset:UIEdgeInsetsMake(0,0,50,0)];
    return cell;
}
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    NSLog(@"%d, %d clicked", rowIndex, colIndex);
    int nIndex = rowIndex;
    nIndex= rowIndex * nGamesColumCount + colIndex;
    NSDictionary* dictItem = gamesGridItemsArray[nIndex];
    NSString* strAppLink;

    
    if(isMoreView==YES){
        strAppLink = dictItem[@"url"];
        if ((NSString *)[NSNull null] == strAppLink || strAppLink == nil) {
            strAppLink=@"";
        }
        NSURL* linkUrl = [NSURL URLWithString:strAppLink];
        [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
    }
    else{
        NSString *gameType = [NSString stringWithFormat:@"%@",[dictItem valueForKey:@"type"]];
        NSString *gameId = [NSString stringWithFormat:@"%@",[dictItem valueForKey:@"id"]];
        if([gameType isEqualToString:@"G"]){
            [self loadGamesDetailsUsingID:gameId];
        }
   }
    
}
#pragma mark - loadApplicationPAge
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
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
-(void) didSelectItemFromCollectionViewForGamesView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    NSString *gameType = [NSString stringWithFormat:@"%@",[cellData valueForKey:@"type"]];
    NSString *gameId = [NSString stringWithFormat:@"%@",[cellData valueForKey:@"id"]];
    if([gameType isEqualToString:@"G"]){
      [self loadGamesDetailsUsingID:gameId];  
    }
    
        
  //  NSString *url = [NSString stringWithFormat:@"%@://app/",currentAppName];
  //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    
}


-(void) sliderViewAllOptionGames:(NSNotification *)notification
{
    //NSDictionary *cellData = [notification object];
}
-(void)loadGamesDetailsUsingID:(NSString*)gamesId{
    
    [[RabbitTVManager sharedManager]cancelRequest];
    
    [[RabbitTVManager sharedManager]getGamesDetailWithID:^(AFHTTPRequestOperation *request, id responseObject) {
        
        NSLog(@"responseObject%@-->",responseObject);
        
        NSString * strAppLink = responseObject[@"url"];
        if ((NSString *)[NSNull null] == strAppLink || strAppLink == nil) {
            strAppLink=@"";
        }
        NSURL* linkUrl = [NSURL URLWithString:strAppLink];
        [self application:[UIApplication sharedApplication] handleOpenURL:linkUrl];
        [COMMON removeLoading];
    } failureBlock:^(AFHTTPRequestOperation *request,NSError *error) {
        [COMMON removeLoading];
    } nID:[gamesId intValue]];
    
    
}

#pragma mark - orientationChanged
-(void) gamesViewOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            //   case UIDeviceOrientationPortraitUpsideDown:
            [self gamesRotateViews:true];
            
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self gamesRotateViews:false];
            
            break;
            
        default:
            break;
    }
}
#pragma mark - (myView.frame.size.width)-(myImageViewXpos*2)
-(void)gamesRotateViews:(BOOL) bPortrait{
    
    if(bPortrait){
        nGamesColumCount = 2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nGamesColumCount = 3;
            
        }
        nGamesCellWidth = SCREEN_WIDTH / nGamesColumCount;
        nGamesCellHeight = SCREEN_HEIGHT / nGamesColumCount;
        
    }
    
    else{
        nGamesColumCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nGamesColumCount = 4;
            
        }
        nGamesCellWidth = SCREEN_WIDTH / nGamesColumCount;
        nGamesCellHeight = SCREEN_HEIGHT / nGamesColumCount;
    }
    if(isMoreView==YES){
        [_gamesGirdTable setTranslatesAutoresizingMaskIntoConstraints:YES];
        [_topSegmentView removeFromSuperview];
        [_carouselTableView removeFromSuperview];
        [_gamesGirdTable setHidden:NO];
        CGRect gamesGridTableFrame = _gamesGirdTable.frame;
        gamesGridTableFrame.origin.x=0;
        gamesGridTableFrame.origin.y=20;
        gamesGridTableFrame.size.width=SCREEN_WIDTH;
        gamesGridTableFrame.size.height=SCREEN_HEIGHT-20;
        [_gamesGirdTable setFrame:gamesGridTableFrame];
        [_gamesGirdTable reloadData];
        
    }
    else{
        [self setScrollHeader];
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
