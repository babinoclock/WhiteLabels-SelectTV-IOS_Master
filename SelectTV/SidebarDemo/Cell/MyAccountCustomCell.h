//
//  MyAccountCustomCell.h
//  SidebarDemo
//
//  Created by ocsdeveloper9 on 6/29/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "AppCommon.h"

@interface MyAccountCustomCell : UITableViewCell<UITextFieldDelegate> {
    

    
}
@property (nonatomic, retain) IBOutlet UITextField *accountField;
@property (nonatomic, retain) IBOutlet UILabel *accountLabel;
@property (nonatomic, retain) IBOutlet     UIButton *genderButton;

@end
