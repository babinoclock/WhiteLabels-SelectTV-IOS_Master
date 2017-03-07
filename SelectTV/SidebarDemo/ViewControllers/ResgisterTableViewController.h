//
//  ResgisterTableViewController.h
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResgisterTableViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    

        IBOutlet UITextField *userNameTF;
        IBOutlet UITextField *emailTF;
        IBOutlet UITextField *passwordTF;
        IBOutlet UITextField *confirmPasswordTF;
        IBOutlet UIButton *maleButton;
        IBOutlet UIButton *femaleButton;
        IBOutlet UITextField *ageRangeTF;
        UIView *mainPickerView;
        int whichSlected;
    
}

-(IBAction)genderChangeButtonPressed:(id)sender;

@end
