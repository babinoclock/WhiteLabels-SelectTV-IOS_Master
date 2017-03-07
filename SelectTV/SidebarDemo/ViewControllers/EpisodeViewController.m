//
//  EpisodeViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 22/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "EpisodeViewController.h"
#import "UIGridView.h"
#import "Cell.h"
#import "Land_Cell.h"
#import "RabbitTVManager.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "MainViewController.h"
#import "ShowDetailViewController.h"
#import "PlusViewController.h"
#import "CustomIOS7AlertView.h"
#import "UIGridView.h"
#import "ShowDetailViewController.h"
#import "MovieViewController.h"
#import "MBProgressHUD.h"
#import "Season.h"
#import "AppConfig.h"
#import "AsyncImage.h"



@interface EpisodeViewController (){
    AsyncImage * asyncImage;
  
}

@end

@implementation EpisodeViewController
@synthesize episodeArray,episodeIDStr,showIDStr,seasonIDStr,showNameStr;

int nEpiColumn  = 3;
int nEpiWidth   = 107;
int nEpiHeight  = 200;

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
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Light(17)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EpisodeOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }



}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
    
}


-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return nEpiWidth;
}
                                          
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    //return nEpiHeight;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return nEpiHeight;
    }
    else{
        return 140;
    }
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    
 return nEpiColumn;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return [episodeArray count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    Land_Cell* cell = [grid dequeueReusableCell];
    if(cell == nil){
        cell = [[Land_Cell alloc] init];
    }
    
    int nIndex = rowIndex * nEpiColumn + columnIndex;
    
    NSLog(@"Array count = %lu, index = %d", (unsigned long)episodeArray.count, nIndex);
    NSDictionary* dictItem = episodeArray[nIndex];
    NSString* strPosterUrl = dictItem[@"poster_url"];
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
    NSURL* imageUrl = [NSURL URLWithString:strPosterUrlCheck];
    [cell.label setText:strNameCheck];
    [cell.thumbnail setImageWithURL:imageUrl];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [cell.label setFont:[COMMON getResizeableFont:Roboto_Bold(12)]];
    }
    
//    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, cell.thumbnail.frame.size.width, cell.thumbnail.frame.size.height)];
//    [asyncImage setLoadingImage];
//    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrlCheck]
//                            type:AsyncImageResizeTypeCrop
//                         isCache:YES];
//    [cell.thumbnail addSubview:asyncImage];
    
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    NSLog(@"%d, %d clicked", rowIndex, colIndex);
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    int nIndex = rowIndex * nEpiColumn + colIndex;
    NSDictionary* dictItem = episodeArray[nIndex];
    NSLog(@"arrayItems%@", episodeArray);
    NSString* episodeName = dictItem[@"name"];
    NSString* episodeID = dictItem[@"id"];
    NSString* strPosterUrl = dictItem[@"poster_url"];
    ShowDetailViewController* mShowVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"showdetail_ipad"];
    } else {
        mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"showdetail"];
    }
    // mShowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"showdetail"];
    //mShowVC.nID = episodeID;
    mShowVC.nID = showIDStr;
    mShowVC.episodeId = episodeID;
    // NSLog(@"showID%@",dictItem[@"id"]);
    mShowVC.isEpisode=YES;
    //mShowVC.showDetailArray=seasonArray;
    mShowVC.headerLabelStr = showNameStr;
    mShowVC.episodeTitle = episodeName;
    mShowVC.posterUrlStr = strPosterUrl;
    [mShowVC getEpisodeData:[showIDStr intValue] seasonId:[seasonIDStr intValue] episodeId:[episodeID intValue]];
    [self.navigationController pushViewController:mShowVC animated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

- (IBAction) goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) EpisodeOrientationChanged:(NSNotification *) note
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
#pragma mark - rotateViews
-(void) rotateViews:(BOOL) bPortrait{
    if(bPortrait){
        
        nEpiColumn = 3;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nEpiColumn = 3;
            
        }
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nEpiWidth = screenWidth / nEpiColumn;
        nEpiHeight = screenWidth / nEpiColumn;
    }else{
        nEpiColumn = 5;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nEpiColumn = 4;
            
        }
        
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        nEpiWidth = screenWidth / nEpiColumn;
        nEpiHeight = screenWidth / nEpiColumn;
        
    }
    
    [self.tableViewEpisode reloadData];
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
