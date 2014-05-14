//
//  LHAction.h
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHActionHandler
@end

@protocol LHActionInitiator
@optional
- (NSString *) friendlyName;
- (void) performAction;
@end

@interface LHAction : NSObject <LHActionInitiator>
@property (weak) id <LHActionHandler> parentDevice;

- (id) initWithParentDevice : (id <LHActionHandler>) aDevice;

@end
