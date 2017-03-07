//
//  ChanelManager.m
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "ChanelManager.h"

static ChanelManager* instance = NULL;

@implementation ChanelManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        instance = self;
        self.arrCategories =[NSMutableArray array];
        
    }
    return self;
}

+(id)sharedChanelManager
{
    
    if(instance==NULL)
    {
        instance = [[ChanelManager alloc] init];
    }
    return instance;
    
}
-(void)initWithJsonData:(NSMutableArray *)jsonchanels
{
    self.arrCategories = [NSMutableArray array];
    
    for(int i=0;i<[jsonchanels count];i++)
    {
        NSMutableDictionary*dic = [jsonchanels objectAtIndex:i];
        Category* category = [[Category alloc] init];
        [category initByJsonData:dic];
        [self.arrCategories addObject:category];
        
    }
    
}

-(NSMutableArray*)subCatergories:(NSString *)idCategory
{
    NSMutableArray* subCats = [NSMutableArray array];
    
    if(idCategory==(NSString*)[NSNull null] || idCategory == nil){
        
        for (int i=0; i< [self.arrCategories count]; i++) {
            
            Category* category = [self.arrCategories objectAtIndex:i];
            
            if ([category.idParent isKindOfClass:[NSString class]] && [category.idParent isEqualToString:@""]) {
                category.idParent = nil;
            }
            
            if(category.idParent == (NSString*)[NSNull null] || category.idParent == nil)
            {
                [subCats addObject:category];
            }
            
        }
        
    }else{
        
        for (int i=0; i< [self.arrCategories count]; i++) {
            Category* category = [self.arrCategories objectAtIndex:i];
            
            if ([category.idParent isKindOfClass:[NSString class]] && [category.idParent isEqualToString:@""]) {
                category.idParent = nil;
            }
            
            if([category.idParent isEqual:idCategory] || category.idParent == idCategory)
            {
                [subCats addObject:category];
            }
        }
        
    }
    
    return subCats;
}

-(Category*)getChannel:(NSString *)idCategory
{
    for (int i = 0;i<[self.arrCategories count];i++)
    {
        
        Category* category = [self.arrCategories objectAtIndex:i];
        if([category.idCategory isEqual:idCategory])
        {
            return category;
        }
        
    }
    
    return nil;
}

-(Category*)getParentChanel:(Category *)subChanel
{
    
    NSString* idChanel = [subChanel idParent];
    
    if ([idChanel isKindOfClass:[NSString class]] && [idChanel isEqualToString:@""]) {
        idChanel = nil;
    }
    
    if(idChanel == (NSString*)[NSNull null] || idChanel == nil)
    {
        return nil;
        
    }else{
        return [self getChannel:idChanel];
    }
    return nil;
    
}

@end
