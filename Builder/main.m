//
//  main.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

@import Foundation;

#import "AntBuilder.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSCAssert(argc == 2, @"There should be 2 passed in arguments, but instead there are %ld", (long)argc);

        NSString *workspacePath = [NSString stringWithUTF8String:argv[1]];

        AntBuilder *antBuilder = [[AntBuilder alloc] initWithCount:100];

        [antBuilder createAntWithProjectPath:[[workspacePath stringByAppendingPathComponent:@"Tests"] stringByAppendingPathComponent:@"01 Import By Module"]];
        [antBuilder createAntWithProjectPath:[[workspacePath stringByAppendingPathComponent:@"Tests"] stringByAppendingPathComponent:@"02 Import Individually"]];
    }
    return 0;
}
