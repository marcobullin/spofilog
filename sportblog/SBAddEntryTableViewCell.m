//
//  SBAddExerciseTableViewCell.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBAddEntryTableViewCell.h"

@implementation SBAddEntryTableViewCell

- (void)render:(SBAddEntryViewModel *)viewData {
    self.addEntryLabel.text = viewData.text;
    self.backgroundColor = viewData.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
