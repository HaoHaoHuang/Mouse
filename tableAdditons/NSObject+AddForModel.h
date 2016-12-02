//
//  NSObject+AddForModel.h
//  TouTiao_student
//
//  Created by haohuang on 16/4/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AddForModel)

// 也会获取私有属性
+ (NSArray*)xtt_propertyNames;

- (void)xtt_setPropertiesWithDictionary:(NSDictionary*)dictionary;

// 该方法也会清空私有属性，使用请慎重
- (void)xtt_clearProperties;

// 也会获取私有属性
@property (nonatomic, readonly) NSArray* xtt_propertyNames;

// 也会对私有属性进行转换
@property (nonatomic, readonly) NSMutableDictionary* xtt_dictionary;

@end


@interface NSDictionary (ModelConvert)

- (id)xtt_modelOfClass:(Class)modelClass;

@end


@interface NSArray (ModelConvert)

// model数组转字典数组
@property (nonatomic, readonly) NSMutableArray* xtt_dictArray;

// 字典数组转model数组
- (NSMutableArray*)xtt_modelArrayOfClass:(Class)modelClass;

@end
