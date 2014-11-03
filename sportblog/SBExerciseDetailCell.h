//
//  SBExerciseDetailCell.h
//  sportblog
//
//  Created by Marco Bullin on 02/11/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWorkoutViewModel.h"
#import "SBExerciseSetViewModel.h"

@interface SBExerciseDetailCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftView;
@property (weak, nonatomic) IBOutlet UIButton *rightView;


- (void)render:(SBWorkoutViewModel *)viewData;
- (void)renderWithExerciseSetVM:(SBExerciseSetViewModel *)viewData;
@end
