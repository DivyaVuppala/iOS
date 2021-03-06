//
//  File.h
//  iPitch V2
//
//  Created by Satheeshwaran on 3/8/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface File : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * filePath;



- (NSString *)getFileType;

-(BOOL)fileObjectIsInArray:(NSMutableArray *)array;

+(BOOL)fileWithPath:(NSString *)path IsInArray:(NSArray *)array;

+(void)removeFileWithFilePath:(NSString *)path InArray:(NSMutableArray *)array;

@end
