//
//  iKFHandle.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFHandle.h"
#import "iKFCompositeNoteViewController.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@implementation iKFHandle{
    iKFMainViewController* _controller;
    UIView* _target;
    
    UIImageView* _plusButton;
}

- (id)init: (iKFMainViewController*)controller target: (UIView*)target;
{
    int SIZE = 40;

    //self = [super initWithFrame:frame];
    self = [super init];
    if (self) {
        _controller = controller;
        _target = target;
        //[self setBackgroundColor: [UIColor yellowColor]];
        CGRect targetFrame = [target frame];
        [self setFrame: CGRectMake(targetFrame.origin.x - SIZE, targetFrame.origin.y - SIZE, targetFrame.size.width + SIZE*2, targetFrame.size.height + SIZE*2)];
        
        if([_target class] == [KFNoteRefView class]){
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"edit.png"]];
                [button setFrame: CGRectMake((self.frame.size.width - SIZE)/2 , 0, SIZE, SIZE)];
                [self addSubview: button];
                button.userInteractionEnabled = YES;
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handleEditTap:)];
                gesture.numberOfTapsRequired = 1;
                [button addGestureRecognizer: gesture];
            }
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"read.png"]];
                [button setFrame: CGRectMake(self.frame.size.width - SIZE , 0, SIZE, SIZE)];
                [self addSubview: button];
                button.userInteractionEnabled = YES;
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handleViewTap:)];
                gesture.numberOfTapsRequired = 1;
                [button addGestureRecognizer: gesture];
            }
            
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bin.png"]];
                [button setFrame: CGRectMake(0 , 0, SIZE, SIZE)];
                [self addSubview: button];
                button.userInteractionEnabled = YES;
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handleDeleteTap:)];
                gesture.numberOfTapsRequired = 1;
                [button addGestureRecognizer: gesture];
            }
            
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"clip.png"]];
                [button setFrame: CGRectMake((self.frame.size.width - SIZE)*3/4, 0, SIZE, SIZE)];
                [self addSubview: button];
                button.userInteractionEnabled = YES;
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handleClipTap:)];
                gesture.numberOfTapsRequired = 1;
                [button addGestureRecognizer: gesture];
            }
            
            {
                _plusButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"new.png"]];
                //                [_plusButton setFrame: CGRectMake(SIZE + targetFrame.size.width , SIZE + targetFrame.size.height, SIZE, SIZE)];
                [_plusButton setFrame: CGRectMake(0 , SIZE + targetFrame.size.height, SIZE, SIZE)];
                [self addSubview: _plusButton];
                _plusButton.userInteractionEnabled = YES;
                UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleBuildsonPan:)];
                [_plusButton addGestureRecognizer: gesture];
            }
        }else{
            {
                _plusButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"new.png"]];
                [_plusButton setFrame: CGRectMake(SIZE + targetFrame.size.width , 0, SIZE, SIZE)];
                [self addSubview: _plusButton];
                _plusButton.userInteractionEnabled = YES;
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget: self  action: @selector(handlePlusTap:)];
                gesture.numberOfTapsRequired = 1;
                [_plusButton addGestureRecognizer: gesture];
            }
        }
    }
    return self;
}

- (void) handleEditTap: (UIGestureRecognizer*) recognizer{
    [_controller openNoteEditController: (KFNote*)((KFPostRefView*)_target).model.post mode:@"edit"];
    [_controller removeHandle];
}

- (void) handleViewTap: (UIGestureRecognizer*) recognizer{
    [_controller openNoteEditController: (KFNote*)((KFPostRefView*)_target).model.post mode:@"read"];
    [_controller removeHandle];
}

- (void) handleDeleteTap: (UIGestureRecognizer*) recognizer{
    [((KFPostRefView*)_target) die];
    [_controller removeHandle];
}

- (void) handlePlusTap: (UIGestureRecognizer*) recognizer{
    CGPoint objectP = [_target frame].origin;
    CGPoint buttonP = [_plusButton frame].origin;
    CGPoint p = CGPointMake(objectP.x + buttonP.x, objectP.y + buttonP.y);
    [_controller createNote: p];
    [_controller removeHandle];
}

- (void) handleClipTap: (UIGestureRecognizer*) recognizer{
    KFNoteRefView* noteref = (KFNoteRefView*)_target;
    KFNote* post = (KFNote*)noteref.model.post;
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = post.title;
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary: [pasteboard items][0]];
    [dic setValue: post.guid forKey: @"kfmodel.guid"];
    pasteboard.items = @[dic];
    //[dic setValue: self.kfModel.guid forKey: @"kfmodel.guid"];
    
    [KFAppUtils showAlert: @"Notification" msg: [NSString stringWithFormat: @"Cliped Post \"%@\"", post.title ]];
    [_controller removeHandle];
}

- (void) handleBuildsonTap: (UIGestureRecognizer*) recognizer{
    CGPoint objectP = [_target frame].origin;
    CGPoint buttonP = [_plusButton frame].origin;
    CGPoint p = CGPointMake(objectP.x + buttonP.x, objectP.y + buttonP.y);
    [_controller createNote: p buildson: (KFPostRefView*)_target];
    [_controller removeHandle];
}

- (void) handleBuildsonPan: (UIPanGestureRecognizer*)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        //        [[self superview] bringSubviewToFront:self];
        //        [self makeShadow];
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint location = [recognizer translationInView: _plusButton];
        CGPoint movePoint = CGPointMake(_plusButton.center.x+location.x, _plusButton.center.y+location.y);
        _plusButton.center = movePoint;
        [recognizer setTranslation: CGPointZero inView: _plusButton];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [self handleBuildsonTap: nil];
        //        [_controller requestConnectionsRepaint];
        //        [self removeShadow];
    }
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
