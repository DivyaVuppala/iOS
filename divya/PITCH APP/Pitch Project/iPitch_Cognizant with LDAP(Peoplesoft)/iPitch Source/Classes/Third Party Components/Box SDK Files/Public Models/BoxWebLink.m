//
//  Created by Robert Wijas on 8/6/12.
//


#import "BoxWebLink.h"


@implementation BoxWebLink {

}



@synthesize url = _url;

- (void)setValuesWithDictionary:(NSDictionary *)values {
    [super setValuesWithDictionary:values];
    if ([values objectForKey:@"url"]) {
    	self.url = [values objectForKey:@"url"];
    }
}


- (void)dealloc {
    [_url release];
    [super dealloc];
}

@end
