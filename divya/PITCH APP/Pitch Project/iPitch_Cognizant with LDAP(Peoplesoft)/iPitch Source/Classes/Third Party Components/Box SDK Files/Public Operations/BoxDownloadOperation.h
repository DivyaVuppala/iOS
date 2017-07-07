
//
// Copyright 2011 Box, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import <Foundation/Foundation.h>
#import "BoxNetworkOperation.h"

typedef void(^BoxFileDownloadProgressHandler)(BoxOperation *op, NSNumber *completionRatio); // progress is returned as between 0 (0%) and 1 (100%).

@interface BoxDownloadOperation : BoxNetworkOperation

@property (nonatomic, readwrite, retain) NSString *tempFilePath;
@property (nonatomic, readwrite, retain) NSString *authToken;

@property (nonatomic, readwrite, copy) BoxFileDownloadProgressHandler progressHandler;

+ (id)operationForFileID:(NSString *)targetFileID toPath:(NSString *)path;

@end