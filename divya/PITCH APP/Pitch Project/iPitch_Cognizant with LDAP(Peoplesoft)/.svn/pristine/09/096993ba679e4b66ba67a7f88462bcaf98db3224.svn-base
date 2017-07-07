//
//  PDFFile.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/8/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PDFFile.h"

@implementation PDFFile

@synthesize fileName;
@synthesize filePath;

- (NSString *)getFileType{
    
    NSString *extnsn = [self.fileName pathExtension];
    extnsn = [extnsn lowercaseString];
    if ([extnsn isEqualToString:@"pdf"]) {
        return extnsn;
    }
    else if([extnsn isEqualToString:@"mp4"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"m4v"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"zip"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"jpg"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"jpeg"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"png"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"doc"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"ppt"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"xls"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"docx"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"pptx"]){
        return extnsn;
    }
    else if([extnsn isEqualToString:@"xlsx"]){
        return extnsn;
    }
    
    
    return nil;
}

-(BOOL)fileObjectIsInArray:(NSMutableArray *)array
{
    
    for (int i=0; i<[array count]; i++)
    {
        PDFFile *sFile=(PDFFile *)[array objectAtIndex:i];
        if ([sFile.fileName isEqualToString:self.fileName])
        {
            return YES;
        }
        
    }
    return NO;
}

+(BOOL)fileWithPath:(NSString *)path IsInArray:(NSMutableArray *)array
{
    
    for (int i=0; i<[array count]; i++)
    {
        PDFFile *sFile=(PDFFile *)[array objectAtIndex:i];
        if ([sFile.filePath isEqualToString:path])
        {
            return YES;
        }
        
    }
    return NO;
}

+(void)removeFileWithFilePath:(NSString *)path InArray:(NSMutableArray *)array
{
    
    for (int i=0; i<[array count]; i++)
    {
        PDFFile *sFile=(PDFFile *)[array objectAtIndex:i];
        if ([sFile.filePath isEqualToString:path])
        {
            [array removeObject:sFile];
        }
        
    }
}
@end
