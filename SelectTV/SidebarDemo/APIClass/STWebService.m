//
//  SHWebService.m
//

#import "STWebService.h"


@implementation STWebService

+(instancetype)sharedWebService{
    
    static STWebService * sharedWebSercice = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedWebSercice = [[self alloc] init];
    });
    
    return sharedWebSercice;
}

- (id)init {
    
    NSURL *baseURL = [NSURL URLWithString:@"http://indiawebcoders.com/urls.php"];
    
    self = [self initWithBaseURL:baseURL];
    
    if (self) {
        
        self.requestSerializer  = [AFJSONRequestSerializer serializer];
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [self.requestSerializer setTimeoutInterval:120];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"application/x-www-form-urlencoded", nil];
        
    }
     [self.requestSerializer setTimeoutInterval:120];
    
    return self;
}

- (void)getNeedHelpLink:(void(^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure {
    
    NSString *url = @"http://indiawebcoders.com/urls.php";

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:url
   parameters:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          
          if ([responseObject isKindOfClass:[NSArray class]]) {
              
              if (success) success(responseObject);
              
              NSLog(@"Success");
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          if(failure) failure (error);
          NSLog(@"Failed");
          
      }];
    
   
   
}




@end
