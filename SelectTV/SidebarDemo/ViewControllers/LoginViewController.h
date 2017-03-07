//
//  LoginViewController.h
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCommon.h"
#import "AppConfig.h"
#import "RabbitTVManager.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *passwordTF;
    
    IBOutlet UIImageView *topImageView;
}
@property (strong, nonatomic) IBOutlet UIButton  *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton  *forgotPwdBtn;
@property (strong, nonatomic) IBOutlet UIButton  *createAccBtn;

@property (strong, nonatomic) IBOutlet UILabel *loginLabel;

@property (strong, nonatomic) IBOutlet UILabel *signUpLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) IBOutlet UIButton  *helpBtn;

@end
