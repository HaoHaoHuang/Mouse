//
//  NSObject+AddForModel.m
//  TouTiao_student
//
//  Created by haohuang on 16/4/15.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "NSObject+AddForModel.h"
#import <objc/runtime.h>

@implementation NSObject (AddForModel)

+ (NSArray *)xtt_propertyNames
{
    NSMutableArray* mPropertyNames = [NSMutableArray arrayWithCapacity:6];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString* propertyStr = [NSString stringWithFormat:@"%s", property_getName(property)];
        [mPropertyNames addObject:propertyStr];
    }
    free(properties);
    return mPropertyNames;
}

- (NSArray *)xtt_propertyNames
{
    NSArray* proNames = objc_getAssociatedObject(self, _cmd);
    if (!proNames) {
        proNames = [[self class] xtt_propertyNames];
        objc_setAssociatedObject(self, _cmd, proNames, OBJC_ASSOCIATION_RETAIN);
    }
    return proNames;
}

- (NSMutableDictionary *)xtt_dictionary
{
    NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithCapacity:6];
    for (NSString* propetyName in self.xtt_propertyNames) {
        [mDic setValue:[self valueForKey:propetyName] forKey:propetyName];
    }
    [mDic removeObjectForKey:@"debugDescription"];
    [mDic removeObjectForKey:@"description"];
    [mDic removeObjectForKey:@"superclass"];
    [mDic removeObjectForKey:@"hash"];
    return mDic;
}

- (void)xtt_setPropertiesWithDictionary:(NSDictionary *)dictionary
{
    for (NSString* proName in self.xtt_propertyNames) {
        
        id proValue = [dictionary valueForKey:proName];
        if (!proValue) {
            NSLog(@"%@不存在key(%@)", dictionary, proName);
        }
        else {
            
            NSString* pNamePrefix = [proName substringToIndex:1].capitalizedString;
            NSString* pNameSuffix = [proName substringFromIndex:1];
            NSString* setProName = [@"set" stringByAppendingFormat:@"%@%@:", pNamePrefix, pNameSuffix];
            if (![self respondsToSelector:NSSelectorFromString(setProName)]) {
                NSLog(@"当前类[%@] 没有该方法(%@)", [self class], setProName);
            }
            else {
                [self setValue:proValue forKey:proName];
            }
        }
    }
}

- (void)xtt_clearProperties
{
    for (NSString* proName in self.xtt_propertyNames) {
        NSString* pNamePrefix = [proName substringToIndex:1].capitalizedString;
        NSString* pNameSuffix = [proName substringFromIndex:1];
        NSString* setProName = [@"set" stringByAppendingFormat:@"%@%@:", pNamePrefix, pNameSuffix];
        if (![self respondsToSelector:NSSelectorFromString(setProName)]) {
            NSLog(@"当前类[%@] 没有该方法(%@)", [self class], setProName);
        }
        else {
            [self setValue:nil forKey:proName];
        }
    }
}

@end


@implementation NSDictionary (ModelConvert)

- (id)xtt_modelOfClass:(Class)modelClass
{
    id model = [[modelClass alloc] init];
    for (NSString* key in self.allKeys) {
        
        if (key.length < 1) {
            continue;
        }
        
        NSString* keyPrefix = [key substringToIndex:1].capitalizedString;
        NSString* keySuffix = [key substringFromIndex:1];
        
        NSString* setKey = [@"set" stringByAppendingFormat:@"%@%@:", keyPrefix, keySuffix];
        if ([model respondsToSelector:NSSelectorFromString(setKey)]) {
            [model setValue:[self valueForKey:key] forKey:key];
        }
        else {
            NSLog(@"类[%@] 没有该方法(%@)", modelClass, setKey);
        }
    }
    return model;
}

@end


@implementation NSArray (ModelConvert)

- (NSMutableArray *)xtt_dictArray
{
    NSMutableArray* mDictArr = [NSMutableArray arrayWithCapacity:6];
    for (NSObject* model in self) {
        [mDictArr addObject:model.xtt_dictionary];
    }
    return mDictArr;
}

- (NSMutableArray *)xtt_modelArrayOfClass:(Class)modelClass
{
    NSMutableArray* mModelArr = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary* dic in self) {
        [mModelArr addObject:[dic xtt_modelOfClass:modelClass]];
    }
    return mModelArr;
}

@end
