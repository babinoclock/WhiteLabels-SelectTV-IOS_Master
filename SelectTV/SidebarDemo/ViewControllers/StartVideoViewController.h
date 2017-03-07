//
//  StartVideoViewController.h
//  SidebarDemo
//
//  Created by Karthikeyan on 27/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RabbitTVManager.h"
#import "H5WebKitBugsManager.h"
#import "AppCommon.h"
#import "AppConfig.h"

@interface StartVideoViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIView *introOne;
    IBOutlet UIView *introTwo;
    IBOutlet UIView *introThree;
    IBOutlet UIScrollView *contentScrollView;
    MPMoviePlayerController *theMoviPlayer;
    
    IBOutlet UIPageControl *pageControll;
    NSTimer *myTimer;
    int whichPage;
    
    

}
@property (strong, nonatomic) IBOutlet UILabel *introOneWelcomeLabel;
-(IBAction)pageChanged:(id)sender;

@end
