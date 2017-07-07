//
//  AppDelegate.h
//  iPitch V2
//
//  Created by Satheeshwaran on 1/24/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

#import <CoreData/CoreData.h>

#import "SNotesViewController.h"

#import "NotificationsHelper.h"

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAppearanceContainer,MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;
@property (retain, nonatomic) NSMutableArray *selectedPages;
@property (strong, nonatomic) NSMutableArray *notesArray;
@property (retain, nonatomic) NSMutableArray *opportArray;
@property (retain, nonatomic) NSMutableArray *acntArray;
@property (assign, nonatomic) BOOL revealStatus;
@property (assign, nonatomic) BOOL isLoadingOtherModuleData;
@property (nonatomic, assign) BOOL postedTokenExpiredNotification;
@property(nonatomic,strong)NSMutableDictionary *opportunitiesForAccounts;

//core data properties - used across the application.
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) deleteAllObjects: (NSString *) entityDescription ForContext:(NSManagedObjectContext *)context;

- (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue inContext:(NSManagedObjectContext *)context;

- (void)sendMailToRecipients:(NSArray *)recipients withSubject:(NSString *)subject andMessage:(NSString *)message;

- (void)sendMailToRecipients:(NSArray *)recipients withSubject:(NSString *)subject andMessage:(NSString *)message WithAttachmentsIfAny:(NSData *)attachmentData andAttachmentType:(NSString *)attachmentType andAttachmentName:(NSString *)attachmentName;
- (void)updateFilesInDocumentsDirectory;
- (BOOL)resetDatastore;

@end
