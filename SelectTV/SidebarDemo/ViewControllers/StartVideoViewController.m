//
//  StartVideoViewController.m
//  SidebarDemo
//
//  Created by Karthikeyan on 27/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "StartVideoViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"

@interface StartVideoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startWtng;

@end

@implementation StartVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startWtng.backgroundColor = [UIColor clearColor];
    _startWtng.layer.borderColor = [UIColor whiteColor].CGColor;
    _startWtng.layer.borderWidth = 2;
    _startWtng.layer.cornerRadius = 4.0;
    _startWtng.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];

    
    
    _splashLogoImage.image =[UIImage imageNamed:splashLogoImageName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:theMoviPlayer];
    
    
    // Do any additional setup after loading the view.
}


- (IBAction)btnLoginTapped:(id)sender {
    [self pushToLoginScreen];
//    [self.navigationController.navigationBar setHidden:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    
//    SWRevealViewController *sideBar = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    
//    
//    [self.navigationController pushViewController:sideBar animated:YES];
    
}

- (void) hidecontrol {
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:theMoviPlayer];
    [theMoviPlayer setControlStyle:MPMovieControlStyleFullscreen];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    CGFloat welcomeFontSize  = 24;
    
    if([self isDeviceIpad]==YES){
        
        welcomeFontSize  = 20;
    }
    
    
    _splashLogoImage.image =[UIImage imageNamed:splashLogoImageName];
    
    NSString * welcomeStr =[NSString stringWithFormat:@"Welcome to %@",APP_TITLE];
    _introOneWelcomeLabel.text = welcomeStr;
    _introOneWelcomeLabel.textAlignment = NSTextAlignmentCenter;
    //_introOneWelcomeLabel.lineBreakMode =NSLineBreakByWordWrapping;
    //_introOneWelcomeLabel.numberOfLines = 2;
    _introOneWelcomeLabel.font = [COMMON getResizeableFont:Roboto_Bold(welcomeFontSize)];
    _introOneWelcomeLabel.textColor = [UIColor whiteColor];
    
    
    
    [self.navigationController.navigationBar setHidden:YES];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"540x960" ofType:@"mp4"];
    NSURL *movieURL = [[NSURL alloc] initFileURLWithPath:moviePath];
    
    //new change
   // NSURL *movieNewURL = [NSURL URLWithString:@"http://freecast.s3.amazonaws.com/Videos/Welcome.mp4"];
    
    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    theMoviPlayer.controlStyle = MPMovieControlStyleNone;
    // theMoviPlayer.view.transform = CGAffineTransformConcat(theMoviPlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    //UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    [theMoviPlayer.view setFrame:self.view.frame];
    //[backgroundWindow addSubview:theMoviPlayer.view];
    
    [theMoviPlayer.view setContentMode:UIViewContentModeScaleToFill];//UIViewContentModeScaleAspectFill
    [theMoviPlayer setRepeatMode:MPMovieRepeatModeOne];
    theMoviPlayer.shouldAutoplay = YES;
    [self.view insertSubview:theMoviPlayer.view belowSubview:contentScrollView];
    //[self.view addSubview:theMoviPlayer.view];
    [theMoviPlayer play];
    
    //int xCor = 0;
    
    [contentScrollView setDelegate:self];
    
    [introTwo setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [contentScrollView addSubview:introTwo];
    
    [introOne setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [contentScrollView addSubview:introOne];
    
    [introThree setFrame:CGRectMake(2*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [contentScrollView addSubview:introThree];
    
    [contentScrollView setContentSize:CGSizeMake(3*self.view.frame.size.width, self.view.frame.size.height)];
    
    [pageControll setNumberOfPages:3];
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    
    
}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [theMoviPlayer stop];
    [myTimer invalidate];
    myTimer = nil;
    [theMoviPlayer stop];
    [theMoviPlayer.view removeFromSuperview];
}

-(void)changePage{
    
    
    int whichNo = pageControll.currentPage;
    
    if (whichNo==2) {
        whichNo = -1;
    }
    [contentScrollView setContentOffset:CGPointMake(self.view.frame.size.width*(whichNo+1), 0) animated:YES];
    
    
}

- (IBAction)pageChanged:(id)sender {
    CGFloat x = pageControll.currentPage * contentScrollView.frame.size.width;
    [contentScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControll.currentPage = page; // you need to have a **iVar** with getter for pageControl
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [myTimer invalidate];
    myTimer = nil;
    [theMoviPlayer stop];
    [theMoviPlayer.view removeFromSuperview];
}

#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    
    [self.navigationController.navigationBar setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController *viewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:viewController animated:NO];

}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    
}




@end
