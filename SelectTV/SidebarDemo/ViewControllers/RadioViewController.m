//
//  RadioViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "RadioViewController.h"
#import "AppDelegate.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "RabbitTVManager.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewController.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "UIGridView.h"
#import "RadioGenreTableViewCell.h"
#import "AsyncImage.h"
#import "RadioListByGenreCell.h"
#import "RadioListByGenreGridCell.h"
#import "NSString+FontAwesome.h"
#import <AVFoundation/AVFoundation.h>
#import "SearchViewController.h"



@interface RadioViewController ()<AVAudioPlayerDelegate,UIWebViewDelegate,UISearchBarDelegate>
{
    
    CGFloat descHeight;
    CGFloat scrollButtonWidth;
    UILabel *indicateLabel;
    BOOL isScrolled;
    
    NSInteger visibleSection;
    NSMutableArray *radioTabArray;
    NSMutableArray *radioCommonArray;
    NSMutableArray *radioGenreArray;
    NSMutableArray *radioLanguageArray;
    NSMutableArray *radioContinentArray;
    NSMutableArray *radioListArray;
    NSMutableArray *radioFirstCountryArray;
    NSMutableArray *radioFirstCityOrRegionArray;
    NSMutableArray *radioByLocNameCityRegionArray;
    NSMutableArray *radioFirstCityRegionArray;
    
    NSMutableArray *radioGenreCacheArray;
    NSMutableArray *radioLanguageCacheArray;
    NSMutableArray *radioLocationCacheArray;
    
    NSMutableArray *sortedArray;

   
    AsyncImage *asyncImage;
    NSString* strID;
    BOOL radioFirstTime;
    BOOL isRadioGenre;
    BOOL isRadioLocation;
    BOOL isRadioLanguage;
    BOOL isRadioByListGenre;
    BOOL isLocationCity;
    BOOL getListByLocation;
    BOOL playing;
    BOOL isFirstTime;
    BOOL isHasCitiesInt;
    NSString *listTitle;
    NSString *listCountryName;
    NSString *playerUrl;
    NSString *strCountryID;
    NSString *tableTagStr;
    
    

    NSString *hasContinent;
    NSString *hasCityOneRegionZero_One;
    NSString *hasCityZeroRegionZero;
    NSString *hasCityAlone;
    NSString *hasCityAloneFalse;
    BOOL    isCityAlone;
    
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
    NSDictionary *currentSelectedDictItem;
    
    BOOL isTableDidSelected;
    UIButton *titleButton;
    BOOL isRadioGridSelected;
    UILabel *currentSelectTitle;
    NSString * currentAppLanguage;

    
}

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation RadioViewController
@synthesize showHeaderView,audioPlayer;

int nRadioColumn=3;
int nRadioWidth=107;
int nRadioHeight=160;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    SWRevealViewController *revealviewcontroller = self.revealViewController;
    
    if(revealviewcontroller)
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
    isRadioGenre =false;
    isRadioLanguage = false;
    isRadioLocation = false;
    isRadioByListGenre=false;
    isLocationCity=false;
    getListByLocation =false;
    isFirstTime = false;
    [_radioHeaderView setHidden:YES];
    [_radioDetailView setHidden:YES];
    
    radioGenreArray= [[NSMutableArray alloc]init];
    radioCommonArray= [[NSMutableArray alloc]init];
    radioFirstCityOrRegionArray= [[NSMutableArray alloc]init];
    radioFirstCountryArray= [[NSMutableArray alloc]init];
   
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr = @"Radio";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
    self.navigationItem.title = titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }

    
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRadioTopTitle:) name:@"tableRadioScrolled" object:nil];
    
    isRadioGridSelected=NO;
    [self getRadioData];
    [self setTitleScrollBarRadio];
    [_tableRadio reloadData];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    self.view.backgroundColor = GRAY_BG_COLOR;
    
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"Search_Image"] forState:UIControlStateHighlighted];
    isRadioGridSelected=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [radio updatePlay:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [radio updatePlay:NO];
    
}

#pragma mark - setUpSearchBarInNavigation
-(void) setUpSearchBarInNavigation{
    searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(5, -5, self.view.frame.size.width-10, 48)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBarView setShowsCancelButton:YES];
    searchBarView.delegate = self;
    [searchBarView setTintColor:[UIColor whiteColor]];
    searchBarView.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:103.0f/255.0f blue:183.0f/255.0f alpha:1];
     searchTextField.backgroundColor = GRAY_BG_COLOR;
    searchBarView.autocorrectionType = UITextAutocorrectionTypeNo;
    for (id subView in ((UIView *)[searchBarView.subviews objectAtIndex:0]).subviews) {
        //UITextField *searchTextField;
        if ([subView isKindOfClass:[UITextField class]]) {
            searchTextField = subView;
            searchTextField.keyboardAppearance = UIKeyboardAppearanceLight;
            //[searchTextField setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:116.0f/255.0f blue:203.0f/255.0f alpha:1]];
            // searchTextField.backgroundColor = GRAY_BG_COLOR;
           // searchTextField.textColor =[UIColor whiteColor];
            searchTextField.textColor =[UIColor whiteColor];
            searchTextField.backgroundColor = [COMMON Common_Screen_BG_Color];
            UIColor *color = [UIColor whiteColor];
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
#pragma mark - Radio Data
- (void) getRadioData{
    
    [self.radioActivityIndicator setHidden:false];

    radioGenreCacheArray = [[COMMON retrieveContentsFromFile:RADIO_GENRES dataType:DataTypeArray] mutableCopy];
    
    if (radioGenreCacheArray == NULL) {
        [[RabbitTVManager sharedManager] getRadioGenre:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setGenre];
        }];
    } else {
        [self sortingArray:radioGenreCacheArray];
        [self setGenre];
    }
    
    radioLanguageCacheArray = [[COMMON retrieveContentsFromFile:RADIO_LANGUAGES dataType:DataTypeArray] mutableCopy];
    
    if (radioLanguageCacheArray == NULL) {
        [[RabbitTVManager sharedManager] getRadioLanguage:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setLanguage];
        }];
    } else {
        [self sortingArray:radioLanguageCacheArray];
        [self setLanguage];
    }
    
    radioLocationCacheArray = [[COMMON retrieveContentsFromFile:RADIO_CONTINENTS dataType:DataTypeArray] mutableCopy];
    
    if (radioLocationCacheArray == NULL) {
        [[RabbitTVManager sharedManager] getRadioContinent:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setLocation];
        }];
    } else {
        [self sortingArray:radioLocationCacheArray];
        [self setLocation];
    }

    
}
-(void) sortingArray:(NSMutableArray *)responseObject{
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    sortedArray=(NSMutableArray *)[responseObject sortedArrayUsingDescriptors:descriptors];
    
}
-(void) setGenre{
    
    radioCommonArray    = sortedArray;
    radioGenreArray     = sortedArray;
    isRadioGenre        =true;
    isRadioLocation     =false;
    isRadioLanguage     =false;
    isLocationCity      =false;
    getListByLocation   =false;
    _tableRadio.tag     =100;
    tableTagStr =@"100";
    [_tableRadio reloadData];
    [self.radioActivityIndicator setHidden:true];

    
}
-(void) setLanguage{
    radioLanguageArray =sortedArray;
    [self.radioActivityIndicator setHidden:true];
    
}
-(void) setLocation{
    radioContinentArray =sortedArray;
    [self.radioActivityIndicator setHidden:true];

    
}
#pragma mark - setTitleScrollBarRadio

-(void)setTitleScrollBarRadio
{
    float commonWidth ;//= self.view.frame.size.width;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        commonWidth = self.view.frame.size.width;
    }
    else{
        commonWidth = self.view.frame.size.width;
    }
    showHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, commonWidth, 44)];
   
   // [showHeaderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]]];
    
    showHeaderView.backgroundColor = GRAY_BG_COLOR;
    
    [currentSelectTitle removeFromSuperview];
    currentSelectTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
    [showHeaderView addSubview:currentSelectTitle];
    NSString *buttonTitle = @"Genre";
    if([COMMON isSpanishLanguage]==YES){
        buttonTitle = [COMMON getFreeStr];
        if ((NSString *)[NSNull null] == buttonTitle||buttonTitle == nil) {
            buttonTitle = @"Genre";
            buttonTitle =  [COMMON stringTranslatingIntoSpanish:buttonTitle];
            [[NSUserDefaults standardUserDefaults] setObject:buttonTitle forKey:GENRE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
   // currentSelectTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]];
    currentSelectTitle.backgroundColor = GRAY_BG_COLOR;
    currentSelectTitle.text = buttonTitle;
    currentSelectTitle.textColor = [UIColor whiteColor];
    currentSelectTitle.textAlignment = NSTextAlignmentCenter ;
    [currentSelectTitle setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
  
    radioTabArray = [NSMutableArray arrayWithObjects:buttonTitle,nil];
//   // radioTabArray = [NSMutableArray arrayWithObjects:@"Genre",@"Language",@"Location",nil];
//    radioTabArray = [NSMutableArray arrayWithObjects:@"Genre",nil];
//    
//    for(int i = 0; i < [radioTabArray count]; i++)
//    {
//        NSString *buttonTitle = [radioTabArray objectAtIndex:i];
//        
//        
//        UIView *backgroundView ;
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            backgroundView = [[UIView alloc]initWithFrame:CGRectMake((commonWidth/3)*i, 0, commonWidth / 3, showHeaderView.frame.size.height)];
//        }
//        else{
//            backgroundView = [[UIView alloc]initWithFrame:CGRectMake((commonWidth/3)*i, 0, commonWidth / 3, showHeaderView.frame.size.height)];
//            
//        }
//        
//        [backgroundView setTag:i + 100];
//        
//        [showHeaderView addSubview:backgroundView];
//        //UIButton *titleButton;
//        
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            scrollButtonWidth = backgroundView.frame.size.width;
//            titleButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, (backgroundView.frame.size.width)-15, showHeaderView.frame.size.height - 3)];
//        }
//        else{
//            scrollButtonWidth = backgroundView.frame.size.width-10;
//            
//            titleButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, backgroundView.frame.size.width - 15, showHeaderView.frame.size.height - 3)];
//            
//        }
//        [titleButton setTitle:buttonTitle forState:UIControlStateNormal];
//        [titleButton setTag:i];
//        
//        titleButton.titleLabel.numberOfLines = 3;
//        if(i == visibleSection)
//        {
//            titleButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
//            [titleButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//        }
//        else
//        {
//            titleButton.titleLabel.font =[COMMON getResizeableFont:Roboto_Bold(14)];
//            [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [titleButton addTarget:self action:@selector(pressRadioTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [backgroundView addSubview:titleButton];
//        if(i == visibleSection)
//        {
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                indicateLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, backgroundView.frame.size.height - 3, backgroundView.frame.size.width-35, 3)];
//            }
//            else{
//                indicateLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, backgroundView.frame.size.height - 3, backgroundView.frame.size.width-15, 3)];
//            }
//            
//            [indicateLabel setBackgroundColor:[UIColor whiteColor]];
//           // [backgroundView addSubview:indicateLabel];
//        }
//        if(isRadioGridSelected!=YES){
//            if(i == visibleSection)
//            {
//                [self setUpMenuVisibleSection];
//            }
//        }
//        
//    }
    [self setUpMenuVisibleSection];
    [self.view addSubview:showHeaderView];
    
}
#pragma mark - setUpMenuVisibleSection
-(void)setUpMenuVisibleSection{
    if(radioCommonArray==nil){
        [self getRadioData];
    }
    else{
        [_tableRadio reloadData];
        _tableRadio.tag =100;
        
        //HIDDEN LOCATION AND LANGUAGE
        
//        NSString *inStr = [NSString string    WithFormat: @"%ld", (long)visibleSection];
//        if(![inStr isEqualToString:@""]){
//            NSString *buttonTitle = [radioTabArray objectAtIndex:visibleSection];
//            if([buttonTitle isEqualToString:@"Location"]){
//                NSInteger tagTable = [tableTagStr intValue];
//                _tableRadio.tag = tagTable;
//                [_tableRadio reloadData];
//            }
//            else{
//                [_tableRadio reloadData];
//            }
//        }
//        else{
//            [_tableRadio reloadData];
//            _tableRadio.tag =100;
//        }
    }

}
#pragma mark - pressRadioTitleBtn
- (void)pressRadioTitleBtn:(UIButton *)sender
{
    [self removeRadioLoadingIcon];
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];

    isScrolled=NO;
    visibleSection = sender.tag;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tableRadioScrolled" object:showHeaderView];
    
    strID = radioTabArray[visibleSection];
    
    if([strID isEqualToString:@"Genre"]){
        radioCommonArray=radioGenreArray;
        isRadioGenre =true;
        isRadioLocation =false;
        isRadioLanguage =false;
        isLocationCity=false;
        getListByLocation =false;
        [_tableRadio setHidden:NO];
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_radioDetailView setHidden:YES];
        [_radioHeaderView setHidden:YES];
       tableTagStr =@"100";
        _tableRadio.tag =100;
        [_tableRadio reloadData];
        
    }
    else if ([strID isEqualToString:@"Language"]){
        radioCommonArray=radioLanguageArray;
        isRadioGenre =false;
        isRadioLocation =false;
        isRadioLanguage =true;
        isLocationCity=false;
        getListByLocation =false;
        [_tableRadio setHidden:NO];
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_radioDetailView setHidden:YES];
        [_radioHeaderView setHidden:YES];
       tableTagStr =@"100";
        _tableRadio.tag =100;
        [_tableRadio reloadData];
 
    }
    else if ([strID isEqualToString:@"Location"]){
        radioCommonArray=radioContinentArray;
        isRadioGenre =false;
        isRadioLanguage =false;
        isRadioLocation =true;
        isLocationCity=false;
        getListByLocation =false;
        [_tableRadio setHidden:NO];
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_radioDetailView setHidden:YES];
        [_radioHeaderView setHidden:YES];
        tableTagStr =@"100";
        _tableRadio.tag =100;
        [_tableRadio reloadData];
       
    }
    [_tableRadio scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableRadio scrollToRowAtIndexPath:indexPath
//                             atScrollPosition:UITableViewScrollPositionTop
//                                     animated:YES];

    
}
- (void)clickRadioTopTitle:(NSNotification *)notification
{
    UIView *scrollView = notification.object;
    CGFloat buttonWidth ;//= scrollView.frame.size.width / 3;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        buttonWidth = scrollView.frame.size.width / 3;
    }
    else{
        buttonWidth = scrollView.frame.size.width / 3;
        
    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
         indicateLabel.frame = CGRectMake(visibleSection * buttonWidth+5, scrollView.frame.size.height - 3, scrollButtonWidth-20, 3);
    }
    else{
         indicateLabel.frame = CGRectMake(visibleSection * buttonWidth+5, scrollView.frame.size.height - 3, scrollButtonWidth-10, 3);
    }    
    for(UIView *backView in [scrollView subviews])
    {
        if(backView.tag == visibleSection + 100){
            for(UIButton *button in [backView subviews]){
                if(![button isKindOfClass:[UIImageView class]] && ![button isKindOfClass:[UILabel class]]){
                    button.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
                    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
                }
            }
        }
        else{
            for(UIButton *button in [backView subviews]){
                if(![button isKindOfClass:[UIImageView class]] && ![button isKindOfClass:[UILabel class]]){
                    if([button.titleLabel.text isEqualToString:@"Genre"])
                        button.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
                    
                    else
                        button.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }
    }
}


- (void)tableFilter:(NSNotification *)notification
{
    UIButton *button = [[UIButton alloc]init];
    button.tag = [[NSString stringWithFormat:@"%@",notification.object] integerValue] + 1;
    [self pressRadioTitleBtn:button];
}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}


#pragma mark UIGRID

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return nRadioWidth;
    
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    //return nCellHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if(isRadioLocation==true){
            return 120;
        }
        else{
            return 160;
            
        }
        
    }
    else{
        if(isRadioLocation==true){
            return 120;
        }
        else{
            return 160;
        }
    }
    
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return nRadioColumn;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return [radioCommonArray count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
    RadioGenreTableViewCell* cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[RadioGenreTableViewCell alloc] init];
    }
    if(_tableRadio.tag==101){
        int nIndex = rowIndex * nRadioColumn + columnIndex;
        NSDictionary* dictItem = radioCommonArray[nIndex];
        NSString* strName = dictItem[@"name"];
        [cell.radioGenreImage setHidden:YES];
        [cell.radioGenreLabel setHidden:YES];
        [cell.radioLocationLabel setHidden:NO];
        [cell.radioLocationLabel setText:strName];
    }
    else if(_tableRadio.tag==102){
        int nIndex = rowIndex * nRadioColumn + columnIndex;
        NSDictionary* dictItem = radioCommonArray[nIndex];
        NSString* strName = dictItem[@"name"];
        [cell.radioGenreImage setHidden:YES];
        [cell.radioGenreLabel setHidden:YES];
        [cell.radioLocationLabel setHidden:NO];
        [cell.radioLocationLabel setText:strName];
   }
    else if(_tableRadio.tag==103){
        int nIndex = rowIndex * nRadioColumn + columnIndex;
        NSDictionary* dictItem = radioCommonArray[nIndex];
        NSString* strName = dictItem[@"name"];
        [cell.radioGenreImage setHidden:YES];
        [cell.radioGenreLabel setHidden:YES];
        [cell.radioLocationLabel setHidden:NO];
        [cell.radioLocationLabel setText:strName];
                
    }
    else if(_tableRadio.tag ==100){
        int nIndex = rowIndex * nRadioColumn + columnIndex;
        NSDictionary* dictItem = radioCommonArray[nIndex];
        NSString* strPosterUrl = dictItem[@"image"];
        NSString* strName = dictItem[@"name"];
        //NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
        asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(cell.radioGenreImage.frame.origin.x+1, 0, cell.radioGenreImage.frame.size.width-15, cell.radioGenreImage.frame.size.height)];
        
        [asyncImage setLoadingImage];
        [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                                type:AsyncImageResizeTypeAspectRatio
                             isCache:YES];
        asyncImage.layer.cornerRadius = 15.0;
        asyncImage.layer.masksToBounds = YES;
       
        if(isRadioGenre ==true){
            [cell.radioGenreImage addSubview:asyncImage];
            [cell.radioGenreLabel setText:strName];
            [cell.radioGenreImage setHidden:NO];
            [cell.radioGenreLabel setHidden:NO];
            [cell.radioLocationLabel setHidden:YES];
        
        }
        else if(isRadioLanguage==true){
            [cell.radioGenreImage addSubview:asyncImage];
            [cell.radioGenreLabel setText:strName];
            [cell.radioGenreImage setHidden:NO];
            [cell.radioGenreLabel setHidden:NO];
            [cell.radioLocationLabel setHidden:YES];
           
        }
        else if(isRadioLocation== true){
            [cell.radioGenreImage setHidden:YES];
            [cell.radioGenreLabel setHidden:YES];
            [cell.radioLocationLabel setHidden:NO];
            [cell.radioLocationLabel setText:strName];
            [_radioHeaderView setHidden:YES];
           
        }

    }

    cell.backgroundColor =[UIColor clearColor];
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    isRadioGridSelected=YES;
//    for (UIView *subview in showHeaderView.subviews) {
//        [subview removeFromSuperview];
//    }
//    
//    currentSelectTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
//    [showHeaderView addSubview:currentSelectTitle];
//    NSString *buttonTitle = [radioTabArray objectAtIndex:visibleSection];
//    currentSelectTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]];
//    currentSelectTitle.text = buttonTitle;
//    currentSelectTitle.textColor = [UIColor whiteColor];
//    currentSelectTitle.textAlignment = NSTextAlignmentCenter ;
//    [currentSelectTitle setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
   
    
    [self.radioActivityIndicator setHidden:false];
    int nIndex = rowIndex * nRadioColumn + colIndex;
    NSDictionary* dictItem = radioCommonArray[nIndex];
    NSString* radioName;
    radioName= dictItem[@"name"];
    NSString* radioId = dictItem[@"id"];
    NSString* hasCities = dictItem[@"has_cities"];
    NSString* hasRegions = dictItem[@"has_regions"];
    NSString* regionID = dictItem[@"region_id"];
    int hasCitiesInt = [hasCities intValue];
    int hasRegionsInt = [hasRegions intValue];
    if(hasRegionsInt == 1 && hasCitiesInt == 1){
            strCountryID = dictItem[@"id"];
    }
    if ((NSString *)[NSNull null] == regionID) {
        strCountryID=@"";
    } else {
        if(hasRegionsInt == 1 && hasCitiesInt == 1){
            strCountryID = dictItem[@"id"];
        }
    }
    listTitle = dictItem[@"name"];
    if(isRadioGenre ==true){
        [[RabbitTVManager sharedManager] getRadioListByGenre:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setRadioListByGenre];
            [self.radioActivityIndicator setHidden:true];
            
        } nGenreID:[radioId intValue]];
    }
    else if(isRadioLanguage==true){
        [[RabbitTVManager sharedManager] getRadioListByLanguage:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setRadioListByLanguage];
            [self.radioActivityIndicator setHidden:true];
            
        } nLanguageID:[radioId intValue]];
        
    }
    else if(isRadioLocation== true){
        if(isLocationCity== true){
            if(hasCitiesInt == 1 && hasRegionsInt == 0){
                [[RabbitTVManager sharedManager] getRadioCities:^(AFHTTPRequestOperation * operation, id responseObject) {
                    [self sortingArray:responseObject];
                    [self setRadioCities];
                    hasCityOneRegionZero_One= dictItem[@"name"];
                    [self.radioActivityIndicator setHidden:true];
                
                } nCountryID:[radioId intValue]];

            }
            if(hasRegionsInt == 1 && hasCitiesInt == 1){
                 [[RabbitTVManager sharedManager] getRadioRegions:^(AFHTTPRequestOperation * operation, id responseObject) {
                     [self sortingArray:responseObject];
                     [self setRadioRegions];
                     hasCityOneRegionZero_One= dictItem[@"name"];
                     [self.radioActivityIndicator setHidden:true];
                    
                } nCountryID:[radioId intValue]];
                
            }
            else if(hasCitiesInt == 0 && hasRegionsInt == 0){
                hasCityZeroRegionZero= dictItem[@"name"];
                [self setNoCities];
                [self.radioActivityIndicator setHidden:true];
            }
            
        }
        else if(getListByLocation ==true){
            
            if(hasCitiesInt == 1){
               
                [[RabbitTVManager sharedManager] getRadioCitiesRegion:^(AFHTTPRequestOperation * operation, id responseObject) {
                    [self sortingArray:responseObject];
                    [self setRadioCitiesRegion];
                    hasCityAlone= dictItem[@"name"];
                    [self.radioActivityIndicator setHidden:true];
                    
                } nRegionID:[radioId intValue]];
                
            }
            else{
                [[RabbitTVManager sharedManager] getListByLocationCountryCity:^(AFHTTPRequestOperation * operation, id responseObject)  {
                    [self sortingArray:responseObject];
                    [self setListByLocationCountryCity];
                    hasCityAloneFalse= dictItem[@"name"];
                    [self.radioActivityIndicator setHidden:true];
                } nCountryID:[strCountryID intValue] nCityID:[radioId intValue]];
            }
        }
        else{
            
            [[RabbitTVManager sharedManager] getRadioCountries:^(AFHTTPRequestOperation * operation, id responseObject) {
            [self sortingArray:responseObject];
            [self setRadioCountries];
            hasContinent= dictItem[@"name"];
            [self.radioActivityIndicator setHidden:true];
            } nContinentID:[radioId intValue]];
        }
    }
    
}
#pragma mark - Radio Location Setting
-(void)setRadioListByGenre{
    radioListArray= sortedArray;
    isRadioByListGenre=true;
    [_radioByListView setHidden:NO];
    [_radioByListTable setHidden:NO];
    [_tableRadio setHidden:YES];
    [_radioDetailView setHidden:YES];
    _radioByListTable.tag = 100;
    [_radioByListTable reloadData];
    [self.radioActivityIndicator setHidden:true];
    
}
-(void)setRadioListByLanguage{
    radioListArray=sortedArray;
    isRadioByListGenre=true;
    [_radioByListView setHidden:NO];
    [_radioByListTable setHidden:NO];
    [_tableRadio setHidden:YES];
    _radioByListTable.tag = 100;
    [_radioByListTable reloadData];
    [self.radioActivityIndicator setHidden:true];
}
-(void)setRadioCities{
    radioCommonArray=sortedArray;
    isCityAlone = false;
    radioFirstCityOrRegionArray = radioCommonArray;
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:NO];
    _tableRadio.tag = 102;
    tableTagStr =@"102";
    [_tableRadio reloadData];
    isHasCitiesInt=false;
    isLocationCity =false;
    getListByLocation = true;
    
}
-(void)setRadioRegions{
    radioCommonArray=sortedArray;
    radioFirstCityOrRegionArray = radioCommonArray;
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:NO];
    _tableRadio.tag = 102;
    tableTagStr =@"102";
    [_tableRadio reloadData];
    isHasCitiesInt=false;
    isLocationCity =false;
    getListByLocation = true;
}
-(void)setNoCities{
    UIAlertView* alertView =[[UIAlertView alloc] init];
    [alertView setTitle:@"NO CITIES AND REGIONS"];
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
    isHasCitiesInt=false;
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:NO];
    _tableRadio.tag = 101;
    tableTagStr =@"101";
    [_tableRadio reloadData];
    getListByLocation =false;
    isLocationCity =true;

}
-(void)setRadioCitiesRegion{
    radioCommonArray=sortedArray;
    isCityAlone =true;
    radioFirstCityRegionArray = radioCommonArray;
    isHasCitiesInt=true;
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:NO];
    _tableRadio.tag = 103;
    tableTagStr =@"103";
    [_tableRadio reloadData];
    isLocationCity =false;
    getListByLocation = true;
}
-(void)setListByLocationCountryCity{
    radioListArray=sortedArray;
    radioByLocNameCityRegionArray =radioListArray;
    isRadioByListGenre=true;
    [_radioByListView setHidden:NO];
    if([radioListArray count]==0){
        _radioByListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        _radioByListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [_tableRadio setHidden:YES];
    [_radioByListTable setHidden:NO];
    [_radioHeaderView setHidden:YES];
    _radioByListTable.tag = 100;
    [_radioByListTable reloadData];
    isLocationCity =false;
}
-(void)setRadioCountries{
    radioCommonArray=sortedArray;
    radioFirstCountryArray =radioCommonArray;
    isRadioByListGenre=true;
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:NO];
    [_radioHeaderView setHidden:NO];
    [self setHeaderViewCountry];
    _tableRadio.tag = 101;
    tableTagStr =@"101";
    [_tableRadio reloadData];
    getListByLocation =false;
    isLocationCity =true;
}

#pragma mark - setHeadetViewCountry
-(void) setHeaderViewCountry{
    
    if(listTitle == nil){
        listTitle= @"Title";
    }
    _radioHeaderLabel.text = listTitle;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerBtn:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_radioHeaderLabel addGestureRecognizer:tapGestureRecognizer];
    _radioHeaderLabel.userInteractionEnabled = YES;
    [_radioHeaderLabel setTextColor :[UIColor whiteColor]];
    //[_radioHeaderBackBtn setBackgroundImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [_radioHeaderBackBtn addTarget:self action:@selector(countryBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)countryBackBtn:(id)sender{
    
    if(_tableRadio.tag ==101){
        radioCommonArray = radioContinentArray;
        isRadioGenre =false;
        isRadioLanguage =false;
        isRadioLocation =true;
        isLocationCity=false;
        getListByLocation =false;
        [_tableRadio setHidden:NO];
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_radioDetailView setHidden:YES];
        [_radioHeaderView setHidden:YES];
        [_tableRadio setHidden:NO];
        _tableRadio.tag =100;
        tableTagStr =@"100";
        [_tableRadio reloadData];
//        if(isRadioGridSelected==YES){
//            [self setTitleScrollBarRadio];
//            isRadioGridSelected=NO;
//        }
        
    }
    if(_tableRadio.tag ==102){
        radioCommonArray = radioFirstCountryArray;
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_tableRadio setHidden:NO];
        _tableRadio.tag =101;
        tableTagStr =@"101";
        isRadioGenre =false;
        isRadioLanguage =false;
        isRadioLocation =true;
        getListByLocation =false;
        isLocationCity =true;
        [_tableRadio reloadData];
        
    }
    if(_tableRadio.tag ==103){
       
        if(isHasCitiesInt ==true){
            isHasCitiesInt =true;
            isRadioLocation=true;
            isLocationCity=false;
            getListByLocation =true;
            radioCommonArray = radioFirstCityOrRegionArray;


        }
        else{
             radioCommonArray = radioFirstCityOrRegionArray;
            isLocationCity =true;
            getListByLocation = true;
            
        }
        isRadioGenre =false;
        isRadioLanguage =false;
        isRadioLocation =true;
        [_radioByListView setHidden:YES];
        [_radioByListTable setHidden:YES];
        [_tableRadio setHidden:NO];
        
        _tableRadio.tag =102;
        tableTagStr =@"102";
        [_tableRadio reloadData];
        
    }
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 30.0;


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, screenWidth-30, 30)];
    if(listTitle == nil){
        listTitle= @"Title";
    }
    label.text = listTitle;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerBtn:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [label addGestureRecognizer:tapGestureRecognizer];
    label.userInteractionEnabled = YES;

    [label setTextColor :[UIColor whiteColor]];
    //[label setBackgroundColor :[UIColor redColor]];
    //[view setBackgroundColor:[UIColor colorWithRed:24.0/255.0f green:25.0/255.0f blue:28.0/255.0f alpha:1]];
    if(listTitle == nil){
        [view setBackgroundColor :[UIColor colorWithRed:1.0/255.0f green:83.0/255.0f blue:137.0/255.0f alpha:1]];
    }
    else{
            [view setBackgroundColor :[UIColor clearColor]];
       }
    [view addSubview:label];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(5, -2, 30, 40)];
    [button setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(headerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    if(isFirstTime == true){
        
        [label setHidden:NO];
        [button setHidden:NO];
        
    }
    else{
        [label setHidden:YES];
        [button setHidden:YES];
        isFirstTime = true;
        
    }
    return view;
}

-(void)headerBtn:(id)sender{
    
    if(_radioByListTable.tag ==100){
        if(isRadioLocation==true){
            
            if(isHasCitiesInt ==true){
                isHasCitiesInt =true;
                isRadioLocation=true;
                isLocationCity=false;
                getListByLocation =true;
                radioCommonArray = radioFirstCityRegionArray;
                [_radioHeaderView setHidden:NO];
                [_radioByListView setHidden:YES];
                [_radioByListTable setHidden:YES];
                [_tableRadio setHidden:NO];
                [_tableRadio reloadData];
                
                
            }
            else{
                isRadioLocation=true;
                isLocationCity=false;
                getListByLocation =true;
                radioCommonArray = radioFirstCityOrRegionArray;
                [_radioHeaderView setHidden:NO];
                [_radioByListView setHidden:YES];
                [_radioByListTable setHidden:YES];
                [_tableRadio setHidden:NO];
                [_tableRadio reloadData];
            }
            
        }
        else{
            [_radioByListView setHidden:YES];
            [_radioByListTable setHidden:YES];
            [_radioHeaderView setHidden:YES];
            [_tableRadio setHidden:NO];
            [_tableRadio reloadData];
            
//            if(isRadioGridSelected==YES){
//                [self setTitleScrollBarRadio];
//                isRadioGridSelected=NO;
//            }
        }
        
    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130.0;
        
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return radioListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ListCell";
     //[_tableRadio setHidden:YES];
    
    RadioListByGenreCell*cell = (RadioListByGenreCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RadioListByGenreCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(_radioByListTable.tag ==100){
        
        
        NSString* cityAloneFalse;
        
        if (hasCityAloneFalse == nil) {
            cityAloneFalse=@"";
        } else {
            cityAloneFalse= hasCityAloneFalse;
        }
        NSString* cityAlone;
        
        if (hasCityAlone == nil) {
            cityAlone=@"";
        } else {
            cityAlone= hasCityAlone;
        }
        NSString* country;
        
        if (hasCityOneRegionZero_One == nil) {
            country=@"";
        } else {
            country= hasCityOneRegionZero_One;
        }
        NSString* continent;
        
        if (hasContinent == nil) {
            continent=@"";
        } else {
            continent= hasContinent;
        }
        
        
    NSDictionary* dictItem = radioListArray[indexPath.row];
    
    NSString* strPosterUrl =dictItem[@"image"];
    
    if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl==nil) {
        strPosterUrl=@"";
    }
    NSString* strName = dictItem[@"name"];
    
    if ((NSString *)[NSNull null] == strName||strName==nil) {
        strName=@"";
    }

    
    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(cell.radioTableListImage.frame.origin.x+1, 0, cell.radioTableListImage.frame.size.width-15, cell.radioTableListImage.frame.size.height)];
    
    [asyncImage setLoadingImage];
    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                            type:AsyncImageResizeTypeAspectRatio
                         isCache:YES];
    
       
        
        if([radioListArray count]==0){
            
            _radioByListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [cell.radioTableListImage setHidden:YES];
            [cell.radioTableListTitle setHidden:YES];
            [cell.radioTableListMainTitle setHidden:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [_radioByListTable setSeparatorColor:[UIColor blackColor]];
           
            
        }
        else{
            [_radioByListTable setSeparatorColor:[UIColor darkGrayColor]];
            [cell.radioTableListImage addSubview:asyncImage];
            [cell.radioTableListTitle setText:strName];
            if(isRadioLocation==true){
                if(isCityAlone == true){
                    [cell.radioTableListMainTitle setText:[NSString stringWithFormat:@"%@,%@,%@,%@", cityAloneFalse, cityAlone,country,continent]];
                    
                }
                else{
                    [cell.radioTableListMainTitle setText:[NSString stringWithFormat:@"%@,%@,%@", cityAloneFalse,country,continent]];
                    
                }
                
            }
            else{
                [cell.radioTableListMainTitle setText:listTitle];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
    }
    return cell;
   
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBarView setHidden:YES];
    [_searchButton setHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.view endEditing:YES];
    
    NSInteger row = indexPath.row;
    NSLog(@"Selected !!%ld",(long)row);
    [_radioByListView setHidden:YES];
    [_radioByListTable setHidden:YES];
    [_tableRadio setHidden:YES];
    [_radioDetailView setHidden:NO];
    [_radioHeaderView setHidden:YES];
    
    NSDictionary* dictItem  = radioListArray[indexPath.row];
    currentSelectedDictItem =[NSDictionary new];
    currentSelectedDictItem = dictItem;
    isTableDidSelected=YES;
    
    
    
    [self loadRadioDetailPage];
//    NSString* strPosterUrl  = dictItem[@"image"];
//    NSString* strName       = dictItem[@"name"];
//    NSString* strSlogan     = dictItem[@"slogan"];
//    NSString* strPhone      = dictItem[@"phone"];
//    NSString* strAdd        = dictItem[@"address"];
//    NSString* strDes        = dictItem[@"description"];
//     playerUrl              = dictItem[@"stream"];
//    
//    NSString* strCheckPlayerUrl;
//    
//    if ((NSString *)[NSNull null] == playerUrl) {
//        strCheckPlayerUrl=@"";
//    } else {
//        strCheckPlayerUrl= playerUrl;
//    }
//    
//
//        NSString* strCheck;
//
//        if ((NSString *)[NSNull null] == strPosterUrl) {
//                strCheck=@"";
//        } else {
//                strCheck= strPosterUrl;
//        }
//    
//        NSString* strCheckName;
//
//        if ((NSString *)[NSNull null] == strName) {
//                strCheckName=@"";
//        } else {
//                strCheckName= strName;
//        }
//        NSString* strCheckSlogan;
//
//        if ((NSString *)[NSNull null] == strSlogan) {
//            strCheckSlogan=@"";
//        } else {
//            strCheckSlogan= strSlogan;
//        }
//        NSString* strCheckPhone;
//
//        if ((NSString *)[NSNull null] == strPhone) {
//            strCheckPhone=@"";
//        } else {
//            strCheckPhone= strPhone;
//        }
//        NSString* strCheckAdd;
//
//        if ((NSString *)[NSNull null] == strAdd) {
//            strCheckAdd=@"";
//        } else {
//            strCheckAdd= strAdd;
//        }
//        NSString* strCheckDes;
//
//        if ((NSString *)[NSNull null] == strDes) {
//            strCheckDes=@"";
//        } else {
//            strCheckDes= strDes;
//        }
//    [_radioDetailMainLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailLeftLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailSloganTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailSloganLabel setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
//    [_radioDetailAddTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailAddLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
//    [_radioDetailPhoneTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailPhoneLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailDesTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    [_radioDetailTextView setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//    
//    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(_radioDetailImageView.frame.origin.x+1, 0, _radioDetailImageView.frame.size.width-15, _radioDetailImageView.frame.size.height)];
//    
//    [asyncImage setLoadingImage];
//    [asyncImage loadImageFromURL:[NSURL URLWithString:strCheck]
//                            type:AsyncImageResizeTypeAspectRatio
//                         isCache:YES];
//    UIImage *image;
//    UIImageView *imageView;
//    if([strCheck  isEqual:@""])
//        image = [UIImage imageNamed:@"playIcon"];
//    else
//        image = nil;
//    
//    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_radioDetailImageView.frame.origin.x+40,40, 40, 40)];
//    imageView.image = image;
//    //[_radioDetailImageView addSubview:imageView];
//    
//    if([strCheck  isEqual:@""]){
//        [asyncImage setHidden:YES];
//        [imageView setHidden:NO];
//        [_radioDetailImageView setHidden:YES];
//    }
//    else{
//        [imageView setHidden:YES];
//        [asyncImage setHidden:NO];
//        [_radioDetailImageView setHidden:NO];
//        [_radioDetailImageView addSubview:asyncImage];
//        
//    }
//    [_radioDetailMainLabel setText:strCheckName];
//    [_radioDetailLeftLabel setText:listTitle];
//    [_radioDetailSloganLabel setText:strCheckSlogan];
//    [_radioDetailAddLabel setText:strCheckAdd];
//    [_radioDetailPhoneLabel setText:strCheckPhone];
//    [_radioDetailTextView setText:strCheckDes];
//    [_radioDetailTextView setTextColor :[UIColor whiteColor]];

    [self setUpGestureForBackBtn];
    
}


-(void)loadRadioDetailPage{
    
    NSString* strPosterUrl  = currentSelectedDictItem[@"image"];
    NSString* strName       = currentSelectedDictItem[@"name"];
    NSString* strSlogan     = currentSelectedDictItem[@"slogan"];
    NSString* strPhone      = currentSelectedDictItem[@"phone"];
    NSString* strAdd        = currentSelectedDictItem[@"address"];
    NSString* strDes        = currentSelectedDictItem[@"description"];
    NSString* strEmail       = currentSelectedDictItem[@"email"];
    playerUrl              = currentSelectedDictItem[@"stream"];
    
    if ((NSString *)[NSNull null] == playerUrl || playerUrl==nil) {
        playerUrl=@"";
    }
    if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl==nil) {
        strPosterUrl=@"";
    }
    if ((NSString *)[NSNull null] == strName||strName==nil) {
        strName=@"";
    }
    if ((NSString *)[NSNull null] == strSlogan||strSlogan==nil) {
        strSlogan=@"";
    }
    if ((NSString *)[NSNull null] == strPhone||strPhone==nil) {
        strPhone=@"";
    }
    if ((NSString *)[NSNull null] == strAdd||strAdd==nil) {
        strAdd=@"";
    }
    if ((NSString *)[NSNull null] == strDes||strDes==nil) {
        strDes=@"";
    }
    if ((NSString *)[NSNull null] == strPhone||strPhone==nil) {
        strPhone=@"";
    }
    if ((NSString *)[NSNull null] == strEmail||strEmail==nil) {
        strEmail=@"";
    }
    [_radioDetailDesTitle setHidden:YES];
   
    [_radioDetailMainLabel setText:strName];
    [_radioDetailLeftLabel setText:listTitle];
    [_radioDetailSloganTitle setText:@"Slogan:"];
    [_radioDetailSloganLabel setText:strSlogan];
    [_radioDetailAddTitle setText:@"Address:"];
    [_radioDetailAddLabel setText:strAdd];
    [_radioDetailPhoneTitle setText:@"Phone:"];
    [_radioDetailPhoneLabel setText:strPhone];
//    [_radioDetailTextView setText:strDes];
        [_radioDetailTextView setHidden:YES];
    [_descriptionLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_descriptionLabel setText:strDes];
    CGRect rect = [strDes boundingRectWithSize:CGSizeMake(_descriptionLabel.frame.size.width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: _descriptionLabel.font}
                                                 context:nil];
    descHeight = rect.size.height;
    [self.view layoutIfNeeded];
    [_descriptionLabel setTextColor :[UIColor whiteColor]];
    [_radioDetailImageView setFrame:CGRectMake(20,0, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
    CGFloat radioPlayBtnXpos =_radioDetailImageView.frame.origin.x;
    CGFloat radioPlayBtnYpos =_radioDetailImageView.frame.origin.y+_radioDetailImageView.frame.size.height+10;
    CGFloat radioPlayBtnWidth =_radioDetailImageView.frame.size.width;
    [_radioDetailPlayBtn setFrame:CGRectMake(radioPlayBtnXpos,radioPlayBtnYpos, radioPlayBtnWidth, 40)];
    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, _radioDetailImageView.frame.size.width, _radioDetailImageView.frame.size.height)];
    
        [asyncImage setLoadingImage];
        [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                                type:AsyncImageResizeTypeAspectRatio
                             isCache:YES];
        UIImage *image;
        UIImageView *imageView;
        if([strPosterUrl  isEqual:@""])
            image = [UIImage imageNamed:@"playIcon"];
        else
            image = nil;
    
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_radioDetailImageView.frame.origin.x+40,40, 40, 40)];
        imageView.image = image;
        //[_radioDetailImageView addSubview:imageView];
    
        if([strPosterUrl  isEqual:@""]){
            [asyncImage setHidden:YES];
            [imageView setHidden:NO];
            [_radioDetailImageView setHidden:YES];
        }
        else{
            [imageView setHidden:YES];
            [asyncImage setHidden:NO];
            [_radioDetailImageView setHidden:NO];
            [_radioDetailImageView setImageWithURL:[NSURL URLWithString:strPosterUrl]];
        }
    
    CGFloat radioDetailMainLabelXpos =_radioDetailImageView.frame.origin.x+_radioDetailImageView.frame.size.width+10;
//    CGFloat radioDetailMainLabelWidth =SCREEN_WIDTH-(radioDetailMainLabelXpos+_radioDetailImageView.frame.size.width);
    CGSize stringSize = [strName sizeWithFont:[COMMON getResizeableFont:Roboto_Regular(12)] constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    CGRect stringSize = [strName boundingRectWithSize:CGSizeMake(_radioDetailMainLabel.frame.size.width, CGFLOAT_MAX)
//                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                    attributes:@{NSFontAttributeName: _radioDetailMainLabel.font}
//                                       context:nil];

    [_radioDetailMainLabel setFrame:CGRectMake(radioDetailMainLabelXpos,0,stringSize.width , 30)];//radioDetailMainLabelWidth
    [_radioDetailMainLabel sizeToFit];

    CGFloat radioDetailTextViewXpos =_radioDetailImageView.frame.origin.x+_radioDetailImageView.frame.size.width+10;
    CGFloat radioDetailTextViewWidth =SCREEN_WIDTH-(radioDetailTextViewXpos+_radioDetailImageView.frame.origin.x);
    [_radioDetailTextView setFrame:CGRectMake(radioDetailTextViewXpos,_radioDetailMainLabel.frame.size.height, radioDetailTextViewWidth, 80)];
    [_descriptionLabel setFrame:CGRectMake(radioDetailTextViewXpos,_radioDetailMainLabel.frame.size.height, radioDetailTextViewWidth, descHeight)];
    
    CGFloat commonWidth =_radioDetailTextView.frame.size.width;
    if([self isDeviceIpad]==YES){
        
    }
    else{
        
    }
    CGFloat radioDetailSloganTitleXpos = _radioDetailTextView.frame.origin.x;
    CGFloat radioDetailSloganTitleYpos = _radioDetailTextView.frame.origin.y+_descriptionLabel.frame.size.height+10;
   
    [_radioDetailSloganTitle setFrame:CGRectMake(radioDetailSloganTitleXpos,radioDetailSloganTitleYpos, commonWidth/4, 50)];
    
  
    CGFloat radioDetailSloganLabelXpos = _radioDetailSloganTitle.frame.origin.x+_radioDetailSloganTitle.frame.size.width;
    CGFloat radioDetailSloganLabelYpos=_radioDetailSloganTitle.frame.origin.y;
    [_radioDetailSloganLabel setFrame:CGRectMake(radioDetailSloganLabelXpos,radioDetailSloganLabelYpos, commonWidth-_radioDetailSloganTitle.frame.size.width, 50)];
    
    
    CGFloat radioDetailAddTitleXpos = _radioDetailTextView.frame.origin.x;
    CGFloat radioDetailAddTitleYpos = _radioDetailSloganLabel.frame.origin.y+_radioDetailSloganLabel.frame.size.height+10;
    [_radioDetailAddTitle setFrame:CGRectMake(radioDetailAddTitleXpos,radioDetailAddTitleYpos, commonWidth/4, 50)];

    CGFloat radioDetailAddLabelXpos = _radioDetailAddTitle.frame.origin.x+_radioDetailAddTitle.frame.size.width;
    CGFloat radioDetailAddLabelYpos = _radioDetailAddTitle.frame.origin.y;
    [_radioDetailAddLabel setFrame:CGRectMake(radioDetailAddLabelXpos,radioDetailAddLabelYpos, commonWidth-_radioDetailAddTitle.frame.size.width, 70)];

    
    CGFloat radioDetailPhoneTitleXpos = _radioDetailTextView.frame.origin.x;
    CGFloat radioDetailPhoneTitleYpos = _radioDetailAddLabel.frame.origin.y+_radioDetailAddLabel.frame.size.height+10;
    [_radioDetailPhoneTitle setFrame:CGRectMake(radioDetailPhoneTitleXpos,radioDetailPhoneTitleYpos, commonWidth/4, 30)];
    
    CGFloat radioDetailPhoneLabelXpos = _radioDetailPhoneTitle.frame.origin.x+_radioDetailPhoneTitle.frame.size.width;
    CGFloat radioDetailPhoneLabelYpos = _radioDetailPhoneTitle.frame.origin.y;
    [_radioDetailPhoneLabel setFrame:CGRectMake(radioDetailPhoneLabelXpos,radioDetailPhoneLabelYpos, commonWidth-_radioDetailPhoneTitle.frame.size.width, 30)];
    
    CGFloat emailTitleLabelXpos = _radioDetailTextView.frame.origin.x;
    CGFloat emailTitleLabelYpos =_radioDetailPhoneTitle.frame.origin.y+_radioDetailPhoneTitle.frame.size.height+10;
    [_emailTitleLabel setFrame:CGRectMake(emailTitleLabelXpos,emailTitleLabelYpos, commonWidth/4, 30)];
    
   
    CGFloat emailDataLabelXpos =  _emailTitleLabel.frame.origin.x+
    _emailTitleLabel.frame.size.width;
    CGFloat emailDataLabelYpos =  _emailTitleLabel.frame.origin.y;
    [_emailDataLabel setFrame:CGRectMake(emailDataLabelXpos,emailDataLabelYpos, commonWidth -_emailTitleLabel.frame.size.width, 30)];
    
    [_radioDetailPhoneLabel setText:strPhone];
    [_emailTitleLabel setText:@"Email:"];
    [_emailDataLabel setText:strEmail];
    [_radioDetailDesTitle setHidden:YES];
    
    
    [_radioDetailPlayBtn setBackgroundColor:[UIColor colorWithRed:154.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
    
    [_radioDetailMainLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailLeftLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailSloganTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailSloganLabel setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
    [_radioDetailAddTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailAddLabel setFont:[COMMON getResizeableFont:Roboto_Regular(11)]];
    [_radioDetailPhoneTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailPhoneLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_radioDetailDesTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_emailTitleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_emailDataLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    _emailTitleLabel.textColor =[UIColor whiteColor];
    _emailDataLabel.textColor =[UIColor whiteColor];
    _descriptionLabel.textColor =BORDER_BLUE;
    [_descriptionLabel setBackgroundColor:[UIColor clearColor]];//grayColor
    //[_radioDetailSloganLabel setBackgroundColor:[UIColor grayColor]];


}
-(void)removeFromView{
    [_radioDetailImageView removeFromSuperview];
    [_radioDetailPlayBtn removeFromSuperview];
    [_descriptionLabel removeFromSuperview];
    [_radioDetailSloganTitle removeFromSuperview];
    [_radioDetailSloganLabel removeFromSuperview];
    [_radioDetailAddTitle removeFromSuperview];
    [_radioDetailAddLabel removeFromSuperview];
    [_radioDetailPhoneTitle removeFromSuperview];
    [_radioDetailPhoneLabel removeFromSuperview];
    [_radioDetailPlayBtn removeFromSuperview];
}


#pragma mark -setUpGestureForBackBtn
-(void)setUpGestureForBackBtn{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailBackBtn:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_radioDetailLeftLabel addGestureRecognizer:tapGestureRecognizer];
    _radioDetailLeftLabel.userInteractionEnabled = YES;
    [_radioDetailPlayBtn addTarget:self action:@selector(radioPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_radioDetailBackBtn addTarget:self action:@selector(detailBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [Webview setDelegate:self];
    [Webview setBackgroundColor:[UIColor clearColor]];
    [Webview setHidden:YES];
    [_radioDetailPlayBtn setTitle:@"PLAY" forState:UIControlStateNormal];
    [_radioDetailPlayBtn setBackgroundColor:[UIColor colorWithRed:164.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
    playing = YES;
    

}
#pragma mark -addLoadingIcon
-(void) addRadioLoadingIcon{
    //spinner, not animated unless we are setting an icon
    radioLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((_radioDetailView.frame.size.width/2.2), (_radioDetailView.frame.size.height/2.2), 30, 30)];
    radioLoadingView.backgroundColor = [UIColor clearColor];
    radioLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [radioLoadingView setHidesWhenStopped:TRUE];
    radioLoadingView.contentMode = UIViewContentModeCenter;
    [radioLoadingView startAnimating];
    [_radioDetailView addSubview:radioLoadingView];
    
}
-(void) removeRadioLoadingIcon{
    [radioLoadingView removeFromSuperview];
}
#pragma mark -Back Action
- (void)detailBackBtn:(id)sender {
    if(_radioByListTable.tag ==100){
        [self.radioActivityIndicator setHidden:true];
        
        [radio updatePlay:NO];
        [radioLoadingView removeFromSuperview];
        [_radioDetailView setHidden:YES];
        [_radioByListView setHidden:NO];
        [_radioByListTable setHidden:NO];
        [_radioByListTable reloadData];
        _radioByListTable.tag =100;
        isTableDidSelected=NO;
    }
    
}
#pragma mark - setUpRadioStation
-(void)setUpRadioStation{
   
    if ((NSString *)[NSNull null] == playerUrl||playerUrl==nil) {
        playerUrl=@"";
    }
    
    radio = [[Radio alloc] initWithUserAgent:@"my radio"];
    [radio connect:playerUrl withDelegate:self withGain:(1.0)];
    
}
- (void)radioPlayBtnAction:(id)sender {
    if(playing)
    {
        [self addRadioLoadingIcon];
        [self setUpRadioStation];
        playing = NO;
        [_radioDetailPlayBtn setTitle:@"STOP" forState:UIControlStateNormal];
        [_radioDetailPlayBtn setBackgroundColor:[UIColor colorWithRed:164.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
        [radio updatePlay:YES];
    }
    else {
        playing = YES;
        [radio updatePlay:NO];
        [_radioDetailPlayBtn setTitle:@"PLAY" forState:UIControlStateNormal];
        [_radioDetailPlayBtn setBackgroundColor:[UIColor colorWithRed:164.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
        [self removeRadioLoadingIcon];
    }

}
#pragma mark - Radio Delegate

- (void)updateBuffering:(BOOL)value {
    NSLog(@"delegate update buffering %d", value);
}
- (void)interruptRadio {
    NSLog(@"delegate radio interrupted");
}
- (void)resumeInterruptedRadio {
    NSLog(@"delegate resume interrupted radio");
}
- (void)networkChanged {
    NSLog(@"delegate network changed");
}

- (void)connectProblem {
    NSLog(@"delegate connection problem");
}

- (void)audioUnplugged {
    NSLog(@"delegate audio unplugged");
}
#pragma mark - help to set current stream title
- (void)metaTitleUpdated:(NSString *)title {
    [self removeRadioLoadingIcon];
    NSLog(@"delegate title updated to %@", title);
    NSArray *chunks = [title componentsSeparatedByString:@";"];
    if ([chunks count]) {
        NSArray *streamTitle = [[chunks objectAtIndex:0] componentsSeparatedByString:@"="];
        if ([streamTitle count] > 1) {
             NSLog(@"title updated to %@", [streamTitle objectAtIndex:1]);
        }
    }
    
}

#pragma mark orientationChanged
-(void) radioOrientationChanged:(NSNotification *) note
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
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_searchButton setHidden:NO];
    [[self.navigationController.navigationBar viewWithTag:1001] removeFromSuperview];
//    
//    if(isRadioGridSelected==YES){
//        for (UIView *subview in showHeaderView.subviews) {
//            [subview removeFromSuperview];
//        }
//        [currentSelectTitle removeFromSuperview];
//        currentSelectTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
//        [showHeaderView addSubview:currentSelectTitle];
//        NSString *buttonTitle = [radioTabArray objectAtIndex:visibleSection];
//        currentSelectTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation"]];
//        currentSelectTitle.text = buttonTitle;
//        currentSelectTitle.textColor = [UIColor whiteColor];
//        currentSelectTitle.textAlignment = NSTextAlignmentCenter ;
//        [currentSelectTitle setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
//        
//
//    }
//    else{
//        [currentSelectTitle removeFromSuperview];
//         [self setTitleScrollBarRadio];
//    }
    [self setTitleScrollBarRadio];
    [_radioDetailTextView setHidden:YES];
    [self setUpSearchBarInNavigation];
    [self removeRadioLoadingIcon];
    if(bPortrait){
        nRadioColumn = 3;
        [_radioDetailPlayBtn setHidden:NO];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nRadioColumn = 6;
        }
        [_radioDetailPlayBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_radioDetailDesTitle setHidden:NO];
        [_descriptionLabel setHidden:NO];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nRadioWidth = screenWidth / nRadioColumn;
        nRadioHeight = screenWidth / nRadioColumn;
    }else{
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nRadioColumn = 5;
       
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nRadioColumn = 8;
            [_radioDetailPlayBtn setHidden:NO];
            [_radioDetailPlayBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        else{
            [_radioDetailPlayBtn setHidden:NO];
            [_radioDetailPlayBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
            CGFloat playBtnYpos = (_radioDetailPhoneLabel.frame.origin.y+_radioDetailPhoneLabel.frame.size.height+1);
            [_radioDetailPlayBtn setFrame:CGRectMake(28,playBtnYpos,_radioDetailPlayBtn.frame.size.width,30)];
            
            [_radioDetailDesTitle setHidden:YES];
//            [_descriptionLabel setHidden:YES];
        }
       
        nRadioWidth = screenWidth / nRadioColumn;
        nRadioHeight = screenWidth / nRadioColumn;
        
    }
    [_radioDetailMainLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [asyncImage setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailPlayBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailDesTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailSloganTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailSloganLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailAddTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailAddLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailPhoneTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailPhoneLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_radioDetailPlayBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_emailTitleLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_emailDataLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self loadRadioDetailPage];

    if(isTableDidSelected==YES){
        //[self removeFromView];
        [self loadRadioDetailPage];
    }
    // [_tableRadio reloadData];
    //  _tableRadio.tag =100;
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
