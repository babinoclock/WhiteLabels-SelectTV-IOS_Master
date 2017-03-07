//
//  WebService.h
//  Policy 99
//
//  Created by Ocs Developer 6 on 8/12/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^WebServiceRequestSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

typedef void (^WebServiceRequestFailureHandler)(AFHTTPRequestOperation  *operation, id error);

typedef void (^WebServiceRequestXMLSuccessHandler)(AFHTTPRequestOperation  *operation);
typedef void (^WebServiceRequestXMLFailureHandler)(AFHTTPRequestOperation  *operation, NSError *error);


@interface WebService : AFHTTPRequestOperationManager

+ (WebService *)service;


-(NSString*)getDebug:(NSString*)_debug;
-(NSString *)getBaseURL:(NSString *)_baseUrl;

#pragma mark - Get Method

-(void)getConfigAPI:(NSString *)ApiConfig
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

-(void)getContact:(NSString *)_contact
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

-(void)getFaqs:(NSString *)Faq
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

-(void)getManagement:()Management
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

-(void)getClient:()Client
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)getAward:(NSString *)Awards
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

- (void)getForgetPassword:(NSString *)forgetpwd
                    email:(NSString *)email
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure;

-(void)getActivation:(NSString *)activation
    verificationCode:(NSString *)code
              userId:(NSString *)userID
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)getResendcode:(NSString *)resendCode
              userid:(NSString *)userId
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;

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
    failure:(WebServiceRequestFailureHandler)failure;

-(void)Login:(NSString *)login
       email:(NSString *)Email
    password:(NSString *)Password
  deviceType:(NSString *)deviceType
 deviceToken:(NSString *)deviceToken
     success:(WebServiceRequestSuccessHandler)success
     failure:(WebServiceRequestFailureHandler)failure;


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
                   failure:(WebServiceRequestFailureHandler)failure;


-(void)getProduct:(NSString *)Products
success:(WebServiceRequestSuccessHandler)success
failure:(WebServiceRequestFailureHandler)failure;

-(void)getProductform:(NSString *)productForm
            productId:(NSString *)productID
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure;

-(void)getProductdetail:(NSString *)productdetail
         productName:(NSString *)productname
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)getManufacture:(NSString *)manufacture
          vehicleType:(NSString *)vehicleType
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure;


-(void)getModel:(NSString *)models
           code:(NSString *)manufacturerCode
        success:(WebServiceRequestSuccessHandler)success
        failure:(WebServiceRequestFailureHandler)failure;


-(void)getSubmodels:(NSString *)subModels
    vehicleModeCode:(NSString *)code
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure;

-(void)Capacity:(NSString *)capacity
    vehicleModeCode:(NSString *)code
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure;


-(void)getManufactureYear:(NSString *)year
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure;

-(void)getstates:(NSString *)states
         success:(WebServiceRequestSuccessHandler)success
         failure:(WebServiceRequestFailureHandler)failure;

-(void)getcity:(NSString *)city
     stateCode:(NSString *)code
       success:(WebServiceRequestSuccessHandler)success
       failure:(WebServiceRequestFailureHandler)failure;

-(void)getPinCode:(NSString *)pinCode
       cityCode:(NSString *)citycode
       success:(WebServiceRequestSuccessHandler)success
       failure:(WebServiceRequestFailureHandler)failure;

-(void)getReg_States:(NSString *)regStates
                type:(NSString *)type
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)getRegCity:(NSString *)regCity
          stateCode:(NSString *)stateCode
          type:(NSString *)type
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure;

-(void)InsuredList:(NSString *)list
           success:(WebServiceRequestSuccessHandler)success
           failure:(WebServiceRequestFailureHandler)failure;

-(void)getRenewalPolicy:(NSString *)renewPolicy
                success:(WebServiceRequestSuccessHandler)success
                failure:(WebServiceRequestFailureHandler)failure;
-(void)getMemberIBA:(NSString *)memberIBAI
                success:(WebServiceRequestSuccessHandler)success
                failure:(WebServiceRequestFailureHandler)failure;

-(void)getTravelInsurance:(NSString *)travelInsurance
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure;

-(void)viewportfolio:(NSString *)_viewportfolio
              portID:(NSString *)portId
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)listportfolio:(NSString *)_listPortfolio
              userID:(NSString *)userId
           productId:(NSString *)productID
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)deleteportfolio:(NSString *)_deleteportfolio
           portfolioId:(NSString *)portfolioID
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure;

-(void)getProductname:(NSString *)productName
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure;

-(void)getCompanyname:(NSString *)companyName
              success:(WebServiceRequestSuccessHandler)success
              failure:(WebServiceRequestFailureHandler)failure;

-(void)getconstants:(NSString *)constants
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure;

-(void)getportfolio:(NSString *)portfolio
             userID:(NSString *)userId
            success:(WebServiceRequestSuccessHandler)success
            failure:(WebServiceRequestFailureHandler)failure;

-(void)GetRelationshipList:(NSString *)_relationShip
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure;

-(void)TravelInsurance:(NSString *)travelInsurance
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure;

#pragma mark - Post method

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
               failure:(WebServiceRequestFailureHandler)failure;

-(void)postContactus:(NSString *)contactUs
                name:(NSString *)name
               email:(NSString *)email
              mobile:(NSString *)mobile
             enquiry:(NSString *)enquiry
          uploadfile:(UIImage *)uploadfile
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;

-(void)Insert_Form:(NSString *)_insertForm
         productID:(NSString *)productId
        customerID:(NSString *)customerID
        formdetailDict:(NSString *)formdetailDict
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure;

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
            failure:(WebServiceRequestFailureHandler)failure;

-(void)updateForm:(NSString *)_updateForm
   lastInsertedID:(NSString *)insertedID
      productName:(NSString *)productName
        productID:(NSString *)productId
      imageUpload:(UIImage *)imageUpload
   updateFormDict:(NSString *)updateFormDict
          success:(WebServiceRequestSuccessHandler)success
          failure:(WebServiceRequestFailureHandler)failure;

-(void)postnewOfflineQuotes:(NSString *)quotes
              policyType:(NSString *)policyType
               productId:(NSString *)productID
                name:(NSString *)name
                email:(NSString *)email
                mobile:(NSString *)mobile
             invoiceImg:(UIImage *)invoiceImg
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure;

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
                      failure:(WebServiceRequestFailureHandler)failure;

-(void)postClaimdata:(NSString *)claimdata
         productType:(NSString *)productType
           firstname:(NSString *)firstname
              mobile:(NSString *)mobile
               email:(NSString *)email
             address:(NSString *)address
        policyNumber:(NSString *)policyNumber
         uploadImage:(UIImage *)uploadImage
             success:(WebServiceRequestSuccessHandler)success
             failure:(WebServiceRequestFailureHandler)failure;


-(void)postPolicyReminder:(NSString *)reminder
                     name:(NSString *)name
                    email:(NSString *)email
                   mobile:(NSString *)mobile
         insuranceProduct:(NSString *)product
             otherProduct:(NSString *)otherProduct
                  dueDate:(NSString *)duedate
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure;

-(void)postInsurancedata:(NSString *)insurancedata
            insured_name:(NSString *)insured_name
                   email:(NSString *)email
                  mobile:(NSString *)mobile
                comments:(NSString *)comments
                  files1:(UIImage *)files1
                  files2:(UIImage *)files2
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure;

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
            failure:(WebServiceRequestFailureHandler)failure;

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
            failure:(WebServiceRequestFailureHandler)failure;


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
        failure:(WebServiceRequestFailureHandler)failure;


-(void)listFamilyMembers:(NSString *)listMembers
                  userID:(NSString *)_userId
                 success:(WebServiceRequestSuccessHandler)success
                 failure:(WebServiceRequestFailureHandler)failure;

-(void)GetDoc_CategoryType:(NSString *)_categoryType
                         success:(WebServiceRequestSuccessHandler)success
                         failure:(WebServiceRequestFailureHandler)failure;

-(void)getNotificationList:(NSString *)NotificationAPI
                customerId:(NSString *)customerId
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure;

-(void)getNotificationCount:(NSString *)NotificationCount
                 customerId:(NSString *)customerId
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure;

-(void)getClaimNotificationHistory:(NSString *)claimsLists
                        customerId:(NSString *)customerId
                           claimId:(NSString *)claimId
                           success:(WebServiceRequestSuccessHandler)success
                           failure:(WebServiceRequestFailureHandler)failure;

-(void)getBulkNotifiactionHistory:(NSString *)bulkLists
                       customerId:(NSString *)customerId
                           bulkId:(NSString *)bulkId
                          success:(WebServiceRequestSuccessHandler)success
                          failure:(WebServiceRequestFailureHandler)failure;

-(void)sendClaimsNotification:(NSString *)claimsReply
                   customerId:(NSString *)customerId
                  notifyReply:(NSString *)notifyReply
                      claimId:(NSString *)claimId
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure;

-(void)sendBulkNotification:(NSString *)claimsReply
                 customerId:(NSString *)customerId
                notifyReply:(NSString *)notifyReply
                   notifyId:(NSString *)notifyId
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure;

-(void)uploadDocuments:(NSString *)uploadDoc
                userID:(NSString *)userID
              memberID:(NSString *)memberID
            categoryID:(NSString *)categoryID
                typeID:(NSString *)typeID
            expiryDate:(NSString *)expiryDate
              otherDoc:(NSString *)otherDocName
              docImage:(UIImage *)docImage
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure;

-(void)deleteDocuments:(NSString *)deletedoc
              memberId:(NSString *)member_id
            documentId:(NSString *)doc_id
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure;

-(void)deleteMembers:(NSString *)deletedoc
              userID:(NSString *)user_id
              memberId:(NSString *)member_id
               success:(WebServiceRequestSuccessHandler)success
               failure:(WebServiceRequestFailureHandler)failure;

#pragma TWO Wheeler API

-(void)GetTwoWheelerFormDetails:(NSString *)applyForm
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure;

-(void)GetMyPolicyDetails:(NSString *)MypolicyDetails
                 customer:(NSString *)customer
                       ID:(NSString *)customerId
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure;

-(void)SendEmail:(NSString *)SendEmail
       productid:(NSString *)productid
       paymentid:(NSString *)paymentid
     failedreson:(NSString *)failedresaon
failedreasonother:(NSString *)failedresonother
    failedupload:(UIImage *)failedupload
         success:(WebServiceRequestSuccessHandler)success
         failure:(WebServiceRequestFailureHandler)failure;

-(void)GetTwoWheelerModel:(NSString *)models
                     make:(NSString *)manufacturer
                modelname:(NSString *)modelName
              productmake:(NSString *)productmake
                modeltype:(NSString *)modeltype
                      app:(NSString *)app
                  success:(WebServiceRequestSuccessHandler)success
                  failure:(WebServiceRequestFailureHandler)failure;

-(void)GetTwoWheelerVarient:(NSString *)varient
                       make:(NSString *)manufacturer
                  modelname:(NSString *)modelName
                productmake:(NSString *)productmake
                  modeltype:(NSString *)modeltype
                        app:(NSString *)app
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure;

-(void)GetRTODetails:(NSString *)DataDetails
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure;

-(void)GetTwoWheelerFinancierDetails:(NSString *)financierDetails
                             success:(WebServiceRequestSuccessHandler)success
                             failure:(WebServiceRequestFailureHandler)failure;

-(void)TwoWheelerQuoteGenerate:(NSString *)QuoteGenerate
               premiuminsertid:(NSString *)premiuminsertid
              premiumproductid:(NSString *)premiumproductid
                           app:(NSString *)app
                       success:(WebServiceRequestSuccessHandler)success
                       failure:(WebServiceRequestFailureHandler)failure;

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
                      failure:(WebServiceRequestFailureHandler)failure;

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
                     failure:(WebServiceRequestFailureHandler)failure;

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
             failure:(WebServiceRequestFailureHandler)failure;

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
                   failure:(WebServiceRequestFailureHandler)failure;

-(void)cancelRequest;

#pragma  mark - Four Wheeler API

-(void)GetFourWheelerFormDetails:(NSString *)applyForm
                         success:(WebServiceRequestSuccessHandler)success
                         failure:(WebServiceRequestFailureHandler)failure;

-(void)GetFourWheelerModel:(NSString *)models
                      make:(NSString *)manufacturer
                 modelname:(NSString *)modelName
               productmake:(NSString *)productmake
                 modeltype:(NSString *)modeltype
                       app:(NSString *)app
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure;

-(void)GetFourWheelerVarient:(NSString *)varient
                        make:(NSString *)manufacturer
                   modelname:(NSString *)modelName
                 productmake:(NSString *)productmake
                   modeltype:(NSString *)modeltype
                         app:(NSString *)app
                     success:(WebServiceRequestSuccessHandler)success
                     failure:(WebServiceRequestFailureHandler)failure;

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
              failure:(WebServiceRequestFailureHandler)failure;

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
                    failure:(WebServiceRequestFailureHandler)failure;

-(void)FourWheelerQuoteGenerate:(NSString *)QuoteGenerate
                premiuminsertid:(NSString *)premiuminsertid
               premiumproductid:(NSString *)premiumproductid
                            app:(NSString *)app
                        success:(WebServiceRequestSuccessHandler)success
                        failure:(WebServiceRequestFailureHandler)failure;

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
                      failure:(WebServiceRequestFailureHandler)failure;

// Travel Insurance
-(void)TravelInsuranceQuote:(NSString *)travelInsurance
                    success:(WebServiceRequestSuccessHandler)success
                    failure:(WebServiceRequestFailureHandler)failure;

-(void)postTravelBasicInfo:(NSDictionary *)NotificationAPI
                customerId:(NSString *)customerId
                   success:(WebServiceRequestSuccessHandler)success
                   failure:(WebServiceRequestFailureHandler)failure;

-(void)TravelInsuranceQuoteApi:(NSString *)travelDataId provider:(NSString *)providerId group:(NSString*)groupId andPremiumId:(NSString *)premiumId
                       success:(WebServiceRequestSuccessHandler)success
                       failure:(WebServiceRequestFailureHandler)failure ;

-(void)TravelProposalCountApi:(NSString *)travelDataId
                     provider:(NSString *)providerId
                        group:(NSString*)groupId
                     customer:(NSString*)customerId
                    coverTypr:(NSString *)typeOfCover
                   familyType:(NSString *)familytype
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure;
-(void)proposalPostTravelInfo:(NSDictionary *)notificationDict
                   customerId:(NSString *)customerId
                      success:(WebServiceRequestSuccessHandler)success
                      failure:(WebServiceRequestFailureHandler)failure;

-(void)proposalDetailSumitInfo:(NSDictionary *)notificationDict
                    customerId:(NSString *)customerId
                       success:(WebServiceRequestSuccessHandler)success
                       failure:(WebServiceRequestFailureHandler)failure;

@end
