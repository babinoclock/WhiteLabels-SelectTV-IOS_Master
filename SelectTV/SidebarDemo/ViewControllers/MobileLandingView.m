//
//  MobileLandingView.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 21/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MobileLandingView.h"
#import "AppConfig.h"
#import "AppDownloadListCell.h"
#import "OverTheAirViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "STWebService.h"


@interface MobileLandingView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIGridViewDelegate,SWRevealViewControllerDelegate>{
    
     NSMutableArray *homeIconArray;
     NSMutableArray * imageArray;
     UIDevice* homeDevice;
    NSString * currentAppLanguage ;
    NSString *needHelpLink;
}
@end

@implementation MobileLandingView
@synthesize homeIconTable,footerView;

int nMobileCount = 2;
int nMobileCellWidth = 107;
int nMobileCellHeight = 200;

+(MobileLandingView *)loadView{
    
    return [[NSBundle mainBundle]loadNibNamed:@"MobileLandingView" owner:self options:nil][0];
}

-(void)loadMobileLandingData{
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    
    self.backgroundColor =GRAY_BG_COLOR;
   
    [self staticArray];
    //[self loadTranslation];
   
    imageArray = [NSMutableArray arrayWithObjects:@"channels_Icon",@"onDemand_Icon",@"listen_Icon",@"payPerView_Icon",@"subscriptions_Icon",@"overTheAir_Icon",@"myInterests_Icon",@"myAccount_Icon",@"games_Icon",@"more_Icon",nil];
    [self setGridTableView];
   

    homeDevice = [UIDevice currentDevice];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobileLandingOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
   
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self mobileLandingRotateViews:false];
    }else{
        [self mobileLandingRotateViews:true];
    }
    
    [homeIconTable reloadData];
}

-(void)staticArray{
    
    if([COMMON isSpanishLanguage]==YES){
        if([[NSUserDefaults standardUserDefaults] valueForKey:HOME_TRANSLATED_WORDS]==nil){
            homeIconArray = [NSMutableArray arrayWithObjects:@"Channels",@"On-Demand",@"Listen",@"Pay Per View",@"My Subscriptions",@"Over the Air Link Sling",@"My Interests",@"My Account",@"Games",@"More",nil];
        }
        else
        {
            homeIconArray =[[[NSUserDefaults standardUserDefaults] valueForKey:HOME_TRANSLATED_WORDS] mutableCopy];
        }
    }
    else{
        homeIconArray = [NSMutableArray arrayWithObjects:@"Channels",@"On-Demand",@"Listen",@"Pay Per View",@"My Subscriptions",@"Over the Air Link Sling",@"My Interests",@"My Account",@"Games",@"More",nil];
    }
    

}
#pragma mark - orientationChanged
-(void) mobileLandingOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self mobileLandingRotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self mobileLandingRotateViews:false];
            break;
            
        default:
            break;
    }
}

-(void) setGridTableView{
    int tableXpos;
    int tableYpos;
    CGFloat tableWidth = SCREEN_WIDTH;
    CGFloat tableHeight = SCREEN_HEIGHT;
    CGFloat ExtraValue=120;
    
    NSLog(@"tableWidth-->%f tableHeight-->%f",tableWidth,tableHeight);
    
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight)
    {

        ExtraValue=0;
        if(tableWidth<=320){
            tableXpos=-5;
            tableYpos=25;
        }
        else{
            tableXpos=5;
            tableYpos=30;
        }
    }
    else{
         ExtraValue=0;
        if(IS_IPHONE4||IS_IPHONE5){
            tableXpos=-3;
            tableYpos=10;
            ExtraValue=120;
            
        }
        else{
            tableXpos=3;
            tableYpos=15;
            if(tableWidth<=320){
                ExtraValue=100;
            }
            
        }
    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        ExtraValue=150;
    }
    
    homeIconTable = [[UIGridView alloc] initWithFrame:CGRectMake(tableXpos,tableYpos,tableWidth,SCREEN_HEIGHT-0)];
    homeIconTable.uiGridViewDelegate = self;
   // homeIconTable.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:83.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    homeIconTable.backgroundColor = [UIColor clearColor];
    homeIconTable.bounces = NO;
    [homeIconTable setScrollEnabled:NO];
    homeIconTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    homeIconTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect homeIconTableRect = homeIconTable.frame;
    //CGFloat homeIconTableRectMaxX = CGRectGetMaxY(homeIconTableRect);
    
    int titleWidth,subtitleWidth,fontSize;
    CGFloat footerViewYPos,footerViewHeight,termsLabelHeight;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        titleWidth=200;
        subtitleWidth=120;
        fontSize=18;
        footerViewYPos=SCREEN_HEIGHT-150;
        footerViewHeight=50;
        termsLabelHeight=30;
    }
    else{
        titleWidth=160;
        subtitleWidth=100;
        fontSize=14;
        footerViewHeight=50;
        termsLabelHeight=30;
        if(IS_IPHONE4||IS_IPHONE5){
            footerViewYPos=SCREEN_HEIGHT-110;
        }
        else{
         footerViewYPos=SCREEN_HEIGHT-130;//130
        }
        //homeIconTableRectMaxX
    }
    
    NSString *termsStr =@"TERMS & CONDITIONS";
    NSString *supportStr = @"SUPPORT" ;
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, footerViewYPos, tableWidth, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    if([COMMON isSpanishLanguage]==YES){
        termsStr = [COMMON getTermsAndConditionsStr];
        if ((NSString *)[NSNull null] == termsStr||termsStr == nil) {
            termsStr =@"TERMS & CONDITIONS";
            termsStr =  [COMMON stringTranslatingIntoSpanish:termsStr];
        }
        supportStr = [COMMON getSupportStr];
        if ((NSString *)[NSNull null] == supportStr||supportStr == nil) {
            supportStr = @"SUPPORT" ;
            supportStr =  [COMMON stringTranslatingIntoSpanish:supportStr];
        }
    }
    CGSize sloganLabelStrSize = [termsStr sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:OpenSans_Bold(fontSize)]}];
    CGFloat termsLabelWidth = sloganLabelStrSize.width+5;
//    
//    UILabel *termsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10 , termsLabelWidth, 30)];
//    termsLabel.text = termsStr;
//    termsLabel.textColor = [UIColor colorWithRed:58.0f/255.0f green:156.0f/255.0f blue:219.0f/255.0f alpha:1];
//    termsLabel.font = OpenSans_Bold(fontSize);
//    termsLabel.textAlignment = NSTextAlignmentCenter;
    
    //CGRect termsLabelRect = termsLabel.frame;
    //CGFloat termsLabelRectMaxX = CGRectGetMaxX(termsLabelRect);
    
    UILabel *supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10 , subtitleWidth, 30)];
    supportLabel.text = supportStr;//APOYO
    supportLabel.textAlignment = NSTextAlignmentCenter;
    supportLabel.textColor = [UIColor colorWithRed:58.0f/255.0f green:156.0f/255.0f blue:219.0f/255.0f alpha:1];
    supportLabel.font = OpenSans_Bold(fontSize);
    
    
    //termsLabel.textColor = [UIColor whiteColor];
    supportLabel.textColor = [UIColor whiteColor];
    
   // [footerView addSubview:termsLabel];
    [footerView addSubview:supportLabel];
    
    //termsLabel.backgroundColor = [UIColor clearColor];
    supportLabel.backgroundColor = [UIColor clearColor];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsAction:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
    //[termsLabel addGestureRecognizer:tapGestureRecognizer];
   // termsLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supportAction:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [supportLabel addGestureRecognizer:tapGestureRecognizer1];
    supportLabel.userInteractionEnabled = YES;


   // [footerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    //homeIconTable.tableFooterView = footerView;
    
    [self addSubview:homeIconTable];
    [self addSubview:footerView];
    
}

- (void)termsAction:(UITapGestureRecognizer *)tap {
    NSString *url= @"http://freecast.s3.amazonaws.com/SelectTV/App/selecttv-tos.html";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}
- (void)supportAction:(UITapGestureRecognizer *)tap {
    
    if ([APP_TITLE isEqualToString:@"SelectTV"])
    {
    NSString *url= Link;     
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else{
//        NSString *url= needHelpLink;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        [self getNeedHelp];
    
    }
    
}
-(id)loadTranslation:(NSString *)currentEnglishText{
    __block NSString *translatedText= @"";
    
    NSString * googleTranslatedText = [COMMON urlEncodedStringFromString:currentEnglishText];
    NSString * urlString=@"";
    urlString = [NSString stringWithFormat:@"%@?key=%@&source=%@&target=%@&q=%@",API_URL_GET_LANGUAGES,GOOLGE_APIS_TRANSLATE_KEY,@"en",@"es",googleTranslatedText];
    
    NSLog(@"urlString = %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSLog(@"jsonObject is %@",jsonObject);
    
    NSDictionary *translation = [[[jsonObject objectForKey:@"data"] objectForKey:@"translations"] objectAtIndex:0];
    translatedText = [translation objectForKey:@"translatedText"];
    
    if ((NSString *)[NSNull null] == currentEnglishText||currentEnglishText == nil) {
        currentEnglishText=@"";
    }
    if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
        translatedText=@"";
    }
    if([translatedText isEqualToString:@""]){
        translatedText = currentEnglishText;
    }
    
    return translatedText;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 30.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sampleView = [[UIView alloc] init];
//    sampleView.frame = CGRectMake(SCREEN_WIDTH/2, 5, 60, 4);
//    sampleView.backgroundColor = [UIColor blackColor];
//    return sampleView;
//}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if(IS_IPHONE4||IS_IPHONE5){
       
        return nMobileCellWidth-3;
    }
    else{
         return nMobileCellWidth;
    }
   return nMobileCellWidth;
    
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int) rowIndex
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 205;
        
    }
    else
    {
        if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
            return 130;
        }
        else{
            if(IS_IPHONE4||IS_IPHONE5){
                return 115;//120
            }
            else{
                return 125;
            }
        }
        
    }
    
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    NSInteger nCount = 0;
    
    if([homeIconArray count]!=0){
        
        nCount = nMobileCount;
    }
    else{
        nCount = 1;
    }
    return nCount;
    
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return [homeIconArray count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    AppDownloadListCell* cell = [grid dequeueReusableCell];
    
    if(cell == nil){
        cell = [[AppDownloadListCell alloc] init];
    }
    
    
    int nIndex = rowIndex;
    
    nIndex= rowIndex * nMobileCount + columnIndex;
    NSString* iconName = homeIconArray [nIndex];
    NSString* imageName = imageArray [nIndex];//[[[homeIconArray valueForKey:@"fields"]valueForKey:@"image"]objectAtIndex:nIndex];
    
    int maskSize,fontSize;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        maskSize = 20;
        fontSize = 11;
    }
    else{
        maskSize = 10;
        fontSize = 7;
    }
    //cell.appView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:cell.appView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(maskSize, maskSize)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.appView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath1 = [UIBezierPath
                              bezierPathWithRoundedRect:cell.coverViewBtn.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(maskSize, maskSize)
                              ];
    
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.bounds;
    maskLayer1.path = maskPath1.CGPath;
    cell.coverViewBtn.layer.mask = maskLayer1;
    
    [cell.coverViewBtn setTitle:iconName forState:UIControlStateNormal];
   // [cell.appImage setImage:[UIImage imageNamed:imageName]];
    
    [cell.appImage setImage: [[UIImage imageNamed:imageName]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [cell.appImage setTintColor:[UIColor whiteColor]];

    
    [cell.coverViewBtn.titleLabel setFont:[COMMON getResizeableFont:OpenSans_Regular(fontSize)]];

    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    NSLog(@"%d, %d clicked", rowIndex, colIndex);
    int count = (int) [homeIconArray count];
    NSLog(@"count%d", count);
    
    int nIndex = nIndex= rowIndex * nMobileCount + colIndex;
    
    if(nIndex < count){
        NSString* iconName = homeIconArray[nIndex];
        NSString *currentIndex =[NSString stringWithFormat:@"%d",nIndex];
        NSMutableDictionary *homeData = [NSMutableDictionary new];
        [homeData setValue:currentIndex forKey:@"homeIndex"];
        [homeData setValue:iconName forKey:@"homeName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFromMobilePage" object:homeData];
    }
   
    
    
}
-(void) mobileLandingRotateViews:(BOOL) bPortrait{
    
    if(bPortrait){
        nMobileCount = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nMobileCount = 4;
        }
         nMobileCellWidth = SCREEN_WIDTH / nMobileCount;//homeIconTable.frame.size.width
         nMobileCellHeight = SCREEN_HEIGHT/ nMobileCount;
    }
    else{
        nMobileCount = 5;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nMobileCount = 5;
        }
        nMobileCellWidth =SCREEN_WIDTH  / nMobileCount;//homeIconTable.frame.size.width
        nMobileCellHeight = SCREEN_HEIGHT/ nMobileCount;
    }
    
}
#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}
-(void)getNeedHelp
{
    
    [[STWebService sharedWebService]getNeedHelpLink:^(id responseObject) {
        
        NSLog(@"RESponse====>%@",responseObject);
        NSLog(@"APPPPPPSSSSS===>%@",[[responseObject objectAtIndex:0] valueForKey:SLUG_NAME]);
        needHelpLink =[[responseObject objectAtIndex:0] valueForKey:SLUG_NAME];
       
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:needHelpLink]];
        
    } failure:^(NSError *error) {
        
        NSLog(@"RESponse====>errrrroooorrr");
    }];
}




@end
