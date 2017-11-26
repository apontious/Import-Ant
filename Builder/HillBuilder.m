//
//  HillBuilder.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

#import "FileUtils.h"
#import "HillBuilder.h"

static NSString *const kHillAppFolderName = @"Hill";

static NSString *const kHillAppMainFileName = @"main.m";

static NSString *const kHillTestsFolderName = @"HillTests";
static NSString *const kHillTestFileName = @"HillTests.m";
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

    FileUtils *fileUtils = [[FileUtils alloc] initWithProjectPath:kHillAppMainFileName];

    // Hill
    //    main.m

    [fileUtils deleteFileInFolder:kHillAppFolderName withName:kHillAppMainFileName];

    // Hill
    //    Hill00001.h/.m, etc.

    if (![fileUtils deleteFilesInFolder:kHillAppFolderName withRegex:@"Hill[0123456789]+\\.[hm]"]) {
        return;
    }

    // HillTests
    //    HillTests.m

    [fileUtils deleteFileInFolder:kHillTestsFolderName withName:kHillTestFileName];
}

- (void)_hill_createHeadersAndSourceWithProjectPath:(NSString *)projectPath {
}

- (void)_hill_createTestFileWithProjectPath:(NSString *)projectPath {
}

@end
