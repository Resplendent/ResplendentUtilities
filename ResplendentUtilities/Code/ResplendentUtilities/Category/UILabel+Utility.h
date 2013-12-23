//
//  UILabel+Utility.h
//  Albumatic
//
//  Created by Ben Maer on 9/26/12.
//
//

#import <UIKit/UIKit.h>

CG_INLINE CGSize textSizeConstrainedToWidth(UILabel* label, CGFloat width)
{
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:label.lineBreakMode];
}

CG_INLINE CGSize textSizeConstrained(UILabel* label)
{
    return [label.text sizeWithFont:label.font];
}

CG_INLINE void setHeightToTextSizeWithCoords(UILabel* label, CGFloat xCoord, CGFloat yCoord, CGFloat width)
{
    [label setFrame:CGRectMake(xCoord, yCoord, width, textSizeConstrainedToWidth(label, width).height)];
}
