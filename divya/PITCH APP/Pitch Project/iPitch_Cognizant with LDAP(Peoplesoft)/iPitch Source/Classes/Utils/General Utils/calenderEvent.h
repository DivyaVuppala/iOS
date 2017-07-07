//
//  calenderEvent.h
//  CRMNew
//
//  Created by Sandhya Sandala on 16/01/13.
//  Copyright (c) 2013 sandhya17@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calenderEvent : NSObject

{
    NSMutableArray *activityEvent;
}

@property (nonatomic, retain)NSMutableArray *activityEvent;

-(void)CreateEvent;

@end
