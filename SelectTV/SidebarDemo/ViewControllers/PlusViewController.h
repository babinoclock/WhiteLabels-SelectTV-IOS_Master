//
//  PlusViewController.h
//  SidebarDemo
//
//  Created by Panda on 7/23/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
@interface PlusViewController : UIViewController<YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

-(IBAction) onGetItNow:(id)sender;

@end
