//
//  RegisterViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 18/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "RegisterViewController.h"



@interface RegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat commonHeight;
    UIView *registerView;
    UIView *redeemView;
    //
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    UITextField *postalCodeTextField;
    UIButton *maleRadioBtn;
    UIButton *femaleRadioBtn;
    UITextField *ageListTextField;
    
    //BOOL
    BOOL isMaleSelected;
    BOOL isMale,isFemale;
    int isAgeSelected;
    
    //Border
    UIView *registerTopBorder;
    UIView *registerBottomBorder;
    UIView *registerRightBorder;
    UIView *redeemTopBorder;
    UIView *redeemBottomBorder;
}

@end

@implementation RegisterViewController
@synthesize scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    pickerArray = [[NSArray alloc]initWithObjects:@"18-24",
                   @"25-35",@"36-49",@"50+", nil];
    isMaleSelected=YES;
    isAgeSelected=0;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpViews];
    
}
-(void)setUpViews{
    CGFloat registerViewXpos;
    CGFloat registerViewYpos;
    CGFloat registerViewHeight;
    CGFloat topViewXPos;
    CGFloat topViewYPos;
    CGFloat topViewWidth;
    CGFloat topViewHeight;
    CGFloat registerLabelHeight;
    
    
    
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        topViewXPos = screenWidth/5;
        topViewYPos = 10;
        topViewWidth =((screenWidth)-(topViewXPos*2));
        topViewHeight =70;
        registerLabelHeight =30;
       
    }
    else{
        topViewXPos = screenWidth/3;
        topViewYPos = 40;
        topViewWidth= (screenWidth/2)-(screenWidth/6);
        topViewHeight  = 100;
        registerLabelHeight = 60;
        
    }
    
    [scrollView setUserInteractionEnabled:YES];
    scrollView.delegate=self;
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(topViewXPos, topViewYPos, topViewWidth, topViewHeight)];
    topView.image =[UIImage imageNamed:splashLogoImageName];//@"splash_logo"
   // topView.image =[UIImage imageNamed:@"splash_logo"];
    //[self.view addSubview:topView];
    [scrollView addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    
    CGFloat registerXpos = topView.frame.origin.x-5;//screenWidth/3
    CGFloat registerYpos = topView.frame.origin.y+topView.frame.size.height+5;
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(registerXpos, registerYpos, (screenWidth/2)-(screenWidth/6), registerLabelHeight)];
    registerLabel.text = @"Register";
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.backgroundColor = [UIColor clearColor];
    [registerLabel setTextColor:[UIColor blackColor]];
    [registerLabel setFont:[COMMON getResizeableFont:HelveticaNeue(18)]];
    [scrollView addSubview:registerLabel];
    
    
    CGFloat redeemLabelXpos = registerLabel.frame.origin.x+registerLabel.frame.size.width;
    UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(redeemLabelXpos, registerYpos, (screenWidth/2)-(screenWidth/6), registerLabelHeight)];
    redeemLabel.text = @"Redeem";
    redeemLabel.textAlignment = NSTextAlignmentCenter;
    redeemLabel.backgroundColor = [UIColor clearColor];
    [redeemLabel setTextColor:[UIColor blackColor]];
    [redeemLabel setFont:[COMMON getResizeableFont:HelveticaNeue(18)]];
    [scrollView addSubview:redeemLabel];
    
    [self addGestureAndLabel:registerLabel :redeemLabel];
    
    
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        registerViewXpos=20;
        registerViewYpos =registerLabel.frame.origin.y+registerLabel.frame.size.height+5;
        [scrollView setScrollEnabled:YES];
        registerViewHeight=screenHeight+(scrollView.frame.size.height/2);
         commonHeight=40;
    }
    else{
        registerViewXpos=screenWidth/7;
        registerViewYpos =registerLabel.frame.origin.y+registerLabel.frame.size.height+5;
        [scrollView setScrollEnabled:NO];
        registerViewHeight= screenHeight-40;
        commonHeight=60;
    }
    
    registerView = [[UIView alloc]initWithFrame:CGRectMake(registerViewXpos, registerViewYpos, (screenWidth)-(registerViewXpos*2), registerViewHeight)];
    registerView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:registerView];
    [scrollView addSubview:registerView];
    registerView.userInteractionEnabled = YES;
    [registerView setHidden:NO];
    
    redeemView = [[UIView alloc]initWithFrame:CGRectMake(registerViewXpos, registerViewYpos, (screenWidth)-(registerViewXpos*2), registerViewHeight-50)];
    redeemView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:redeemView];
    redeemView.userInteractionEnabled = YES;
    [self redeemView];
    [redeemView setHidden:YES];
    
    
    scrollView.userInteractionEnabled = YES;
    
    [self setEmailTexField];
    
    
}
-(void)addGestureAndLabel:(UILabel *)registerLabel :(UILabel *)redeemLabel{
    
    UITapGestureRecognizer *registerLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerLabelTapAction:)];
    registerLabelTap.numberOfTapsRequired = 1;
    registerLabelTap.numberOfTouchesRequired = 1;
    [registerLabel addGestureRecognizer:registerLabelTap];
    [registerLabel setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *redeemLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redeemLabelTapAction:)];
    redeemLabelTap.numberOfTapsRequired = 1;
    redeemLabelTap.numberOfTouchesRequired = 1;
    [redeemLabel addGestureRecognizer:redeemLabelTap];
    [redeemLabel setUserInteractionEnabled:YES];
    
    //TOP BORDER
    registerTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,registerLabel.frame.size.width,1.5)];
    [registerLabel addSubview:registerTopBorder];
    [registerTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    registerTopBorder.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    redeemTopBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,redeemLabel.frame.size.width,1.5)];
    [redeemLabel addSubview:redeemTopBorder];
    [redeemTopBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    redeemTopBorder.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];

    
    //RIGHT BORDER
    registerRightBorder = [[UIView alloc] initWithFrame:CGRectMake(registerLabel.frame.size.width-1.0f, 0, 1.0, registerLabel.frame.size.height)];
    [registerLabel addSubview:registerRightBorder];
    [registerRightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    registerRightBorder.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    
    //BOTTOM BORDER
    registerBottomBorder  = [[UIView alloc] initWithFrame:CGRectMake(0, registerLabel.frame.size.height-1.5f, registerLabel.frame.size.width, 1.5)];
    [registerLabel addSubview:registerBottomBorder];
    [registerBottomBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    registerBottomBorder.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    redeemBottomBorder  = [[UIView alloc] initWithFrame:CGRectMake(0, redeemLabel.frame.size.height-2.0f, redeemLabel.frame.size.width, 1.5)];
    [redeemLabel addSubview:redeemBottomBorder];
    [redeemBottomBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    redeemBottomBorder.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [registerTopBorder setHidden:NO];
    [registerRightBorder setHidden:NO];
    [registerBottomBorder setHidden:YES];
    [redeemTopBorder setHidden:YES];
    [redeemBottomBorder setHidden:NO];
    

}
#pragma mark - registerLabelTapAction
- (void)registerLabelTapAction:(UILabel *)myLabel
{
    [registerView setHidden:NO];
    [redeemView setHidden:YES];
    [registerTopBorder setHidden:NO];
    [registerRightBorder setHidden:NO];
    [registerBottomBorder setHidden:YES];
    [redeemTopBorder setHidden:YES];
    [redeemBottomBorder setHidden:NO];
}
#pragma mark - redeemLabelTapAction
- (void)redeemLabelTapAction:(UILabel *)myLabel
{
    [registerView setHidden:YES];
    [redeemView setHidden:NO];
    [registerTopBorder setHidden:YES];
    [registerRightBorder setHidden:NO];
    [registerBottomBorder setHidden:NO];
    [redeemTopBorder setHidden:NO];
    [redeemBottomBorder setHidden:YES];
}
-(void)setEmailTexField{
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, registerViewWidth, commonHeight)];
    emailTextField.delegate=self;
    emailTextField.userInteractionEnabled = YES;
    emailTextField.placeholder = @"User name";
    [emailTextField setTextColor:[UIColor blackColor]];
    [emailTextField setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    emailTextField.keyboardType = UIKeyboardTypeDefault;
    emailTextField.returnKeyType = UIReturnKeyDefault;
    emailTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [emailTextField setLeftViewMode:UITextFieldViewModeAlways];
    [emailTextField setLeftView:spacerView];
    [registerView addSubview:emailTextField];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, emailTextField.frame.size.height-2.0f, emailTextField.frame.size.width, 1.5)];
    [emailTextField addSubview:bottomEmail];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [self setPasswordTexField];
    
}
-(void)setPasswordTexField{
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat passwordTextFieldYpos =emailTextField.frame.origin.y+emailTextField.frame.size.height+10;
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, passwordTextFieldYpos, registerViewWidth, commonHeight)];
     passwordTextField.delegate=self;
    passwordTextField.userInteractionEnabled = YES;
    passwordTextField.placeholder = @"Password";
    [passwordTextField setTextColor:[UIColor blackColor]];
    [passwordTextField setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDefault;
    passwordTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordTextField setLeftView:spacerView];
    [registerView addSubview:passwordTextField];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, passwordTextField.frame.size.height-2.0f, passwordTextField.frame.size.width, 1.5)];
    [passwordTextField addSubview:bottomEmail];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [self setConfirmPasswordTexField];
    
}

-(void)setConfirmPasswordTexField{
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat passwordTextFieldYpos =passwordTextField.frame.origin.y+passwordTextField.frame.size.height+10;
    
    confirmPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,passwordTextFieldYpos, registerViewWidth, commonHeight)];
    confirmPasswordTextField.delegate=self;
    confirmPasswordTextField.userInteractionEnabled = YES;
    confirmPasswordTextField.placeholder = @"Confirm Password";
    [confirmPasswordTextField setTextColor:[UIColor blackColor]];
    [confirmPasswordTextField setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    confirmPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    confirmPasswordTextField.returnKeyType = UIReturnKeyDefault;
    confirmPasswordTextField.secureTextEntry =YES;
    confirmPasswordTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    confirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [confirmPasswordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [confirmPasswordTextField setLeftView:spacerView];
    [registerView addSubview:confirmPasswordTextField];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, confirmPasswordTextField.frame.size.height-2.0f, confirmPasswordTextField.frame.size.width, 1.5)];
    [confirmPasswordTextField addSubview:bottomEmail];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [self setPostalCodeTextField];
    
}
-(void)setPostalCodeTextField{
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat postalCodeTextFieldYpos =confirmPasswordTextField.frame.origin.y+confirmPasswordTextField.frame.size.height+10;
    
    postalCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,postalCodeTextFieldYpos, registerViewWidth, commonHeight)];
    postalCodeTextField.delegate=self;
    postalCodeTextField.userInteractionEnabled = YES;
    postalCodeTextField.placeholder = @"Postal Code";
    [postalCodeTextField setTextColor:[UIColor blackColor]];
    [postalCodeTextField setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    postalCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    postalCodeTextField.returnKeyType = UIReturnKeyDefault;
    postalCodeTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    postalCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [postalCodeTextField setLeftViewMode:UITextFieldViewModeAlways];
    [postalCodeTextField setLeftView:spacerView];
    [registerView addSubview:postalCodeTextField];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, postalCodeTextField.frame.size.height-2.0f, postalCodeTextField.frame.size.width, 1.5)];
    [postalCodeTextField addSubview:bottomEmail];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    [self radioButtons];
}
-(void)radioButtons{
    CGFloat radioBtnHeight;
    CGFloat radioBtnWidth;
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        radioBtnHeight=20;
        radioBtnWidth =20;
    }
    else{
        radioBtnHeight=40;
        radioBtnWidth =30;
    }
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat maleRadioBtnYpos =postalCodeTextField.frame.origin.y+postalCodeTextField.frame.size.height+10;
    maleRadioBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,maleRadioBtnYpos, radioBtnWidth, radioBtnHeight)];
    [maleRadioBtn setImage:[UIImage imageNamed:@"radio_Active"] forState:UIControlStateNormal];
    [maleRadioBtn addTarget:self action:@selector(maleBtnAction) forControlEvents:UIControlEventTouchUpInside];[maleRadioBtn setBackgroundColor:[UIColor clearColor]];
    [registerView addSubview:maleRadioBtn];
    
    CGFloat maleLabelXpos =maleRadioBtn.frame.origin.x+maleRadioBtn.frame.size.width+2;
    UILabel *maleLabel = [[UILabel alloc]initWithFrame:CGRectMake(maleLabelXpos,maleRadioBtnYpos, registerViewWidth/3, radioBtnHeight)];
    maleLabel.text = @"Male";
    [maleLabel setTextAlignment:NSTextAlignmentLeft];
    [maleLabel setBackgroundColor:[UIColor clearColor]];
    [maleLabel setTextColor:[UIColor blackColor]];
    [maleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [registerView addSubview:maleLabel];
    
    CGFloat femaleRadioBtnXpos =maleLabel.frame.origin.x+maleLabel.frame.size.width+2;
    femaleRadioBtn = [[UIButton alloc]initWithFrame:CGRectMake(femaleRadioBtnXpos,maleRadioBtnYpos, radioBtnWidth, radioBtnHeight)];
    [femaleRadioBtn setImage:[UIImage imageNamed:@"radio_Inactive"] forState:UIControlStateNormal];
    [femaleRadioBtn addTarget:self action:@selector(femaleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [femaleRadioBtn setBackgroundColor:[UIColor clearColor]];
    [registerView addSubview:femaleRadioBtn];
    
    
    CGFloat femaleLabelXpos =femaleRadioBtn.frame.origin.x+femaleRadioBtn.frame.size.width+2;
    UILabel *femaleLabel = [[UILabel alloc]initWithFrame:CGRectMake(femaleLabelXpos,maleRadioBtnYpos, registerViewWidth/3, radioBtnHeight)];
    femaleLabel.text = @"Female";
    [femaleLabel setTextAlignment:NSTextAlignmentLeft];
    [femaleLabel setBackgroundColor:[UIColor clearColor]];
    [femaleLabel setTextColor:[UIColor blackColor]];
    [femaleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(13)]];
    [registerView addSubview:femaleLabel];
    
    [self ageRangeLabel:femaleLabel];
    
}
-(void)ageRangeLabel:(UILabel*)femaleLabel{
    
    CGFloat ageListTextFieldHeight;
    
    if(IS_IPHONE4||IS_IPHONE5||IS_IPHONE6||IS_IPHONE6_Plus){
        ageListTextFieldHeight=20;
        }
    else{
        ageListTextFieldHeight=40;
        }

    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat ageRangeLabelYpos =femaleLabel.frame.origin.y+femaleLabel.frame.size.height+10;
    UILabel *ageRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,ageRangeLabelYpos, registerViewWidth/2, commonHeight)];
    ageRangeLabel.text = @"Your age range";
    [ageRangeLabel setTextAlignment:NSTextAlignmentCenter];
    [ageRangeLabel setBackgroundColor:[UIColor clearColor]];
    [ageRangeLabel setTextColor:[UIColor blackColor]];
    [ageRangeLabel setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
    [registerView addSubview:ageRangeLabel];
    
    CGFloat ageBorderLabelXpos =ageRangeLabel.frame.origin.x+ageRangeLabel.frame.size.width+10;
    UILabel *ageBorderLabel = [[UILabel alloc]initWithFrame:CGRectMake(ageBorderLabelXpos,ageRangeLabelYpos, (registerViewWidth/2)-10, commonHeight)];
    ageBorderLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    ageBorderLabel.layer.borderWidth = 2.0f;
    ageBorderLabel.userInteractionEnabled = YES;
    CGFloat ageRangeLabelWidth =ageRangeLabel.frame.size.width;
    ageListTextField = [[UITextField alloc]initWithFrame:CGRectMake(10,10, ageRangeLabelWidth-30, ageListTextFieldHeight)];
    ageListTextField.text = @"18-24";
    ageListTextField.delegate=self;
    ageListTextField.userInteractionEnabled = YES;
    [ageListTextField setBackgroundColor:[UIColor whiteColor]];
    [ageListTextField setTextColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [ageListTextField setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [ageListTextField setLeftViewMode:UITextFieldViewModeAlways];
    [ageListTextField setLeftView:spacerView];
    [ageBorderLabel addSubview:ageListTextField];
    [registerView addSubview:ageBorderLabel];
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView setHidden:NO];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, screenHeight-50, screenWidth, 50)];
    [toolBar setBarStyle:UIBarStyleDefault];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    ageListTextField.inputView = myPickerView;
   // ageListTextField.inputAccessoryView = toolBar;
    [self termsLabel:ageBorderLabel];
    
    
}

-(void)termsLabel:(UILabel*)ageBorderLabel{
    
    CGFloat termsLabelHeight;
    termsLabelHeight=70;
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat termsLabelYpos =ageBorderLabel.frame.origin.y+ageBorderLabel.frame.size.height+10;
    UILabel *termsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,termsLabelYpos, registerViewWidth, termsLabelHeight)];
    termsLabel.text = @"By clicking 'Create Account', you agree to the Terms of Use \n and Privacy Policy, and to receive member notifications";
    [termsLabel setTextAlignment:NSTextAlignmentLeft];
    [termsLabel setBackgroundColor:[UIColor clearColor]];
    [termsLabel setTextColor:[UIColor whiteColor]];
    termsLabel.numberOfLines=0;
    [termsLabel setFont:[COMMON getResizeableFont:Roboto_Regular(14)]];
    [registerView addSubview:termsLabel];
    
    [self createAccountBtn:termsLabel];
    
}
-(void)createAccountBtn:(UILabel*)termsLabel{
    
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat createBtnXpos = registerViewWidth/4;
    CGFloat createBtnYpos =termsLabel.frame.origin.y+termsLabel.frame.size.height+10;
    UIButton *createBtn = [[UIButton alloc]initWithFrame:CGRectMake(createBtnXpos,createBtnYpos, registerViewWidth-(createBtnXpos*2), 40)];
    [createBtn setTitle:@"Create Account" forState:UIControlStateNormal];
    createBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.layer.cornerRadius = 4.0f;
    createBtn.clipsToBounds = YES;
    [createBtn addTarget:self action:@selector(creatAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [createBtn setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [registerView addSubview:createBtn];
    [self backBtn:createBtn];
    
}
-(void)backBtn:(UIButton*)createBtn{
    CGFloat registerViewWidth = registerView.frame.size.width;
    CGFloat backBtnXpos = registerViewWidth/4;
    CGFloat backBtnYpos =createBtn.frame.origin.y+createBtn.frame.size.height+10;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(backBtnXpos,backBtnYpos, registerViewWidth-(backBtnXpos*2), 40)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:backBtn];
    
   //TESTING
    [scrollView setFrame:CGRectMake(0, 0, screenWidth, registerView.frame.origin.y+registerView.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(0,registerView.frame.origin.y+registerView.frame.size.height)];
    


}
-(void)maleBtnAction{
    if(isMaleSelected==NO){
        [maleRadioBtn setImage:[UIImage imageNamed:@"radio_Active"] forState:UIControlStateNormal];
        [femaleRadioBtn setImage:[UIImage imageNamed:@"radio_Inactive"] forState:UIControlStateNormal];
        isMaleSelected=YES;
        isMale=YES;
        isFemale=NO;
    }
    else{
       isMaleSelected=YES;
        
    }
    
}
-(void)femaleBtnAction{
    if(isMaleSelected==YES){
        [maleRadioBtn setImage:[UIImage imageNamed:@"radio_Inactive"] forState:UIControlStateNormal];
        [femaleRadioBtn setImage:[UIImage imageNamed:@"radio_Active"] forState:UIControlStateNormal];
        isMaleSelected=NO;
        isMale=NO;
        isFemale=YES;
    }
    else{
        isMaleSelected=NO;
    }
}
#pragma mark - redeemView
-(void)redeemView{
    
    CGFloat registerViewWidth = redeemView.frame.size.width;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, registerViewWidth, commonHeight)];
    titleLabel.text = @"Just Activate & Watch!";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[COMMON getResizeableFont:Roboto_Regular(15)]];
    [redeemView addSubview:titleLabel];
    
    CGFloat codeTextFieldYpos =titleLabel.frame.origin.y+titleLabel.frame.size.height+20;
    UITextField *codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, codeTextFieldYpos, registerViewWidth, commonHeight)];
    codeTextField.delegate=self;
    codeTextField.userInteractionEnabled = YES;
    codeTextField.placeholder = @"Enter Your Code Here";
    [codeTextField setTextColor:[UIColor blackColor]];
    [codeTextField setFont:[COMMON getResizeableFont:Roboto_Regular(16)]];
    codeTextField.keyboardType = UIKeyboardTypeDefault;
    codeTextField.returnKeyType = UIReturnKeyDefault;
    codeTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [codeTextField setLeftViewMode:UITextFieldViewModeAlways];
    [codeTextField setLeftView:spacerView];
    [[codeTextField layer] setBorderColor:[[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[codeTextField layer] setBorderWidth:1.5];
    [[codeTextField layer] setCornerRadius:2.0f];
    
    [redeemView addSubview:codeTextField];
    
    UIView *bottomEmail  = [[UIView alloc] initWithFrame:CGRectMake(0, codeTextField.frame.size.height-2.0f, codeTextField.frame.size.width, 1.5)];
   // [codeTextField addSubview:bottomEmail];
    
    [bottomEmail setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    bottomEmail.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1];
    
    CGFloat activateBtnXpos = registerViewWidth/4;
    CGFloat activateBtnYpos =codeTextField.frame.origin.y+codeTextField.frame.size.height+20;
    UIButton *activateBtn = [[UIButton alloc]initWithFrame:CGRectMake(activateBtnXpos,activateBtnYpos, registerViewWidth-(activateBtnXpos*2), 40)];
    [activateBtn setTitle:@"Activate" forState:UIControlStateNormal];
    activateBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Bold(14)];
    [activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    activateBtn.layer.cornerRadius = 4.0f;
    activateBtn.clipsToBounds = YES;
    [activateBtn addTarget:self action:@selector(activateAction:) forControlEvents:UIControlEventTouchUpInside];
    [activateBtn setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1]];
    [redeemView addSubview:activateBtn];
    
    
}
-(void)activateAction:(id) sender{
    
}


#pragma mark- hide keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
-(void)done:(id)sender
{
     [sender resignFirstResponder];
    [self.view endEditing:YES];
    

}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    isAgeSelected =(int)row+1;
    [ageListTextField setText:[pickerArray objectAtIndex:row]];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
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
#pragma mark - creatAccountAction
-(void)creatAccountAction:(id)sender{
    
    
    if (emailTextField.text.length==0 || passwordTextField.text.length==0 || confirmPasswordTextField.text.length==0) {
        [AppCommon showSimpleAlertWithMessage:@"Email Address, Passsord, postal code can't be empty."];
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Email address, passsord, postal code can't be empty." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;
        
    }
    
    else if (![self emailvalidate:emailTextField.text]){
        [AppCommon showSimpleAlertWithMessage:@"Please Enter correct Email"];
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter correct email" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;
        
    }
    
    else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]){
        [AppCommon showSimpleAlertWithMessage:@"Password and confirm password doesn't match."];
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Password and confirm password doesn't match." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    else{
        
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        
        
        if (isMale ==YES ) {
            
            [tempDict setObject:@"M" forKey:@"gender"];
        }
        
        else{
            [tempDict setObject:@"F" forKey:@"gender"];
            
        }
        [tempDict setObject:postalCodeTextField.text forKey:@"zip_code"];

        if (isAgeSelected>0) {
            [tempDict setObject:[NSNumber numberWithInt:isAgeSelected] forKey:@"age_group"];
            
        }
        else{
             [tempDict setObject:[NSNumber numberWithInt:1] forKey:@"age_group"];
        }

        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
        [[RabbitTVManager sharedManager] getRegisterDetails:^(AFHTTPRequestOperation * operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            
            NSLog(@"%@",responseObject);
            if ([responseObject valueForKey:@"error"]) {
                [[[UIAlertView alloc] initWithTitle:nil message:[responseObject valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            }
            else{
                if([responseObject count]!=0){
                    NSString *accessTokenStr = [responseObject valueForKey:@"access_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:accessTokenStr  forKey:USERACCESSTOKEN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self loadStartPage];
                }
                

            }
            
        }  email:emailTextField.text password:passwordTextField.text data:tempDict];
       
        
    }
    
    
}
#pragma mark - loadStartPage
-(void)loadStartPage{
    
    StartScreenViewController * startScreenVC = nil;
    startScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreenViewController"];
    [self.navigationController pushViewController:startScreenVC animated:YES];
    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc]init];
    NSString *start =@"YES";
    [dictItem setValue:start forKey:LOGGEDIN];
    [COMMON setLoginDetails:dictItem];

    
}


-(void)backAction:(id)sender{
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    //return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
