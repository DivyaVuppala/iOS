//
//  XMLParser.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "XMLParser.h"
#import "Product.h"

@implementation XMLParser
@synthesize parsingType;
@synthesize IsAuthenticated;

- (XMLParser *) initXMLParser {
	
	self=[super init];

	return self;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
    switch (self.parsingType) {
        case Products:
        {
            if([elementName isEqualToString:@"PRODUCTS"]) {
                //Initialize the array.
                self.resultsArray = [[NSMutableArray alloc] init];
            }
            else if([elementName isEqualToString:@"PRODUCT"]) {
                
                productObject = [[Product alloc] init];
            }
            break;
        }
            
        case Categories:
        {
            if([elementName isEqualToString:@"CATEGORIES"]) {
                //Initialize the array.
                self.resultsArray = [[NSMutableArray alloc] init];
            }
            else if([elementName isEqualToString:@"CATEGORY"]) {
                
                categoryObject = [[ProductCategory alloc] init];
            }
            break;
        }
            
        case Opport:
        {
            if([elementName isEqualToString:@"task"]) {
                //Initialize the array.
                self.resultsArray = [[NSMutableArray alloc] init];
            }
            else if([elementName isEqualToString:@"item"]) {
                
                opportunityObject = [[Opportunity alloc] init];
                opportunityObject.productArray = [[NSMutableArray alloc] init];
            }
            else if([elementName isEqualToString:@"ProductGroup"]) {
                
                objProduct        = [[products alloc]init];
            }
            break;
        }
            
        case Account:
        {
            if([elementName isEqualToString:@"task"]) {
                //Initialize the array.
                self.resultsArray = [[NSMutableArray alloc] init];
            }
            else if([elementName isEqualToString:@"item"]) {
                
                objAcnt = [[SearchAccounts alloc] init];
            }
            
            break;
        }
            
              default:
            break;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
    //to eliminate white spaces and lines
    NSString *foundString=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:foundString];
	else
		[currentElementValue appendString:foundString];
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
    switch (self.parsingType) {
            
        case Products:
        {
            if([elementName isEqualToString:@"PRODUCTS"])
                return;
            
            if([elementName isEqualToString:@"PRODUCT"]) {
                [self.resultsArray addObject:productObject];
                
                productObject = nil;
            }
            else
                [productObject setValue:currentElementValue forKey:elementName];
            
            currentElementValue = nil;
            break;
        }
            
        case Categories:
        {
            if([elementName isEqualToString:@"CATEGORIES"])
                return;
            
            if([elementName isEqualToString:@"CATEGORY"]) {
                [self.resultsArray addObject:categoryObject];
                
                categoryObject = nil;
            }
            else
                [categoryObject setValue:currentElementValue forKey:elementName];
            
            currentElementValue = nil;
            break;
            
        }
            
        case Opport:
        {
            if([elementName isEqualToString:@"task"])
                return;
            
            if([elementName isEqualToString:@"item"]) {
                [self.resultsArray addObject:opportunityObject];
                
                opportunityObject = nil;
            }
            else if([elementName isEqualToString:@"EstimatedClosedate"])
            {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"yyyy-mm-dd"];
                NSDate *closeDate = [dateFormat dateFromString:currentElementValue];
                [dateFormat setDateFormat:@"mm/dd/yyyy"];
                [opportunityObject setValue:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:closeDate]] forKey:@"EstimatedClosedate"];
            }
            else if([elementName isEqualToString:@"ProductGroup"]) {
                
                [opportunityObject.productArray addObject:objProduct];
                objProduct = nil;
            }
            else if([elementName isEqualToString:@"Productid"]) {
                
                [objProduct setValue:currentElementValue forKey:elementName];
            }
            else if([elementName isEqualToString:@"Productdescription"]) {
                
                [objProduct setValue:currentElementValue forKey:elementName];
            }
            else if([elementName isEqualToString:@"Splitpercentage"]) {
                
                [objProduct setValue:currentElementValue forKey:elementName];
            }
            else if([elementName isEqualToString:@"Primaryflag"]) {
                
                [objProduct setValue:currentElementValue forKey:elementName];
            }
            else
                [opportunityObject setValue:currentElementValue forKey:elementName];
            
            currentElementValue = nil;
            break;
            
        }
            
        case Account:
        {
            if([elementName isEqualToString:@"task"])
                return;
            
            if([elementName isEqualToString:@"item"]) {
                [self.resultsArray addObject:objAcnt];
                
                objAcnt = nil;
            }
            else
                [objAcnt setValue:currentElementValue forKey:elementName];
            
            currentElementValue = nil;
            break;
            
        }
            
        case Authentication:
        {
            if([elementName isEqualToString:@"IsAuthenticated"])
            {
                IsAuthenticated = [currentElementValue boolValue];
            }
            
            if([elementName isEqualToString:@"Name"])
                [[ModelTrackingClass sharedInstance] setUserName:currentElementValue];
                
                currentElementValue = nil;
                break;
                
        }
            
        case CreateOpportunity:
        {
            if([elementName isEqualToString:@"OpportunityID"] && currentElementValue)
            {
                opportunityObject.OpportunityId = currentElementValue;
                  
                [[ModelTrackingClass sharedInstance] setOppID:currentElementValue];
                
                NSLog(@"%@",[[ModelTrackingClass sharedInstance] oppID]);
            }
             
            currentElementValue = nil;
            break;
        }
            
        default:
            break;
    }
    }

- (void) dealloc {
	
}

@end
