//
//  MyAccountViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 22/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitTVManager.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "New_Land_Cell.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "NIDropDown.h"
#import "NSString+validations.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface MyAccountViewController : UIViewController<UITextFieldDelegate,NIDropDownDelegate> {
    
    NIDropDown *dropDown;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (strong, nonatomic) IBOutlet UITableView *myAccountTable;

@property (strong, nonatomic) IBOutlet UIButton *saveAction;

@end
