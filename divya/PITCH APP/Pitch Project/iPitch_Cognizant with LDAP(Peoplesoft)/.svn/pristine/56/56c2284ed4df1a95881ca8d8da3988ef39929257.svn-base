//
//  CTSDropBoxHelper.h
//  iPitch
//
//  Created by unameit on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@class CTSDropBoxHelper;

@protocol CTSDropBoxHelperDelegate <NSObject>

- (void)cTSDropBoxHelper:(CTSDropBoxHelper *)cTSDropBoxHelper loadedMetaData:(DBMetadata *)metadata ForRestClient:(DBRestClient *)client;
- (void)cTSDropBoxHelper:(CTSDropBoxHelper *)cTSDropBoxHelper loadMetadataFailedWithError:(NSError *)error ForRestClient:(DBRestClient *)client;
- (void)loadedLocalFolders:(NSMutableArray *)folders andFiles:(NSMutableArray *)files atPath:(NSString *)path;
- (void)loadeUserInfoWithName:(NSString *)userName andUserID:(NSString *)userID;

@end

@interface CTSDropBoxHelper : NSObject<DBRestClientDelegate>{
    DBRestClient *restClient;
    NSString *lastLocalPath;
}

@property (nonatomic, weak) id <CTSDropBoxHelperDelegate> delegate;
@property (retain, nonatomic) DBRestClient *restClient;
@property (copy,nonatomic)  NSString *lastLocalPath;

+ (void) createSession;
+ (BOOL)handleOpenUrl:(NSURL *)url;
- (BOOL)checkForSession:(UIViewController *)vc;
- (void)logOut;
- (void)loadPreviousLocalPath;
- (void)linkDropBoxAccountForVC:(UIViewController *)vc;
- (void)loadFilesAtPath:(NSString *)path;
- (NSString *)applicationDocumentsDirectory;
- (NSString *)getDropBoxDirectory;
- (void)deleteAllFilesInDropBoxFolder;
- (void)deleteFileAtPath:(NSString *)filePath withFileType:(NSString *)fType;
- (void)loadAccountInfo;

@end
