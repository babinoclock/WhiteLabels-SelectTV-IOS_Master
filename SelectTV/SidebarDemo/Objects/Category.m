//
//  Chanel.m
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "Category.h"

@implementation Category

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)initByData:(NSString *)_parentID selfID:(NSString *)_id name:(NSString *)_selfName
{
    self.idParent = _parentID;
    self.idCategory = _id;
    self.name = _selfName;
    
}

-(void)initByJsonData:(NSMutableDictionary*)dic
{
    self.idCategory = [dic valueForKey:@"id"];
    self.idParent = [dic valueForKey:@"parent_id"];
    self.name = [dic valueForKey:@"name"];

}

@end
