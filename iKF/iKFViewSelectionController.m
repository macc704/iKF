//
//  iKFViewSelectionController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-05-15.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFViewSelectionController.h"

@interface iKFViewSelectionController ()

@end

@implementation iKFViewSelectionController{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray* x = [[NSMutableArray alloc] init];
        [x addObject: @"hoge1"];
        [x addObject: @"hoge2"];
        [x addObject: @"hoge3"];
        self.objects = x;
        //ここはまだだめ．
        //self.viewsTable.delegate = self;
        //self.viewsTable.dataSource = self;
        //self.viewsTable.title = @"hoho";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewsTable.delegate = self;
    self.viewsTable.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier];
    cell.textLabel.text=[self.objects[row] description];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView{
    return 1;
}

//-(NSString *)tableView:
//(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section{
//        return @"views";
//}

-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.listener != nil){
        [self.listener changed: self.objects[[indexPath row]]];
    }
    return;
}

@end
