//
//  AppDelegate.h
//  tractor-mac
//
//  Created by Michael Bass on 12/17/11.
//  Copyright Macadamian 2011. All rights reserved.
//

#import "cocos2d.h"

@interface tractor_macAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
