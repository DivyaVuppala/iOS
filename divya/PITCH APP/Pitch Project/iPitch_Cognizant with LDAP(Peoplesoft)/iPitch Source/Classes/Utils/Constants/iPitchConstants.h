//
//  iPitchConstants.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/25/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#ifndef iPitch_V2_iPitchConstants_h
#define iPitch_V2_iPitchConstants_h


#ifdef DEBUG
// do nothing
#else
//#define NSLog(...)
#endif

typedef enum {
    CustomerModule=0,
    AccountsModule,
    OpportunitiesModule,
    EventModule,
    TaskModule,
    LeadModule
    
}ModuleType;

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define LOADED_MODULES_DATA_NOTIFICATION @"LoadedModuleDataNotification"

// # of minutes before application times out
#define kApplicationTimeoutInMinutes 5.0
#define HUD_ALERT_TIMING 3.0

// Notification that gets sent when the timeout occurs
#define kApplicationDidTimeoutNotification @"ApplicationDidTimeout"


#define FONT_BOLD @"HelveticaNeue-CondensedBold"
#define FONT_REGULAR @"HelveticaNeue-Medium"

#define PITCH_COLLATERALS_URL @"https://ch1hub.cognizant.com/sites/SC24/dmpg/HiPitch/Collaterals/Forms/AllItems.aspx"

#define IPITCH_CURRENT_USER_NAME @"iPitch Current user"
//CRM
#define ZOHO_CRM_API_KEY @"ZohoCRMAPIKey"
#define ZOHO_CRM_USERNAME @"ZohoUserName"
#define ZOHO_CRM_PASSWORD @"ZohoPassword"

//Color Theme
#define IPITCH_CURRENT_THEME_NAME @"iPitchCurrentThemeName"
#define IPITCH_CURRENT_THEME_BG_IMAGE @"iPitchCurrentThemeBGImage"

#define IPITCH_THEME1_NAME @"Theme 1"
#define IPITCH_THEME2_NAME @"Theme 2"

#define IPITCH_THEME1_BG @"Dashboard_bg.png"
#define IPITCH_THEME2_BG @"Theme2_bg.png"

#define IPITCH_THEME1_NAV_BAR_IMAGE @"header_band.png"
#define IPITCH_THEME2_NAV_BAR_IMAGE @"Theme2_header_band.png"

#define IPITCH_THEME1_NAVITEM_TINT_COLOR_CODE @"398799"
#define IPITCH_THEME2_NAVITEM_TINT_COLOR_CODE @"004e7f"


//Domain
#define IPITCH_CURRENT_DOMAIN @"iPitchCurrentDomain"
#define IPITCH_CURRENT_DOMAIN_PLIST_FILE @"iPitchCurrentDomainPlistFile"

#define IPITCH_FIRST_RUN @"iPitchFirstTimeRun"

#define BFS_DOMAIN @"BFS"
#define INSURANCE_DOMAIN @"Insurance"

#define BFS_STAGES_PLIST @"BFS_Stages.plist"
#define INSURANCE_STAGES_PLIST @"Insurance_Stages.plist"

//Notes

#define NOTES_TITLE @"notesTitle"
#define NOTES_CONTENT @"notesContent"
#define NOTES_STATUS @"notesStatus"
#define NOTES_ADDED_NOTIFICATION @"NotesAddedToEntity"
#define NOTES_DELETED_NOTIFICATION @"NotesDeletedForEntity"


//Customers
#define CUSTOMERS_ENTITY @"Customers"
#define CONTACTS_MODULE @"Contacts"
#define POTENTIALS_MODULE @"Potentials"
#define LEADS_MODULE @"Leads"
#define OPPORTUNITY_ENTITY @"Opportunities"
#define LEAD_ID @"leadID"

#define DROPBOXUSERNAME @"DropBoxUserName"
#define DROPBOXUSERID @"DropBoxUserID"
#define kDropBoxLinkedSuccessfullyNotification  @"DropBoxLinkedSuccessfullyNotification"


//Accounts
#define ACCOUNTS_ENTITY @"Accounts"
#define OPP_ENTITY @"Opportutnities"
#define NOTES_ENTITY @"Notes"

#define EVENTS_PARAMETER @"Events"
#define NO_PARAMETER @"no"
#define SUBJECT_PARAMETER @"Subject"
#define POST_PARAMETER @"POST"
#define CONTENT_TYPE_PARAMETER @"Content-Type"
#define XML_CONTENT_TYPE_PARAMETER @"application/xml"
#define JSON_CONTENT_TYPE_PARAMETER @"application/json"


#define NOTAPPLICABLE_PARAMETER @"N/A"
#define ORANGE_COLOR_CODE @"e37b34"
#define GRAY_COLOR_CODE @"6d6c6c"
#define ORANGE_COLOR_CODE_1 @"E97A@F"

#define GRAY1_COLOR_CODE @"7E7E7E"
#define GRAY2_COLOR_CODE @"A7A7A7"
#define DARK_BLUE_COLOR_CODE @"082B4C"
#define WHITE_COLOR_CODE @"FFFFFF"
#define OAUTH_TOKEN @"oAuthToken"
#define OAUTH_REFRESH_TOKEN @"oAuthRefreshToken"

#define SERVICE_NAME @"Pitch"

#define KEY_TO_ENCRYPT @"MoBiLiTyPoRtAL09"





#pragma mark CREATED BY SWARNAVA



#define NO_CONTACT_ERROR @"Opportunity cannot be created since no Client contacts exist for the Customer.Please contact CRMCompassHelpdesk@cognizant.com"

#define OPPORTUNITY_FAILURE @"Sorry could not Save Opportunity Details"

#define NOTE_ADDED @"Note added successfully"

#define INTERNET_NOT_FOUND @"No Internet Connection Found"

#define OPPORTUNITY_SUCCESS @"Opportunity Updated Successfully!!"

#define OPPORTUNITY_UNEXPECTED_ERROR @"Could not save Opportunity data save again"

#define TCV_VALID @"TCV $ should be a valid decimal"

#define TCV_NONZERO @"TCV $ should be non zero"

#define FIRST_YEAR_VALID @"First Year $ should be a valid decimal"

#define FIRST_YEAR_NONZERO @"First Year $ should be non zero"

#define ADD_PRODUCT @"Please add product"

#define FIRST_YEAR_CANT_BE_GREATER @"First Year $ cannot be greater then TCV $"

#define PRIMARY @"At least one product should be primary"

#define SUM @"Sum of individual Percentage splits must not exceed 100"

#define DURATION @"Put Proper Duration"

#define RANGE @"Percentage split must be an integer ranging from 1 to 100"

#define SAME_IF_GREATER_12 @"First Year $ should be same as TCV $ if Deal duration is lesser than or equal to 12" 

#define SELECT_DATE @"Select Date"

#define PERCENTAGE_NONZERO @"Percentage can not be zero"

#define CHECK_DESELECT @"Cognizant_button_unselect.png"

#define CHECK_SELECT @"Cognizant_button_selectd.png"

#define DELETE @"cognizant_del.png"

#define SAME_PRODUCTS @"Same products cant be repeated"

#define UPDATE_OPPORTUNITY @"Updating Opportunity..."

#define ADD_OPPORTUNITY @"Adding Opportunity..."

#define PROVIDE_USER_ID @"Please give User ID"

#define PROVIDE_PASWORD @"Please give Password"

#define AUTHENTICATE @"Authenticating User.."

#define AUTHENTICATION_FAILED @"Authentication failed!!"

#endif
