//
//  PresentationPanelViewController.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 06/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "PresentationPaneViewController.h"
#import "File.h"
#import "iPitchConstants.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "iPitchAnalytics.h"
#import "ZipArchive.h"
#import "ThemeHelper.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface PresentationPaneViewController ()
@end

@implementation PresentationPaneViewController
@synthesize presentationView;
@synthesize pptDocsScrollView;
@synthesize pptEvent;
@synthesize pptDocsArray;
@synthesize btnPlayPresentation;
@synthesize btnClose;
@synthesize PDFPPTView;
@synthesize SelectDocLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidLoad];
    
    [ThemeHelper applyCurrentThemeToView];
    
    if([pptDocsArray count] ==0 )
    {
    [NSThread detachNewThreadSelector:@selector(loadPresentationData) toTarget:self withObject:nil];
    }
    else
    {
        
        PlayDocfromDocuments = NO;
        self.presentationView.userInteractionEnabled = YES;
        
        File *sFile=(File *)[pptDocsArray objectAtIndex:0];
        
        if([sFile.getFileType isEqualToString:@"zip"])
        {
            
            [self unzipFileAt:sFile.filePath toPath:NSTemporaryDirectory()];
            
            NSString *htmlFilePath = [self temporaryDirectoryWithPath:[[sFile.filePath lastPathComponent]stringByDeletingPathExtension]];
            [self.presentationView.hTML5Container loadHTMLFileAtPath:htmlFilePath WithType:@"html"];
        }
        
        else
        {
            [self.presentationView.hTML5Container loadHTMLFileAtPath:sFile.filePath WithType:sFile.getFileType];
            
        }
        [self.presentationView isFullScreenMode:YES];
        selectedFileTypePDF = NO;
    }

    [self.view bringSubviewToFront:SelectDocLabel];
}

-(void)loadPresentationData
{
        PlayDocfromDocuments = YES;
        
        pptDocsArray = [[NSMutableArray alloc]init];
        [pptDocsArray addObjectsFromArray: [pptEvent.filesTaggedToEvent allObjects]];
        
        for(int i=0;i<[pptDocsArray count];i++)
        {
            File *sFile=(File *)[pptDocsArray objectAtIndex:i];
            UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(50+ 120 *i, 10, 100, 100)];
            UIImageView *sFileIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 80, 80)];
            // sFileIcon.image=[UIImage imageNamed:@"pdf"];
            
            NSString *pathString=[NSString stringWithFormat:@"%@",sFile .filePath];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                
                UIImage *pdfThumbNailImage=[Utils generateThumbNailIconForFile:pathString WithSize:CGSizeMake(60, 60)];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    sFileIcon.image = pdfThumbNailImage;
                });
            });
            
            [sView addSubview:sFileIcon];
            
            dummyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dummyBtn.frame = CGRectMake(0, 0, 100, 100);
            dummyBtn.tag = i;
            [dummyBtn setBackgroundColor:[UIColor clearColor]];
            [dummyBtn addTarget:self action:@selector(openPresentationDoc:)forControlEvents:UIControlEventTouchUpInside];
            [sView addSubview:dummyBtn];
            
            UILabel *sFileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 100, 20)];
            sFileNameLabel.text=sFile.fileName;
            sFileNameLabel.font=[UIFont fontWithName:FONT_BOLD size:14];
            [sView addSubview:sFileNameLabel];
            
            [pptDocsScrollView addSubview:sView];
        }

}
-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"PresentationPane"];
   
    if (PlayDocfromDocuments) {
        pptDocsScrollView.hidden = NO;
        [self.presentationView isFullScreenMode:NO];
        self.presentationView.userInteractionEnabled = NO;
        self.btnPlayPresentation.hidden = YES;
        self.presentationView.hidden = YES;
        [self.presentationView nullLoadWebView];
        [SelectDocLabel setHidden:NO]; 
    }
    else
        [SelectDocLabel setHidden:YES];

    [self.navigationController setNavigationBarHidden:NO];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.presentationView nullLoadWebView];
    [self.presentationView.hTML5Container.mediaContainer.moviePlayer stop];
}

- (IBAction)btnCloseAction:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    pptDocsScrollView.hidden = NO;
    [self.presentationView isFullScreenMode:NO];
    self.presentationView.userInteractionEnabled = NO;
    self.btnPlayPresentation.hidden = YES;
    self.btnClose.hidden = YES;
    self.presentationView.hidden = YES;
    [self.presentationView nullLoadWebView];
    [self.presentationView.hTML5Container.mediaContainer.moviePlayer stop];
    [SelectDocLabel setHidden:NO];
}

- (IBAction)btnPlayAction:(id)sender{
    [self.navigationController setNavigationBarHidden:YES];
    
    if (selectedFileTypePDF)
    {
        [PDFPPTView isFullScreenMode:YES];
        [self.navigationController pushViewController:PDFPPTView animated:YES];
        pptDocsScrollView.hidden = NO;
        self.btnClose.hidden = YES;
        self.btnPlayPresentation.hidden = NO;
    }
    else
    {
        [self.presentationView isFullScreenMode:YES];
        self.presentationView.userInteractionEnabled = YES;
        pptDocsScrollView.hidden = YES;
        self.btnClose.hidden = NO;
        self.btnPlayPresentation.hidden = YES;
    }
    
    self.presentationView.hidden = NO;
}

-(void)openPresentationDoc:(id)sender
{
    [SelectDocLabel setHidden:YES];
    UIButton *temp=(UIButton*)sender;
    self.btnPlayPresentation.hidden = NO;
    self.presentationView.alpha = 0.0;
    self.presentationView.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.presentationView.alpha = 1.0;
    [UIView commitAnimations];
    
    self.presentationView.html5Flag=NO;
    //[self.presentationView.canvas removeLaserObjects];
    //[self.presentationView.canvas.lines removeAllObjects];
    //[self.presentationView.canvas setNeedsDisplay];
    
    File *selectedFile = (File *)[pptDocsArray objectAtIndex:temp.tag];
    
    if ([[selectedFile getFileType] isEqualToString:@"pdf"])
    {
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Presentation Pane Screen" withAction:@"Document Opened" withLabel:selectedFile.fileName withValue:nil];
        selectedFileTypePDF = YES;
        PDFPPTView = [[PDFPresentationView alloc] initWithPDFFileinPPT:selectedFile.filePath andPath:selectedFile.filePath];
        
        [self.presentationView.hTML5Container loadHTMLFileAtPath:[NSString stringWithFormat:@"%@",selectedFile.filePath] WithType:selectedFile.getFileType];
    }
    else
    {
        
        if([[selectedFile getFileType] isEqualToString:@"zip"] )
        {
            
            [self unzipFileAt:selectedFile.filePath toPath:NSTemporaryDirectory()];

            NSString *htmlFilePath = [self temporaryDirectoryWithPath:[[selectedFile.filePath lastPathComponent]stringByDeletingPathExtension]];
            [self.presentationView.hTML5Container loadHTMLFileAtPath:htmlFilePath WithType:@"html"];
        }
        
        else
        {
            [self.presentationView.hTML5Container loadHTMLFileAtPath:[NSString stringWithFormat:@"%@",selectedFile.filePath] WithType:selectedFile.getFileType];
            
        }
        
        selectedFileTypePDF = NO;
    }
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
@end
