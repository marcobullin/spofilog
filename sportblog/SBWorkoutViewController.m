//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutViewController.h"
#import "SBWorkoutTableViewCell.h"
#import "SBAddExerciseTableViewCell.h"
#import "SBExerciseTableViewCell.h"

@interface SBWorkoutViewController ()

@end

@implementation SBWorkoutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Workout", nil);
    
    self.tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
        SBWorkoutTableViewCell *cell = (SBWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBWorkoutTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.workoutLabel.text = @"Workout vom 22.03.2012";
        
        return cell;
    
}

@end
