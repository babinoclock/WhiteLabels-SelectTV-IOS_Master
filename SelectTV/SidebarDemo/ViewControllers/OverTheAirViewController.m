//
//  OverTheAirViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 22/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "OverTheAirViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"

@implementation OverTheAirViewController
{
    NSString * currentAppLanguage;
}
-(void)viewDidLoad {
    [_mainView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr = @"Over the Air Link Sling";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.navigationItem.title = titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
 //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;

    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overTheAirOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UIDevice* homeDevice = [UIDevice currentDevice];
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self overTheAirRotateViews:false];
    }else{
        [self overTheAirRotateViews:true];
    }

    
}
-(void)viewWillAppear:(BOOL)animated {
    UIDevice* homeDevice = [UIDevice currentDevice];
    if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
        [self overTheAirRotateViews:false];
    }else{
        [self overTheAirRotateViews:true];
    }
}
-(void)initialSetup {
    
    if([self isDeviceIpad]==YES){
    }
    else{
        
    }
    for(UIView *view in self.view.subviews){
        [view removeFromSuperview];
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
           
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
            
        }
    }
    
    
    UIView *overTheAirFullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:overTheAirFullView];
   
    //buttonView
    CGFloat buttonViewXPos,buttonViewYPos,buttonViewWidth,buttonViewHeight;
     //buttonViewImage
    CGFloat buttonImageTopXPos,buttonImageTopYPos,buttonImageTopWidth,buttonImageTopHeight;
    
   
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        
        
        if([self isDeviceIpad]==YES){
            buttonViewXPos= SCREEN_WIDTH/14;//30;
            buttonViewYPos= SCREEN_HEIGHT/5;
            buttonViewWidth =SCREEN_WIDTH/2.8;
            buttonViewHeight=SCREEN_HEIGHT/2;

        }
        else{
            buttonViewXPos= SCREEN_WIDTH/15;
            buttonViewYPos= SCREEN_HEIGHT/6;
            buttonViewWidth =SCREEN_WIDTH/2.8;
            buttonViewHeight=SCREEN_HEIGHT/1.6;
        }
        
    }
    else{
        
        if([self isDeviceIpad]==YES){
            buttonViewXPos= SCREEN_WIDTH/4;
            buttonViewYPos= SCREEN_HEIGHT/15;//40;
            buttonViewWidth =SCREEN_WIDTH/2;
            buttonViewHeight=SCREEN_HEIGHT/3;

        }
        else{
            buttonViewXPos= SCREEN_WIDTH/6;
            buttonViewYPos= SCREEN_HEIGHT/17;
            buttonViewWidth =SCREEN_WIDTH/1.5;
            buttonViewHeight=SCREEN_HEIGHT/3;
        }
    }
    int titleFontSize;
    int subTitleFontSize;
    int orFontSize;
    int maskSize;
    if([self isDeviceIpad]==YES){
        titleFontSize    = 28;
        subTitleFontSize = 22;
        maskSize=20;
        orFontSize=22;
    }
    else{
        titleFontSize    = 18;
        subTitleFontSize = 12;
        maskSize=10;
        orFontSize=17;
    }
    
    
    UIView *buttonViewTop = [[UIView alloc]initWithFrame:CGRectMake(buttonViewXPos, buttonViewYPos, buttonViewWidth, buttonViewHeight)];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:buttonViewTop.bounds
                              byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(maskSize, maskSize)
                              ];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    buttonViewTop.layer.mask = maskLayer;
    buttonViewTop.backgroundColor = [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:.30];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        
        buttonImageTopXPos=buttonViewTop.frame.size.width/3;
        buttonImageTopYPos=buttonViewTop.frame.size.height/6;
        buttonImageTopWidth=buttonViewTop.frame.size.width-(buttonImageTopXPos*2);
        buttonImageTopHeight=buttonViewTop.frame.size.height/2.5;

    }
    else{
        //bottomImage
        buttonImageTopXPos=buttonViewTop.frame.size.width/3;
        buttonImageTopYPos=buttonViewTop.frame.size.height/6;
        buttonImageTopWidth=buttonViewTop.frame.size.width-(buttonImageTopXPos*2);
        buttonImageTopHeight=buttonViewTop.frame.size.height/2.5;

    }
    
    UIImageView *buttonImageTop = [[UIImageView alloc]initWithFrame:CGRectMake(buttonImageTopXPos, buttonImageTopYPos, buttonImageTopWidth, buttonImageTopHeight)];
    buttonImageTop.image = [UIImage imageNamed:@"wifi_Icon"];
   
    CGFloat titleLabelYPos;
    if([self isDeviceIpad]==YES){
        titleLabelYPos =buttonImageTop.frame.origin.y+buttonImageTop.frame.size.height+20;
    }
    else{
        titleLabelYPos = buttonImageTop.frame.origin.y+buttonImageTop.frame.size.height+10;
        
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,titleLabelYPos , buttonViewTop.frame.size.width, 30)];
    titleLabel.text = @"Local Channels";
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.font = OpenSans_Regular(titleFontSize);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, buttonViewTop.frame.size.width, 40)];
    subtitleLabel.text = @"Desktop, Laptop, Set-top-Box";
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = OpenSans_Regular(subTitleFontSize);

    
    [buttonViewTop addSubview:buttonImageTop];
    [buttonViewTop addSubview:titleLabel];
    [buttonViewTop addSubview:subtitleLabel];
    [overTheAirFullView addSubview:buttonViewTop];
    

    
    CGRect buttonViewTopFrame = buttonViewTop.frame;
    CGFloat buttonViewTopFrameMaxX = CGRectGetMaxX(buttonViewTopFrame);
    CGFloat buttonViewTopFrameMaxY = CGRectGetMaxY(buttonViewTopFrame);
    
    //centreOkView
    CGFloat centreOkViewXPos,centreOkViewYPos,centreOkViewWidth,centreOkViewHeight;
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        centreOkViewXPos = buttonViewTopFrameMaxX+20;
        centreOkViewYPos = buttonViewTop.frame.origin.y+(buttonViewTop.frame.size.height/3);
        centreOkViewWidth = buttonViewTop.frame.size.width/3;
        centreOkViewHeight = buttonViewTop.frame.size.height/3;
        
    }
    else{
        centreOkViewXPos = buttonViewTop.frame.origin.x+(buttonViewTop.frame.size.width/3);
        centreOkViewYPos = buttonViewTopFrameMaxY+20;
        centreOkViewWidth = buttonViewTop.frame.size.width/3;
        centreOkViewHeight = buttonViewTop.frame.size.height/3;
    }
    UIView *centreOkView = [[UIView alloc]initWithFrame:CGRectMake(centreOkViewXPos, centreOkViewYPos, centreOkViewWidth, centreOkViewHeight)];
    
     CGFloat orLabelLine1XPos,orLabelLine1YPos,centreLabelLineCommonWidth,centreLabelLineCommonHeight;
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        orLabelLine1XPos = 0;
        orLabelLine1YPos = (centreOkViewHeight/2)-3;
        centreLabelLineCommonHeight = 3;
        centreLabelLineCommonWidth =centreOkViewWidth/3;
        
    }
    else{
        orLabelLine1XPos = (centreOkViewWidth/2)-3;
        orLabelLine1YPos = 0;
        centreLabelLineCommonHeight = centreOkViewHeight/3;
        centreLabelLineCommonWidth =3;
       
    }
    UILabel *orLabelLine1 = [[UILabel alloc]initWithFrame:CGRectMake(orLabelLine1XPos, orLabelLine1YPos, centreLabelLineCommonWidth, centreLabelLineCommonHeight)];
    
    CGRect orLabelLine1Frame = orLabelLine1.frame;
    CGFloat orLabelLine1FrameMaxX = CGRectGetMaxX(orLabelLine1Frame);
    CGFloat orLabelLine1FrameMaxY = CGRectGetMaxY(orLabelLine1Frame);
    
    CGFloat orLabelXPos,orLabelYPos,orLabelWidth,orLabelHeight;
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        orLabelXPos=orLabelLine1FrameMaxX;
        orLabelYPos=(centreOkViewHeight/3);
        orLabelWidth = centreOkViewWidth/3;
        orLabelHeight=centreOkViewHeight/3;
    }
    else{
        orLabelXPos=0;
        orLabelYPos=orLabelLine1FrameMaxY;
        orLabelWidth = centreOkViewWidth;
        orLabelHeight=centreOkViewHeight/3;
    }
    
    UILabel *orLabel = [[UILabel alloc]initWithFrame:CGRectMake(orLabelXPos, orLabelYPos, orLabelWidth, orLabelHeight)];//30
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.text = @"or";
    orLabel.font = OpenSans_Bold(orFontSize);
    orLabel.textColor = [UIColor whiteColor];
   // orLabel.backgroundColor = [UIColor grayColor];
  //  centreOkView.backgroundColor = [UIColor lightGrayColor];
    
    CGRect orLabelFrame = orLabel.frame;
    CGFloat orLabelFrameMaxX = CGRectGetMaxX(orLabelFrame);
    CGFloat orLabelFrameMaxY = CGRectGetMaxY(orLabelFrame);
    CGFloat orLabelLine2XPos,orLabelLine2YPos;
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        orLabelLine2XPos=orLabelFrameMaxX;
        orLabelLine2YPos=(centreOkViewHeight/2)-3;
    }
    else{
        orLabelLine2XPos=(centreOkViewWidth/2)-3;
        orLabelLine2YPos=orLabelFrameMaxY;
    }
    
    UILabel *orLabelLine2 = [[UILabel alloc]initWithFrame:CGRectMake(orLabelLine2XPos,orLabelLine2YPos, centreLabelLineCommonWidth, centreLabelLineCommonHeight)];
    
    orLabelLine1.backgroundColor = [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];
    orLabelLine2.backgroundColor = [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];
    
    [centreOkView addSubview:orLabel];
    [centreOkView addSubview:orLabelLine1];
    [centreOkView addSubview:orLabelLine2];
    [overTheAirFullView addSubview:centreOkView];

    CGRect centreOkViewFrame = centreOkView.frame;
    CGFloat centreOkViewFrameMaxX = CGRectGetMaxX(centreOkViewFrame);
    CGFloat centreOkViewFrameMaxY = CGRectGetMaxY(centreOkViewFrame);
    
    //buttonViewBottom
    CGFloat buttonViewBottomXPos,buttonViewBottomYPos,buttonViewBottomWidth,buttonViewBottomHeight;

    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        buttonViewBottomXPos= centreOkViewFrameMaxX+15;
        buttonViewBottomYPos= buttonViewTop.frame.origin.y;//SCREEN_HEIGHT/6;
        buttonViewBottomWidth =buttonViewTop.frame.size.width;//SCREEN_WIDTH/2.8;
        buttonViewBottomHeight=buttonViewTop.frame.size.height;//SCREEN_HEIGHT/2;
        
    }
    else{
        buttonViewBottomXPos = buttonViewTop.frame.origin.x;
        buttonViewBottomYPos =centreOkViewFrameMaxY+15;
        buttonViewBottomWidth =buttonViewTop.frame.size.width;//SCREEN_WIDTH/2;
        buttonViewBottomHeight=buttonViewTop.frame.size.height;//SCREEN_HEIGHT/3;
       
    }
    
    UIView *buttonViewBottom = [[UIView alloc]initWithFrame:CGRectMake(buttonViewBottomXPos, buttonViewBottomYPos, buttonViewBottomWidth, buttonViewBottomHeight)];
    //buttonViewBottom.layer.cornerRadius = 5;
    //buttonViewBottom.clipsToBounds = YES;
    //buttonViewBottom.backgroundColor = [UIColor colorWithRed:0.0f/255 green:39.0f/255 blue:36.0f/255 alpha:1.0];
    buttonViewBottom.backgroundColor = [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:.30];

  
    UIBezierPath *maskPath1 = [UIBezierPath
                              bezierPathWithRoundedRect:buttonViewBottom.bounds
                              byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(maskSize,maskSize)
                              ];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    
    maskLayer1.frame = self.view.bounds;
    maskLayer1.path = maskPath1.CGPath;
    buttonViewBottom.layer.mask = maskLayer1;
    
     CGFloat buttonImageBottomXPos,buttonImageBottomYPos,buttonImageBottomWidth,buttonImageBottomHeight;
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        
        buttonImageBottomXPos=buttonViewTop.frame.size.width/3;
        buttonImageBottomYPos=buttonViewTop.frame.size.height/6;
        buttonImageBottomWidth=buttonViewTop.frame.size.width-(buttonImageTopXPos*2);
        buttonImageBottomHeight=buttonViewTop.frame.size.height/2.5;
        
    }
    else{
        //bottomImage
        buttonImageBottomXPos=buttonViewTop.frame.size.width/3;
        buttonImageBottomYPos=buttonViewTop.frame.size.height/6;
        buttonImageBottomWidth=buttonViewTop.frame.size.width-(buttonImageTopXPos*2);
        buttonImageBottomHeight=buttonViewTop.frame.size.height/2.5;
        
    }
    
    
//    UIImageView *buttonImageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(buttonViewBottom.frame.size.width/4, 10, buttonViewBottom.frame.size.width/2, buttonViewBottom.frame.size.height/2)];
    UIImageView *buttonImageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(buttonImageBottomXPos, buttonImageBottomYPos, buttonImageBottomWidth, buttonImageBottomHeight)];
    
    buttonImageBottom.image = [UIImage imageNamed:@"tv_Icon"];
    
    CGFloat titleLabelBottomYPos;
    if([self isDeviceIpad]==YES){
        titleLabelBottomYPos =buttonImageBottom.frame.origin.y+buttonImageBottom.frame.size.height+20;
    }
    else{
        titleLabelBottomYPos = buttonImageBottom.frame.origin.y+buttonImageBottom.frame.size.height+10;
        
    }
    
    UILabel *titleLabelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabelBottomYPos, buttonViewBottom.frame.size.width, 30)];
    titleLabelBottom.text = @"Premium Channels";
    titleLabelBottom.textColor = [UIColor whiteColor];
    titleLabelBottom.font = OpenSans_Regular(titleFontSize);
    titleLabelBottom.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *subtitleLabelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, buttonViewTop.frame.size.width, 30)];
    subtitleLabelBottom.text = @"Live TV Packages";
    subtitleLabelBottom.textAlignment = NSTextAlignmentCenter;
    subtitleLabelBottom.textColor = [UIColor whiteColor];
    subtitleLabelBottom.font = OpenSans_Regular(subTitleFontSize);
    
    
    [buttonViewBottom addSubview:buttonImageBottom];
    [buttonViewBottom addSubview:titleLabelBottom];
    [buttonViewBottom addSubview:subtitleLabelBottom];
    
    [overTheAirFullView addSubview:buttonViewBottom];
    
    
    [self AddingGestureToView:buttonViewTop buttonViewBottom:buttonViewBottom];
    
    
}
-(void)AddingGestureToView:(UIView*)buttonViewTop buttonViewBottom:(UIView*)buttonViewBottom{
    
    UITapGestureRecognizer* firstView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstView:)];
    firstView.numberOfTapsRequired = 1;
    firstView.numberOfTouchesRequired = 1;
    buttonViewTop.userInteractionEnabled = YES;
    [buttonViewTop addGestureRecognizer:firstView];
    
    UITapGestureRecognizer* secondView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondView:)];
    secondView.numberOfTapsRequired = 1;
    secondView.numberOfTouchesRequired = 1;
    buttonViewBottom.userInteractionEnabled = YES;
    [buttonViewBottom addGestureRecognizer:secondView];
    
}
- (void)firstView:(UITapGestureRecognizer *)tap {
//    NSLog(@"First");
//   OverTheAirDetailController *overdetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"OverTheAirDetailController"];
//    overdetailView.isSling = NO;
//    [self.navigationController pushViewController:overdetailView animated:YES];
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *ourPath = @"http://selecttv.com/hd-antenna/";
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    [ourApplication openURL:ourURL];

}
- (void)secondView:(UITapGestureRecognizer *)tap {
    OverTheAirDetailController *overdetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"OverTheAirDetailController"];
    overdetailView.isSling = YES;
    [self.navigationController pushViewController:overdetailView animated:YES];

}

-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - orientationChanged
-(void) overTheAirOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            //   case UIDeviceOrientationPortraitUpsideDown:
            [self overTheAirRotateViews:true];
            
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self overTheAirRotateViews:false];
            
            break;
            
        default:
            break;
    }
}

-(void)overTheAirRotateViews:(BOOL) bPortrait{
    
    [self initialSetup];
    
    if(bPortrait){
        
    }
    
    else{
        
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
