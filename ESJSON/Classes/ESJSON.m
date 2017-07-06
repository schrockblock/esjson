//
//  ESJSON.m
//  Pods
//
//  Created by Elliot Schrock on 11/5/16.
//
//

#import "ESJSON.h"
#import <objc/runtime.h>
#import "ISO8601DateFormatter.h"

@implementation ESJSON

+ (NSDictionary *)toJson:(NSObject *)object
{
    return [self toJson:object includingNilProperties:NO];
}

+ (NSDictionary *)toJson:(NSObject *)object includingNilProperties:(BOOL)shouldIncludeNilProperties
{
    NSMutableDictionary *json = [@{} mutableCopy];
    
    [self addPropertiesForClass:[object class] ofObject:object to:json includingNilProperties:shouldIncludeNilProperties];
    
    return [json copy];
}

+ (void)addPropertiesForClass:(Class)clazz ofObject:(NSObject *)object to:(NSMutableDictionary *)json includingNilProperties:(BOOL)shouldIncludeNilProperties
{
    NSDictionary *keyMap;
    if ([clazz respondsToSelector:@selector(esjsonPropertyToKeyMap)]) {
        keyMap = [[object class] esjsonPropertyToKeyMap];
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    for(int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            
            id value = [object valueForKey:propertyName];
            
            NSString *key = [self snakeCaseVersionOf:propertyName];
            if (keyMap[propertyName]) {
                key = keyMap[propertyName];
            }
            
            [self setOrSerialize:value json:json key:key includingNilProperties:shouldIncludeNilProperties];
        }
    }
    free(properties);
    
    if ([clazz superclass] != [NSObject class]) {
        [self addPropertiesForClass:[clazz superclass] ofObject:object to:json includingNilProperties:shouldIncludeNilProperties];
    }
}

+ (void)setOrSerialize:(id)value json:(NSMutableDictionary *)json key:(NSString *)key includingNilProperties:(BOOL)shouldIncludeNilProperties
{
    if (value == nil && shouldIncludeNilProperties) {
        json[key] = value;
    }else if (value) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray new];
            for (id arrayValue in ((NSArray *)value)) {
                [array addObject:[self jsonValueOf:arrayValue includingNilProperties:shouldIncludeNilProperties]];
            }
            json[key] = [array copy];
        }else{
            json[key] = [self jsonValueOf:value includingNilProperties:shouldIncludeNilProperties];
        }
    }
}

+ (id)jsonValueOf:(id)value includingNilProperties:(BOOL)shouldIncludeNilProperties
{
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] ) {
        return value;
    }else if ([value isKindOfClass:[NSDate class]]){
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        formatter.includeTime = YES;
        return [formatter stringFromDate:value];
    }else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray new];
        for (id arrayValue in ((NSArray *)value)) {
            [arrayValue addObject:[self jsonValueOf:arrayValue includingNilProperties:shouldIncludeNilProperties]];
        }
        return array;
    }else{
        return [self toJson:value includingNilProperties:shouldIncludeNilProperties];
    }
}

+ (id)modelOfClass:(Class)clazz fromJson:(NSDictionary *)json
{
    return [self modelOfClass:clazz fromJson:json includingNulls:NO];
}

+ (id)modelOfClass:(Class)clazz fromJson:(NSDictionary *)json includingNulls:(BOOL)shouldIncludeNulls
{
    id model = [[clazz alloc] init];
    
    NSDictionary *keyMap;
    if ([clazz respondsToSelector:@selector(esjsonPropertyToKeyMap)]) {
        keyMap = [clazz esjsonPropertyToKeyMap];
    }
    
    for (NSString *key in json.allKeys) {
        NSString *propertyName = [self llamaCaseVersionOf:key];
        
        for (NSString *propertyString in keyMap.allKeys) {
            if ([keyMap[propertyString] isEqualToString:key]) {
                propertyName = propertyString;
            }
        }
        
        if ([model respondsToSelector:NSSelectorFromString(propertyName)]) {
            id value = json[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                objc_property_t property = class_getProperty(clazz, [propertyName UTF8String]);
                Class propertyClass = [self classOfProperty:property];
                
                if (propertyClass == [NSDictionary class] || propertyClass == [NSMutableDictionary class]) {
                    [model setValue:json[key] forKey:propertyName];
                }else if (propertyClass == [NSDate class]){
                    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
                    formatter.includeTime = YES;
                    [model setValue:[formatter dateFromString:json[key]] forKey:propertyName];
                }else{
                    [model setValue:[self modelOfClass:propertyClass fromJson:json[key]] forKey:propertyName];
                }
            }else if (![value isKindOfClass:[NSNull class]] || shouldIncludeNulls){
                [model setValue:json[key] forKey:propertyName];
            }
        }
    }
    
    return model;
}

+ (Class)classOfProperty:(objc_property_t)property
{
    Class propertyClass = nil;
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0){
        // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

+ (NSString *)llamaCaseVersionOf:(NSString *)key
{
    NSString *llamaCase = @"";
    NSArray *stringArray = [key componentsSeparatedByString:@"_"];
    for (int i = 0; i < stringArray.count; i++) {
        NSString *string = stringArray[i];
        if (i != 0) {
            string = [string capitalizedString];
        }
        llamaCase = [NSString stringWithFormat:@"%@%@", llamaCase, string];
    }
    return llamaCase;
}

+ (NSString *)snakeCaseVersionOf:(NSString *)propertyName
{
    NSString *snakeCase = propertyName;
    NSRange range = [snakeCase rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    while (range.location != NSNotFound) {
        NSString *substring = [snakeCase substringWithRange:range];
        snakeCase = [snakeCase stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"_%@",[substring lowercaseString]]];
        range = [snakeCase rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    }
    return snakeCase;
}

//- (NSMutableArray *)serializers
//{
//    if (!_serializers) _serializers = [@{} mutableCopy];
//    return _serializers;
//}

@end
