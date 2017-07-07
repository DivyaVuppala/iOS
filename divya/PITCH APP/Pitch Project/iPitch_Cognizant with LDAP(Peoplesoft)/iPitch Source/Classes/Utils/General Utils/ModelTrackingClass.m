//
//  ModelTrackingClass.m
//  
//
//  Created by Cognizant on 2/22/11.
//  Copyright 2012 by Cognizant. All rights reserved.
//

#import "ModelTrackingClass.h"


@implementation ModelTrackingClass

static ModelTrackingClass *sharedModelTrackingInstance = nil;
static NSMutableDictionary *modelObjectDictionary = nil;
static NSMutableDictionary *indexDictionary = nil;
static NSMutableDictionary *locationDictionary = nil;
@synthesize userID,password,userName,oppID;

//dictionary for maintaining index & model objects..
+(ModelTrackingClass *)sharedInstance
{
	@synchronized(self){
		if(sharedModelTrackingInstance == nil){
			sharedModelTrackingInstance = [[self alloc] init];
			
			modelObjectDictionary = [[NSMutableDictionary alloc] init];
			indexDictionary = [[NSMutableDictionary alloc] init];
			locationDictionary = [[NSMutableDictionary alloc] init];
		}
	}
	return sharedModelTrackingInstance;
}

-(void)setLocationObject:(id)locObj forKey:(NSString *)keyValue
{
	[locationDictionary setObject:locObj forKey:keyValue];
}

-(id)getLocationObjectForKey:(NSString *)keyValue
{
	return [locationDictionary objectForKey:keyValue];
}


-(void)setModelObject:(id)modelObj forKey:(NSString *)keyValue
{
	[modelObjectDictionary setObject:modelObj forKey:keyValue];
}

-(id)getModelObjectForKey:(NSString *)keyValue
{
	return [modelObjectDictionary objectForKey:keyValue];
}

-(void) removeModelObjectForKey:(NSString *)keyValue
{
	[modelObjectDictionary removeObjectForKey:keyValue];
}

-(void)setModelIndex:(id)modelObj forKey:(NSString *)keyValue
{
	[indexDictionary setObject:modelObj forKey:keyValue];
}

-(id)getModelIndexForKey:(NSString *)keyValue
{
	return [indexDictionary objectForKey:keyValue];
}

-(void) clear {
	[modelObjectDictionary removeAllObjects];
	[indexDictionary removeAllObjects];
}
- (void)dealloc {
	[modelObjectDictionary release];
	[indexDictionary release];
	[super dealloc];
}


@end
