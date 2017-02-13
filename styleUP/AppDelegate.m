//
//  AppDelegate.m
//  styleUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Appearance.h"
#import <Photos/Photos.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self setupTheme];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PermissionViewController" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
