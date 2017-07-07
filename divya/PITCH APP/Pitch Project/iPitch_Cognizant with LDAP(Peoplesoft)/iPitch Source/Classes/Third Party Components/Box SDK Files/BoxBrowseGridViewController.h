//
//  BoxBrowseGridViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxFolder.h"
#import "BoxLoginViewController.h"
#import "BoxCommonUISetup.h"

@interface BoxBrowseGridViewController : UIViewController<BoxLoginViewControllerDelegate>
{
    BoxLoginViewController *vc;

}
@property (nonatomic, readonly, retain) NSString * folderID;
@property (nonatomic, readonly, retain) BoxFolder * rootFolder; //Refers to the folder that is being presented by the view.

- (id)initWithFolderID:(NSString*)folderID; //The folderID must be set. Use @"0" for the root folder.
- (void)refreshBoxContentsSource;
@end
