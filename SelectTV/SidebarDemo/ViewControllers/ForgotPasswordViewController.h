//
//  ForgotPasswordViewController.h
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCommon.h"
#import "AppConfig.h"
@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *emailTF;

    IBOutlet UIImageView *topImageView;
}
@property (strong, nonatomic) IBOutlet UIButton  *backBtn;
@property (strong, nonatomic) IBOutlet UIButton  *continueBtn;
@property (strong, nonatomic) IBOutlet UILabel *resetPasswordLabel;
@end
