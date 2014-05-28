//
//  iKFViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/18.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFViewController.h"
#import "iKFConnector.h"
#import "iKFModels.h"

@interface iKFViewController ()
@end

@implementation iKFViewController{
    NSArray* databases;
    iKFLoadingView* _loading;
    NSMutableData* _webdata;
    NSString* _currentDatabase;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //92.168.43.97:8080 はタイムアウトする
    //128.100.72.13:8080 はすぐhost error
    databases = @[@"132.203.154.41:8080", @"128.100.72.137:8080", @"192.168.43.97:8080", @"138.51.179.43:8080", @"no server"];
    _currentDatabase = databases[0];
    self.pickerDatabase.delegate = self;
    
    _loading = [[iKFLoadingView alloc] init];
    
    self.textfieldLoginID.text = @"ikit"; //tmp
    self.textfieldPassword.secureTextEntry = YES;
    self.textfieldPassword.text = @"pass"; //tmp
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonPressed:(id) sender {
    @try {
        [self login];
    }@catch (NSException *ex) {
        NSLog(@"[ERROR] exception[%@]", ex);
        [self showAlert: [NSString stringWithFormat: @"failed to login %@", ex ]];
        [_loading hide];
        //@throw exception;
    }
}

- (void) login{
    //no server モード
    if([_currentDatabase isEqualToString: @"no server"]){
        iKFUser* user = [[iKFUser alloc] init];
        user.firstName = @"Yoshiaki";//tmp
        user.lastName = @"Matsuzawa";//tmp
        iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
        mainViewController.user = user;
        //[mainViewController update2];
        [self presentViewController: mainViewController animated:YES completion: nil];
        return;
    }
    
    [_loading show: self];
    
    iKFConnector* connector = [[iKFConnector alloc] initWithHost: _currentDatabase];
    //iKFConnector* connector = [[iKFConnector alloc] initWithHost: @"132.203.154.41:8080"];
    BOOL googleTest = [connector testConnectionToGoogle];
    if(googleTest == NO){
        [self showAlert: @"failed to google test"];
        [_loading hide];
        return;
    }
    BOOL hostTest = [connector testConnectionToTheHost];
    if(hostTest == NO){
        [self showAlert: @"failed to host test"];
        [_loading hide];
        return;
    }
    
    BOOL loginResult = [connector loginWithName: self.textfieldLoginID.text password: self.textfieldPassword.text];
    if(loginResult == NO){
        [self showAlert: @"failed to login"];
        [_loading hide];
        return;
    }
    NSArray* registrations = [connector registrations];
    //NSLog(@"%@", registrations);
    
    // 仮
    NSString* registrationId = [registrations[0] guid];
    NSString* communityId = [registrations[0] communityId];
    
    BOOL enterResult = [connector enterCommunity: registrationId];
    if(enterResult == NO){
        [self showAlert: @"failed to enterCommunity"];
        [_loading hide];
        return;
    }
    
    iKFUser* user = [[iKFUser alloc] init];
    user.firstName = @"Yoshiaki";//tmp
    user.lastName = @"Matsuzawa";//tmp
    
    
    iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
    [mainViewController setUser: user];
    [self presentViewController: mainViewController animated:YES completion: nil];
    [mainViewController initServer: connector communityId: communityId];
    [_loading hide];
}

- (void) showAlert: (NSString*) msg{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"OK PRESSED.");
    }
}

- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent: (NSInteger)component {
    NSString* database = databases[[self.pickerDatabase selectedRowInComponent: 0]];
    //NSLog(@"database=%@", database);
    _currentDatabase = database;
}

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *)pView {
    return 1;
}

- (NSInteger) pickerView: (UIPickerView*)pView numberOfRowsInComponent: (NSInteger)rowCount {
    return [databases count];
}

- (NSString*) pickerView: (UIPickerView*)pView titleForRow: (NSInteger)rowCount forComponent:(NSInteger) comp {
    return databases[rowCount];
}

@end
