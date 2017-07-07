//
//  LocalFilesViewController.h
//  iPitch
//
//  Created by Krishnaveni Singaram on 12/4/12.
//  Copyright (c) 2012 Cognizant Technology Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Folder.h"
#import "File.h"
#import "Playlist.h"

#import "BoxFolder.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"

#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxLoginViewController.h"
#import "MBProgressHUD.h"


@interface LocalFilesViewController : UIViewController<UIAlertViewDelegate,BoxLoginViewControllerDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *folderArray;
    UIViewController *VC;
    NSMutableArray *filteredArray;
    NSMutableArray * PlaylistArray;
    
    MBProgressHUD *hud;
    BoxLoginViewController * vc;

}

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (copy, nonatomic) NSMutableArray *folderArray;

@property (nonatomic, retain) NSMutableArray *tableSource;
@property (nonatomic,  retain) Folder *currentFolder;
@property (nonatomic,  retain) NSString *currentFolderpath;

@property (nonatomic,  retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, retain) NSString * folderID;
@property (nonatomic, readonly, retain) BoxFolder * rootFolder;


@property (retain, nonatomic) NSMutableArray *filteredArray;
 
@property BOOL isServerMode;

- (void)reloadWithArray:(NSMutableArray *)_contents;
@end
