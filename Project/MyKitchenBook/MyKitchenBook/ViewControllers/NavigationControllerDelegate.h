//
//  NavigationControllerDelegate.h
//  KitchenBook
//
//  Created by Tibi Kolozsi on 23/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CBStoreHouseTransition.h"

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) CBStoreHouseTransitionAnimator *animator;
@property (nonatomic, strong) CBStoreHouseTransitionInteractiveTransition *interactiveTransition;


- (void)initInteractiveTransitionWithViewController:(UIViewController*)viewController;
@end
