//
//  iKFMainViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFMainViewController.h"
#import "iKFCompositeNoteViewController.h"

//@interface iKFMainViewController ()
//
//@end

@implementation iKFMainViewController{
    iKFMainPanel* _mainPanel;
    iKFConnectionLayerView* _connectionLayer;
    UIPopoverController* _popController;
    iKFHandle* _handle;
    NSDictionary* _posts;
    NSDictionary* _postviews;
    iKFConnector* _connector;
    NSString* _communityId;
    NSArray* _views;
    //NSString* _viewId;
    NSInteger _selectedRow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _postviews = [[NSMutableDictionary alloc] init];
    _views = [[NSMutableArray alloc] init];
    //self.viewchooser.delegate = self;
    
    _mainPanel = [[iKFMainPanel alloc] init];
    _mainPanel.frame = CGRectMake(0, 0, 3000, 4000);
    [self.scrollView addSubview: _mainPanel];
    self.scrollView.contentSize = _mainPanel.frame.size;
    
    _connectionLayer = [[iKFConnectionLayerView alloc] init];
    [_mainPanel addSubview: _connectionLayer];
    _connectionLayer.frame = _mainPanel.frame;
    
    //スクロールの拡大縮小の設定
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.minimumZoomScale = 0.4;
    
    //Tap
    //Double Tap
    UITapGestureRecognizer* recognizerTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handleTap:)];
    recognizerTap.numberOfTapsRequired = 1;
    [_mainPanel addGestureRecognizer: recognizerTap];
    
    [self update];
}

- (void) handleTap: (UIGestureRecognizer*)recognizer{
    if(_handle){
        [self removeHandle];
    }else{
        UIView* view = [[UIView alloc] init];
        CGPoint p = [recognizer locationInView: _mainPanel];
        view.frame = CGRectMake(p.x, p.y, 60, 20);
        [self showHandle: view];
    }
}

- (void) update{
    if(self.user){
        self.navigationBar.title = [NSString stringWithFormat: @"iKF - %@", [self.user getFullName]] ;
    }
}

//スクロールの拡大縮小の設定
- (UIView*) viewForZoomingInScrollView: (UIScrollView*)aScrollView {
    return _mainPanel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated: YES completion: NULL];
}

- (IBAction)bgButtonPressed:(id)sender {
    [self setBgFromLibrary];
}

- (IBAction)notePlusButtonPressed:(id)sender {
    [self createNote];
}

- (IBAction)updateButtonPressed:(id)sender {
    [self updateViews];
}

- (IBAction)viewSelectionPressed:(id)sender {
    [self showSelection];
}

- (void) showSelection{
    //iKFViewSelectionController* controller = [[iKFViewSelectionController alloc] init];
    iKFViewSelectionController* controller = [[iKFViewSelectionController alloc] initWithNibName:nil bundle:nil];
    controller.objects = _views;
    controller.listener = self;
    _popController = [[UIPopoverController alloc] initWithContentViewController: controller];
    [_popController presentPopoverFromBarButtonItem: self.viewSelectionButton permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

- (void) changed: (iKFView*) view{
    _selectedRow = [_views indexOfObject: view];
    [_popController dismissPopoverAnimated:YES];
    [self updateViews];
}

- (void) setBgFromLibrary{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.delegate = self;
    _popController = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
    [_popController presentPopoverFromBarButtonItem: self.bgButton permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _mainPanel.backgroundColor=[UIColor colorWithPatternImage: image];
    [_popController dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_popController dismissPopoverAnimated:YES];
}

//- (IBAction)viewSelectionPressed:(id)sender{
//    
//}

- (void) createNote{
    [self createNote: CGPointMake(50, 50)];
}

- (void) createNote: (CGPoint)p{
    [self createNote: p buildson: nil];
}

- (void) createNote: (CGPoint)p buildson: (iKFNoteView*)from{
    [self removeHandle];
    if(from != nil){
        [_connector createNote: [self currentViewId] buildsOn: from.model location: p];
    }else{
        [_connector createNote: [self currentViewId] buildsOn: nil location: p];
    }
    [self updateViews];
}

// local version
//- (void) createNote: (CGPoint)p buildson: (iKFNoteView*)from{
//    [self removeHandle];
//    iKFNote* note = [[iKFNote alloc] initWithAuthor: self.user];
//    note.location = p;
//    note.buildsOn = from.model;
//    [self addNote: note];
//    [self addBuildsOn: note];
//}

- (void) addNote: (iKFNote*)note{
    [self removeHandle];
    iKFNoteView* noteView = [[iKFNoteView alloc] init: self note: note];
    noteView.connector = _connector;
    CGRect r = noteView.frame;
    r.origin.x = note.location.x;
    r.origin.y = note.location.y;
    noteView.frame = r;
    //[noteView setCenter: p];
    [_postviews setValue: noteView forKey: note.guid];
    [_mainPanel addSubview: noteView];
}

- (void) addBuildsOn: (iKFNote*)note{
    if(note.buildsOn != nil){
        iKFNoteView* fromView = _postviews[note.guid];
        iKFNoteView* toView = _postviews[note.buildsOn.guid];
        //NSLog(@"%@ ; %@", toView, fromView);
        [_connectionLayer addConnectionFrom: fromView To: toView];
    }
}

- (void) openNoteEditController: (iKFNote*)note mode: (NSString*)mode{
    //[((iKFNoteView*)_target) openPopupViewer];
    iKFCompositeNoteViewController* noteController = [[iKFCompositeNoteViewController alloc] init];
    if([mode isEqualToString: @"edit"]){
        [noteController toEditMode];
    }else if([mode isEqualToString: @"read"]){
        [noteController toReadMode];
    }
    [noteController setNote: note];
    [self presentViewController: noteController animated:YES completion: nil];
}


- (void) requestConnectionsRepaint{
    [_connectionLayer requestRepaint];
}

- (void) showHandle: (UIView*) view{
    [self removeHandle];
    _handle = [[iKFHandle alloc] init: self target: view];
    
    [_handle setAlpha: 0];
    [_mainPanel addSubview: _handle];
    [UIView
     animateWithDuration: 0.5f
     delay: 0.0f
     options: UIViewAnimationOptionCurveEaseInOut
     animations:^{
         [_handle setAlpha: 1];
     }
     completion:^(BOOL finished){
     }];
}

- (void) removeHandle{
    if(_handle != nil){
        [_handle removeFromSuperview];
        _handle = nil;
    }
}

- (void) removeNote: (iKFNoteView*) view{
    [self removeHandle];
    [view removeFromSuperview];
    [_connectionLayer noteRemoved: view];
}

- (void) postLocationChanged: (iKFNoteView*) noteview{
    if(_connector == nil){
        return;
    }
    
    [noteview.model setLocation: noteview.frame.origin];
    NSString* viewId = [_views[_selectedRow] guid];
    [_connector movePost: viewId note: noteview.model];
}

- (void) initServer: (iKFConnector*)connector communityId: (NSString*)communityId{
    self->_connector = connector;
    self->_communityId = communityId;
    
    _views = [_connector getViews: _communityId];
    _selectedRow = 0;
    //[_viewchooser reloadAllComponents];

    [self updateViews];
}

- (void) updateViews{
    if(_connector == nil){
        return;
    }
    
    [self clearViews];
    
    NSString* viewId = [self currentViewId];
    self->_posts = [_connector getPosts: viewId];
    for(iKFNote* each in [self->_posts allValues]){
        //NSLog(@"%@", each);
        [self addNote: each];
    }
    for(iKFNote* each in [self->_posts allValues]){
        //NSLog(@"%@", each);
        [self addBuildsOn: each];
    }
}

- (NSString*) currentViewId{
    return [_views[_selectedRow] guid];
}

- (void) clearViews{
    _postviews = [[NSMutableDictionary alloc] init];
    
    //mainPanelにconnectionLayerも含まれるのでけしてはだめ
    //[self removeChildren: _mainPanel];
    for (UIView* subview in _mainPanel.subviews) {
        if(subview != _connectionLayer){
            [subview removeFromSuperview];
        }
    }
    [_connectionLayer clearAllConnections];
}

//- (void) removeChildren: (UIView*)view{
//    for (UIView* subview in view.subviews) {
//        [subview removeFromSuperview];
//    }
//}

//*********************************
//for picker
//*********************************

- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent: (NSInteger)component {
    _selectedRow = row;
}

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *)pView {
    return 1;
}

- (NSInteger) pickerView: (UIPickerView*)pView numberOfRowsInComponent: (NSInteger)rowCount {
    return [_views count];
}

- (NSString*) pickerView: (UIPickerView*)pView titleForRow: (NSInteger)rowCount forComponent:(NSInteger) comp {
    return [_views[rowCount] title];
}





//- (void) setJSON: (id)json{
//    //    NSLog(@"%@", json[0][@"postInfo"][@"title"]);
//    for (id post in json) {
//        NSString* title = post[@"postInfo"][@"title"];
//        NSString* body = post[@"postInfo"][@"body"];
//        CGFloat x = [post[@"location"][@"point"][@"x"] floatValue];
//        CGFloat y = [post[@"location"][@"point"][@"y"] floatValue];
//        CGPoint p = CGPointMake(x, y);
//        iKFUser* user = [[iKFUser alloc] init];
//        user.firstName = post[@"postInfo"][@"authors"][0][@"firstName"];
//        user.lastName = post[@"postInfo"][@"authors"][0][@"lastName"];
//        [self addNote0: p title: title body: body user: user];
//    }
//    //NSLog(@"%@", [json[0] description]);
//}


@end
