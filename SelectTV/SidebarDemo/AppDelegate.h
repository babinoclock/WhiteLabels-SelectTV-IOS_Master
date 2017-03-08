//
//  AppDelegate.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitTVManager.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "SWRevealViewController.h"
#import "StartVideoViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <NewRelicAgent/NewRelic.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>
{
    NSString* _vcCurrentID;
}

@property (strong, nonatomic) UIWindow *window;

@property( retain,nonatomic) NSString* vcCurrentID;

@property(nonatomic,retain) AFJSONRPCClient *client;

@property (strong, nonatomic) NSString *isSubscriptPage;

+(id)sharedAppDelegate;
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
