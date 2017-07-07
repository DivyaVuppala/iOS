//
//  ThemeHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeHelper : NSObject

+(void)setCurrentTheme:(NSString *)themeName;
+(void)applyCurrentThemeToView;

@end
