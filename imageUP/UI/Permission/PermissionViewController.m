//
//  PermissionViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/22/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "PermissionViewController.h"
#import "Theme.h"
#import "PhotosCollectionViewController.h"
#import <Photos/Photos.h>

@interface PermissionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation PermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self requestPermission];
}

- (void)configureView {
     self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navTitle"]];
    self.settingsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    self.settingsButton.layer.cornerRadius = CornerRadius;
}

- (void)requestPermission {
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PhotosCollectionViewController *photosController = [storyboard instantiateViewControllerWithIdentifier:@"PhotosCollectionViewController"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController setViewControllers:@[photosController]];
            });
        }
    }];
}

#pragma mark - Actions

- (IBAction)settingsButtonTapped:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}


@end
