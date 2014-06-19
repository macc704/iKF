//
//  KFLoginViewController.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-05.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFLoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    var servers = ["132.203.154.41:8080", "128.100.72.137:8080", "localhost:8080", "192.168.43.97:8080", "138.51.179.228:8080", "no server"];
    
    @IBOutlet var passwordField : UITextField
    @IBOutlet var usernameField : UITextField
    @IBOutlet var serverPicker : UIPickerView
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverPicker.dataSource = self;
        serverPicker.delegate = self;
        
        self.usernameField.text = "ikit";
        self.passwordField.text = "pass";
        self.passwordField.secureTextEntry = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        
        var connector = iKFConnector.getInstance();
        connector.host = servers[serverPicker.selectedRowInComponent(0)];
        let googleTest = connector.testConnectionToGoogle();
        if(googleTest == false){
            self.showAlert("Connection Error", msg: "Internet Connection Failed");
            return;
        }
        
        let hostTest = connector.testConnectionToTheHost();
        if(hostTest == false){
            self.showAlert("Connection Error", msg: "Connection Failed to the Selected Host");
            return;
        }
        
        let loginResult = connector.loginWithName(self.usernameField.text, password:self.passwordField.text);
        if(loginResult == false){
            self.showAlert("Login Error", msg: "Login Failed");
            return;
        }
        let registrationViewController = KFRegistrationViewController(nibName: nil, bundle: nil);
        self.presentViewController(registrationViewController, animated: true, completion: nil);
    }
    
    func showAlert(title:String, msg:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("OK");
        alertView.title = title;
        alertView.message = msg;
        alertView.show();
    }
    
    //    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
    //    }
    
    /* data source */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return servers.count;
    }
    
    /* delegate */
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return servers[row];
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
    }
    
    //    iKFLoadingView* _loading;
    //    NSMutableData* _webdata;
    //    NSString* _currentDatabase;
    
    //
    //    - (IBAction)loginButtonPressed:(id) sender {
    //    @try {
    //    [self login];
    //    }@catch (NSException *ex) {
    //    NSLog(@"[ERROR] exception[%@]", ex);
    //    [self showAlert: [NSString stringWithFormat: @"failed to login %@", ex ]];
    //    [_loading hide];
    //    //@throw exception;
    //    }
    //    }
    //
    //    - (void) login{
    //    //no server モード
    //    if([_currentDatabase isEqualToString: @"no server"]){
    //    iKFUser* user = [[iKFUser alloc] init];
    //    user.firstName = @"Yoshiaki";//tmp
    //    user.lastName = @"Matsuzawa";//tmp
    //    iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
    //    mainViewController.user = user;
    //    //[mainViewController update2];
    //    [self presentViewController: mainViewController animated:YES completion: nil];
    //    return;
    //    }
    //
    //    [_loading show: self];
    //
    //    iKFConnector* connector = [iKFConnector getInstance];
    //    connector.host = _currentDatabase;
    //    //iKFConnector* connector = [[iKFConnector alloc] initWithHost: @"132.203.154.41:8080"];
    //    BOOL googleTest = [connector testConnectionToGoogle];
    //    if(googleTest == NO){
    //    [self showAlert: @"failed to google test"];
    //    [_loading hide];
    //    return;
    //    }
    //    BOOL hostTest = [connector testConnectionToTheHost];
    //    if(hostTest == NO){
    //    [self showAlert: @"failed to host test"];
    //    [_loading hide];
    //    return;
    //    }
    //
    //    BOOL loginResult = [connector loginWithName: self.textfieldLoginID.text password: self.textfieldPassword.text];
    //    if(loginResult == NO){
    //    [self showAlert: @"failed to login"];
    //    [_loading hide];
    //    return;
    //    }
    //    NSArray* registrations = [connector registrations];
    //    //NSLog(@"%@", registrations);
    //
    //    // 仮
    //    NSString* registrationId = [registrations[0] guid];
    //    NSString* communityId = [registrations[0] communityId];
    //
    //    BOOL enterResult = [connector enterCommunity: registrationId];
    //    if(enterResult == NO){
    //    [self showAlert: @"failed to enterCommunity"];
    //    [_loading hide];
    //    return;
    //    }
    //
    //    iKFUser* user = [[iKFUser alloc] init];
    //    user.firstName = @"Yoshiaki";//tmp
    //    user.lastName = @"Matsuzawa";//tmp
    //
    //
    //    iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
    //    [mainViewController setUser: user];
    //    [self presentViewController: mainViewController animated:YES completion: nil];
    //    [mainViewController initServer: connector communityId: communityId];
    //    [_loading hide];
    //    }
    //
    //    - (void) showAlert: (NSString*) msg{
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alertView show];
    //    }
    //
    //    - (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    if (buttonIndex == 1) {
    //    NSLog(@"OK PRESSED.");
    //    }
    //    }
    //
    //    - (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent: (NSInteger)component {
    //    NSString* database = databases[[self.pickerDatabase selectedRowInComponent: 0]];
    //    //NSLog(@"database=%@", database);
    //    _currentDatabase = database;
    //    }
    //
    //    - (NSInteger) numberOfComponentsInPickerView: (UIPickerView *)pView {
    //    return 1;
    //    }
    //
    //    - (NSInteger) pickerView: (UIPickerView*)pView numberOfRowsInComponent: (NSInteger)rowCount {
    //    return [databases count];
    //    }
    //
    //    - (NSString*) pickerView: (UIPickerView*)pView titleForRow: (NSInteger)rowCount forComponent:(NSInteger) comp {
    //    return databases[rowCount];
    //    }
    //
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

//@implementation iKFViewController{
//    NSArray* databases;
//    iKFLoadingView* _loading;
//    NSMutableData* _webdata;
//    NSString* _currentDatabase;
//    }
//
//    - (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    {//test button
//        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
//        [button setTitle: @"test" forState: UIControlStateNormal];
//        button.frame = CGRectMake(100, 100, 100, 100);
//        [button addTarget:self
//        action:@selector(testPressed:) forControlEvents:UIControlEventTouchUpInside];
//        //[button setTitle: @"hoge" forState: nil];
//        [self.view addSubview: button];
//    }
//
//    //92.168.43.97:8080 はタイムアウトする
//    //128.100.72.13:8080 はすぐhost error
//    databases = @[@"132.203.154.41:8080", @"128.100.72.137:8080", @"192.168.43.97:8080", @"138.51.177.211:8080", @"no server"];
//    _currentDatabase = databases[0];
//    self.pickerDatabase.delegate = self;
//
//    _loading = [[iKFLoadingView alloc] init];
//
//    self.textfieldLoginID.text = @"ikit"; //tmp
//    self.textfieldPassword.secureTextEntry = YES;
//    self.textfieldPassword.text = @"pass"; //tmp
//}
//
//-(void)testPressed:(UIButton*)button{
//    //iKFRegistrationViewController* controller = [[iKFRegistrationViewController alloc] init];
//    //[self presentViewController:controller animated:YES completion:nil];
//
//    }
//
//    - (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    }
//
//    - (IBAction)loginButtonPressed:(id) sender {
//        @try {
//            [self login];
//        }@catch (NSException *ex) {
//            NSLog(@"[ERROR] exception[%@]", ex);
//            [self showAlert: [NSString stringWithFormat: @"failed to login %@", ex ]];
//            [_loading hide];
//            //@throw exception;
//        }
//        }
//
//        - (void) login{
//            //no server モード
//            if([_currentDatabase isEqualToString: @"no server"]){
//                iKFUser* user = [[iKFUser alloc] init];
//                user.firstName = @"Yoshiaki";//tmp
//                user.lastName = @"Matsuzawa";//tmp
//                iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
//                mainViewController.user = user;
//                //[mainViewController update2];
//                [self presentViewController: mainViewController animated:YES completion: nil];
//                return;
//            }
//
//            [_loading show: self];
//
//            iKFConnector* connector = [iKFConnector getInstance];
//            connector.host = _currentDatabase;
//            //iKFConnector* connector = [[iKFConnector alloc] initWithHost: @"132.203.154.41:8080"];
//            BOOL googleTest = [connector testConnectionToGoogle];
//            if(googleTest == NO){
//                [self showAlert: @"failed to google test"];
//                [_loading hide];
//                return;
//            }
//            BOOL hostTest = [connector testConnectionToTheHost];
//            if(hostTest == NO){
//                [self showAlert: @"failed to host test"];
//                [_loading hide];
//                return;
//            }
//
//            BOOL loginResult = [connector loginWithName: self.textfieldLoginID.text password: self.textfieldPassword.text];
//            if(loginResult == NO){
//                [self showAlert: @"failed to login"];
//                [_loading hide];
//                return;
//            }
//            NSArray* registrations = [connector registrations];
//            //NSLog(@"%@", registrations);
//
//            // 仮
//            NSString* registrationId = [registrations[0] guid];
//            NSString* communityId = [registrations[0] communityId];
//
//            BOOL enterResult = [connector enterCommunity: registrationId];
//            if(enterResult == NO){
//                [self showAlert: @"failed to enterCommunity"];
//                [_loading hide];
//                return;
//            }
//
//            iKFUser* user = [[iKFUser alloc] init];
//            user.firstName = @"Yoshiaki";//tmp
//            user.lastName = @"Matsuzawa";//tmp
//
//
//            iKFMainViewController* mainViewController = [[iKFMainViewController alloc] init];
//            [mainViewController setUser: user];
//            [self presentViewController: mainViewController animated:YES completion: nil];
//            [mainViewController initServer: connector communityId: communityId];
//            [_loading hide];
//            }
//
//            - (void) showAlert: (NSString*) msg{
//                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alertView show];
//                }
//
//                - (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//                    if (buttonIndex == 1) {
//                        NSLog(@"OK PRESSED.");
//                    }
//                    }
//
//                    - (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent: (NSInteger)component {
//                        NSString* database = databases[[self.pickerDatabase selectedRowInComponent: 0]];
//                        //NSLog(@"database=%@", database);
//                        _currentDatabase = database;
//                        }
//
//                        - (NSInteger) numberOfComponentsInPickerView: (UIPickerView *)pView {
//                            return 1;
//                            }
//
//                            - (NSInteger) pickerView: (UIPickerView*)pView numberOfRowsInComponent: (NSInteger)rowCount {
//                                return [databases count];
//                                }
//
//                                - (NSString*) pickerView: (UIPickerView*)pView titleForRow: (NSInteger)rowCount forComponent:(NSInteger) comp {
//                                    return databases[rowCount];
//                                }
