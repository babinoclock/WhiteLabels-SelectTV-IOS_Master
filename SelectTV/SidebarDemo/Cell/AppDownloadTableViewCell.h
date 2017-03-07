//
//  AppDownloadTableViewCell.h
//  SidebarDemo
//
//  Created by Panda on 6/16/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDownloadTableViewCell : UITableViewCell{
    
    IBOutlet UIImageView *appImage;
}
@property (nonatomic, weak) IBOutlet UILabel *appTitle;

@property (strong, nonatomic) IBOutlet UIImageView *appImageView;
@property (strong, nonatomic) IBOutlet UIButton *getAppBtn;

@end
