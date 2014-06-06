//
//  iKFViewController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/18.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKF.h"

@interface iKFViewController : UIViewController <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfieldLoginID;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerDatabase;

- (IBAction)loginButtonPressed:(id)sender;

@end
