//
//  AntBuilder.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

#import "AntBuilder.h"
#import "CountUtils.h"
#import "FileUtils.h"

static NSString *const kAntFrameworkFolderName = @"Ant";
static NSString *const kAntFrameworkHeaderName = @"Ant.h";

static NSString *const kAntFrameworkHeaderTemplate;
static NSString *const kAntFrameworkHeaderReplacementsString = @"FRAMEWORK_IMPORT_REPLACEMENTS";

static NSString *const kAntHeaderTemplate;
static NSString *const kAntSourceTemplate;
static NSString *const kAntBaseNumberReplacementString = @"BASE_NUMBER";

static NSString *const kAntTestsFolderName = @"AntTests";
static NSString *const kAntTestFileName = @"AntTests.m";

static NSString *const kAntTestFileTemplate;
static NSString *const kAntTestTemplate;
static NSString *const kAntTestFileTestsReplacementString = @"TEST_REPLACEMENTS";

@implementation AntBuilder

- (instancetype)initWithCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        _count = count;

        if (count < 1) {
            assert("Not expecting count to be zero");
        }
    }
    return self;
}

- (void)createAntWithProjectPath:(NSString *)projectPath {
    FileUtils *fileUtils = [[FileUtils alloc] initWithProjectPath:projectPath];

    [self _ant_deleteExistingFilesWithFileUtils:fileUtils];

    [self _ant_createFrameworkHeaderWithFileUtils:fileUtils];
    [self _ant_createHeadersAndSourceWithFileUtils:fileUtils];
    [self _ant_createTestFileWithFileUtils:fileUtils];
}

#pragma mark - Private Methods

- (void)_ant_deleteExistingFilesWithFileUtils:(FileUtils *)fileUtils {

    // Ant
    //    Ant.h

    [fileUtils deleteFileInFolder:kAntFrameworkFolderName withName:kAntFrameworkHeaderName];

    // Ant
    //    Ant0001.h/.m, etc.

    if (![fileUtils deleteFilesInFolder:kAntFrameworkFolderName withRegex:@"Ant[0123456789]+\\.[hm]"]) {
        return;
    }

    // AntTests
    //    AntTests.m

    [fileUtils deleteFileInFolder:kAntTestsFolderName withName:kAntTestFileName];
}

- (void)_ant_createFrameworkHeaderWithFileUtils:(FileUtils *)fileUtils {
    NSArray<NSString *> *baseNumberStrings = [CountUtils numberStringsForCount:self.count];

    NSMutableString *headerFileNamesString = [NSMutableString new];

    for (NSString *baseNumberString in baseNumberStrings) {
        [headerFileNamesString appendFormat:@"#import <Ant/Ant%@.h>\n", baseNumberString];
    }

    [fileUtils writeFileWithTemplate:kAntFrameworkHeaderTemplate
                     replacingString:kAntFrameworkHeaderReplacementsString
                          withString:headerFileNamesString
                            inFolder:kAntFrameworkFolderName
                            withName:kAntFrameworkHeaderName];
}

- (void)_ant_createHeadersAndSourceWithFileUtils:(FileUtils *)fileUtils {
    NSArray<NSString *> *baseNumberStrings = [CountUtils numberStringsForCount:self.count];

    for (NSString *baseNumberString in baseNumberStrings) {
        // Header
        if (![fileUtils writeFileWithTemplate:kAntHeaderTemplate
                              replacingString:kAntBaseNumberReplacementString
                                   withString:baseNumberString
                                     inFolder:kAntFrameworkFolderName
                                     withName:[NSString stringWithFormat:@"Ant%@.h", baseNumberString]]) {
            break;
        }

        // Source
        if (![fileUtils writeFileWithTemplate:kAntSourceTemplate
                              replacingString:kAntBaseNumberReplacementString
                                   withString:baseNumberString
                                     inFolder:kAntFrameworkFolderName
                                     withName:[NSString stringWithFormat:@"Ant%@.m", baseNumberString]]) {
            break;
        }
    }
}

- (void)_ant_createTestFileWithFileUtils:(FileUtils *)fileUtils {
    NSArray<NSString *> *baseNumberStrings = [CountUtils numberStringsForCount:self.count];

    NSMutableString *testsString = [NSMutableString new];

    for (NSString *baseNumberString in baseNumberStrings) {
        NSMutableString *testString = kAntTestTemplate.mutableCopy;

        [testString replaceOccurrencesOfString:kAntBaseNumberReplacementString
                                    withString:baseNumberString
                                       options:0
                                         range:NSMakeRange(0, testString.length)];

        [testsString appendString:testString];
    }

    [fileUtils writeFileWithTemplate:kAntTestFileTemplate
                     replacingString:kAntTestFileTestsReplacementString
                          withString:testsString
                            inFolder:kAntTestsFolderName
                            withName:kAntTestFileName];
}

@end

static NSString *const kAntFrameworkHeaderTemplate =
@"//\n\
//  Ant.h\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
@import Foundation;\n\
\n\
FRAMEWORK_IMPORT_REPLACEMENTS";

static NSString *const kAntHeaderTemplate =
@"//\n\
//  AntBASE_NUMBER.h\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
@import Foundation;\n\
\n\
@interface AntBASE_NUMBER : NSObject\n\
\n\
- (NSString *)antBASE_NUMBER;\n\
\n\
@end\n\
";

static NSString *const kAntSourceTemplate =
@"//\n\
//  AntBASE_NUMBER.m\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
#import \"AntBASE_NUMBER.h\"\n\
\n\
@implementation AntBASE_NUMBER\n\
\n\
- (NSString *)antBASE_NUMBER {\n\
    return @\"antBASE_NUMBER\";\n\
}\n\
\n\
@end\n\
";

static NSString *const kAntTestFileTemplate =
@"//\n\
//  AntTests.m\n\
//  AntTests\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
@import XCTest;\n\
\n\
@import Ant;\n\
\n\
@interface AntTests : XCTestCase\n\
\n\
@end\n\
\n\
@implementation AntTests\n\
TEST_REPLACEMENTS\n\
@end\n\
";

static NSString *const kAntTestTemplate =
@"\n\
- (void)testAntBASE_NUMBER {\n\
    AntBASE_NUMBER *ant = [[AntBASE_NUMBER alloc] init];\n\
    XCTAssertEqualObjects(ant.antBASE_NUMBER, @\"antBASE_NUMBER\", @\"Method should produce given string\");\n\
}\n\
";
