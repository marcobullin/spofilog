//
//  SBExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWorkout.h"
#import "SBExercisesViewController.h"

@class SBWorkoutViewController;

@protocol SBWorkoutViewControllerDelegate <NSObject>
- (void)addWorkoutViewController:(SBWorkoutViewController *)controller newWorkout:(SBWorkout *)workout;
@end

@interface SBWorkoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SBExerciseViewControllerDelegate>

- (IBAction)onWorkoutCompleted:(id)sender;
- (IBAction)onCancelWorkout:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SBWorkout *workout;
@property (nonatomic, weak) id <SBWorkoutViewControllerDelegate> delegate;
@end
