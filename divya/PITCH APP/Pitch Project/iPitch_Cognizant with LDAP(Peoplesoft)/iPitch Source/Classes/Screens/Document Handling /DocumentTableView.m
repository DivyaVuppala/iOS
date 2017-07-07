//
//  DocumentTableView.m
//  iPitch V2
//
//  Created by Sandhya Sandala on 12/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "DocumentTableView.h"
#import "DocumentTileView.h"
#import "ModelTrackingClass.h"
#import "PDFViewController.h"
#import "AppDelegate.h"
#import "Playlist.h"
#import "LoginViewController.h"
#import "LandscapeViewController.h"
#import "SWRevealViewController.h"
#import "QuartzCore/CALayer.h"
#import "iPitchConstants.h"
#import "PlayListContentsViewController.h"
#import "Utils.h"
#import "iPitchAnalytics.h"
#import "AsyncImageView.h"
#import "BoxDownloadOperation.h"
#import "BoxBrowseGridViewController.h"
#import "DropBoxGridBrowserViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "ZipArchive.h"

#import "BoxFolder.h"
#import "BoxFile.h"
#import "BoxNetworkOperationManager.h"
#import "BoxUser.h"
#import "XMLParser.h"
#import "ProductDetailViewController.h"
#import "ThemeHelper.h"
#import "ProductCategoryViewController.h"

@interface DocumentTableView ()
{
    NSInteger expandedRowIndex;
    NSDictionary *onlineFileRepositories;
    BOOL rowExpanded;
    NSMutableArray *boxFolderProdcutsArray;
    NSMutableArray *boxProductsListArray;
    NSMutableArray *repositoryIconsArray;
    int currentSelection;
    UIActionSheet *fileOperationsActionSheet;
    UIActionSheet *playlistOperationsActionSheet;


}
@property (nonatomic,  retain) NSString * folderID;
@property (nonatomic,  retain) BoxFolder * rootFolder;
@property (nonatomic,  retain) NSMutableArray *boxContentsArray;
@property (nonatomic,  retain) CTSDropBoxHelper *dbHelper;
@end

@implementation DocumentTableView

@synthesize tableContents;
@synthesize sortedKeys, currentFolder,tableSource, filesSearchBar, FilesSearchtable, PlaylistNametable, filteredArray, buttonToggle, BackGroundView,toolBarView;
@synthesize managedObjectContext, Searchbtn, UserIcon, NotificationIcon, horizontalLine;
@synthesize fileRepositoriesArray,fileRepositoriesTable,fileRepositoriesToolBar;
@synthesize folderID,rootFolder,boxContentsArray,dbHelper;

#define RECENTLY_ADDED_SECTION 0
#define MOSTLY_VIEWED_SECTION 1
#define MY_PLAYLIST_SECTION 2

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#pragma mark View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



int itemPRessed=-1;
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    expandedRowIndex = -1;

    self.titleLabel.text=NSLocalizedString(@"PRODUCTS", @"Products");
    [self.Playlist1 setTitle:NSLocalizedString(@"CREATE_PLAYLIST", @"Create Playlist") forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
    }
    
    
    self.managedObjectContext=SAppDelegateObject.managedObjectContext;
    
    
    PlaylistArray = [[ NSMutableArray alloc] init];
    
    self.tableSource=[[NSMutableArray alloc]init];
    
    [self refreshLocalFiles];
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
    [BackGroundView.layer setCornerRadius:5];
    
    [[filesSearchBar.subviews objectAtIndex:0] removeFromSuperview];

    [self.fileRepositoriesTable.layer setCornerRadius:5];
    
    [self.fileRepositoriesToolBar.layer setCornerRadius:5];
    [self.fileRepositoriesToolBar.layer setMasksToBounds:YES];

    [self.view bringSubviewToFront:self.fileRepositoriesTable];
    
    self.fileRepositoriesArray=[[NSMutableArray alloc]initWithObjects:@"Products",@"Offline Assets",@"Playlists",nil];
    
    repositoryIconsArray=[[NSMutableArray alloc]initWithObjects:@"Server",@"Local",@"Product", nil];
    
    boxFolderProdcutsArray=[[NSMutableArray alloc]init];

    
    NSString *boxConnectionStatus=@"";
    boxConnectionStatus=@"Not Connected";
    
    if ([BoxLoginViewController currentUser])
    {
        boxConnectionStatus=[BoxLoginViewController currentUser].userName;
        
    }
    
    
    NSString *dropboxConnectionStatus=@"";
    dropboxConnectionStatus=@"Not Connected";
    
    if ([Utils userDefaultsGetObjectForKey:DROPBOXUSERNAME])
    {
        dropboxConnectionStatus=[Utils userDefaultsGetObjectForKey:DROPBOXUSERNAME];
        
    }
    onlineFileRepositories=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:boxConnectionStatus,dropboxConnectionStatus, nil] forKeys:[NSArray arrayWithObjects:@"Box",@"Dropbox", nil]];
    
    docDetailController=[[UIViewController alloc]init];
    docDetailController.title=@"Local";
    docDetailController.view.frame=CGRectMake(250, 80, 740, 650);
    [docDetailController.view.layer setCornerRadius:5];
    
    DocumentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 740, 650)];
    DocumentScrollView.backgroundColor=[UIColor whiteColor];
    [DocumentScrollView.layer setCornerRadius:5];
    [DocumentScrollView.layer setMasksToBounds:YES];

    [docDetailController.view addSubview:DocumentScrollView];
    
    docDetailNavController=[[UINavigationController alloc]initWithRootViewController:docDetailController];
    docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
    [docDetailNavController.view.layer setCornerRadius:5];
    [docDetailNavController.view.layer setMasksToBounds:YES];

    
    [self.view addSubview:docDetailNavController.view];
    
    self.boxContentsArray =[[NSMutableArray alloc]init];
    
    currentSelection=1;
    [self.fileRepositoriesTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    rowExpanded=NO;
    
    self.dbHelper=[[CTSDropBoxHelper alloc]init];
    self.dbHelper.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dropBoxLinkedSuccesfullyForFirstTime) name:kDropBoxLinkedSuccessfullyNotification object:nil];
    
    
    [self.dbHelper loadAccountInfo];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    [ThemeHelper applyCurrentThemeToView];
}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setFileRepositoriesTable:nil];
    [self setFileRepositoriesToolBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Screen" withAction:@"Search Document Clicked" withLabel:nil withValue:nil];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    
    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];

     SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
 
    [SearchPopoverController presentPopoverFromRect:filesSearchBar.frame inView:self.BackGroundView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    FilesSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    FilesSearchtable.tag = 4;
    FilesSearchtable.dataSource=self;
    FilesSearchtable.delegate=self;
    [popoverContent.view addSubview:FilesSearchtable];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchBar.text];
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
        
        if([[self.tableSource objectAtIndex:i] isKindOfClass:[Folder class]])
        {
            Folder *selectedFolder = [self.tableSource objectAtIndex:i];
            if ([self string:selectedFolder.folderName containsString:searchText]) {
                [tempArray addObject:selectedFolder];
            }
            
        }
        else
        {                
            File *selectedFile=[self.tableSource objectAtIndex:i];
            if ([self string:selectedFile.fileName containsString:searchText]) {
                [tempArray addObject:selectedFile];
            }
        }
        
    }
    
    filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];
    NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"fileName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [ filteredArray sortUsingDescriptors:[NSArray arrayWithObject:alphaDesc]];	
    alphaDesc = nil;
    NSLog(@"filteredArray: %@", filteredArray);
    
    [FilesSearchtable reloadData];
    
    
}

- (BOOL) string :(NSString *)string containsString: (NSString*) substring
{
    NSRange range = [ [string lowercaseString]  rangeOfString : [substring lowercaseString]];
    BOOL found = ( range.location != NSNotFound );
    return found;
}


#pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       
    if (tableView.tag == 2){
            
        return 50;

    }
    else {
        return 60;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    
    if (table.tag ==2)
    {
        return  [self.fileRepositoriesArray count] + (expandedRowIndex != -1 ? [boxFolderProdcutsArray count] : 0);
    }
    else if(table.tag==3) {
        
        return [PlaylistArray count];
        
    }
    else if (table.tag ==4) {
        return [filteredArray count] ;
    }
	
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   if(tableView.tag==2) {
       
       tableView.separatorColor=[UIColor clearColor];
       
       /* NSInteger row = [indexPath row];
        
        BOOL expandedCell = expandedRowIndex != -1 && (row>expandedRowIndex && row<=[boxFolderProdcutsArray count]);
        
    
        if (!expandedCell)
        {*/
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"data"];
       
            cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_Unselected.png",[repositoryIconsArray objectAtIndex:indexPath.row]]];

            [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
            [cell.textLabel setTextAlignment:UITextAlignmentLeft];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
            if(indexPath.row < [self.fileRepositoriesArray  count])
            cell.textLabel.text= [self.fileRepositoriesArray objectAtIndex:indexPath.row];
       
       UIView *unselectedView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LP_gradient_unselect.png"]];
       
       UIView *selectedView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LP_gradient_select.png"]];

       cell.selectedBackgroundView=selectedView;
       cell.backgroundView=unselectedView;
       
            return cell;
        //}
       
        /*else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expanded"];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"expanded"];
            
        
            [cell.imageView.layer setMasksToBounds:YES];
            [cell.imageView.layer setCornerRadius:6];
            
            [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
            cell.textLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
            
//            if(indexPath.row%2==0)
//            cell.imageView.image=[UIImage imageNamed:@"BoxTopBarLogo.png"];
//            else
//            cell.imageView.image=[UIImage imageNamed:@"dropbox.png"];
//            
//            cell.textLabel.text= [[onlineFileRepositories allKeys]objectAtIndex:indexPath.row -2];
//            cell.detailTextLabel.text = [onlineFileRepositories objectForKey:  [[onlineFileRepositories allKeys]objectAtIndex:indexPath.row -2]];
        
            if (indexPath.row==0)
            cell.textLabel.text= ((BoxObject *) [boxFolderProdcutsArray objectAtIndex:indexPath.row]).objectName;
            else
                cell.textLabel.text= ((BoxObject *) [boxFolderProdcutsArray objectAtIndex:indexPath.row -1]).objectName;

            return cell;
        }*/
            
    }

   else if(tableView.tag==3) {
       
       static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
       
       UITableViewCell * cell = [tableView 
                                 dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
       
       if(cell == nil) {
           
           cell = [[UITableViewCell alloc] 
                   initWithStyle:UITableViewCellStyleDefault 
                   reuseIdentifier:SimpleTableIdentifier];
       }
       
       else
       {
           for (UIView *subview in cell.contentView.subviews)
               [subview removeFromSuperview];
       }
       
       
       Playlist *playlst=[PlaylistArray objectAtIndex:indexPath.row];
       cell.imageView.image = [UIImage imageNamed:@"playlist1.png"];
       cell.textLabel.text= playlst.playlistName;
       
       cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:14];

      if ([playlst.playListDocuments containsObject:[self.tableSource objectAtIndex:tButton.tag]])
       {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
       }
       
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
       
   }
    
    
   else if(tableView.tag==4) {
       
       static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
       
       UITableViewCell * cell = [tableView 
                                 dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
       
       if(cell == nil) {
           
           cell = [[UITableViewCell alloc] 
                   initWithStyle:UITableViewCellStyleDefault 
                   reuseIdentifier:SimpleTableIdentifier];
           
       }
       
       else
           
       {
           for (UIView *subview in cell.contentView.subviews)
               [subview removeFromSuperview];
       }
       
       
       cell.textLabel.text= ((File *)[filteredArray objectAtIndex:indexPath.row]).fileName ;

       NSString *pathString=[NSString stringWithFormat:@"%@/%@",((File *)[filteredArray objectAtIndex:indexPath.row]).filePath,((File *)[filteredArray objectAtIndex:indexPath.row]).fileName];

       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
       
       dispatch_async(queue, ^{
           
           UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
           
           dispatch_sync(dispatch_get_main_queue(), ^{
               
               cell.imageView.image = pdfThumbNailImage;
           });
       });
       return cell;
   }

    return nil;
}



#pragma mark TableView Delegate Methods


/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if(row ==0)
    {
    BOOL preventReopen = NO;
    
    if ((row == expandedRowIndex + [boxFolderProdcutsArray count])&& expandedRowIndex != -1)
        return indexPath;
    
    [tableView beginUpdates];
    
    if (expandedRowIndex != -1)
    {
        
        NSInteger rowToRemove = expandedRowIndex + 1;
        
        preventReopen = (row == expandedRowIndex );
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        for (int i=0; i<[boxFolderProdcutsArray count]; i++) {
          [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowToRemove inSection:0],nil]  withRowAnimation:UITableViewRowAnimationTop];
            rowToRemove+=1;
            
        }
       
        rowExpanded=NO;
    }
   // NSInteger rowToAdd = -1;
    if (!preventReopen)
    {
       // rowToAdd = row + 1;
        expandedRowIndex = row;
        [boxFolderProdcutsArray removeAllObjects];
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UIActivityIndicatorView *loading=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loading startAnimating];
        [loading hidesWhenStopped];
        cell.accessoryView=loading;
        
        [self performSelectorInBackground:@selector(getRootFolderListFromBox) withObject:nil];
               
        rowExpanded=YES;
    }
    [tableView endUpdates];
    }
    return indexPath;
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag ==3)
    {
        if ( [tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
            Playlist *playlst=(Playlist *)[self.managedObjectContext objectWithID:((Playlist *)  [PlaylistArray objectAtIndex:indexPath.row]).objectID];
            [playlst removePlayListDocumentsObject:[self.tableSource objectAtIndex:tButton.tag]];

            // [[playlst.playListDocuments allObjects] removeObject:[self.tableSource objectAtIndex:tButton.tag]];
            

        }
        
        else
        {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        Playlist *playlst=(Playlist *)[self.managedObjectContext objectWithID:((Playlist *)  [PlaylistArray objectAtIndex:indexPath.row]).objectID];
            
            [playlst addPlayListDocumentsObject:[self.tableSource objectAtIndex:tButton.tag]];
            
       // [[playlst.playListDocuments allObjects] addObject:[self.tableSource objectAtIndex:tButton.tag]];
     
        }

        NSError *error;
        if (![self.managedObjectContext save: &error])
        {
            NSLog(@"Sorry could not save playlist");
        }
        
    }
    else if (tableView.tag == 4) {
        
        [SearchPopoverController dismissPopoverAnimated:YES];
        File *selectedFile = [filteredArray objectAtIndex:indexPath.row];
        if ([[selectedFile getFileType] isEqualToString:@"pdf"]) {
            
            PDFViewController *viewController = [[PDFViewController alloc] initWithPDFFile:selectedFile.fileName];
            
            [self.navigationController pushViewController:viewController animated:YES];
         [self.navigationController setNavigationBarHidden:NO];
        }
       
        else
        {
            
            if([[selectedFile.fileName lastPathComponent] isEqualToString:@"zip"] )
            {
                [self unzipFileAt:selectedFile.filePath toPath:NSTemporaryDirectory()];

                NSString *htmlFilePath = [self temporaryDirectoryWithPath:[[selectedFile.filePath lastPathComponent]stringByDeletingPathExtension]];
                [pptPane.presentationView.hTML5Container loadHTMLFileAtPath:htmlFilePath WithType:@"html"];
            }
            
            else
            {
                [pptPane.presentationView.hTML5Container loadHTMLFileAtPath:selectedFile.filePath WithType:selectedFile.getFileType];
                
            }

        }
    
    }
    
    else if(tableView.tag==2)
    {
        
        UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        
        selectedCell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_Unselected.png",[repositoryIconsArray objectAtIndex:indexPath.row]]];
                
        docDetailController.navigationItem.rightBarButtonItem=nil;

        currentSelection = indexPath.row;
        
       if(indexPath.row==0)
        {
            //bring in products and catrgories screen here.
            //local files.
            [docDetailNavController.view removeFromSuperview];
            docDetailNavController=nil;
            
            ProductCategoryViewController *prodcutDetailVC=[[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
            prodcutDetailVC.title=@"Product Categories";
            
            docDetailNavController=[[UINavigationController alloc]initWithRootViewController:prodcutDetailVC];
            docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
            
            UILabel *categoriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            [categoriesLabel setFont:[UIFont fontWithName:FONT_REGULAR size:14.0f]];
            [categoriesLabel setText:@"Categories"];
            [categoriesLabel setTextAlignment:NSTextAlignmentLeft];
            [categoriesLabel setTextColor:[Utils colorFromHexString:ORANGE_COLOR_CODE_1]];
           
            UIBarButtonItem *categoriesButton=[[UIBarButtonItem alloc]initWithTitle:@"Categories" style:UIBarButtonItemStylePlain target:self action:nil];
           
            docDetailNavController.navigationItem.rightBarButtonItem=categoriesButton;
            
            [docDetailNavController.view.layer setCornerRadius:5];
            [self.view addSubview:docDetailNavController.view];
        }
        
       /*if(rowExpanded)
       {
        
        
            if(indexPath.row==[boxFolderProdcutsArray count] +1)
           {
                //local files.
               [docDetailNavController.view removeFromSuperview];
               docDetailNavController=nil;
               
               docDetailNavController=[[UINavigationController alloc]initWithRootViewController:docDetailController];
               docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
               [docDetailNavController.view.layer setCornerRadius:5];
               [self.view addSubview:docDetailNavController.view];
               
               docDetailController.title=@"Local";
               [SAppDelegateObject updateFilesInDocumentsDirectory];
               [self refreshLocalFiles];
               [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
               
               return;
               
           }
           
           else if (indexPath.row==[boxFolderProdcutsArray count] +2)
           {
               //playlist files.
               [docDetailNavController.view removeFromSuperview];
               docDetailNavController=nil;
               
               docDetailNavController=[[UINavigationController alloc]initWithRootViewController:docDetailController];
               docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
               [docDetailNavController.view.layer setCornerRadius:5];
               
               UIBarButtonItem * addPlayListButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(CreatePlaylistbtnSelected:)];
               [ThemeHelper applyCurrentThemeToView];
               
               docDetailController.navigationItem.rightBarButtonItem=addPlayListButton;
               
               [self.view addSubview:docDetailNavController.view];
               docDetailController.title=@"Playlists";
               [self refreshLocalFiles];
               [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
               
               return;
               
           }
           
           else if(indexPath.row < ([boxFolderProdcutsArray count]+1) && indexPath.row >0 )
           {
               hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.animationType=MBProgressHUDModeIndeterminate;
               hud.labelText=@"Loading Product Collaterals From Server...";
               
               Product *selectedProduct;
               
               for(Product *productObject in boxProductsListArray)
               {
                   if([productObject.PRODUCT_NAME isEqualToString:((BoxObject *)[boxFolderProdcutsArray objectAtIndex:indexPath.row-1]).objectName])
                   {
                       selectedProduct=productObject;
                   }
               }
               
                                 
                   NSMutableArray *productCollaterals=[[NSMutableArray alloc]init];
                   
                   BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
                       
                       if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
                           
                           NSString *productIconId=@"";
                           for(BoxObject *boxObject in folder.objectsInFolder)
                           {
                               if(![boxObject.objectName isEqualToString:@"ProductIcon.png"])
                               {
                                   [productCollaterals addObject:boxObject];
                               }
                               
                               else
                               {
                                   productIconId=boxObject.objectId;
                               }
                               
                           }
                           
                           selectedProduct.productCollaterals=productCollaterals;
                           
                           BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:productIconId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",productIconId]]];
                           
                           [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                               NSLog(@"download completed with response %d", response);
                               
                               if(response == BoxOperationResponseSuccessful
                                  ) {
                                   selectedProduct.productIcon=[UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",productIconId]]];
                               }
                               [docDetailNavController.view removeFromSuperview];
                               docDetailNavController=nil;
                               
                               ProductDetailViewController *prodcutDetailVC=[[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
                               prodcutDetailVC.productObject=selectedProduct;
                               docDetailNavController=[[UINavigationController alloc]initWithRootViewController:prodcutDetailVC];
                               docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
                               [docDetailNavController.view.layer setCornerRadius:5];
                               [self.view addSubview:docDetailNavController.view];
                               
                               [hud hide:YES];
                           }];
                                                      
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
                       //NSLog(@"Error: FolderID must be set in BoxBrowserGridViewController");
                   }
                   
                   
                   [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID: ((BoxObject *)[boxFolderProdcutsArray objectAtIndex:indexPath.row-1]).objectId onCompletion:block];
                   
                   
               }
        
        }*/
        
        /*else
        {*/
            
            if (indexPath.row==2)
            {
                //playlist files.
                [docDetailNavController.view removeFromSuperview];
                docDetailNavController=nil;
                
                docDetailNavController=[[UINavigationController alloc]initWithRootViewController:docDetailController];
                docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
                [docDetailNavController.view.layer setCornerRadius:5];
                
                UIBarButtonItem * addPlayListButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(CreatePlaylistbtnSelected:)];
                [ThemeHelper applyCurrentThemeToView];

                docDetailController.navigationItem.rightBarButtonItem=addPlayListButton;
                [self.view addSubview:docDetailNavController.view];
                docDetailController.title=@"Playlists";
                [self refreshLocalFiles];
                [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                
            }
            
            if(indexPath.row==1)
            {
                //local files.
                [docDetailNavController.view removeFromSuperview];
                 docDetailNavController=nil;
                 
                 docDetailNavController=[[UINavigationController alloc]initWithRootViewController:docDetailController];
                 docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
                 [docDetailNavController.view.layer setCornerRadius:5];
                 [self.view addSubview:docDetailNavController.view];
                 
                 docDetailController.title=@"Local";
                 [SAppDelegateObject updateFilesInDocumentsDirectory];
                 [self refreshLocalFiles];
                 [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }

        /*}*/
        
        

    }
}

#pragma mark Box CMS methods

-(void)getRootFolderListFromBox
{
    
    BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
                
        if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
           
                        [boxFolderProdcutsArray removeAllObjects];
            for (BoxObject *object in folder.objectsInFolder) {
                if([object isKindOfClass:[BoxFolder class]])
                {
                    [boxFolderProdcutsArray addObject:object];
                }
                
                if([object.objectName isEqualToString:@"ProductList.xml"])
                {
                    BoxDownloadOperation *op = [BoxDownloadOperation operationForFileID:object.objectId toPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",object.objectName]]];
                    
                    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:op onCompletetion:^(BoxOperation *op, BoxOperationResponse response) {
                        NSLog(@"download completed with response %d", response);
                        if(response==BoxOperationResponseSuccessful)
                        {
                            NSLog(@"ProductList.xml Downloaded!!");
                                                        
                            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",object.objectName]]]];
                            
                            //Initialize the delegate.
                            XMLParser *parser = [[XMLParser alloc] initXMLParser];
                            
                            //Set delegate
                            [xmlParser setDelegate:parser];
                            
                            //Start parsing the XML file.
                            BOOL success = [xmlParser parse];
                            
                            if(success)
                            {
                                NSLog(@"No Errors");
                                
                                boxProductsListArray=[[NSMutableArray alloc]initWithArray:parser.resultsArray];
                            }
                            else
                                NSLog(@"Error Error Error!!!");
                            


                        }
                    }];
                }
            }
            
            [self performSelectorOnMainThread:@selector(updateTableAfterBoxCall) withObject:nil waitUntilDone:YES];
            //[self loadBoxFilesGridView];
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
        //NSLog(@"Error: FolderID must be set in BoxBrowserGridViewController");
    }
    
    
    [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:@"0"onCompletion:block];
    
}


-(void)getProductCollateralsFromBoxFolderForBoxObject:(BoxObject *)object
{
   
}
-(void)updateTableAfterBoxCall
{
    UITableViewCell *cell=[self.fileRepositoriesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIActivityIndicatorView *loading=(UIActivityIndicatorView *)cell.accessoryView;
    [loading stopAnimating];
    cell.accessoryView=nil;

    [self.fileRepositoriesTable beginUpdates];
    
    NSInteger rowToAdd = 1;

    for (int i=0; i<[boxFolderProdcutsArray count]; i++) {
        [self.fileRepositoriesTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowToAdd inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        rowToAdd+=1;
    }
    [self.fileRepositoriesTable endUpdates];
    
}


- (void)boxFolderClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    BoxObject *boxObject=[self.boxContentsArray objectAtIndex:btn.tag];
    
    if ([boxObject isKindOfClass:[BoxFolder class]]) {
        
        self.rootFolder=(BoxFolder *)boxObject;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.animationType=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Loading Files From Server...";
        
        BoxGetFolderCompletionHandler block = ^(BoxFolder* folder, BoxFolderDownloadResponseType response) {
            if (response == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
                                
                self.rootFolder = folder;
                
                [self.boxContentsArray removeAllObjects];
                
                [self.boxContentsArray addObjectsFromArray:self.rootFolder.objectsInFolder];
                
                
                UIScrollView *tScrollView=[[UIScrollView alloc]initWithFrame:DocumentScrollView.frame];
                UIViewController *tViewController=[[UIViewController alloc]init];
                [tViewController.view setBackgroundColor:[UIColor whiteColor]];
                tViewController.title=boxObject.objectName;
                tViewController.view.frame=docDetailController.view.frame;
                [tViewController.view addSubview:tScrollView];
                
                [self loadScrollView:tScrollView ForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                 ];
                [docDetailController.navigationController pushViewController:tViewController animated:YES];

                [hud hide:YES];
            }
            
            else if (response == boxFolderDownloadResponseTypeFolderNotLoggedIn)
            {
                [hud hide:YES];
                [self presenBoxLoginForm];
            }
            else {
                [hud hide:YES];
                self.title = @"Error";
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:(BoxOperationResponse)response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
                [alert show];
            }
        };
        
        [[BoxNetworkOperationManager sharedBoxOperationManager] getBoxFolderForID:self.rootFolder.objectId onCompletion:block];
        
    }
    else
    {
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
            
        }];
        
    }


}

- (void)loadServerFiles
{
    
}

- (void)updateAfrerLoadingServerFiles
{
    
}

- (void)presenBoxLoginForm
{
    vc = [BoxLoginViewController loginViewControllerWithNavBar:YES];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self presentModalViewController:vc animated:YES];
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    expandedRowIndex = -1;

    if(result==LoginSuccess)
    {
        //        BoxDownloadActionViewController * inputController = [[BoxDownloadActionViewController alloc] initWithFolderID:@"0"];
        //
        //        [viewTail buildBoxFolderListAfterLogin:inputController];
        
        [vc dismissModalViewControllerAnimated:YES];
        [self.fileRepositoriesTable.delegate tableView:self.fileRepositoriesTable willSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
        
        
    }
    
    
    if (result==LoginCancelled)
    {
        [vc dismissModalViewControllerAnimated:YES];
        UITableViewCell *cell=[self.fileRepositoriesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIActivityIndicatorView *loading=(UIActivityIndicatorView *)cell.accessoryView;
        [loading stopAnimating];
        cell.accessoryView=nil;
    }
    
    
    //  [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}

- (void)refreshLocalFiles
{
    [self.tableSource removeAllObjects];
    [PlaylistArray removeAllObjects];
    
           
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
        
        [self.tableSource addObjectsFromArray:fetchedObjects];
    
        //uncomment and mak necessry changes in loadScrollViewForIndex for getting folders in local section
        /*fetchRequest = [[NSFetchRequest alloc] init];
        sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"folderName" ascending:YES];
        fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
        entity = [NSEntityDescription entityForName:@"Folder"
                             inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        fetchedObjects = [self.managedObjectContext
                          executeFetchRequest:fetchRequest error:nil
                          ];
        
        [self.tableSource addObjectsFromArray:fetchedObjects];*/

        fetchRequest = [[NSFetchRequest alloc] init];
        sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"playlistName" ascending:YES];
        fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
        entity = [NSEntityDescription entityForName:@"Playlist"
                             inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        fetchedObjects = [self.managedObjectContext
                          executeFetchRequest:fetchRequest error:nil
                          ];
        
        [PlaylistArray addObjectsFromArray:fetchedObjects];
    
}

#pragma mark Custom UI Methods

- (IBAction)toggleButtonClicked:(id)sender
{
    
}

-(void)loadScrollView : (UIScrollView *)scrollView ForIndexPath:(NSIndexPath *)indexPath
{
     
    switch (indexPath.row) {
        case 0:
            {
                CGFloat contentSize=200;
                
                for(UIView *tView in scrollView.subviews)
                {
                    if (![tView isKindOfClass:[UIImageView class]]) {
                        [tView removeFromSuperview];
                    }
                }
                
                int row = 0;
                int column = 0;
                
                scrollView.showsHorizontalScrollIndicator=YES;
                
                for(int i = 0; i < [self.tableSource count]; ++i)
                {
                    DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(column*180+30, row*180+25, 120, 150)];
                    innerView.backgroundColor=[UIColor clearColor];
                    
                    if (column == 3)
                    {
                        column = 0;
                        row++;
                        contentSize=contentSize+200;
                        [scrollView setContentSize:CGSizeMake(0, contentSize)];
                        
                    } else {
                        column++;
                    }

               
                    dummyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    dummyBtn.frame = CGRectMake(0,0, 120, 150);
                    dummyBtn.tag = i;
                    File *aFile = [self.tableSource objectAtIndex:i];
                    innerView.docNameLabel.text= aFile.fileName;
                    innerView.docModifiedDateLabel.text=aFile.fileName;
                    
                    NSString *pathString=[NSString stringWithFormat:@"%@",aFile .filePath];

                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                        
                        dispatch_async(queue, ^{
                            
                            UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(120, 110)];
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                
                                innerView.docIcon.image = pdfThumbNailImage;
                        });
                    });
                 
                    [dummyBtn setBackgroundColor:[UIColor clearColor]];
                    
                    [dummyBtn addTarget:self action:@selector(ShowPdfPreview:)forControlEvents:UIControlEventTouchUpInside];
                                        
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                    [dummyBtn addGestureRecognizer:longPress];
                    
                    [innerView addSubview:dummyBtn];
                 
                    [scrollView addSubview:innerView];
                    
                }

            }
            break;

        case 1:
        {
            
            CGFloat contentSize=200;
            
            for(UIView *tView in scrollView.subviews)
            {
                if (![tView isKindOfClass:[UIImageView class]]) {
                    [tView removeFromSuperview];
                }
            }
            
            int row = 0;
            int column = 0;

            scrollView.showsHorizontalScrollIndicator=YES;
            
            
            for(int i = 0; i < [self.boxContentsArray count]; ++i)
            {
                DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(column*180+30, row*180+25, 120, 150)];
                innerView.backgroundColor=[UIColor clearColor];
                                
                dummyBtn = [[UIButton alloc]init];
                dummyBtn.frame = CGRectMake(0,0, 120, 150);
                dummyBtn.tag = i;
                
                BoxObject *boxObject=[self.boxContentsArray objectAtIndex:i];
                innerView.docNameLabel.text= boxObject.objectName;
                
                if ([boxObject isKindOfClass:[BoxFolder class]]) {
                    innerView.docIcon.image=[UIImage imageNamed:@"BoxFolderIcon@2x.png"];
                }
                else
                {
                    BoxFile *file=[self.boxContentsArray objectAtIndex:i];
                    [innerView.docIcon setImageURL:[NSURL URLWithString:file.largeThumbnailURL]];
                }
                
                [dummyBtn setBackgroundColor:[UIColor clearColor]];
                [dummyBtn addTarget:self action:@selector(boxFolderClicked:)forControlEvents:UIControlEventTouchUpInside];
                
               // UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
               // [dummyBtn addGestureRecognizer:longPress];
                
                [innerView addSubview:dummyBtn];
                
                contentSize=contentSize+200;
                [scrollView setContentSize:CGSizeMake(contentSize,0)];
                
                if (column == 3)
                {
                    column = 0;
                    row++;
                    contentSize=contentSize+200;
                    [scrollView setContentSize:CGSizeMake(0, contentSize)];
                    
                } else {
                    column++;
                }

                [scrollView addSubview:innerView];
                
            }
            
        }
            break;

            
        case 2:
            {
            
                CGFloat contentSize=200;
                
                for(UIView *tView in scrollView.subviews)
                {
                    if (![tView isKindOfClass:[UIImageView class]]) {
                        [tView removeFromSuperview];
                    }
                }
                
                int row = 0;
                int column = 0;
                
                scrollView.showsHorizontalScrollIndicator=YES;
                
                
                for(int i = 0; i < [PlaylistArray count]; ++i)
                {
                    DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(column*180+30, row*180+25, 120, 150)];
                    innerView.backgroundColor=[UIColor clearColor];
                    
                    dummyBtn = [[UIButton alloc]init];
                    dummyBtn.frame = CGRectMake(0,0, 120, 150);
                    dummyBtn.tag = i;
                    
                    Playlist *playlst=[PlaylistArray objectAtIndex:i];
                    innerView.docNameLabel.text= playlst.playlistName;
                    CGRect tRect=innerView.docNameLabel.frame;
                    tRect.origin.x+=20;
                    innerView.docNameLabel.frame=tRect;
                    innerView.docIcon.image = [UIImage imageNamed:@"playlist1.png"];
                    
                    [dummyBtn setBackgroundColor:[UIColor clearColor]];
                    [dummyBtn addTarget:self action:@selector(ShowPlaylistPreview:)forControlEvents:UIControlEventTouchUpInside];
                    
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                    [innerView addGestureRecognizer:longPress];
                    
                    [innerView addSubview:dummyBtn];
                    
                    if (column == 3)
                    {
                        column = 0;
                        row++;
                        contentSize=contentSize+200;
                        [scrollView setContentSize:CGSizeMake(0, contentSize)];
                        
                    } else {
                        column++;
                    }

                    [scrollView addSubview:innerView];
                    
                }
                
            }
            break;
            
        default:
            break;
    }
      

    
    
}


- (IBAction) itemMoved:(id) sender withEvent:(UIEvent *) event { 
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view]; 
    UIControl *control = sender; 
    control.center = point;
}


- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        tButton = (UIButton *) gesture.view;
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        
        if (currentSelection ==2) {
            
            
            playlistOperationsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Playlist Operation" delegate:self cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles: NSLocalizedString(@"DELETE", @"Delete"), nil];
            
            [playlistOperationsActionSheet showFromRect:gesture.view.frame inView:tButton.superview  animated:NO];
            
            playlistOperationsActionSheet.tag=tButton.tag;
            
            popoverContent.contentSizeForViewInPopover=CGSizeMake(200, 40);
            documentOptionsPopOver= [[UIPopoverController alloc]initWithContentViewController:popoverContent];
            UIView * FileActionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            [FileActionView setBackgroundColor:[UIColor grayColor]];
            [popoverContent.view addSubview:FileActionView];
            
            UIButton * deleteBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [deleteBtn setFrame:CGRectMake(5, 5, 190, 30)];
            [deleteBtn setTitle: NSLocalizedString(@"DELETE", @"Delete") forState: UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            deleteBtn.tag=tButton.tag;
            [FileActionView addSubview:deleteBtn];
            
            if([documentOptionsPopOver isPopoverVisible])
                [documentOptionsPopOver dismissPopoverAnimated:YES];

           // [documentOptionsPopOver presentPopoverFromRect:tButton.frame inView:tButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
       
        popoverContent.contentSizeForViewInPopover=CGSizeMake(200, 130);
        documentOptionsPopOver= [[UIPopoverController alloc]initWithContentViewController:popoverContent];
       UIView * FileActionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 130)];
        [FileActionView setBackgroundColor:[UIColor grayColor]];
        [popoverContent.view addSubview:FileActionView];
        
        fileOperationsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select File Operation" delegate:self cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"SEND_EMAIL", @"Send Email") , NSLocalizedString(@"ADD_TO_EXISTING_PLAYLIST", @"Add To Existing Playlist"),NSLocalizedString(@"DELETE", @"Delete"), nil];
        
        fileOperationsActionSheet.tag=tButton.tag;

        [fileOperationsActionSheet showFromRect:gesture.view.frame inView:tButton.superview  animated:NO];

        UIButton * SendEmailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [SendEmailButton setTag:tButton.tag];
        [SendEmailButton setFrame:CGRectMake(5, 5, 190, 30)];
        [SendEmailButton setTitle: NSLocalizedString(@"SEND_EMAIL", @"Send Email") forState: UIControlStateNormal];
        [SendEmailButton addTarget:self action:@selector(SendEmail:) forControlEvents:UIControlEventTouchUpInside];
        [SendEmailButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [FileActionView addSubview:SendEmailButton];
        
        UIButton * addToExistingPlaylistBtn =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addToExistingPlaylistBtn setFrame:CGRectMake(5, 50, 190, 30)];      
        [addToExistingPlaylistBtn setTitle: NSLocalizedString(@"ADD_TO_EXISTING_PLAYLIST", @"Add To Existing Playlist") forState: UIControlStateNormal];
        [addToExistingPlaylistBtn addTarget:self action:@selector(addToExistingPlaylistBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [addToExistingPlaylistBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            addToExistingPlaylistBtn.tag=tButton.tag;

        [FileActionView addSubview:addToExistingPlaylistBtn];
        
        UIButton * deleteBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteBtn setFrame:CGRectMake(5, 95, 190, 30)];
        [deleteBtn setTitle: NSLocalizedString(@"DELETE", @"Delete") forState: UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag=tButton.tag;

        [deleteBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [FileActionView addSubview:deleteBtn];
        
        if([documentOptionsPopOver isPopoverVisible])
                [documentOptionsPopOver dismissPopoverAnimated:YES];
       // [documentOptionsPopOver presentPopoverFromRect:tButton.frame inView:tButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
        

    }
}


-(void)deleteBtnSelected:(NSInteger)tag
{
    
    if (currentSelection ==1)
    {
        [documentOptionsPopOver dismissPopoverAnimated:YES];

        
        
        NSFileManager *manager=[NSFileManager defaultManager];
        
        NSError *error;
        
        File *fileObjectSelected=[self.tableSource objectAtIndex:tag];

        [manager removeItemAtPath:fileObjectSelected.filePath error:&error];
        
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        [context deleteObject:fileObjectSelected];
        
        if(![context save:&error])
        {
            NSLog(@"Sorry could not delete playlist object : %@",[error localizedDescription]);
        }

                
        [self refreshLocalFiles];
        
        [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }

    else if (currentSelection ==2) {
        [documentOptionsPopOver dismissPopoverAnimated:YES];
        [PlaylistArray removeObjectAtIndex:tag];
        
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        Playlist *fileObjectSelected=[PlaylistArray objectAtIndex:tag];
        [context deleteObject:fileObjectSelected];
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"Sorry could not delete playlist object");
        }
        
        [self refreshLocalFiles];
        
        [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    }
}

-(void)ShowPdfPreview:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    File *selectedFile = [self.tableSource objectAtIndex:temp.tag];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Screen" withAction:@"Document Clicked" withLabel:selectedFile.fileName withValue:nil];
    if ([[selectedFile getFileType] isEqualToString:@"pdf"]) {
        
        PDFViewController *viewController = [[PDFViewController alloc] initWithPDFFile:selectedFile.fileName];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }
    else
    {
        pptPane = [[PresentationPaneViewController alloc]initWithNibName:@"PresentationPaneViewController" bundle:nil];
        NSMutableArray *fileArray=[[NSMutableArray alloc]initWithObjects:selectedFile, nil];
        pptPane.pptDocsArray=fileArray;
        [self.navigationController pushViewController:pptPane animated:YES];
    }

}

-(void)ShowPlaylistPreview:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    itemPRessed=temp.tag;
    
    Playlist *playlistClicked=(Playlist *)[PlaylistArray objectAtIndex:temp.tag];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Screen" withAction:@"Playlist Clicked" withLabel:playlistClicked.playlistName withValue:nil];
    PlayListContentsViewController *play=[[PlayListContentsViewController alloc]initWithNibName:@"PlayListContentsViewController" bundle:nil];
    play.playlist=playlistClicked;
    play.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:play animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 250, 500, 500);
    r = [self.view convertRect:r toView:play.view.superview.superview];
    play.view.superview.frame = r;
    
}
-(void)dismissModalVC
{
    [PlaylistDetails dismissModalViewControllerAnimated:YES];
}
-(void)dismissModalVCPlaylist
{
    [addToExistingPlaylist dismissModalViewControllerAnimated:YES];
}

-(void)CreatePlaylistbtnSelected:(id)sender
{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Screen" withAction:@"Create Playlist Clicked" withLabel:nil withValue:nil];
    
    UIAlertView *createNewPlaylistAlert=[[UIAlertView alloc]initWithTitle:@"Enter Play List Name \n" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",@"Cancel") otherButtonTitles:NSLocalizedString(@"OK",@"Ok"), nil];
    createNewPlaylistAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [createNewPlaylistAlert show];
}


#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        
    }
    
    else if(buttonIndex==1)
    {
        //creating new playlist
        NSString *newPlaylistName= [alertView textFieldAtIndex:0].text;
        
        if (![SAppDelegateObject checkAttributeWithAttributeName:@"playlistName" InEntityWithEntityName:@"Playlist" ForPreviousItems:newPlaylistName inContext:self.managedObjectContext])
        {
            Playlist * pl1 = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Playlist"
                              inManagedObjectContext:self.managedObjectContext];;
            pl1. playlistName = newPlaylistName;
            
            
        }
        
        NSError *error;
        
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Sorry, couldn't create new playlist %@", [error localizedDescription]);
        }
        
         [self refreshLocalFiles];
         [self loadScrollView:DocumentScrollView ForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

}
}

#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            if(actionSheet == playlistOperationsActionSheet)
            {
                [self deleteBtnSelected:actionSheet.tag];
            }
            
            else if(actionSheet == fileOperationsActionSheet)
            {
                [self SendEmail:actionSheet.tag];
            }
        
        }

            break;
            
        case 2:
        {
            [self addToExistingPlaylistBtnSelected];
        }
            
            break;
            
            case 3:
            
             if(actionSheet == fileOperationsActionSheet)
            {
                [self deleteBtnSelected:actionSheet.tag];
            }
            
            break;
            
        default:
            break;
    }
    

}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

#pragma mark Document Mailing

-(void)SendEmail:(NSInteger)tag
{
    
    
    NSError *error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:((File*)([self.tableSource objectAtIndex:tag])).filePath error:&error];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    NSLog(@"file size: %lld",fileSize);
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *mailController= [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            
            [[mailController navigationBar] setTintColor:[UIColor blackColor]];
            
            //PDF Attachement
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"pdf"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }

            //PNG attachement
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"png"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"image/png" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }
            
            //JPEG attachment
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"jpg"] || [[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"jpeg"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"image/jpeg" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }
            
            //MS-DOC attachement
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"doc"]  || [[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"docx"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }
            
            //MS-PPT attachement
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"ppt"] || [[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"pptx"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"application/mspowerpoint" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }
            
            //MS-EXCEL attachment
            if ([[((File*)([self.tableSource objectAtIndex:tag])) getFileType] isEqualToString:@"xls"]) {
                
                NSMutableData *pdfData = [NSMutableData dataWithContentsOfFile:((File*)([self.tableSource objectAtIndex:tag])).filePath];
                [mailController addAttachmentData:pdfData mimeType:@"application/x-msexcel" fileName:((File*)([self.tableSource objectAtIndex:tag])).fileName];
            }
            
            
            NSMutableString *subject  = [NSMutableString string];
            [subject appendString:[NSString stringWithFormat:@"Mailing Document - %@",((File*)([self.tableSource objectAtIndex:tag])).fileName]];
            [mailController setSubject:subject];
            
            NSMutableString *mailbody  = [NSMutableString string];
            [mailbody appendString:[NSString stringWithFormat: @"Hi, PFA"]];
            
            [mailController setMessageBody:mailbody isHTML:NO];
            
            [self presentModalViewController:mailController animated:YES];
            mailController = nil;
        }
        else
        {
            [self launchMailAppOnDeviceForShare];
        }
    }
    
    
}


-(void)launchMailAppOnDeviceForShare
{
    
    NSMutableString *subject  = [NSMutableString string];
    [subject appendString:@"Meeting"];
    
    NSMutableString *mailbody  = [NSMutableString string];
    [mailbody appendString:@"You and I have an appointment on "];
    [mailbody appendString:@"To discuss about "];
    
    
    NSString *recipients = [NSString stringWithFormat:@"mailto:?&subject=%@!",subject];
    
    NSString *body = [NSString stringWithFormat:@"&body=%@!",mailbody];;
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result  error:(NSError*)error
{
    UIAlertView *alert;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
			
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
        {
            alert=[[UIAlertView alloc] initWithTitle: @"Mail sent" message:@"Mail successfully sent!!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
			alert = nil;
        }
            break;
        case MFMailComposeResultFailed:
		{
            alert=[[UIAlertView alloc] initWithTitle:@"Failure"  message:@"Mail sending failed" delegate:self cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
            break;
        default:
			NSLog(@"Result: not sent");
            break;
    }
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)addToExistingPlaylistBtnSelected

    {
      
    [self refreshLocalFiles];
    [documentOptionsPopOver dismissPopoverAnimated:YES];
    addToExistingPlaylist = [[ LandscapeViewController alloc] init];
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] init];
    toolBar.frame = CGRectMake(0, 0, 500, 44);
    toolBar.barStyle = UIBarStyleDefault;
    // [toolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalVCPlaylist)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];;
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment:UITextAlignmentCenter];
    [title setText:NSLocalizedString(@"SELECT_PLAYLIST_TO_ADD", @"Select Playlist To Add")];
    
    UIBarButtonItem *titleItem=[[UIBarButtonItem alloc]initWithCustomView:title];
    
    NSArray *barButton  =   [[NSArray alloc] initWithObjects:doneButton,flexibleSpace,titleItem,flexibleSpace, nil];
    [toolBar setItems:barButton];
    
    [addToExistingPlaylist.view addSubview:toolBar];
    
    PlaylistNametable =[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 500, 450) style:UITableViewStylePlain];
    PlaylistNametable.tag = 3;
    PlaylistNametable.dataSource=self;
    PlaylistNametable.delegate=self;
    
    [addToExistingPlaylist.view  addSubview:PlaylistNametable];
    
    //SSimpleCalculator *vc=[[SSimpleCalculator alloc]initWithNibName:@"SSimpleCalculator" bundle:nil];
    addToExistingPlaylist.modalPresentationStyle=UIModalPresentationFormSheet; 
    [self presentModalViewController:addToExistingPlaylist animated:YES]; 
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 250, 500, 500); 
    r = [self.view convertRect:r toView:addToExistingPlaylist.view.superview.superview];
    addToExistingPlaylist.view.superview.frame = r;
    

    
}


- (NSString *)temporaryDirectoryWithPath:(NSString *)pathComponent{
    return [NSString stringWithFormat:@"%@%@/index.html",NSTemporaryDirectory(),pathComponent];
}


- (void)unzipFileAt:(NSString *)sourcePath toPath:(NSString *)destnPath{
    ZipArchive *zipper = [[ZipArchive alloc]init];
    if ([zipper UnzipOpenFile:sourcePath]) {
        [zipper UnzipFileTo:destnPath overWrite:YES];
        [zipper UnzipCloseFile];
        
    }
}

#pragma mark CTSDropBoxHelper

- (void)cTSDropBoxHelper:(CTSDropBoxHelper *)cTSDropBoxHelper loadedMetaData:(DBMetadata *)metadata ForRestClient:(DBRestClient *)client
{
  
}
- (void)cTSDropBoxHelper:(CTSDropBoxHelper *)cTSDropBoxHelper loadMetadataFailedWithError:(NSError *)error ForRestClient:(DBRestClient *)client
{
    
}

- (void)loadeUserInfoWithName:(NSString *)userName andUserID:(NSString *)userID
{
    [Utils userDefaultsSetObject:userName forKey:DROPBOXUSERNAME];
    [Utils userDefaultsSetObject:userID forKey:DROPBOXUSERID];
    
    NSString *boxConnectionStatus=@"";
    boxConnectionStatus=@"Not Connected";
    
    if ([BoxLoginViewController currentUser])
    {
        boxConnectionStatus=[BoxLoginViewController currentUser].userName;
        
    }
    
    onlineFileRepositories=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:boxConnectionStatus,userName, nil] forKeys:[NSArray arrayWithObjects:@"Box",@"Dropbox", nil]];
    
    
}

-(void)loadedLocalFolders:(NSMutableArray *)folders andFiles:(NSMutableArray *)files atPath:(NSString *)path
{
    
}

- (void)dropBoxLinkedSuccesfullyForFirstTime
{
   
    
    docDetailNavController=nil;
    DropBoxGridBrowserViewController *dropBoxBrowser=[[DropBoxGridBrowserViewController alloc]init];
    
    docDetailNavController=[[UINavigationController alloc]initWithRootViewController:dropBoxBrowser];
    docDetailNavController.view.frame=CGRectMake(250, 80, 740, 650);
    [docDetailNavController.view.layer setCornerRadius:5];
    [self.view addSubview:docDetailNavController.view];
 
}

@end
