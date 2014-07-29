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

static int SIZE = 40;

@implementation iKFHandle{
    iKFMainViewController* _controller;
    UIView* _target;
    
    UIImageView* _plusButton;
    UIImageView* _resizeButton;
    UIImageView* _moveButton;
    UIImageView* _rotateButton;
}

- (id)init: (iKFMainViewController*)controller target: (UIView*)target;
{

    //self = [super initWithFrame:frame];
    self = [super init];
    if (self) {
        _controller = controller;
        _target = target;
        //[self setBackgroundColor: [UIColor yellowColor]];
        CGRect targetFrame = [target frame];
        [self setFrame: CGRectMake(targetFrame.origin.x - SIZE, targetFrame.origin.y - SIZE, targetFrame.size.width + SIZE*2, targetFrame.size.height + SIZE*2)];
        
        if([_target class] == [KFDrawingRefView class]){
            KFPostRefView* postRef = (KFPostRefView*)_target;
            if([postRef.model isLocked]){
                {
                    UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"anchornot.png"]];
                    [button setFrame: CGRectMake((self.frame.size.width - SIZE) , 0, SIZE, SIZE)];
                    [self addSubview: button];
                    button.userInteractionEnabled = YES;
                    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                                       initWithTarget: self  action: @selector(unlock:)];
                    gesture.numberOfTapsRequired = 1;
                    [button addGestureRecognizer: gesture];
                }
            }else{
                {
                    UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"anchor.png"]];
                    [button setFrame: CGRectMake((self.frame.size.width - SIZE) , 0, SIZE, SIZE)];
                    [self addSubview: button];
                    button.userInteractionEnabled = YES;
                    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
                                                       initWithTarget: self  action: @selector(lock:)];
                    gesture.numberOfTapsRequired = 1;
                    [button addGestureRecognizer: gesture];
                }
            }
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"resize.png"]];
                [button setFrame: CGRectMake(self.frame.size.width - SIZE , self.frame.size.height - SIZE, SIZE, SIZE)];
                [self addSubview: button];
                _resizeButton = button;
                button.userInteractionEnabled = YES;
                UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleResize:)];
                [button addGestureRecognizer: gesture];

            }
            
            if(![postRef.model isLocked]){
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"move.png"]];
                [button setFrame: CGRectMake((self.frame.size.width - SIZE)/2 , 0, SIZE, SIZE)];
                [self addSubview: button];
                _moveButton = button;
                button.userInteractionEnabled = YES;
                UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleMove:)];
                [button addGestureRecognizer: gesture];
                
            }
            
            {
                UIImageView* button = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"rotation.png"]];
                [button setFrame: CGRectMake(0, self.frame.size.height - SIZE, SIZE, SIZE)];
                [self addSubview: button];
                _rotateButton = button;
                button.userInteractionEnabled = YES;
                UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleRotate:)];
                [button addGestureRecognizer: gesture];
                
            }
            
            {
                UIRotationGestureRecognizer* gesture = [[UIRotationGestureRecognizer alloc] initWithTarget: self action: @selector(handleRotation:)];
                [self addGestureRecognizer: gesture];
            }
            {
                UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinch:)];
                [self addGestureRecognizer: gesture];
            }
        }
        
        if([_target class] == [KFNoteRefView class] || [_target class] == [KFDrawingRefView class] || [_target class] == [KFViewRefView class]){
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
        }
        
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
        }
        
//        else{
//            {
//                _plusButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"new.png"]];
//                [_plusButton setFrame: CGRectMake(SIZE + targetFrame.size.width , 0, SIZE, SIZE)];
//                [self addSubview: _plusButton];
//                _plusButton.userInteractionEnabled = YES;
//                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]
//                                             initWithTarget: self  action: @selector(handlePlusTap:)];
//                gesture.numberOfTapsRequired = 1;
//                [_plusButton addGestureRecognizer: gesture];
//            }
//        }
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

//- (void) handleOpenMenuTap: (UIGestureRecognizer*) recognizer{
//    KFPostRefView* drawingTarget = (KFPostRefView*)_target;
//    bool locked = [drawingTarget.model isLocked];
//    [[drawingTarget model] setLocked: !locked];
//    [_controller updatePostRef: drawingTarget.model];
//}

- (void) lock: (UIGestureRecognizer*) recognizer{
    KFPostRefView* drawingTarget = (KFPostRefView*)_target;
    [drawingTarget.model setLocked: true];
    [drawingTarget updatePanEventBinding];
    [_controller updatePostRef: drawingTarget.model];
    [_controller removeHandle];
}
- (void) unlock: (UIGestureRecognizer*) recognizer{
    KFPostRefView* drawingTarget = (KFPostRefView*)_target;
    [drawingTarget.model setLocked: false];
    [drawingTarget updatePanEventBinding];
    [_controller updatePostRef: drawingTarget.model];
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
//    [_controller removeHandle];
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

- (void) handleResize: (UIPanGestureRecognizer*)recognizer{
    KFDrawingRefView* drawingTarget = (KFDrawingRefView*)_target;
    //int x = drawingTarget.frame.origin.x;
    //int y = drawingTarget.frame.origin.y;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        //        [[self superview] bringSubviewToFront:self];
        //        [self makeShadow];
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint location = [recognizer translationInView: _resizeButton];
        CGPoint movePoint = CGPointMake(_resizeButton.center.x+location.x, _resizeButton.center.y+location.y);
        _resizeButton.center = movePoint;
        [recognizer setTranslation: CGPointZero inView: _resizeButton];
        CGFloat w = _resizeButton.frame.origin.x - SIZE;
        CGFloat h = _resizeButton.frame.origin.y - SIZE;
        [drawingTarget kfSetSize:w height:h];
//        _resizeButton.frame.origin
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //[self handleBuildsonTap: nil];
        //        [_controller requestConnectionsRepaint];
        //        [self removeShadow];
        //[_controller removeHandle];
        drawingTarget.model.width = drawingTarget.svgwidth * drawingTarget.scaleX;
        drawingTarget.model.height = drawingTarget.svgheight * drawingTarget.scaleY;
        drawingTarget.model.rotation = drawingTarget.rotation;
        [drawingTarget.model setShowInPlace: true];
        [_controller updatePostRef: drawingTarget.model];
        
        [_controller showHandle: drawingTarget];
    }
}

- (void) handleMove: (UIPanGestureRecognizer*)recognizer{
    KFDrawingRefView* drawingTarget = (KFDrawingRefView*)_target;

//    if(recognizer.state == UIGestureRecognizerStateChanged){
//        CGPoint location = [recognizer translationInView: _moveButton];
//        CGPoint movePoint = CGPointMake(_moveButton.center.x+location.x, _moveButton.center.y+location.y);
//        _moveButton.center = movePoint;
//        //[recognizer setTranslation: CGPointZero inView: _moveButton];//tmp
//    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint location = [recognizer translationInView: self];
        CGPoint movePoint = CGPointMake(self.center.x+location.x, self.center.y+location.y);
        self.center = movePoint;
        //[recognizer setTranslation: CGPointZero inView: _moveButton];//tmp
    }
    [drawingTarget handlePanning: recognizer];//tmp
}

- (void) handleRotate: (UIPanGestureRecognizer*)recognizer{
    KFDrawingRefView* drawingTarget = (KFDrawingRefView*)_target;
    
    if(recognizer.state == UIGestureRecognizerStateChanged){

        CGPoint location = [recognizer translationInView: _rotateButton];
        CGPoint movePoint = CGPointMake(_rotateButton.center.x+location.x, _rotateButton.center.y+location.y);
        _rotateButton.center = movePoint;
        [recognizer setTranslation: CGPointZero inView: _rotateButton];
        
        float fw = self.frame.size.width;
        float fh = self.frame.size.height;
        CGPoint org = CGPointMake(fw/2, fh/2);
        
        //http://kappdesign.blog.fc2.com/blog-entry-18.html
        // make difference then reverse y axis
        float x = movePoint.x - org.x;
        float y = -(movePoint.y - org.y);
       // NSLog(@"atan2f degree：%f", (M_PI_2 - atan2f(fh,fw))*360/(2*M_PI));
        // radian
        float radian = atan2f(y, x) + (M_PI_2 + (M_PI_2 - atan2f(fh,fw)));
        int degree = (int)(radian *360 /(2*M_PI));
        int a = degree % 90;
        if(-5 < a && a < 0){
            degree = degree + a;
        }else if(0 < a && a < 5){
            degree = degree - a;
        }
        radian = ((float)degree)* (2*M_PI) / 360;
//        drawingTarget.transform = CGAffineTransformMakeRotation(-radian);
        //NSLog(@"radian：%f　degree：%f", radian, degree);
        [drawingTarget kfSetRotation: -radian];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        drawingTarget.model.width = drawingTarget.svgwidth * drawingTarget.scaleX;
        drawingTarget.model.height = drawingTarget.svgheight * drawingTarget.scaleY;
        drawingTarget.model.rotation = drawingTarget.rotation;
        [drawingTarget.model setShowInPlace: true];
        [_controller updatePostRef: drawingTarget.model];
        
        [_controller showHandle: drawingTarget];
    }
}

CGFloat initialRotation;

- (void) handleRotation: (UIRotationGestureRecognizer*)recognizer{
    KFDrawingRefView* drawingTarget = (KFDrawingRefView*)_target;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        initialRotation = drawingTarget.rotation;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat rotation = [recognizer rotation];
        CGFloat newRotation = initialRotation + rotation;
        [drawingTarget kfSetRotation: newRotation];
    }
}

CGFloat initialScale;

- (void) handlePinch : (UIPinchGestureRecognizer *)recognizer {
    KFDrawingRefView* drawingTarget = (KFDrawingRefView*)_target;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        initialScale = drawingTarget.scaleX;
//        currentTransForm = imgView.transform;
        // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat scale = [recognizer scale];
        CGFloat newScale = initialScale * scale;
        [drawingTarget kfSetScale: newScale newScaleY:newScale];
    }
    // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
    // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
    //    CGFloat scale = [sender scale];
    
    // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
    //    imgView.transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale));
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
