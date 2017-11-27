//
//  main.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

@import Foundation;

#import "AntBuilder.h"
#import "HillBuilder.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSCAssert(argc == 2, @"There should be 2 passed in arguments, but instead there are %ld", (long)argc);

        AntBuilder *antBuilder = [[AntBuilder alloc] initWithCount:100];
        HillBuilder *hillBuilder = [[HillBuilder alloc] initWithCount:5000 antBuilder:antBuilder];

        NSString *workspacePath = [NSString stringWithUTF8String:argv[1]];
        NSString *testsPath = [workspacePath stringByAppendingPathComponent:@"Tests"];

        for (NSString *testName in @[@"01 Import By Module", @"02 Import Individually"]) {
            NSString *testPath = [testsPath stringByAppendingPathComponent:testName];

            [antBuilder createAntWithProjectPath:testPath];

            [hillBuilder createHillWithProjectPath:testPath];
        }
    }
    return 0;
}
