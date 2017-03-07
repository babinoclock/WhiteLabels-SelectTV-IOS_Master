//
//  MenuCell.h
//  SidebarDemo
//
//  Created by Panda on 6/15/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textMenuItem;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;

@end
