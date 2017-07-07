    //
//  PDFExampleViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "PDFViewController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "PageSelectorViewController.h"
#import "PDFFile.h"
#import "LoginViewController.h"
#import "LeavesView.h"
#import "Utils.h"
#import "iPitchAnalytics.h"
#import "iPitchConstants.h"
#import "ThemeHelper.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface PDFViewController ()
{
    CGSize _pageSize;
}

@end


@implementation PDFViewController
@synthesize pageThumbnailsScrollView;
@synthesize selectedPagesPopOver;


- (id)initWithPDFFile:(NSString *)fileName
{
    if (self = [super init]) {
        
        // Get Documents Directory
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
        NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
                                                                                 
        NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                                 
                            // Check if the file exists
       if ([fileManager fileExistsAtPath:path])
        {
                                                                         //Display PDF
        CFURLRef pdfURL = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)path, kCFURLPOSIXPathStyle, FALSE);
        pdf = CGPDFDocumentCreateWithURL(pdfURL);
            
        CFRelease(pdfURL);
        }
       
        pdfFileName=fileName;
       /* CFStringRef strRef=(__bridge CFStringRef)fileName;
		CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), strRef, NULL, NULL);
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);*/
		//CFRelease(pdfURL);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
        NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-pdf-Images",[pdfFileName stringByDeletingPathExtension]]];
        
        NSFileManager *filemgr=[NSFileManager defaultManager];
        
        BOOL isExist = [filemgr fileExistsAtPath:documentsDirectory isDirectory:NO];
        if (isExist)
        {
            [filemgr removeItemAtPath:documentsDirectory error:NULL];
        }
        NSError *err;
        
        [filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&err];
        
        currentPageContext=UIGraphicsGetCurrentContext();
        currentPageNumber=0;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Pdf Screen"];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [ThemeHelper applyCurrentThemeToView];
        
}


- (void)viewDidDisappear:(BOOL)animated
{
    [ selectedPagesPopOver dismissPopoverAnimated:YES];
    [super viewDidDisappear:animated];
}


- (void) displayPageNumber:(NSUInteger)pageNumber {
	self.navigationItem.title = [NSString stringWithFormat:
					
                       
                       
                       @"Page %u of %ld",
								 pageNumber, 
								 CGPDFDocumentGetNumberOfPages(pdf)];
}

#pragma mark  LeavesViewDelegate methods

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex
{
    
	[self displayPageNumber:pageIndex + 1];
    currentPageNumber=pageIndex;
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Document Opened Screen" withAction:@"PDF Page Selected" withLabel:[NSString stringWithFormat:@"Pdf Name:%@ , Page No: %d", pdfFileName, currentPageNumber] withValue:nil];
    
    PDFFile *sFile=[[PDFFile alloc]init];
    if (pdfFileName.length >10) {
        sFile.fileName=[NSString stringWithFormat:@"%@.. page no %d",[pdfFileName substringToIndex:10],currentPageNumber+1];
    }
    else
    {
        sFile.fileName=[NSString stringWithFormat:@"%@ page no %d",pdfFileName,currentPageNumber+1];
    }
    
    
    if ([sFile fileObjectIsInArray:SAppDelegateObject.selectedPages]) {
       [pageSelectionButton setTitle:NSLocalizedString(@"DESELECT_THIS_PAGE", @"Deselect This Page")];
        
    }
    
    else
    {
            [pageSelectionButton setTitle:NSLocalizedString(@"SELECT_THIS_PAGE", @"Select This Page")];
    }

}


#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return CGPDFDocumentGetNumberOfPages(pdf);
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
    
    
   	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, index + 1);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);

    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    
    UIImage* img = [UIImage imageWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-pdf-Images/pdf_%d.png",[pdfFileName stringByDeletingPathExtension],index+1]];
    
    NSFileManager *filemgr=[NSFileManager defaultManager];
    
    BOOL isExist = [filemgr fileExistsAtPath:documentsDirectory isDirectory:NO];
    if (!isExist )
    {
    NSData* data = UIImagePNGRepresentation(img);
    
    [data writeToFile:documentsDirectory atomically:YES];
    }
       

    
    //   // UIWebView *pdfWebVIew=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 768,1004)];
//    
//    // Create file manager
//    if ([filemgr fileExistsAtPath:documentsDirectory isDirectory:FALSE])
//    {
//        [pdfWebVIew setScalesPageToFit:YES];
//        [pdfWebVIew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:documentsDirectory isDirectory:NO]]];
//    }
//    
//    [self.view addSubview:pdfWebVIew];


    
    
}

#pragma mark ViewLifeCycle

- (void) viewDidLoad
{
	[super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
        
	leavesView.backgroundRendering = YES;
	[self displayPageNumber:1];
    
    showPages=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"SELECTED_PAGES", @"Selected Pages") style:UIBarButtonItemStyleBordered target:self action:@selector(didClickShowPages)];
    
     pageSelectionButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"SELECT_THIS_PAGE", @"Select This Page") style:UIBarButtonItemStyleBordered target:self action:@selector(pageSelected)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:pageSelectionButton,showPages, nil];
    
    [ThemeHelper applyCurrentThemeToView];

    
     pageThumbnailsScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 607, 1070, 100)]; [pageThumbnailsScrollView setBackgroundColor:[UIColor grayColor]];
    pageThumbnailsScrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    pageThumbnailsScrollView.layer.borderWidth = 1;
    [pageThumbnailsScrollView setContentSize:CGSizeMake(CGPDFDocumentGetNumberOfPages(pdf)*120.f , 0)];
    
    [self.view addSubview:pageThumbnailsScrollView];
    
    
    [self performSelectorInBackground:@selector(addThumbnailsToScrollView) withObject:nil];
    //[[UIBarButtonItem appearance] setTintColor:[Utils colorFromHexString:@"59ACBA"]];

   }

-(void)addThumbnailsToScrollView
{
    for (int i=0; i<CGPDFDocumentGetNumberOfPages(pdf); i++)
    {
        
        UIButton *thumbnailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
              
        [thumbnailBtn setBackgroundImage:[Utils generateThumbNailIconForPDFPageNumber:i+1 InPDFFileWithName:pdfFileName WithSize:CGSizeMake(80, 80)] forState:UIControlStateNormal];
        [thumbnailBtn setBackgroundColor:[UIColor whiteColor]];
        [thumbnailBtn setFrame:CGRectMake(100*i+10, 10, 80, 80)];
        thumbnailBtn.tag = i;
       
        [thumbnailBtn addTarget:self action:@selector(thumbnailClick:) forControlEvents:UIControlEventTouchUpInside];
        [pageThumbnailsScrollView addSubview:thumbnailBtn];
        
    }
}

-(void)thumbnailClick:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    NSLog(@"page : %d", temp.tag+1);
    
    currentPageNumber=temp.tag;
    [self.leavesView setCurrentPageIndex:temp.tag];
    [self displayPageNumber:temp.tag+1];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-pdf-Images/pdf_%d.png",[pdfFileName stringByDeletingPathExtension],currentPageNumber+1]];
    
    NSLog(@"currentPageNumber : %d", currentPageNumber);

    NSLog(@"path: %@",documentsDirectory);
    
    
    if (![PDFFile fileWithPath:documentsDirectory IsInArray:SAppDelegateObject.selectedPages] )
    {
        [pageSelectionButton setTitle:NSLocalizedString(@"SELECT_THIS_PAGE", @"Select This Page")];
    }
    
    else
    {
        [pageSelectionButton setTitle:NSLocalizedString(@"DESELECT_THIS_PAGE", @"DeSelect This Page")];
    }
}

-(void)didClickShowPages
{
    
    PageSelectorViewController *pageSelector=[[PageSelectorViewController alloc]initWithStyle:UITableViewStylePlain] ;
    UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:pageSelector];
    if([self.selectedPagesPopOver isPopoverVisible])
        [self.selectedPagesPopOver dismissPopoverAnimated:YES];
    self.selectedPagesPopOver=[[UIPopoverController alloc]initWithContentViewController:navControl];
    [self.selectedPagesPopOver presentPopoverFromBarButtonItem:showPages permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)pageSelected
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);

    NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-pdf-Images/pdf_%d.png",[pdfFileName stringByDeletingPathExtension],currentPageNumber+1]];
    
    NSLog(@"path: %@",documentsDirectory);
    
    if (![PDFFile fileWithPath:documentsDirectory IsInArray:SAppDelegateObject.selectedPages] )
    {
        
        PDFFile *sFile=[[PDFFile alloc]init];
        if (pdfFileName.length >10) {
            sFile.fileName=[NSString stringWithFormat:@"%@.. page no %d",[pdfFileName substringToIndex:10],currentPageNumber+1];
        }
        else
        {
            sFile.fileName=[NSString stringWithFormat:@"%@ page no %d",pdfFileName,currentPageNumber+1];
        }
        
        sFile.filePath=documentsDirectory;

        [SAppDelegateObject.selectedPages addObject:sFile];
        [pageSelectionButton setTitle:NSLocalizedString(@"DESELECT_THIS_PAGE", @"DeSelect This Page")];
        

    }
    
    else
    {
        [PDFFile removeFileWithFilePath:documentsDirectory InArray:SAppDelegateObject.selectedPages];
        [pageSelectionButton setTitle:NSLocalizedString(@"SELECT_THIS_PAGE", @"Select This Page")];
    }
    NSLog(@"pagesSelected: %@",SAppDelegateObject.selectedPages);

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
@end
