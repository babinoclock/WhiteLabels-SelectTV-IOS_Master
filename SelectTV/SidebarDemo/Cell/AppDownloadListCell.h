//
//  AppDownloadListCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 09/07/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "UIGridViewCell.h"

@interface AppDownloadListCell : UIGridViewCell{
    
}
@property (strong, nonatomic) IBOutlet UIView *appView;
@property (nonatomic, retain) IBOutlet UIImageView *appImage;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *coverViewBtn;
@end
