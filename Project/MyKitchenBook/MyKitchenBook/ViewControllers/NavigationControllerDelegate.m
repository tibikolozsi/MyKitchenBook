//
//  NavigationControllerDelegate.m
//  KitchenBook
//
//  Created by Tibi Kolozsi on 23/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//
#import "NavigationControllerDelegate.h"

@interface NavigationControllerDelegate ()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;

@end

@implementation NavigationControllerDelegate

- (void)initInteractiveTransitionWithViewController:(UIViewController*)viewController
{
    self.interactiveTransition = [[CBStoreHouseTransitionInteractiveTransition alloc] initWithViewController:viewController];
}

#pragma mark - Navigation Controller Delegate

- (void)awakeFromNib {
    [super awakeFromNib];
    // Do any additional setup after loading the view, typically from a nib.
    self.animator = [[CBStoreHouseTransitionAnimator alloc] init];
    
    self.interactiveTransition = [[CBStoreHouseTransitionInteractiveTransition alloc] init];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.animator.type = AnimationTypePush;
            return self.animator;
        case UINavigationControllerOperationPop:
            self.animator.type = AnimationTypePop;
            return self.animator;
        default:
            return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.animator.type == AnimationTypePush || !self.interactiveTransition.isPanned) {
        // we don't need interactive transition for push and pop with back button
        return nil;
    } else {
        return self.interactiveTransition;
    }
}


@end
