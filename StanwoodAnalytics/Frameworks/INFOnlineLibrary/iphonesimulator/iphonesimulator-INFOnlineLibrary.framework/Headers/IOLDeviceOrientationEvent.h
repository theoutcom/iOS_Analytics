//
//  IOLDeviceOrientationEvent.h
//  INFOnlineLibrary
//
//  Created by Michael Ochs on 7/26/12.
//  Copyright (c) 2012 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLDeviceOrientationEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLDeviceOrientationEvent : IOLEvent

/**
 Initializes an IOLDeviceOrientationEvent object with its IOLDeviceOrientationEventTypeChanged.
 
 @return The created IOLDeviceOrientationEvent.
 */
- (instancetype)init;

/**
 Initializes an IOLDeviceOrientationEvent object with its IOLDeviceOrientationEventTypeChanged, category and comment.
 
 @param category The category you want to set for this IOLDeviceOrientationEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLDeviceOrientationEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLDeviceOrientationEvent.
 */
- (instancetype)initWithCategory:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLDeviceOrientationEvent object with its IOLDeviceOrientationEventTypeChanged, category, comment and parameter.
 
 @param category The category you want to set for this IOLDeviceOrientationEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLDeviceOrientationEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLDeviceOrientationEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLDeviceOrientationEvent.
 */
- (instancetype)initWithCategory:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter ;

@end

NS_ASSUME_NONNULL_END
