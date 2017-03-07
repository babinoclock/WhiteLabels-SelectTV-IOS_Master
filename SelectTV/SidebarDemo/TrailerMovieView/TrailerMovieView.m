//
//  TrailerMovieView.m
//  SidebarDemo
//
//  Created by scott harris on 9/29/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "TrailerMovieView.h"

@implementation TrailerMovieView



- (instancetype)init
{
    self = [super init];
    if (self) {
        links = [NSMutableArray array];
        index = 0;
    }
    return self;
}

-(void)setTrailers:(NSMutableArray *)arrTrailers
{
    links = [NSMutableArray arrayWithArray:arrTrailers];
    
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.playerView)
    {
        self.playerView.delegate = self;
    }
    
  
}



- (IBAction)onCancel:(id)sender {
    [self.playerView stopVideo];
    
    //     [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel Trailers" object:self];
    [self removeFromSuperview];
    
    
}

- (void) startPlay
{
   
    
    if([links count]==0){
        //  [self showError:@"Error when starting stream, stream is zero"];
        return;
    }
    
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
    NSLog(@"playerVars %@", playerVars);
    
    if(index ==0){
        
        NSLog(@"link count: %lu", (unsigned long)links.count);
        
        [self.playerView loadWithVideoId:[self getVideoID:[links objectAtIndex:0]] playerVars:playerVars];
    }else{
        
        [self.playerView cueVideoById:[self getVideoID:[links objectAtIndex:index]] startSeconds:0 suggestedQuality:kYTPlaybackQualityMedium];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
            [self.playerView playVideo];
            
        });
    }
    
    index++;
    
    
}

-(NSString*)getVideoID:(NSString*)url
{
    NSArray* spilts = [url componentsSeparatedByString: @"="];
    NSString* idVideo = [spilts objectAtIndex: 1];
    NSLog(@"spilts %@", spilts);
    NSLog(@"idVideo %@", idVideo);
    return idVideo;
    
}


#pragma mark - YTPlayer View Delegate
#pragma mark - Video view Delegate
- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    
    [self.playerView playVideo];
    
}

- (void) playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    
    switch (state) {
            
        case kYTPlayerStatePlaying:
            
            break;
            
        case kYTPlayerStateEnded:
            if(index >= [links count]){
                return;
            }
            [self startPlay];
            
            break;
            
        default:
            break;
            
    }
    
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    UIAlertView* alertView =[[UIAlertView alloc] init];
    [alertView setTitle:@"Video Error"];
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}
@end
