//
//  SliderViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 16/08/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "AppCommon.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImage.h"
#import "NKContainerCellTableViewCell.h"


@interface OnDemandSliderCarouselView : UIView 


+(OnDemandSliderCarouselView *)loadView;
-(void)loadSliderShowImages:(NSMutableArray *)ImageArray carouselArray:(NSMutableArray *)carouselArray currentViewStr:(NSString *) currentViewStr currentTitleStr:(NSString *) currentTitleStr;
@end
