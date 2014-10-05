#import <UIKit/UIKit.h>
#import "SBWorkoutViewModel.h"

@interface SBSmallTopBottomCell : UITableViewCell

+ (UINib *)nib;

@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;

- (void)render:(SBWorkoutViewModel *)viewData;

@end