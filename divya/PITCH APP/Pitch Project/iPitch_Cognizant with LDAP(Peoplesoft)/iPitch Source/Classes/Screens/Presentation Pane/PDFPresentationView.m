//
//  PDFPresentationView.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 11/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PDFPresentationView.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "PageSelectorViewController.h"
#import "PDFFile.h"
#import "LoginViewController.h"
#import "Utils.h"
#import "LeavesView.h"
#import "iPitchAnalytics.h"
#import "iPitchConstants.h"
#import "LandscapeViewController.h"
#import "PDFPreviewViewController.h"
#import "ThemeHelper.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface PDFPresentationView ()
{
    CGSize _pageSize;
    PDFFile *generatedPDFFile;
    UIViewController * generatedPDFController;

}

@end

@implementation PDFPresentationView

@synthesize canvas;
@synthesize colorsArray;
@synthesize colorPaletteButton;
@synthesize colorSelectionTable;
@synthesize colorSelectionPopOver;
@synthesize clearButton;
@synthesize closeButton;
@synthesize pencilButton;
@synthesize highlightButton;
@synthesize laserButton;
@synthesize pullDownButton;
@synthesize toolBarView;
@synthesize toolBarViewNew;
@synthesize childToolsView;
@synthesize childToolsViewBg;
@synthesize toolBarViewBg;
@synthesize undoButton;
@synthesize deselectButton;
@synthesize screenShotButton;

#define PENCIL_OPACITY  1.0
#define PENCIL_THICKNESS 2.0
#define HIGHLIGHT_OPACITY 0.5
#define HIGHLIGHT_THICKNESS 15.0
#define COLORS_COUNT 5
#define LASER_CHILD_VIEW_HEIGHT 50
#define OTHER_CHILD_VIEW_HEIGHT 200

#define REDCOLOR @"Red Color"
#define BLACKCOLOR @"Black Color"
#define YELLOWCOLOR @"Yellow Color"
#define GRAYCOLOR @"Gray Color"
#define BLUECOLOR @"Blue Color"

- (id)initWithPDFFileinPPT:(NSString *)fileName andPath:(NSString *)path
{
    if (self = [super init]) {
        
        pdfFileName=fileName;
                
        NSURL *pdfUrl = [NSURL fileURLWithPath:path];
        
        if (pdfUrl)
        {
		pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfUrl);
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
        }
        currentPageContext=UIGraphicsGetCurrentContext();
        currentPageNumber=0;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Pdf Presentation"];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [ThemeHelper applyCurrentThemeToView];

}

- (void)configureViews{
    
    popOverContent=[[UIViewController alloc]init];
    
    colorSelectionTable =[[UITableView alloc]init];
    colorSelectionTable.dataSource=self;
    colorSelectionTable.delegate=self;
    
    CanvasView *newCanvas = [[CanvasView alloc] initWithFrame:CGRectMake(0.0, 0, 1024, 768)];
    
    self.canvas = newCanvas;
    
    self.canvas.currentLine.lineWidth = 2.0;
    self.canvas.currentLine.opacity = 1.0;
    self.canvas.currentLine.lineColor=[UIColor blueColor];
    self.canvas.laserSelected=YES;
    
    colorsArray =[[NSMutableArray alloc]initWithObjects:@"black.png",@"blue.png",@"grey.png",@"Red.png",@"yellow.png", nil];
    
    childToolsView=[[UIView alloc]initWithFrame:CGRectMake(-60,(self.view.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, 50)];
    [childToolsView setBackgroundColor:[UIColor clearColor]];
    [childToolsView setOpaque:NO];
    [self.view addSubview:self.childToolsView];
    
    childToolsViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0 , 0)];
    [childToolsViewBg setImage:[UIImage imageNamed:@"side_bar_1.png"]];
    [childToolsViewBg setOpaque:NO];
    [childToolsView addSubview:childToolsViewBg];
    
    deselectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [deselectButton setFrame:CGRectMake(10, 10, 30, 30)];
    [deselectButton setImage:[UIImage imageNamed:@"close_btn1"] forState:UIControlStateNormal];
    [deselectButton addTarget:self action:@selector(deselectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:deselectButton];
    
    
    toolBarViewNew=[[UIView alloc]initWithFrame:CGRectMake(994, 85, 84, 608)];
    [toolBarViewNew setBackgroundColor:[UIColor clearColor]];
    [toolBarViewNew setOpaque:NO];
    toolBarViewNew.layer.zPosition = 1;
    [toolBarViewNew setHidden:YES];
    [self.view addSubview:self.toolBarViewNew];
    
    toolBarViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84 , 608)];
    [toolBarViewBg setImage:[UIImage imageNamed:@"side_bar_2.png"]];
    [toolBarViewBg setOpaque:NO];
    [toolBarViewNew addSubview:toolBarViewBg];
    
    pullDownButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pullDownButton setFrame:CGRectMake(10, 250, 20, 120)];
    [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
    [pullDownButton addTarget:self action:@selector(pullDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:pullDownButton];
    
    laserButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [laserButton setFrame:CGRectMake(50, 80, 30, 30)];
    [laserButton setImage:[UIImage imageNamed:@"hand.png"] forState:UIControlStateNormal];
    [laserButton addTarget:self action:@selector(laserButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:laserButton];
    
    
    pencilButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pencilButton setFrame:CGRectMake(50, 160, 30, 30)];
    [pencilButton setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(pencilButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:pencilButton];
    
    highlightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [highlightButton setFrame:CGRectMake(50, 420, 30, 30)];
    [highlightButton setImage:[UIImage imageNamed:@"highlighetr.png"] forState:UIControlStateNormal];
    [highlightButton addTarget:self action:@selector(highlightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:highlightButton];
    
    colorPaletteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [colorPaletteButton setFrame:CGRectMake(10, 5, 30, 30)];
    [colorPaletteButton setImage:[UIImage imageNamed:@"color_wheel.png"] forState:UIControlStateNormal];
    [colorPaletteButton addTarget:self action:@selector(colorPalettePressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:colorPaletteButton];
    
    undoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setFrame:CGRectMake(10, 50, 30, 30)];
    [undoButton setImage:[UIImage imageNamed:@"undo.png"] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:undoButton];
    
    clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(10, 100, 30, 30)];
    [clearButton setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:clearButton];
    
    
    screenShotButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [screenShotButton setFrame:CGRectMake(50, 500, 30, 30)];
    [screenShotButton setImage:[UIImage imageNamed:@"screen_shot.png"] forState:UIControlStateNormal];
    [screenShotButton addTarget:self action:@selector(takeScreenShotSelected:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:screenShotButton];

    
    laserSelected=NO;
    toolBarVisible=NO;
    toolBarNewVisible=NO;
    pencilSelected=NO;
    childToolOpen = NO;
    highlightSelected = NO;
    userStoppedEditing=YES;
    
}

- (void)isFullScreenMode:(BOOL)_isFullScreen{
    
    [self resetSelection];
   // [self.canvas removeFromSuperview];
   // [self.canvas removeLaserObjects];
   // [self.canvas.lines removeAllObjects];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnded)];
    
    if (_isFullScreen) {
        self.view.frame = CGRectMake(0, 0, 1024, 690);
        [toolBarViewNew setHidden:NO];
        
        toolBarViewNew.frame=CGRectMake(994, 85, 84, 608);
        pullDownButton.frame=CGRectMake(10, 250, 20, 100);
        [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
        [self.childToolsView setFrame:CGRectMake(-60, (self.view.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, 50)];
        toolBarVisible = NO;
        childToolOpen = NO;
    }
    
    [UIView commitAnimations];
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
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"PDF Page Selected" withLabel:[NSString stringWithFormat:@"Pdf Name:%@ , Page No: %d", pdfFileName, currentPageNumber] withValue:nil];
    

    PDFFile *sFile=[[PDFFile alloc]init];
    if (pdfFileName.length >10) {
        sFile.fileName=[NSString stringWithFormat:@"%@.. page no %d",[pdfFileName substringToIndex:10],currentPageNumber+1];
    }
    else
    {
        sFile.fileName=[NSString stringWithFormat:@"%@ page no %d",pdfFileName,currentPageNumber+1];
    }
    
    
    if ([sFile fileObjectIsInArray:SAppDelegateObject.selectedPages]) {
        //  [self.navigationItem.rightBarButtonItem setTitle:@"Deselect This Page"];
        currentPageSelected=YES;
        
    }
    
    else{
        //   [self.navigationItem.rightBarButtonItem setTitle:@"Select This Page"];
        currentPageSelected=NO;
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
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Custom Annotation Methods

-(IBAction)undoButtonPressed:(UIButton *)sender{
    if ([self.canvas.lines count] > 0) {
        
        //NSLog(@"last line: %i", [self.canvas.lines count]);
        
        [self.canvas.lines removeLastObject];
        [self.canvas setNeedsDisplay];
    }
}


-(IBAction)colorPalettePressed:(id)sender
{
    if (!self.canvas.laserSelected)
    {
        popOverContent.view=colorSelectionTable;
        [popOverContent setContentSizeForViewInPopover:CGSizeMake(210, 50)];
        UIPopoverController *tempPopOver = [[UIPopoverController alloc]initWithContentViewController:popOverContent];
        self.colorSelectionPopOver = tempPopOver;
        if([colorSelectionPopOver isPopoverVisible])
            [colorSelectionPopOver dismissPopoverAnimated:YES];
        [colorSelectionPopOver presentPopoverFromRect:colorPaletteButton.frame inView:childToolsView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for(int i=0;i<COLORS_COUNT;i++)
    {
        UIButton *colorButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [colorButton setFrame:CGRectMake((i*40)+10, 10, 30, 30)];
        [colorButton setTag:i];
        [colorButton setImage:[UIImage imageNamed:[colorsArray objectAtIndex:i]] forState:UIControlStateNormal];
        [colorButton.layer setCornerRadius:9];
        [colorButton addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:colorButton];
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *tView=[[UIView alloc]init] ;
    return tView;
}

#define radians(degrees) (degrees * M_PI/180)

- (void)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
        
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, imageSize.height, imageSize.width), nil);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-pdf-Images/pdf_%d.png",[pdfFileName stringByDeletingPathExtension],currentPageNumber+1]];
    
    NSFileManager *filemgr=[NSFileManager defaultManager];
    
    
    
    BOOL isExist = [filemgr fileExistsAtPath:documentsDirectory isDirectory:NO];
    if (isExist )
    {
        UIImage *image=[UIImage imageWithContentsOfFile:documentsDirectory];
        [image drawInRect:CGRectMake(0, -20, imageSize.height, imageSize.width)];
    }
    
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [[self.canvas layer]renderInContext:pdfContext];
    
     CGContextTranslateCTM( pdfContext, 0.5f * imageSize.height, 0.5f * imageSize.width ) ;
    CGContextRotateCTM( pdfContext, radians( 90 ) ) ;

    UIGraphicsEndPDFContext();
   
}

- (void)takeScreenShotSelected:(UIButton *)sender
{
    [Utils showLoading:self.view];

    generatedPDFFile=[[PDFFile alloc]init];
    
    generatedPDFFile.fileName=[NSString stringWithFormat:@"Pitch_screen_shot_%@.pdf",[NSDate date]];
    
    generatedPDFFile.filePath=[NSTemporaryDirectory() stringByAppendingPathComponent:generatedPDFFile.fileName];
    
    [self setupPDFDocumentNamed:generatedPDFFile.filePath];
    
    [self screenshot];
        
    [Utils removeLoading:self.view];

    PDFPreviewViewController *pdfPreview=[[PDFPreviewViewController alloc]initWithNibName:@"PDFPreviewViewController" bundle:nil];
    pdfPreview.pdfFile=generatedPDFFile;
    pdfPreview.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:pdfPreview animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                          self.view.bounds.size.height/2 - 300,
                          650, 600);
    r = [self.view convertRect:r toView:pdfPreview.view.superview.superview];
    pdfPreview.view.superview.frame = r;

    
}

- (void)setupPDFDocumentNamed:(NSString*)path
{
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, nil);
}

-(void)colorSelected:(UIButton*)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            self.canvas.currentLine.lineColor=[UIColor blackColor];
            break;
        }
        case 1:
        {
            self.canvas.currentLine.lineColor=[UIColor blueColor];
            break;
        }
        case 2:
        {
            self.canvas.currentLine.lineColor=[UIColor grayColor];
            break;
        }
        case 3:
        {
            self.canvas.currentLine.lineColor=[UIColor redColor];
            break;
        }
        case 4:
        {
            self.canvas.currentLine.lineColor=[UIColor yellowColor];
            break;
            
        }
        default:
        {
            self.canvas.currentLine.lineColor=[UIColor blueColor];
            break;
        }
    }
    
    if (colorSelectionPopOver.isPopoverVisible) {
        [colorSelectionPopOver dismissPopoverAnimated:YES];
        
    }

    if(pencilSelected)
    {

        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"Pencil Color Selected" withLabel:[NSString stringWithFormat:@"%@-%@",pdfFileName , self.canvas.currentLine.lineColor] withValue:nil];
       
    }
    else
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"Highlighter Color Selected" withLabel:[NSString stringWithFormat:@"%@-%@",pdfFileName , self.canvas.currentLine.lineColor] withValue:nil];
    }
    
    
}

-(IBAction)laserButtonPressed:(id)sender
{
    
    [self resetSelection];
    userStoppedEditing=NO;
    laserSelected = YES;
    self.canvas.laserSelected=YES;
    [laserButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    if(self.canvas.laserSelected)
    {
        [self.canvas removeLaserObjects];
    }
    else
    {
    }

    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"Laser Selected" withLabel:pdfFileName withValue:nil];
    
    [self showChildTools];
    
}

-(IBAction)clearButtonPressed:(id)sender
{
    [self.canvas.lines removeAllObjects];
    [self.canvas setNeedsDisplay];
    
}

-(IBAction)pullDownButtonPressed:(id)sender
{
    [self.canvas removeLaserObjects];
    toolBarVisible=!toolBarVisible;
    
    if(!toolBarVisible)
        [self hideToolBar];
    else
        [self showToolBar];
    
    [self.view bringSubviewToFront:pullDownButton];
}


-(IBAction)pencilButtonPressed:(id)sender
{
    userStoppedEditing=NO;
    [self resetSelection];
    self.canvas.laserSelected=NO;
    [self.canvas removeLaserObjects];
    [pencilButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    pencilSelected=YES;
    highlightSelected=NO;
    self.canvas.currentLine.lineWidth = PENCIL_THICKNESS;
    self.canvas.currentLine.opacity =PENCIL_OPACITY;
    self.canvas.currentLine.lineColor=[UIColor blueColor];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"Pencil Selected" withLabel:pdfFileName withValue:nil];
    [self showChildTools];
}

-(IBAction)highlightButtonPressed:(id)sender
{
    userStoppedEditing=NO;
    [self resetSelection];
    self.canvas.laserSelected=NO;
    [self.canvas removeLaserObjects];
    [highlightButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    highlightSelected=YES;
    pencilSelected=NO;
    self.canvas.currentLine.lineWidth = HIGHLIGHT_THICKNESS;
    self.canvas.currentLine.opacity = HIGHLIGHT_OPACITY;
    self.canvas.currentLine.lineColor=[UIColor yellowColor];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Pdf Presentation Screen" withAction:@"Highlighter Selected" withLabel:pdfFileName withValue:nil];
    [self showChildTools];
}

-(void)resetSelection
{
    [pencilButton setBackgroundImage:nil forState:UIControlStateNormal];
    [highlightButton setBackgroundImage:nil forState:UIControlStateNormal];
    [laserButton setBackgroundImage:nil forState:UIControlStateNormal];
    laserSelected = NO;
    pencilSelected = NO;
    highlightSelected = NO;
}

-(IBAction)deselectButtonPressed:(id)sender
{
    userStoppedEditing=YES;
    [self hideChildTools];
    [self resetSelection];
}

-(void)showChildTools
{
    childToolOpen = YES;
    
    if(toolBarVisible)
        [self hideToolBar];
    
    if(laserSelected)
    {
        childToolsViewBg.frame=CGRectMake(0, 0, 50, 50);
        [self.childToolsView setFrame:CGRectMake(-60, (768-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
        [deselectButton setFrame:CGRectMake(10, 10, 30, 30)];
        [childToolsView addSubview:deselectButton];
        [colorPaletteButton setHidden:YES];
        [undoButton setHidden:YES];
        [clearButton setHidden:YES];
    }
    
    else
    {
        childToolsViewBg.frame=CGRectMake(0, 0, 50, 200);
        [self.childToolsView setFrame:CGRectMake(-60, (768-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
        [deselectButton setFrame:CGRectMake(10, 150, 30, 30)];
        [colorPaletteButton setHidden:NO];
        [undoButton setHidden:NO];
        [clearButton setHidden:NO];
    }
    
    [self.view addSubview: canvas];
    [self.view bringSubviewToFront:canvas];
    [self.view bringSubviewToFront:toolBarViewNew];
    
    [UIView animateWithDuration:0.50f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [self.view bringSubviewToFront:childToolsView];
                         if(laserSelected)
                             [self.childToolsView setFrame:CGRectMake(0, (768-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
                         
                         else
                             [self.childToolsView setFrame:CGRectMake(0, (768-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
                     }
     
                     completion:nil];
}

-(void)hideChildTools
{
    childToolOpen = NO;
    
    if(userStoppedEditing)
    {
        [self.canvas.lines removeAllObjects];
        [self.canvas setNeedsDisplay];
        [self.canvas removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.50f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         if(laserSelected)
                             [self.childToolsView setFrame:CGRectMake(-60, (self.view.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
                         
                         else
                             [self.childToolsView setFrame:CGRectMake(-60, (self.view.frame.size.height-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
                         
                     }
     
                     completion:nil];
}

-(void)showToolBar
{
    toolBarVisible = YES;
    
    if(childToolOpen)
        [self hideChildTools];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         toolBarViewNew.frame=CGRectMake(941, 85, 84, 608);
                         pullDownButton.frame=CGRectMake(10, 250, 20, 100);
                     }
                     completion:nil];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             
             [pullDownButton setImage:[UIImage imageNamed:@"up_arrow_New.png"] forState:UIControlStateNormal];
             
         }
     }
     ];
    
}

-(void)hideToolBar
{
    toolBarVisible = NO;
    
    if((laserSelected || pencilSelected || highlightSelected) && !childToolOpen)
        [self showChildTools];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         toolBarViewNew.frame=CGRectMake(994, 85, 84, 608);
                         pullDownButton.frame=CGRectMake(10, 250, 20, 100);
                     }
                     completion:nil];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
         }
     }
     ];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor redColor]];
    [ThemeHelper applyCurrentThemeToView];

    [self configureViews];
	leavesView.backgroundRendering = YES;
    leavesView.frame = CGRectMake(0, 10, 1024, 690);
	[self displayPageNumber:1];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
