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

        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"EEEE"];
        
        NSString *day = [dateFormatter2 stringFromDate:workout.date];
        _dateText = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:workout.date]];
        
        _nameTextColor = [UIColor headlineColor];
        _dateTextColor = [UIColor textColor];
    }
    
    return self;
}

@end
