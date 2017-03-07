//
//  OverTheAirDetailController.m
//  SidebarDemo
//
//  Created by ocsdeveloper9 on 9/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "OverTheAirDetailController.h"
#import "AppConfig.h"
#import "AppCommon.h"
#import "TrailerMovieView.h"

@interface OverTheAirDetailController () {
    NSString *strDescriptionText;
    NSString *currentAppLanguage;
}
@property(retain,nonatomic)   TrailerMovieView *mainView;

@end

@implementation OverTheAirDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_overTheAirCollectionView1 registerNib:[UINib nibWithNibName:@"OverTheAirCustomCell" bundle:nil] forCellWithReuseIdentifier:@"OverTheAirCustomCell"];
    [_overTheAirCollectionView registerNib:[UINib nibWithNibName:@"OverTheAirCustomCell" bundle:nil] forCellWithReuseIdentifier:@"OverTheAirCustomCell"];
    [self loadValues];
    
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr;
    if(_isSling){
        titleStr =@"Premium Channels";
    }
    else{
        titleStr = @"Local HD Channels";
    }
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.navigationItem.title =titleStr;
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    [self initialSetupIpad];
    [self initialSetUp];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overTheAirOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    self.navigationItem.rightBarButtonItem = nil;
    UIDevice* homeDevice = [UIDevice currentDevice];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [_ipadView setHidden:NO];

    } else {

        if(homeDevice.orientation == UIDeviceOrientationLandscapeLeft || homeDevice.orientation == UIDeviceOrientationLandscapeRight){
            [self rotationView:false];
        }else{
            [self rotationView:true];
        }
    }

}


#pragma mark - orientationChanged
- (void) overTheAirOrientationChanged:(NSNotification *) note {
    [self loadValues];
    UIDevice * devie = note.object;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [_ipadView setHidden:NO];

    } else {
    
        switch (devie.orientation) {
            case UIDeviceOrientationPortrait:
                //   case UIDeviceOrientationPortraitUpsideDown:
                [self rotationView:true];
                
                
                break;
                
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                [self rotationView:false];
                
                break;
                
            default:
                break;
        }
    }

}
- (void) loadValues {
    if(_isSling) {
        strDescriptionText = @"Sling TV lets stream your favourite live shows and on-demand entertainment, without you want top feature like video reply, and the freedom to cancel easily online - all for a simple low price for $20/mo.";
        collectionArray = @[@"abc",@"adult",@"ae",@"amc",@"bloomberg",@"cn",@"cnn",@"disney",@"elrey",@"espn",@"espn2",@"food",@"golovision",@"h2",@"hgtv",@"history",@"ifc",@"lifetime",@"maker",@"polaris",@"tbs",@"tnt",@"travel"];
        
    } else {
        strDescriptionText = @"Are you of playing expense cable and satellite bills every month?Now watch all your favourite broadcast network shows-for free";
        collectionArray = @[@"abc_hd",@"cw",@"fox",@"hd",@"my_tv",@"nbc",@"pbs",@"univision"];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotationView:(BOOL) bPortrait {
    if(bPortrait) {
        [_ipadView setHidden:YES];
        [self initialSetUp];

    }else {
        [_ipadView setHidden:NO];
        [self initialSetupIpad];
    }


}

- (void)initialSetUp {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    _ipadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    [_mainScrollView setBackgroundColor:[UIColor clearColor]];
    [_overTheAirCollectionView setBackgroundColor:[UIColor clearColor]];
    if(_isSling) {
        [_headerLabel setText:@"Sling TV"];
        [_headerImageView setImage:[UIImage imageNamed:@"sling"]];
        [_trialButton setTitle:@"Start Free Trial" forState:UIControlStateNormal];
        //_urlString = @"http://selecttv.com/landing/free-antenna";
        _urlString =  @"http://www.kqzyfj.com/click-7506458-12175633-1441920147000";

    } else {
        [_headerLabel setText:@"HD Digital Antenna"];
        [_headerImageView setImage:[UIImage imageNamed:@"ant"]];
        [_trialButton setTitle:@"Get it Now" forState:UIControlStateNormal];
        _urlString = @"http://www.anrdoezrs.net/click-7506458-12167665-1441920147000";

    }
    [_trialButton setBackgroundImage:[UIImage imageNamed:@"orangeBtn"] forState:UIControlStateNormal];
    [[_watchVideoButton layer] setBorderColor:[[[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f]  colorWithAlphaComponent:0.5] CGColor]];
    [[_watchVideoButton layer] setBorderWidth:2.5f];
    [[_watchVideoButton layer] setCornerRadius:2.0f];
    [_watchVideoButton setTitleColor: [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    [_watchVideoButton setTitle:@"Watch Video" forState:UIControlStateNormal];
    _watchVideoButton.titleLabel.font = OpenSans_Regular(24);
    [_watchVideoButton addTarget:self
                          action:@selector(onTrailerShow:)
                forControlEvents:UIControlEventTouchUpInside];
    [_trialButton addTarget:self
                      action:@selector(openLinkAction:)
            forControlEvents:UIControlEventTouchUpInside];

    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descLabel.numberOfLines = 0;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        
        [_headerLabel setFont:OpenSans_Regular(26)];
        [_descLabel setFont:OpenSans_Regular(22)];

    } else {

        [_headerLabel setFont:OpenSans_Regular(20)];
        [_descLabel setFont:OpenSans_Regular(16)];
    }
    [_descLabel setText:strDescriptionText];
    [_descLabel setTextColor:[UIColor whiteColor]];
    [_headerLabel setTextColor:[UIColor whiteColor]];
    [_descLabel sizeToFit];
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);

    CGSize expectedLabelSize = [strDescriptionText sizeWithFont:_descLabel.font constrainedToSize:maximumLabelSize lineBreakMode:_descLabel.lineBreakMode];
    _descHeight.constant = expectedLabelSize.height+10;

    [_overTheAirCollectionView setScrollEnabled:NO];
    [self.view layoutIfNeeded];
}

- (void)initialSetupIpad {
    _ipadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    [_overTheAirCollectionView1 setBackgroundColor:[UIColor clearColor]];
    if(_isSling) {
        [_headerLabel1 setText:@"Sling TV"];
        [_headerImageView1 setImage:[UIImage imageNamed:@"sling"]];
        [_trialButton1 setTitle:@"Start Free Trial" forState:UIControlStateNormal];
        //_urlString = @"http://selecttv.com/landing/free-antenna";
       // _urlString = @"https://www.sling.com/";//NEW URL CODE
        _urlString =  @"http://www.kqzyfj.com/click-7506458-12175633-1441920147000";

    } else {
        [_headerLabel1 setText:@"HD Digital Antenna"];
        [_headerImageView1 setImage:[UIImage imageNamed:@"ant"]];
        [_trialButton1 setTitle:@"Get it Now" forState:UIControlStateNormal];
        _urlString = @"http://www.anrdoezrs.net/click-7506458-12167665-1441920147000";
    }
    [_trialButton1 setBackgroundImage:[UIImage imageNamed:@"orangeBtn"] forState:UIControlStateNormal];
    [[_watchVideoButton1 layer] setBorderColor:[[[UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f]  colorWithAlphaComponent:0.5] CGColor]];
    [[_watchVideoButton1 layer] setBorderWidth:2.5f];
    [[_watchVideoButton1 layer] setCornerRadius:2.0f];
    [_watchVideoButton1 setTitleColor: [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f] forState:UIControlStateNormal];
    [_watchVideoButton1 setTitle:@"Watch Video" forState:UIControlStateNormal];
    _descLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    _descLabel1.numberOfLines = 0;
    _watchVideoButton1.titleLabel.font = OpenSans_Regular(24);
    [_watchVideoButton1 addTarget:self
                           action:@selector(onTrailerShow:)
       forControlEvents:UIControlEventTouchUpInside];
    [_trialButton1 addTarget:self
                           action:@selector(openLinkAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        
        [_headerLabel1 setFont:OpenSans_Regular(26)];
        [_descLabel1 setFont:OpenSans_Regular(22)];
        
    } else {
        
        [_headerLabel1 setFont:OpenSans_Regular(20)];
        [_descLabel1 setFont:OpenSans_Regular(16)];
    }

    [_descLabel1 setText:strDescriptionText];
    [_descLabel1 setTextColor:[UIColor whiteColor]];
    [_headerLabel1 setTextColor:[UIColor whiteColor]];
    [_descLabel1 sizeToFit];
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    
    CGSize expectedLabelSize = [strDescriptionText sizeWithFont:_descLabel.font constrainedToSize:maximumLabelSize lineBreakMode:_descLabel.lineBreakMode];
    _descHeight.constant = expectedLabelSize.height;
    [_overTheAirCollectionView1 setScrollEnabled:NO];
    [self.view layoutIfNeeded];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    _collectionHeight.constant = _overTheAirCollectionView.contentSize.height;
    _collectionHeight1.constant = _overTheAirCollectionView1.contentSize.height;
    [self.view layoutIfNeeded];
}

- (void)onTrailerShow:(id)sender {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TrailerMovieView" owner:self options:nil];
    NSLog(@"subviewArray%@",subviewArray);
    _mainView = [subviewArray objectAtIndex:0];
    
    [self watchAction];
}
- (void)onTrailerShowIpad:(id)sender {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TrailerMovieView" owner:self options:nil];
    NSLog(@"subviewArray%@",subviewArray);
    _mainView = [subviewArray objectAtIndex:0];
    
    [self watchAction];
}
- (void)openLinkAction:(id)sender {
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *ourPath = _urlString;
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    [ourApplication openURL:ourURL];
}

- (void)watchAction {
    NSMutableArray *linksTrailer = [NSMutableArray new];
    if(_isSling){
        [linksTrailer addObject: @"http://www.guidebox.com/embed.php?video=1KzYpvXrLL4"];
    }
    
    else{
        [linksTrailer addObject: @"http://www.guidebox.com/embed.php?video=ZM0j2ZSLm1w"];
    }
    

    [_mainView setTrailers:linksTrailer];
    NSLog(@"self.linksTrailer%@",linksTrailer);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frameView = [_mainView frame];
    CGFloat widthView = frameView.size.width;
    CGFloat heightView = frameView.size.height;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        widthView = 500;
        heightView = 500;
    }
    CGFloat x_Pos = (screenWidth - widthView)/2;
    CGFloat y_Pos = (screenHeight - heightView)/2;
    [self.view addSubview:_mainView];
    frameView = CGRectMake(x_Pos, y_Pos, widthView, heightView);
    [_mainView setFrame:frameView];
    [_mainView startPlay];

}

#pragma mark - UICollectionView Datasource & Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(_isSling)
       return 5.0;
    else
        return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(_isSling)
       return 5.0;
    else
        return 20.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_isSling)
        return CGSizeMake(55, 25);
    else
        return CGSizeMake(60, 30);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [collectionArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     OverTheAirCustomCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OverTheAirCustomCell" forIndexPath:indexPath];
    [cell.tvImageView setImage:[UIImage imageNamed:[collectionArray objectAtIndex:indexPath.row]]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;

}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
