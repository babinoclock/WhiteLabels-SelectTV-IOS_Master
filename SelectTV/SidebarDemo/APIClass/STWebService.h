//
//  SHWebService.h
//

#import <AFNetworking/AFNetworking.h>



@interface STWebService : AFHTTPSessionManager

+(instancetype)sharedWebService;

- (void)getNeedHelpLink:(void(^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure;


@end
