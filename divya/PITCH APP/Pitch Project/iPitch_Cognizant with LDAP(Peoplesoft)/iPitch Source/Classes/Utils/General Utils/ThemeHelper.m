//
//  ThemeHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ThemeHelper.h"
#import "Utils.h"
#import "iPitchConstants.h"

@implementation ThemeHelper

+(void)setCurrentTheme:(NSString *)themeName
{
    [Utils userDefaultsSetObject:themeName forKey:IPITCH_CURRENT_THEME_NAME];
    
    if([themeName isEqualToString:IPITCH_THEME1_NAME])
    [Utils userDefaultsSetObject:IPITCH_THEME2_BG forKey:IPITCH_CURRENT_THEME_BG_IMAGE];
    else
        [Utils userDefaultsSetObject:IPITCH_THEME2_BG forKey:IPITCH_CURRENT_THEME_BG_IMAGE];
    
}

+(void)applyCurrentThemeToView
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
    
        [[UIBarButtonItem appearance] setTintColor:[Utils colorFromHexString:IPITCH_THEME1_NAVITEM_TINT_COLOR_CODE]];
    //customising Toolbar for all places.
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:IPITCH_THEME1_NAV_BAR_IMAGE] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    //customising UINavigationBar for all places.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:IPITCH_THEME1_NAV_BAR_IMAGE] forBarMetrics: UIBarMetricsDefault];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIColor blackColor],
                                                 UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    }
    
    else
    {
        
        [[UIBarButtonItem appearance] setTintColor:[Utils colorFromHexString:IPITCH_THEME2_NAVITEM_TINT_COLOR_CODE]];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:IPITCH_THEME2_NAV_BAR_IMAGE] forBarMetrics: UIBarMetricsDefault];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   [UIColor blackColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
        
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:IPITCH_THEME2_NAV_BAR_IMAGE] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        

    }

}
@end
