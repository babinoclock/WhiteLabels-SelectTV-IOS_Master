//
//  LoginViewController.m
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "LoginViewController.h"
#import "RabbitTVManager.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "ForgotPasswordViewController.h"
#import "StartScreenViewController.h"
#import "IntroViewController.h"

@interface LoginViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString * currentAppLanguage;
    NSString *signUpStr;
    NSString *signUpStrPart_One;
    NSString *signUpStrPart_Two;
    NSString *helpStr;
    NSString *helpStrPart_One;
    NSString *helpStrPart_Two;
    
    UIView *helpAlert;
    
    UIAlertView *alert;
    
}

@end

@implementation LoginViewController

@synthesize loginBtn,forgotPwdBtn,createAccBtn,signUpLabel,helpLabel,helpBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *loginStr = @"Login";
    if([COMMON isSpanishLanguage]==YES){
        loginStr =  [COMMON stringTranslatingIntoSpanish:loginStr];
    }

    self.title = loginStr;
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginSuccessFull"];
    [[NSUserDefaults standardUserDefaults] synchronize];

//    screenWidth = [UIScreen mainScreen].bounds.size.width;
//    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self showCreateAccBtn];
   
    [_loginLabel setHidden:YES];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
    
}
#pragma mark orientationChanged
-(void) loginOrientationChanged:(NSNotification *) note
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
    
    screenWidth = SCREEN_WIDTH;
    screenHeight = SCREEN_HEIGHT;
    
    [self setImageViewFrame];
    [self setUpViews];
    
    
    if(bPortrait){
       
       
    }
    else{
        
    
    }

}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setUpViews];
 //   [self setImageViewFrame];
    
    

    
}
#pragma mark - setImageViewFrame
-(void)setImageViewFrame{
    [topImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGFloat topViewXPos;
    CGFloat topViewYPos;
    CGFloat topViewWidth;
    CGFloat topViewHeight;
    
    NSString *appTitle = APP_TITLE;
    
    if([appTitle isEqualToString:@"SmartCity"]){
        if([self isDeviceIpad]!=YES){
            
            topViewWidth= screenWidth/5;
        }
        else{
            
            topViewWidth= screenWidth/8;
            
        }
    }
    else{
        if([self isDeviceIpad]!=YES){
            
            topViewWidth= screenWidth/2.1;//free cast//5
        }
        else{
            
            topViewWidth= screenWidth/4; //free cast//8
            
        }
    }
    
//   
//    topViewXPos = (screenWidth/2)-(topViewWidth/2);
//    topViewYPos = 40;
//    topViewHeight = 62;//55
//    
//    [topImageView setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
//    topImageView.image =[UIImage imageNamed:homeLogoImageName];//homeLogo
//    topImageView.backgroundColor = [UIColor redColor];
//    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    
     UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            topViewXPos = (screenWidth/1.8)-(topViewWidth/1.8);
            topViewYPos = 40;
            topViewHeight = 62;//55
            topViewWidth= screenWidth/2.5;
           
        }
        else{
           
            topViewXPos = (screenWidth/2)-(topViewWidth/2);
            topViewYPos = 40;
            topViewHeight = 62;//55
            topViewWidth= screenWidth/2.5;
        }
    }else{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            topViewXPos = (screenWidth/2)-(topViewWidth/2);
                topViewYPos = 40;
                topViewHeight = 62;///55
            
                  }
        else{
            
            topViewXPos = (screenWidth/2)-(topViewWidth/2);
            topViewYPos = 40;
            topViewHeight = 62;//55

            
                    }
    }

    
    
    topImageView.image =[UIImage imageNamed:homeLogoImageName];//homeLogo
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topImageView setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
    
    

}

#pragma mark - setUpViews
-(void) setUpViews{
    
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        //[self IPhoneFrame];
         createAccBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(14)];
    }
    else{
       // [self IPadFrame];
        createAccBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(17)];

    }
   [self IPadFrame];
   
    [self setUpSignUpLabels];
    
    NSString *emailStr =@"Email";
    NSString *pwdStr =@"Password";
    NSString *loginBtnStr =@"LOGIN";
    NSString *forgetBtnStr =@"Forgot your Password?";
    
    if([COMMON isSpanishLanguage]==YES){
        emailStr =  [COMMON stringTranslatingIntoSpanish:emailStr];
        pwdStr =    [COMMON stringTranslatingIntoSpanish:pwdStr];
        loginBtnStr =  [COMMON stringTranslatingIntoSpanish:loginBtnStr];
        forgetBtnStr =  [COMMON stringTranslatingIntoSpanish:forgetBtnStr];
    }
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailTF.leftView = paddingView;
    emailTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passwordTF.leftView = paddingView1;
    passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    emailTF.textColor = [UIColor blackColor];
    passwordTF.textColor = [UIColor blackColor];
    
    emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    loginBtn.layer.cornerRadius = 4.0f;
    loginBtn.clipsToBounds = YES;
//new
    loginBtn.backgroundColor = GRAY_BG_COLOR;
    
    [emailTF setFont:[COMMON getResizeableFont:OpenSans_Regular(14)]];
    [passwordTF setFont:[COMMON getResizeableFont:OpenSans_Regular(14)]];
    //loginBtn.titleLabel.font= [COMMON getResizeableFont:OpenSans_Regular(14)];
    //forgotPwdBtn.titleLabel.font= [COMMON getResizeableFont:OpenSans_Regular(14)];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, emailTF.frame.size.height-1.0f, emailTF.frame.size.width, 1.0)];
    
    //[emailTF addSubview:bottomEmail];
    
    UIView *bottomPassword  = [[UIView alloc] initWithFrame:CGRectMake(0, passwordTF.frame.size.height-1.0f, passwordTF.frame.size.width, 1.0)];
    
    //[passwordTF addSubview:bottomPassword];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    [bottomPassword setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    bottomPassword.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [loginBtn addTarget:self action:@selector(loginAciton:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:loginBtnStr forState:UIControlStateNormal];
    [forgotPwdBtn setTitle:forgetBtnStr forState:UIControlStateNormal];

    loginBtn.titleLabel.text = loginBtnStr;
    forgotPwdBtn.titleLabel.text = forgetBtnStr;
    forgotPwdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
-(void)setUpSignUpLabels{
    //[signUpLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [helpLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [helpBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
   // [self setFrameForSignUpLabel];
    
    [self setFrameForTheNeedHelp];
    
}
-(void)setFrameForSignUpLabel{
    CGFloat signUpLabelXpos=0;
    CGFloat signUpLabelHeight=55;
    CGFloat signUpLabelYpos=SCREEN_HEIGHT-(signUpLabelHeight*2);
    [signUpLabel setFrame:CGRectMake(signUpLabelXpos, signUpLabelYpos, SCREEN_WIDTH, signUpLabelHeight)];
    signUpStr = @"Dont have an account? Sign up here";
    signUpStrPart_One = @"Dont have an account?";
    signUpStrPart_Two = @" Sign up here";
    
    if([COMMON isSpanishLanguage]==YES){
        signUpStr =  [COMMON stringTranslatingIntoSpanish:signUpStr];
        signUpStrPart_One =  [COMMON stringTranslatingIntoSpanish:signUpStrPart_One];
        signUpStrPart_Two =  [COMMON stringTranslatingIntoSpanish:signUpStrPart_Two];
    }
    signUpLabel.backgroundColor=[UIColor clearColor];
    signUpLabel.attributedText = [self setAttributedTextForAppNote:signUpStr];
    [signUpLabel setTextAlignment:NSTextAlignmentCenter];
    signUpLabel.tag=100;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signUpLabelAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [signUpLabel addGestureRecognizer:tapGestureRecognizer];
    signUpLabel.userInteractionEnabled = YES;
    //[self setFrameForTheNeedHelp:signUpLabel];
}
- (void)signUpLabelAction:(UITapGestureRecognizer *)tap {
//    NSString *url= @"http://selecttv.com/?utm_source=Android&amp;utm_medium=register&amp;utm_campaign=MobileSignupA";//doubt
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}
-(void)setFrameForTheNeedHelp{
    CGFloat helpLabelHeight=40;
    CGFloat helpLabelWidth=100;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        helpLabelWidth = 110;//110
        
        if([COMMON isSpanishLanguage]==YES){
            helpLabelWidth =200;
        }
    }
    
    //CGRect signUpLabelRect = signUpLabelFrame.frame;
    //CGFloat signUpLabelMaxY = CGRectGetMaxY(signUpLabelRect);
    //CGFloat helpBtnYpos=signUpLabelMaxY;
    
    CGFloat helpLabelXpos=SCREEN_WIDTH -(helpLabelWidth);
    CGFloat helpLabelYpos=screenHeight -(helpLabelHeight*2);
    [helpLabel setFrame:CGRectMake(helpLabelXpos,helpLabelYpos, helpLabelWidth, helpLabelHeight)];
    helpStr = @"Need Help?";
    
    if([COMMON isSpanishLanguage]==YES){
        helpStr =  [COMMON stringTranslatingIntoSpanish:helpStr];
    }
    helpLabel.text = helpStr;
    helpLabel.textColor =[UIColor colorWithRed:58.0f/255.0f green:156.0f/255.0f blue:219.0f/255.0f alpha:1];
    [helpLabel setTextAlignment:NSTextAlignmentLeft];
    helpLabel.backgroundColor=[UIColor clearColor];
    helpLabel.font = [COMMON getResizeableFont:OpenSans_SemiBold(13)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(needHelpAction)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [helpLabel addGestureRecognizer:tapGestureRecognizer];
    helpLabel.userInteractionEnabled = YES;
    
    CGFloat helpBtnXpos=helpLabelXpos-40;
    CGFloat helpBtnYpos=screenHeight -(helpLabelHeight*2);
    [helpBtn setFrame:CGRectMake(helpBtnXpos,helpBtnYpos, 40, 40)];
    [helpBtn setImage:[UIImage imageNamed:@"help_Icon"] forState:UIControlStateNormal];
    //[helpBtn setBackgroundImage:[UIImage imageNamed:@"help_Icon"] forState:UIControlStateNormal];
    helpBtn.backgroundColor=[UIColor clearColor];
    [helpBtn addTarget:self action:@selector(needHelpAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)needHelpAction{
//    NSString *url= @"http://support.selecttv.com/";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    alert = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Billing",@"Customer Support",nil];
    [alert show];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOut:)];
    tap.cancelsTouchesInView = NO;
    [alert.window addGestureRecognizer:tap];
   
    
}
-(void)tapOut:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"clicked");
      [alert dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 0)
    {
        NSString *url= Link;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    
    
    if (buttonIndex == 1) {
        
         if([APP_TITLE isEqualToString:@"ETV"])
         {
         
             NSString *url= @"https://etvanywhere.net/support_selection/";
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
         }
         else{
         
              NSString *url= @"http://support.freecast.com/";
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
         }

    }
}


//-(void)setupHelpFrame
//{
//    //[helpAlert removeFromSuperview];
//    helpAlert = [[UIView alloc]init];
//    
//   CGFloat topViewXPos = screenWidth/2;
//   CGFloat topViewYPos =screenHeight/2;
//  CGFloat  topViewWidth =((screenWidth)-(topViewXPos*2));
//   CGFloat topViewHeight =((screenHeight)-(topViewYPos*2));
//    
//    [helpAlert setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
//    [self.view addSubview:helpAlert];
//}

#pragma mark - setAttributedTextForAppNote
-(NSMutableAttributedString *)setAttributedTextForAppNote:movieString{
    
    NSDictionary *attributes = @ {NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[COMMON getResizeableFont:OpenSans_Regular(13)] };
    NSDictionary *attributes1 = @ {NSForegroundColorAttributeName : [UIColor colorWithRed:13.0f/255.0f green:118.0f/255.0f blue:188.0f/255.0f alpha:1],NSFontAttributeName:[COMMON getResizeableFont:OpenSans_Regular(13)]};
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:movieString];
    [attStr addAttributes:attributes  range:[movieString rangeOfString:signUpStrPart_One]];
    [attStr addAttributes:attributes1 range:[movieString rangeOfString:signUpStrPart_Two]];
    
    return attStr;
}

#pragma mark - IPhoneFrame
-(void)IPhoneFrame{
    [emailTF setTranslatesAutoresizingMaskIntoConstraints:NO];
    [passwordTF setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [forgotPwdBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
     createAccBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(14)];
      [createAccBtn setTranslatesAutoresizingMaskIntoConstraints:YES];

}
#pragma mark - IPadFrame
-(void)IPadFrame{
    
    [emailTF setTranslatesAutoresizingMaskIntoConstraints:YES];
    [passwordTF setTranslatesAutoresizingMaskIntoConstraints:YES];
    [loginBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    [forgotPwdBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
     [createAccBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGFloat Xpos=30;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        Xpos=screenWidth/7;
    }
    
    CGFloat emailTFYpos =  CGRectGetMaxY(topImageView.frame)+20; //emailTF.frame.origin.y;
    [emailTF setFrame:CGRectMake(Xpos, emailTFYpos, (screenWidth)-(Xpos*2), 55)];
    [passwordTF setFrame:CGRectMake(Xpos, emailTF.frame.origin.y+emailTF.frame.size.height+20, (screenWidth)-(Xpos*2), 55)];
    CGFloat loginBtnXpos =(SCREEN_WIDTH/2)-75;  //(passwordTF.frame.size.width)/2;
    CGFloat loginBtnYpos =passwordTF.frame.origin.y+passwordTF.frame.size.height+20;
    
    [loginBtn setFrame:CGRectMake(loginBtnXpos,loginBtnYpos, 150, 55)];
    
    CGFloat forgotPwdBtnYpos=0.0;
    if([self isDeviceIpad]==YES){
        forgotPwdBtnYpos =loginBtn.frame.origin.y+loginBtn.frame.size.height+15;
    }
    else{
        forgotPwdBtnYpos =loginBtn.frame.origin.y+loginBtn.frame.size.height+3;
    }
    //new change color white to black
    [forgotPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgotPwdBtn setFrame:CGRectMake(10 ,forgotPwdBtnYpos, screenWidth-20, 55)];
    
      if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
          [createAccBtn setFrame:CGRectMake(screenWidth/2 - createAccBtn.frame.size.width/2 , CGRectGetMaxY(forgotPwdBtn.frame)+180, createAccBtn.frame.size.width, createAccBtn.frame.size.height)];
     }
     else{
    
     [createAccBtn setFrame:CGRectMake(screenWidth/2 - createAccBtn.frame.size.width/2, CGRectGetMaxY(forgotPwdBtn.frame)+30, createAccBtn.frame.size.width, createAccBtn.frame.size.height)];
     }
    


}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark- hide keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    NSLog(@"textfield:%@",textField);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"textfield:%@",textField);
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   // [textField resignFirstResponder];
    
    return YES;
}

#pragma mark- loginAciton
-(void)loginAciton:(id)sender{
    
    NSString *userStr =@"Username/password can't be empty.";
    if([COMMON isSpanishLanguage]==YES){
        userStr =  [COMMON stringTranslatingIntoSpanish:userStr];
    }

    
    if (emailTF.text.length==0 || passwordTF.text.length==0) {
       
        [AppCommon showSimpleAlertWithMessage:userStr];
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Username/password can't be empty." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];

        return;
    }
    
    
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
   // [self loadStartPage];
    
    [[RabbitTVManager sharedManager] getLoginDetails:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        NSLog(@"responseObject%@",responseObject);
        if ([responseObject valueForKey:@"error"]) {
            [AppCommon showSimpleAlertWithMessage:[responseObject valueForKey:@"error"]];
            //[[[UIAlertView alloc] initWithTitle:nil message:[responseObject valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        }
        
        else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *accessTokenStr = [responseObject valueForKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:accessTokenStr  forKey:USERACCESSTOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getUserProfileInformation];
            [self loadStartPage:responseObject];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, id error){
         NSLog(@"error%@",error);
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }  email:emailTF.text password:passwordTF.text];
    

}
#pragma mark - loadStartPage
-(void)loadStartPage:(id)responseObject{
    
    //to load subscription page.
    
    [[NSUserDefaults standardUserDefaults] setObject:@"SubscriptionPage" forKey:MOBILE_DASHBOARD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self pushToIntroViewController:[responseObject mutableCopy]];
    
    NSMutableDictionary *dictItem;
    dictItem = [[NSMutableDictionary alloc]init];
    NSString *start =@"YES";
    [dictItem setValue:start forKey:STARTPAGE];
    [COMMON setDetails:dictItem];
    
    
//    if ([COMMON isUserFirstTimeLoggedIn]) {
//
//        [self pushToIntroViewController:[responseObject mutableCopy]];
//
//    } else {
//
//         [self pushToStartViewController:[responseObject mutableCopy]];
//    }

}
-(void)pushToIntroViewController:(id)responseObject{
    [self.navigationController.navigationBar setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    IntroViewController *viewController = (IntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    
   // CATransition* transition = [CATransition animation];
    //transition.duration = 0.5;//2.5
    //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionPush;
    //transition.subtype = kCATransitionFromRight;
    //[self.view.layer addAnimation:transition forKey:kCATransition];
    
    //[self presentViewController:viewController animated:NO completion:nil];
    
    //raji changed present to push on 21 march 2017
    [self.navigationController pushViewController:viewController animated:NO];

    // NSMutableDictionary *dictItem = [[NSMutableDictionary alloc]init];
    //NSString *start =@"YES";
    //[dictItem setValue:start forKey:LOGGEDIN];
    
    [COMMON setLoginDetails:responseObject];
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    //        [self.navigationController pushViewController:viewController animated:NO];
}



-(void)pushToStartViewController:(id)responseObject{
    StartScreenViewController * startScreenVC = nil;
    startScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreenViewController"];
    //    [self.navigationController pushViewController:startScreenVC animated:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 2.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:startScreenVC animated:NO completion:nil];
    
    //        NSMutableDictionary *dictItem = [[NSMutableDictionary alloc]init];
    //        NSString *start =@"YES";
    //        [dictItem setValue:start forKey:LOGGEDIN];
    //        [COMMON setLoginDetails:dictItem];
    [COMMON setLoginDetails:responseObject];
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

}
-(void)getUserProfileInformation{
    [[RabbitTVManager sharedManager]getUserProfileDetails:^(AFHTTPRequestOperation *request, id responseObject) {
        NSLog(@"PROFILE_DETAILS-->%@",responseObject);
        [COMMON storeUserProfileDetails:responseObject];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"PROFILE_ERROR-->%@",error);
        
    } strAccessToken: [COMMON getUserAccessToken]];
}


#pragma mark-Orientation
//
//-(BOOL)shouldAutorotate {
//    
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//     return UIInterfaceOrientationMaskPortrait;
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createBtnAction:(id)sender {
    
    NSString *url= @"http://selecttv.com/?utm_source=Ios&amp;utm_medium=register&amp;utm_campaign=MobileSignupA";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)showCreateAccBtn
{

    if([APP_TITLE isEqualToString:@"SelectTV"])
    {
   [helpBtn setHidden:YES];
   [helpLabel setHidden:YES];
         [createAccBtn setHidden:NO];
    }
    else{
        [helpBtn setHidden:NO];
        
        
        
        
        
        
        [helpLabel setHidden:NO];
         [createAccBtn setHidden:YES];
    
    }
    

}
@end
