//
//  AppDelegate.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "AppDelegate.h"
#import "RabbitTVManager.h"
#import "H5WebKitBugsManager.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "LoginViewController.h"
#import "StartScreenViewController.h"


@implementation UINavigationController (navrotations)

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}
@end


static AppDelegate * appDelegate;

@implementation AppDelegate
@synthesize client;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    NSLog(@"isBroadView = %@",APP_TITLE);
    
    NSLog(@"isArvig = %@",APP_TITLE);
    
    _isSubscriptPage = @"NO";
    if([self isMyAppInstalled]) {
        NSLog(@"Found");
    } else {
        NSLog(@"Not Found");
    }
    [COMMON removeFileFromLocalCache];
    [COMMON removeAppManagerManualNotification];

    
    appDelegate = self;
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc]
                                                    init];
    revealViewController.delegate = self;

    //NewRelicAgent
    [NewRelicAgent startWithApplicationToken:@"AA65c8e5df95fa18c7885d03bc1569cac2e94d2965"];
    
    [COMMON isAppManager:@"NO"];
    
    [H5WebKitBugsManager fixAllBugs];
    
    [COMMON setAppManagerManualNotification:@"YES"];
  
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ENTER_FOREGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    
    
    // Change the background color of navigation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // Change the font style of the navigation bar
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica-Light" size:21.0], NSFontAttributeName, nil]];
    
      //Check USER LOGGEDIN
    if ([COMMON isUserLoggedIn]) {
        
        [self pushToStartScreen];
    }
    else{//pushToVideoScreen
//        [self pushToLoginScreen];
        [self pushToVideoScreen];
    }
    
//    if ([COMMON isUserFirstTimeLoggedIn]) {
//        //        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SplashScreenImage"]];
//        [self pushToIntro];
//    }
    
    return YES;
}

- (BOOL)isMyAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cbs:"]];
}

#pragma mark - pushToStartScreen
-(void)pushToStartScreen{//StartVideoViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    StartScreenViewController * startScreenVC = nil;
    startScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"StartScreenViewController"];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:startScreenVC];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
}

- (void)pushToVideoScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    StartScreenViewController * startScreenVC = nil;
    startScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"StartVideoViewController"];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:startScreenVC];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];

}

#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
}

//- (void)pushToIntro{
//    [self.navigationController.navigationBar setHidden:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//    IntroViewController *viewController = (IntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
//    [self.navigationController pushViewController:viewController animated:NO];
//}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //exit(0);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSUserDefaults standardUserDefaults] setObject:ENTER_FOREGROUND  forKey:ENTER_FOREGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [COMMON removeAppManagerManualNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [COMMON removeAppManagerManualNotification];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - App Delegate Instance Get
+(id)sharedAppDelegate
{
    return appDelegate;
}

#pragma mark- Set current viewcontroller
-(void)setVcCurrent:(NSString *)vcCurrentID
{
    _vcCurrentID = vcCurrentID;
}
-(NSString*)vcCurrentID
{
    return _vcCurrentID;
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    // handler code here
//}


@end
