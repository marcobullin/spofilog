#import "SBWorkoutViewModel.h"
#import "UIColor+SBColor.h"

@implementation SBWorkoutViewModel

- (instancetype)initWithWorkout:(SBWorkout *)workout {
    self = [super init];
    
    if (self) {
        _nameText = workout.name;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

        _dateText = [dateFormatter stringFromDate:workout.date];
        
        _nameTextColor = [UIColor textColor];
        _dateTextColor = [UIColor textColor];
    }
    
    return self;
}

@end
