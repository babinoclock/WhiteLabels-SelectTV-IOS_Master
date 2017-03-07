//
//  WebserviceConfig.h
//  Policy 99
//
//  Created by Ocs Developer 6 on 8/12/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#ifndef WebserviceConfig_h
#define WebserviceConfig_h

//Live URL
#define BUILD_FOR      @"live"

//demo URL
//#define BUILD_FOR      @"demo"

#define Config_Details  @"configdetails"

#define UserID          @"userId"

#define Version_Details  @"version_Details"


//API keys
#define ConfigAPI           @"getApiDetails"

#define ApiPaths            @"ApiPaths"

#define Registration        @"register"

#define SignIn              @"signIn"

#define SignInsocial        @"signInsocial"

#define getContacts         @"getContactus"

#define getFaq              @"getFaq"

#define getManagementTeam   @"getManagementTeam"

#define getOurClients       @"getOurClients"

#define getAwards           @"getAwards"

#define getChooseus         @"getChooseus"

#define getPrivacyPolicy    @"getPrivacyPolicy"

#define getTermsofUse       @"getTermsofUse"

#define getForgotPassword   @"forgetPassword"

#define getProducts         @"getProducts"

#define getProductForm      @"getProdoctFormData"

#define getActivate         @"activation"

#define getresendcode       @"resendCode"

#define getManufacturer     @"getManufacturer"

#define getModels           @"getModels"

#define getSubModels        @"getSubModels"

#define getCapacity         @"getCapacity"

#define getManufacturerYear   @"getManufacturerYear"

#define getRegistrationStates @"getRegistrationStates"

#define getRegistrationCity   @"getRegistrationCity"

#define getStates          @"getStates"

#define getCity            @"getCity"

#define getPinLocality     @"getPinLocality"

#define getInsurerList     @"getInsurerList"

#define getrenewalCorner   @"renewalCorner"

#define getMemberIBAI      @"MemberIBAI"

#define postContact        @"sendContact"

#define UpdateProfile      @"updateProfile"

#define InsertForm         @"insertForm"

#define getproductDetail   @"getProductDetails"

#define UpdateForm         @"updateForm"

#define getOfflineQuotes   @"getOfflineQuotes"

#define getExternalTravelInsurance @"getExternalTravelInsurance"

#define claimsCorner       @"claimsCorner"

#define policyReminder     @"policyReminder"

#define insuranceConsultancy @"insuranceConsultancy"

#define viewPortfolio     @"viewportfolio"

#define listPortfolio     @"portfolio"

#define addPortfolio      @"addportfolio"

#define updatePortfolio   @"updatePortfolio"

#define deletePortfolio   @"deletePortfolio"

#define getProductName     @"getproductname"

#define getCompanyName     @"getcompanyname"

#define getConstants       @"constants"

#define getPortfolio       @"getPortfolio"

#define getProductDetailstest @"getProductDetailstest"

#define forceUpdate        @"forceupdate_ios"

#define GetFamilyMembersDetails @"getFamilymembersDetails"

#define Add_Update_FamilyMembers   @"AddandUpdateFamilyMembers"

#define GetCategoryandType  @"getCategoryandType"

#define RelationShipList    @"getRelationshipList"

#define DocumentsUpload     @"UpLoadDocuments"

#define Delete_FamilyMember @"DeleteFamilyMember"

#define Delete_FamilyMember_Document @"DeleteFamilyMemberDocument"

#define getMypolicyDetails   @"mypolicies"


/*// Two wheeler
 TESTER WITH STAGING
#define TwoWheeler_Apply_Form    @"http://staging.policy99.com/app/two-wheeler-insurance"


#define RTO_Details              @"http://staging.policy99.com/getrtomastervalue?app=1"

#define TwoWheeler_Financier_Details  @"http://staging.policy99.com/index.php?route=vehicle/proposal/getfinanciervalue&app=1"
 
 //#define FourWheeler_Apply_Form  @"http://staging.policy99.com/app/car-insurance"
 */

// Two wheeler
#define TwoWheeler_Apply_Form    @"http://www.policy99.com/app/two-wheeler-insurance"

#define RTO_Details              @"http://www.policy99.com/getrtomastervalue?app=1"

#define TwoWheeler_Financier_Details  @"http://www.policy99.com/index.php?route=vehicle/proposal/getfinanciervalue&app=1"



#define GetTwoWheelerForm     @"Two_wheeler_Apply_Form"
#define GetRTOData            @"Two_wheeler_Data_"
#define GetTwoWheelerFinancier     @"TwoWheeler_Financier_Detail"

//Four wheeler

#define FourWheeler_Apply_Form  @"http://www.policy99.com/app/car-insurance"

#define GetFourWheelerForm   @"Four_Wheeler_Apply_Form"

//Push Notifications

#define DeviceToken                   @"deviceToken"

#define DeviceType                    @"iphone"

#define GetNotificationList           @"getNotificationList?"

#define GetNotificationCount          @"getNotificationCount?"

#define GetClaimsNotificationHistory  @"getClaimsNotificationHistory?"

#define GetBulkNotificationHistory    @"getBulkNotificationHistory?"

#define SendClaimsNotification        @"sendClaimsNotification?"

#define SendBulkNotification          @"sendBulkNotification?"

#endif
