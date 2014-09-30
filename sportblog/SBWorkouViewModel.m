#import "SBWorkoutViewModel.h"

@implementation SBWorkoutViewModel

- (instancetype)initWithWorkout:(SBWorkout *)workout {
    self = [super init];
    
    if (self) {
        _nameText = workout.name;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

        _dateText = [dateFormatter stringFromDate:workout.date];
    }
    
    return self;
}

@end
