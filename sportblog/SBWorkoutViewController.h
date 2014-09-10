//
//  SBExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBWorkoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)onWorkoutCompleted:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
