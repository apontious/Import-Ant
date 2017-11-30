//
//  HillBuilder.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

#import "AntBuilder.h"
#import "CountUtils.h"
#import "FileUtils.h"
#import "HillBuilder.h"

static NSString *const kHillAppFolderName = @"Hill";

static NSString *const kHillAppDelegateSourceName = @"AppDelegate.m";

static NSString *const kHillAppDelegateSourceTemplate;
static NSString *const kHillAppDelegateSourceImportReplacementsString = @"IMPORT_REPLACEMENTS";
static NSString *const kHillAppDelegateSourceMethodCallReplacementsString = @"METHOD_CALL_REPLACEMENTS";

static NSString *const kHillHeaderTemplate;
static NSString *const kHillSourceTemplate;
static NSString *const kHillBaseNumberReplacementString = @"BASE_NUMBER";
static NSString *const kHillAntNumberReplacementString = @"ANT_NUMBER";

static NSString *const kHillTestsFolderName = @"HillTests";
static NSString *const kHillTestFileName = @"HillTests.m";

static NSString *const kHillTestFileTemplate;
static NSString *const kHillTestTemplate;
static NSString *const kHillTestFileTestsReplacementString = @"TEST_REPLACEMENTS";

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
    FileUtils *fileUtils = [[FileUtils alloc] initWithProjectPath:projectPath];

    [self _hill_deleteExistingFilesWithProjectPath:projectPath];

    [self _hill_createAppDelegateSourceWithFileUtils:fileUtils];
    [self _hill_createHeadersAndSourceWithFileUtils:fileUtils];
    [self _hill_createTestFileWithFileUtils:fileUtils];
}

#pragma mark - Private Methods

- (void)_hill_deleteExistingFilesWithProjectPath:(NSString *)projectPath {

    FileUtils *fileUtils = [[FileUtils alloc] initWithProjectPath:projectPath];

    // Hill
    //    AppDelegate.m

    [fileUtils deleteFileInFolder:kHillAppFolderName withName:kHillAppDelegateSourceName];

    // Hill
    //    Hill00001.h/.m, etc.

    if (![fileUtils deleteFilesInFolder:kHillAppFolderName withRegex:@"Hill[0123456789]+\\.[hm]"]) {
        return;
    }

    // HillTests
    //    HillTests.m

    [fileUtils deleteFileInFolder:kHillTestsFolderName withName:kHillTestFileName];
}

- (void)_hill_createAppDelegateSourceWithFileUtils:(FileUtils *)fileUtils {
    NSArray<NSString *> *baseNumberStrings = [CountUtils numberStringsForCount:self.count];

    NSMutableString *headerFileNamesString = [NSMutableString new];
    for (NSString *baseNumberString in baseNumberStrings) {
        [headerFileNamesString appendFormat:@"#import \"Hill%@.h\"\n", baseNumberString];
    }

    NSMutableString *methodCallsString = [NSMutableString new];
    for (NSString *baseNumberString in baseNumberStrings) {
        [methodCallsString appendFormat:@"    NSLog(@\"%%@\", [Hill%@ hill%@]);\n", baseNumberString, baseNumberString];
    }

    [fileUtils writeFileWithTemplate:kHillAppDelegateSourceTemplate
                    replacingStrings:@[kHillAppDelegateSourceImportReplacementsString, kHillAppDelegateSourceMethodCallReplacementsString]
                         withStrings:@[headerFileNamesString, methodCallsString]
                            inFolder:kHillAppFolderName
                            withName:kHillAppDelegateSourceName];
}

- (void)_hill_createHeadersAndSourceWithFileUtils:(FileUtils *)fileUtils {
    NSArray<NSString *> *baseNumberStrings = [CountUtils numberStringsForCount:self.count];

    for (NSString *baseNumberString in baseNumberStrings) {
        // Header
        if (![fileUtils writeFileWithTemplate:kHillHeaderTemplate
                              replacingString:kHillBaseNumberReplacementString
                                   withString:baseNumberString
                                     inFolder:kHillAppFolderName
                                     withName:[NSString stringWithFormat:@"Hill%@.h", baseNumberString]]) {
            break;
        }

        // Source
        NSString *antNumberString = [self.antBuilder antNumberForIndex:[baseNumberString longLongValue] inCount:self.count];

        if (![fileUtils writeFileWithTemplate:kHillSourceTemplate
                             replacingStrings:@[kHillAntNumberReplacementString, kHillBaseNumberReplacementString]
                                  withStrings:@[antNumberString, baseNumberString]
                                     inFolder:kHillAppFolderName
                                     withName:[NSString stringWithFormat:@"Hill%@.m", baseNumberString]]) {
            break;
        }
    }
}

- (void)_hill_createTestFileWithFileUtils:(FileUtils *)fileUtils {
}

@end

static NSString *const kHillAppDelegateSourceTemplate = \
@"//\n\
//  AppDelegate.m\n\
//  Hill\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
#import \"AppDelegate.h\"\n\
\n\
IMPORT_REPLACEMENTS\n\
@implementation AppDelegate\n\
\n\
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {\n\
\n\
METHOD_CALL_REPLACEMENTS\n\
\n\
    return YES;\n\
}\n\
\n\
@end\n\
";

static NSString *const kHillHeaderTemplate = \
@"//\n\
//  HillBASE_NUMBER.h\n\
//  Hill\n\
//\n\
//  Created by Andrew Pontious on 11/30/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
@import Foundation;\n\
\n\
@interface HillBASE_NUMBER : NSObject\n\
\n\
+ (NSString *)hillBASE_NUMBER;\n\
\n\
@end\n\
";

static NSString *const kHillSourceTemplate = \
@"//\n\
//  HillBASE_NUMBER.m\n\
//  Hill\n\
//\n\
//  Created by Andrew Pontious on 11/30/17.\n\
//  Copyright © 2017 Andrew Pontious.\n\
//  Some rights reserved: http://opensource.org/licenses/mit-license.php\n\
//\n\
\n\
#import \"HillBASE_NUMBER.h\"\n\
\n\
@import Ant;\n\
\n\
@implementation HillBASE_NUMBER\n\
\n\
+ (NSString *)hillBASE_NUMBER {\n\
    AntANT_NUMBER *ant = [[AntANT_NUMBER alloc] init];\n\
\n\
    return [NSString stringWithFormat:@\"%@\", ant.antANT_NUMBER];\n\
}\n\
\n\
@end\n\
";
