//
//  PlusViewController.m
//  SidebarDemo
//
//  Created by Panda on 7/23/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "PlusViewController.h"
#import "Constants.h"


@interface PlusViewController ()

@end

@implementation PlusViewController

NSString* m_strVideoUrl = @"dz1TxIWmACU";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerView.delegate = self;

    //NEWLY Changing showinfo @1 to @0  to hide video info(title) and ShareIcon
    //Changing controls @1 to @0 to hide controls
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay":@1,
                                 @"showinfo" : @0,//raji
                                 @"rel" : @0,
                                 @"controls" : @0,
                                 @"origin" : @"https://www.example.com", // this is critical
                                 @"modestbranding" : @1
                                 };
    [self.playerView stopVideo];
    
    [self.playerView loadWithVideoId:m_strVideoUrl playerVars:playerVars];
    [self.playerView playVideo];

    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.playerView stopVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    [self.playerView playVideo];
    
    
}

- (void) playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    switch (state) {
            
        case kYTPlayerStatePlaying:
            
            break;
            
        case kYTPlayerStateEnded:
            
            [self.playerView cueVideoById:m_strVideoUrl startSeconds:0 suggestedQuality:kYTPlaybackQualityMedium];
            
            break;
            
        default:
            break;
            
    }
}


-(IBAction) onGetItNow:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *url = [NSURL URLWithString:EXTERNAL_LINK];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
}
- (IBAction)onBack:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
