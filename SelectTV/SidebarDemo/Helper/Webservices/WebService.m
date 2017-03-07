//
//  WebService.m
//  Policy 99
//
//  Created by Ocs Developer 6 on 8/12/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.


#import "WebService.h"
#import "AFNetworking.h"
#import "AppCommon.h"
#import "WebserviceConfig.h"
#import "AppCommon.h"
#import "iCarousel.h"

static const NSString *WebServicePost   = @"POST";
static const NSString *WebServiceGet    = @"GET";
static const NSString *WebServicePut    = @"PUT";
static const NSString *WebServiceDelete = @"DELETE";

static const NSString *WebServiceContentJSON = @"application/json";
static const NSString *WebServiceContentFORM = @"application/x-www-form-urlencoded";
static NSString       *WebServiceMimeType    = @"image/jpeg";

static const NSString *baseUrl  = @"http://qtv3.neatsoft.org/";

@interface WebService (){
    NSString *urlString;
    NSString *baseUrl;
    BOOL isConfigAPI;
}

@end


@implementation WebService
- (id)init {
    self = [super init];
    if (self) {
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",@"image/png",nil];
    }
    return self;
}

+ (WebService *)service {
    return [[WebService alloc] init];
}

#pragma mark - Get Method

-(void)getConfigAPI:(NSString *)ApiConfig
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,ApiConfig];
    NSLog(@"urlString = %@",urlString);
    isConfigAPI = YES;
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
                  saveContentToFileName:ConfigAPI
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getContact:(NSString *)_contact
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure{
    
      baseUrl = [self getBaseURL:ApiPaths];
     if(baseUrl !=nil && ![baseUrl isEqualToString:@""]){
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_contact];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:getContacts
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)GetMyPolicyDetails:(NSString *)MypolicyDetails
                 customer:(NSString *)customer
                       ID:(NSString *)customerId
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure
{
    //Switch API
    urlString=[NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@?%@=%@",MypolicyDetails,customer,customerId];
    NSLog(@"urlsting=%@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)getFaqs:(NSString *)Faq
       success:(WebServiceRequestSuccessHandler)success
       failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,Faq];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                  saveContentToFileName:getFaq
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getManagement:(NSString *)Management
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,Management];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
         saveContentToFileName:getManagementTeam
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}



-(void)getClient:(NSString *)Client
         success:(WebServiceRequestSuccessHandler)success
         failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,Client];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
         saveContentToFileName:getOurClients
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}




-(void)getAward:(NSString *)Awards
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,Awards];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
               saveContentToFileName:getAwards
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}
-(void)getForgetPassword:(NSString *)forgetpwd
                   email:(NSString *)email
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?email=%@",baseUrl,forgetpwd,email];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                    saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getActivation:(NSString *)activation
    verificationCode:(NSString *)code
              userId:(NSString *)userID
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?verificationCode=%@&userid=%@",baseUrl,activation,code,userID];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                  saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}
-(void)getResendcode:(NSString *)resendCode
       userid:(NSString *)userId 
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?userid=%@",baseUrl,resendCode,userId];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)Register:(NSString *)registration
             firstName:(NSString *)fname
              lastName:(NSString *)lname
                 email:(NSString *)email
                mobile:(NSString *)mobile
              password:(NSString *)password
           registerVia:(NSString *)registerVia
                 group:(NSString *)group
       appViaregistered:(NSString *)appViaregistered
            profilelink:(NSString *)profilelink
                    dob:(NSString *)dob
                 sn_key:(NSString *)sn_key
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?firstname=%@&lastname=%@&email=%@&mobile=%@&password=%@&registeredVia=%@&group=%@&appViaregistered=%@&profilelink=%@&dob=%@&sn_key=%@",baseUrl,registration,fname,lname,email,mobile,password,registerVia,group,appViaregistered,profilelink,dob,sn_key];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
               saveContentToFileName:@""
               completionSucessHandler:success
               completionFailureHandler:failure];
    }
    
}

-(void)Login:(NSString *)login
       email:(NSString *)Email
    password:(NSString *)Password
  deviceType:(NSString *)deviceType
 deviceToken:(NSString *)deviceToken
     success:(WebServiceRequestSuccessHandler)success
     failure:(WebServiceRequestFailureHandler)failure{
    
    //baseUrl = [self getBaseURL:ApiPaths];
    baseUrl =@"http://www.policy99.com/manage/api/data/";
    //Switch API
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?email=%@&password=%@&device_type=%@&device_token=%@",baseUrl,login,Email,Password,deviceType,deviceToken];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                  saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)socialNetworksLogin:(NSString *)socialLogin
                 firstName:(NSString *)firstname
                  lastName:(NSString *)lastname
                     email:(NSString *)email
                    mobile:(NSString *)mobile
                      type:(NSString *)type
                    sn_key:(NSString *)sn_key
              profileImage:(NSString *)profileImg
                       dob:(NSString *)dob
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?firstname=%@&lastname=%@&email=%@&mobile=%@&type=%@&sn_key=%@&profilelink=%@&dob=%@",baseUrl,socialLogin,firstname,lastname,email,mobile,type,sn_key,profileImg,dob];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                  saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getProduct:(NSString *)Products
           success:(WebServiceRequestSuccessHandler)success
           failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,Products];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                saveContentToFileName:getProducts
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getProductform:(NSString *)productForm
            productId:(NSString *)productID
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?Productid=%@",baseUrl,productForm,productID];
        NSLog(@"urlString = %@",urlString);
        
        NSString *fileName = [NSString stringWithFormat:@"form%@",productID];
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
         saveContentToFileName:fileName
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)getProductdetail:(NSString *)productdetail
            productName:(NSString *)productname
                success:(WebServiceRequestSuccessHandler)success
                failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?product=%@",baseUrl,productdetail,productname];
       // urlString = [NSString stringWithFormat:@"http://policy99.com/manage/api/data/getProductDetailstest?product=%@",productname];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:productname
               completionSucessHandler:success
              completionFailureHandler:failure];
    }

}

-(void)getManufacture:(NSString *)manufacture
          vehicleType:(NSString *)vehicleType
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?vehicletype=%@",baseUrl,manufacture,vehicleType];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
             saveContentToFileName:getManufacturer
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}


-(void)getModel:(NSString *)models code:(NSString *)manufacturerCode
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?manufacturercode=%@",baseUrl,models,manufacturerCode];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                   saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)getSubmodels:(NSString *)subModels
    vehicleModeCode:(NSString *)code
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?vehiclemodelcode=%@",baseUrl,subModels,code];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                     saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }

}

-(void)Capacity:(NSString *)capacity
   vehicleModeCode:(NSString *)code
           success:(WebServiceRequestSuccessHandler)success
           failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?vehiclemodelcode=%@",baseUrl,capacity,code];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }

    
}

-(void)getManufactureYear:(NSString *)year
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,year];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
         saveContentToFileName:getManufacturerYear
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}


-(void)getstates:(NSString *)states
         success:(WebServiceRequestSuccessHandler)success
         failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,states];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:getStates
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)getcity:(NSString *)city
     stateCode:(NSString *)code
       success:(WebServiceRequestSuccessHandler)success
       failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?statecode=%@",baseUrl,city,code];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                          saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getPinCode:(NSString *)pinCode
         cityCode:(NSString *)citycode
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?citycode=%@",baseUrl,pinCode,citycode];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
         saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getReg_States:(NSString *)regStates
                type:(NSString *)type
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?type=%@",baseUrl,regStates,type];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                  saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)getRegCity:(NSString *)regCity
        stateCode:(NSString *)stateCode
             type:(NSString *)type
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?statecode=%@&type=%@",baseUrl,regCity,stateCode,type];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                        saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)InsuredList:(NSString *)list
           success:(WebServiceRequestSuccessHandler)success
           failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,list];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:getInsurerList
               completionSucessHandler:success
              completionFailureHandler:failure];
    }

    
}

-(void)getRenewalPolicy:(NSString *)renewPolicy
                success:(WebServiceRequestSuccessHandler)success
                failure:(WebServiceRequestFailureHandler)failure{
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,renewPolicy];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:getrenewalCorner
           completionSucessHandler:success
          completionFailureHandler:failure];
}
-(void)getMemberIBA:(NSString *)memberIBAI
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,memberIBAI];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:getMemberIBAI
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getTravelInsurance:(NSString *)travelInsurance
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure{
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,travelInsurance];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)viewportfolio:(NSString *)_viewportfolio
              portID:(NSString *)portId
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@?portId=%@",baseUrl,_viewportfolio,portId];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)listportfolio:(NSString *)_listPortfolio
              userID:(NSString *)userId
             productId:(NSString *)productID
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@?userId=%@&productId=%@",baseUrl,_listPortfolio,userId,productID];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)deleteportfolio:(NSString *)_deletePortfolio
           portfolioId:(NSString *)portfolioID
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl =[self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@?portfolioId=%@",baseUrl,_deletePortfolio,portfolioID];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)getProductname:(NSString *)productName
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,productName];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:productName
               completionSucessHandler:success
              completionFailureHandler:failure];

    }
}

    
-(void)getCompanyname:(NSString *)companyName
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,companyName];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:companyName
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getconstants:(NSString *)constants
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure
{
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if(baseUrl !=nil && ![baseUrl isEqualToString:@""])
    {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,constants];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:constants
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
}

-(void)getportfolio:(NSString *)portfolio
             userID:(NSString *)userId
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@?userId=%@",baseUrl,portfolio,userId];
        NSLog(@"urlString = %@",urlString);
        [self sendRequestWithURLString:urlString
                         andParameters:nil
                                method:WebServiceGet
                 saveContentToFileName:getPortfolio
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)GetRelationshipList:(NSString *)_relationShip
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    
     baseUrl = [self getBaseURL:ApiPaths];
    
     urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_relationShip];
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:RelationShipList
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}
-(void)GetDoc_CategoryType:(NSString *)_categoryType
                         success:(WebServiceRequestSuccessHandler)success
                         failure:(WebServiceRequestFailureHandler)failure{
   // baseUrl = @"http://dev.upc.org/alert-works/newpolicy/policy99-live/manage/index.php?route=api/data/";
    baseUrl = [self getBaseURL:ApiPaths];
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_categoryType];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)AddandUpdateFamilymembersAPI:(NSString *)_addMembers
                 firstName:(NSString *)first_name
                  lastName:(NSString *)last_name
                     email:(NSString *)email
                    mobile:(NSString *)mobile
                       pan:(NSString *)pan
                     adhar:(NSString *)adharNum
                       dob:(NSString *)_dob
                    gender:(NSString *)gender
              relationship:(NSString *)relationship
                    userId:(NSString *)userId
                  updateId:(NSString *)_updateId
              profileImage:(UIImage *)profileImg
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    
                    NSMutableDictionary *addInfo = [[NSMutableDictionary alloc] init];
        
                    [addInfo setObject:first_name  forKey:@"first_name"];
                    [addInfo setObject:last_name  forKey:@"last_name"];
                    [addInfo setObject:email  forKey:@"email"];
                    [addInfo setObject:mobile  forKey:@"mobile"];
                    [addInfo setObject:pan  forKey:@"pan"];
                    [addInfo setObject:adharNum  forKey:@"adhar"];
                    [addInfo setObject:_dob  forKey:@"dob"];
                    [addInfo setObject:gender  forKey:@"gender"];
                    [addInfo setObject:relationship  forKey:@"relationship"];
                    [addInfo setObject:userId forKey:@"user_id"];
    
                    if(![_updateId isEqualToString:@""])   [addInfo setObject:_updateId forKey:@"updated_id"];
    
                    baseUrl = [self getBaseURL:ApiPaths];
    
                    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_addMembers];
                    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:addInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",urlString);
         NSLog(@"user = %@",addInfo);
         if(profileImg){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImg)
                                         name:@"profileimg"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([[responseObject valueForKey:@"Status"] isEqualToString:@"Success"]){
//            [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"addupdatemembers"
              object:self
              userInfo:nil];
         }
         else{
             // [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
             NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"Message"]description]];
             str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
             str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//             [COMMON showErrorAlert:str];
             
         }
                [COMMON removeLoading];
         NSLog(@"response = %@",responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           
           NSLog(@"error=%@",error);
           
           NSLog(@"userInfo=%@",error.userInfo);
           
           NSLog(@"localizedDescription=%@",error.localizedDescription);
          
           NSLog(@"localizedFailureReason=%@",error.localizedFailureReason);
          
           NSLog(@"localizedRecoverySuggestion=%@",error.localizedRecoverySuggestion);
           NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
           NSDictionary *serializedData;
           
           if(errorData!=nil)
            serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"serializedData = %@", serializedData);
           [COMMON removeLoading];
       }];
}


-(void)listFamilyMembers:(NSString *)listMembers
                  userID:(NSString *)_userId
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,listMembers];
    
    NSMutableDictionary *listDict = [[NSMutableDictionary alloc]init];
    
    [listDict setObject:_userId forKey:@"user_id"];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:listDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)uploadDocuments:(NSString *)uploadDoc
                userID:(NSString *)userID
              memberID:(NSString *)memberID
            categoryID:(NSString *)categoryID
                typeID:(NSString *)typeID
            expiryDate:(NSString *)expiryDate
              otherDoc:(NSString *)otherDocName
              docImage:(UIImage *)docImage
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *uploadInfo = [[NSMutableDictionary alloc] init];
    
    [uploadInfo setObject:userID  forKey:@"user_id"];
    
    [uploadInfo setObject:memberID forKey:@"upl-members"];
    
    [uploadInfo setObject:categoryID  forKey:@"upl-category"];
    
    [uploadInfo setObject:typeID forKey:@"upl-type"];
    
    [uploadInfo setObject:expiryDate forKey:@"expiry_date"];
    
    [uploadInfo setObject:otherDocName forKey:@"otherdocument"];
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,uploadDoc];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:uploadInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",uploadInfo);
         if(docImage){
             [formData appendPartWithFileData:UIImagePNGRepresentation(docImage)
                                         name:@"upl-familydocs"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject = %@",responseObject);
         if([[responseObject valueForKey:@"Status"] isEqualToString:@"Success"]){
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:@"uploaddocsuccess"
                       object:self
                       userInfo:nil];

         }
         else{
              NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"Message"]description]];
              str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
              str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//              [COMMON showErrorAlert:str];
             
         }
                 [COMMON removeLoading];
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           [COMMON removeLoading];
       }];

    
}

-(void)deleteDocuments:(NSString *)deletedoc
              memberId:(NSString *)member_id
            documentId:(NSString *)doc_id
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,deletedoc];
    
    NSMutableDictionary *deleteDict = [[NSMutableDictionary alloc]init];
    
    [deleteDict setObject:member_id forKey:@"member_id"];
    
    [deleteDict setObject:doc_id forKey:@"doc_id"];
    
    NSLog(@"urlString = %@",urlString);
    
    NSLog(@"deleteDict = %@",deleteDict);
    
    [self sendRequestWithURLString:urlString
                     andParameters:deleteDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)deleteMembers:(NSString *)deletedoc
              userID:(NSString *)user_id
            memberId:(NSString *)member_id
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,deletedoc];
    
    NSMutableDictionary *deleteDict = [[NSMutableDictionary alloc]init];
    
    [deleteDict setObject:member_id forKey:@"member_id"];
    
    [deleteDict setObject:user_id forKey:@"user_id"];
    
    NSLog(@"urlString = %@",urlString);
    
    NSLog(@"deleteDict = %@",deleteDict);
    
    [self sendRequestWithURLString:urlString
                     andParameters:deleteDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TravelInsurance:(NSString *)travelInsurance
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
   //http://staging.policy99.com/app/overseas-travel-insurance
    baseUrl =@"https://www.policy99.com/app/overseas-travel-insurance";//https://www.policy99.com/manage/api/data/getExternalTravelInsurance
    urlString = [NSString stringWithFormat:@"%@",baseUrl];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TravelInsuranceQuote:(NSString *)travelInsurance
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl =@"https://www.policy99.com/manage/api/data/getExternalTravelInsurance";
    urlString = [NSString stringWithFormat:@"%@",baseUrl];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}


#pragma mark - Post method

-(void)postContactus:(NSString *)contactUs
                name:(NSString *)name
               email:(NSString *)email
              mobile:(NSString *)mobile
             enquiry:(NSString *)enquiry
          uploadfile:(UIImage *)uploadfile
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:name  forKey:@"name"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:mobile  forKey:@"phone"];
    [userInfo setObject:enquiry  forKey:@"enquiry"];
    
     baseUrl = [self getBaseURL:ApiPaths];
    
     urlString = [NSString stringWithFormat:@"%@%@",baseUrl,contactUs];
    
     NSLog(@"urlString = %@",urlString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];

    [self POST:urlString parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",userInfo);
         if(uploadfile){
             [formData appendPartWithFileData:UIImagePNGRepresentation(uploadfile)
                                         name:@"file1"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
    }
     
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([[responseObject valueForKey:@"status"] isEqualToString:@"Success"]){
//             [COMMON showErrorAlert:[[responseObject valueForKey:@"message"]valueForKey:@"success"]];
         }
         else{
             
             NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"message"]description]];
             str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
             str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//             [COMMON showErrorAlert:str];

             //[COMMON showErrorAlert:[[responseObject valueForKey:@"message"]valueForKey:@"enquiry"]];
         }//contactsuccess
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"contactsuccess"
          object:self
          userInfo:nil];
         [COMMON removeLoading];
         NSLog(@"response = %@",responseObject);
      }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [COMMON removeLoading];
       }];
    
}

-(void)postProfiledata:(NSString *)profile
            customerID:(NSString *)customerID
          profileimage:(UIImage *)profileimage
             firstname:(NSString *)firstname
              lastname:(NSString *)lastname
         date_of_birth:(NSString *)date_of_birth
                gender:(NSString *)gender
                 email:(NSString *)email
             telephone:(NSString *)telephone
               address:(NSString *)address
        officeaddresss:(NSString *)officeaddresss
              passport:(NSString *)passport
    passportexpirydate:(NSString *)passportexpirydate
               pancard:(NSString *)pancard
           nomineename:(NSString *)nomineename
            nomineedob:(NSString *)nomineeDob
            nomineeage:(NSString *)nomineeage
   nomineerelationship:(NSString *)nomineerelationship
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
        
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:customerID  forKey:@"customer_id"];
    [userInfo setObject:firstname  forKey:@"firstname"];
    [userInfo setObject:lastname  forKey:@"lastname"];
    [userInfo setObject:date_of_birth  forKey:@"birth"];
    [userInfo setObject:gender  forKey:@"gender"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:telephone  forKey:@"telephone"];
    [userInfo setObject:address  forKey:@"address"];
    [userInfo setObject:officeaddresss  forKey:@"office"];
    [userInfo setObject:passport  forKey:@"passno"];
    [userInfo setObject:passportexpirydate  forKey:@"passexpdate"];
    [userInfo setObject:pancard  forKey:@"pancartno"];
    [userInfo setObject:nomineename  forKey:@"nomname"];
    [userInfo setObject:nomineeDob  forKey:@"nomineedob"];
    [userInfo setObject:nomineeage  forKey:@"nomage"];
    [userInfo setObject:nomineerelationship  forKey:@"relation"];
    
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,profile];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",userInfo);
         if(profileimage){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileimage)
                                         name:@"images"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([[responseObject valueForKey:@"status"] isEqualToString:@"Error"]){
             NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"message"]description]];
             str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
             str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//             [COMMON showErrorAlert:str];
         }
         else{
            
//             [COMMON setUserDetails:[responseObject valueForKey:@"userdatails"]];
//             [COMMON showErrorAlert:[responseObject valueForKey:@"message"]];
         }
         [COMMON removeLoading];
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"profileupdatedsuccess"
          object:self
          userInfo:nil];
         NSLog(@"response = %@",responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [COMMON removeLoading];
     }];
    
    
}

-(void)CalculateIDV:(NSString *)Idv
              model:(NSString *)model
          vehicleCD:(NSString *)vehicleCD
        manufacture:(NSString *)manufacture
          startDate:(NSString *)startDate
           location:(NSString *)location
           reg_date:(NSString *)regDate
    manufactureYear:(NSString *)year
        productName:(NSString *)productname
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    
    urlString = [NSString stringWithFormat:@"http://policy99.com/manage/api/data/calculateIDV"];
    
    
    
    NSMutableDictionary *IdvDict = [[NSMutableDictionary alloc] init];
    
     if(model)           [IdvDict setObject:model forKey:@"model"];
     if(vehicleCD)       [IdvDict setObject:vehicleCD forKey:@"vehiclecd"];
     if(manufacture)     [IdvDict setObject:manufacture forKey:@"manufactures"];
     if(startDate)       [IdvDict setObject:startDate forKey:@"policystartdate"];
     if(location)        [IdvDict setObject:location forKey:@"location"];
     if(regDate)         [IdvDict setObject:regDate forKey:@"registration_date"];
     if(year)            [IdvDict setObject:year forKey:@"manufacture_year"];
     if(productname)     [IdvDict setObject:productname forKey:@"productName"];
    
   
    
    NSLog(@"urlString = %@",urlString);
     NSLog(@"dict = %@",IdvDict);
    [self sendRequestWithURLString:urlString
                     andParameters:IdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];



}

-(void)Insert_Form:(NSString *)_insertForm
         productID:(NSString *)productId
        customerID:(NSString *)customerID
        formdetailDict:(NSString *)formdetailDict
           success:(WebServiceRequestSuccessHandler)success
           failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_insertForm];
        
         NSLog(@"updateFormDict=%@",formdetailDict);
        NSMutableDictionary *formDetails = [[NSMutableDictionary alloc] init];
        
        
        
        if(productId)              [formDetails    setObject:productId             forKey:@"product_id"];
                                   [formDetails    setObject:customerID            forKey:@"CustomerId"];
                                   [formDetails    setObject:formdetailDict        forKey:@"jsonStr"];
        
        
        NSLog(@"urlString = %@",urlString);
        NSLog(@"formDetails = %@",formDetails);
        [self sendRequestWithURLString:urlString
                         andParameters:formDetails
                                method:WebServicePost
                 saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }
    
}

-(void)updateForm:(NSString *)_updateForm
   lastInsertedID:(NSString *)insertedID
      productName:(NSString *)productName
        productID:(NSString *)productId
    imageUpload:(UIImage *)imageUpload
   updateFormDict:(NSString *)updateFormDict
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_updateForm];
        
        NSMutableDictionary *updateDetails = [[NSMutableDictionary alloc] init];
        
        if(insertedID)             [updateDetails setObject:insertedID forKey:@"LastInsertedId"];
                                   [updateDetails setObject:productName forKey:@"productName"];
                                   [updateDetails setObject:productId forKey:@"productId"];
                                   [updateDetails setObject:updateFormDict forKey:@"jsonStr"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
        NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        
        [self POST:urlString parameters:updateDetails constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             NSLog(@"baseAPI = %@",baseUrl);
             NSLog(@"urlString = %@",urlString);
             NSLog(@"user = %@",updateDetails);
             if(imageUpload){
                 [formData appendPartWithFileData:UIImagePNGRepresentation(imageUpload)
                                             name:@"mobileupload"
                                         fileName:imageNameStr
                                         mimeType:@"image/png"];
                 
                 NSLog(@"formData = %@",formData);
             }
         }
         
           success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"responseObject = %@",responseObject);
             NSLog(@"responseObject = %@",responseObject);
             if([responseObject isKindOfClass:[NSDictionary class]]){
                 if([[responseObject valueForKey:@"status"]isEqualToString:@"Success"]){
                     
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"updateform"
                      object:self
                      userInfo:responseObject];

                 }
                 else{
//                     [COMMON showErrorAlert:[responseObject valueForKey:@"message"]];
                 }
                 [COMMON removeLoading];
             }
         }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [COMMON removeLoading];
         }];
        


    }
    
}

-(void)postnewOfflineQuotes:(NSString *)quotes
                 policyType:(NSString *)policyType
                  productId:(NSString *)productID
                       name:(NSString *)name
                      email:(NSString *)email
                     mobile:(NSString *)mobile
                 invoiceImg:(UIImage *)invoiceImg
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *formDetails = [[NSMutableDictionary alloc] init];
    
    [formDetails setObject:policyType  forKey:@"policytype"];
    [formDetails setObject:productID  forKey:@"product_id"];
    [formDetails setObject:name  forKey:@"frmNameNew"];
    [formDetails setObject:email  forKey:@"frmEmailNew"];
    [formDetails setObject:mobile  forKey:@"frmMobileNew"];

    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,quotes];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:formDetails constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",formDetails);
         if(invoiceImg){
             [formData appendPartWithFileData:UIImagePNGRepresentation(invoiceImg)
                                         name:@"frmInvoice"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject = %@",responseObject);
         if([[responseObject valueForKey:@"status"]isEqualToString:@"success"])
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         
          [COMMON removeLoading];
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [COMMON removeLoading];
     }];
    
    
}

-(void)postRenewOfflineQuotes:(NSString *)quotes
                   policyType:(NSString *)policyType
                    productId:(NSString *)productID
                         name:(NSString *)name
                        email:(NSString *)email
                       mobile:(NSString *)mobile
                    rcBookImg:(UIImage *)rcBookImg
                 insuranceImg:(UIImage *)insuranceImg
                     renewImg:(UIImage *)renewImg
                    prePolicy:(NSString *)prePolicy
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *formDetails = [[NSMutableDictionary alloc] init];
    
    [formDetails setObject:policyType  forKey:@"policytype"];
    [formDetails setObject:productID  forKey:@"product_id"];
    [formDetails setObject:name  forKey:@"frmName"];
    [formDetails setObject:email  forKey:@"frmEmail"];
    [formDetails setObject:mobile  forKey:@"frmMobile"];
    [formDetails setObject:prePolicy  forKey:@"frmPrepolicy"];
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,quotes];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:formDetails constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",formDetails);
         if(rcBookImg){
             [formData appendPartWithFileData:UIImagePNGRepresentation(rcBookImg)
                                         name:@"frmRcbook"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(insuranceImg){
             [formData appendPartWithFileData:UIImagePNGRepresentation(insuranceImg)
                                         name:@"frmInsurance"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(renewImg){
             [formData appendPartWithFileData:UIImagePNGRepresentation(renewImg)
                                         name:@"frmRenewl"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
          NSLog(@"responseObject = %@",responseObject);
         if([[responseObject valueForKey:@"status"]isEqualToString:@"success"])
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         
         [COMMON removeLoading];
         
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [COMMON removeLoading];
     }];
    

    
}

-(void)postClaimdata:(NSString *)claimdata
         productType:(NSString *)productType
           firstname:(NSString *)firstname
              mobile:(NSString *)mobile
               email:(NSString *)email
             address:(NSString *)address
        policyNumber:(NSString *)policyNumber
         uploadImage:(UIImage *)uploadImage
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:productType  forKey:@"protitle"];
    [userInfo setObject:firstname  forKey:@"name-of-the-insured"];
    [userInfo setObject:mobile  forKey:@"mobile-no"];
    [userInfo setObject:email  forKey:@"e-mail-id"];
    [userInfo setObject:address  forKey:@"communication-address"];
    [userInfo setObject:policyNumber  forKey:@"policy-no"];
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,claimdata];
    
    NSLog(@"urlString = %@",urlString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",userInfo);
         if(uploadImage){
             [formData appendPartWithFileData:UIImagePNGRepresentation(uploadImage)
                                         name:@"filename"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([[responseObject valueForKey:@"status"] isEqualToString:@"success"]){
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         }
         else{
             
             NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"message"]description]];
             str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
             str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//             [COMMON showErrorAlert:str];
             
             //[COMMON showErrorAlert:[[responseObject valueForKey:@"message"]valueForKey:@"enquiry"]];
         }//contactsuccess
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"ClaimsFormsuccess"
          object:self
          userInfo:nil];
         [COMMON removeLoading];
         NSLog(@"response = %@",responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           [COMMON removeLoading];
       }];
    
}

-(void)postPolicyReminder:(NSString *)reminder
                     name:(NSString *)name
                    email:(NSString *)email
                   mobile:(NSString *)mobile
         insuranceProduct:(NSString *)product
             otherProduct:(NSString *)otherProduct
                  dueDate:(NSString *)duedate
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = [self getBaseURL:ApiPaths];
    NSLog(@"%@",baseUrl);
    if (baseUrl !=nil && ![baseUrl isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,reminder];
        
        NSMutableDictionary *policyDetails = [[NSMutableDictionary alloc] init];
        
        
        
        if(name)    [policyDetails setObject:name forKey:@"username"];
        if(email)   [policyDetails setObject:email forKey:@"useremail"];
        if(mobile)  [policyDetails setObject:mobile forKey:@"userphone"];
        if(product) [policyDetails setObject:product forKey:@"insuranceproduct"];
                    [policyDetails setObject:otherProduct forKey:@"otherinsurance"];
        if(duedate) [policyDetails setObject:duedate forKey:@"duedate"];
      
        
        
        NSLog(@"urlString = %@",urlString);
        
        [self sendRequestWithURLString:urlString
                         andParameters:policyDetails
                                method:WebServicePost
                 saveContentToFileName:@""
               completionSucessHandler:success
              completionFailureHandler:failure];
    }

    
}

-(void)postInsurancedata:(NSString *)insurancedata
            insured_name:(NSString *)insured_name
                   email:(NSString *)email
                  mobile:(NSString *)mobile
                comments:(NSString *)comments
                  files1:(UIImage *)files1
                  files2:(UIImage *)files2
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure

{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:insured_name  forKey:@"insured_name"];
    [userInfo setObject:email  forKey:@"email"];
    [userInfo setObject:mobile  forKey:@"mobile"];
    [userInfo setObject:comments  forKey:@"comments"];
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,insurancedata];
    
    NSLog(@"urlString = %@",urlString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",userInfo);
         if(files1){
             [formData appendPartWithFileData:UIImagePNGRepresentation(files1)
                                         name:@"files1"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(files2){
             [formData appendPartWithFileData:UIImagePNGRepresentation(files2)
                                         name:@"files2"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([[responseObject valueForKey:@"status"] isEqualToString:@"success"]){
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         }
         else{
             
             NSString *str = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"message"]description]];
             str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
             str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//             [COMMON showErrorAlert:str];
             
             //[COMMON showErrorAlert:[[responseObject valueForKey:@"message"]valueForKey:@"enquiry"]];
         }//contactsuccess
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"InsuranceFormsuccess"
          object:self
          userInfo:nil];
         [COMMON removeLoading];
         NSLog(@"response = %@",responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           [COMMON removeLoading];
       }];
    
}

-(void)AddPortfolio:(NSString *)_addportfolio
             userid:(NSString *)userID
        insuredname:(NSString *)name
            enddate:(NSString *)endDate
       policynumber:(NSString *)policyNo
       policyamount:(NSString *)amount
           brokerId:(NSString *)brokerID
    insuredproduct :(NSString *)product
otherinsureproduct :(NSString *)otherProduct
    insuredcompany :(NSString *)company
otherinsurecompany :(NSString *)otherCompany
          policyPdf:(UIImage *)policypdf
       vechileRegNo:(NSString *)regNo
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *addInfo = [[NSMutableDictionary alloc] init];
    [addInfo setObject:userID forKey:@"userId"];
    [addInfo setObject:name forKey:@"insuredname"];
    [addInfo setObject:endDate forKey:@"enddate"];
    [addInfo setObject:policyNo forKey:@"policynumber"];
    [addInfo setObject:amount forKey:@"policyamount"];
    [addInfo setObject:brokerID forKey:@"broker"];
    [addInfo setObject:product forKey:@"insuredproduct"];
    [addInfo setObject:otherProduct forKey:@"otherinsureproduct"];
    [addInfo setObject:company forKey:@"insuredcompany"];
    [addInfo setObject:otherCompany forKey:@"otherinsurecompany"];
    [addInfo setObject:regNo forKey:@"vechile_reg_no"];
    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_addportfolio];
    
    NSLog(@"urlString = %@",urlString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:addInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",addInfo);
         if(policypdf){
             [formData appendPartWithFileData:UIImagePNGRepresentation(policypdf)
                                         name:@"policypdf"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
        
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
          NSLog(@"responseObject = %@",responseObject);
         if([[responseObject valueForKey:@"Status"]isEqualToString:@"Sucess"]){
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Policy99.com"
                                                             message:[responseObject valueForKey:@"Message"]
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil,nil];
             [alert show];

         }
         else{
//              [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         }
         
         [COMMON removeLoading];

     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           [COMMON removeLoading];
       }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *string = [alertView buttonTitleAtIndex:buttonIndex];
    if ([string isEqualToString:@"Ok"]){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"notifyaddportfolio"
         object:self
         userInfo:nil];
        NSLog(@"alert");

    }
    
}

-(void)UpdatePortfolio:(NSString *)_updateportfolio
           portfolioId:(NSString *)portfolioID
           insuredname:(NSString *)name
             startdate:(NSString *)startDate
               enddate:(NSString *)endDate
          policynumber:(NSString *)policyNo
          policyamount:(NSString *)amount
       insuredproduct :(NSString *)product
   otherinsureproduct :(NSString *)otherProduct
       insuredcompany :(NSString *)company
   otherinsurecompany :(NSString *)otherCompany
             policyPdf:(UIImage *)policypdf
              brokerId:(NSString *)brokerID
          vechileRegNo:(NSString *)regNo
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure{
    
    NSMutableDictionary *updateInfo = [[NSMutableDictionary alloc] init];
    [updateInfo setObject:portfolioID forKey:@"portfolioId"];
    [updateInfo setObject:name forKey:@"insuredname"];
    [updateInfo setObject:startDate forKey:@"startdate"];
    [updateInfo setObject:endDate forKey:@"enddate"];
    [updateInfo setObject:policyNo forKey:@"policynumber"];
    [updateInfo setObject:amount forKey:@"policyamount"];
    [updateInfo setObject:product forKey:@"insuredproduct"];
    [updateInfo setObject:otherProduct forKey:@"otherinsureproduct"];
    [updateInfo setObject:company forKey:@"insuredcompany"];
    [updateInfo setObject:otherCompany forKey:@"otherinsurecompany"];
    [updateInfo setObject:brokerID forKey:@"broker"];
    [updateInfo setObject:regNo forKey:@"vechile_reg_no"];

    
    baseUrl = [self getBaseURL:ApiPaths];
    
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl,_updateportfolio];
    
    NSLog(@"urlString = %@",urlString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:urlString parameters:updateInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSLog(@"baseAPI = %@",baseUrl);
         NSLog(@"user = %@",updateInfo);
         if(policypdf){
             [formData appendPartWithFileData:UIImagePNGRepresentation(policypdf)
                                         name:@"policypdf"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject = %@",responseObject);
         if([[responseObject valueForKey:@"Status"]isEqualToString:@"Sucess"]){
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Policy99.com"
                                                             message:[responseObject valueForKey:@"Message"]
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil,nil];
             [alert show];
             
         }
         else{
//             [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
         }
         
         [COMMON removeLoading];
         
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           [COMMON removeLoading];
       }];
    
    
}

#pragma mark Two Wheelere API

-(void)GetTwoWheelerFormDetails:(NSString *)applyForm
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure{
    
    [self sendRequestWithURLString:TwoWheeler_Apply_Form
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:GetTwoWheelerForm
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetTwoWheelerModel:(NSString *)models
                     make:(NSString *)manufacturer
                modelname:(NSString *)modelName
              productmake:(NSString *)productmake
                modeltype:(NSString *)modeltype
                      app:(NSString *)app
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/getnewmodels?
    //http://staging.policy99.com/getnewmodels?
    //Switch API staging.policy99.com  -> www.policy99.com
    
    NSString *TwoWheelStr=@"http://www.policy99.com/getnewmodels?";
    
    TwoWheelStr=[NSString stringWithFormat:@"%@makename=%@&modelname=%@&productmake=%@&modeltype=%@&app=%@",TwoWheelStr,manufacturer,modelName,productmake,modeltype,app];
    
    NSLog(@"<<<<----%@---->>>>",TwoWheelStr);
    
    [self sendRequestWithURLString:TwoWheelStr
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetTwoWheelerVarient:(NSString *)varient
                       make:(NSString *)manufacturer
                  modelname:(NSString *)modelName
                productmake:(NSString *)productmake
                  modeltype:(NSString *)modeltype
                        app:(NSString *)app
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/getnewmodels?
    //http://staging.policy99.com/getnewmodels?
    //Switch API
    NSString *TwoWheelStr=@"http://www.policy99.com/getnewmodels?";
    
    TwoWheelStr=[NSString stringWithFormat:@"%@makename=%@&modelname=%@&productmake=%@&modeltype=%@&app=%@",TwoWheelStr,manufacturer,modelName,productmake,modeltype,app];
    
     NSLog(@"<<<<----%@---->>>>",TwoWheelStr);
    
    [self sendRequestWithURLString:TwoWheelStr
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetRTODetails:(NSString *)DataDetails
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure{
    
    baseUrl = RTO_Details;
    NSLog(@"%@",baseUrl);
    [self sendRequestWithURLString:RTO_Details
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:GetRTOData
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetTwoWheelerFinancierDetails:(NSString *)financierDetails
                             success:(WebServiceRequestSuccessHandler)success
                             failure:(WebServiceRequestFailureHandler)failure{
    baseUrl = TwoWheeler_Financier_Details;
    NSLog(@"%@",baseUrl);
    [self sendRequestWithURLString:TwoWheeler_Financier_Details
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:GetTwoWheelerFinancier
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TwoWheelerQuoteGenerate:(NSString *)QuoteGenerate
               premiuminsertid:(NSString *)premiuminsertid
              premiumproductid:(NSString *)premiumproductid
                           app:(NSString *)app
                       success:(WebServiceRequestSuccessHandler)success
                       failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/quotegenerate?
    //http://staging.policy99.com/quotegenerate?
    //Switch API
    NSString *TwoWheelQuotwGenerate=@"http://www.policy99.com/quotegenerate?";
    
    TwoWheelQuotwGenerate=[NSString stringWithFormat:@"%@app=%@&premiuminsertid=%@&premiumproductid=%@",TwoWheelQuotwGenerate,app,premiuminsertid,premiumproductid];
    
    NSLog(@"<<<<----%@---->>>>",TwoWheelQuotwGenerate);

    
    [self sendRequestWithURLString:TwoWheelQuotwGenerate
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TwoWheelerProposaldata:(NSString *)Proposaldata
                          app:(NSString *)app
              premiuminsertid:(NSString *)premiuminsertid
             premiumproductid:(NSString *)premiumproductid
                 savedquoteId:(NSString *)savedquoteId
                  customer_id:(NSString *)customer_id
             proposalprovider:(NSString *)proposalprovider
                proposalarray:(NSString *)proposalarray
              proposalproduct:(NSString *)proposalproduct
                  checkpolicy:(NSString *)checkpolicy
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure {
    
    //    NSString *TwoWheelerIDVAPI = [NSString stringWithFormat:@"http://staging.policy99.com/vehicleproposal?app=1&&premiuminsertid=2285&&premiumproductid=3&&savedquoteId=1291"];
  
    //https://www.policy99.com/vehicleproposal?
    //http://staging.policy99.com/vehicleproposal?
    //Switch API
    NSString *TwoWheelQuotwGenerate=@"http://www.policy99.com/vehicleproposal?";
    
    TwoWheelQuotwGenerate=[NSString stringWithFormat:@"%@app=%@&&premiuminsertid=%@&&premiumproductid=%@&&savedquoteId=%@",TwoWheelQuotwGenerate,app,premiuminsertid,premiumproductid,savedquoteId];
    
    
    NSMutableDictionary *IdvDict = [[NSMutableDictionary alloc] init];
    
    
    if(customer_id)        [IdvDict setObject:customer_id forKey:@"customer_id"];
    if(proposalprovider)   [IdvDict setObject:proposalprovider forKey:@"proposalprovider"];
    if(proposalarray)      [IdvDict setObject:proposalarray forKey:@"proposalarray"];
    if(proposalproduct)    [IdvDict setObject:proposalproduct forKey:@"proposalproduct"];
    if(checkpolicy)        [IdvDict setObject:checkpolicy forKey:@"checkpolicy"];
    
    
    
    NSLog(@"urlString = %@",TwoWheelQuotwGenerate);
    NSLog(@"dict = %@",IdvDict);
    [self sendRequestWithURLString:TwoWheelQuotwGenerate
                     andParameters:IdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TwoWheelerPaymentdata:(NSString *)Paymentdata
                         app:(NSString *)app
             premiuminsertid:(NSString *)premiuminsertid
            premiumproductid:(NSString *)premiumproductid
                 customer_id:(NSString *)customer_id
                    basicity:(NSString *)basicity
                    address2:(NSString *)address2
                     pincode:(NSString *)pincode
                      mobile:(NSString *)mobile
                    address1:(NSString *)address1
                       email:(NSString *)email
                   hdfc_hypo:(NSString *)hdfc_hypo
                      gender:(NSString *)gender
                   firstname:(NSString *)firstname
                    fueltype:(NSString *)fueltype
            proposalprovider:(NSString *)proposalprovider
                     pancard:(NSString *)pancard
                  birth_date:(NSString *)birth_date
                  basicstate:(NSString *)basicstate
         registration_number:(NSString *)registration_number
                     surname:(NSString *)surname
                    lastname:(NSString *)lastname
              chassis_number:(NSString *)chassis_number
               engine_number:(NSString *)engine_number
                proposalinfo:(NSString *)proposalinfo
              policyidvvalue:(NSString *)policyidvvalue
                     success:(WebServiceRequestSuccessHandler)success
                     failure:(WebServiceRequestFailureHandler)failure{
    
    //https://www.policy99.com/vehiclepayment?
    //http://staging.policy99.com/vehiclepayment?
    //Switch API
    NSString *TwoWheelQuotwGenerate=@"http://www.policy99.com/vehiclepayment?";
    
    TwoWheelQuotwGenerate=[NSString stringWithFormat:@"%@app=%@&premiuminsertid=%@&premiumproductid=%@&customer_id=%@",TwoWheelQuotwGenerate,app,premiuminsertid,premiumproductid,customer_id];
    
                  
    
    NSMutableDictionary *IdvDict = [[NSMutableDictionary alloc] init];
    
   
    if(basicity)         [IdvDict setObject:basicity forKey:@"basicity"];
    if(address2)         [IdvDict setObject:address2 forKey:@"address2"];
    if(pincode)          [IdvDict setObject:pincode forKey:@"pincode"];
    if(mobile)           [IdvDict setObject:mobile forKey:@"mobile"];
    if(address1)         [IdvDict setObject:address1 forKey:@"address1"];
    if(email)            [IdvDict setObject:email forKey:@"email"];
    if(hdfc_hypo)        [IdvDict setObject:hdfc_hypo forKey:@"hdfc_hypo"];
    if(gender)           [IdvDict setObject:gender forKey:@"gender"];
    if(firstname)        [IdvDict setObject:firstname forKey:@"firstname"];
    if(fueltype)         [IdvDict setObject:fueltype forKey:@"fueltype"];
    if(proposalprovider) [IdvDict setObject:proposalprovider forKey:@"proposalprovider"];
    if(pancard)          [IdvDict setObject:pancard forKey:@"pancard"];
    if(birth_date)       [IdvDict setObject:birth_date forKey:@"birth_date"];
    if(basicstate)       [IdvDict setObject:basicstate forKey:@"basicstate"];
    if(registration_number)   [IdvDict setObject:registration_number forKey:@"registration_number"];
    if(surname)          [IdvDict setObject:surname forKey:@"surname"];
    if(lastname)         [IdvDict setObject:lastname forKey:@"lastname"];
    if(chassis_number)   [IdvDict setObject:chassis_number forKey:@"chassis_number"];
    if(engine_number)    [IdvDict setObject:engine_number forKey:@"engine_number"];
    if(proposalinfo)     [IdvDict setObject:proposalinfo forKey:@"proposalinfo"];
    if(policyidvvalue)   [IdvDict setObject:policyidvvalue forKey:@"policyidvvalue"];
    
    
    
    NSLog(@"urlString = %@",TwoWheelQuotwGenerate);
    NSLog(@"dict = %@",IdvDict);
    [self sendRequestWithURLString:TwoWheelQuotwGenerate
                     andParameters:IdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TwoWheelerIDV:(NSString *)Idv
         manufacture:(NSString *)manufacture
               model:(NSString *)model
            submodel:(NSString *)submodel
   registration_date:(NSString *)registration_date
            location:(NSString *)location
           vehiclecd:(NSString *)vehiclecd
     manufactureYear:(NSString *)manufactureYear
     policystartdate:(NSString *)policystartdate
         productName:(NSString *)productName
        typeofpolicy:(NSString *)typeofpolicy
       policyenddate:(NSString *)policyenddate
 prevpolicystartdate:(NSString *)prevpolicystartdate
   prevpolicyenddate:(NSString *)prevpolicyenddate
            no_claim:(NSString *)no_claim
          Policytype:(NSString *)policytype
   manufacturedMonth:(NSString*)maunfacturedMonth
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure  {
    //https://www.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1
    
    NSString *TwoWheelerIDVAPI = [NSString stringWithFormat:@"http://www.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1"];
    
    //http://staging.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1
    //Switch API
    
    NSMutableDictionary *IdvDict = [[NSMutableDictionary alloc] init];
    
    if(manufacture)           [IdvDict setObject:manufacture forKey:@"manufactures"];
    if(model)                 [IdvDict setObject:model forKey:@"model"];
    if(submodel)              [IdvDict setObject:submodel forKey:@"submodel"];
    if(registration_date)     [IdvDict setObject:registration_date forKey:@"registration_date"];
    if(location)              [IdvDict setObject:location forKey:@"location"];
    if(vehiclecd)             [IdvDict setObject:vehiclecd forKey:@"vehiclecd"];
    if(manufactureYear)       [IdvDict setObject:manufactureYear forKey:@"manufacture_year"];
    if(policystartdate)       [IdvDict setObject:policystartdate forKey:@"policystartdate"];
    if(productName)           [IdvDict setObject:productName forKey:@"productName"];
    if(typeofpolicy)          [IdvDict setObject:typeofpolicy forKey:@"typeofpolicy"];
    if(policyenddate)         [IdvDict setObject:policyenddate forKey:@"policyenddate"];
    if(prevpolicystartdate)   [IdvDict setObject:prevpolicystartdate forKey:@"prevpolicystartdate"];
    if(prevpolicyenddate)     [IdvDict setObject:prevpolicyenddate forKey:@"prevpolicyenddate"];
    if(no_claim)              [IdvDict setObject:no_claim forKey:@"no_claim"];
    if(policytype)            [IdvDict setObject:policytype forKey:@"policytype"];
    if(maunfacturedMonth)     [IdvDict setObject:maunfacturedMonth forKey:@"manufacture_month"];
    
    NSLog(@"urlString = %@",TwoWheelerIDVAPI);
    NSLog(@"dict = %@",IdvDict);
    
    [self sendRequestWithURLString:TwoWheelerIDVAPI
                     andParameters:IdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TwoWheelerViewQuote:(NSString *)ViewQuote
                preinsurer:(NSString *)preinsurer
             policyenddate:(NSString *)policyenddate
           typeofinsurance:(NSString *)typeofinsurance
            insured_person:(NSString *)insured_person
               customer_id:(NSString *)customer_id
      no_unnamedpassengers:(NSString *)no_unnamedpassengers
         breakin_uninsured:(NSString *)breakin_uninsured
               claims_made:(NSString *)claims_made
            policyidvvalue:(NSString *)policyidvvalue
           thirdparty_tppd:(NSString *)thirdparty_tppd
        unnamed_passengers:(NSString *)unnamed_passengers
         policyrtolocation:(NSString *)policyrtolocation
         registration_date:(NSString *)registration_date
           exshowroomPrice:(NSString *)exshowroomPrice
              manufactures:(NSString *)manufactures
sum_unnamedinsuredpassenger:(NSString *)sum_unnamedinsuredpassenger
    previous_policy_number:(NSString *)previous_policy_number
           policyuriaction:(NSString *)policyuriaction
         manufacture_month:(NSString *)manufacture_month
                product_id:(NSString *)product_id
     policyrtolocationtext:(NSString *)policyrtolocationtext
  previous_policy_end_date:(NSString *)previous_policy_end_date
                 agentcode:(NSString *)agentcode
               checkpolicy:(NSString *)checkpolicy
                  no_claim:(NSString *)no_claim
      policydate_condition:(NSString *)policydate_condition
previous_policy_start_date:(NSString *)previous_policy_start_date
              insured_name:(NSString *)insured_name
                  submodel:(NSString *)submodel
               productName:(NSString *)productName
          manufacture_year:(NSString *)manufacture_year
                   vehicle:(NSString *)vehicle
          policyuriproduct:(NSString *)policyuriproduct
                 vehiclecd:(NSString *)vehiclecd
           policystartdate:(NSString *)policystartdate
                     model:(NSString *)model
       policy_max_idvvalue:(NSString *)policy_max_idvvalue
       policy_min_idvvalue:(NSString *)policy_min_idvvalue
          policynewenddate:(NSString *)policynewenddate
        policynewstartdate:(NSString *)policynewstartdate
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    
    NSString *TwoWheelerViuewQuoteAPI = [NSString stringWithFormat:@"http://www.policy99.com/vehiclebasic"];
    
    //http://staging.policy99.com/vehiclebasic
    //https://www.policy99.com/vehiclebasic
    //Switch API
    
    NSMutableDictionary *ViewQuoteDict = [[NSMutableDictionary alloc] init];
    
    if(preinsurer)           [ViewQuoteDict setObject:preinsurer forKey:@"preinsurer"];
    if(policyenddate)        [ViewQuoteDict setObject:policyenddate forKey:@"policyenddate"];
    if(typeofinsurance)      [ViewQuoteDict setObject:typeofinsurance forKey:@"typeofinsurance"];
    if(insured_person)       [ViewQuoteDict setObject:insured_person forKey:@"insured_person"];
    if(customer_id)          [ViewQuoteDict setObject:customer_id forKey:@"customer_id"];
    if(no_unnamedpassengers) [ViewQuoteDict setObject:no_unnamedpassengers forKey:@"no_unnamedpassengers"];
    if(breakin_uninsured)    [ViewQuoteDict setObject:breakin_uninsured forKey:@"breakin_uninsured"];
    if(claims_made)          [ViewQuoteDict setObject:claims_made forKey:@"claims_made"];
    if(policyidvvalue)       [ViewQuoteDict setObject:policyidvvalue forKey:@"policyidvvalue"];
    if(thirdparty_tppd)      [ViewQuoteDict setObject:thirdparty_tppd forKey:@"thirdparty_tppd"];
    if(unnamed_passengers)   [ViewQuoteDict setObject:unnamed_passengers forKey:@"unnamed_passengers"];
    if(policyrtolocation)    [ViewQuoteDict setObject:policyrtolocation forKey:@"policyrtolocation"];
    if(registration_date)    [ViewQuoteDict setObject:registration_date forKey:@"registration_date"];
    if(exshowroomPrice)      [ViewQuoteDict setObject:exshowroomPrice forKey:@"exshowroomPrice"];
    if(manufactures)         [ViewQuoteDict setObject:manufactures forKey:@"manufactures"];
    if(sum_unnamedinsuredpassenger)   [ViewQuoteDict setObject:sum_unnamedinsuredpassenger forKey:@"sum_unnamedinsuredpassenger"];
    if(previous_policy_number)        [ViewQuoteDict setObject:previous_policy_number forKey:@"previous_policy_number"];
    if(policyuriaction)        [ViewQuoteDict setObject:policyuriaction forKey:@"policyuriaction"];
    if(manufacture_month)      [ViewQuoteDict setObject:manufacture_month forKey:@"manufacture_month"];
    if(product_id)             [ViewQuoteDict setObject:product_id forKey:@"product_id"];
    if(policyrtolocationtext)  [ViewQuoteDict setObject:policyrtolocationtext forKey:@"policyrtolocationtext"];
    if(previous_policy_end_date)      [ViewQuoteDict setObject:previous_policy_end_date forKey:@"previous_policy_end_date"];
    if(agentcode)             [ViewQuoteDict setObject:agentcode forKey:@"agentcode"];
    if(checkpolicy)           [ViewQuoteDict setObject:checkpolicy forKey:@"checkpolicy"];
    if(no_claim)              [ViewQuoteDict setObject:no_claim forKey:@"no_claim"];
    if(policydate_condition)  [ViewQuoteDict setObject:policydate_condition forKey:@"policydate_condition"];
    if(previous_policy_start_date)    [ViewQuoteDict setObject:previous_policy_start_date forKey:@"previous_policy_start_date"];
    if(insured_name)          [ViewQuoteDict setObject:insured_name forKey:@"insured_name"];
    if(submodel)              [ViewQuoteDict setObject:submodel forKey:@"submodel"];
    if(productName)           [ViewQuoteDict setObject:productName forKey:@"productName"];
    if(manufacture_year)      [ViewQuoteDict setObject:manufacture_year forKey:@"manufacture_year"];
    if(vehicle)               [ViewQuoteDict setObject:vehicle forKey:@"vehicle"];
    if(policyuriproduct)      [ViewQuoteDict setObject:policyuriproduct forKey:@"policyuriproduct"];
    if(vehiclecd)             [ViewQuoteDict setObject:vehiclecd forKey:@"vehiclecd"];
    if(policystartdate)       [ViewQuoteDict setObject:policystartdate forKey:@"policystartdate"];
    if(model)                [ViewQuoteDict setObject:model forKey:@"model"];
    if(policy_max_idvvalue)  [ViewQuoteDict setObject:policy_max_idvvalue forKey:@"policy_max_idvvalue"];
    if(policy_min_idvvalue)  [ViewQuoteDict setObject:policy_min_idvvalue forKey:@"policy_min_idvvalue"];
    if(policynewenddate)     [ViewQuoteDict setObject:policynewenddate forKey:@"policynewenddate"];
    if(policynewstartdate)   [ViewQuoteDict setObject:policynewstartdate forKey:@"policynewstartdate"];
    
    
    NSLog(@"urlString = %@",TwoWheelerViuewQuoteAPI);
    NSLog(@"dict = %@",ViewQuoteDict);
    [self sendRequestWithURLString:TwoWheelerViuewQuoteAPI
                     andParameters:ViewQuoteDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)SendEmail:(NSString *)SendEmail
       productid:(NSString *)productid
       paymentid:(NSString *)paymentid
     failedreson:(NSString *)failedreson
failedreasonother:(NSString *)failedreasonother
    failedupload:(UIImage *)failedupload
         success:(WebServiceRequestSuccessHandler)success
         failure:(WebServiceRequestFailureHandler)failure
{
    NSString * emailPostAPI =[NSString stringWithFormat:@"http://www.policy99.com/manage/index.php?route=api/data/sendEmailtoInsurer&productid=%@&paymentid=%@&failedreson=%@&failedresonother=%@",productid,paymentid,failedreson,failedreasonother];
    //Switch API
    
    NSMutableDictionary * emailDict = [[NSMutableDictionary alloc] init];
    
    if(failedupload)   [emailDict setObject:failedupload forKey:@"failedupload"];

    NSLog(@"urlString = %@",emailPostAPI);
    NSLog(@"dict = %@",emailDict);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    
    [self POST:emailPostAPI parameters:emailDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        NSLog(@"baseAPI = %@",emailPostAPI);
         NSLog(@"user = %@",emailDict);
         if(failedupload){
             [formData appendPartWithFileData:UIImagePNGRepresentation(failedupload)
                                         name:@"failedupload"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject){
        
           NSLog(@"responseObject = %@",responseObject);
           if([[responseObject valueForKey:@"Status"]isEqualToString:@"Sucess"]){
            
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Policy99.com"
                                                             message:[responseObject valueForKey:@"Message"]
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil,nil];
               [COMMON removeLoading];
               [alert show];
//               [popController.view removeFromSuperview];
//               [popController removeFromParentViewController];
           }
           else{
               
//               [COMMON removeLoading];
//               [COMMON showErrorAlert:[responseObject valueForKey:@"Message"]];
//               [popController.view removeFromSuperview];
//               [popController removeFromParentViewController];
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
         
//           [COMMON removeLoading];
//           [COMMON showErrorAlert:@"Mail not sent Successfully!"];
//           [popController.view removeFromSuperview];
//           [popController removeFromParentViewController];
       }];
}

#pragma mark - Four Wheeler API

-(void)GetFourWheelerFormDetails:(NSString *)applyForm
                         success:(WebServiceRequestSuccessHandler)success
                         failure:(WebServiceRequestFailureHandler)failure{
    
    [self sendRequestWithURLString:FourWheeler_Apply_Form
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:GetFourWheelerForm
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetFourWheelerModel:(NSString *)models
                      make:(NSString *)manufacturer
                 modelname:(NSString *)modelName
               productmake:(NSString *)productmake
                 modeltype:(NSString *)modeltype
                       app:(NSString *)app
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/getnewmodels?
    //http://staging.policy99.com/getnewmodels?
    //Switch API
    NSString *fourWheelerStr=@"http://www.policy99.com/getnewmodels?";
    
    fourWheelerStr=[NSString stringWithFormat:@"%@makename=%@&modelname=%@&productmake=%@&modeltype=%@&app=%@",fourWheelerStr,manufacturer,modelName,productmake,modeltype,app];
    
    NSLog(@"<<<<----%@---->>>>",fourWheelerStr);
    
    [self sendRequestWithURLString:fourWheelerStr
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)GetFourWheelerVarient:(NSString *)varient
                        make:(NSString *)manufacturer
                   modelname:(NSString *)modelName
                 productmake:(NSString *)productmake
                   modeltype:(NSString *)modeltype
                         app:(NSString *)app
                     success:(WebServiceRequestSuccessHandler)success
                     failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/getnewmodels?
    //http://staging.policy99.com/getnewmodels?
    //Switch API
    NSString *fourWheelerStr=@"http://www.policy99.com/getnewmodels?";
    
    fourWheelerStr=[NSString stringWithFormat:@"%@makename=%@&modelname=%@&productmake=%@&modeltype=%@&app=%@",fourWheelerStr,manufacturer,modelName,productmake,modeltype,app];
    
    NSLog(@"<<<<----%@---->>>>",fourWheelerStr);
    
    [self sendRequestWithURLString:fourWheelerStr
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

-(void)FourWheelerIDV:(NSString *)Idv
          manufacture:(NSString *)manufacture
                model:(NSString *)model
             submodel:(NSString *)submodel
    registration_date:(NSString *)registration_date
             location:(NSString *)location
            vehiclecd:(NSString *)vehiclecd
      manufactureYear:(NSString *)manufactureYear
      policystartdate:(NSString *)policystartdate
          productName:(NSString *)productName
         typeofpolicy:(NSString *)typeofpolicy
        policyenddate:(NSString *)policyenddate
  prevpolicystartdate:(NSString *)prevpolicystartdate
    prevpolicyenddate:(NSString *)prevpolicyenddate
             no_claim:(NSString *)no_claim
           Policytype:(NSString *)policytype
    manufacturedMonth:(NSString*)maunfacturedMonth
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure  {
    //https://www.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1
    
    NSString *fourWheelerIDVAPI = [NSString stringWithFormat:@"http://www.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1"];
    
    //http://staging.policy99.com/index.php?route=vehicle/basicproduct/calculateIDVNew&app=1
    //Switch API
    
    NSMutableDictionary *fourWheelerIdvDict = [[NSMutableDictionary alloc] init];
    
    if(manufacture)           [fourWheelerIdvDict setObject:manufacture forKey:@"manufactures"];
    if(model)                 [fourWheelerIdvDict setObject:model forKey:@"model"];
    if(submodel)              [fourWheelerIdvDict setObject:submodel forKey:@"submodel"];
    if(registration_date)     [fourWheelerIdvDict setObject:registration_date forKey:@"registration_date"];
    if(location)              [fourWheelerIdvDict setObject:location forKey:@"location"];
    if(vehiclecd)             [fourWheelerIdvDict setObject:vehiclecd forKey:@"vehiclecd"];
    if(manufactureYear)       [fourWheelerIdvDict setObject:manufactureYear forKey:@"manufacture_year"];
    if(policystartdate)       [fourWheelerIdvDict setObject:policystartdate forKey:@"policystartdate"];
    if(productName)           [fourWheelerIdvDict setObject:productName forKey:@"productName"];
    if(typeofpolicy)          [fourWheelerIdvDict setObject:typeofpolicy forKey:@"typeofpolicy"];
    if(policyenddate)         [fourWheelerIdvDict setObject:policyenddate forKey:@"policyenddate"];
    if(prevpolicystartdate)   [fourWheelerIdvDict setObject:prevpolicystartdate forKey:@"prevpolicystartdate"];
    if(prevpolicyenddate)     [fourWheelerIdvDict setObject:prevpolicyenddate forKey:@"prevpolicyenddate"];
    if(no_claim)              [fourWheelerIdvDict setObject:no_claim forKey:@"no_claim"];
    if(policytype)            [fourWheelerIdvDict setObject:policytype forKey:@"policytype"];
    if(maunfacturedMonth)     [fourWheelerIdvDict setObject:maunfacturedMonth forKey:@"manufacture_month"];
    
    NSLog(@"urlString = %@",fourWheelerIDVAPI);
    NSLog(@"dict = %@",fourWheelerIdvDict);
    
    [self sendRequestWithURLString:fourWheelerIDVAPI
                     andParameters:fourWheelerIdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)FourWheelerViewQuote:(NSString *)ViewQuote
                 preinsurer:(NSString *)preinsurer
              policyenddate:(NSString *)policyenddate
            typeofinsurance:(NSString *)typeofinsurance
             insured_person:(NSString *)insured_person
                customer_id:(NSString *)customer_id
       no_unnamedpassengers:(NSString *)no_unnamedpassengers
          breakin_uninsured:(NSString *)breakin_uninsured
                claims_made:(NSString *)claims_made
             policyidvvalue:(NSString *)policyidvvalue
            thirdparty_tppd:(NSString *)thirdparty_tppd
         unnamed_passengers:(NSString *)unnamed_passengers
          policyrtolocation:(NSString *)policyrtolocation
          registration_date:(NSString *)registration_date
            exshowroomPrice:(NSString *)exshowroomPrice
               manufactures:(NSString *)manufactures
sum_unnamedinsuredpassenger:(NSString *)sum_unnamedinsuredpassenger
     previous_policy_number:(NSString *)previous_policy_number
            policyuriaction:(NSString *)policyuriaction
          manufacture_month:(NSString *)manufacture_month
                 product_id:(NSString *)product_id
      policyrtolocationtext:(NSString *)policyrtolocationtext
   previous_policy_end_date:(NSString *)previous_policy_end_date
                  agentcode:(NSString *)agentcode
                checkpolicy:(NSString *)checkpolicy
                   no_claim:(NSString *)no_claim
       policydate_condition:(NSString *)policydate_condition
 previous_policy_start_date:(NSString *)previous_policy_start_date
               insured_name:(NSString *)insured_name
                   submodel:(NSString *)submodel
                productName:(NSString *)productName
           manufacture_year:(NSString *)manufacture_year
                    vehicle:(NSString *)vehicle
           policyuriproduct:(NSString *)policyuriproduct
                  vehiclecd:(NSString *)vehiclecd
            policystartdate:(NSString *)policystartdate
                      model:(NSString *)model
        policy_max_idvvalue:(NSString *)policy_max_idvvalue
        policy_min_idvvalue:(NSString *)policy_min_idvvalue
            noofpaiddrivers:(NSString *)noofpaiddrivers
                paid_driver:(NSString *)paid_driver
                  car_addon:(NSString *)car_addon
            addon_main_plan:(NSString *)addon_main_plan
         policynewstartdate:(NSString *)policynewstartdate
           policynewenddate:(NSString *)policynewenddate
                  subcovers:(NSArray *)subcovers
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure{
    
    NSString *FourWheelerViuewQuoteAPI = [NSString stringWithFormat:@"http://www.policy99.com/vehiclebasic"];
    
    //http://staging.policy99.com/vehiclebasic
    //https://www.policy99.com/vehiclebasic
    //Switch API
    
    NSMutableDictionary *ViewQuoteDict = [[NSMutableDictionary alloc] init];
    
    if(preinsurer)                    [ViewQuoteDict setObject:preinsurer forKey:@"preinsurer"];
    if(policyenddate)                 [ViewQuoteDict setObject:policyenddate forKey:@"policyenddate"];
    if(typeofinsurance)               [ViewQuoteDict setObject:typeofinsurance forKey:@"typeofinsurance"];
    if(insured_person)                [ViewQuoteDict setObject:insured_person forKey:@"insured_person"];
    if(customer_id)                   [ViewQuoteDict setObject:customer_id forKey:@"customer_id"];
    if(no_unnamedpassengers)          [ViewQuoteDict setObject:no_unnamedpassengers forKey:@"no_unnamedpassengers"];
    if(breakin_uninsured)             [ViewQuoteDict setObject:breakin_uninsured forKey:@"breakin_uninsured"];
    if(claims_made)                   [ViewQuoteDict setObject:claims_made forKey:@"claims_made"];
    if(policyidvvalue)                [ViewQuoteDict setObject:policyidvvalue forKey:@"policyidvvalue"];
    if(thirdparty_tppd)               [ViewQuoteDict setObject:thirdparty_tppd forKey:@"thirdparty_tppd"];
    if(unnamed_passengers)            [ViewQuoteDict setObject:unnamed_passengers forKey:@"unnamed_passengers"];
    if(policyrtolocation)             [ViewQuoteDict setObject:policyrtolocation forKey:@"policyrtolocation"];
    if(registration_date)             [ViewQuoteDict setObject:registration_date forKey:@"registration_date"];
    if(exshowroomPrice)               [ViewQuoteDict setObject:exshowroomPrice forKey:@"exshowroomPrice"];
    if(manufactures)                  [ViewQuoteDict setObject:manufactures forKey:@"manufactures"];
    if(sum_unnamedinsuredpassenger)   [ViewQuoteDict setObject:sum_unnamedinsuredpassenger forKey:@"sum_unnamedinsuredpassenger"];
    if(previous_policy_number)        [ViewQuoteDict setObject:previous_policy_number forKey:@"previous_policy_number"];
    if(policyuriaction)               [ViewQuoteDict setObject:policyuriaction forKey:@"policyuriaction"];
    if(manufacture_month)             [ViewQuoteDict setObject:manufacture_month forKey:@"manufacture_month"];
    if(product_id)                    [ViewQuoteDict setObject:product_id forKey:@"product_id"];
    if(policyrtolocationtext)         [ViewQuoteDict setObject:policyrtolocationtext forKey:@"policyrtolocationtext"];
    if(previous_policy_end_date)      [ViewQuoteDict setObject:previous_policy_end_date forKey:@"previous_policy_end_date"];
    if(agentcode)                     [ViewQuoteDict setObject:agentcode forKey:@"agentcode"];
    if(checkpolicy)                   [ViewQuoteDict setObject:checkpolicy forKey:@"checkpolicy"];
    if(no_claim)                      [ViewQuoteDict setObject:no_claim forKey:@"no_claim"];
    if(policydate_condition)          [ViewQuoteDict setObject:policydate_condition forKey:@"policydate_condition"];
    if(previous_policy_start_date)    [ViewQuoteDict setObject:previous_policy_start_date forKey:@"previous_policy_start_date"];
    if(insured_name)                  [ViewQuoteDict setObject:insured_name forKey:@"insured_name"];
    if(submodel)                      [ViewQuoteDict setObject:submodel forKey:@"submodel"];
    if(productName)                   [ViewQuoteDict setObject:productName forKey:@"productName"];
    if(manufacture_year)              [ViewQuoteDict setObject:manufacture_year forKey:@"manufacture_year"];
    if(vehicle)                       [ViewQuoteDict setObject:vehicle forKey:@"vehicle"];
    if(policyuriproduct)              [ViewQuoteDict setObject:policyuriproduct forKey:@"policyuriproduct"];
    if(vehiclecd)                     [ViewQuoteDict setObject:vehiclecd forKey:@"vehiclecd"];
    if(policystartdate)               [ViewQuoteDict setObject:policystartdate forKey:@"policystartdate"];
    if(model)                         [ViewQuoteDict setObject:model forKey:@"model"];
    if(policy_max_idvvalue)           [ViewQuoteDict setObject:policy_max_idvvalue forKey:@"policy_max_idvvalue"];
    if(policy_min_idvvalue)           [ViewQuoteDict setObject:policy_min_idvvalue forKey:@"policy_min_idvvalue"];
    if(noofpaiddrivers)               [ViewQuoteDict setObject:noofpaiddrivers forKey:@"noofpaiddrivers"];
    if(paid_driver)                   [ViewQuoteDict setObject:paid_driver forKey:@"paid_driver"];
    if(car_addon)                     [ViewQuoteDict setObject:car_addon forKey:@"car-addon"];
    if(addon_main_plan)               [ViewQuoteDict setObject:addon_main_plan forKey:@"addon_main_plan"];
    if(policynewstartdate)            [ViewQuoteDict setObject:policynewstartdate forKey:@"policynewstartdate"];
    if(policynewenddate)              [ViewQuoteDict setObject:policynewenddate forKey:@"policynewenddate"];
    if(subcovers)                     [ViewQuoteDict setObject:subcovers forKey:@"subcovers"];
    
    NSLog(@"urlString = %@",FourWheelerViuewQuoteAPI);
    NSLog(@"dict = %@",ViewQuoteDict);
    [self sendRequestWithURLString:FourWheelerViuewQuoteAPI
                     andParameters:ViewQuoteDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)FourWheelerQuoteGenerate:(NSString *)QuoteGenerate
                premiuminsertid:(NSString *)premiuminsertid
               premiumproductid:(NSString *)premiumproductid
                            app:(NSString *)app
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure{
    //https://www.policy99.com/quotegenerate?
    //http://staging.policy99.com/quotegenerate?
    //Switch API
    NSString *FourWheelerQuotwGenerate=@"http://www.policy99.com/quotegenerate?";
    
    FourWheelerQuotwGenerate=[NSString stringWithFormat:@"%@app=%@&premiuminsertid=%@&premiumproductid=%@",FourWheelerQuotwGenerate,app,premiuminsertid,premiumproductid];
    
    NSLog(@"<<<<----%@---->>>>",FourWheelerQuotwGenerate);
    
    
    [self sendRequestWithURLString:FourWheelerQuotwGenerate
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)FourWheelerPaymentdata:(NSString *)Paymentdata
                          app:(NSString *)app
              premiuminsertid:(NSString *)premiuminsertid
             premiumproductid:(NSString *)premiumproductid
                  customer_id:(NSString *)customer_id
                     basicity:(NSString *)basicity
                     address2:(NSString *)address2
                      pincode:(NSString *)pincode
                       mobile:(NSString *)mobile
                     address1:(NSString *)address1
                        email:(NSString *)email
                    hdfc_hypo:(NSString *)hdfc_hypo
                       gender:(NSString *)gender
                    firstname:(NSString *)firstname
                     fueltype:(NSString *)fueltype
             proposalprovider:(NSString *)proposalprovider
                      pancard:(NSString *)pancard
                   birth_date:(NSString *)birth_date
                   basicstate:(NSString *)basicstate
          registration_number:(NSString *)registration_number
                      surname:(NSString *)surname
                     lastname:(NSString *)lastname
               chassis_number:(NSString *)chassis_number
                engine_number:(NSString *)engine_number
                 proposalinfo:(NSString *)proposalinfo
               policyidvvalue:(NSString *)policyidvvalue
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure{
    
    //https://www.policy99.com/vehiclepayment?
    //http://staging.policy99.com/vehiclepayment?
    //Switch API
    NSString *FourWheelQuotwGenerate=@"http://www.policy99.com/vehiclepayment?";
    
    FourWheelQuotwGenerate=[NSString stringWithFormat:@"%@app=%@&premiuminsertid=%@&premiumproductid=%@&customer_id=%@",FourWheelQuotwGenerate,app,premiuminsertid,premiumproductid,customer_id];
    
    NSMutableDictionary *IdvDict = [[NSMutableDictionary alloc] init];
    
    if(basicity)         [IdvDict setObject:basicity forKey:@"basicity"];
    if(address2)         [IdvDict setObject:address2 forKey:@"address2"];
    if(pincode)          [IdvDict setObject:pincode forKey:@"pincode"];
    if(mobile)           [IdvDict setObject:mobile forKey:@"mobile"];
    if(address1)         [IdvDict setObject:address1 forKey:@"address1"];
    if(email)            [IdvDict setObject:email forKey:@"email"];
    if(hdfc_hypo)        [IdvDict setObject:hdfc_hypo forKey:@"hdfc_hypo"];
    if(gender)           [IdvDict setObject:gender forKey:@"gender"];
    if(firstname)        [IdvDict setObject:firstname forKey:@"firstname"];
    if(fueltype)         [IdvDict setObject:fueltype forKey:@"fueltype"];
    if(proposalprovider) [IdvDict setObject:proposalprovider forKey:@"proposalprovider"];
    if(pancard)          [IdvDict setObject:pancard forKey:@"pancard"];
    if(birth_date)       [IdvDict setObject:birth_date forKey:@"birth_date"];
    if(basicstate)       [IdvDict setObject:basicstate forKey:@"basicstate"];
    if(registration_number)   [IdvDict setObject:registration_number forKey:@"registration_number"];
    if(surname)          [IdvDict setObject:surname forKey:@"surname"];
    if(lastname)         [IdvDict setObject:lastname forKey:@"lastname"];
    if(chassis_number)   [IdvDict setObject:chassis_number forKey:@"chassis_number"];
    if(engine_number)    [IdvDict setObject:engine_number forKey:@"engine_number"];
    if(proposalinfo)     [IdvDict setObject:proposalinfo forKey:@"proposalinfo"];
    if(policyidvvalue)   [IdvDict setObject:policyidvvalue forKey:@"policyidvvalue"];
    
    NSLog(@"urlString = %@",FourWheelQuotwGenerate);
    NSLog(@"dict = %@",IdvDict);
    [self sendRequestWithURLString:FourWheelQuotwGenerate
                     andParameters:IdvDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}


#pragma mark -Notification API

-(void)getNotificationList:(NSString *)NotificationAPI
                customerId:(NSString *)customerId
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    
    //Switch API
    //http://staging.policy99.com/manage/api/data/
    //http://staging.policy99.com/manage/api/data/
    NSString *notificationUrlString= [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",NotificationAPI];
    
    notificationUrlString=[NSString stringWithFormat:@"%@customer_id=%@",notificationUrlString,customerId];
    
    [self sendRequestWithURLString:notificationUrlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getNotificationCount:(NSString *)NotificationCount
                 customerId:(NSString *)customerId
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure{
    //Switch API
    NSString *notificationCountUrlString = [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",NotificationCount];
    
    notificationCountUrlString=[NSString stringWithFormat:@"%@customer_id=%@",notificationCountUrlString,customerId];
    
    [self sendRequestWithURLString:notificationCountUrlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getClaimNotificationHistory:(NSString *)claimsLists
                        customerId:(NSString *)customerId
                           claimId:(NSString *)claimId
                           success:(WebServiceRequestSuccessHandler)success
                           failure:(WebServiceRequestFailureHandler)failure{
    //Switch API
    NSString *claimHistoryUrlString = [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",claimsLists];
    
    claimHistoryUrlString = [NSString stringWithFormat:@"%@customer_id=%@&claimid=%@",claimHistoryUrlString,customerId,claimId];
    
    [self sendRequestWithURLString:claimHistoryUrlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getBulkNotifiactionHistory:(NSString *)bulkLists
                       customerId:(NSString *)customerId
                           bulkId:(NSString *)bulkId
                          success:(WebServiceRequestSuccessHandler)success
                          failure:(WebServiceRequestFailureHandler)failure{
    //Switch API
    NSString *bulkHistoryUrlString = [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",bulkLists];
    
    bulkHistoryUrlString = [NSString stringWithFormat:@"%@customer_id=%@&id=%@",bulkHistoryUrlString,customerId,bulkId];
    
    [self sendRequestWithURLString:bulkHistoryUrlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)sendClaimsNotification:(NSString *)claimsReply
                   customerId:(NSString *)customerId
                  notifyReply:(NSString *)notifyReply
                      claimId:(NSString *)claimId
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure{
 //Switch API
    NSString * sendClaimString = [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",claimsReply];
    
    sendClaimString = [NSString stringWithFormat:@"%@customer_id=%@&notifyreply=%@&claimid=%@",sendClaimString,customerId,notifyReply,claimId];
    
    [self sendRequestWithURLString:sendClaimString
                     andParameters:nil
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)sendBulkNotification:(NSString *)claimsReply
                 customerId:(NSString *)customerId
                notifyReply:(NSString *)notifyReply
                   notifyId:(NSString *)notifyId
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure{
    //Switch API
    NSString * sendBulkString = [NSString stringWithFormat:@"http://www.policy99.com/manage/api/data/%@",claimsReply];
    
    sendBulkString = [NSString stringWithFormat:@"%@customer_id=%@&notifyreply=%@&notify_id=%@",sendBulkString,customerId,notifyReply,notifyId];
    
    [self sendRequestWithURLString:sendBulkString
                     andParameters:nil
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}


#pragma mark - Helpers

- (void)sendXMLRequestWithURLString:(NSString *)url
                      andParameters:(NSDictionary *)parameters
                             method:(const NSString *)method
            completionSucessHandler:(WebServiceRequestXMLSuccessHandler)sucesshandler
           completionFailureHandler:(WebServiceRequestXMLFailureHandler)failurehandler {
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (method == WebServiceGet) {
        
        self.responseSerializer = [AFXMLParserResponseSerializer new];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
        
        [self GET:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseDict) {
              if (sucesshandler) sucesshandler(operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failurehandler) failurehandler(operation, nil);
          }];
    }
}

- (void)sendRequestWithURLString:(NSString *)url
                   andParameters:(NSDictionary *)parameters
                          method:(const NSString *)method
           saveContentToFileName:(NSString *)fileName
         completionSucessHandler:(WebServiceRequestSuccessHandler)sucesshandler
        completionFailureHandler:(WebServiceRequestFailureHandler)failurehandler {
    
    //   [self.requestSerializer setAuthorizationHeaderFieldWithUsername:TEAM_AUTH_USERNAME password:TEAM_AUTH_PASSWORD];
   
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ( method == WebServiceGet) {
        
        [self GET:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseDict) {
            if (sucesshandler) sucesshandler(operation,responseDict);
              saveContentsToFile(responseDict,fileName);
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failurehandler) failurehandler(operation, error);
          }];
    }
    else{
        
        [self POST:url parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseDict) {
               if (sucesshandler) sucesshandler(operation,responseDict);
               NSLog(@"responseDict = %@",responseDict);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               if (failurehandler) failurehandler(operation,error);
           }];
    }
}

-(void)cancelRequest
{
    [self.operationQueue cancelAllOperations];
}

-(NSString*)getDebug:(NSString*)_debug
{
    NSString *strDebugState;
    if ([_debug isEqualToString:@"demo"])
        strDebugState=@"demo";
    else
        strDebugState=@"live";
    
    return strDebugState;
}

-(NSString *)getBaseURL:(NSString *)_baseUrl
{
    
    NSString *strURL=@"";
    
    NSDictionary *apisDic,*apisSelectedkeyDic;
    
    apisDic = [[NSUserDefaults standardUserDefaults]valueForKey:Config_Details];
    
    apisSelectedkeyDic=[apisDic valueForKey:_baseUrl];
    
    strURL=[apisSelectedkeyDic valueForKey:[self getDebug:BUILD_FOR]];
    
    return strURL;
    
}

// Travel Insurance
-(void)postTravelBasicInfo:(NSDictionary *)NotificationAPI
                customerId:(NSString *)customerId
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    NSString *Url=@"https://www.policy99.com/travelquote";//http://staging.policy99.com/travelquote   //https://www.policy99.com/travelquote
//    NSString *notificationUrlString= [NSString stringWithFormat:@"%@&app=%@",Url,customerId];

    [self sendRequestWithURLString:Url
                     andParameters:NotificationAPI
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TravelInsuranceQuoteApi:(NSString *)travelDataId provider:(NSString *)providerId group:(NSString*)groupId andPremiumId:(NSString *)premiumId
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure {
    baseUrl =@"https://www.policy99.com/travel-quotes?";//http://staging.policy99.com/travel-quotes?  //https://www.policy99.com/travel-quotes?
    urlString = [NSString stringWithFormat:@"%@&providerid=%@&travelformdataid=%@&premiumproductid=%@&app=1&group_id=%@",baseUrl,providerId,travelDataId,premiumId,groupId];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)TravelProposalCountApi:(NSString *)travelDataId
                     provider:(NSString *)providerId
                        group:(NSString*)groupId
                        customer:(NSString*)customerId
                 coverTypr:(NSString *)typeOfCover
                    familyType:(NSString *)familytype
                       success:(WebServiceRequestSuccessHandler)success
                       failure:(WebServiceRequestFailureHandler)failure {
    baseUrl =@"https://www.policy99.com/travelproposal?";//staging.policy99.com/travelproposal?
    //https://www.policy99.com/travelproposal?
    urlString = [NSString stringWithFormat:@"%@&insure=%@&travel_id=%@&typeofcover=%@&familytype=%@&customer_id=%@&app=1&group_id=%@",baseUrl,providerId,travelDataId,typeOfCover,familytype,customerId,groupId];
    NSLog(@"urlString = %@",urlString);
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:WebServiceGet
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)proposalPostTravelInfo:(NSDictionary *)notificationDict
                customerId:(NSString *)customerId
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure{
    NSString *Url=@"https://www.policy99.com/travelproposal?app=1";//http://staging.policy99.com/travelproposal?app=1  //https://www.policy99.com/travelproposal?app=1
    [self sendRequestWithURLString:Url
                     andParameters:notificationDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}


-(void)proposalDetailSumitInfo:(NSDictionary *)notificationDict
                   customerId:(NSString *)customerId
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure{
    NSString *Url=@"https://www.policy99.com/proposalprocess?app=1";//http://staging.policy99.com/proposalprocess?app=1  //https://www.policy99.com/proposalprocess?app=1
    [self sendRequestWithURLString:Url
                     andParameters:notificationDict
                            method:WebServicePost
             saveContentToFileName:@""
           completionSucessHandler:success
          completionFailureHandler:failure];
}

//staging.policy99.com/travelproposal?app=1&cstomer_id=243&group_id=2&travel_id=5498&insure=5&typeofcover=F&familytype=SS

@end
