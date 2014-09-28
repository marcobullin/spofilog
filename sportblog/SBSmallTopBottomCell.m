
#import "SBSmallTopBottomCell.h"

@implementation SBSmallTopBottomCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"SBSmallTopBottomCell" bundle:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
