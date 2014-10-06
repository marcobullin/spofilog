//
//  SBAddExerciseTableViewCell.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAddEntryViewModel.h"

@interface SBAddEntryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addEntryLabel;

- (void)render:(SBAddEntryViewModel *)viewData;

@end
