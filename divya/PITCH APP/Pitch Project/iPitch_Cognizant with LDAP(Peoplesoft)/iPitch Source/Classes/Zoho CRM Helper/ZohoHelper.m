//
//  ZohoHelper.m
//  CRMNew
//
//  Created by Sandhya Sandala on 20/12/12.
//  Copyright (c) 2012 sandhya17@gmail.com. All rights reserved.
//

#import "ZohoHelper.h"
#import "ModelTrackingClass.h"
#import "ASIHTTPRequest.h"
#import "XMLWriter.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "Tasks.h"
#import "Accounts.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "Events.h"
#import "Opportunities.h"
#import "Customers.h"
#import "Lead.h"
#import "SearchAccounts.h"
#import "Potentials.h"
#import "Notes.h"
#import "Leads.h"
#import "CoreDataHelper.h"


//Vineets -1
//static NSString * AuthToken = @"efd4649757af08308d831905b88ae263";

//Vineets -2
//static NSString * AuthToken = @"9e1e4655e646064ba9897579061a2947";

//Satheesh Key
//static NSString * AuthToken = @"b550457a4ac70736e0fbc729c3d6c3f1";

//Demo Key
//static NSString * AuthToken = @"ca64bb3babdb3fa3439741f9651ea467";


@implementation ZohoHelper

@synthesize userString;
@synthesize PasswordString;
@synthesize token;

#pragma mark init Method

- (ZohoHelper *) init
{
    
    self=[super init];
    self.token = [Utils userDefaultsGetObjectForKey:ZOHO_CRM_API_KEY];
    searchContactArray= [[ NSMutableArray alloc]init];
    searchAccountArray = [[ NSMutableArray alloc]init];
    searchOpportunityArray = [[ NSMutableArray alloc]init];
    return self;
    
}


#pragma mark Zoho Authentication Key Retrieval

/****************************************************************************************/
 //	This method creates the AUTHENTICATION TOKEN USED in all API calls of Zoho CRM
/****************************************************************************************/

- (void)check
{   
    NSLog(@"User String now %@", self.userString);
    NSString *fileName = @"https://accounts.zoho.com/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&EMAIL_ID=";
    NSString *extension = @"&PASSWORD=";
    NSString * loginURL = [NSString stringWithFormat:@"%@%@%@%@", fileName, userString,extension,PasswordString];
    loginURL=[loginURL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];;
    NSURL * urlnew =[NSURL URLWithString: loginURL];
    
    ASIHTTPRequest *requestLogin=[[ASIHTTPRequest alloc]initWithURL:urlnew];
    [requestLogin setRequestMethod:@"GET"];
    [requestLogin setTimeOutSeconds:30];
    [requestLogin startSynchronous];
    NSError *errorLogin = [requestLogin error];
    NSString *responseLogin=@"";
    
    if (!errorLogin){
        responseLogin = [requestLogin responseString];
        NSLog(@"response: %@",responseLogin);
    }
    else {
        NSLog(@"Error : %@",[errorLogin localizedDescription]);
    }
    NSString *str2 = @"AUTHTOKEN=";
    NSRange result = [responseLogin rangeOfString:str2];
    NSString *newStr = [responseLogin substringFromIndex:(result.location+result.length)];
    self.token=[newStr substringToIndex:32];
    [[ModelTrackingClass sharedInstance] setModelObject:[newStr substringToIndex:32] forKey:@"token"];
    
    
}

#pragma mark Zoho Contacts - Application Customer Methods

/****************************************************************************************/
//	This method adds an account to Zoho CRM
/****************************************************************************************/

- (void)AddContactToZoho
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"Contacts"];
	[xmlWriter writeStartElement:@"row"];
    [xmlWriter writeAttribute:@"no" value:@"1"];
	[xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"First Name"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"FirstName"]]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Last Name"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"LastName"]]];
	[xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Email"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Email"]]];
    [xmlWriter writeEndElement];
    
	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
	
    NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Contacts/insertRecords?authtoken=";
    NSString *extensionAdd = @"&scope=crmapi&xmlData=";
    NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL *urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:@"POST"];
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    
}

/****************************************************************************************/
// 	This method helps in editing an existing contact in Zoho CRM
/****************************************************************************************/

- (void)EditContactOFZoho
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"Contacts"];
	[xmlWriter writeStartElement:@"row"];
    [xmlWriter writeAttribute:@"no" value:@"1"];
	[xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"First Name"];
	[xmlWriter writeCharacters:@"Satheeshwarab"];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Last Name"];
	[xmlWriter writeCharacters:
     @"J"];
	[xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Email"];
	[xmlWriter writeCharacters:@"Satheesh4590@gmail.com"];
    [xmlWriter writeEndElement];
    
    
    
    
    
	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
    
    NSString *StringEdit1 = @"https://crm.zoho.com/crm/private/xml/Contacts/updateRecords?authtoken=";
    NSString *extensionEdit = @"&scope=crmapi&id=";
    NSString *extensionEdit1 = @"&xmlData=";
    NSString * urlStringEdit = [NSString stringWithFormat:@"%@%@%@%@%@%@", StringEdit1,self.token, extensionEdit,[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"LeadUpdate"],extensionEdit1,[xmlWriter toString]];
    urlStringEdit=[urlStringEdit stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringEdit: %@",urlStringEdit);
    NSURL * urlnewEdit =[NSURL URLWithString: urlStringEdit];
    
    ASIHTTPRequest *requestEdit=[[ASIHTTPRequest alloc]initWithURL:urlnewEdit];
    
    [requestEdit setRequestMethod:@"POST"];
    [requestEdit addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestEdit setTimeOutSeconds:30];
    
    [requestEdit startSynchronous];
    
    NSError *errorEdit = [requestEdit error];
    
    NSString *responseEdit=@"";
    
    if (!errorEdit){
        responseEdit = [requestEdit responseString];
        
        NSLog(@"response: %@",responseEdit);
        
    }
    else {
        NSLog(@"Error : %@",[errorEdit localizedDescription]);
    }
    
    
    
}

/****************************************************************************************/
// This method deletes a contact from Zoho CRM.
/****************************************************************************************/

-(void)DeleteContactFromZoho
{
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Contacts/deleteRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&id=";
    NSString * urlStringDelete = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension,[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"RecordID"]];
    urlStringDelete=[urlStringDelete stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringDelete: %@",urlStringDelete);
    
    NSURL *urlDelete =[NSURL URLWithString: urlStringDelete];
    ASIHTTPRequest *requestDelete=[[ASIHTTPRequest alloc]initWithURL:urlDelete];
    [requestDelete setRequestMethod:@"GET"];
    [requestDelete addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestDelete setTimeOutSeconds:30];
    
    [requestDelete startSynchronous];
    
    NSError *errorDelete = [requestDelete error];
    
    NSString *responseDelete=@"";
    
    if (!errorDelete){
        responseDelete = [requestDelete responseString];
        
        NSLog(@"response To Delete : %@",responseDelete );
        
    }
    else {
        NSLog(@"Error : %@",[errorDelete localizedDescription]);
    }
    
    
}

/****************************************************************************************/
//	This method helps in searching Contacts in Zoho
/****************************************************************************************/

-(void)SearchContactsFromZoho
{
    //https://crm.zoho.com/crm/private/json/Contacts/getSearchRecords?authtoken=9e1e4655e646064ba9897579061a2947&scope=crmapi&selectColumns=Contacts(First Name,Last Name,CONTACTID,ACCOUNTID,Account Name,Department,Email,Phone,Date of Birth,Mailing Street,Mailing City,Mailing State,Mailing Zip,Mailing Country,Skype ID,Twitter,Linkedin)&searchCondition=(First Name|contains|*Vi*)
    //checking for inserted values.
    [searchContactArray removeAllObjects];
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Contacts/getSearchRecords?authtoken=";
    NSString *extension1 = @"&scope=crmapi&selectColumns=Contacts(First Name,Last Name,CONTACTID,ACCOUNTID,Account Name,Department,Email,Phone,Date of Birth,Mailing Street,Mailing City,Mailing State,Mailing Zip,Mailing Country,Skype ID,Twitter,Linkedin)&searchCondition=";
    
    NSString *extension2 = [NSString stringWithFormat:@"(First Name|contains|*%@*)", [NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"searchText"]]];
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension1,extension2];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * url1 =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url1];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        if ([response objectForKey:@"nodata"])
        {
            // no data
            
        }
        if ([response objectForKey:@"result"])
        {
            //[SAppDelegateObject deleteAllObjects:@"Customers" ForContext:context];
            
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *contactsDict=[result objectForKey:@"Contacts"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [contactsDict allKeys]) {
                if ([[contactsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[contactsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [contactsDict allKeys]) {
                if ([[contactsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[contactsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[contactsDict objectForKey:@"row"]];
                    
                }
            }
            
            
            for (int i=0; i<[FlDict count]; i++)
                
            {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                NSString *customerID;
                
                if ([[[flArray objectAtIndex:0] objectForKey:@"val"] isEqualToString:@"CONTACTID"])
                {
                    customerID =[[flArray objectAtIndex:0] objectForKey:@"content"];
                }
                
                NSLog(@"eventID: %@",customerID);
                
                //checking for duplications
                
                
                Lead * customerObject =[[ Lead alloc]init];
                
                for (int j=0; j<[flArray count]; j++)
                {
                    NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Phone"])
                    {
                        customerObject.Phone = [dictionary1 objectForKey:@"content"];
                        [searchContactArray addObject:customerObject];
                        
                    }
                    
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"First Name"])
                    {
                        customerObject.FirstName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Last Name"])
                    {
                        customerObject.LastName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                        customerObject.ContactID = [dictionary1 objectForKey:@"content"];
                        
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Email"]) {
                        
                        customerObject.Email=[dictionary1 objectForKey:@"content"];
                    }
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Date of Birth"]) {
                        
                        customerObject.DateofBirth = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Department"]) {
                        
                        customerObject.Department = [dictionary1 objectForKey:@"content"];
                    }
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                        
                        customerObject.ACCOUNTID = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                        
                        customerObject.AccountName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Skype ID"]) {
                        
                        customerObject.skypeID = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Twitter"]) {
                        
                        customerObject.TwitterID = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"]) {
                        
                        customerObject.Description = [dictionary1 objectForKey:@"content"];
                    }
                    
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing City"]) {
                        
                        customerObject.MailingCity = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Country"]) {
                        
                        customerObject.MailingCountry = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing State"]) {
                        
                        customerObject.MailingState = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Street"]) {
                        
                        customerObject.MailingStreet = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Zip"]) {
                        
                        customerObject.MailingZIP = [dictionary1 objectForKey:@"content"];
                    }
                    
                    customerObject.customerImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Contacts/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",self.token,customerObject.ContactID];
                }
                
                NSLog(@"searchContactArray : %@", searchContactArray);
                [[ModelTrackingClass sharedInstance] setModelObject:searchContactArray forKey:@"searchContactArray"];
                
            }
        }
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
    
}

/****************************************************************************************/
//	This method fetches favourite contacts from Zoho CRM.
/****************************************************************************************/

- (void)FetchContactsFromZoho
{
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    //checking for inserted values.
    
    //https://crm.zoho.com/crm/private/xml/Contacts/getSearchRecords?authtoken=9e1e4655e646064ba9897579061a2947&scope=crmapi&selectColumns=Contacts(First%20Name,Last%20Name,CONTACTID,ACCOUNTID,Account%20Name,Department,Email,Phone,Date%20of%20Birth,Mailing%20Street,Mailing%20City,Mailing%20State,Mailing%20Zip,Mailing%20Country,Skype%20ID,Twitter,Linkedin,Favourite)&searchCondition=(Favourite|contains|*Yes*)
    
    //https://crm.zoho.com/crm/private/json/Contacts/getRecords?authtoken= &scope=crmapi&fromIndex=1&toIndex=1
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Contacts/getSearchRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&selectColumns=Contacts(First Name,Last Name,CONTACTID,ACCOUNTID,Account Name,Department,Email,Phone,Date of Birth,Mailing Street,Mailing City,Mailing State,Mailing Zip,Mailing Country,Skype ID,Twitter,Linkedin,Favourite)&searchCondition=(Favourite|contains|*Yes*)";
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * url1 =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url1];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        if ([response objectForKey:@"result"])
        {
            [SAppDelegateObject deleteAllObjects:@"Customers" ForContext:context];
            
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *contactsDict=[result objectForKey:@"Contacts"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [contactsDict allKeys]) {
                if ([[contactsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[contactsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [contactsDict allKeys]) {
                if ([[contactsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[contactsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[contactsDict objectForKey:@"row"]];
                    
                }
            }
            
            
            for (int i=0; i<[FlDict count]; i++)
                
            {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                NSString *customerID;
                
                if ([[[flArray objectAtIndex:0] objectForKey:@"val"] isEqualToString:@"CONTACTID"])
                {
                    customerID =[[flArray objectAtIndex:0] objectForKey:@"content"];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"customerID" InEntityWithEntityName:@"Customers" ForPreviousItems:customerID inContext:context] )
                {
                    
                    
                    Customers * customerObject = [NSEntityDescription
                                                  insertNewObjectForEntityForName:@"Customers"
                                                  inManagedObjectContext:context];
                    
                    for (int j=0; j<[flArray count]; j++)
                    {
                        NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Phone"])
                        {
                            customerObject.phoneNumber = [dictionary1 objectForKey:@"content"];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"First Name"])
                        {
                            customerObject.firstName = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Last Name"])
                        {
                            customerObject.lastName = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                            customerObject.customerID = [dictionary1 objectForKey:@"content"];
                            
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Email"]) {
                            
                            customerObject.emailID=[dictionary1 objectForKey:@"content"];
                        }
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Date of Birth"]) {
                            
                            customerObject.dateOfBirth = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Department"]) {
                            
                            customerObject.department = [dictionary1 objectForKey:@"content"];
                        }
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                            
                            customerObject.accountID = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                            
                            customerObject.accountName = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Skype ID"]) {
                            
                            customerObject.skypeID = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Twitter"]) {
                            
                            customerObject.twitterID = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Linkedin"]) {
                            
                            customerObject.linkedinID = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"]) {
                            
                            customerObject.descriptionAboutCustomer = [dictionary1 objectForKey:@"content"];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing City"]) {
                            
                            customerObject.mailingCity = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Country"]) {
                            
                            customerObject.mailingCountry = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing State"]) {
                            
                            customerObject.mailingState = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Street"]) {
                            
                            customerObject.mailingStreet = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Mailing Zip"]) {
                            
                            customerObject.mailingZIP = [dictionary1 objectForKey:@"content"];
                        }
                        
                        customerObject.customerImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Contacts/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",self.token,customerObject.customerID];
                    }
                    
                   // [customerObject addNotesTaggedToCustomer:[self fetchNotesForRecordID:customerID inModule:@"Contacts"]];
                    
                    
                    if (![context save:&error])
                    {
                        NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
                    }
                    
                }
                
                else
                {
                    //update All values, excpet for events tagged to customers.
                }
                
            }
        }
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
}

#pragma mark Zoho Tasks - Application To Do Methods

/****************************************************************************************/
//This method adds a task to Zoho CRM
/****************************************************************************************/

- (void)AddTasksToZoho
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"Tasks"];
	[xmlWriter writeStartElement:@"row"];
    [xmlWriter writeAttribute:@"no" value:@"1"];
	[xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Subject"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Subject"]]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Due Date"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"StartDate"]]];
	[xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Description"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Description"]]];
    [xmlWriter writeEndElement];
    
    
	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
	
    
    NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Tasks/insertRecords?authtoken=";
    NSString *extensionAdd = @"&scope=crmapi&xmlData=";
    NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL *urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:@"POST"];
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    
}

/****************************************************************************************/
//	This method fetches all tasks from Zoho CRM
/****************************************************************************************/

- (void)FetchTasksFromZoho
{
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Tasks/getRecords?authtoken=";
    NSString *extension = @"&scope=crmapi";
    NSString * urlStringTasks = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlStringTasks=[urlStringTasks stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlStringTasks);
    
    NSURL *urltasks =[NSURL URLWithString: urlStringTasks];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:urltasks];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *responseTasks=@"";
    
    if (!error){
        responseTasks = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseActivitiesTasks = [NSJSONSerialization JSONObjectWithData:[responseTasks dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        // NSLog(@"responseActivities : %@", responseActivitiesTasks);
        NSDictionary *responsetasksDict=[responseActivitiesTasks objectForKey:@"response"];
        
        if ([responsetasksDict objectForKey:@"result"])
        {
            [self deleteCRMTasksInTasksEntityInContext:context];
            NSDictionary *resultTaskActivity=[responsetasksDict objectForKey:@"result"];
            
            NSDictionary *TaskActivityDetails=[resultTaskActivity objectForKey:@"Tasks"];
            NSMutableArray *FlArrayTaskActivity=[[NSMutableArray alloc]init];
            
            NSMutableArray *FlDictTaskActivity =[[NSMutableArray alloc]init];;
            
            
            for (id key in [TaskActivityDetails allKeys]) {
                if ([[TaskActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArrayTaskActivity addObject:[TaskActivityDetails objectForKey:key]];
                }
                
            }
            
            
            for (id key in [TaskActivityDetails allKeys]) {
                if ([[TaskActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDictTaskActivity=[FlArrayTaskActivity objectAtIndex:0];
                }
                if  ([[TaskActivityDetails objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDictTaskActivity addObject: [TaskActivityDetails objectForKey:@"row"]];
                    
                }
            }
            
            
            
            for (int i=0; i<[FlDictTaskActivity count]; i++)
            {
                NSMutableDictionary *dictionaryTaskActivity=[FlDictTaskActivity objectAtIndex:i];
                
                NSMutableArray *flArrayTaskActivity=[dictionaryTaskActivity objectForKey:@"FL"];
                
                NSString *taskID;
                
                
                if ([[[flArrayTaskActivity objectAtIndex:0] objectForKey:@"val"] isEqualToString:@"ACTIVITYID"])
                {
                    taskID =[[flArrayTaskActivity objectAtIndex:0] objectForKey:@"content"];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"taskID" InEntityWithEntityName:@"Tasks" ForPreviousItems:taskID inContext:context] )
                {
                    Tasks *taskObject = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"Tasks"
                                         inManagedObjectContext:context];
                    
                    
                    taskObject.taskSyncType=[NSNumber numberWithBool:YES];
                    
                    
                    for (int j=0; j<[flArrayTaskActivity count]; j++)
                    {
                        
                        
                        NSMutableDictionary *dictionaryTaskActivity=[flArrayTaskActivity objectAtIndex:j];
                        
                        
                        
                        if ([[dictionaryTaskActivity objectForKey:@"val"] isEqualToString:@"Subject"]) {
                            taskObject.taskSubject = [dictionaryTaskActivity objectForKey:@"content"];
                            
                            if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
                                [taskObject setTaskTypeRaw:TaskTypeCall];
                                
                            }
                            
                            else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
                                [taskObject setTaskTypeRaw:TaskTypeEmail];
                                
                            }
                            else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
                                [taskObject setTaskTypeRaw:TaskTypeMeeting];
                                
                            }
                            else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
                                [taskObject setTaskTypeRaw:TaskTypeProduct_Demo];
                                
                            }
                            
                        }
                        
                        if ([[dictionaryTaskActivity objectForKey:@"val"] isEqualToString:@"Due Date"]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionaryTaskActivity objectForKey:@"content"]];
                            
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"dd-MMM-yyyy "]; // changed line in your code
                            
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            taskObject.taskDueDate =[dateFormatter2 dateFromString:dateText];
                            
                        }
                        if ([[dictionaryTaskActivity objectForKey:@"val"] isEqualToString:@"Description"])
                        {
                            taskObject.taskDescription=[dictionaryTaskActivity objectForKey:@"content"];
                        }
                        
                        if ([[dictionaryTaskActivity objectForKey:@"val"] isEqualToString:@"ACTIVITYID"])
                        {
                            taskObject.taskID=[dictionaryTaskActivity objectForKey:@"content"];
                        }
                        
                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save Tasks %@", [error localizedDescription]);
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
        }
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
}


#pragma mark Zoho Activities - Application Event Methods

/****************************************************************************************/
 //	This method adds a activity to Zoho CRM
/****************************************************************************************/

- (void)AddActivityEventToZoho
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"Events"];
	[xmlWriter writeStartElement:@"row"];
    [xmlWriter writeAttribute:@"no" value:@"1"];
	[xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Subject"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Subject"]]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Start DateTime"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"StartDate"]]];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"End DateTime"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"EndDate"]]];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Event Purpose"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Description"]]];
    [xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"FL"];
	[xmlWriter writeAttribute:@"val" value:@"Venue"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"Venue"]]];
    [xmlWriter writeEndElement];
    
	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
	
    
    NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Events/insertRecords?authtoken=";
    NSString *extensionAdd = @"&scope=crmapi&xmlData=";
    NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL * urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:@"POST"];
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    
}


/****************************************************************************************/
//	This method adds an activity to a Zoho CRM Module
/****************************************************************************************/

- (void)AddActivityEventToZohoForModule:(ModuleType) moduleType WithDetails:(NSMutableDictionary *)details
{
    //Creating XML to send to Zoho CRM API
    
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:ZOHO_EVENTS_PARAMETER];
	[xmlWriter writeStartElement:ZOHO_ROW_PARAMETER];
    [xmlWriter writeAttribute:ZOHO_NO_PARAMETER value:@"1"];
	[xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
	[xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SUBJECT_PARAMETER];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_SUBJECT_PARAMETER]]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
	[xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_START_TIME_PARAMETER];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_START_TIME_PARAMETER]]];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
	[xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_END_TIME_PARAMETER];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_END_TIME_PARAMETER]]];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
	[xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_PURPOSE_PARAMETER];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_PURPOSE_PARAMETER]]];
    [xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
	[xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_VENUE_PARAMETER];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_VENUE_PARAMETER]]];
    [xmlWriter writeEndElement];
    
  
    
    NSString *seModuleParameter=@"";
    switch (moduleType) {
        case AccountsModule:
        {
            seModuleParameter=ZOHO_ACCOUNTS_PARAMETER;
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEID_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_SEID_PARAMETER]]];
            [xmlWriter writeEndElement];
            
            NSLog(@"semodule: %@",seModuleParameter);
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEMODULE_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",seModuleParameter]];
            [xmlWriter writeEndElement];

            break;
        }
            
        case CustomerModule:
        {
            //seModuleParameter=ZOHO_CONTACTS_PARAMETER;
            
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_CONTACT_ID_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_SEID_PARAMETER]]];
            [xmlWriter writeEndElement];
            
            break;
        }
            
        case OpportunitiesModule:
        {
            seModuleParameter=ZOHO_POTENTIALS_PARAMETER;
            
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEID_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_SEID_PARAMETER]]];
            [xmlWriter writeEndElement];
            
            NSLog(@"semodule: %@",seModuleParameter);
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEMODULE_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",seModuleParameter]];
            [xmlWriter writeEndElement];

            break;
        }
            
        case LeadModule:
            
        {
            seModuleParameter=LEADS_MODULE;
            
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEID_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",[details objectForKey:ZOHO_SEID_PARAMETER]]];
            [xmlWriter writeEndElement];
            
            NSLog(@"semodule: %@",seModuleParameter);
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_SEMODULE_PARAMETER];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",seModuleParameter]];
            [xmlWriter writeEndElement];

        }
            
        default:
            break;
    }
    
       

	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
	
    NSString * urlStringAdd = [NSString stringWithFormat:ZOHO_INSERT_NOTE_CALL, self.token, [xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL * urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:POST_PARAMETER];
    [requestAdd addRequestHeader:CONTENT_TYPE_PARAMETER value: XML_CONTENT_TYPE_PARAMETER];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    
}

/****************************************************************************************/
// This method fetches all activites from Zoho CRM
/****************************************************************************************/

- (void)FetchActivitiesFromZoho
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Events/getRecords?authtoken=";
    NSString *extension = @"&scope=crmapi";
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL *urlActivities =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:urlActivities];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseActivities = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        //NSLog(@"responseActivities : %@", responseActivities);
        NSDictionary *responseActivity=[responseActivities objectForKey:ZOHO_RESPONSE_PARAMETER];
        
        if ([responseActivity objectForKey:ZOHO_RESULT_PARAMETER])
        {
            // [self deleteCRMActivitiesInEventsEntityInContext:context];
            NSDictionary *resultActivity=[responseActivity objectForKey:ZOHO_RESULT_PARAMETER];
            NSDictionary *ActivityDetails=[resultActivity objectForKey:ZOHO_EVENTS_PARAMETER];
            NSMutableArray *FlArrayActivity=[[NSMutableArray alloc]init];
            NSMutableArray *FlDictActivity =[[NSMutableArray alloc]init];
            for (id key in [ActivityDetails allKeys]) {
                if ([[ActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArrayActivity addObject:[ActivityDetails objectForKey:key]];
                }
                
                
            }
            
            
            for (id key in [ActivityDetails allKeys]) {
                if ([[ActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDictActivity=[FlArrayActivity objectAtIndex:0];
                }
                if  ([[ActivityDetails objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDictActivity addObject: [ActivityDetails objectForKey:ZOHO_ROW_PARAMETER]];
                    
                }
                
            }
            for (int i=0; i<[FlDictActivity count]; i++)
            {
                NSMutableDictionary *dictionaryActivity=[FlDictActivity objectAtIndex:i];
                
                NSMutableArray *flArrayActivity=[dictionaryActivity objectForKey:ZOHO_FL_PARAMETER];
                
                
                NSString *eventID;
                
                
                if ([[[flArrayActivity objectAtIndex:0] objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ACTIVITY_ID_PARAMETER])
                {
                    eventID =[[flArrayActivity objectAtIndex:0] objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"eventID" InEntityWithEntityName:@"Events" ForPreviousItems:eventID inContext:context] )
                {
                    
                    Events *ActivityObject=[NSEntityDescription
                                            insertNewObjectForEntityForName:@"Events"
                                            inManagedObjectContext:context];
                    
                    
                    NSMutableDictionary *eventDetailsDict=[[NSMutableDictionary alloc]init];
                    
                    
                    ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
                    
                    for (int j=0; j<[flArrayActivity count]; j++) {
                        NSMutableDictionary *dictionaryActivity=[flArrayActivity objectAtIndex:j];
                        
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_SUBJECT_PARAMETER];
                            
                            //ActivityObject.eventTitle = [dictionaryActivity objectForKey:@"content"];
                        }
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_VENUE_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_VENUE_PARAMETER];

                            //ActivityObject.eventVenue = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ACTIVITY_ID_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_ACTIVITY_ID_PARAMETER];

                            //event ID
                           // ActivityObject.eventID = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:ZOHO_PURPOSE_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_PURPOSE_PARAMETER];
                            //event ID
                            //ActivityObject.eventDescType = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Start DateTime"]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            
                            
                            [eventDetailsDict setObject:dateNew forKey:ZOHO_START_TIME_PARAMETER];

                            //ActivityObject.eventStartDate = dateNew;
                            
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"End DateTime"]) {
                            
                            
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            
                            [eventDetailsDict setObject:dateNew forKey:ZOHO_END_TIME_PARAMETER];

                            //ActivityObject.eventEndDate = dateNew;
                            
                            
                        }
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_PURPOSE_TYPE_PARAMETER];

                           // ActivityObject.eventPurpose=[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER];
                            {
                                if ([[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:@"Call"]) {
                                    //[ActivityObject setEventTypeRaw:EventTypeCall];
                                    [eventDetailsDict setObject:ZOHO_PURPOSE_TYPE_CALL forKey:ZOHO_EVENT_TYPE_PARAMETER];
                                    
                                }
                                
                                else if ([[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:@"Email"]) {
                                     //[ActivityObject setEventTypeRaw:EventTypeEmail];
                                    [eventDetailsDict setObject: ZOHO_PURPOSE_TYPE_EMAIL forKey:ZOHO_EVENT_TYPE_PARAMETER];

                                    
                                }
                                else if ([[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:@"Meeting"]) {
                                    //[ActivityObject setEventTypeRaw:EventTypeMeeting];
                                    [eventDetailsDict setObject: ZOHO_PURPOSE_TYPE_MEETING forKey:ZOHO_EVENT_TYPE_PARAMETER];

                                    
                                }
                                else if ([[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:@"Product Demo"]) {
                                   // [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                                    [eventDetailsDict setObject:ZOHO_PURPOSE_TYPE_DEMO forKey:ZOHO_EVENT_TYPE_PARAMETER];

                                    
                                }
                                
                            }
                        }
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_RELATED_TO_ID])
                        {
                            //ActivityObject.relatedToID = [dictionaryActivity objectForKey:@"content"];
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_RELATED_TO_ID];
                            
                        }
                        
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_CONTACT_ID_PARAMETER])
                        {
                            //ActivityObject.relatedToContactID = [dictionaryActivity objectForKey:@"content"];
                            [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_CONTACT_ID_PARAMETER];
                        }
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_CONTACT_NAME_PARAMETER])
                        {
                            //ActivityObject.relatedToContactName = [dictionaryActivity objectForKey:@"content"];
                           [eventDetailsDict setObject:[dictionaryActivity objectForKey:ZOHO_CONTENT_PARAMETER] forKey:ZOHO_CONTACT_NAME_PARAMETER];
                        }
                        
                        
                        if ([[dictionaryActivity objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"SEMODULE"]) {
                            
                            
                            if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Contacts"])
                            {
                                
                                //ActivityObject.relatedToContactID = ActivityObject.relatedToID;
                               // ActivityObject.relatedToID =@"";
                            }
                            
                            else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Accounts"])
                            {
                                
                                //ActivityObject.relatedToAccountID = ActivityObject.relatedToID;
                                //ActivityObject.relatedToID = @"";
                                
                                
                            }
                            else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Potentials"])
                            {
                                
                                //ActivityObject.relatedToPotentialID =  ActivityObject.relatedToID;
                                //ActivityObject.relatedToID = @"";
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    //[ActivityObject addNotesTaggedToEvent:[self fetchNotesForRecordID:eventID inModule:@"Events"]];
                    [CoreDataHelper insertEventsToStore:eventDetailsDict CRMSyncStatus:YES];

                }
                
                
                else
                {
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Events" inManagedObjectContext:context]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID == %@", eventID];
                    [request setPredicate:predicate];
                    
                    NSError *error = nil;
                    NSArray *results = [context executeFetchRequest:request error:&error];
                    
                    if ([results count]>0)
                    {
                        
                        Events *ActivityObject=(Events *)[results objectAtIndex:0];
                        
                        ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
                        
                        for (int j=0; j<[flArrayActivity count]; j++) {
                            NSMutableDictionary *dictionaryActivity=[flArrayActivity objectAtIndex:j];
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Subject"]) {
                                ActivityObject.eventTitle = [dictionaryActivity objectForKey:@"content"];
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Venue"]) {
                                ActivityObject.eventVenue = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"ACTIVITYID"]) {
                                
                                //event ID
                                ActivityObject.eventID = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Event Purpose"]) {
                                
                                //event ID
                                ActivityObject.eventDescType = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Start DateTime"]) {
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                ActivityObject.eventStartDate = dateNew;
                                
                                NSLog (@" ActivityObject.dueDate: %@", ActivityObject.eventStartDate);
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"End DateTime"]) {
                                
                                
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                ActivityObject.eventEndDate = dateNew;
                                
                                
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Purpose Type"]) {
                                ActivityObject.eventPurpose=[dictionaryActivity objectForKey:@"content"];
                                {
                                    if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeCall];
                                        
                                    }
                                    
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeEmail];
                                        
                                    }
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeMeeting];
                                        
                                    }
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                                        
                                    }
                                    
                                }
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"RELATEDTOID"])
                            {
                                ActivityObject.relatedToID = [dictionaryActivity objectForKey:@"content"];
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"CONTACTID"])
                            {
                                ActivityObject.relatedToContactID = [dictionaryActivity objectForKey:@"content"];
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Contact Name"])
                            {
                                ActivityObject.relatedToContactName = [dictionaryActivity objectForKey:@"content"];
                            }
                            
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"SEMODULE"]) {
                                
                                
                                if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Contacts"])
                                {
                                    
                                    ActivityObject.relatedToContactID = ActivityObject.relatedToID;
                                    ActivityObject.relatedToID =@"";
                                }
                                
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Accounts"])
                                {
                                    
                                    ActivityObject.relatedToAccountID = ActivityObject.relatedToID;
                                    ActivityObject.relatedToID = @"";
                                    
                                    
                                    
                                }
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Potentials"])
                                {
                                    
                                    ActivityObject.relatedToPotentialID =  ActivityObject.relatedToID;
                                    ActivityObject.relatedToID = @"";
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        NSLog(@"customers tagged to evneg: $%@",[ActivityObject.customersTaggedToEvent allObjects]);
                        
                        //[ActivityObject addNotesTaggedToEvent:[self fetchNotesForRecordID:eventID inModule:@"Activities"]];

                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
                        }
                    }
                    
                }
            }
            
            
        }
        
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
    
}


/****************************************************************************************/
// This method fetches Related Activities For Entity in parent module in Zoho CRM.
/****************************************************************************************/

- (void)FetchRelatedActivitiesForEntity:(NSString *)parentModule :(NSString *)value
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Events/getRelatedRecords?newFormat=1&authtoken=";
    NSString *extension = @"&scope=crmapi&parentModule=";
    NSString *extension1 = @"&id=";
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", String1,self.token, extension,parentModule, extension1, value];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL *urlActivities =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:urlActivities];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseActivities = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        //NSLog(@"responseActivities : %@", responseActivities);
        NSDictionary *responseActivity=[responseActivities objectForKey:@"response"];
        
        if ([responseActivity objectForKey:@"result"])
        {
            // [self deleteCRMActivitiesInEventsEntityInContext:context];
            NSDictionary *resultActivity=[responseActivity objectForKey:@"result"];
            NSDictionary *ActivityDetails=[resultActivity objectForKey:@"Events"];
            NSMutableArray *FlArrayActivity=[[NSMutableArray alloc]init];
            NSMutableArray *FlDictActivity =[[NSMutableArray alloc]init];
            for (id key in [ActivityDetails allKeys]) {
                if ([[ActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArrayActivity addObject:[ActivityDetails objectForKey:key]];
                }
                
                
            }
            
            
            for (id key in [ActivityDetails allKeys]) {
                if ([[ActivityDetails objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDictActivity=[FlArrayActivity objectAtIndex:0];
                }
                if  ([[ActivityDetails objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDictActivity addObject: [ActivityDetails objectForKey:@"row"]];
                    
                }
                
            }
            for (int i=0; i<[FlDictActivity count]; i++)
            {
                NSMutableDictionary *dictionaryActivity=[FlDictActivity objectAtIndex:i];
                
                NSMutableArray *flArrayActivity=[dictionaryActivity objectForKey:@"FL"];
                
                
                NSString *eventID;
                
                
                if ([[[flArrayActivity objectAtIndex:0] objectForKey:@"val"] isEqualToString:@"ACTIVITYID"])
                {
                    eventID =[[flArrayActivity objectAtIndex:0] objectForKey:@"content"];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"eventID" InEntityWithEntityName:@"Events" ForPreviousItems:eventID inContext:context] )
                {
                    
                    Events *ActivityObject=[NSEntityDescription
                                            insertNewObjectForEntityForName:@"Events"
                                            inManagedObjectContext:context];
                    
                    ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
                    
                    for (int j=0; j<[flArrayActivity count]; j++) {
                        NSMutableDictionary *dictionaryActivity=[flArrayActivity objectAtIndex:j];
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Subject"]) {
                            ActivityObject.eventTitle = [dictionaryActivity objectForKey:@"content"];
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Venue"]) {
                            ActivityObject.eventVenue = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"ACTIVITYID"]) {
                            
                            //event ID
                            ActivityObject.eventID = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Event Purpose"]) {
                            
                            //event ID
                            ActivityObject.eventDescType = [dictionaryActivity objectForKey:@"content"];
                            
                        }
                        
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Start DateTime"]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            
                            ActivityObject.eventStartDate = dateNew;
                            
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"End DateTime"]) {
                            
                            
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            
                            ActivityObject.eventEndDate = dateNew;
                            
                            
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Purpose Type"]) {
                            ActivityObject.eventPurpose=[dictionaryActivity objectForKey:@"content"];
                            {
                                if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
                                    [ActivityObject setEventTypeRaw:EventTypeCall];
                                    
                                }
                                
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
                                    [ActivityObject setEventTypeRaw:EventTypeEmail];
                                    
                                }
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
                                    [ActivityObject setEventTypeRaw:EventTypeMeeting];
                                    
                                }
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
                                    [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                                    
                                }
                                
                            }
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"RELATEDTOID"])
                        {
                            ActivityObject.relatedToID = [dictionaryActivity objectForKey:@"content"];
                        }
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"CONTACTID"])
                        {
                            ActivityObject.relatedToContactID = [dictionaryActivity objectForKey:@"content"];
                        }
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Contact Name"])
                        {
                            ActivityObject.relatedToContactName = [dictionaryActivity objectForKey:@"content"];
                        }
                        
                        
                        if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"SEMODULE"]) {
                            
                            
                            if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Contacts"])
                            {
                                
                                ActivityObject.relatedToContactID = ActivityObject.relatedToID;
                                ActivityObject.relatedToID =@"";
                            }
                            
                            else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Accounts"])
                            {
                                
                                ActivityObject.relatedToAccountID = ActivityObject.relatedToID;
                                ActivityObject.relatedToID = @"";
                                
                                
                                
                            }
                            else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Potentials"])
                            {
                                
                                ActivityObject.relatedToPotentialID =  ActivityObject.relatedToID;
                                ActivityObject.relatedToID = @"";
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    if (![context save:&error])
                    {
                        NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
                    }
                }
                
                
                else
                {
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Events" inManagedObjectContext:context]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID == %@", eventID];
                    [request setPredicate:predicate];
                    
                    NSError *error = nil;
                    NSArray *results = [context executeFetchRequest:request error:&error];
                    
                    if ([results count]>0)
                    {
                        
                        Events *ActivityObject=(Events *)[results objectAtIndex:0];
                        
                        ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
                        
                        for (int j=0; j<[flArrayActivity count]; j++) {
                            NSMutableDictionary *dictionaryActivity=[flArrayActivity objectAtIndex:j];
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Subject"]) {
                                ActivityObject.eventTitle = [dictionaryActivity objectForKey:@"content"];
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Venue"]) {
                                ActivityObject.eventVenue = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"ACTIVITYID"]) {
                                
                                //event ID
                                ActivityObject.eventID = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Event Purpose"]) {
                                
                                //event ID
                                ActivityObject.eventDescType = [dictionaryActivity objectForKey:@"content"];
                                
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Start DateTime"]) {
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                ActivityObject.eventStartDate = dateNew;
                                
                                NSLog (@" ActivityObject.dueDate: %@", ActivityObject.eventStartDate);
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"End DateTime"]) {
                                
                                
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionaryActivity objectForKey:@"content"]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                ActivityObject.eventEndDate = dateNew;
                                
                                
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Purpose Type"]) {
                                ActivityObject.eventPurpose=[dictionaryActivity objectForKey:@"content"];
                                {
                                    if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeCall];
                                        
                                    }
                                    
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeEmail];
                                        
                                    }
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeMeeting];
                                        
                                    }
                                    else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
                                        [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                                        
                                    }
                                    
                                }
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"RELATEDTOID"])
                            {
                                ActivityObject.relatedToID = [dictionaryActivity objectForKey:@"content"];
                            }
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"CONTACTID"])
                            {
                                ActivityObject.relatedToContactID = [dictionaryActivity objectForKey:@"content"];
                            }
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"Contact Name"])
                            {
                                ActivityObject.relatedToContactName = [dictionaryActivity objectForKey:@"content"];
                            }
                            
                            
                            if ([[dictionaryActivity objectForKey:@"val"] isEqualToString:@"SEMODULE"]) {
                                
                                
                                if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Contacts"])
                                {
                                    
                                    ActivityObject.relatedToContactID = ActivityObject.relatedToID;
                                    ActivityObject.relatedToID =@"";
                                }
                                
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Accounts"])
                                {
                                    
                                    ActivityObject.relatedToAccountID = ActivityObject.relatedToID;
                                    ActivityObject.relatedToID = @"";
                                    
                                    
                                    
                                }
                                else if ([[dictionaryActivity objectForKey:@"content"] isEqualToString:@"Potentials"])
                                {
                                    
                                    ActivityObject.relatedToPotentialID =  ActivityObject.relatedToID;
                                    ActivityObject.relatedToID = @"";
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        NSLog(@"customers tagged to evneg: $%@",[ActivityObject.customersTaggedToEvent allObjects]);
                        
                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
                        }
                    }
                    
                }
            }
            
            
        }
        
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
    
    
    
    
}



#pragma mark Zoho Potentials - Application Opportunities Methods

/****************************************************************************************/
//	This method adds a potential to Zoho CRM
/****************************************************************************************/

- (BOOL)AddPotentialsToZohoForModule:(ModuleType)moduleType withDetails:(NSMutableDictionary *)details
{
    
    if(details)
    {
        XMLWriter* xmlWriter = [[XMLWriter alloc]init];
        
        //[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
        [xmlWriter writeStartElement:ZOHO_POTENTIALS_PARAMETER];
        [xmlWriter writeStartElement:ZOHO_ROW_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_NO_PARAMETER value:@"1"];
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_POTENTIAL_NAME_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_POTENTIAL_NAME_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_DESCRIPTION_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_DESCRIPTION_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_CLOSING_DATE_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_CLOSING_DATE_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_TYPE_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_TYPE_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_STAGE_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_STAGE_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_AMOUNT_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_AMOUNT_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_PROBABILITY_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_PROBABILITY_PARAMETER]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_NEXT_STEP_PARAMETER];
        [xmlWriter writeCharacters:[details objectForKey:ZOHO_NEXT_STEP_PARAMETER]];
        [xmlWriter writeEndElement];
        
        if(moduleType == CustomerModule)
        {
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_ACCOUNT_ID_PARAMETER];
            [xmlWriter writeCharacters:[details objectForKey:ZOHO_ACCOUNT_ID_PARAMETER]];
            [xmlWriter writeEndElement];
            
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_CONTACT_ID_PARAMETER];
            [xmlWriter writeCharacters:[details objectForKey:ZOHO_CONTACT_ID_PARAMETER]];
            [xmlWriter writeEndElement];
        }
        
        else if(moduleType == AccountsModule)
        {
            [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
            [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_ACCOUNT_ID_PARAMETER];
            [xmlWriter writeCharacters:[details objectForKey:ZOHO_ACCOUNT_ID_PARAMETER]];
            [xmlWriter writeEndElement];
        }
        
        [xmlWriter writeEndElement];
        [xmlWriter writeEndElement];
        [xmlWriter writeEndDocument];
        
        NSLog(@"%@", [xmlWriter toString]);
        
        
        NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Potentials/insertRecords?authtoken=";
        NSString *extensionAdd = @"&scope=crmapi&xmlData=";
        NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
        urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        NSLog(@"urlStringAdd: %@",urlStringAdd);
        NSURL * urlnewAdd =[NSURL URLWithString: urlStringAdd];
        
        ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
        
        [requestAdd setRequestMethod:@"POST"];
        [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
        [requestAdd setTimeOutSeconds:30];
        
        [requestAdd startSynchronous];
        
        NSError *errorAdd = [requestAdd error];
        
        NSString *responseAdd=@"";
        
        if (!errorAdd){
            responseAdd = [requestAdd responseString];
            NSLog(@"response: %@",responseAdd);
            
            if ([responseAdd rangeOfString:ZOHO_RECORD_ADDED_SUCCESSFULLY_PARAMETER].location != NSNotFound )
                return YES;
            
        }
        else {
            NSLog(@"Error : %@",[errorAdd localizedDescription]);
        }
        
    }
    return NO;
    
}


/****************************************************************************************/
 //	This method helps in searching for a string in Zoho CRM Opportutnites
/****************************************************************************************/

- (void)searchOpportunitiesFromZoho
{
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Potentials/getSearchRecords?authtoken=";
    NSString *extension1 = @"&scope=crmapi&selectColumns=Potentials(Amount,POTENTIALID,Potential Name,Closing Date,ACCOUNTID,Account Name,Stage,Type,Probability,Description,CONTACTID,Contact Name,Expected Revenue)&searchCondition=";
    NSString *extension2 = [NSString stringWithFormat:@"(Potential Name|contains|*%@*)",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"PotentialsearchText"]];
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension1,extension2];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    NSURL *urlPotentials =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestPotentials=[[ASIHTTPRequest alloc]initWithURL:urlPotentials];
    [requestPotentials setRequestMethod:@"GET"];
    [requestPotentials addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestPotentials setTimeOutSeconds:30];
    
    [requestPotentials startSynchronous];
    
    NSError *errorPotential = [requestPotentials error];
    
    NSString *response=@"";
    
    if (!errorPotential){
        response = [requestPotentials responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        //NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        if ([response objectForKey:@"result"])
        {
            
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *PotentialsDict=[result objectForKey:@"Potentials"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[PotentialsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[PotentialsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[PotentialsDict objectForKey:@"row"]];
                    
                }
            }
            
            
            
            for (int i=0; i<[FlDict count]; i++) {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                Potentials * opportunityObject = [[Potentials alloc] init];
                
                for (int j=0; j<[flArray count]; j++) {
                    NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                    
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Potential Name"])
                    {
                        opportunityObject.PotentialName = [dictionary1 objectForKey:@"content"];
                        [searchOpportunityArray addObject:opportunityObject];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"])
                    {
                        opportunityObject.PotentialDescription = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Probability"]) {
                        opportunityObject.PotentialProbability = [dictionary1 objectForKey:@"content"];
                        
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Expected Revenue"]) {
                        
                        opportunityObject.PotentialRevenue=[dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Stage"]) {
                        
                        opportunityObject.PotentialStage = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Type"]) {
                        
                        opportunityObject.PotentialType = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Closing Date"]) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
                        
                        opportunityObject.ClosingDate = [dateFormatter dateFromString:[dictionary1 objectForKey:@"content"]];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                        
                        opportunityObject.AccountName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                        
                        opportunityObject.AccountID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"POTENTIALID"]) {
                        
                        opportunityObject.PotentialID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                        
                        opportunityObject.ContactID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Contact Name"]) {
                        
                        opportunityObject.ContactName = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Amount"]) {
                        
                        opportunityObject.Amount = [dictionary1 objectForKey:@"content"];
                        
                    }
                    
                }
                
                
                NSLog(@"searchOpportunityArray : %@", searchOpportunityArray);
                [[ModelTrackingClass sharedInstance] setModelObject:searchOpportunityArray forKey:@"searchOpportunityArray"];
                
                
            }
            
        }
        
    }
    else {
        NSLog(@"Error : %@",[errorPotential localizedDescription]);
    }
    
}


/****************************************************************************************/
//	This method fetches favourite opportunites from Zoho CRM
/****************************************************************************************/

- (void)FetchOppOrtunitiesFromZoho
{
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    /*
     
     NSString *String1 = @"https://crm.zoho.com/crm/private/json/Potentials/getSearchRecords?authtoken=";
     NSString *extension1 = @"&scope=crmapi&selectColumns=Potentials(Amount,POTENTIALID,Potential Name,Closing Date,ACCOUNTID,Account Name,Stage,Type,Probability,Description,CONTACTID,Contact Name,Expected Revenue)&searchCondition=";
     (Potential Name|contains|*%@*)
     
     */
    
    //https://crm.zoho.com/crm/private/json/Potentials/getRecords?authtoken= &scope=crmapi&fromIndex=1&toIndex=2
    
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Potentials/getSearchRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&selectColumns=Potentials(Amount,POTENTIALID,Potential Name,Closing Date,ACCOUNTID,Account Name,Stage,Type,Probability,Description,CONTACTID,Contact Name,Expected Revenue, Favourite)&searchCondition=(Favourite|contains|*Yes*)";
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL *urlPotentials =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestPotentials=[[ASIHTTPRequest alloc]initWithURL:urlPotentials];
    [requestPotentials setRequestMethod:@"GET"];
    [requestPotentials addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestPotentials setTimeOutSeconds:30];
    
    [requestPotentials startSynchronous];
    
    NSError *errorPotential = [requestPotentials error];
    
    NSString *response=@"";
    
    if (!errorPotential){
        response = [requestPotentials responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        if ([response objectForKey:@"result"])
        {
            [SAppDelegateObject deleteAllObjects:@"Opportunities" ForContext:context];
            
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *PotentialsDict=[result objectForKey:@"Potentials"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[PotentialsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[PotentialsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[PotentialsDict objectForKey:@"row"]];
                    
                }
            }
            
            
            
            for (int i=0; i<[FlDict count]; i++) {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                Opportunities * opportunityObject = [NSEntityDescription
                                                     insertNewObjectForEntityForName:@"Opportunities"
                                                     inManagedObjectContext:context];;
                
                for (int j=0; j<[flArray count]; j++) {
                    NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                    
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Potential Name"])
                    {
                        opportunityObject.opportunityName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"])
                    {
                        opportunityObject.opportunityDescription = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Probability"]) {
                        opportunityObject.opportunityProbability = [dictionary1 objectForKey:@"content"];
                        
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Expected Revenue"]) {
                        
                        opportunityObject.opportunityRevenue=[dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Stage"]) {
                        
                        opportunityObject.opportunityStage = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Type"]) {
                        
                        opportunityObject.opportunityType = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Closing Date"]) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
                        
                        opportunityObject.opportunityClosingDate = [dateFormatter dateFromString:[dictionary1 objectForKey:@"content"]];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                        
                        opportunityObject.opportunityRelatedToAccountName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                        
                        opportunityObject.opportunityRelatedToAccountID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"POTENTIALID"]) {
                        
                        opportunityObject.opportunityID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                        
                        opportunityObject.opportunityRelatedToContactID = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Contact Name"]) {
                        
                        opportunityObject.opportunityRelatedToContactName = [dictionary1 objectForKey:@"content"];
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Amount"]) {
                        
                        opportunityObject.opportunityAmount = [dictionary1 objectForKey:@"content"];
                        
                    }
                    
                }
                
                NSError *error=nil;
                
               // [opportunityObject addNotesTaggedToOpportunity:[self fetchNotesForRecordID:opportunityObject.opportunityID inModule:@"Potentials"]];

                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Potentials %@", [error localizedDescription]);
                }
                
            }
            
        }
        
    }
    else {
        NSLog(@"Error : %@",[errorPotential localizedDescription]);
    }
    
}

/****************************************************************************************/
//	This method fetches related opportunities for a parent modules in Zoho CRM
/****************************************************************************************/

- (void)FetchRelatedOpportunitiesForEntity:(NSString *)parentModule :(NSString *)value
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Potentials/getSearchRecordsByPDC?authtoken=";
    NSString *extension = @"&scope=crmapi&selectColumns=Potentials(Amount,POTENTIALID,Potential Name,Closing Date,ACCOUNTID,Account Name,Stage,Type,Probability,Description,CONTACTID,Contact Name,Expected Revenue)&searchColumn=";
    NSString *extension1 = @"&searchValue=";
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", String1,self.token, extension,parentModule, extension1, value];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL *urlPotentials =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestPotentials=[[ASIHTTPRequest alloc]initWithURL:urlPotentials];
    [requestPotentials setRequestMethod:@"GET"];
    [requestPotentials addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestPotentials setTimeOutSeconds:30];
    
    [requestPotentials startSynchronous];
    
    NSError *errorPotential = [requestPotentials error];
    
    NSString *response=@"";
    
    if (!errorPotential){
        response = [requestPotentials responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        //NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        if ([response objectForKey:@"result"])
        {
            
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *PotentialsDict=[result objectForKey:@"Potentials"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[PotentialsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [PotentialsDict allKeys]) {
                if ([[PotentialsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[PotentialsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[PotentialsDict objectForKey:@"row"]];
                    
                }
            }
            
            
            
            for (int i=0; i<[FlDict count]; i++) {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                
                NSString *opportunityID;
                
                
                if ([[[flArray objectAtIndex:0] objectForKey:@"val"] isEqualToString:@"POTENTIALID"])
                {
                    opportunityID =[[flArray objectAtIndex:0] objectForKey:@"content"];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"opportunityID" InEntityWithEntityName:@"Opportunities" ForPreviousItems:opportunityID inContext:context] )
                {
                    
                    
                    Opportunities * opportunityObject = [NSEntityDescription
                                                         insertNewObjectForEntityForName:@"Opportunities"
                                                         inManagedObjectContext:context];;
                    
                    for (int j=0; j<[flArray count]; j++) {
                        NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                        
                        
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Potential Name"])
                        {
                            opportunityObject.opportunityName = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"])
                        {
                            opportunityObject.opportunityDescription = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Probability"]) {
                            opportunityObject.opportunityProbability = [dictionary1 objectForKey:@"content"];
                            
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Expected Revenue"]) {
                            
                            opportunityObject.opportunityRevenue=[dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Stage"]) {
                            
                            opportunityObject.opportunityStage = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Type"]) {
                            
                            opportunityObject.opportunityType = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Closing Date"]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
                            
                            opportunityObject.opportunityClosingDate = [dateFormatter dateFromString:[dictionary1 objectForKey:@"content"]];
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                            
                            opportunityObject.opportunityRelatedToAccountName = [dictionary1 objectForKey:@"content"];
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                            
                            opportunityObject.opportunityRelatedToAccountID = [dictionary1 objectForKey:@"content"];
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"POTENTIALID"]) {
                            
                            opportunityObject.opportunityID = [dictionary1 objectForKey:@"content"];
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                            
                            opportunityObject.opportunityRelatedToContactID = [dictionary1 objectForKey:@"content"];
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Contact Name"]) {
                            
                            opportunityObject.opportunityRelatedToContactName = [dictionary1 objectForKey:@"content"];
                            
                        }
                        if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Amount"]) {
                            
                            opportunityObject.opportunityAmount = [dictionary1 objectForKey:@"content"];
                            
                        }
                        
                    }
                    
                    NSError *error=nil;
                    
                    if (![context save:&error])
                    {
                        NSLog(@"Sorry, couldn't save Related Opportunities %@", [error localizedDescription]);
                    }
                    
                    
                }
                
                
                
                else
                {
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Opportunities" inManagedObjectContext:context]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opportunityID == %@", opportunityID];
                    [request setPredicate:predicate];
                    
                    NSError *error = nil;
                    NSArray *results = [context executeFetchRequest:request error:&error];
                    if ([results count]>0)
                    {
                        
                        Opportunities *opportunityObject=(Opportunities *)[results objectAtIndex:0];
                        for (int j=0; j<[flArray count]; j++) {
                            NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                            
                            
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Potential Name"])
                            {
                                opportunityObject.opportunityName = [dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Description"])
                            {
                                opportunityObject.opportunityDescription = [dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Probability"]) {
                                opportunityObject.opportunityProbability = [dictionary1 objectForKey:@"content"];
                                
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Expected Revenue"]) {
                                
                                opportunityObject.opportunityRevenue=[dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Stage"]) {
                                
                                opportunityObject.opportunityStage = [dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Type"]) {
                                
                                opportunityObject.opportunityType = [dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Closing Date"]) {
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // changed line in your code
                                
                                opportunityObject.opportunityClosingDate = [dateFormatter dateFromString:[dictionary1 objectForKey:@"content"]];
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"]) {
                                
                                opportunityObject.opportunityRelatedToAccountName = [dictionary1 objectForKey:@"content"];
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                                
                                opportunityObject.opportunityRelatedToAccountID = [dictionary1 objectForKey:@"content"];
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"POTENTIALID"]) {
                                
                                opportunityObject.opportunityID = [dictionary1 objectForKey:@"content"];
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"CONTACTID"]) {
                                
                                opportunityObject.opportunityRelatedToContactID = [dictionary1 objectForKey:@"content"];
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Contact Name"]) {
                                
                                opportunityObject.opportunityRelatedToContactName = [dictionary1 objectForKey:@"content"];
                                
                            }
                            if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Amount"]) {
                                
                                opportunityObject.opportunityAmount = [dictionary1 objectForKey:@"content"];
                                
                            }
                            
                            
                            
                        }
                        
                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
                        }
                        
                        
                        
                    }
                }
                
            }
            
        }
        
    }
    else {
        NSLog(@"Error : %@",[errorPotential localizedDescription]);
    }
    
    
    
}

#pragma mark Zoho Accounts - Application Accounts Mehods


/****************************************************************************************/
// This method helps in searching Accounts in Zoho CRM
/****************************************************************************************/

- (void)searchAccountsFromZoho
{
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Accounts/getSearchRecords?authtoken=";
    NSString *extension1 = @"&scope=crmapi&selectColumns=Accounts(ACCOUNTID,Account Name,Phone,Website,Account Number,Account Type,Ownership,Industry,Employees,Annual Revenue,Billing Street,Billing City,Billing State,Billing Code,Billing Country,Description,Twitterid)&searchCondition=";
    
    NSString *extension2 = [NSString stringWithFormat:@"(Account Name|contains|*%@*)",[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"AccountsearchText"]];
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension1,extension2];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * urlSearch =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestAccounts=[[ASIHTTPRequest alloc]initWithURL:urlSearch];
    [requestAccounts setRequestMethod:@"GET"];
    [requestAccounts addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestAccounts setTimeOutSeconds:30];
    
    [requestAccounts startSynchronous];
    
    NSError *errorAccounts = [requestAccounts error];
    
    NSString *response=@"";
    
    
    if (!errorAccounts){
        
        response = [requestAccounts responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        
        if ([response objectForKey:@"result"])
        {
            NSDictionary *result=[response objectForKey:@"result"];
            NSLog(@"result : %@", result);
            NSDictionary *AccountsDict=[result objectForKey:@"Accounts"];
            
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[AccountsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                    NSLog(@"fldict : %@", FlDict);
                }
                if  ([[AccountsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict  addObject:[AccountsDict objectForKey:@"row"]];
                    NSLog(@"fldict : %@", FlDict);
                    
                }
            }
            
            
//            for (int i=0; i<[FlDict count]; i++) {
//                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
//                
//                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
//                
//                SearchAccounts * AccountObject = [[SearchAccounts alloc]init];
//                
//                for (int j=0; j<[flArray count]; j++)
//                {
//                    NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
//                    
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Phone"])
//                    {
//                        AccountObject.AccountPhoneNo = [dictionary1 objectForKey:@"content"];
//                        
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"])
//                    {
//                        AccountObject.AccountName = [dictionary1 objectForKey:@"content"];
//                        [searchAccountArray addObject:AccountObject];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Number"]) {
//                        AccountObject.AccountNo = [dictionary1 objectForKey:@"content"];
//                        
//                        
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Type"]) {
//                        
//                        AccountObject.AccountType=[dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Annual Revenue"]) {
//                        
//                        AccountObject.AnnualRevenue = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Ownership"]) {
//                        
//                        AccountObject.OwnerShip = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Industry"]) {
//                        
//                        AccountObject.AccountIndustry = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"PARENTACCOUNTID"]) {
//                        
//                        AccountObject.ParentAccountId = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
//                        
//                        AccountObject.AccountID = [dictionary1 objectForKey:@"content"];
//                    }
//                    
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Employees"]) {
//                        
//                        AccountObject.employees=[dictionary1 objectForKey:@"content"];
//                        
//                    }
//                    
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Street"]) {
//                        
//                        AccountObject.MailingStreet=[dictionary1 objectForKey:@"content"];
//                        
//                    }
//                    
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing City"]) {
//                        
//                        AccountObject.MailingCity = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing State"]) {
//                        
//                        AccountObject.MailingState = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Code"]) {
//                        
//                        AccountObject.MailingZIP = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Country"]) {
//                        
//                        AccountObject.MailingCountry = [dictionary1 objectForKey:@"content"];
//                    }
//                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Website"]) {
//                        
//                        AccountObject.Website = [dictionary1 objectForKey:@"content"];
//                    }
//                    
//                }
            
                NSLog(@"searchAccountArray : %@", searchAccountArray);
                [[ModelTrackingClass sharedInstance] setModelObject:searchAccountArray forKey:@"searchAccountArray"];
            }
        }
 //   }
    
    else
    {
        NSLog(@"Error : %@",[errorAccounts localizedDescription]);
    }
    
}

/****************************************************************************************/
//	This method fetches all favourite Accounts from Zoho CRM
/****************************************************************************************/


-(void)FetchAccountsFromZoho
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    /*
     NSString *String1 = @"https://crm.zoho.com/crm/private/json/Accounts/getSearchRecords?authtoken=";
     NSString *extension1 = @"&scope=crmapi&selectColumns=Accounts(ACCOUNTID,Account Name,Phone,Website,Account Number,Account Type,Ownership,Industry,Employees,Annual Revenue,Billing Street,Billing City,Billing State,Billing Code,Billing Country,Description,Twitterid)&searchCondition=";
     (Account Name|contains|*%@*)
     */
    
    
    
    //https://crm.zoho.com/crm/private/json/Accounts/getRecords?authtoken= &scope=crmapi&fromIndex=1&toIndex=2
    
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Accounts/getSearchRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&selectColumns=Accounts(ACCOUNTID,Account Name,Phone,Website,Account Number,Account Type,Ownership,Industry,Employees,Annual Revenue,Billing Street,Billing City,Billing State,Billing Code,Billing Country,Description,Twitterid)&searchCondition=(Favourite|contains|*Yes*)";
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * urlAccounts =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestAccounts=[[ASIHTTPRequest alloc]initWithURL:urlAccounts];
    [requestAccounts setRequestMethod:@"GET"];
    [requestAccounts addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestAccounts setTimeOutSeconds:30];
    
    [requestAccounts startSynchronous];
    
    NSError *errorAccounts = [requestAccounts error];
    
    NSString *response=@"";
    
    if (!errorAccounts){
        response = [requestAccounts responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        if ([response objectForKey:@"result"])
        {
            [SAppDelegateObject deleteAllObjects:@"Accounts" ForContext:context];
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *AccountsDict=[result objectForKey:@"Accounts"];
            
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[AccountsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                    NSLog(@"fldict : %@", FlDict);
                }
                if  ([[AccountsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict  addObject:[AccountsDict objectForKey:@"row"]];
                    NSLog(@"fldict : %@", FlDict);
                    
                }
            }
            
            
            for (int i=0; i<[FlDict count]; i++) {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:@"FL"];
                
                Accounts * AccountObject = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"Accounts"
                                            inManagedObjectContext:context];;
                
                for (int j=0; j<[flArray count]; j++)
                {
                    NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Phone"])
                    {
                        AccountObject.acconuntPhoneNo = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Name"])
                    {
                        AccountObject.accountName = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Number"]) {
                        AccountObject.accountNo = [dictionary1 objectForKey:@"content"];
                        
                        
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Account Type"]) {
                        
                        AccountObject.accountType=[dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Annual Revenue"]) {
                        
                        AccountObject.annualRevenue = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Ownership"]) {
                        
                        AccountObject.accountOwnerShip = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Industry"]) {
                        
                        AccountObject.accountIndustry = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"PARENTACCOUNTID"]) {
                        
                        AccountObject.parentAccountId = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"ACCOUNTID"]) {
                        
                        AccountObject.accountID = [dictionary1 objectForKey:@"content"];
                    }
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Employees"]) {
                        
                        AccountObject.numberOfEmployees=[dictionary1 objectForKey:@"content"];
                        
                    }
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Street"]) {
                        
                        AccountObject.mailingStreet=[dictionary1 objectForKey:@"content"];
                        
                    }
                    
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing City"]) {
                        
                        AccountObject.mailingCity = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing State"]) {
                        
                        AccountObject.mailingState = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Code"]) {
                        
                        AccountObject.mailingZIP = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Billing Country"]) {
                        
                        AccountObject.mailingCountry = [dictionary1 objectForKey:@"content"];
                    }
                    if ([[dictionary1 objectForKey:@"val"] isEqualToString:@"Website"]) {
                        
                        AccountObject.accountWebSite = [dictionary1 objectForKey:@"content"];
                    }
                    
                }
                
                NSError *error=nil;

               // [AccountObject addNotesTaggedToAccount:[self fetchNotesForRecordID:AccountObject.accountID inModule:@"Accounts"]];
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Accounts %@", [error localizedDescription]);
                }

                
            }
        }
        
    }
    else {
        NSLog(@"Error : %@",[errorAccounts localizedDescription]);
    }
    
}


#pragma mark Zoho Leads - Application Leads Methods

/****************************************************************************************/
//	This method fetches favourite Leads from Zoho CRM.
/****************************************************************************************/
- (void) FetchLeadsFromZoho
{
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    //checking for inserted values.
    
    //https://crm.zoho.com/crm/private/xml/Contacts/getSearchRecords?authtoken=9e1e4655e646064ba9897579061a2947&scope=crmapi&selectColumns=Contacts(First%20Name,Last%20Name,CONTACTID,ACCOUNTID,Account%20Name,Department,Email,Phone,Date%20of%20Birth,Mailing%20Street,Mailing%20City,Mailing%20State,Mailing%20Zip,Mailing%20Country,Skype%20ID,Twitter,Linkedin,Favourite)&searchCondition=(Favourite|contains|*Yes*)
    
    //https://crm.zoho.com/crm/private/json/Contacts/getRecords?authtoken= &scope=crmapi&fromIndex=1&toIndex=1
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Leads/getSearchRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&newFormat=2&selectColumns=All&searchCondition=(Favourite|contains|*Yes*)";
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * url1 =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url1];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:ZOHO_RESPONSE_PARAMETER];
        
        if ([response objectForKey:ZOHO_RESULT_PARAMETER])
        {
            [SAppDelegateObject deleteAllObjects:LEADS_MODULE ForContext:context];
            
            NSDictionary *result=[response objectForKey:ZOHO_RESULT_PARAMETER];
            NSDictionary *leadsDict=[result objectForKey:LEADS_MODULE];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [leadsDict allKeys]) {
                if ([[leadsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[leadsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [leadsDict allKeys]) {
                if ([[leadsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[leadsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[leadsDict objectForKey:ZOHO_ROW_PARAMETER]];
                    
                }
            }
            
            
            for (int i=0; i<[FlDict count]; i++)
                
            {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:ZOHO_FL_PARAMETER];
                
                NSString *leadID;
                
                if ([[[flArray objectAtIndex:0] objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_ID_PARAMETER])
                {
                    leadID =[[flArray objectAtIndex:0] objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:LEAD_ID InEntityWithEntityName:LEADS_MODULE ForPreviousItems:leadID inContext:context] )
                {
                    
                    
                    Leads * leadObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:LEADS_MODULE
                                          inManagedObjectContext:context];
                    
                    for (int j=0; j<[flArray count]; j++)
                    {
                        NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_PHONE_PARAMETER])
                        {
                            leadObject.leadPhone = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
                        {
                            leadObject.leadFirstName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LAST_NAME_PARAMETER])
                        {
                            leadObject.leadLastName = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_ID_PARAMETER]) {
                            leadObject.leadID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            
                            
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_EMAIL_PARAMETER]) {
                            
                            leadObject.leadEmailID=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_OWNER_PARAMETER]) {
                            
                            leadObject.leadOwner = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COMPANY_PARAMETER]) {
                            
                            leadObject.leadCompany = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESIGNATION_PARAMETER]) {
                            
                            leadObject.leadTitle = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_INDUSTRY_PARAMETER]) {
                            
                            leadObject.leadIndustry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ACCOUNT_REVENUE_PARAMETER]) {
                            
                            leadObject.annualRevenue = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAX_PARAMETER]) {
                            
                            leadObject.leadFax = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_MOBILE_PARAMETER]) {
                            
                            leadObject.leadMobileNo = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_WEBSITE_PARAMETER]) {
                            
                            leadObject.leadWebsite = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_STATUS_PARAMETER]) {
                            
                            leadObject.leadStatus = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LEAD_SOURCE_PARAMETER]) {
                            
                            leadObject.leadSource = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_NUMBER_OF_EMPLOYEES_PARAMETER]) {
                            
                            leadObject.numberOfEmployees = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_RATING_PARAMETER]) {
                            
                            leadObject.leadRating = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SALUTATION_PARAMETER]) {
                            
                            leadObject.leadSalutation = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_FAVOURITE_PARAMETER]) {
                            
                            leadObject.favouriteStatus = [NSNumber numberWithBool: [[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]boolValue ]];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_SKYPE_PARAMETER]) {
                            
                            leadObject.leadSkypeID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_TWITTER_ID_PARAMETER]) {
                            
                            leadObject.leadTwitterID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_LINKEDIN_PARAMETER]) {
                            
                            leadObject.leadLinkedInID = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            leadObject.leadDescription = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_CITY_PARAMETER]) {
                            
                            leadObject.mailingCity = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_COUNTRY_PARAMETER]) {
                            
                            leadObject.mailingCountry = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STATE_PARAMETER]) {
                            
                            leadObject.mailingState = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_STREET_PARAMETER]) {
                            
                            leadObject.mailingStreet = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ZIP_CODE_PARAMETER]) {
                            
                            leadObject.mailingZIP = [dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        leadObject.leadImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Leads/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",self.token,leadObject.leadID];
                    }
                    
                    //[customerObject addNotesTaggedToLead:[self fetchNotesForRecordID:leadID inModule:LEADS_MODULE]];
                    
                    
                    if (![context save:&error])
                    {
                        NSLog(@"Sorry, couldn't save Leads %@", [error localizedDescription]);
                    }
                    
                }
                
                else
                {
                    //update All values, excpet for events tagged to leads.
                }
                
            }
        }
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
}

/****************************************************************************************/
// This method searches for a string in Leads Module of Zoho CRM.
/****************************************************************************************/

- (NSMutableArray *)searchLeadsFromZoho:(NSString *)searchString;
{
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Leads/getSearchRecords?authtoken=";
    NSString *extension1 = @"&scope=crmapi&selectColumns=All&searchCondition=";
    NSString *extension2 = [NSString stringWithFormat:@"(First Name|contains|*%@*)",searchString];
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension1,extension2];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * urlSearch =[NSURL URLWithString: urlString];
    ASIHTTPRequest *requestAccounts=[[ASIHTTPRequest alloc]initWithURL:urlSearch];
    [requestAccounts setRequestMethod:@"GET"];
    [requestAccounts addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestAccounts setTimeOutSeconds:30];
    
    [requestAccounts startSynchronous];
    
    NSError *errorAccounts = [requestAccounts error];
    
    NSString *response=@"";
    
    
    if (!errorAccounts){
        
        response = [requestAccounts responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:@"response"];
        
        
        if ([response objectForKey:@"result"])
        {
            NSDictionary *result=[response objectForKey:@"result"];
            NSDictionary *AccountsDict=[result objectForKey:@"Leads"];
            
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[AccountsDict objectForKey:key]];
                }
                
            }
            
            for (id key in [AccountsDict allKeys]) {
                if ([[AccountsDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[AccountsDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict  addObject:[AccountsDict objectForKey:@"row"]];
                    
                }
            }
            
            NSMutableArray *searchResultsArray=[[NSMutableArray alloc]init];
            
            for (int i=0; i<[FlDict count]; i++)
            {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                [searchResultsArray addObject:[dictionary objectForKey:@"FL"]];                
            }
            
            return searchResultsArray;
        }
    }
    
    else
    {
        NSLog(@"Error : %@",[errorAccounts localizedDescription]);
    }

    return nil;
}



/*****************************************************************************************/
//	This method adds an account to Zoho CRM
/*****************************************************************************************/

- (BOOL)addLeadToZohoWithDetails: (NSMutableDictionary *)details
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:LEADS_MODULE];
	[xmlWriter writeStartElement:ZOHO_ROW_PARAMETER];
    [xmlWriter writeAttribute:ZOHO_NO_PARAMETER value:@"1"];
	for(id key in [details allKeys])
    {
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:key];
        
        if([key isEqualToString:ZOHO_SKYPE_PARAMETER] || [key isEqualToString:ZOHO_EMAIL_PARAMETER] || [key isEqualToString:ZOHO_LINKEDIN_PARAMETER] ||[key isEqualToString:ZOHO_MAILING_STREET_PARAMETER] )
            [xmlWriter writeCData:[details objectForKey:key]];
        else
            [xmlWriter writeCharacters:[details objectForKey:key]];
        
        [xmlWriter writeEndElement];
        
    }

    [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
    [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:ZOHO_FAVOURITE_PARAMETER];
    [xmlWriter writeCharacters:@"Yes"];
    [xmlWriter writeEndElement];
    
	[xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];
	
	NSLog(@"%@", [xmlWriter toString]);
	
    NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Leads/insertRecords?authtoken=";
    NSString *extensionAdd = @"&scope=crmapi&xmlData=";
    NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL *urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:@"POST"];
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        if ([responseAdd rangeOfString:ZOHO_RECORD_ADDED_SUCCESSFULLY_PARAMETER].location != NSNotFound )
            return YES;        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    return NO;
}

#pragma mark Zoho Notes Module Methods

/****************************************************************************************/
//	This method adds notes for a particular record in a specified module in Zoho CRM.
/****************************************************************************************/

- (void) addNotesToRecordID:(NSString *)recordID withNoteTitle:(NSString *)title andNoteContent:(NSString *)content
{
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    
    //[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    
    
    [xmlWriter writeStartElement:@"Notes"];
    
    [xmlWriter writeStartElement:@"row"];
    
    [xmlWriter writeAttribute:@"no" value:@"1"];
    
    [xmlWriter writeStartElement:@"FL"];
    
    [xmlWriter writeAttribute:@"val" value:@"entityId"];
    
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",recordID]];
    
    [xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"FL"];
    
    [xmlWriter writeAttribute:@"val" value:@"Note Title"];
    
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",title]];
    
    [xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"FL"];
    
    [xmlWriter writeAttribute:@"val" value:@"Note Content"];
    
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",content]];
    
    [xmlWriter writeEndElement];
    
    
    
    [xmlWriter writeEndElement];
    
    [xmlWriter writeEndElement];
    
    [xmlWriter writeEndDocument];
    
    
    NSLog(@"%@", [xmlWriter toString]);
    
    
    NSString *StringAdd1 = @"https://crm.zoho.com/crm/private/xml/Notes/insertRecords?newFormat=1&authtoken=";
    
    NSString *extensionAdd = @"&scope=crmapi&xmlData=";
    
    NSString * urlStringAdd = [NSString stringWithFormat:@"%@%@%@%@", StringAdd1,self.token, extensionAdd,[xmlWriter toString]];
    
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    
    NSURL *urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    
    
    [requestAdd setRequestMethod:@"POST"];
    
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    
    [requestAdd setTimeOutSeconds:30];
    
    
    
    [requestAdd startSynchronous];
    
    
    
    NSError *errorAdd = [requestAdd error];
    
    
    
    NSString *responseAdd=@"";
    
    
    
    if (!errorAdd)
        
    {
        
        responseAdd = [requestAdd responseString];
        
        NSLog(@"response: %@",responseAdd);
        
    }
    
    
    
    else
        
    {
        
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
        
    }
    

}

/****************************************************************************************/
//	This method fetches notes for a particular record in a specified module in Zoho CRM.
/****************************************************************************************/

- (NSMutableSet *) fetchNotesForRecordID:(NSString *)recordID inModule:(NSString *)moduleName
{
    NSMutableSet *notedsForModule=[[NSMutableSet alloc]init];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Notes/getRelatedRecords?authtoken=";
    NSString *extension = [NSString stringWithFormat:@"&scope=crmapi&id=%@&parentModule=%@",recordID,moduleName];
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@", String1,self.token, extension];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"url: %@",urlString);
    
    NSURL * url1 =[NSURL URLWithString: urlString];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url1];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value: @"application/json"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response=@"";
    
    if (!error){
        response = [request responseString];
        
        NSError *jsonParsingError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        NSLog(@"res : %@", res);
        NSDictionary *response=[res objectForKey:ZOHO_RESPONSE_PARAMETER];
        
        if ([response objectForKey:ZOHO_RESULT_PARAMETER])
        {
           // [SAppDelegateObject deleteAllObjects:@"Customers" ForContext:context];
            
            NSDictionary *result=[response objectForKey:ZOHO_RESULT_PARAMETER];
            NSDictionary *notesDict=[result objectForKey:@"Notes"];
            NSMutableArray *FlArray=[[NSMutableArray alloc]init];
            NSMutableArray *FlDict=[[NSMutableArray alloc]init];
            for (id key in [notesDict allKeys]) {
                if ([[notesDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    [FlArray addObject:[notesDict objectForKey:key]];
                }
                
            }
            
            for (id key in [notesDict allKeys]) {
                if ([[notesDict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    FlDict=[FlArray objectAtIndex:0];
                }
                if  ([[notesDict objectForKey:key] isKindOfClass:[NSDictionary class]])
                {
                    
                    [FlDict addObject:[notesDict objectForKey:ZOHO_ROW_PARAMETER]];
                    
                }
            }
            
            
            for (int i=0; i<[FlDict count]; i++)
                
            {
                NSMutableDictionary *dictionary=[FlDict objectAtIndex:i];
                
                NSMutableArray* flArray=[dictionary objectForKey:ZOHO_FL_PARAMETER];
                
                NSString *noteID;
                
                if ([[[flArray objectAtIndex:0] objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ID_PARAMETER])
                {
                    noteID =[[flArray objectAtIndex:0] objectForKey:ZOHO_CONTENT_PARAMETER];
                }
                
                //checking for duplications
                
                if (![self checkAttributeWithAttributeName:@"noteID" InEntityWithEntityName:NOTES_ENTITY ForPreviousItems:noteID inContext:context] )
                {
                    
                    Notes *notesObject=[NSEntityDescription
                                        insertNewObjectForEntityForName:NOTES_ENTITY
                                        inManagedObjectContext:context];
                    
                    for (int j=0; j<[flArray count]; j++)
                    {
                        NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ID_PARAMETER])
                        {
                            notesObject.noteID=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Title"])
                        {
                            notesObject.noteTitle=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Note Content"])
                        {
                            notesObject.noteContent=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Created Time"])
                        {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            

                            notesObject.noteCreationDate=dateNew;
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Modified Time"])
                        {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                            
                            NSDate *date = [dateFormatter dateFromString:[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]];
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            NSString *dateText = [dateFormatter2 stringFromDate:date];
                            
                            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                            [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                            
                            NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                            
                            
                            notesObject.noteModifiedDate=dateNew;
                        }
                        
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"ISVOICENOTES"])
                        {
                            notesObject.isVoiceNotes= [NSNumber numberWithBool:[[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER] boolValue ]];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Modified By"])
                        {
                            notesObject.noteModifierName=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Created By"])
                        {
                            notesObject.noteCreatorName=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                        }
                        
                        notesObject.notesCRMSyncStatus=[NSNumber numberWithBool:YES];
                        notesObject.noteModule=moduleName;
                        notesObject.noteRelatedToID=recordID;
                        
                        [notedsForModule addObject:notesObject];

                    }
                    
                    
                    if (![context save:&error])
                    {
                        NSLog(@"Sorry, couldn't save notes %@", [error localizedDescription]);
                    }
                    
                
                    
                }
                
                else
                {
                   //update the existing note from CRM.
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteID == %@", noteID];
                    [request setPredicate:predicate];
                    
                    NSError *error = nil;
                    NSArray *results = [context executeFetchRequest:request error:&error];
                    
                    if ([results count]>0)
                    {
                        
                        Notes *existingNoteObject=[results objectAtIndex:0];
                        
                        
                        for (int j=0; j<[flArray count]; j++)
                        {
                            NSMutableDictionary* dictionary1=[flArray objectAtIndex:j];
                            
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:ZOHO_ID_PARAMETER])
                            {
                                existingNoteObject.noteID=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Title"])
                            {
                                existingNoteObject.noteTitle=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Note Content"])
                            {
                                existingNoteObject.noteContent=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Created Time"])
                            {
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                
                                existingNoteObject.noteCreationDate=dateNew;
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Modified Time"])
                            {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"]; // changed line in your code
                                
                                NSDate *date = [dateFormatter dateFromString:[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER]];
                                
                                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                [dateFormatter2 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                NSString *dateText = [dateFormatter2 stringFromDate:date];
                                
                                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                                [dateFormatter3 setDateFormat:@"yyyy-MMM-dd  HH:mm"]; // changed line in your code
                                
                                NSDate *dateNew = [dateFormatter3 dateFromString:dateText];
                                
                                
                                existingNoteObject.noteModifiedDate=dateNew;
                            }
                            
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"ISVOICENOTES"])
                            {
                                existingNoteObject.isVoiceNotes= [NSNumber numberWithBool:[[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER] boolValue ]];
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Modified By"])
                            {
                                existingNoteObject.noteModifierName=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            }
                            
                            if ([[dictionary1 objectForKey:ZOHO_VALUE_PARAMETER] isEqualToString:@"Created By"])
                            {
                                existingNoteObject.noteCreatorName=[dictionary1 objectForKey:ZOHO_CONTENT_PARAMETER];
                            }
                            
                            existingNoteObject.notesCRMSyncStatus=[NSNumber numberWithBool:YES];
                            existingNoteObject.noteModule=moduleName;
                            existingNoteObject.noteRelatedToID=recordID;
                            
                            [notedsForModule addObject:existingNoteObject];

                        }

                        
                        
                        if (![context save:&error])
                        {
                            NSLog(@"Sorry, couldn't save notes %@", [error localizedDescription]);
                        }
                    }
                }
            }
        }
    }
    else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }

    
    return notedsForModule;
}


/****************************************************************************************/
//	This method deletes a note in Zoho CRM.
/****************************************************************************************/

- (void)deleteNotesFromZoho:(NSString *)noteID
{
    
    NSString *String1 = @"https://crm.zoho.com/crm/private/json/Notes/deleteRecords?authtoken=";
    NSString *extension = @"&scope=crmapi&id=";
    NSString * urlStringDelete = [NSString stringWithFormat:@"%@%@%@%@", String1,self.token, extension,noteID];
    urlStringDelete=[urlStringDelete stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringDelete: %@",urlStringDelete);
    
    NSURL *urlDelete =[NSURL URLWithString: urlStringDelete];
    ASIHTTPRequest *requestDelete=[[ASIHTTPRequest alloc]initWithURL:urlDelete];
    [requestDelete setRequestMethod:@"GET"];
    [requestDelete addRequestHeader:@"Content-Type" value: @"application/json"];
    [requestDelete setTimeOutSeconds:30];
    
    [requestDelete startSynchronous];
    
    NSError *errorDelete = [requestDelete error];
    
    NSString *responseDelete=@"";
    
    if (!errorDelete){
        responseDelete = [requestDelete responseString];
        
        NSLog(@"response for Delete : %@",responseDelete );
        
    }
    else {
        NSLog(@"Error : %@",[errorDelete localizedDescription]);
    }
    
    
}




#pragma mark Zoho Update Contact, Account, Potential - Application Cusomter, Account, Opportunity

/****************************************************************************************/
//	This method updates an existing record details for three modules (Contact, Account, Potential) in Zoho CRM
/****************************************************************************************/

- (BOOL)updateDetailsForZohoEntity:(ModuleType )modulType WithID:(NSString *)entityID withDetails:(NSDictionary *)details
{
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    NSString *moduleName=@"";
    
    switch (modulType) {
        case CustomerModule:
            moduleName = ZOHO_CONTACTS_PARAMETER;
            break;
            
        case AccountsModule:
            moduleName = ZOHO_ACCOUNTS_PARAMETER;
            break;
            
        case OpportunitiesModule:
            moduleName = ZOHO_POTENTIALS_PARAMETER;
            break;
            
        case EventModule:
           moduleName = ZOHO_EVENTS_PARAMETER;
            break;
            
        case LeadModule:
            moduleName = LEADS_MODULE;
            
        default:
            break;
    }
    
    [xmlWriter writeStartElement:moduleName];
	[xmlWriter writeStartElement:ZOHO_ROW_PARAMETER];
    [xmlWriter writeAttribute:ZOHO_NO_PARAMETER value:@"1"];
    
    for(id key in [details allKeys])
    {
        [xmlWriter writeStartElement:ZOHO_FL_PARAMETER];
        [xmlWriter writeAttribute:ZOHO_VALUE_PARAMETER value:key];

        if([key isEqualToString:ZOHO_SKYPE_PARAMETER] || [key isEqualToString:ZOHO_EMAIL_PARAMETER] || [key isEqualToString:ZOHO_LINKEDIN_PARAMETER] ||[key isEqualToString:ZOHO_MAILING_STREET_PARAMETER] )
            [xmlWriter writeCData:[details objectForKey:key]];
        else
        [xmlWriter writeCharacters:[details objectForKey:key]];
        [xmlWriter writeEndElement];

    }
    
    [xmlWriter writeEndElement];
	[xmlWriter writeEndDocument];

	
	NSLog(@"%@", [xmlWriter toString]);
    
    NSString *urlStringAdd = [NSString stringWithFormat:@"https://crm.zoho.com/crm/private/xml/%@/updateRecords?authtoken=%@&scope=crmapi&id=%@&xmlData=%@",moduleName,self.token,entityID,[xmlWriter toString]];
    urlStringAdd=[urlStringAdd stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"urlStringAdd: %@",urlStringAdd);
    NSURL * urlnewAdd =[NSURL URLWithString: urlStringAdd];
    
    ASIHTTPRequest *requestAdd=[[ASIHTTPRequest alloc]initWithURL:urlnewAdd];
    
    [requestAdd setRequestMethod:@"POST"];
    [requestAdd addRequestHeader:@"Content-Type" value: @"application/xml"];
    [requestAdd setTimeOutSeconds:30];
    
    [requestAdd startSynchronous];
    
    NSError *errorAdd = [requestAdd error];
    
    NSString *responseAdd=@"";
    
    if (!errorAdd){
        responseAdd = [requestAdd responseString];
        NSLog(@"response: %@",responseAdd);
        if ([responseAdd rangeOfString:ZOHO_RECORD_UPDATED_SUCCESSFULLY_PARAMETER].location != NSNotFound )
            return YES;
        
    }
    else {
        NSLog(@"Error : %@",[errorAdd localizedDescription]);
    }
    
    return NO;
}



@end
