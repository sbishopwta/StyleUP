//
//  AppDelegate+Appearance.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "AppDelegate+Appearance.h"
#import "Theme.h"

@implementation AppDelegate (Appearance)

-(void)setupTheme {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navImgOverlay"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 145, 0, 0) resizingMode:UIImageResizingModeTile] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                         NSFontAttributeName: [UIFont primarySemiBoldFont]};
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor themeBrownColor],
                              NSFontAttributeName : [UIFont primaryFont],} forState:UIControlStateNormal];
}

@end
