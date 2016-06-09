//
//  RUEnumIsInRangeSynthesization.h
//  Pods
//
//  Created by Benjamin Maer on 6/7/16.
//
//

#ifndef RUEnumIsInRangeSynthesization_h
#define RUEnumIsInRangeSynthesization_h





#define RUEnumIsInRangeSynthesization(enumType, enumFirst, enumLast) \
BOOL enumType##__isInRange(enumType enumValue) \
{ \
	return ((enumValue >= enumFirst) && \
			(enumValue <= enumLast)); \
}

#define RUEnumIsInRangeSynthesization_autoFirstLast(enumType) \
RUEnumIsInRangeSynthesization(enumType, enumType##__first, enumType##__last)





#endif /* RUEnumIsInRangeSynthesization_h */
