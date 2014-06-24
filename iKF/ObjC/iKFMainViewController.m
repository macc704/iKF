//
//  iKFMainViewController.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFCompositeNoteViewController.h"
#import "iKFHandle.h"
#import "iKFMainView.h"
#import "iKFConnectionLayerView.h"

#import "iKF-Swift.h"

//@interface iKFMainViewController ()
//
//@end

@implementation iKFMainViewController{
    
    iKFMainView* _mainPanel;
    
    UIPopoverController* _popController;
    
    iKFHandle* _handle;
    NSDictionary* _posts;
    NSDictionary* _postRefViews;
    iKFConnector* _connector;
    NSString* _communityId;
    NSArray* _views;
    //NSString* _viewId;
    NSInteger _selectedRow;
    
    bool _threadActive;
    
    NSString* _cometVersion;
    
    //reuse
    NSDictionary* _reusebox;
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
    
    _postRefViews = [[NSMutableDictionary alloc] init];
    _views = [[NSMutableArray alloc] init];
    //self.viewchooser.delegate = self;
    
    _mainPanel = [[iKFMainView alloc] init];
    [_mainPanel setSizeWithWidth:4000 height:3000];
    [self.scrollView addSubview: _mainPanel];
    self.scrollView.contentSize = _mainPanel.frame.size;
    
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
    
    [self updateViews];
}

- (void) startComet{
    _threadActive = true;
    dispatch_queue_t sub_queue = dispatch_queue_create("sub_queue", 0);
    dispatch_async(sub_queue, ^{
        NSString* viewId = [self currentViewId];
        _cometVersion = @"-1";
        while(true){
            if(!([viewId isEqualToString: [self currentViewId]])){
                viewId = [self currentViewId];
                _cometVersion = @"-1";
            }
            NSString* newVersion = [[iKFConnector getInstance] getNextViewVersionAsync: viewId currentVersion: _cometVersion];
            if(_threadActive == false){
                break;
            }
            if(newVersion == nil){
                NSLog(@"error at newVersion");
                break;
            }
            NSLog(@"newVersion=%@", newVersion);
            if(!([newVersion isEqualToString: _cometVersion])){
                _cometVersion = newVersion;
                NSLog(@"refresh request");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateViewsComet];
                });
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"wake up");
            }
        }
        NSLog(@"comet stopped");
    });
}

- (void) incrementCometVersion{
    int v = _cometVersion.integerValue;
    v++;
    _cometVersion = [NSString stringWithFormat:@"%d", v];
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

- (void)viewWillDisappear:(BOOL)animated{
    _threadActive = false;
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
    _threadActive = false;
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

- (void) changed: (KFView*) view{
    [_popController dismissPopoverAnimated:YES];
    [self setKFView: view];
}

- (void) setKFView: (KFView*) view{
    _selectedRow = [_views indexOfObject: view];
    //NSLog(@"%d", _selectedRow);
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
    //_mainPanel.backgroundColor=[UIColor colorWithPatternImage: image];
    [_popController dismissPopoverAnimated:YES];
    [[iKFConnector getInstance] createPicture:image onView:[self currentViewId] location:CGPointMake(50, 50)];
    [self update];
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

- (void) createNote: (CGPoint)p buildson: (KFPostRefView*)from{
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

- (void) addNote: (KFReference*)ref{
    if([ref.post class] != [KFNote class]){
        [NSException raise:@"iKFConnectionException" format:@"Illegal addNote"];
    }
    
    [self removeHandle];
    
    KFNoteRefView* noteView;
    if(_reusebox != nil && _reusebox[ref.guid] != nil ){
        noteView = _reusebox[ref.guid];
        noteView.model = ref;
        [noteView update];
    }else{
        noteView = [[KFNoteRefView alloc] initWithController:self ref: ref];
    }
    CGRect r = noteView.frame;
    r.origin.x = ref.location.x;
    r.origin.y = ref.location.y;
    noteView.frame = r;
    //[noteView setCenter: p];
    [_postRefViews setValue: noteView forKey: ref.guid];
    [_postRefViews setValue: noteView forKey: ref.post.guid];//ちょっとずる
    [_mainPanel.noteLayer addSubview: noteView];
}

- (void) addDrawing: (KFReference*)ref{
    if([ref.post class] != [KFDrawing class]){
        [NSException raise:@"iKFConnectionException" format:@"Illegal addDrawing"];
    }
    
    [self removeHandle];
    KFDrawingRefView* postRefView;
    if(_reusebox != nil && _reusebox[ref.guid] != nil ){
        postRefView = _reusebox[ref.guid];
        postRefView.model = ref;
        postRefView.frame = CGRectMake(ref.location.x, ref.location.y, postRefView.frame.size.width, postRefView.frame.size.height);
    }else{
        postRefView = [[KFDrawingRefView alloc] initWithController:self ref: ref];
    }
    [_postRefViews setValue: postRefView forKey: ref.guid];
    //[_postviews setValue: noteView forKey: ref.guid];
    //[_postviews setValue: noteView forKey: ref.post.guid];//ちょっとずる
    [_mainPanel.drawingLayer addSubview: postRefView];
}

- (void) addViewRef: (KFReference*)ref{
    if([ref.post class] != [KFView class]){
        [NSException raise:@"iKFConnectionException" format:@"Illegal ViewRef"];
    }
    
    [self removeHandle];
    KFViewRefView* noteView = [[KFViewRefView alloc] initWithController:self ref: ref];
    [_mainPanel.noteLayer addSubview: noteView];
}

- (void) addBuildsOn: (KFReference*)ref{
    if([ref.post class] != [KFNote class]){
        [NSException raise:@"iKFConnectionException" format:@"Illegal Buildson"];
    }
    KFNote* note = ((KFNote*)ref.post);
    if(note.buildsOn != nil){
        KFPostRefView* fromView = _postRefViews[note.guid];
        KFPostRefView* toView = _postRefViews[note.buildsOn.guid];//ちょっとずる
        //NSLog(@"%@ ; %@", toView, fromView);
        [_mainPanel.connectionLayer addConnectionFrom: fromView To: toView];
    }
}

- (void) openNoteEditController: (KFNote*)note mode: (NSString*)mode{
    //[((iKFNoteView*)_target) openPopupViewer];
    iKFCompositeNoteViewController* noteController = [[iKFCompositeNoteViewController alloc] init];
    if([mode isEqualToString: @"edit"]){
        [noteController toEditMode];
    }else if([mode isEqualToString: @"read"]){
        [noteController toReadMode];
    }
    [noteController setNote: note andViewId: [self currentViewId]];
    [self presentViewController: noteController animated:YES completion: nil];
}


- (void) requestConnectionsRepaint{
    [_mainPanel.connectionLayer requestRepaint];
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

- (void) removeNote: (KFPostRefView*) view{
    [self removeHandle];
    [view removeFromSuperview];
    [_mainPanel.connectionLayer noteRemoved: view];
}

- (void) postLocationChanged: (KFPostRefView*) noteview{
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
    [self startComet];
}

- (void) updateViewsComet{
    _reusebox = _postRefViews;
    [self updateViews];
    _reusebox = [[NSMutableDictionary alloc] init];
}

- (void) updateViews{
    if(_connector == nil){
        return;
    }
    
    [self clearViews];
    
    NSString* viewId = [self currentViewId];
    self->_posts = [_connector getPosts: viewId];
    for(KFReference* each in [self->_posts allValues]){
        //NSLog(@"%@", each);
        if([each.post class] == [KFNote class]){
            [self addNote: each];
        }else if([each.post class] == [KFDrawing class]){
            [self addDrawing: each];
        }else if([each.post class] == [KFView class]){
            [self addViewRef: each];
        }else{
            [NSException raise:@"iKFException" format: @"unknown type%@", [each.post class]];
        }
    }
    for(KFReference* each in [self->_posts allValues]){
        //NSLog(@"%@", each);
        if([each.post class] == [KFNote class]){
            [self addBuildsOn: each];
        }
    }
}

- (NSString*) currentViewId{
    return [_views[_selectedRow] guid];
}

- (void) clearViews{
    _postRefViews = [[NSMutableDictionary alloc] init];
    [_mainPanel clearViews];
}

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
