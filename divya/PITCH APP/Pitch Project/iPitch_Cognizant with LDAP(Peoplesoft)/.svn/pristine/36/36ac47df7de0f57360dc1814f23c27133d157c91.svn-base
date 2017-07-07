//
//  SalesForceOAuthLoginHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 6/14/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SalesForceOAuthLoginResultParamters {
	SalesForceOAuthLoginResultSuccessParamter = 0,
	SalesForceOAuthLoginResultFailedParamter,
	SalesForceOAuthLoginResultUnknownErrorParamters
} SalesForceOAuthLoginResultParamters;

@protocol SalesForceLoginDelegate 

@required

-(void)loginCompletedWithResult:(SalesForceOAuthLoginResultParamters)resultParamter;

-(void)loginCancelled;

@end
                                 
@interface SalesForceOAuthLoginHelper : UIViewController

@property (nonatomic,weak) id <SalesForceLoginDelegate> delegate;

@end


