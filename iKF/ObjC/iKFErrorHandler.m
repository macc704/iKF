//
//  iKFErrorHandler.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFErrorHandler.h"

static UIApplication* g_app;

@implementation iKFErrorHandler{
    
}

+ (void) hookErrorHandler: (UIApplication*)app{
    g_app = app;
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
    //showAlert(@"xxx", g_app);
}

void showAlert(NSString* msg, UIApplication* app){
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"OK PRESSED.");
    }
}

@end
