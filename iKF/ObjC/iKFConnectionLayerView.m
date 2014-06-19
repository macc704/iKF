//
//  iKFConnectionLayerView.m
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2013/09/30.
//  Copyright (c) 2013年 Yoshiaki Matsuzawa. All rights reserved.
//

#import "iKFConnectionLayerView.h"
#import "Math.h"
#import "iKFConnection.h"

#import "iKFAbstractNoteEditView.h"
#import "iKFMainViewController.h"
#import "iKFNotePopupViewController.h"
#import "iKF-Swift.h"

@implementation iKFConnectionLayerView{
    NSMutableArray* _connections;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _connections = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = NO;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) clearAllConnections{
    _connections = [[NSMutableArray alloc] init];
    [self requestRepaint];
}

- (void) requestRepaint{
    [self setNeedsDisplay];
}

- (void) noteRemoved: (KFPostRefView*)removedNote{
    NSMutableArray* newConnections = [[NSMutableArray alloc] init];
    for (iKFConnection* conn in _connections){
        if(conn.from != removedNote && conn.to != removedNote){
            [newConnections addObject: conn];
        }
    }
    if([newConnections count] != [_connections count]){
        _connections = newConnections;
        [self requestRepaint];
    }
}

- (void) addConnectionFrom: (KFPostRefView*)from To: (KFPostRefView*)to{
    iKFConnection* conn = [[iKFConnection alloc] initFrom: from To: to];
    [_connections addObject: conn];
    [self requestRepaint];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect: (CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    for(iKFConnection* conn in _connections){
        CGPoint fromP = conn.from.center;
        //        CGPoint toP = conn.to.center;
        CGPoint toP = [self createChopBoxAnchorFrom: conn.from To: conn.to];
        CGContextMoveToPoint(context, fromP.x, fromP.y);
        CGContextAddLineToPoint(context, toP.x, toP.y);
        CGContextStrokePath(context);
        
        //Arrow
        [self createArrowContext: context From: fromP To: toP];
    }
}

- (void) createArrowContext: (CGContextRef)context From: (CGPoint)from To: (CGPoint)to{
    float baseDir = atan2(to.y - from.y, to.x - from.x);
    baseDir = baseDir + 3.141592 * 1;//逆向き
    
    float dir1 = baseDir + 0.5;
    float dir2 = baseDir - 0.5;
    
    float newX, newY;
    newX = to.x + cos(dir1) * 13;
    newY = to.y + sin(dir1) * 13;
    CGContextMoveToPoint(context, to.x, to.y);
    CGContextAddLineToPoint(context, newX, newY);
    CGContextStrokePath(context);
    
    newX = to.x + cos(dir2) * 13;
    newY = to.y + sin(dir2) * 13;
    CGContextMoveToPoint(context, to.x, to.y);
    CGContextAddLineToPoint(context, newX, newY);
    CGContextStrokePath(context);
}

- (CGPoint) createChopBoxAnchorFrom: (UIView*)from To: (UIView*)to{
    CGPoint reference = from.center;
    CGRect r = to.frame;
    float centerX = r.origin.x + 0.5f * r.size.width;
    float centerY = r.origin.y + 0.5f * r.size.height;
    
    // This avoids divide-by-zero
    if (/*r.isEmpty()*/ r.size.width <= 0 || r.size.height <= 0 ||
        (reference.x == (int) centerX && reference.y == (int) centerY)){
        return CGPointMake((int) centerX, (int) centerY);
    }
    
    float dx = reference.x - centerX;
    float dy = reference.y - centerY;
    float scale = 0.5f / MAX(abs(dx) / r.size.width, abs(dy) / r.size.height);
    dx *= scale;
    dy *= scale;
    centerX += dx;
    centerY += dy;
    return CGPointMake(round(centerX), round(centerY));
}

/*
public Point  [More ...] getLocation(Point reference) {
    Rectangle r = Rectangle.SINGLETON;
    r.setBounds(getBox());
    r.translate(-1, -1);
    r.resize(1, 1);
    getOwner().translateToAbsolute(r);
    float centerX = r.x + 0.5f * r.width;
    float centerY = r.y + 0.5f * r.height;
    if (r.isEmpty()
        || (reference.x == (int) centerX && reference.y == (int) centerY))
        return new Point((int) centerX, (int) centerY); // This avoids
    float dx = reference.x - centerX;
    float dy = reference.y - centerY;
    float scale = 0.5f / Math.max(Math.abs(dx) / r.width, Math.abs(dy)
                                  / r.height);
   
    dx *= scale;
    dy *= scale;
    centerX += dx;
    centerY += dy;
    return new Point(Math.round(centerX), Math.round(centerY));
}
 */


@end
