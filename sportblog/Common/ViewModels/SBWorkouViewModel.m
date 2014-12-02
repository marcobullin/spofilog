#import "SBWorkoutViewModel.h"
#import "UIColor+SBColor.h"

@implementation SBWorkoutViewModel

- (instancetype)initWithWorkout:(NSDictionary *)workout {
    self = [super init];
    
    if (self) {
        _nameText = [workout objectForKey:@"name"];
        _dateText = [workout objectForKey:@"date"];
        
        _nameTextColor = [UIColor headlineColor];
        _dateTextColor = [UIColor textColor];
    }
    
    return self;
}

@end
