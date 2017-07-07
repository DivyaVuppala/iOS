
//
//  Service.m
//  AppStoreiPhone
//
//  Created by Deepa Gangadharan on 20/11/11.
//  Copyright 2011 Cognizant. All rights reserved.
//

#import "LDAPAuthenticator.h"
#import "ASIHTTPRequest.h"
#import "XMLParser.h"
#import "ModelTrackingClass.h"
#import "Utils.h"


#define MIDDLEWARE_URL @"https://truhub.cognizant.com/"
#define LOGIN_CALL @"AuthenticationService.svc/AppStoreAuthenticate"
#define LOGOUT_CALL @"AuthenticationService.svc/AppStoreLogOut"

#define CONTENT_TYPE_PARAMETER @"Content-Type"
#define CONTENT_TYPE_VALUE @"application/json; charset=utf-8"

#define PLATFORM_PARAMETER @"platform_name"
#define OS_VERSION_PARAMETER @"os_version"
#define MODEL_NUMBER_PARAMETER @"model_number"
#define DEVICE_TYPE_PARAMETER @"device_type"

#define DEVICE_PLATFORM_VALUE @"iOS"
#define DEVICE_MODEL_NUMBER_VALUE @"null"
#define DEVICE_TYPE_VALUE @"iPad"

#define MESSAGE_STATUS_PARAMETER @"message_status"
#define DISPLAY_MESSAGE_PARAMETER @"display_message"
#define SUCCESS_PARAMETER @"Success."
#define APPSTORE_INFORMATION_PARAMETER @"appstore_information"
#define APPSTORE_USER_ID_PARAMETER @"appstore_user_id"
#define APPSTORE_PASSWORD_PARAMETER  @"appstore_password"
#define APPSTORE_AUTHENTICATION_PARAMETER @"appstore_authentication_type"
#define NETWORK_TIMEOUT 30
#define loginURL @"https://vibewebservices.cognizant.com/vibeservice.asmx?"
//#define loginURL @"www.google.com:81"
#define POST @"Post"


@implementation LDAPAuthenticator
@synthesize delegate;

#pragma mark init

- (id)init {
    
	if (self = [super init])
    {
        
		return self;
	}
    
    return nil;
}


//Called for LDAP service

#pragma mark Login

-(void)authenticateLDAPUserWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    NSURL *urlActivities =[NSURL URLWithString: loginURL];
    
    NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><isLDAPAuthenticated xmlns=\"http://tempuri.org/\"><username>%@</username><password>%@</password><domain>cts</domain></isLDAPAuthenticated></soap:Body></soap:Envelope>",userName,password];
    
  
    NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
    requests.timeoutInterval = 30;
    [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [requests setValue:@"http://tempuri.org/isLDAPAuthenticated" forHTTPHeaderField:@"SOAPAction"];
    [requests setHTTPMethod:@"POST"];
    [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData   *data = (NSMutableData *) [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
    
    NSString *s = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",s);
    if(!error)
    {
        
        //parsing
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        XMLParser *xmlParser = [[XMLParser alloc]initXMLParser];
        xmlParser.ParsingType = Authentication;
        [parser setDelegate:xmlParser];
        BOOL success = [parser parse];
        if(success)
        {
            if(xmlParser.IsAuthenticated)
            {
                if([self.delegate respondsToSelector:@selector(autenticationSuccess)])
                {
                    [self.delegate autenticationSuccess];
                }
            }
            else if(!xmlParser.IsAuthenticated)
            {
                if([self.delegate respondsToSelector:@selector(ldapAuthenticationFailed)])
                {
                    [self.delegate ldapAuthenticationFailed];
                }
                NSLog(@"Authentication Error!!!");
            }
            
        }
    }
    
    else
    {
        if([self.delegate respondsToSelector:@selector(requestFailed:)])
        {
            [self.delegate requestFailed:error];
        }
    }
    
    
}


@end
