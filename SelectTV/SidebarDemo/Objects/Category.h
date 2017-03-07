//
//  Chanel.h
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property(nonatomic,retain) NSString* idCategory;
@property(nonatomic,retain) NSString* idParent;
@property(nonatomic,retain) NSString* name;

-(void)initByJsonData:(NSMutableDictionary*)dic;

-(void)initByData:(NSString*)_parentID selfID:(NSString*)_id name:(NSString*)_name;

@end
