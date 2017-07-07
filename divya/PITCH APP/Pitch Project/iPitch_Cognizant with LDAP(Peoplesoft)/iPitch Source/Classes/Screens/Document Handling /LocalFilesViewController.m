//
//  CTSCategoryListViewController.m
//  CTSCacheDisplayController
//
//  Created by developer2 on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalFilesViewController.h"
//#import "PDFExampleViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PDFViewController.h"
#import "BoxDownloadOperation.h"
#import "Utils.h"

@interface LocalFilesViewController () {
    BoxFolder *__rootFolder;
    NSString *__folderID;
}

@property (nonatomic, readwrite, retain) NSString * folderID; //overriding readonly properties from .h file
@property (nonatomic, readwrite, retain) BoxFolder * rootFolder;

@end

@implementation LocalFilesViewController
@synthesize tblView;
@synthesize folderArray;
@synthesize isServerMode;
@synthesize filteredArray;
@synthesize managedObjectContext;

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)updateTitle{
    if (self.isServerMode) {
        self.title=@"Files cached in device";
    }
    else{
        
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)reloadWithArray:(NSMutableArray *)_contents{
    self.folderArray = _contents;
    //[tblView reloadData];
}


#pragma mark - View lifecycle


- (id)initWithFolderPath:(NSString*)Path
{
    self = [super init];
    if (self)
    {
        NSLog(@"paht: %@",Path);
        
        self.tableSource=[[NSMutableArray alloc]init];
        
        self.managedObjectContext=SAppDelegateObject.managedObjectContext;        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES];
        fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"File"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *fetchedObjects = [self.managedObjectContext
                                   executeFetchRequest:fetchRequest error:nil
                                   ];
        
        NSLog(@"fetchedObjects: %@",fetchedObjects);
        
        [self.tableSource addObjectsFromArray:fetchedObjects];
        
        //uncomment for displaying folders
        /*fetchRequest = [[NSFetchRequest alloc] init];
        sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES];
        fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];

        entity = [NSEntityDescription entityForName:@"File"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil
                                   ];

        [self.tableSource addObjectsFromArray:fetchedObjects];*/
        

        NSLog(@"self.tableSource:  %@",self.tableSource);
    }
    return self;
}


-(id)initWithBoxFolder:(NSString *)objectID
{
    self = [super init];
    if (self) {
        self.folderID=objectID;
        self.isServerMode=YES;
    
        self.tableSource=[[NSMutableArray alloc]init];
        
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.animationType=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Loading Files From Server...";

        BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            if ([self.folderID isEqualToString:@"0"]) {
            } else {
                self.title = folder.objectName;
            }
        
            self.rootFolder = folder;
            
            [self.tableSource addObjectsFromArray:self.rootFolder.objectsInFolder];
            
            
            [self.tblView reloadData];
            
            [hud hide:YES];
        } else {
            self.title = @"Error";
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
    if (self.folderID == nil) {
        NSLog(@"Error: FolderID must be set in BoxBrowserTableViewController");
    }
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:self.folderID onCompletion:block];

    }
    return self;
}

- (void)refreshTableViewSourceForCurrentServerPath {
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Loading Files From Server...";

    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
            if ([self.folderID isEqualToString:@"0"]) {
                self.title = @"Documents";
            } else {
                self.title = folder.objectName;
            }
            self.rootFolder = folder;
            
            
            NSMutableArray *tArray=[[NSMutableArray alloc]init];
            for (int i=0;i<[self.tableSource count]; i++) {
                if ([[self.tableSource objectAtIndex:i] isKindOfClass:[File class]]) {
                    [tArray addObject:[self.tableSource objectAtIndex:i]];
                }
            }
            
            [self.tableSource removeObjectsInArray:tArray];
            
            [self.tableSource addObjectsFromArray:self.rootFolder.objectsInFolder];
            
            [self.tableSource addObjectsFromArray:tArray];
            
            
            [self.tblView reloadData];
            
            [hud hide:YES];
            
        } else {
            self.title = @"Error";
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
        }
    };
    if (self.folderID == nil) {
        NSLog(@"Error: FolderID must be set in BoxBrowserTableViewController");
    }
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:self.folderID onCompletion:block];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!isServerMode)
    {
    if([self initWithFolderPath: [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]])
    {
        //do something here.
    }
    }
    self.folderArray = [NSMutableArray array];
    
    PlaylistArray = [[NSMutableArray alloc]init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"playlistName" ascending:YES];
    fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playlist"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [self.managedObjectContext
                               executeFetchRequest:fetchRequest error:nil
                               ];
    
    NSLog(@"fetchedObjects: %@",fetchedObjects);
    
    [PlaylistArray addObjectsFromArray:fetchedObjects];
    
    [self.filteredArray addObjectsFromArray: PlaylistArray];
    [self.tableSource addObjectsFromArray: PlaylistArray];
    
    self.contentSizeForViewInPopover=CGSizeMake(400, 500);
    
    /*UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem=doneButton;
    
    [doneButton release];*/
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"addActivityIndicatorView" object:self];
   // lblName.text = @"DropBox";

    
   // [self refreshTableViewSource];
    
    
}



-(void)BoxLogin
{
    self.view.userInteractionEnabled=YES;
    
    vc = [BoxLoginViewController loginViewControllerWithNavBar:YES];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self presentModalViewController:vc animated:YES];
    
    /*CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 325, 650, 500);
     r = [self.view convertRect:r toView:vc.view.superview.superview];
     vc.view.superview.frame = r;*/
    
    //[promptForDropBoxCredentials removeFromSuperview];
    
    
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    if(result==LoginSuccess)
    {
        //        BoxDownloadActionViewController * inputController = [[BoxDownloadActionViewController alloc] initWithFolderID:@"0"];
        //
        //        [viewTail buildBoxFolderListAfterLogin:inputController];
        
        [vc dismissModalViewControllerAnimated:YES];
        [self refreshTableViewSourceForCurrentServerPath];

        
    }
    
    
    if (result==LoginCancelled)
    {
        [vc dismissModalViewControllerAnimated:YES];
    }
    
    
    //  [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
    // [self refreshTableSourceForCurrentPathLocalPath];
    //[self refreshTableViewSourceForCurrentServerPath];
}

-(void)viewDidAppear:(BOOL)animated
{
    // NSLog(@"self.current path: %@",self.currentFolderpath);
    
    // self.title=[self.currentFolderpath lastPathComponent];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        BoxUser* userModel = [BoxUser savedUser];
        
        if(/*![self.dBHelper checkForSession:self]*//*for dropBox*/  /*||*/ !userModel/*for box*/)
        {
            // self.view.userInteractionEnabled=NO;
           [self performSelector:@selector(BoxLogin) withObject:nil afterDelay:0];
            
        }
        else
        {
        }

        self.folderID=@"0";
        
    }
    
    else
    {
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        
    {    return [self.filteredArray count];
    }
    
    else{
        return [self.tableSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
    if ([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[BoxObject class]])
        {
                        
            BoxObject* boxObject = (BoxObject*)[self.filteredArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text = boxObject.objectName;
            cell.detailTextLabel.text = boxObject.objectDescription;
            
            if ([boxObject isKindOfClass:[BoxFolder class]]) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                BoxFolder * folder = (BoxFolder*)boxObject;
                if(folder.isCollaborated) {
                    cell.imageView.image = [UIImage imageNamed:@"BoxCollabFolder"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon"];
                }
                if ([folder.fileCount intValue] == 1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file. %@", folder.objectDescription];
                } else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ files. %@", folder.fileCount, folder.objectDescription];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageView.image = [UIImage imageNamed:@"BoxDocumentIcon"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }

    else if([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[Folder class]])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        Folder *aFolder =[self.filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text = aFolder.folderName;
        if ([aFolder numberOfItemsInFolder] == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"empty folder."];
        }
        else if ([aFolder numberOfItemsInFolder] == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file."];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d files.", [aFolder numberOfItemsInFolder]];
        }        cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon"];
    }
    
    else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[Playlist class]])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        Playlist *aFolder =[self.tableSource objectAtIndex:indexPath.row];
        cell.textLabel.text = aFolder.playlistName;
        
        if ([aFolder.playListDocuments count] == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Empty Playlist."];
        }
        else if ([aFolder.playListDocuments count] == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file."];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d files.", [aFolder.playListDocuments count]];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"playlist1.png"];
    }

    else if([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[File class]])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        File *aFile = [self.filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text = aFile.fileName;
      //  if ([[aFile getFileType] isEqualToString:@"pdf"]) {
         //   cell.imageView.image = [UIImage imageNamed:@"pdf.png"];
        NSString *pathString=[NSString stringWithFormat:@"%@",aFile .filePath];

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                
                UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                     cell.imageView.image = pdfThumbNailImage;
                });
            });
            
   //     }
        
    //    else
     //   {
    //        cell.imageView.image = [UIImage imageNamed:@"BoxDocumentIcon.png"];
//        }
        
        /*   if ([[aFile getFileType] isEqualToString:@"pdf"]) {
         cell.imageView.image = [UIImage imageNamed:@"pdf.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"mp4"]){
         cell.imageView.image = [UIImage imageNamed:@"video.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"m4v"]){
         cell.imageView.image = [UIImage imageNamed:@"video.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"zip"]){
         cell.imageView.image = [UIImage imageNamed:@"HTML5.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"jpg"]){
         cell.imageView.image = [UIImage imageNamed:@"picture1.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"jpeg"]){
         cell.imageView.image = [UIImage imageNamed:@"picture1.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"png"]){
         cell.imageView.image = [UIImage imageNamed:@"picture1.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"doc"]){
         cell.imageView.image = [UIImage imageNamed:@"Word_doc.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"ppt"]){
         cell.imageView.image = [UIImage imageNamed:@"Pptx.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"xls"]){
         cell.imageView.image = [UIImage imageNamed:@"Excel.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"docx"]){
         cell.imageView.image = [UIImage imageNamed:@"Word_doc.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"pptx"]){
         cell.imageView.image = [UIImage imageNamed:@"Pptx.png"];
         
         }
         else if([[aFile getFileType] isEqualToString:@"xlsx"]){
         cell.imageView.image = [UIImage imageNamed:@"Excel.png"];
         
         }
         else
         {
         cell.imageView.image = [UIImage imageNamed:@"BoxDocumentIcon.png"];
         
         }*/
        
    }
    
    }
    
    else{
        
        if ([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[BoxObject class]])
        {
                    
            BoxObject* boxObject = (BoxObject*)[self.tableSource objectAtIndex:indexPath.row];
            
            cell.textLabel.text = boxObject.objectName;
            cell.detailTextLabel.text = boxObject.objectDescription;
            
            if ([boxObject isKindOfClass:[BoxFolder class]]) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                BoxFolder * folder = (BoxFolder*)boxObject;
                if(folder.isCollaborated) {
                    cell.imageView.image = [UIImage imageNamed:@"BoxCollabFolder"];
                } else {
                    cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon"];
                }
                if ([folder.fileCount intValue] == 1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file. %@", folder.objectDescription];
                } else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ files. %@", folder.fileCount, folder.objectDescription];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageView.image = [UIImage imageNamed:@"BoxDocumentIcon"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }
        
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[Folder class]])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            Folder *aFolder =[self.tableSource objectAtIndex:indexPath.row];
            cell.textLabel.text = aFolder.folderName;
            
            if ([aFolder numberOfItemsInFolder] == 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"empty folder."];
            }
            else if ([aFolder numberOfItemsInFolder] == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file."];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d files.", [aFolder numberOfItemsInFolder]];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon"];
        }
        
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[File class]])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            File *aFile = [self.tableSource objectAtIndex:indexPath.row];
            cell.textLabel.text = aFile.fileName;
      //      if ([[aFile getFileType] isEqualToString:@"pdf"]) {
              
                cell.imageView.image = [UIImage imageNamed:@"pdf.png"];
            
                NSString *pathString=[NSString stringWithFormat:@"%@",aFile .filePath];
 
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                
                dispatch_async(queue, ^{
                    
                    UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        cell.imageView.image = pdfThumbNailImage;
                    });
                });
                
       /*     }
            
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"BoxDocumentIcon.png"];
                
            }   */

            
        }            
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[Playlist class]])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            Playlist *aFolder =[self.tableSource objectAtIndex:indexPath.row];
            cell.textLabel.text = aFolder.playlistName;
            
            if ([aFolder.playListDocuments count] == 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Empty Playlist."];
            }
            else if ([aFolder.playListDocuments count] == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"1 file."];
            }
            else {
               cell.detailTextLabel.text = [NSString stringWithFormat:@"%d files.", [aFolder.playListDocuments count]];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"playlist1.png"];
        }
        
        
    }
    // Configure the cell...
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tView=[[UIView alloc]init] ;
    return tView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        
    {
        
        if ([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[BoxObject class ]])
        {
            BoxObject * boxObject = ((BoxObject*)[self.filteredArray objectAtIndex:indexPath.row]);
            if ([boxObject isKindOfClass:[BoxFolder class]]) {
                LocalFilesViewController *f=[[LocalFilesViewController alloc]initWithBoxFolder:boxObject.objectId];
                f.title =boxObject.objectName;
                
                [self.navigationController pushViewController:f animated:YES];
                if (self.navigationController == nil) {
                    NSLog(@"Error: BoxBrowserTableViewController should be in a UINavigationViewController to work properly.");
                }
            }
            
            
            else
            {
                
                //Download File and then make a File Object and pass it as notificaiton object.
                
                //[[NSNotificationCenter defaultCenter ]postNotificationName:@"FilesAddedToEvent" object:boxObject ];
            }
            
        }

        else if([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[Folder class]])
        {
            Folder *selectedFolder = [self.filteredArray objectAtIndex:indexPath.row];
            
            LocalFilesViewController *f=[[LocalFilesViewController alloc]initWithFolderPath: selectedFolder.folderPath];
            f.title =[selectedFolder.folderPath lastPathComponent];
            
            [self.navigationController pushViewController:f animated:YES];
            
            
        }
        
        else if([[self.filteredArray objectAtIndex:indexPath.row] isKindOfClass:[File class]])
        {
                        
            if ( [tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryCheckmark) {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
            }
            
            else
                [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
            
            
            //generate fileselectednotifications
            
            NSManagedObjectID *customerID=((File *)[self.tableSource objectAtIndex:indexPath.row]).objectID ;
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"FilesAddedToEvent" object: customerID];

        }
        
        
      
    }
    
    else{
        
        
        if ([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[BoxObject class ]])
        {
            BoxObject * boxObject = ((BoxObject*)[self.tableSource objectAtIndex:indexPath.row]);
            if ([boxObject isKindOfClass:[BoxFolder class]]) {
                LocalFilesViewController *f=[[LocalFilesViewController alloc]initWithBoxFolder:boxObject.objectId];
                f.title =boxObject.objectName;
        
                [self.navigationController pushViewController:f animated:YES];
                if (self.navigationController == nil) {
                    NSLog(@"Error: BoxBrowserTableViewController should be in a UINavigationViewController to work properly.");
                }
        }
            
            
            else
            {
                
             //Download File and then make a File Object and pass it as notificaiton object.
                
                hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode =MBProgressHUDModeAnnularDeterminate;
                hud.labelText=@"Downloading File From Server...";
             
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:boxObject.objectId toPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,boxObject.objectName]];
                [op setProgressHandler:^(BoxOperation *op, NSNumber *completionRatio) {
                    NSLog(@"got completion ratio %@ for op %@", completionRatio, op);
                    hud.progress=[completionRatio floatValue];
                }];
                [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                    NSLog(@"download completed with response %d", response);
                    [hud hide:YES];
                    
                    
                    
                    NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
                    
                    File *fileObject=[NSEntityDescription
                                          insertNewObjectForEntityForName:@"File"
                                          inManagedObjectContext:context];
                        
                    fileObject.fileName=boxObject.objectName;
                    fileObject.filePath=[NSString stringWithFormat:@"%@/%@",documentsDirectory,boxObject.objectName];
                        
                        NSError *error=nil;
                        
                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save Folders %@", [error localizedDescription]);
                        }

                    [[NSNotificationCenter defaultCenter ]postNotificationName:@"FilesAddedToEvent" object:fileObject.objectID];
                }];

            }

        }
        
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[Folder class]])
        {
            Folder *selectedFolder = [self.tableSource objectAtIndex:indexPath.row];
            
            LocalFilesViewController *f=[[LocalFilesViewController alloc]initWithFolderPath:[NSString stringWithFormat:@"%@/%@",  selectedFolder.folderPath,selectedFolder.folderName]];
            f.title =[selectedFolder.folderPath lastPathComponent];
            [self.navigationController pushViewController:f animated:YES];
            //  [SAppDelegateObject.viewController.stackVC popViewControllerAnimated:YES];
            
        }
        
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[Playlist class]])
        {
            NSManagedObjectID *playlistID=((Playlist *)[self.tableSource objectAtIndex:indexPath.row]).objectID ;
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"PlaylistFilesAddedToEvent" object:playlistID];
        }
        
        else if([[self.tableSource objectAtIndex:indexPath.row] isKindOfClass:[File class]])
        {
            if ( [tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryCheckmark)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
                //  [navForFileBrowser popToRootViewControllerAnimated:YES];
               // [SAppDelegateObject.viewController.stackVC popViewControllerAnimated:YES];
            }
            else
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
            }
            
            NSManagedObjectID *fileID=((File *)[self.tableSource objectAtIndex:indexPath.row]).objectID ;
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"FilesAddedToEvent" object: fileID];
            
        }
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dismissModalVC
{
    [VC dismissModalViewControllerAnimated:YES];
}


-(void)pop
{
    [SAppDelegateObject.viewController.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[filteredArray removeAllObjects];
    
	// Filter the array using NSPredicate
  //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",searchText];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    for (int i=0; i<[self.tableSource count]; i++) {
        
        if([[self.tableSource objectAtIndex:i] isKindOfClass:[BoxObject class]])
            
        {
            BoxObject *bObject = [self.tableSource objectAtIndex:i];
            if ([self string:bObject.objectName containsString:searchText]) {
                [tempArray addObject:bObject];
            }

        }
        
        else if([[self.tableSource objectAtIndex:i] isKindOfClass:[Folder class]])
        {
            Folder *folderObject = [self.tableSource objectAtIndex:i];
            if ([self string:folderObject.folderName containsString:searchText]) {
                [tempArray addObject:folderObject];
            }
            
        }
        
        else if([[self.tableSource objectAtIndex:i] isKindOfClass:[File class]])
            {                
                File *fileObject=[self.tableSource objectAtIndex:i];
                if ([self string:fileObject.fileName containsString:searchText]) {
                    [tempArray addObject:fileObject];
                }
            }
        
        
        
    }
        
    filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];

    
}

- (BOOL) string :(NSString *)string containsString: (NSString*) substring
{
    NSRange range = [ [string lowercaseString]  rangeOfString : [substring lowercaseString]];
    BOOL found = ( range.location != NSNotFound );
    return found;
}
@end
