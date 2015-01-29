//
//  RecipesCollectionViewController.m
//  KitchenBook
//
//  Created by Tibi Kolozsi on 29/01/15.
//  Copyright (c) 2015 tibikolozsi. All rights reserved.
//

#import "RecipesCollectionViewController.h"
#import "NavigationControllerDelegate.h"
#import "KitchenBook-Swift.h"
#import <CNPGridMenu.h>


@interface RACollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIView *highlightedCover;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) CAGradientLayer* gradientLayer;

@end

@implementation RACollectionViewCell

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.highlightedCover.hidden = !highlighted;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyGradiation:self.imageView];
}

- (void)configure
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.highlightedCover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.highlightedCover.hidden = YES;
}

- (void)applyGradiation:(UIView*)gradientView
{
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
    
    self.gradientLayer = [[CAGradientLayer alloc] init];
    self.gradientLayer.frame = gradientView.bounds;
    
    self.gradientLayer.colors = @[[UIColor clearColor],[UIColor colorWithWhite:0 alpha:0.3]];
    self.gradientLayer.locations = @[@0,@1];
    
    [gradientView.layer addSublayer:self.gradientLayer];
}

@end

@interface RecipesCollectionViewController () <RAReorderableLayoutDataSource, RAReorderableLayoutDelegate, CNPGridMenuDelegate, UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray* images;

@property (nonatomic,strong) UISearchBar* searchBar;

@end

@implementation RecipesCollectionViewController

static NSString * const kReuseIdentifier = @"RecipeCell";


- (void)setupUI {
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // buttons color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]}; // title color
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)hidesSearchBar
{
//    CGSize searchSize = self.searchDisplayController.searchBar.bounds.size;
//    [self.tableView setContentOffset:CGPointMake(0, searchSize.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self hidesSearchBar];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.view addSubview:self.searchBar];
    
    
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.images = [[NSMutableArray alloc] init];
    for (int i=0; i<29; i++) {
        NSString* name = [NSString stringWithFormat:@"Sample%d.jpg",i];
        UIImage* image = [UIImage imageNamed:name];
        [self.images addObject:image];
    }
}

- (void)changeSearchBar:(BOOL)shouldShow
{
    CGPoint positionToSet;
    CGFloat desiredYPosition = self.navigationController.navigationBar.frame.size.height + 20;
    if (shouldShow) {
        positionToSet = CGPointMake(0, desiredYPosition);
    } else {
        positionToSet = CGPointMake(0, desiredYPosition - self.searchBar.frame.size.height);

    }
    self.searchBar.frame = CGRectMake(positionToSet.x, positionToSet.y, self.searchBar.frame.size.width, self.searchBar.frame.size.height);;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NavigationControllerDelegate* delegate = self.navigationController.delegate;
    if ([delegate isKindOfClass:[NavigationControllerDelegate class]]) {
        [delegate initInteractiveTransitionWithViewController:self];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    
}

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 300);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 2.0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RACollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    // configure cell
//    cell.imageView = [[UIImageView alloc] initWithImage:[self.images objectAtIndex:indexPath.item]];
    cell.imageView.image = [self.images objectAtIndex:indexPath.item];
    
    return cell;
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView allowMoveAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView numberOfItemsInSection:indexPath.section] <= 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage* image = [self.images objectAtIndex:atIndexPath.item];
    [self.images removeObjectAtIndex:atIndexPath.item];
    [self.images insertObject:image atIndex:toIndexPath.item];
    
}

- (UIEdgeInsets)scrollTrigerEdgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView reorderingItemAlphaInSection:(NSInteger)section
{
    return 0; // 0.3
}

- (UIEdgeInsets)scrollTrigerPaddingInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0);
}

#pragma mark - Actions

- (IBAction)menuButtonTouched:(id)sender {
    CNPGridMenuItem *newRecipe = [[CNPGridMenuItem alloc] init];
    newRecipe.icon = [UIImage imageNamed:@"LaterToday"];
    newRecipe.title = NSLocalizedString(@"New recipe", @"New recipe menu item");
    
    CNPGridMenuItem *allRecipes = [[CNPGridMenuItem alloc] init];
    allRecipes.icon = [UIImage imageNamed:@"ThisEvening"];
    allRecipes.title = NSLocalizedString(@"All recipes", @"All recipes menu item");
    
    CNPGridMenuItem *desserts = [[CNPGridMenuItem alloc] init];
    desserts.icon = [UIImage imageNamed:@"RecipeViewIconDessert"];
    desserts.title = NSLocalizedString(@"Desserts", @"Desserts menu item");
    
    CNPGridMenuItem *starters = [[CNPGridMenuItem alloc] init];
    starters.icon = [UIImage imageNamed:@"RecipeViewIconStarters"];
    starters.title = NSLocalizedString(@"Starters", @"Starters menu item");
    
    CNPGridMenuItem *mainCourses = [[CNPGridMenuItem alloc] init];
    mainCourses.icon = [UIImage imageNamed:@"RecipeViewIconMainCourses"];
    mainCourses.title = NSLocalizedString(@"Main courses", @"Main courses menu item");
    
    CNPGridMenuItem *soups = [[CNPGridMenuItem alloc] init];
    soups.icon = [UIImage imageNamed:@"RecipeViewIconSoup"];
    soups.title = NSLocalizedString(@"Soups", @"Soups menu item");
    
    CNPGridMenuItem *favourites = [[CNPGridMenuItem alloc] init];
    favourites.icon = [UIImage imageNamed:@"RecipeViewIconFavourites"];
    favourites.title = NSLocalizedString(@"Favourites", @"Favourites menu item");
    
    CNPGridMenu *gridMenu = [[CNPGridMenu alloc] initWithMenuItems:@[newRecipe,
                                                                     allRecipes,
                                                                     desserts,
                                                                     starters,
                                                                     mainCourses,
                                                                     soups,
                                                                     favourites]];
    gridMenu.delegate = self;
    [self presentGridMenu:gridMenu animated:YES completion:^{
        NSLog(@"Grid Menu Presented");
    }];
}

#pragma mark - CNPGridMenuDelegate methods

- (void)gridMenuDidTapOnBackground:(CNPGridMenu *)menu {
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Dismissed With Background Tap");
    }];
}

- (void)gridMenu:(CNPGridMenu *)menu didTapOnItem:(CNPGridMenuItem *)item {
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Did Tap On Item: %@", item.title);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger yOffset = scrollView.contentOffset.y;
//    NSLog(@"y offset: %ld",yOffset);
//        UIView* tb = self.searchBar;
//    if (yOffset > 0) {
//
//        tb.frame = CGRectMake(tb.frame.origin.x, 0 + yOffset, tb.frame.size.width, tb.frame.size.height);
//    }
//    if (yOffset < 1) tb.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.searchBar.frame.size.height);
    
//    NSLog(@" frame: %@",NSStringFromCGRect(self.searchBar.frame));
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // TODO : fix
    if (velocity.y < 0 && velocity.y > -1.5) {
        [self changeSearchBar:YES];
    } else {
        [self changeSearchBar:NO];
    }
    NSLog(@"frame: %@",NSStringFromCGRect(self.searchBar.frame));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"didEndDragging:willDecelerate:%@",decelerate ? @"YES" : @"NO");
}

@end
