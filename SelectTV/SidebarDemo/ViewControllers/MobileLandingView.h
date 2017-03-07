//
//  MobileLandingView.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 21/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"

@interface MobileLandingView : UIView 

@property (strong, nonatomic) IBOutlet UIGridView *homeIconTable;

@property (strong, nonatomic) IBOutlet UIView   *footerView;

+(MobileLandingView *)loadView;

-(void)loadMobileLandingData;

@end
