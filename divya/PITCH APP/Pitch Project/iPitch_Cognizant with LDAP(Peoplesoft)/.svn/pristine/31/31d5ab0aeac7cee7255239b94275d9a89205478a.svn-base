//
//  Service.h
//  AppStoreiPhone
//
//  Created by Deepa Gangadharan on 20/11/11.
//  Copyright 2011 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LDAPCallBack <NSObject>

@required

-(void)autenticationSuccess;
-(void)ldapAuthenticationFailed;
-(void)requestFailed:(NSError *)error;

@end

@interface LDAPAuthenticator : NSObject {
    
   
 //   ServicType serviceType;
}

@property (nonatomic,weak) id<LDAPCallBack> delegate;

-(void)authenticateLDAPUserWithUserName:(NSString *)userName andPassword:(NSString *)passwordl;
-(void)loginOutService;

@end
