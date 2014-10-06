
#import "SBSmallTopBottomCell.h"

@implementation SBSmallTopBottomCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"SBSmallTopBottomCell" bundle:nil];
}

- (void)render:(SBWorkoutViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.dateText;
    self.bottomLabel.textColor = viewData.dateTextColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)renderWithExerciseSetVM:(SBExerciseSetViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.setsText;
    self.bottomLabel.textColor = viewData.setsTextColor;

    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
