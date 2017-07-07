//
//  Tasks.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "Tasks.h"


@implementation Tasks

@dynamic taskSubject;
@dynamic taskDueDate;
@dynamic taskDescription;
@dynamic taskCompletionStatus;
@dynamic taskSyncType;
@dynamic taskType;
@dynamic taskID;


-(TaskType)taskTypeRaw {
    return (TaskType)[[self taskType] intValue];
}

-(void)setTaskTypeRaw:(TaskType)type {
    [self setTaskType:[NSNumber numberWithInt:type]];
}

+(NSSet *)keyPathsForValuesAffectingTaskTypeRaw {
    return [NSSet setWithObject:@"taskType"];
}

@end
