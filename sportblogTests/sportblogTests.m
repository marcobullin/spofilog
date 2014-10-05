//
//  sportblogTests.m
//  sportblogTests
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Realm/Realm.h>
#import "SBWorkout.h"

@interface sportblogTests : XCTestCase

@end

@implementation sportblogTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    // SBWorkout *workout = [SBWorkout new];
    // workout.name = @"MyWorkout";
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    //RLMArray *foo = [SBWorkout allObjects];
    [realm commitWriteTransaction];
    
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
