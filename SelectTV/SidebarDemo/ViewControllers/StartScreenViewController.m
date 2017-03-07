//
//  StartScreenViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 05/03/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "StartScreenViewController.h"
#import "PWParallaxScrollView.h"
#import "IntroViewController.h"
#import "SWRevealViewController.h"
#import "AppCommon.h"
#import "AppDelegate.h"

@interface StartScreenViewController ()<PWParallaxScrollViewDataSource,PWParallaxScrollViewDelegate, SWRevealViewControllerDelegate>

{
    SWRevealViewController *revealViewController;
    NSInteger indexPageValue;
    NSInteger CurrentPageIndex;
    UIButton *letsDossome;
    NSMutableDictionary *dictItem;
}
@property (nonatomic, strong) PWParallaxScrollView *scrollView;

@end

@implementation StartScreenViewController
@synthesize mainImageArry,mainImageView,arrowBtn,stringImageView,textImageArray,arrowImageArray;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
     dictItem = [[NSMutableDictionary alloc]init];
    
    if ([COMMON isUserFirstTimeLoggedIn]) {
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SplashScreenImage"]];
        [self pushToIntro];
    }
    else{
        
        
        
        
        
        self.edgesForExtendedLayout=UIRectEdgeNone;
        //self.automaticallyAdjustsScrollViewInsets=NO;
        mainImageArry = [[NSMutableArray alloc]initWithObjects:@"selectTV",@"liveChannel",@"tvImage",@"movies",@"radio",@"countries", nil];
        
        textImageArray = [[NSMutableArray alloc]initWithObjects:@"welcome",@"live_channels",@"tv_epidoes",@"moviestext",@"radio_stations",@"country_text", nil];
        
        arrowImageArray = [[NSMutableArray alloc]initWithObjects:@"blueArrow",@"livechannelsarrow",@"tv_arrow",@"movies_arrow",@"radio_arrow",@"radio_arrow", nil];
        
        [self initControl];
        [self reloadData];
        [self createButton];
        
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.revealViewController.delegate = self;
//    
//    [self.revealViewController tapGestureRecognizer];
//    
//    [self.revealViewController panGestureRecognizer];
//    
//     self.revealViewController.panGestureRecognizer.enabled=NO;
    
}

#pragma mark - Gesture Delegate Methods
- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    
    return YES;//NO
    
}
- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;//NO
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
    pgDtView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - ((([mainImageArry count]-1) * 30)/2) + 8 , 75, ([mainImageArry count]-1) * 30, 19)];
    
    pgDtView.backgroundColor = [UIColor clearColor];
    return [mainImageArry count];
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    sampletest=[[UIView alloc]init];
    viewImages=[[UIView  alloc]init];
    
    if ( index ==0) {
        viewImages.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:133.0/255.0 blue:238.0/255.0 alpha:1.0];
        
    }
    if ( index ==1) {
        viewImages.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:184.0/255.0 blue:113.0/255.0 alpha:1.0];
        
    }
    if ( index ==2) {
        viewImages.backgroundColor=[UIColor colorWithRed:162.0/255.0 green:137.0/255.0 blue:218.0/255.0 alpha:1.0];
        
    }
    if ( index ==3) {
        viewImages.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:217.0/255.0 blue:139.0/255.0 alpha:1.0];
        
    }
    if ( index ==4) {
        viewImages.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
        
    }
    if ( index ==5) {
        viewImages.backgroundColor=[UIColor colorWithRed:28.0/255.0 green:133.0/255.0 blue:238.0/255.0 alpha:1.0];
        
    }
    
    viewImages.frame=CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height/2);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:mainImageArry[index]]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
        imageView.frame=CGRectMake(viewImages.frame.origin.x+160, viewImages.frame.origin.y+40, viewImages.frame.size.width-330, viewImages.frame.size.height-85);
    }
    else{
        imageView.frame=CGRectMake(viewImages.frame.origin.x+50, viewImages.frame.origin.y+30, viewImages.frame.size.width-96, viewImages.frame.size.height-60);
    }
    
    [viewImages addSubview:imageView];
    [sampletest addSubview:viewImages];
    
    return sampletest;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UIView *foregroundView=[[UIView alloc]init];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
        stringImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height - viewImages.frame.size.height)];
        [stringImageView setImage:[UIImage imageNamed:textImageArray[index]]];

        
    }
    else{
        stringImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height - viewImages.frame.size.height)];
        [stringImageView setImage:[UIImage imageNamed:textImageArray[index]]];
    }
    [foregroundView addSubview:stringImageView];
    return foregroundView;
}

-(void)doSomethingButton
{
    letsDossome =  [[UIButton alloc]init];
    [letsDossome addTarget:self action:@selector(letsDoThis:) forControlEvents:UIControlEventTouchUpInside];
    [letsDossome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //letsDossome.backgroundColor=[UIColor redColor];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
//        [letsDossome setFrame:CGRectMake((self.view.frame.size.width/2)-200,stringImageView.frame.origin.y-170,400, 90)];
        [letsDossome setFrame:CGRectMake((self.view.frame.size.width/3)-20,self.view.frame.size.height-60 ,(self.view.frame.size.width/3)+38,self.view.frame.origin.y-85)];
        
        
    }
    else{
        [letsDossome setFrame:CGRectMake(stringImageView.frame.origin.x+130,stringImageView.frame.size.height+stringImageView.frame.size.height-40,self.view.frame.size.width-250, stringImageView.frame.size.height-self.view.frame.size.width-5)];
        letsDossome.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    [self.view addSubview:letsDossome];
    
}

-(void)createButton
{
    
    arrowBtn = [[UIButton alloc]init];
    [arrowBtn addTarget:_scrollView action:@selector(didClickOkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [arrowBtn setFrame:CGRectMake(stringImageView.frame.origin.x+self.view.frame.size.width-45,(viewImages.frame.origin.y+viewImages.frame.size.height-50),-90,-90)];
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"blueArrow"] forState:UIControlStateNormal];
    //arrowBtn.backgroundColor=[UIColor redColor];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
        //[arrowBtn setFrame:CGRectMake(stringImageView.frame.origin.x+self.view.frame.size.width-45,(viewImages.frame.origin.y+viewImages.frame.size.height+600),-90,-90)];
        [arrowBtn setFrame:CGRectMake((self.view.frame.size.width/2)+(stringImageView.frame.size.width/2)-140,self.view.frame.size.height-140,90,90)];
    }
    else{
        [arrowBtn setFrame:CGRectMake(stringImageView.frame.origin.x+self.view.frame.size.width-20,self.view.frame.size.height -30,stringImageView.frame.size.width-self.view.frame.size.width-40, stringImageView.frame.size.height-self.view.frame.size.width-10)];
    }
    [self.view addSubview:arrowBtn];
    
}
#pragma mark - PWParallaxScrollViewDelegate

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
{
    if (index !=4 ) {
    }
    Currentindex = index;
    
    if (index==0) {
        [arrowBtn setHidden:NO];
        [letsDossome setHidden:YES];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"blueArrow"] forState:UIControlStateNormal];
        
    }
    if (index==1) {
        [arrowBtn setHidden:NO];
        [letsDossome setHidden:YES];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"livechannelsarrow"] forState:UIControlStateNormal];
    }
    
    if (index==2) {
        [arrowBtn setHidden:NO];
        [letsDossome setHidden:YES];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"tv_arrow"] forState:UIControlStateNormal];
        
    }
    
    if (index==3) {
        [arrowBtn setHidden:NO];
        [letsDossome setHidden:YES];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"movies_arrow"] forState:UIControlStateNormal];
        
    }
    
    if (index==4) {
        [arrowBtn setHidden:NO];
        [letsDossome setHidden:YES];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"radio_arrow"] forState:UIControlStateNormal];
        
    }
    if (index==5) {
        [arrowBtn setHidden:YES];
        [letsDossome setHidden:NO];
        //[arrowBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self doSomethingButton];
        
    }
    
}

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
    
    Currentindex = index;
    
    if (index == [mainImageArry count] - 1 && flag == 1) {
        
    }
    else if (index == [mainImageArry count] - 2) {
        flag = 1;
        [pgDtView setHidden:NO];
   
    }
    else{
        flag = 0;
        [pgDtView setHidden:NO];
    }
}

#pragma mark - view's life cycle

- (void)initControl
{
    self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];
    
    self.scrollView.isdifferSpeed = YES;
    
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)reloadData
{
    _scrollView.delegate = self;
    _scrollView.dataSource = self;
}

-(void)letsDoThis:(UIButton*) button
{
    [self.navigationController.navigationBar setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    IntroViewController *viewController = (IntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
//    [self.navigationController pushViewController:viewController animated:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self presentViewController:viewController animated:NO completion:nil];
    
    NSString *start =@"YES";
    [dictItem setValue:start forKey:STARTPAGE];
    [COMMON setDetails:dictItem];
   
}
- (void)pushToIntro{
    [self.navigationController.navigationBar setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    IntroViewController *viewController = (IntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    [self.navigationController pushViewController:viewController animated:NO];
}


#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
