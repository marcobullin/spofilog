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

    NSArray *frontImageNames;
    NSArray *backImageNames;
    if (viewData.frontImages != nil && ![viewData.frontImages isEqualToString:@""]) {
        frontImageNames = [viewData.frontImages componentsSeparatedByString: @","];
    }
    
    if (viewData.backImages != nil && ![viewData.backImages isEqualToString:@""]) {
        backImageNames = [viewData.backImages componentsSeparatedByString: @","];
    }
    
    if ([backImageNames count] > 0) {
        for (NSString *imageName in backImageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [self.rightView addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"back"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [self.rightView addSubview:imageView];
    }
    
    if ([frontImageNames count] > 0) {
        for (NSString *imageName in frontImageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [self.leftView addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"front"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [self.leftView addSubview:imageView];
    }
}

@end
