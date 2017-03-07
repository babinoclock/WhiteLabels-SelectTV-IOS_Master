//
//  FavTableViewCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 27/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "AppCommon.h"

@interface FavTableViewCell : UITableViewCell {
    
    CGFloat showDespWidth ;
    CGFloat showWidth ;
    CGFloat removeBtnWidth ;
    CGFloat XPos ;
    CGFloat RXPos;
    int runtimeFont;
    int ratingFont;

}

@property (nonatomic, retain) IBOutlet UIImageView *showImageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showDesp;
@property (strong, nonatomic) IBOutlet UILabel *showRunTime;
@property (strong, nonatomic) IBOutlet UILabel *showRating;
@property (strong, nonatomic) IBOutlet UIButton *removeBtn;



@end
