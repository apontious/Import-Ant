//
//  CountUtils.m
//  Builder
//
//  Created by Andrew Pontious on 11/25/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

#import "CountUtils.h"

@implementation CountUtils

+ (NSArray<NSString *> *)numberStringsForCount:(NSUInteger)count {
    NSString *temp = [NSString stringWithFormat:@"%lu", (unsigned long)(count - 1)];
    const NSUInteger maxDigits = temp.length;

    if (maxDigits > 6) {
        assert("Not expecting count to be > 999999");
    }

    NSMutableArray<NSString *> *result = [NSMutableArray new];

    for (NSUInteger i = 0; i < count; i++) {
        NSString *numberString = [NSString stringWithFormat:@"%lu", (unsigned long)i];

        [result addObject:[NSString stringWithFormat:@"%@%@",
                           [@"0000000" substringToIndex:maxDigits + 1 - numberString.length],
                           numberString]];
    }

    return result;
}

@end
