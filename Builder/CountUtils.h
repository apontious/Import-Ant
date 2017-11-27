//
//  CountUtils.h
//  Builder
//
//  Created by Andrew Pontious on 11/25/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

@import Foundation;

@interface CountUtils : NSObject

/**
 Will take number, make a string for zero through that number - 1, and prepend all of them with enough zeros to be uniform in length, and for the longest numbers to have one prepending zero.

 For example, for a count of 10, the strings would be 00 through 09.

 For a count of 450, the strings would be 0000 through 0449.

 Etc.

 If count is > 999999, this method will assert.
 */
+ (NSArray<NSString *> *)numberStringsForCount:(NSUInteger)count;

@end
