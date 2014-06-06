//
//  iKFViewSelectionController.h
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-15.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iKFTableSelectionListener
-(void) changed: (id) selected;
@end

@interface iKFViewSelectionController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *viewsTable;

@property (weak, nonatomic) id<iKFTableSelectionListener> listener;

@property NSArray* objects;

@end
