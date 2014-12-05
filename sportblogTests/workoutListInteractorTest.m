#import <XCTest/XCTest.h>
#import "SBWorkoutListInteractorIO.h"
#import "SBWorkoutDataSource.h"
#import "SBWorkoutListInteractor.h"
#import <OCMock/OCMock.h>

@interface WorkoutListInteractorTest : XCTestCase

@property (nonatomic, strong) id dataSource;
@property (nonatomic, strong) id output;
@property (nonatomic, strong) SBWorkoutListInteractor *interactor;

@end

@implementation WorkoutListInteractorTest

- (void)setUp
{
    [super setUp];
    
    self.dataSource = [OCMockObject mockForClass:[SBWorkoutDataSource class]];
    self.output = [OCMockObject mockForProtocol:@protocol(SBWorkoutListInteractorOutput)];
    
    self.interactor = [SBWorkoutListInteractor new];
    self.interactor.datasource = self.dataSource;
    self.interactor.output = self.output;
}

- (void)tearDown
{
    [self.dataSource verify];
    [self.output verify];
    
    [super tearDown];
}

- (void)testExample
{
    NSDate *date = [NSDate date];
    SBWorkout *workout = [SBWorkout new];
    workout.workoutId = @"Some ID";
    workout.name = @"WorkoutName";
    workout.date = date;
    
    [[[self.dataSource stub] andReturn:workout] createWorkoutWithName:OCMOCK_ANY andDate:OCMOCK_ANY];
    
    NSDictionary *expected = @{
                               @"workoutId" : @"Some ID",
                               @"name" : @"WorkoutName",
                               @"date" : date
                               };
    
    [[self.output expect] workoutCreated:expected];
    
    [self.interactor createWorkout];
}

@end
