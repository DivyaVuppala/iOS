//
//  Created by Robert Wijas on 8/6/12.
//


#import "BoxTag.h"


@implementation BoxTag {

}

@synthesize name = _name;
@synthesize tagId = _tagId;


- (void)dealloc {
    [_name release];
    [_tagId release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)values {
    if (self = [super init]) {
        [self setAttributesDictionary:values];
    }

    return self;
}

- (void)setAttributesDictionary:(NSDictionary *)dictionary {
    self.tagId = [dictionary objectForKey:@"id"];
    self.name = [dictionary objectForKey:@"name"];
}

@end
