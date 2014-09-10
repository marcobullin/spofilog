//
//  SBWorkoutTableViewCell.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBWorkoutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
