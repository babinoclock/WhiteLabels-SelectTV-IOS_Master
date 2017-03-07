//
//  appManagerStaticCustomCollectionCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 08/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appManagerStaticCustomCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *appImage;
@property (strong, nonatomic) IBOutlet UIView *appColorView;
@property (strong, nonatomic) IBOutlet UIImageView *tickIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *installBtn;

@end
