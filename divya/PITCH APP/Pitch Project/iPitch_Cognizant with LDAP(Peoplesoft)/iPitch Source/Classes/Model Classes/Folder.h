//
//  Folder.h
//  iPitch V2
//
//  Created by Satheeshwaran on 3/6/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Folder : NSManagedObject

@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSString * folderPath;

-(int)numberOfItemsInFolder;
-(int)numberOfItemsInFolder:(Folder *)folder;


@end
