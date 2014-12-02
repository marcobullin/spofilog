#import <UIKit/UIKit.h>
#import "SBWorkoutViewModel.h"
#import "SBExerciseSetViewModel.h"

@interface SBSmallTopBottomCell : UITableViewCell

+ (UINib *)nib;

@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;

- (void)render:(SBWorkoutViewModel *)viewData;
- (void)renderWithExerciseSetVM:(SBExerciseSetViewModel *)viewData;

@end