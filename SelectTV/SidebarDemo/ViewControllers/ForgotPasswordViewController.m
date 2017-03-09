//
//  ForgotPasswordViewController.m
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "RabbitTVManager.h"
#import "MBProgressHUD.h"

@interface ForgotPasswordViewController (){
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString * currentAppLanguage;
}

@end

@implementation ForgotPasswordViewController
@synthesize continueBtn,backBtn,resetPasswordLabel;;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];

    NSString *resetStr = @"Reset Password";
    if([currentAppLanguage containsString:@"es"]){
        resetStr =  [COMMON stringTranslatingIntoSpanish:resetStr];
    }
    resetPasswordLabel.text = resetStr;
    
    self.title = resetStr;
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //[self addLeftImageOnTextField:@"Email icon" :emailTF];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgotPageOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateForgotViews:false];
    }else{
        [self rotateForgotViews:true];
    }
    
    
}
#pragma mark orientationChanged
-(void) forgotPageOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self rotateForgotViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self rotateForgotViews:false];
            break;
            
        default:
            break;
    }
}
-(void) rotateForgotViews:(BOOL) bPortrait{
    
    screenWidth = SCREEN_WIDTH;
    screenHeight = SCREEN_HEIGHT;
    
    [self setImageViewFrame];
    [self setUpViews];
    
    if(bPortrait){
        
    }
    else{
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setImageViewFrame];
    [self setUpViews];
    
}
#pragma mark - setImageViewFrame
-(void)setImageViewFrame{
    [topImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGFloat topViewXPos;
    CGFloat topViewYPos;
    CGFloat topViewWidth;
    CGFloat topViewHeight;

   
        if([self isDeviceIpad]!=YES){
            
            topViewWidth= screenWidth/2.1;//free cast//5
        }
        else{
            
            topViewWidth= screenWidth/4; //free cast//8
            
        }
    

    topViewXPos = (screenWidth/2)-(topViewWidth/2);
    topViewYPos = 40;
    topViewHeight = 62;//55
    
    [topImageView setFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
    
    topImageView.image =[UIImage imageNamed:homeLogoImageName];//splash_logo
}
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - setUpViews
-(void) setUpViews{
    
    
//    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
//        [self IPhoneFrame];
//        
//    }
//    else{
//        [self IPadFrame];
//    }
     [self IPadFrame];
    
    UIColor *color = [UIColor whiteColor];
    
    NSString *emailTFStr = @"Email";
    if([COMMON isSpanishLanguage]==YES){
        emailTFStr =  [COMMON stringTranslatingIntoSpanish:emailTFStr];
    }


    emailTF.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:emailTFStr
     attributes:@{NSForegroundColorAttributeName:color}];
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailTF.leftView = paddingView;
    emailTF.leftViewMode = UITextFieldViewModeAlways;
    emailTF.textColor = [UIColor whiteColor];
    emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    continueBtn.layer.cornerRadius = 4.0f;
    continueBtn.clipsToBounds = YES;
    continueBtn.backgroundColor = GRAY_BG_COLOR;
    [emailTF setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    continueBtn.titleLabel.font= [COMMON getResizeableFont:Roboto_Bold(14)];
    backBtn.titleLabel.font= [COMMON getResizeableFont:Roboto_Regular(14)];
    backBtn.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    NSString *continueStr = @"Continue";
    NSString *backStr = @"back";
    if([COMMON isSpanishLanguage]==YES){
        continueStr =  [COMMON stringTranslatingIntoSpanish:continueStr];
        backStr =  [COMMON stringTranslatingIntoSpanish:backStr];
    }
    [continueBtn setTitle:continueStr forState:UIControlStateNormal];
    [backBtn setTitle:backStr forState:UIControlStateNormal];
    continueBtn.titleLabel.text = continueStr;//blueBtn.png
    backBtn.titleLabel.text = backStr;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    // [continueBtn setImage:[UIImage imageNamed:@"blueBtn.png"] forState:UIControlStateNormal];

//    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, emailTF.frame.size.height-1.0f, emailTF.frame.size.width, 1.0)];
//    [emailTF addSubview:bottomEmail];
//    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
   // bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    }
#pragma mark - IPhoneFrame
-(void)IPhoneFrame{
    [emailTF setTranslatesAutoresizingMaskIntoConstraints:NO];
    [continueBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];

}
#pragma mark - IPadFrame
-(void)IPadFrame{
    [emailTF setTranslatesAutoresizingMaskIntoConstraints:YES];
    [resetPasswordLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [continueBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:YES];
    
     CGFloat Xpos=20;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        Xpos=screenWidth/7;
    }
   
    CGFloat resetPasswordLabelYpos =resetPasswordLabel.frame.origin.y;
    [resetPasswordLabel setFrame:CGRectMake(Xpos, resetPasswordLabelYpos, (screenWidth)-(Xpos*2),30)];
    
    CGFloat emailTFYpos =emailTF.frame.origin.y;
    [emailTF setFrame:CGRectMake(Xpos, emailTFYpos, (screenWidth)-(Xpos*2), 55)];
    
    CGFloat continueBtnXpos = (SCREEN_WIDTH/2)-75;   // (emailTF.frame.size.width)/2;
    CGFloat continueBtnYpos =emailTF.frame.origin.y+emailTF.frame.size.height+20;
   // [continueBtn setFrame:CGRectMake(continueBtnXpos,continueBtnYpos, emailTF.frame.size.width-(emailTF.frame.size.width/2)-10, continueBtn.frame.size.height+5)];
    [continueBtn setFrame:CGRectMake(continueBtnXpos,continueBtnYpos, 150, 55)];

   // CGFloat backBtnXpos =(emailTF.frame.size.width)/2;
    CGFloat backBtnYpos =continueBtn.frame.origin.y+continueBtn.frame.size.height+20;
    
    [backBtn setFrame:CGRectMake(0 ,backBtnYpos, screenWidth, 30)];
    
}
#pragma mark - backAction

-(void)backAction{
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - forgotPasswordClicked
-(IBAction)forgotPasswordClicked:(id)sender{
    
    NSString *inCorrectEmail =@"Please enter correct email";
    NSString *inCorrentRegisterEmail =@"Please check your registered email.";
    if([COMMON isSpanishLanguage]==YES){
        inCorrectEmail =  [COMMON stringTranslatingIntoSpanish:inCorrectEmail];
        inCorrentRegisterEmail =  [COMMON stringTranslatingIntoSpanish:inCorrentRegisterEmail];
    }
    
    
    if (![self emailvalidate:emailTF.text]) {
        [AppCommon showSimpleAlertWithMessage:inCorrectEmail];
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter correct email" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;
        
    }
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    [[RabbitTVManager sharedManager] getForgotPassword:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
        if ([responseObject valueForKey:@"error"]) {
            [AppCommon showSimpleAlertWithMessage:[responseObject valueForKey:@"error"]];
            //[[[UIAlertView alloc] initWithTitle:nil message:[responseObject valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            
        }
        else{
            [AppCommon showSimpleAlertWithMessage:inCorrentRegisterEmail];
             //[[[UIAlertView alloc] initWithTitle:nil message:@"Please check your registered email." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            
        }
    
    } failureBlock:^(AFHTTPRequestOperation *operation, id responseObject){
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [AppCommon showSimpleAlertWithMessage:@"No Network Error"];
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Error" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
    }email:emailTF.text];
    
}
#pragma mark - emailvalidate
-(BOOL) emailvalidate:(NSString *)tempMail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:tempMail];
}

//#pragma mark-Orientation
//
//-(BOOL)shouldAutorotate {
//    
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    //return UIInterfaceOrientationMaskAll;
//    return UIInterfaceOrientationMaskPortrait;
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
