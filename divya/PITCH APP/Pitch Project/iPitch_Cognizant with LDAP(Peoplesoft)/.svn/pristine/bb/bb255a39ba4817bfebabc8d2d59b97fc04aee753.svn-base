//
//  DocumentTableView.h
//  iPitch V2
//
//  Created by Sandhya Sandala on 12/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "File.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "PresentationPaneViewController.h"

#import "BoxFolder.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"

#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxLoginViewController.h"

#import "CTSDropBoxHelper.h"


@interface DocumentTableView : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BoxLoginViewControllerDelegate,CTSDropBoxHelperDelegate>{
	NSDictionary *tableContents;
	NSArray *sortedKeys;
    UIScrollView * DocumentScrollView;
    UIButton *dummyBtn;
    UIButton *tButton;
    UIPopoverController* documentOptionsPopOver;
    NSMutableArray * PlaylistArray;
    UIViewController * PlaylistDetails;
    UIViewController * addToExistingPlaylist;
    UITableView * PlaylistNametable;
    UITableView * FilesSearchtable;
    UIPopoverController * SearchPopoverController;
    NSMutableArray *filteredArray;
    IBOutlet UIView * BackGroundView;
    MBProgressHUD *hud;
    UIActivityIndicatorView * activityIndicator;
    PresentationPaneViewController *pptPane;
    UINavigationController *docDetailNavController;
    UIViewController *docDetailController;
    BoxLoginViewController * vc;

}

@property (nonatomic,retain) NSDictionary *tableContents;
@property (nonatomic,retain) NSArray *sortedKeys;
@property (nonatomic, retain) NSMutableArray *tableSource;
@property (nonatomic, retain) Folder *currentFolder;
@property (nonatomic, retain) NSString *currentFolderpath;

@property (nonatomic, retain) IBOutlet UITableView * DocumentTable;
@property (retain, nonatomic) IBOutlet UISearchBar *filesSearchBar;
@property (retain, nonatomic)IBOutlet UIView * BackGroundView;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property (nonatomic, retain) IBOutlet UIButton *UserIcon;
@property (nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (retain, nonatomic)IBOutlet UIButton * Playlist1;
@property (weak, nonatomic) IBOutlet UITableView *fileRepositoriesTable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIToolbar *fileRepositoriesToolBar;

@property (nonatomic, strong) UITableView * PlaylistNametable;
@property (nonatomic, strong) UITableView * FilesSearchtable;
@property (retain, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic,  retain) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSMutableArray *fileRepositoriesArray;



- (IBAction)toggleButtonClicked:(id)sender;
-(IBAction)CreatePlaylistbtnSelected:(id)sender;
@end


