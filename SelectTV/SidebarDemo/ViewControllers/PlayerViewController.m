//
//  PlayerViewController.m
//  SidebarDemo
//
//  Created by Panda on 7/13/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppConfig.h"

@interface PlayerViewController () <YTPlayerViewDelegate>

@end

@implementation PlayerViewController

NSString* m_strVideoUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    self.view.backgroundColor = GRAY_BG_COLOR;
    
    // Do any additional setup after loading the view.
    self.playerView.delegate = self;

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    

    //NEWLY Changing showinfo @1 to @0  to hide video info(title) and ShareIcon
    //Changing controls @1 to @0 to hide controls
    
    //NSDictionary *playerVars = @{ @"playsinline" : @1};
    NSDictionary *playerVars = @{
                   @"playsinline" : @1,
                   @"autoplay":@1,
                   @"showinfo" : @0,//raji
                   @"rel" : @0,
                   @"controls" : @0,
                   @"origin" : @"https://www.example.com", // this is critical
                   @"modestbranding" : @1
                   };

    [self.playerView loadWithVideoId:m_strVideoUrl playerVars:playerVars];
    [self.playerView playVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
    //[self.playerView playVideo];
  //  [self.playerView loadWithVideoId:m_strVideoUrl];
    [self.playerView playVideo];
    
}

- (void) playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    
}

- (void) setURL:(NSString *)strVideoUrl
{
    m_strVideoUrl = strVideoUrl;


}

- (IBAction) goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) orientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            [self rotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self rotateViews:false];
            break;
            
        default:
            break;
    }
}

-(void) rotateViews:(BOOL) bPortrait{
    if(bPortrait){
        int nWidth = [UIScreen mainScreen].bounds.size.width;
        int nHeight = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height;
        
        self.playerView.frame = CGRectMake(0, 0, nWidth, nHeight);
        
    }else{
        int nWidth = [UIScreen mainScreen].bounds.size.width;
        int nHeight = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height;
        
        self.playerView.frame = CGRectMake(0, 0, nWidth, nHeight);
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

@end
