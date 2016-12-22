//
//  AppDelegate.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Appearance.h"
#import <Photos/Photos.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self setupTheme];
    UIViewController *controller;
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        controller = storyboard.instantiateInitialViewController;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PermissionViewController" bundle:nil];
        controller = storyboard.instantiateInitialViewController;
    }
    
    [[self window] setRootViewController:controller];
    [[self window] makeKeyAndVisible];
    
    return YES;
}

@end
