//
//  SBEditWorkoutTableViewCell.h
//  sportblog
//
//  Created by Bullin, Marco on 10.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBEditWorkoutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *workoutTextField;
@end
