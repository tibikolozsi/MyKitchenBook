//
//  RecipesViewController.m
//  KitchenBook
//
//  Created by Tibi Kolozsi on 23/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

#import "RecipesViewController.h"
#import "NavigationControllerDelegate.h"
#import "RecipeTableViewCell.h"
#import <CNPGridMenu.h>

@interface RecipesViewController () <CNPGridMenuDelegate>

@property (nonatomic, strong) CNPGridMenu *gridMenu;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation RecipesViewController

- (void)viewWillAppear:(BOOL)animated {
    [self setupUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self hidesSearchBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NavigationControllerDelegate* delegate = self.navigationController.delegate;
    if ([delegate isKindOfClass:[NavigationControllerDelegate class]]) {
        [delegate initInteractiveTransitionWithViewController:self];
    }
}

- (void)setupUI {
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // buttons color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]}; // title color
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)hidesSearchBar
{
    CGSize searchSize = self.searchDisplayController.searchBar.bounds.size;
    [self.tableView setContentOffset:CGPointMake(0, searchSize.height)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    
    NSString* string = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.backgroundImage.image = [UIImage imageNamed:string];
    
    // Configure the cell...
 
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}



@end
