//
//  PlayerViewController.h
//  SidebarDemo
//
//  Created by Panda on 7/13/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

- (void) setURL:(NSString *)strVideoUrl;
- (IBAction) goBack:(id)sender;

@end
