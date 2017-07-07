    //
//
//  iPitch V2
//
//  Created by Satheeshwaran on 03/04/13.
//  Copyright 2011 Cognizant. All rights reserved.
//

#import "Utils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "QuartzCore/CALayer.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "File.h"
#import "MBProgressHUD.h"


#define PDF_THUMBNAIL_WIDTH_SMALL 60
#define PDF_THUMBNAIL_HEIGHT_SMALL 60

#define PDF_THUMBNAIL_WIDTH_LARGE 60
#define PDF_THUMBNAIL_WIDTH_LARGE 60

/**
 *	This Class is for utility services used by all Classes
 */
@implementation Utils


static UIAlertView *popUpAlert;
/**
 *	This method gets batter details
 */

+ (int)getBatteryDetails {
    // obtain the battery details
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
    CGFloat value = [device batteryLevel];
    int info = [device batteryState];
    int batinfo=(value*100);
    
    // value is from 0.0 to 1.0
    // if value is nagitive then its either in charge mode or its iOS Simulator
    NSLog(@"bat values is %d %d",info,batinfo);
    return batinfo;
}

/**
 *	This method shows alert message
 */
+ (void) showMessage:(NSString *)message withTitle:(NSString *)title{
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}
/**
 *	This method shows alert message  with cancel button
 */
+ (void) showMessage:(NSString *)message withTitle:(NSString *)title withCancelButtonTitle:(NSString *)cancelBtnTtl {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
													   delegate:nil cancelButtonTitle:cancelBtnTtl otherButtonTitles:nil];
	[alertView show];
}
/**
 *	This method shows loading activity indicator along view with background color
 */


/**
 *	This method Changes Date To Format
 */
+(NSString*)changeToDateFormat:(NSString*)dateString
{
    NSString *stringFromDate = @"";
    if ([dateString length]>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss aaa"];
        //   NSDate *date = [dateFormatter dateFromString:@"5/16/2012 2:50:52 PM"];//application.releaseDate];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
        
        stringFromDate = [dateFormatter1 stringFromDate:date];
        
        //NSLog(@"%@ :ReleaseDate: %@\ndate: %@",stringFromDate,dateString, date);
    }
    return stringFromDate;
}
/**
 *	This method converts Nil to a empty string
 */

+ (NSString*)convertNil:(NSString*)stringObject
{
	if (stringObject == nil) {
		stringObject = @"";
	}
	return stringObject;
}


/**
 *	This method will update the font size and color
 */
+ (UIFont *)controlWithfontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	UIFont *font=nil;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version == 5.0)
    {
        if(bold)
            font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:fontSize];
        else
            font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:fontSize];
	}
    else
    {
        if(bold)
        {
            // font = [UIFont fontWithName:@"Helvetica" size:fontSize];
            font = [UIFont boldSystemFontOfSize:fontSize];
        }
        else
            font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    }
  	return font;
}

/**
 *	This method checks for Null data
 */
+(NSString*)checkForNull:(NSString*)data
{
    if ([data isEqual:[NSNull null]] ) {
        return @"";
    }
    else {
        return data;
    }
	
}

/**
 *	This method returns number of characters
 */

+ (int)countString:(NSString *)stringToCount inText:(NSString *)text{
	int foundCount=0;
	NSRange range = NSMakeRange(0, text.length);
	range = [text rangeOfString:stringToCount options:NSCaseInsensitiveSearch range:range locale:nil];
	while (range.location != NSNotFound) {
		foundCount++;
		range = NSMakeRange(range.location+range.length, text.length-(range.location+range.length));
		range = [text rangeOfString:stringToCount options:NSCaseInsensitiveSearch range:range locale:nil];
	}
	
	return foundCount;
}


/**
 *	This method shows a Loading HUD
 */

+(void)showLoading:(UIView *)onView

{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:onView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
}
+(void)removeLoading:(UIView *)onView
{
    [MBProgressHUD hideHUDForView:onView animated:YES];
    
}

/**
 *	This method shows alert message and dismissed itself after a time interval
 */
+(void)showPopUpAlert:(NSString*)title WithMessage :(NSString*) message
{
    popUpAlert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@
                                                  "\n\n%@",title] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [popUpAlert show];
    [self performSelector:@selector(dismissPopUpAlertAfterDelay) withObject:nil afterDelay:2];
    
}

+(void)dismissPopUpAlertAfterDelay
{
    if(popUpAlert)
    {
        [popUpAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
    /*appDelegate=(CustomAppDelegate*)[[UIApplication sharedApplication]delegate];
     [MBProgressHUD hideHUDForView:appDelegate.idleWindow
     animated:YES];*/
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    [alertView setFrame:CGRectMake(1, 20, 2700, 400)];
}

/**
 *	This method returns color from a hex string eg: 00EEFF
 */

+(UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3)
    { cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6)
    { cleanString = [cleanString stringByAppendingString:@"ff"];
        
    }
    
    unsigned int baseValue; [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue]; float red = ((baseValue >> 24) & 0xFF)/255.0f;
    
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

/**
 *	This method helps to set values to NSUserDefaults
 */

+(void)userDefaultsSetObject:(id)userObject forKey:(NSString *)userKey
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userObject forKey:userKey];
    [userDefaults synchronize];
}

/**
 *	This method helps to get values from NSUserDefaults
 */

+(id)userDefaultsGetObjectForKey:(NSString *)userKey
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:userKey];
}

/**
 *	This method thumbnails for any file type.
 */

+(UIImage *)generateThumbNailIconForFile:(NSString *)file WithSize:(CGSize)size
{
    
    if ([[file pathExtension] isEqualToString:@"pdf"])
    {
        
        NSArray *parts = [file componentsSeparatedByString:@"/"];
        NSString *filename = [parts objectAtIndex:[parts count]-1];
        return [self generateThumbNailIconForPDFFile:filename WithSize:size];
    }
    
    else if ([[file pathExtension] isEqualToString:@"mp4"])
    {
        NSURL *videoURL=[[NSURL alloc]initFileURLWithPath:file];
        UIImage *videoThbNail=[self generateThumbnailIconForVideoFileWith:videoURL  WithSize:size];
        return videoThbNail;
    }
    
    else if ([[file pathExtension] isEqualToString:@"doc"] || [[file pathExtension] isEqualToString:@"docx"])
    {
        return [UIImage imageNamed:@"Word_doc.png"];
    }
    else if ([[file pathExtension] isEqualToString:@"ppt"] || [[file pathExtension] isEqualToString:@"pptx"])
    {
        return [UIImage imageNamed:@"Pptx.png"];
        
    }
    else if ([[file pathExtension] isEqualToString:@"xls"] || [[file pathExtension] isEqualToString:@"xlsx"])
    {
        return [UIImage imageNamed:@"Excel.png"];
        
    }
    else if ([[file pathExtension] isEqualToString:@"zip"])
    {
        return [UIImage imageNamed:@"HTML5.png"];
    }
    else if ([[file pathExtension] isEqualToString:@"html"])
    {
        return [UIImage imageNamed:@"html_icon.png"];
    }
    else if ([[file pathExtension] isEqualToString:@"txt"])
    {
        return [UIImage imageNamed:@"txt_icon.png"];
    }
    else if ([[file pathExtension] isEqualToString:@"png"] || [[file pathExtension] isEqualToString:@"jpeg"] || [[file pathExtension] isEqualToString:@"jpg"])
    {
        NSArray *parts = [file componentsSeparatedByString:@"/"];
        NSString *filename = [parts objectAtIndex:[parts count]-1];
        UIImage *originalImage = [UIImage imageNamed:filename];
        return originalImage;
        
    }
    else
        return [UIImage imageNamed:@"BoxDocumentIcon@2x.png"];
    
}

/**
 *	This method retunrs a thumbnail of a PDF file
 */

+(UIImage *)generateThumbNailIconForPDFFile:(NSString *)pdfFileName WithSize:(CGSize)size
{

    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:pdfFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the file exists
    if ([fileManager fileExistsAtPath:path])
    {
        //Display PDF
        CFURLRef pdfURL = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)path, kCFURLPOSIXPathStyle, FALSE);
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(pdfURL);
        
        CFRelease(pdfURL);

    
    CGPDFPageRef page;
    
    CGRect aRect = CGRectMake(0, 0, size.width, size.height); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage* thumbnailImage;
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, aRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, aRect);
    
    page = CGPDFDocumentGetPage(pdf,1);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
    
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(pdf);
    //CFRelease(pdfURL);
        
    return thumbnailImage;
    }
    
    return nil;
    
}

/**
 *	This method retunrs a thumbnail of a PDF page
 */


+(UIImage *)generateThumbNailIconForPDFPageNumber:(int)pageNumber InPDFFileWithName :(NSString *)pdfFileName WithSize:(CGSize)size
{
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [searchPaths objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:pdfFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the file exists
    if ([fileManager fileExistsAtPath:path])
    {
        //Display PDF
        CFURLRef pdfURL = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)path, kCFURLPOSIXPathStyle, FALSE);
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(pdfURL);
        
        CFRelease(pdfURL);
  
    
    CGPDFPageRef page;
    
    CGRect aRect = CGRectMake(0, 0, size.width, size.height); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage* thumbnailImage;
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, aRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, aRect);
    
    page = CGPDFDocumentGetPage(pdf,pageNumber);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
    
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(pdf);
   // CFRelease(pdfURL);
    
    
    return thumbnailImage;
    }
    
    return nil;
    
}

/**
 *	This method retunrs a thumbnail of a Video file
 */

+ (UIImage *)generateThumbnailIconForVideoFileWith:(NSURL *)contentURL WithSize:(CGSize)size
{
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.maximumSize=size;
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(100,100);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef] ;
    
    CGImageRelease(imgRef);
    
    return theImage;
}

//************************************************************************
// Method for making files and folders secure
//************************************************************************
+ (void)makeItemAtPathSecure:(NSString *)path
{
    NSError *securingFilesError;
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSDictionary *attrs = [manager attributesOfItemAtPath:path error:&securingFilesError];
    
    
    if(![[attrs objectForKey:NSFileProtectionKey] isEqual:NSFileProtectionComplete])
    {
        
        if(![manager setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete                                                                       forKey:NSFileProtectionKey] ofItemAtPath:path error:&securingFilesError])
        {
            NSLog(@"Problem in securing files: %@",[securingFilesError localizedDescription]);
        }
    }
    
    else
    {
        NSLog(@"Problem in securing files: %@",[securingFilesError localizedDescription]);
        
    }
    
}

+ (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)showToastWithText:(NSString *)text inView:(UIView *)view hideAfter:(NSTimeInterval )hideTiming
{
    MBProgressHUD *HUD=[MBProgressHUD showHUDAddedTo:view animated:YES];
    [HUD hide:YES afterDelay:hideTiming];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= text;
}

+ (void)clearAllTempFiles
{
    for(NSString *file in [NSArray arrayWithArray:[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSTemporaryDirectory() error:nil]])
    {
        [[NSFileManager defaultManager]removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:file] error:nil];
    }
}
@end


