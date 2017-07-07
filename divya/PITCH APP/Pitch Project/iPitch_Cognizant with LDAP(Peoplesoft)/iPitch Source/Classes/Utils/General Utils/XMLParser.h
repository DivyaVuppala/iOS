//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductCategory.h"
#import "Opportunity.h"
#import "products.h"
#import "SearchAccounts.h"
#import "ModelTrackingClass.h"

typedef enum  {
	Categories = 0,
    Products = 1,
    Opport = 2,
    Account = 3,
    Authentication = 4,
    CreateOpportunity = 5
} ParsingType;


@interface XMLParser : NSObject<NSXMLParserDelegate> {

	NSMutableString *currentElementValue;
    Product *productObject;
    ProductCategory *categoryObject;
    Opportunity *opportunityObject;
    products *objProduct;
    SearchAccounts *objAcnt;
    BOOL IsAuthenticated;
	
}
@property (nonatomic,strong)NSMutableArray *resultsArray;
@property (nonatomic,assign)ParsingType parsingType;
@property (nonatomic) BOOL IsAuthenticated;
- (XMLParser *) initXMLParser;

@end
