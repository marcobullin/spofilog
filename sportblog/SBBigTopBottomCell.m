//
//  SBWorkoutTableViewCell.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBBigTopBottomCell.h"
#import "UIColor+SBColor.h"

@implementation SBBigTopBottomCell

- (void)render:(SBWorkoutViewModel *)viewData {
    _topLabel.text = viewData.nameText;
    _topLabel.textColor = [UIColor whiteColor];
    
    _bottomLabel.text = viewData.dateText;
    _bottomLabel.textColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor importantCellColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
