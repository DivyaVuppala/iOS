//
//  ModelTrackingClass.h
//  BBT
//
//  Created by Cognizant on 2/22/11.
//  Copyright 2012 by Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelTrackingClass : NSObject {
    
    NSString *userID;
    NSString *password;
    NSString *userName;
    NSString *oppID;
	
}

@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *password;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *oppID;

/* Shared Instance of  ModelTrackingClass(self) */
+(ModelTrackingClass *)sharedInstance;

-(id)getLocationObjectForKey:(NSString *)keyValue;
-(void)setLocationObject:(id)locObj forKey:(NSString *)keyValue;

-(void)setModelObject:(id)modelObj forKey:(NSString *)keyValue;
-(id)getModelObjectForKey:(NSString *)keyValue;
-(void) removeModelObjectForKey:(NSString *)keyValue;

-(void)setModelIndex:(id)modelObj forKey:(NSString *)keyValue;
-(id)getModelIndexForKey:(NSString *)keyValue;

-(void) clear;
@end
