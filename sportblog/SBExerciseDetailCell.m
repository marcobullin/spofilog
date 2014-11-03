//
//  SBExerciseDetailCell.m
//  sportblog
//
//  Created by Marco Bullin on 02/11/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBExerciseDetailCell.h"

@implementation SBExerciseDetailCell

- (void)render:(SBWorkoutViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.dateText;
    self.bottomLabel.textColor = viewData.dateTextColor;
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)renderWithExerciseSetVM:(SBExerciseSetViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.setsText;
    self.bottomLabel.textColor = viewData.setsTextColor;
    
    self.backgroundColor = [UIColor clearColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
