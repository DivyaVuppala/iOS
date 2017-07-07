//
//  Created by Robert Wijas on 8/6/12.
//


#import <Foundation/Foundation.h>


@interface BoxTag : NSObject

@property(nonatomic, retain)NSString *tagId;
@property(nonatomic, retain)NSString *name;

- (id)initWithDictionary:(NSDictionary *)values;
- (void)setAttributesDictionary:(NSDictionary *)attributes;

@end
