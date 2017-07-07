//
//  Folder.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/6/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "Folder.h"


@implementation Folder

@dynamic folderName;
@dynamic folderPath;

-(int)numberOfItemsInFolder
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSArray *allList= [NSArray arrayWithArray:[manager contentsOfDirectoryAtPath:self.folderPath error:nil]];
    
    return [allList count];
}

-(int)numberOfItemsInFolder:(Folder *)folder
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSArray *allList= [NSArray arrayWithArray:[manager contentsOfDirectoryAtPath:folder.folderPath error:nil]];
    
    return [allList count];
}

@end
