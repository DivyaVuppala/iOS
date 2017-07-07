//
//  CTSDropBoxHelper.m
//  iPitch
//
//  Created by unameit on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTSDropBoxHelper.h"
#import "iPitchConstants.h"

#define APP_KEY @"0shhmbdlithnsdi" //also change in info.plist for URL schema iPitchAccount
#define SEC_KEY @"cjs7or0axhwsh4z"

@implementation CTSDropBoxHelper

@synthesize restClient;
@synthesize lastLocalPath;
@synthesize delegate;

- (void)dealloc{
}

- (id)init{
    self = [super init];
    if (self) {
              
         self.lastLocalPath = [self applicationDocumentsDirectory];
       
    }
    return self;
}



+ (void)createSession{
    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:APP_KEY
      appSecret:SEC_KEY
      root:kDBRootDropbox]
     ;
    [DBSession setSharedSession:dbSession];

}

+ (BOOL)handleOpenUrl:(NSURL *)url{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully! In APPDELEGATE");
            [[NSNotificationCenter defaultCenter] postNotificationName:kDropBoxLinkedSuccessfullyNotification object:nil];
        }
        return YES;
    }
    NSLog(@"App linking Failed!");
    return NO;

}

- (void)deleteAllFilesInDropBoxFolder{
    NSFileManager *fileMgr = [[NSFileManager alloc] init] ;
    NSError *error = nil;
    NSString *dropBoxPath = [self applicationDocumentsDirectory];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:dropBoxPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [dropBoxPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
            else {
                NSLog(@"Removed file at Path:%@",fullPath);
            }
        }
    } else {
        // Error handling
        
    }
}

- (void)deleteFileAtPath:(NSString *)filePath withFileType:(NSString *)fType
{
    if ([fType isEqualToString:@"zip"]) {
        
    }
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager removeItemAtPath:filePath error:nil])
    {
        NSLog(@"File at Path:%@ DELETED",filePath);
    }
    else{
        NSLog(@"File at Path:%@ NOT DELETED",filePath);
    }
}





- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}


- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
    if([self.delegate respondsToSelector:@selector(cTSDropBoxHelper:loadMetadataFailedWithError:ForRestClient:)])
        [self.delegate cTSDropBoxHelper:self loadMetadataFailedWithError:error ForRestClient:client];

}

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
    NSLog(@"UserID: %@ %@", [info displayName], [info userId]);
    if([self.delegate respondsToSelector:@selector(loadeUserInfoWithName:andUserID:)])
        [self.delegate loadeUserInfoWithName:[info displayName] andUserID:[info userId]];

}

- (BOOL)checkForSession:(UIViewController *)vc
{
    return [[DBSession sharedSession] isLinked];
}

- (void)linkDropBoxAccountForVC:(UIViewController *)vc{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:vc];
    }
  
}

- (void)loadFilesAtPath:(NSString *)path{
    if ([[DBSession sharedSession] isLinked]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addActivityIndicatorView" object:self];
        [[self restClient] loadMetadata:path];
    }
   
}

//- (NSString *)downloadFileAtDBPath:(NSString *)filePath{
//    
//    NSString *destnPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],filePath];
//    NSLog(@"Slide Downloading Path:%@",destnPath);
//    [[self restClient] loadFile:filePath intoPath:destnPath];
//    return destnPath;
//}

- (NSString *)applicationDocumentsDirectory 
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
- (NSString *)getDropBoxDirectory{
    return [NSString stringWithFormat:@"%@/Container",[self applicationDocumentsDirectory]];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    if([self.delegate respondsToSelector:@selector(cTSDropBoxHelper:loadedMetaData:ForRestClient:)])
        [self.delegate cTSDropBoxHelper:self loadedMetaData:metadata ForRestClient:client];
}





-(void)getFoldersAndFilesAtPath:(NSString *)_path
{
       // [allList release];
}

- (void)logOut{
   if ([[DBSession sharedSession] isLinked]) {
       [[DBSession sharedSession]unlinkAll];
   }
}

- (void)loadPreviousLocalPath{
    //[self loadFilesAtLocalPath:self.lastLocalPath];
}
- (void)loadAccountInfo{
    if ([[DBSession sharedSession] isLinked]) {
        [self.restClient loadAccountInfo];
    }
}


@end
