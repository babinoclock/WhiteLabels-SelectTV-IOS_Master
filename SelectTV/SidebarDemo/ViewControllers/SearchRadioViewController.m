//
//  SearchRadioViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 02/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "SearchRadioViewController.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "Season.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImage.h"

@interface SearchRadioViewController ()<UIWebViewDelegate>{
    NSString *playerUrl;
    AsyncImage *asyncImage;
    BOOL playing;
}

@end

@implementation SearchRadioViewController
@synthesize radioDetailArray,radioImageUrl;
@synthesize emailTitleLabel, emailDataLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
     self.edgesForExtendedLayout=UIRectEdgeNone;
    //[self loadRadioData];
    
    [self setOrientation];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [radio updatePlay:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [radio updatePlay:NO];
    
}

-(void) loadNavigation{
    
    //NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr = @"Radio Detail";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
  
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
    [_descriptionData removeFromSuperview];
    
    
    [_SearchRadioTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_searchRadioSlogan setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_sloganData setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
    [_searchRadioAddress setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_addressData setFont:[COMMON getResizeableFont:Roboto_Regular(9)]];
    _addressData.numberOfLines=0;
    [_searchRadioPhone setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_phoneData setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_searchRadioDescription setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [_descriptionDataLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [emailTitleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    [emailDataLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    _descriptionDataLabel.textColor =BORDER_BLUE;
    
}
-(void)setOrientation{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchRadioOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
}

-(void) searchRadioOrientationChanged:(NSNotification *) note
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

-(void) loadRadioData{
   
    [self.searchRadioActivityIndicator setHidden:true];
    // not valuble in server so i'm getting image from before page
    NSString* strPosterUrl  = [radioDetailArray valueForKey:@"image"]; // not working
    NSString* strName       = [radioDetailArray valueForKey:@"name"];
    NSString* strSlogan     = [radioDetailArray valueForKey:@"slogan"];
    NSString* strPhone      = [radioDetailArray valueForKey:@"phone"];
    NSString* strAdd        = [radioDetailArray valueForKey:@"address"];
    NSString* strDes        = [radioDetailArray valueForKey:@"description"];
    NSString* strEmail      = [radioDetailArray valueForKey:@"email"];
    playerUrl               = [radioDetailArray valueForKey:@"stream"];
    
    if ((NSString *)[NSNull null] == playerUrl ||playerUrl==nil) {
        playerUrl=@"";
    }
    if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl==nil) {
        strPosterUrl=@"";
    }
    if ((NSString *)[NSNull null] == strName||strName==nil) {
        strName=@"-";
    }
    if ((NSString *)[NSNull null] == strSlogan||strSlogan==nil) {
        strSlogan=@"-";
    }
    if ((NSString *)[NSNull null] == strPhone||strPhone==nil) {
        strPhone=@"-";
    }
    if ((NSString *)[NSNull null] == strAdd||strAdd==nil) {
        strAdd=@"-";
    }
    
    if ((NSString *)[NSNull null] == strDes||strDes==nil) {
        strDes=@"-";
    }
    if ((NSString *)[NSNull null] == strEmail||strEmail==nil) {
        strEmail=@"-";
    }
    
    [_SearchRadioTitle setText:strName];
    [_SearchRadioTitle setTextAlignment:NSTextAlignmentLeft];
    [_searchRadioSlogan setText:@"Slogan:"];
    [_sloganData setText:strSlogan];
    [_searchRadioAddress setText:@"Address:"];
    [_addressData setText:strAdd];
    [_searchRadioPhone setText:@"Phone:"];
    [_phoneData setText:strPhone];
    //[_searchRadioDescription setText:@"Description"];
    [_searchRadioDescription setHidden:YES];
    [_descriptionDataLabel setText:strDes];
    _descriptionDataLabel.textColor = BORDER_BLUE;
    
    
    [_searchRadioPlayButton addTarget:self action:@selector(searchRadioPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchRadioWebView setDelegate:self];
    //Webview.frame = CGRectMake(-1, -1, 1, 1);
    [_searchRadioWebView setBackgroundColor:[UIColor clearColor]];
    [_searchRadioWebView setHidden:YES];
    
    [_searchRadioPlayButton setTitle:@"PLAY" forState:UIControlStateNormal];
     playing = YES;
    
    
    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0,0, _searchRadioImage.frame.size.width, _searchRadioImage.frame.size.height)];
    
    [asyncImage setLoadingImage];
    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                            type:AsyncImageResizeTypeAspectRatio
                         isCache:YES];
    
    //CODING RADIO
    
    [_searchRadioImage setFrame:CGRectMake(20,40, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
    
    
    UIImage *image;
    UIImageView *imageView;
    if([strPosterUrl  isEqual:@""])
        image = [UIImage imageNamed:@"playIcon"];
    else
        image = nil;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_searchRadioImage.frame.origin.x+40,40, 40, 40)];
    imageView.image = image;
    //[_radioDetailImageView addSubview:imageView];
    
    if([strPosterUrl  isEqual:@""]){
        [asyncImage setHidden:YES];
        [imageView setHidden:NO];
        [_searchRadioImage setHidden:YES];
    }
    else{
        [imageView setHidden:YES];
        [asyncImage setHidden:NO];
        [_searchRadioImage setHidden:NO];
        [_searchRadioImage setImageWithURL:[NSURL URLWithString:strPosterUrl]];
        
    }
    
    
    CGRect searchRadioImageFrame = _searchRadioImage.frame;
    CGFloat searchRadioImageFrameMaxX = CGRectGetMaxX(searchRadioImageFrame);
    CGFloat searchRadioImageFrameMaxY = CGRectGetMaxY(searchRadioImageFrame);
    
    CGFloat radioPlayBtnXpos =_searchRadioImage.frame.origin.x;
    CGFloat radioPlayBtnYpos =searchRadioImageFrameMaxY+10;//_searchRadioImage.frame.origin.y+_searchRadioImage.frame.size.height+15;
    CGFloat radioPlayBtnWidth =_searchRadioImage.frame.size.width;
    [_searchRadioPlayButton setFrame:CGRectMake(radioPlayBtnXpos,radioPlayBtnYpos, radioPlayBtnWidth, 40)];
   

    CGFloat radioDetailMainLabelXpos =searchRadioImageFrameMaxX+10;//_searchRadioImage.frame.origin.x+_searchRadioImage.frame.size.width+10;
    CGFloat radioDetailMainLabelWidth =SCREEN_WIDTH-(searchRadioImageFrameMaxX-10);
    [_SearchRadioTitle setFrame:CGRectMake(radioDetailMainLabelXpos,40, radioDetailMainLabelWidth, 30)];
    
    CGRect  searchRadioTitleFrame = _SearchRadioTitle.frame;
    CGFloat searchRadioTitleFrameMaxY = CGRectGetMaxY(searchRadioTitleFrame);

    
    CGFloat radioDetailTextViewXpos =searchRadioImageFrameMaxX+10;//_searchRadioImage.frame.origin.x+_searchRadioImage.frame.size.width+10;
    CGFloat radioDetailTextViewWidth =SCREEN_WIDTH-(radioDetailTextViewXpos+_searchRadioImage.frame.origin.x);
    
    
    CGRect descriptionRect = [strDes boundingRectWithSize:CGSizeMake(radioDetailTextViewWidth-10, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: _descriptionDataLabel.font}
                                                        context:nil];
    
    [_descriptionDataLabel setFrame:CGRectMake(radioDetailTextViewXpos,searchRadioTitleFrameMaxY+5, radioDetailTextViewWidth, descriptionRect.size.height)];
    _descriptionDataLabel.numberOfLines=0;
    
    CGRect descriptionDataLabelFrame = _descriptionDataLabel.frame;
    CGFloat descriptionDataLabelFrameMaxY = CGRectGetMaxY(descriptionDataLabelFrame);
    CGFloat descCommonWidth =_descriptionDataLabel.frame.size.width;
   
    //SLOGAN
    [self loadSloganframe:descCommonWidth descriptionMaxY:descriptionDataLabelFrameMaxY strSloganData:strSlogan];
    
    //ADDRESS
    [self loadAddressFrame:descCommonWidth strAddressData:strAdd];
    
    //PHONE
    [self loadPhoneFrame:descCommonWidth];
    
    //EMAIL
    [self loadEmailFrame:descCommonWidth strEmailData:strEmail];
    
    CGRect emailDataLabelFrame = emailDataLabel.frame;
    CGFloat emailDataLabelFrameMaxY = CGRectGetMaxY(emailDataLabelFrame);
    
    [_radioFullScrollView setContentSize:CGSizeMake(0,(emailDataLabelFrameMaxY+10))];
}
#pragma mark - loadSloganframe
-(void)loadSloganframe:(CGFloat)descCommonWidth descriptionMaxY:(CGFloat)descriptionDataLabelFrameMaxY strSloganData:(NSString*)strSlogan {
    
    CGFloat radioDetailSloganTitleXpos = _descriptionDataLabel.frame.origin.x;
    CGFloat radioDetailSloganTitleYpos = descriptionDataLabelFrameMaxY+10;
    
    
    [_searchRadioSlogan setFrame:CGRectMake(radioDetailSloganTitleXpos,radioDetailSloganTitleYpos, descCommonWidth/4, 40)];
    
    CGRect searchRadioSloganFrame = _searchRadioSlogan.frame;
    CGFloat searchRadioSloganFrameMaxX = CGRectGetMaxX(searchRadioSloganFrame);
    
    CGFloat radioDetailSloganLabelXpos = searchRadioSloganFrameMaxX;
    CGFloat radioDetailSloganLabelYpos=_searchRadioSlogan.frame.origin.y;
    CGFloat radioDetailSloganLabelWidth=descCommonWidth-_searchRadioSlogan.frame.size.width;
    
    CGRect sloganDataRect = [strSlogan boundingRectWithSize:CGSizeMake(radioDetailSloganLabelWidth, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: _descriptionDataLabel.font}
                                                    context:nil];
    
    CGFloat radioDetailSloganLabelHeight = sloganDataRect.size.height;
    
    if(radioDetailSloganLabelHeight<40){
        radioDetailSloganLabelHeight=40;
    }
    
    [_sloganData setFrame:CGRectMake(radioDetailSloganLabelXpos,radioDetailSloganLabelYpos,radioDetailSloganLabelWidth ,radioDetailSloganLabelHeight)];
     _sloganData.numberOfLines = 0;
}

#pragma mark - loadAddressFrame
-(void)loadAddressFrame:(CGFloat)descCommonWidth strAddressData:(NSString*)strAdd {
    CGRect sloganDataFrame = _sloganData.frame;
    CGFloat sloganDataFrameMaxY = CGRectGetMaxY(sloganDataFrame);
    CGFloat radioDetailSloganLabelWidth=descCommonWidth-_searchRadioSlogan.frame.size.width;
    
    CGFloat radioDetailAddTitleXpos = _descriptionDataLabel.frame.origin.x;
    CGFloat radioDetailAddTitleYpos = sloganDataFrameMaxY+10;
    
    [_searchRadioAddress setFrame:CGRectMake(radioDetailAddTitleXpos,radioDetailAddTitleYpos, descCommonWidth/4, 40)];
    
    
    CGRect searchRadioAddressFrame = _searchRadioAddress.frame;
    CGFloat searchRadioAddressFrameMaxX = CGRectGetMaxX(searchRadioAddressFrame);
    
    CGFloat radioDetailAddLabelXpos = searchRadioAddressFrameMaxX;
    CGFloat radioDetailAddLabelYpos = _searchRadioAddress.frame.origin.y;
    CGFloat addressDataWidth = descCommonWidth-_searchRadioAddress.frame.size.width;
    
    CGRect addressDataRect = [strAdd boundingRectWithSize:CGSizeMake(radioDetailSloganLabelWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: _descriptionDataLabel.font}
                                                  context:nil];
    
    CGFloat addressDataHeight = addressDataRect.size.height;
    
    if(addressDataHeight<40){
        addressDataHeight=40;
    }
    
    [_addressData setFrame:CGRectMake(radioDetailAddLabelXpos,radioDetailAddLabelYpos,addressDataWidth ,addressDataHeight)];
     _addressData.numberOfLines = 0;
}

#pragma mark - loadPhoneFrame
-(void)loadPhoneFrame:(CGFloat)descCommonWidth
{
    CGRect addressDataFrame = _addressData.frame;
    CGFloat addressDataFrameMaxY = CGRectGetMaxY(addressDataFrame);
    CGFloat radioDetailPhoneTitleXpos = _descriptionDataLabel.frame.origin.x;
    CGFloat radioDetailPhoneTitleYpos = addressDataFrameMaxY+10;
    
    [_searchRadioPhone setFrame:CGRectMake(radioDetailPhoneTitleXpos,radioDetailPhoneTitleYpos, descCommonWidth/4, 30)];
    
    CGRect searchRadioPhoneFrame = _searchRadioPhone.frame;
    CGFloat searchRadioPhoneFrameMaxX = CGRectGetMaxX(searchRadioPhoneFrame);
    
    CGFloat radioDetailPhoneLabelXpos = searchRadioPhoneFrameMaxX;
    CGFloat radioDetailPhoneLabelYpos = _searchRadioPhone.frame.origin.y;
    CGFloat radioDetailPhoneLabelWidth = descCommonWidth-_searchRadioPhone.frame.size.width;
    [_phoneData setFrame:CGRectMake(radioDetailPhoneLabelXpos,radioDetailPhoneLabelYpos, radioDetailPhoneLabelWidth , 30)];
}

#pragma mark - loadEmailFrame
-(void)loadEmailFrame:(CGFloat)descCommonWidth strEmailData:(NSString*)strEmail{
    
    CGFloat emailTitleLabelXpos = _descriptionDataLabel.frame.origin.x;
    CGFloat emailTitleLabelYpos =_searchRadioPhone.frame.origin.y+_searchRadioPhone.frame.size.height;
    [emailTitleLabel setFrame:CGRectMake(emailTitleLabelXpos,emailTitleLabelYpos, descCommonWidth/4, 30)];
    
    CGFloat emailDataLabelXpos =  emailTitleLabel.frame.origin.x+
    emailTitleLabel.frame.size.width;
    CGFloat emailDataLabelYpos =  emailTitleLabel.frame.origin.y;
    CGFloat emailDataLabelWidth =  descCommonWidth -emailTitleLabel.frame.size.width;
    
    CGRect emailDataLabelRect = [strEmail boundingRectWithSize:CGSizeMake(emailDataLabelWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: _descriptionDataLabel.font}
                                                  context:nil];
    
    CGFloat emailDataLabelHeight = emailDataLabelRect.size.height;
    
    if(emailDataLabelHeight<40){
        emailDataLabelHeight=40;
    }
    
    [emailDataLabel setFrame:CGRectMake(emailDataLabelXpos,emailDataLabelYpos, emailDataLabelWidth , emailDataLabelHeight)];
    
    [emailTitleLabel setText:@"Email:"];
    [emailDataLabel setText:strEmail];
    emailDataLabel.numberOfLines = 0;
    [emailTitleLabel setTextColor:[UIColor whiteColor]];
    [emailDataLabel setTextColor:[UIColor whiteColor]];
}

#pragma mark -addRadioLoadingIcon
-(void) addRadioLoadingIcon{
    //spinner, not animated unless we are setting an icon
    radioLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((searchRadioView.frame.size.width/2.2), (searchRadioView.frame.size.height/2.2), 30, 30)];
    radioLoadingView.backgroundColor = [UIColor clearColor];
    radioLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [radioLoadingView setHidesWhenStopped:TRUE];
    radioLoadingView.contentMode = UIViewContentModeCenter;
    [radioLoadingView startAnimating];
    [searchRadioView addSubview:radioLoadingView];
}

-(void) removeRadioLoadingIcon{
    [radioLoadingView removeFromSuperview];
}

#pragma mark - setUpRadioStation
-(void)setUpRadioStation{
    NSString* strCheckPlayerUrl;
    if ((NSString *)[NSNull null] == playerUrl) {
        strCheckPlayerUrl=@"";
    } else {
        strCheckPlayerUrl= playerUrl;
    }
    
    radio = [[Radio alloc] initWithUserAgent:@"my radio"];
    [radio connect:playerUrl withDelegate:self withGain:(1.0)];
    
}
#pragma mark - searchRadioPlayBtnAction
- (void)searchRadioPlayBtnAction:(id)sender {
    if(playing)
    {
        [self setUpRadioStation];
        [self addRadioLoadingIcon];
        playing = NO;
        [_searchRadioPlayButton setTitle:@"STOP" forState:UIControlStateNormal];
        [_searchRadioPlayButton setBackgroundColor:[UIColor colorWithRed:164.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
        [radio updatePlay:YES];
    }
    else
    {
        playing = YES;
        [radio updatePlay:NO];
        [_searchRadioPlayButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [_searchRadioPlayButton setBackgroundColor:[UIColor colorWithRed:164.0/255.0f green:205.0/255.0f blue:102.0/255.0f alpha:1]];
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

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self removeRadioLoadingIcon];
    
}

#pragma mark -Rotate View
-(void) rotateViews:(BOOL) bPortrait{
    [self removeRadioLoadingIcon];
    
    [_SearchRadioTitle setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioSlogan setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_sloganData setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioAddress setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_addressData setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioPhone setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_phoneData setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioDescription setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_descriptionData setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_descriptionDataLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioPlayButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioImage setTranslatesAutoresizingMaskIntoConstraints:YES];
    [emailTitleLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [emailDataLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_searchRadioDescription removeFromSuperview];
    [_searchRadioWebView setTranslatesAutoresizingMaskIntoConstraints:YES];
   
    [self loadRadioData];
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
