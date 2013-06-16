//
//  IntroLayer.m
//  Report_7
//
//  Created by Apple on 13. 5. 22..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


#import "IntroLayer.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}


-(void) onEnter
{
	[super onEnter];

	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
		background = [CCSprite spriteWithFile:@"bg_start.png"];
	}
    else
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	background.position = ccp(size.width/2, size.height/2);

	[self addChild: background];
	
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	[SceneManager goMenu];
}
@end
