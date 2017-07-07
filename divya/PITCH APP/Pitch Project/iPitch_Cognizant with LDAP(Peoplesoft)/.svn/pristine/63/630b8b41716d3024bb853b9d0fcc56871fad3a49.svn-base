//
//  NetworkServiceHandler.h
//  RAKbankDynamic
//
//  Created by Sanjay B on 15/10/10.
//  Copyright 2010 Zylog Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkServiceHandler : NSObject 
{
}
+(NSString*)getResourceFilePath:(NSString*)filePath;
+(NSString*)getUDIDNumber;
+(NSString*)getApplicationVersion;
+(id)requestForLoginData;
+(NSString*)createLoginRequest;
+(NSString*)createURL;
+(NSString*)encryptedString:(NSString*)requestString key:(NSDictionary*)key;
+(NSString*)decryptedString:(NSString*)requestString key:(NSMutableDictionary*)key;
+(NSString*)encryptLoginRequest:(NSString*)userName pwd:(NSString*)password req:(NSString*)requestString;
+(NSString*)encryptLoginRequestPwd:(NSString*)userName pwd:(NSString*)password key:(NSMutableDictionary*)key;
+(NSString*)timeStamp;
+(BOOL)isAllowPhoneNumber:(NSString*)strg;
+(BOOL)isAllowPONumber:(NSString*)strg;
+(BOOL)isAllowAmount:(NSString*)strg;
+(BOOL)isAllowtextfied:(NSString*)strg;

+(BOOL)NSStringIsValidateAmount:(NSString*)checkString;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(BOOL)NSStringIsValidatePhone:(NSString*)checkString;
+(BOOL)NSStringIsValidateAccountNo:(NSString*)checkString;
+(BOOL)NSStringIsValidateIBAN:(NSString*)checkString;
+(BOOL)NSStringIsValidateAlphabet:(NSString*)checkString;
+(BOOL)isAllowAccountNumber:(NSString*)strg;
+(BOOL)isAllowLoanNumber:(NSString*)strg;
+(BOOL)isAllowCreditCardNumber:(NSString*)strg;
+(BOOL)isAllowPinNumber:(NSString*)strg;
+(BOOL)isAllowMobileNumber:(NSString*)strg;
+(BOOL)isAllowLoginName:(NSString*)strg;
+(BOOL)isAllowCountryCode:(NSString*)strg;
+(BOOL)isAllowNames:(NSString*)strg;
+(BOOL)isAllowMaxChars:(NSString*)strg;
+(BOOL)isAllowOutsideAccountNumber:(NSString*)strg;
+(BOOL)isAllowTransferName:(NSString*)strg;
+(BOOL)isAllowTransferDetails:(NSString*)strg;
+(BOOL)isAllowSwift:(NSString*)strg;
+(BOOL)isAllowCity:(NSString*)strg;
+(BOOL)NSStringIsValidateAmount_new:(NSString*)checkString;
+(BOOL)isAllowFaxNumber:(NSString*)strg;
+(BOOL)NSStringIsValidateDate:(NSString*)checkString;
+(BOOL)isAllowOtherComment:(NSString*)strg;
+(BOOL)isAllowtextNameOfCard:(NSString*)strg;
+(BOOL)isAllowEmailId:(NSString*)strg;
+(BOOL)NSStringIsValidateAlphaNumaric:(NSString *)checkString;
+(BOOL)isAllowMxNames:(NSString*)strg;
+(BOOL)isAllowMaxNumber:(NSString*)strg;
+(BOOL)NSStringIsValidateAlphaNumaric_withoutSpace:(NSString *)checkString;
+(BOOL)NSStringIsValidateAlphaNumaric_withSplChrac:(NSString *)checkString;
+(BOOL)isAllowtextNameOnCard:(NSString*)strg;
+(BOOL)NSStringIsValidateDecimal:(NSString*)strg;
+(BOOL)isAllowDesc:(NSString*)strg;

@end
