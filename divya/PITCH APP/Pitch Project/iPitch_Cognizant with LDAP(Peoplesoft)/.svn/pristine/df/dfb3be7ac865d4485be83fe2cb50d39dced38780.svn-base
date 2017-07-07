//
//  Twitter.m
//  iPitch V2
//
//  Created by Vineet on 07/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "Twitter.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "ModelTrackingClass.h"
#import "iPitchConstants.h"

@implementation Twitter

+ (void)getTweetsFortwitterID:(NSString *)twitterID

{
    
    NSString * url1 = @"https://api.twitter.com/1.1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=@satheeshwaran";
    NSString * url2 = @"&count=10";
    NSString * finalURL = [NSString stringWithFormat:@"%@%@",url1, url2 ];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:finalURL] parameters:nil requestMethod:TWRequestMethodGET];
	
	// Perform the request created above and create a handler block to handle the response.
    NSMutableArray *tweetsArray=[[NSMutableArray alloc]init];
    
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		
        // Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
        NSArray *publicTimeline;
        NSError *jsonParsingError = nil;
        if (responseData)
        {
        publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
        NSLog(@"publicTimeline : %@", publicTimeline);
        }
        
        if ([publicTimeline isKindOfClass:[NSArray class]])
        {
            
            for (int i =0; i<[publicTimeline count]; i++)
            {
                NSMutableDictionary *twitterDict=[[NSMutableDictionary alloc]init];
                
                if ([[publicTimeline objectAtIndex:i] objectForKey:@"text"])
                {
                    NSLog(@"ID: %@", [[publicTimeline objectAtIndex:i] objectForKey:@"text"]);
                    [twitterDict setObject:[[publicTimeline objectAtIndex:i] objectForKey:@"text"] forKey:@"text"];
                }
                if ([[publicTimeline objectAtIndex:i] objectForKey:@"created_at"])
                {
                    NSLog(@"ID: %@", [[publicTimeline objectAtIndex:i] objectForKey:@"created_at"]);
                    [twitterDict setObject:[[publicTimeline objectAtIndex:i] objectForKey:@"created_at"]
                                    forKey:@"created_at"];
                }
                
                if ([[publicTimeline objectAtIndex:i] objectForKey:@"user"])
                {
                    NSLog(@"ID: %@", [[publicTimeline objectAtIndex:i] objectForKey:@"created_at"]);
                    [twitterDict setObject:[[[publicTimeline objectAtIndex:i] objectForKey:@"user"]objectForKey:@"profile_image_url"]
                                    forKey:@"profile_image_url"];
                }

                
                [tweetsArray addObject:twitterDict];
                NSLog(@"tweets:%@", tweetsArray);
                
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tweetsLoaded" object:tweetsArray];
        
        //        [[ModelTrackingClass sharedInstance] setModelObject:twitterDict forKey:@"tweets"];
    }];
    
    
    
}

@end
