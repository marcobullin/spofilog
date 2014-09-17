//
//  SBStatisticViewController.m
//  sportblog
//
//  Created by Marco Bullin on 16/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBStatisticViewController.h"
#import "SBExerciseSet.h"
#import "PCHalfPieChart.h"

@interface SBStatisticViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SBStatisticViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    self.navigationItem.title = self.exerciseName;
    
    NSMutableArray *reps = [[NSMutableArray alloc] init];
    NSMutableArray *weights = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    RLMArray *exercises = [SBExerciseSet objectsWhere:[NSString stringWithFormat:@"name = '%@'", self.exerciseName]];
    
    int count = 1;
    for (int i = 0; i < [exercises count]; i++) {
        SBExerciseSet *exercise = [exercises objectAtIndex:i];
        
        for (int j = 0; j < [exercise.sets count]; j++) {
            SBSet *set = [exercise.sets objectAtIndex:j];
            
            [reps addObject:[NSNumber numberWithInt:set.repetitions]];
            [weights addObject:[NSNumber numberWithFloat:set.weight]];
            [labels addObject:[self.dateFormatter stringFromDate:exercise.date]];
            count++;
        }
    }
    CGRect frame = CGRectMake(0, 44, [self.view bounds].size.width-20,[self.view bounds].size.height-44);
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:frame];
    [self.lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.lineChartView setInterval:5.0];
    self.lineChartView.autoscaleYAxis = YES;
    
    if (count <= 4) {
        self.lineChartView.numXIntervals = 1;
    } else {
        self.lineChartView.numXIntervals = ceil(count/3) ;
    }
    
    [self.view addSubview:self.lineChartView];
    
    NSMutableArray *components = [NSMutableArray array];

    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setPoints:weights];
    [components addObject:component];
    
    [self.lineChartView setComponents:components];
    [self.lineChartView setXLabels:labels];
}
- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.lineChartView setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.lineChartView removeFromSuperview];// = nil;
}

@end
