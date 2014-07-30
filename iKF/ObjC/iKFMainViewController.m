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
#import "iKFConnectionLayerView.h"
//#import "iKFConnector.h"

#import "iKF-Swift.h"

//@interface iKFMainViewController ()
//
//@end

@implementation iKFMainViewController{
    
    KFCanvasView* _mainPanel;
    
    UIPopoverController* _popController;
    
    iKFHandle* _handle;
    NSDictionary* _posts;
    NSDictionary* _postRefViews;
    NSString* _communityId;
    NSArray* _views;
    //NSString* _viewId;
    NSInteger _selectedRow;
    
    bool _initialized;
    //bool _cometActive;
    int _cometThreadNumber;
    int _cometVersion;
    
    //reuse
    NSDictionary* _reusebox;
    
    KFImagePicker* imagePicker;
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
    _initialized = false;
    _cometThreadNumber = 0;
    
    _postRefViews = [[NSMutableDictionary alloc] init];
    _views = [[NSMutableArray alloc] init];
    //self.viewchooser.delegate = self;
    
    _mainPanel = [[KFCanvasView alloc] init];
    [_mainPanel setSize: self.scrollViewContainer.frame.size];
    [_mainPanel setCanvasSize: 4000 height:3000];
    [self.scrollViewContainer addSubview: _mainPanel];
//    [self.scrollView addSubview: _mainPanel];
//    self.scrollView.contentSize = _mainPanel.frame.size;
//    
//    //スクロールの拡大縮小の設定
//    self.scrollView.delegate = self;
//    self.scrollView.maximumZoomScale = 4.0;
//    self.scrollView.minimumZoomScale = 0.4;
    
    //Tap
    //Double Tap
//    UITapGestureRecognizer* recognizerTap = [[UITapGestureRecognizer alloc]
//                                             initWithTarget: self  action: @selector(handleTap:)];
//    recognizerTap.numberOfTapsRequired = 1;
//    [_mainPanel addGestureRecognizer: recognizerTap];
    
    //[self updateViews];
    imagePicker = [[KFImagePicker alloc] initWithMainController: self];
}

- (void)viewWillAppear:(BOOL)animated{
    if(_initialized){
        _cometThreadNumber++;
        [self startComet: _cometThreadNumber];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    _cometThreadNumber++;
}

- (void) go:(KFRegistration *)registration{
    self->_user = [[KFService getInstance] getCurrentUser];
    self->_communityId = registration.communityId;

    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        bool enterResult = [[KFService getInstance] enterCommunity: registration];
        if(enterResult == false){
            //alert
            return;
        }
        
        _views = [[KFService getInstance] getViews: _communityId];
        _selectedRow = 0;
        //[_viewchooser reloadAllComponents];
        
        //[self updateViews];
        _initialized = true;
        
        _cometThreadNumber++;
        [self startComet: _cometThreadNumber];
    });
}

- (void) startComet: (int)threadNumber{
    //    dispatch_queue_t sub_queue = dispatch_queue_create("sub_queue", 0);
    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        NSString* viewId = [self currentViewId];
        _cometVersion = -1;
        while(true){
            if(!([viewId isEqualToString: [self currentViewId]])){
                viewId = [self currentViewId];
                _cometVersion = -1;
            }
            int newVersion = [[KFService getInstance] getNextViewVersionAsync: viewId currentVersion: _cometVersion];
            if(threadNumber != _cometThreadNumber){
                break;
            }
            if(newVersion == -1){
                NSLog(@"error at newVersion");
                break;
            }
            NSLog(@"newVersion=%d", newVersion);
            if(newVersion > _cometVersion){
                _cometVersion = newVersion;
                NSLog(@"refresh request");
                [self refreshAllPostsAsync];
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"wake up");
            }else if(newVersion < _cometVersion){
                NSLog(@"ERROR: newVersion < cometVersion");
                _cometVersion = newVersion;
            }
        }
        NSLog(@"comet stopped number=%d", threadNumber);
    });
}


//- (void) handleTap: (UIGestureRecognizer*)recognizer{
//    if(_handle){
//        [self removeHandle];
//    }else{
//        UIView* view = [[UIView alloc] init];
//        CGPoint p = [recognizer locationInView: _mainPanel];
//        view.frame = CGRectMake(p.x, p.y, 60, 20);
//        [self showHandle: view];
//    }
//}

- (void) update{
    if(self.user){
        self.navigationBar.title = [NSString stringWithFormat: @"iKF - %@", [self.user getFullName]] ;
    }
}

////スクロールの拡大縮小の設定
//- (UIView*) viewForZoomingInScrollView: (UIScrollView*)aScrollView {
//    return _mainPanel;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backButtonPressed:(id)sender {
    _cometThreadNumber++;
    [self dismissViewControllerAnimated: YES completion: NULL];
}

- (IBAction)bgButtonPressed:(id)sender {
    [imagePicker openImagePicker:self.bgButton viewId: [self currentViewId]];
}

- (IBAction)notePlusButtonPressed:(id)sender {
    [self createNote];
}

- (IBAction)updateButtonPressed:(id)sender {
    [self refreshAllPostsAsync];
}

- (IBAction)viewSelectionPressed:(id)sender {
    [self showSelection];
}

- (void) showSelection{
    //iKFViewSelectionController* controller = [[iKFViewSelectionController alloc] init];
    KFViewSelectionController* controller = [[KFViewSelectionController alloc] initWithNibName:nil bundle:nil];
    controller.views = _views;
//    func a(view:KFView){
//        [_popController dismissPopoverAnimated:YES];
//        [self setKFView: view];
//    }
//    controller.selectedHandler = a;
    _popController = [[UIPopoverController alloc] initWithContentViewController: controller];
    [_popController presentPopoverFromBarButtonItem: self.viewSelectionButton permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

- (void) setKFView: (KFView*) view{
    _selectedRow = [_views indexOfObject: view];
    //NSLog(@"%d", _selectedRow);
    //[self refreshAllPostsAsync];
    _cometThreadNumber++;
    [self startComet: _cometThreadNumber];
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
    [[KFService getInstance] createNote: [self currentViewId] buildsOn: from.model location: p];
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
        [noteView updateFromModel];
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
    [postRefView updateFromModel];
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

- (void) deletePostRef: (KFPostRefView*) ref{
    [self removeHandle];
    [ref removeFromSuperview];
    [_mainPanel.connectionLayer noteRemoved: ref];
    NSString* viewId = [_views[_selectedRow] guid];
    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        _cometVersion++;
        [[KFService getInstance] deletePostRef:viewId postRef:ref.model];
    });
}

- (void) postLocationChanged: (KFPostRefView*) noteview{
    if([KFService getInstance] == nil){
        return;
    }
    
    [noteview.model setLocation: noteview.frame.origin];

    
    [self updatePostRef: noteview.model];
}

- (void) updatePostRef: (KFReference*) ref{
    NSString* viewId = [_views[_selectedRow] guid];
    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        _cometVersion++;
        [[KFService getInstance] updatePostRef: viewId postRef: ref];
    });
}

- (void) refreshAllPostsSync{
    NSDictionary* newPosts = [self retrievePosts];
    [self refreshPosts: newPosts];
}

- (void) refreshAllPostsAsync{
    dispatch_queue_t sub_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sub_queue, ^{
        NSDictionary* newPosts = [self retrievePosts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshPosts: newPosts];
        });
    });
}

- (NSDictionary*)retrievePosts{
    NSString* viewId = [self currentViewId];
    return [[KFService getInstance] getPosts: viewId];
}

- (void) refreshPosts: (NSDictionary*) newPosts {
    _reusebox = _postRefViews;
    [self clearViews];
    self->_posts = newPosts;
    for(KFReference* each in [self->_posts allValues]){
        if([each isHidden]){
            continue;
        }
        
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
    _reusebox = [[NSMutableDictionary alloc] init];
}

- (NSString*) currentViewId{
    return [[self getCurrentView] guid];
}

- (KFView*) getCurrentView{
    return _views[_selectedRow];
}

- (void) clearViews{
    _postRefViews = [[NSMutableDictionary alloc] init];
    [_mainPanel clearViews];
}

@end
