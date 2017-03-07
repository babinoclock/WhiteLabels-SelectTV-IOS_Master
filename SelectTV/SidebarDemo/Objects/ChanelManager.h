//
//  ChanelManager.h
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
@interface ChanelManager : NSObject

@property(nonatomic,retain) NSMutableArray* arrCategories;

+(id)sharedChanelManager;
-(void)initWithJsonData:(NSMutableArray*)jsonchanels;

-(NSMutableArray*)subCatergories:(NSString*)idChanel;

-(Category*)getChannel:(NSString*)idChannel;
-(Category*)getParentChanel:(Category*)subChanel;

//-(NSMutableArray*)rootCategories;

@end
