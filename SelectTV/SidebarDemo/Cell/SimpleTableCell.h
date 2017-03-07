//
//  SimpleTableCell.h
//  SidebarDemo
//
//  Created by Panda on 6/16/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelTextSecondary;
@property (nonatomic, weak) IBOutlet UIView   *viewContent;
@property (nonatomic, retain) IBOutlet UIImageView *menuImage;
@end
