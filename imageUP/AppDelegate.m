//
//  AppDelegate.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "AppDelegate.h"
#import "Theme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navImgOverlay"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 145, 0, 0) resizingMode:UIImageResizingModeTile] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                     NSFontAttributeName: [UIFont primarySemiBoldFont]};
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor themeBrownColor],
                              NSFontAttributeName : [UIFont primaryFont],} forState:UIControlStateNormal];

    return YES;
}

@end
