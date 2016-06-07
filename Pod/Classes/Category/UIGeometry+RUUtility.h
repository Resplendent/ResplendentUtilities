//
//  UIGeometry+RUUtility.h
//  Pods
//
//  Created by Benjamin Maer on 3/19/16.
//
//

#ifndef UIGeometry_RUUtility_h
#define UIGeometry_RUUtility_h

@import UIKit;





static inline UIEdgeInsets RU_UIEdgeInsetsMakeAll(CGFloat insetValue) {
	return (UIEdgeInsets){
		.left		= insetValue,
		.right		= insetValue,
		.top		= insetValue,
		.bottom		= insetValue,
	};
}

static inline UIEdgeInsets RU_UIEdgeInsetsInvert(UIEdgeInsets edgeInsets) {
	return (UIEdgeInsets){
		.left		= -edgeInsets.left,
		.right		= -edgeInsets.right,
		.top		= -edgeInsets.top,
		.bottom		= -edgeInsets.bottom,
	};
}





#endif /* UIGeometry_RUUtility_h */
