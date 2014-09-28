#import <UIKit/UIKit.h>

@interface SBSmallTopBottomCell : UITableViewCell

+ (UINib *)nib;

@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;

@end