//
//  FilterSelectionTableViewController.m
//  imageUP
//
//  Created by Steven Bishop on 12/20/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

#import "FilterSelectionCollectionViewController.h"
#import "FilterSelectionCollectionViewCell.h"


typedef NS_ENUM(NSInteger, Filter) {
    FilterSepia,
    FilterInvert,
    FilterPosterize,
    FilterMonochrome,
    FilterBlur,
    FilterFade,
    FilterNoir,
    FilterCrystallize,
    FilterInstant,
    FilterComic,
    FilterCount
};

@interface FilterSelectionCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray <NSString *> *filters;
@property (weak, nonatomic) id <FilterDelegate> delegate;
@end

@implementation FilterSelectionCollectionViewController

+ (instancetype)buildWithDelegate:(id<FilterDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([FilterSelectionCollectionViewController class]) bundle:nil];
    FilterSelectionCollectionViewController *filterContoller = storyboard.instantiateInitialViewController;
    filterContoller.filters = @[@"CISepiaTone", @"CIColorInvert", @"CIColorPosterize", @"CIColorMonochrome", @"CIMotionBlur", @"CIPhotoEffectFade", @"CIPhotoEffectNoir", @"CICrystallize", @"CIPhotoEffectInstant", @"CIComicEffect"];
    filterContoller.delegate = delegate;
    filterContoller.title = NSLocalizedString(@"FilterSelectionViewController.Title", nil);
    return filterContoller;
}

- (NSString *)displayNameForFilter:(Filter)filter {
    switch (filter) {
        case FilterSepia:
            return @"Sepia";
        case FilterInvert:
            return @"Color Invert";
        case FilterPosterize:
            return @"Posterize";
        case FilterMonochrome:
            return @"Monochrome";
        case FilterBlur:
            return @"Motion Blur";
        case FilterFade:
            return @"Fade";
        case FilterNoir:
            return @"Noir";
        case FilterCrystallize:
            return @"Crystallize";
        case FilterInstant:
            return @"Instant";
        case FilterComic:
            return @"Comic";
        default:
            NSLog(@"Display name case %li not handled", (long)filter);
            return @"";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FilterSelectionCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([FilterSelectionCollectionViewCell class])];
    CGSize screenSize = self.view.frame.size;
    NSInteger numberOfColumns = 2;
    double cellDimension = ((screenSize.width - (self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right)) / numberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

- (void)setupNavigationBar {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Cancel", nil).uppercaseString
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionButton.Reset", nil).uppercaseString
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reset)];
    self.navigationItem.leftBarButtonItem = resetButton;
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)reset {
    [self.delegate didSelectFilter:nil];
    [self dismiss];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return FilterCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FilterSelectionCollectionViewCell class])
                                                                                        forIndexPath:indexPath];
    NSString *filterName = [self displayNameForFilter:indexPath.item];
    [cell configureWithFilterName:filterName];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filterName = self.filters[indexPath.item];
    [self.delegate didSelectFilter:filterName];
    [self dismiss];
}

@end
