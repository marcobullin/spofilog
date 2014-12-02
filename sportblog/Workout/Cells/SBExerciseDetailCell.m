#import "SBExerciseDetailCell.h"

@implementation SBExerciseDetailCell

- (void)render:(SBWorkoutViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.dateText;
    self.bottomLabel.textColor = viewData.dateTextColor;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)renderWithExerciseSetVM:(SBExerciseSetViewModel *)viewData {
    self.topLabel.text = viewData.nameText;
    self.topLabel.textColor = viewData.nameTextColor;
    
    self.bottomLabel.text = viewData.setsText;
    self.bottomLabel.textColor = viewData.setsTextColor;
    
    self.backgroundColor = [UIColor clearColor];
    
    if ([viewData.backImages count] > 0) {
        for (NSString *imageName in viewData.backImages) {
            UIImage *image = [UIImage imageNamed:imageName];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [self.rightView addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"back"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [self.rightView addSubview:imageView];
    }
    
    if ([viewData.frontImages count] > 0) {
        for (NSString *imageName in viewData.frontImages) {
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setImage:image];
            
            [self.leftView addSubview:imageView];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"front"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setImage:image];
        
        [self.leftView addSubview:imageView];
    }
}

@end
