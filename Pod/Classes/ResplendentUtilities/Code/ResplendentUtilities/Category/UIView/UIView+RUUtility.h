//
//  Resplendent
//
//  Created by Benjamin Maer on 5/6/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PINE_ANIMATION_ROTATION_DEGREES 20.0f * M_PI / 180.0f
#define PINE_ANIMATION_TRANSLATION_DEPTH 100.0f

#pragma mark - frame modifiers

#define CGRectSetX(x, rect) (CGRectMake(x, (rect).origin.y, (rect).size.width, (rect).size.height))
#define CGRectSetY(y, rect) (CGRectMake((rect).origin.x, y, (rect).size.width, (rect).size.height))
#define CGRectSetXY(x, y, rect) (CGRectMake(x, y, (rect).size.width, (rect).size.height))
#define CGRectSetOrigin(o, rect) ((CGRect){o,(rect).size})
#define CGRectSetYHeight(y,height, rect) (CGRectMake((rect).origin.x, y, (rect).size.width, height))
#define CGRectSetWidth(w, rect) (CGRectMake((rect).origin.x, (rect).origin.y, w, (rect).size.height))
#define CGRectSetHeight(h, rect) (CGRectMake((rect).origin.x, (rect).origin.y, (rect).size.width, (h)))
#define CGRectSetSize(s, rect) ((CGRect){(rect).origin.x, (rect).origin.y, (s)})
#define CGRectFlipY(rect) (CGRectMake((rect).origin.x, -((rect).origin.y), (rect).size.width, (rect).size.height))
#define CGRectMultiply(m, rect) (CGRectMake((rect).origin.x*(m), (rect).origin.y*(m), (rect).size.width*(m), (rect).size.height*(m)))
#define CGRectRotate(rect) (CGRectMake((rect).origin.x, (rect).origin.y, (rect).size.height, (rect).size.width))

#define CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(width,onWidth) (((onWidth) - (width)) / 2.0f)
#define CGRectGetHorizontallyAlignedXCoordForRectOnRect(rect,onRect) CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(CGRectGetWidth(rect),CGRectGetWidth(onRect))
#define CGRectGetHorizontallyAlignedXCoordForViewonView(view,onView) CGRectGetHorizontallyAlignedXCoordForRectOnRect(view.frame,onView.frame)
#define CGRectSetFrameWithHorizontallyAlignedXCoordOnWidth(y,width,height,onWidth) CGRectMake(CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(width,onWidth),y,width,height)
#define CGRectSetFrameWithHorizontallyAlignedXCoordOnRect(y,width,height,onRect) CGRectSetFrameWithHorizontallyAlignedXCoordOnWidth(y,width,height,CGRectGetWidth(onRect))
#define CGRectSetFrameWithHorizontallyAlignedXCoordOnView(y,width,height,onView) CGRectSetFrameWithHorizontallyAlignedXCoordOnRect(y,width,height,onView.frame)

#define CGRectGetVerticallyAlignedYCoordForHeightOnHeight(height,onHeight) (((onHeight) - (height)) / 2.0f)
#define CGRectGetVerticallyAlignedYCoordForRectOnRect(rect,onRect) CGRectGetVerticallyAlignedYCoordForHeightOnHeight(CGRectGetHeight(rect),CGRectGetHeight(onRect))
#define CGRectGetVerticallyAlignedYCoordForViewonView(view,onView) CGRectGetVerticallyAlignedYCoordForRectOnRect(view.frame,onView.frame)
#define CGRectSetFrameWithVerticallyAlignedYCoordOnHeight(x,width,height,onHeight) CGRectMake(x,CGRectGetVerticallyAlignedYCoordForHeightOnHeight(height,onHeight),width,height)
#define CGRectSetFrameWithVerticallyAlignedYCoordOnRect(x,width,height,onRect) CGRectSetFrameWithVerticallyAlignedYCoordOnHeight(x,width,height,CGRectGetHeight(onRect))
#define CGRectSetFrameWithVerticallyAlignedYCoordOnView(x,width,height,onView) CGRectSetFrameWithVerticallyAlignedYCoordOnRect(x,width,height,onView.frame)

#define CGRectSizeThatFitsRect(rect) ((CGSize){.width = CGRectGetMaxX(rect),.height = CGRectGetMaxY(rect)})

CG_INLINE CGRect CGRectFloorOrigin(CGRect rect)
{
	return (CGRect){
		.origin.x = floor(rect.origin.x),
		.origin.y = floor(rect.origin.y),
		.size = rect.size,
	};
}

CG_INLINE CGRect CGRectCeilOrigin(CGRect rect)
{
	return (CGRect){
		.origin.x = ceil(rect.origin.x),
		.origin.y = ceil(rect.origin.y),
		.size = rect.size,
	};
}

CG_INLINE UIEdgeInsets ru_CGRectGetEdgeInsetsFromFrameToTargetSize(CGRect parentFrame, CGSize targetSize)
{
	CGFloat horizontalPadding = (CGRectGetWidth(parentFrame) - targetSize.width) / 2.0f;
	CGFloat verticalPadding = (CGRectGetHeight(parentFrame) - targetSize.height) / 2.0f;
	
	return (UIEdgeInsets){
		.top = verticalPadding,
		.bottom = verticalPadding,
		.left = horizontalPadding,
		.right = horizontalPadding,
	};
}

#pragma mark Set origin methods
CG_INLINE void setCoords(UIView* view,CGFloat xCoord,CGFloat yCoord)
{
    [view setFrame:CGRectMake(xCoord, yCoord, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
}

CG_INLINE void setXCoord(UIView* view,CGFloat xCoord)
{
    setCoords(view, xCoord, view.frame.origin.y);
}

CG_INLINE void setYCoord(UIView* view,CGFloat yCoord)
{
    setCoords(view, view.frame.origin.x, yCoord);
}


#pragma mark Increase origin methods

CG_INLINE void increaseXCoord(UIView* view,CGFloat xIncrement)
{
    setXCoord(view, view.frame.origin.x + xIncrement);
}

CG_INLINE void increaseYCoord(UIView* view,CGFloat yIncrement)
{
    setYCoord(view, view.frame.origin.y + yIncrement);
}

CG_INLINE void increaseCoords(UIView* view,CGFloat xIncrement,CGFloat yIncrement)
{
    setCoords(view, view.frame.origin.x + xIncrement, view.frame.origin.y + yIncrement);
}

#pragma mark Set frame methods
CG_INLINE void setSize(UIView* view,CGSize size)
{
    [view setFrame:(CGRect){view.frame.origin,size}];
}

CG_INLINE void setWidthHeight(UIView* view,CGFloat width,CGFloat height)
{
    setSize(view, (CGSize){width,height});
}

CG_INLINE void setWidth(UIView* view,CGFloat width)
{
    setWidthHeight(view, width, CGRectGetHeight(view.frame));
}

CG_INLINE void setHeight(UIView* view,CGFloat height)
{
    setWidthHeight(view, CGRectGetWidth(view.frame), height);
}

CG_INLINE void ceilCoordinates(UIView* view)
{
    setCoords(view, ceilf(view.frame.origin.x), ceilf(view.frame.origin.y));
}

CG_INLINE void ceilSize(UIView* view)
{
    setWidthHeight(view, ceilf(CGRectGetWidth(view.frame)), ceilf(CGRectGetHeight(view.frame)));
}

#pragma mark Increase frame methods

CG_INLINE void increaseSize(UIView* view,CGFloat widthIncrease,CGFloat heightIncrease)
{
    setWidthHeight(view, CGRectGetWidth(view.frame) + widthIncrease, CGRectGetHeight(view.frame) + heightIncrease);
}

CG_INLINE void increaseWidth(UIView* view,CGFloat widthIncrease)
{
    setWidth(view, CGRectGetWidth(view.frame) + widthIncrease);
}

CG_INLINE void increaseHeight(UIView* view,CGFloat heightIncrease)
{
    setHeight(view, CGRectGetHeight(view.frame) + heightIncrease);
}



@interface UIView (RUUtility)

-(UIView*)addUnderline;
-(UIView*)addUnderlineWithColor:(UIColor*)color;
-(UIView*)addUnderlineWithColorFloat:(float)colorFloat;
-(UIView*)addUnderlineWithColorFloat:(float)colorFloat withWidth:(float)width;
-(UIView*)addUnderlineWithColorFloat:(float)colorFloat withWidth:(float)width height:(float)height;

-(UIView*)addOverline;
-(UIView*)addOverlineWithColorFloat:(float)colorFloat;
-(UIView*)addOverlineWithColorFloat:(float)colorFloat withWidth:(float)width;

-(UIView*)addDividerLineWithColorFloat:(float)colorFloat withWidth:(float)width atYCoord:(float)yCoord height:(float)height;

-(void)setShadowSize:(CGSize)shadowSize radius:(float)radius opacity:(float)opacity;
-(void)setShadowColor:(UIColor*)color;
-(void)setShadowHeight:(float)shadowHeight radius:(float)radius opacity:(float)opacity;

//Animations
-(void)animateWithFallbackStart:(void (^)())start middle:(void (^)())middle end:(void (^)(BOOL finished))completion;
-(void)animateWithFallfrontStart:(void (^)())start middle:(void (^)())middle end:(void (^)(BOOL finished))completion;

-(void)animateMoveBackStart:(void (^)())start completion:(void (^)(BOOL finished))completion;
-(void)animateMoveFrontStart:(void (^)())start completion:(void (^)(BOOL finished))completion;

-(void)increaseWidth:(CGFloat)width;
-(void)increaseHeight:(CGFloat)height;
-(void)increaseWidth:(CGFloat)width height:(CGFloat)height;

@end
