//
//
//  iPitch V2
//
//  Created by Satheeshwaran on 03/04/13.
//  Copyright 2011 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "File.h"

@interface ProgressParam : NSObject

@end


@interface Utils : NSObject <UIAlertViewDelegate>
{
    NSThread *loadingThread;
}

+ (void) showMessage:(NSString *)message withTitle:(NSString *)title;

+ (void) showMessage:(NSString *)message withTitle:(NSString *)title withCancelButtonTitle:(NSString *)cancelBtnTtl;

+ (NSString*)convertNil:(NSString*)stringObject;

+ (NSString*)checkForNull:(NSString*)data;

+ (NSString*)changeToDateFormat:(NSString*)dateString;

+ (UIFont *)controlWithfontSize:(CGFloat)fontSize bold:(BOOL)bold;

+ (int)getBatteryDetails;

+ (void)showLoading:(UIView *)onView;

+ (void)removeLoading:(UIView *)onView;

+ (void)showPopUpAlert:(NSString*)title WithMessage :(NSString*) message;

+ (UIColor *) colorFromHexString:(NSString *)hexString;

+ (void)userDefaultsSetObject:(id)userObject forKey:(NSString *)userKey;

+ (id)userDefaultsGetObjectForKey:(NSString *)userKey;

+ (UIImage *)generateThumbNailIconForPDFFile:(NSString *)pdfFileName WithSize:(CGSize)size;

+ (UIImage *)generateThumbNailIconForPDFPageNumber:(int)pageNumber InPDFFileWithName :(NSString *)pdfFileName WithSize:(CGSize)size;

+ (UIImage *)generateThumbnailIconForVideoFileWith:(NSURL *)contentURL WithSize:(CGSize)size;

+ (UIImage *)generateThumbNailIconForFile:(NSString *)file WithSize:(CGSize)size;

+ (void)makeItemAtPathSecure:(NSString *)path;

+ (NSString *)applicationDocumentsDirectory;

+ (void)showToastWithText:(NSString *)text inView:(UIView *)view hideAfter:(NSTimeInterval )hideTiming;

+ (void)clearAllTempFiles;


@end
