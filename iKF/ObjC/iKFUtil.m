//
//  iKFUtil.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-01.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFUtil.h"

@implementation iKFUtil

+ (NSString*) getBuildDate{
    return [NSString stringWithUTF8String:__DATE__];
}

+ (NSString*) getBuildTime{
    return [NSString stringWithUTF8String:__TIME__];
}

// http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html
+ (NSString *)generateRandomString: (int)len {
    static const char randomSeedCharArray[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
        'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
        'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    char *result;   // result with c-string
    result = malloc(len + 1);
    
    for (int index = 0; index < len; index++) {
        result[index] = randomSeedCharArray[arc4random() % sizeof(randomSeedCharArray)];
    }
    result[len] = '\0';
    
    // result NSString
    NSString *resultString = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
    free(result);
    return resultString;
}

@end
