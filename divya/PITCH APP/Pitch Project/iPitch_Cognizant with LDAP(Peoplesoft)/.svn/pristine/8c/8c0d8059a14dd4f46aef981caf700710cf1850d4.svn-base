//
//  DropBoxGridBrowserViewController.m
//  DBRoulette
//
//  Created by Satheeshwaran on 4/17/13.
//
//

#import "DropBoxGridBrowserViewController.h"
#import "DocumentTileView.h"
#import <DropboxSDK/DropboxSDK.h>
#import <stdlib.h>
#import "AsyncImageView.h"
#import "iPitchConstants.h"
#import "ThemeHelper.h"

#define GRID_ELEMENT_WIDTH 120
#define GRID_ELEMENT_HEIGHT 150
#define FOLDER_ICON @"server_folder.png"

@interface DropBoxGridBrowserViewController () <DBRestClientDelegate>

{
    UIScrollView *dropBoxGridView;
    NSMutableArray *dropBoxContentsArray;
    NSString* photosHash;
    NSDictionary *thumbnailLoadingDictionary;
}

@property (nonatomic, readonly) DBRestClient* restClient;
@property (nonatomic, retain) NSString* currentPath;

@end

@implementation DropBoxGridBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFolderPath:(NSString*)folderPath {
    self = [super init];
    if (self) {
        
        NSString *root=nil;
        if (folderPath == kDBRootDropbox) {
            root = @"/";
            self.title=@"Root Folder";
        }
        
        else
        {
            root=folderPath;
            self.title=[[folderPath lastPathComponent] stringByDeletingPathExtension];

        }
        
        self.currentPath=root;

    }
    return self;
}

- (id)init {
    return [self initWithFolderPath:kDBRootDropbox]; //Default value
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dropBoxContentsArray=[[NSMutableArray alloc]init];
    
    dropBoxGridView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 740, 650)];
    dropBoxGridView.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:dropBoxGridView];
    
    thumbnailLoadingDictionary=[[NSMutableDictionary alloc]init];
	// Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ThemeHelper applyCurrentThemeToView];
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Loading Files From Dropbox...";

    [self.restClient loadMetadata:self.currentPath withHash:photosHash];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadBoxFilesGridView
{
    
    CGFloat contentSize=200;
    
    for(UIView *tView in dropBoxGridView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    int row = 0;
    int column = 0;
    
    
    if(dropBoxContentsArray && [dropBoxContentsArray count]>0)
        for(int i = 0; i < [dropBoxContentsArray count]; ++i)
        {
            DocumentTileView *innerView = [[DocumentTileView alloc]initWithFrame:CGRectMake(column*180+30, row*180+25, GRID_ELEMENT_WIDTH, GRID_ELEMENT_HEIGHT)];
            innerView.backgroundColor=[UIColor clearColor];
            
            UIButton *dummyBtn = [[UIButton alloc]init];
            dummyBtn.frame = CGRectMake(0,0, GRID_ELEMENT_WIDTH, GRID_ELEMENT_HEIGHT);
            dummyBtn.tag = i;
            
            DBMetadata* dropBoxObject = (DBMetadata*)[dropBoxContentsArray objectAtIndex:i];
            
            innerView.docNameLabel.text= dropBoxObject.filename;
            
            
            if ([dropBoxObject isDirectory]) {
                
                
                    innerView.docIcon.image = [UIImage imageNamed:FOLDER_ICON];
                
                if ([dropBoxObject.contents count] == 1) {
                    innerView.docModifiedDateLabel.text = [NSString stringWithFormat:@"1 file."];
                } else {
                    innerView.docModifiedDateLabel.text = [NSString stringWithFormat:@"%d files.", [dropBoxObject.contents count]];
                }
            }
            else
            {

                if(dropBoxObject.thumbnailExists)
                {
                    [self.restClient loadThumbnail:dropBoxObject.path ofSize:@"iphone_bestfit" intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumbs.jpg",dropBoxObject.filename]]];
                    
                    [thumbnailLoadingDictionary setValue:innerView.docIcon forKey:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumbs.jpg",dropBoxObject.filename]]];
                }
                
                
                innerView.docModifiedDateLabel.text=[NSString stringWithFormat:@"%@", dropBoxObject.lastModifiedDate];
            }
            
            [dummyBtn setBackgroundColor:[UIColor clearColor]];
            [dummyBtn addTarget:self action:@selector(dropBoxItemClicked:)forControlEvents:UIControlEventTouchUpInside];
            
            // UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            // [dummyBtn addGestureRecognizer:longPress];
            
            [innerView addSubview:dummyBtn];
            
            if (column == 3)
            {
                column = 0;
                row++;
                contentSize=contentSize+220;
                [dropBoxGridView setContentSize:CGSizeMake(0, contentSize)];
                
            } else {
                column++;
            }
            
            [dropBoxGridView addSubview:innerView];
            
        }
    
    
}


- (void)dropBoxItemClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    DBMetadata * dropBoxObject = ((DBMetadata*)[dropBoxContentsArray objectAtIndex:btn.tag]);
    if ([dropBoxObject isDirectory]) {
        DropBoxGridBrowserViewController * browserTableViewController = [[[self class] alloc] initWithFolderPath:dropBoxObject.path] ; //Using [self class] ensures that if this class is subclassed, it pushes the correct kind of BoxBrowserTableViewController
        if (self.navigationController == nil) {
            NSLog(@"Error: BoxBrowserTableViewController should be in a UINavigationViewController to work properly.");
        }
        [self.navigationController pushViewController:browserTableViewController animated:YES];
    }
    
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *pathToSave=[NSString stringWithFormat:@"%@/%@",documentsDirectory,dropBoxObject.filename];

        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode =MBProgressHUDModeAnnularDeterminate;
        hud.labelText=@"Downloading File From Server...";
        [self.restClient loadFile:dropBoxObject.path intoPath:pathToSave];
    }
    
}


#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
        
    [dropBoxContentsArray removeAllObjects];
    [dropBoxContentsArray addObjectsFromArray:metadata.contents];
    [hud hide:YES];
    [self loadBoxFilesGridView];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    [self loadBoxFilesGridView];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    
    for (id key in [thumbnailLoadingDictionary allKeys]) {
        
        if ([key isEqualToString:destPath])
        {
            ((UIImageView *)  [thumbnailLoadingDictionary objectForKey:key]).image=[UIImage imageWithContentsOfFile:destPath];
        }
    }
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
}

-(void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath
{
    hud.progress=progress;
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath contentType:(NSString*)contentType
{
    [hud hide:YES];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:HUD_ALERT_TIMING];
    hud.mode =MBProgressHUDModeText;
    hud.labelText= @"File Downloaded Successfully!!";

}
- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

-(void)dealloc
{
    restClient=nil;
    dropBoxGridView=nil;
    dropBoxContentsArray=nil;
    thumbnailLoadingDictionary=nil;
    
}
@end
