//
//  iKFNoteView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFNoteView.h"

@implementation iKFNoteView{
    iKFMainViewController* _controller;
    
    iKFNoteIcon* _icon;
    UILabel* _titleLabel;
    UILabel* _authorLabel;
    
    UIPopoverController* _popoverController;
    iKFNotePopupViewController* _notePopupController;
}

- (id)init: (iKFMainViewController*)controller note: (iKFNote*)note
{
    self = [super init];

    if (self) {
        _controller = controller;
        self.model = note;

        [self setBackgroundColor: [UIColor whiteColor]];
        [self setFrame: CGRectMake(0, 0, 230, 40)];
        
        _icon = [[iKFNoteIcon alloc] initWithFrame: CGRectMake(5, 5, 20, 20)];
        [self addSubview: _icon];
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(30, 5, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12];

        [self addSubview: _titleLabel];
        _authorLabel = [[UILabel alloc] initWithFrame: CGRectMake(50, 25, 120, 10)];
        _authorLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview: _authorLabel];
        
        [note attach: self selector: @selector(noteChanged:)];
        [self update];

        
        //Pan
        [self addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(handlePanning:)]];
        
        //Single Tap
        UITapGestureRecognizer* recognizerSingleTap = [[UITapGestureRecognizer alloc]
                                                       initWithTarget: self  action: @selector(handleSingleTap:)];
        recognizerSingleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer: recognizerSingleTap];
        //Double Tap
        UITapGestureRecognizer* recognizerDoubleTap = [[UITapGestureRecognizer alloc]
                                                       initWithTarget: self  action: @selector(handleDoubleTap:)];
        recognizerDoubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer: recognizerDoubleTap];
        
        [recognizerSingleTap requireGestureRecognizerToFail : recognizerDoubleTap];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) noteChanged: (NSNotification*)notification{
    [self update];
    
}

- (void) update{
    _titleLabel.text = self.model.title;
    _authorLabel.text = [[self.model primaryAuthor] getFullName];
}

- (void) handlePanning:(UIPanGestureRecognizer*) recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        [[self superview] bringSubviewToFront:self];
        [self makeShadow];
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint location = [recognizer translationInView:self];
        CGPoint movePoint = CGPointMake(self.center.x+location.x, self.center.y+location.y);
        self.center = movePoint;
        [recognizer setTranslation:CGPointZero inView:self];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [_controller requestConnectionsRepaint];
        [_controller postLocationChanged: self];
        [self removeShadow];
    }
}

- (void) makeShadow{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

- (void) removeShadow{
    self.layer.shadowOpacity = 0.0f;
}


- (void) handleSingleTap: (UIGestureRecognizer *) recognizer{
    //[self openPopupViewer];
    [_controller showHandle: self];
}

- (void) handleDoubleTap: (UIGestureRecognizer *) recognizer{
    [self openPopupViewer];
    //[_controller showHandle: self];
}

//これはkfMainへ移動すること
- (void) openPopupViewer{
    _notePopupController = [[iKFNotePopupViewController alloc] init];
    _notePopupController.note = self.model;
    _notePopupController.noteView = self;
    _notePopupController.kfViewController = _controller;
//    _notePopupController.connector = self.connector;
    _notePopupController.contentSizeForViewInPopover = _notePopupController.view.frame.size;
    _popoverController = [[UIPopoverController alloc] initWithContentViewController: _notePopupController];
    _popoverController.delegate = self;
    [_popoverController presentPopoverFromRect: self.frame inView: self.superview permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void) closePopupViewer{
    //[_notePopupController updateToModel];
    [_popoverController dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //[_notePopupController updateToModel];
    _popoverController = nil;
//    NSLog(@"PopoverSampleViewController released popoverController.");
}

- (void) die{
    [_controller removeNote: self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
