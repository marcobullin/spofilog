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
    int statisticCountOfSets = 0;
    float statisticMinWeight = 0;
    float statisticMaxWeight = 0;
    for (int i = 0; i < [exercises count]; i++) {
        SBExerciseSet *exercise = [exercises objectAtIndex:i];
        
        statisticCountOfSets += [exercise.sets count];
        
        for (int j = 0; j < [exercise.sets count]; j++) {
            SBSet *set = [exercise.sets objectAtIndex:j];
            
         
            if (statisticMinWeight == 0 || set.weight < statisticMinWeight) {
                statisticMinWeight = set.weight;
            }
            
            if (set.weight > statisticMaxWeight) {
                statisticMaxWeight = set.weight;
            }
            
            [reps addObject:[NSNumber numberWithInt:set.repetitions]];
            [weights addObject:[NSNumber numberWithFloat:set.weight]];
            [labels addObject:[self.dateFormatter stringFromDate:exercise.date]];
            count++;
        }
    }
    CGRect frame = CGRectMake(20, 44, self.view.frame.size.width - 20, self.view.frame.size.height/2);
    
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
    
    
    UILabel *statSetsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.lineChartView.frame.origin.y + self.lineChartView.frame.size.height, self.view.frame.size.width, 44)];
    
    statSetsLabel.text = [NSString stringWithFormat:@"Count of Sets: %d", statisticCountOfSets];
    
    [self.view addSubview:statSetsLabel];
    
    UILabel *statMinWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, statSetsLabel.frame.origin.y + statSetsLabel.frame.size.height, self.view.frame.size.width, 44)];
    
    statMinWeightLabel.text = [NSString stringWithFormat:@"You startet with %.01fkg", statisticMinWeight];
    
    [self.view addSubview:statMinWeightLabel];
    
    UILabel *statMaxWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, statMinWeightLabel.frame.origin.y + statMinWeightLabel.frame.size.height, self.view.frame.size.width, 44)];
    
    statMaxWeightLabel.text = [NSString stringWithFormat:@"Now you can handle %.01fkg", statisticMaxWeight];
    
    [self.view addSubview:statMaxWeightLabel];
    
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
