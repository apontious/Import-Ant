//
//  HillBuilder.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

#import "HillBuilder.h"

@implementation HillBuilder

- (instancetype)initWithCount:(NSUInteger)count antBuilder:(AntBuilder *)antBuilder {
    self = [super init];
    if (self) {
        _count = count;
        _antBuilder = antBuilder;
    }
    return self;
}

- (void)createHillWithProjectPath:(NSString *)projectPath {
    [self _hill_deleteExistingFilesWithProjectPath:projectPath];

    [self _hill_createHeadersAndSourceWithProjectPath:projectPath];
    [self _hill_createTestFileWithProjectPath:projectPath];
}

#pragma mark - Private Methods

- (void)_hill_deleteExistingFilesWithProjectPath:(NSString *)projectPath {
}

- (void)_hill_createHeadersAndSourceWithProjectPath:(NSString *)projectPath {
}

- (void)_hill_createTestFileWithProjectPath:(NSString *)projectPath {
}

@end
