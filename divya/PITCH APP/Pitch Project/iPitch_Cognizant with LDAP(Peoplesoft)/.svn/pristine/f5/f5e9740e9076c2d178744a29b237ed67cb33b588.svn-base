//
//  BoxBrowseGridViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 4/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "BoxBrowseGridViewController.h"
#import "BoxFolder.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"
#import "DocumentTileView.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "BoxDownloadOperation.h"
#import "File.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "BoxUser.h"
#import "iPitchConstants.h"
#import "ThemeHelper.h"


#define GRID_ELEMENT_WIDTH 120
#define GRID_ELEMENT_HEIGHT 150
#define FOLDER_ICON @"server_folder.png"
#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface BoxBrowseGridViewController ()
{
    BoxFolder *__rootFolder;
    NSString *__folderID;
    UIScrollView *boxGridView;
    MBProgressHUD *hud;
}

@property (nonatomic, readwrite, retain) NSString * folderID; //overriding readonly properties from .h file
@property (nonatomic, readwrite, retain) BoxFolder * rootFolder;

@end

@implementation BoxBrowseGridViewController

@synthesize folderID = __folderID, rootFolder = __rootFolder;

- (id)initWithFolderID:(NSString*)folderID {
    self = [super init];
    if (self) {
        self.folderID = folderID;
    }
    return self;
}

- (id)init {
    return [self initWithFolderID:@"0"]; //Default value
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Loading...";
    boxGridView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 740, 650)];
    boxGridView.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boxGridView];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshBoxContentsSource];
    [ThemeHelper applyCurrentThemeToView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    __rootFolder = nil;
    __folderID = nil;
}

#pragma mark - Table view data source

- (void)refreshBoxContentsSource
{
    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        
        [hud hide:YES];
        
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            if ([self.folderID isEqualToString:@"0"]) {
                self.title = @"Root Folder";
            } else {
                self.title = folder.objectName;
            }
            self.rootFolder = folder;
            [self loadBoxFilesGridView];
        }
        
        else if(response==boxFolderDownloadResponseTypeFolderNotLoggedIn
                ) {
            [self presenBoxLoginForm];
        }
        
        else {
            self.title = @"Error";
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    };
    if (self.folderID == nil) {
        NSLog(@"Error: FolderID must be set in BoxBrowserGridViewController");
    }
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode =MBProgressHUDModeIndeterminate;
    hud.labelText=@"Loading Files From Box...";

    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:self.folderID onCompletion:block];
}

-(void)loadBoxFilesGridView
{
        
        CGFloat contentSize=200;
        
        for(UIView *tView in boxGridView.subviews)
        {
            if (![tView isKindOfClass:[UIImageView class]]) {
                [tView removeFromSuperview];
            }
        }
        
        int row = 0;
        int column = 0;
        
        boxGridView.showsHorizontalScrollIndicator=YES;
        
        if(self.rootFolder.objectsInFolder && [self.rootFolder.objectsInFolder count]>0)
        for(int i = 0; i < [self.rootFolder.objectsInFolder count]; ++i)
        {
            DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(column*180+30, row*180+25, GRID_ELEMENT_WIDTH, GRID_ELEMENT_HEIGHT)];
            innerView.backgroundColor=[UIColor clearColor];
            
            UIButton *dummyBtn = [[UIButton alloc]init];
            dummyBtn.frame = CGRectMake(0,0, GRID_ELEMENT_WIDTH, GRID_ELEMENT_HEIGHT);
            dummyBtn.tag = i;
            
            BoxObject* boxObject = (BoxObject*)[self.rootFolder.objectsInFolder objectAtIndex:i];

            innerView.docNameLabel.text= boxObject.objectName;
            
            
            if ([boxObject isKindOfClass:[BoxFolder class]]) {
                
                BoxFolder * folder = (BoxFolder*)boxObject;

                if(folder.isCollaborated) {
                    innerView.docIcon.image = [UIImage imageNamed:@"BoxCollabFolder"];
                } else {
                    innerView.docIcon.image = [UIImage imageNamed:FOLDER_ICON];
                }
                
                if ([folder.fileCount intValue] == 1) {
                    innerView.docModifiedDateLabel.text = [NSString stringWithFormat:@"1 file. %@", folder.objectDescription];
                } else {
                    innerView.docModifiedDateLabel.text = [NSString stringWithFormat:@"%@ files. %@", folder.fileCount, folder.objectDescription];
                }
            }
            else
            {
                BoxFile *file=(BoxFile*)boxObject;
                [innerView.docIcon setImageURL:[NSURL URLWithString:file.largeThumbnailURL]];
                innerView.docModifiedDateLabel.text=[NSString stringWithFormat:@"%@", boxObject.objectUpdatedTime];
            }
            
            [dummyBtn setBackgroundColor:[UIColor clearColor]];
            [dummyBtn addTarget:self action:@selector(boxFolderClicked:)forControlEvents:UIControlEventTouchUpInside];
            
            // UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            // [dummyBtn addGestureRecognizer:longPress];
            
            [innerView addSubview:dummyBtn];
                        
            if (column == 3)
            {
                column = 0;
                row++;
                contentSize=contentSize+220;
                [boxGridView setContentSize:CGSizeMake(0, contentSize)];
                
            } else {
                column++;
            }
            
            [boxGridView addSubview:innerView];
            
        }
        

}

- (void)boxFolderClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    BoxObject * boxObject = ((BoxObject*)[self.rootFolder.objectsInFolder objectAtIndex:btn.tag]);
    if ([boxObject isKindOfClass:[BoxFolder class]]) {
        BoxBrowseGridViewController * browserTableViewController = [[[self class] alloc] initWithFolderID:boxObject.objectId] ; //Using [self class] ensures that if this class is subclassed, it pushes the correct kind of BoxBrowserTableViewController
        if (self.navigationController == nil) {
            NSLog(@"Error: BoxBrowserTableViewController should be in a UINavigationViewController to work properly.");
        }
        [self.navigationController pushViewController:browserTableViewController animated:YES];
    }
    
    else
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode =MBProgressHUDModeAnnularDeterminate;
        hud.labelText=@"Downloading File From Server...";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *pathToSave=[NSString stringWithFormat:@"%@/%@",documentsDirectory,boxObject.objectName];
        
        NSLog(@"path to save: %@",pathToSave);
        
        BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:boxObject.objectId toPath:pathToSave];
        [op setProgressHandler:^(BoxOperation *op, NSNumber *completionRatio) {
            NSLog(@"got completion ratio %@ for op %@", completionRatio, op);
            hud.progress=[completionRatio floatValue];
        }];
        [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
            NSLog(@"download completed with response %d", response);
            [hud hide:YES];

            if (response==BoxOperationResponseSuccessful) {
                        
            /*NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
            
            File *fileObject=[NSEntityDescription
                              insertNewObjectForEntityForName:@"File"
                              inManagedObjectContext:context];
            
            fileObject.fileName=boxObject.objectName;
            fileObject.filePath=pathToSave;
            
            NSError *error=nil;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Files %@", [error localizedDescription]);
            }*/
                
                hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [hud hide:YES afterDelay:HUD_ALERT_TIMING];
                hud.mode =MBProgressHUDModeText;
                hud.labelText= @"File Downloaded Successfully!!";

            }
            
        }];
        
    }
    
    
}

- (void)presenBoxLoginForm
{
    vc = [BoxLoginViewController loginViewControllerWithNavBar:YES];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self presentModalViewController:vc animated:YES];
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    if(result==LoginSuccess)
    {
        [vc dismissModalViewControllerAnimated:YES];
        [self refreshBoxContentsSource];
        
    }
    
    
    if (result==LoginCancelled)
    {
        [vc dismissModalViewControllerAnimated:YES];
    }
    
}

@end
