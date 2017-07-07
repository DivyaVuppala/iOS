//
//  Tasks.h
//  iPitch V2
//
//  Created by Satheeshwaran on 3/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    TaskTypeCall=0,
    TaskTypeEmail=1,
    TaskTypeMeeting=2,
    TaskTypeProduct_Demo=3
} TaskType;

@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSString * taskSubject;
@property (nonatomic, retain) NSDate * taskDueDate;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSNumber * taskCompletionStatus;
@property (nonatomic, retain) NSNumber * taskSyncType;
@property (nonatomic, retain) NSNumber * taskType;
@property (nonatomic, retain) NSString * taskID;


-(TaskType)taskTypeRaw;
-(void)setTaskTypeRaw:(TaskType)type;

@end
