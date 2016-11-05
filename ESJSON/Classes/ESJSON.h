//
//  ESJSON.h
//  Pods
//
//  Created by Elliot Schrock on 11/5/16.
//
//

#import <Foundation/Foundation.h>

@protocol ESJSONKeyMapper <NSObject>
+ (NSDictionary *)esjsonPropertyToKeyMap;
@end

@interface ESJSON : NSObject
//@property (nonatomic, strong) NSMutableArray *serializers;

+ (NSDictionary *)toJson:(NSObject *)object;
+ (id)modelOfClass:(Class)clazz fromJson:(NSDictionary *)json;
@end
