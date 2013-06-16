//
//  HowtoLayer.m
//  Cocos2dGame
//
//  Created by DongGyu Park on 13. 2. 14..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "HowtoLayer.h"

@implementation HowtoLayer

- (id) init {
	if((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg_hotwo.png"];
		[bgSprite setAnchorPoint:CGPointZero];
		[bgSprite setPosition:CGPointZero];
		[self addChild:bgSprite z:0 tag:kTagHowtoBackground];
        // HowtoLayer에 필요한 이미지 삽입
        
		CCMenuItem *closeMenuItem = [CCMenuItemImage itemWithNormalImage:@"btn_1.png" selectedImage:@"btn_2.png" target:self selector:@selector(closeMenuCallback:)];
		CCMenu *menu = [CCMenu menuWithItems:closeMenuItem, nil];
		menu.position = ccp(size.width*4/5, size.height*1/15);
		[self addChild:menu z:133 tag:kTagHowtoMenu];
        // 돌아가기 버튼 제작
	}
	return self;
}

- (void) closeMenuCallback: (id) sender
{
	[SceneManager goMenu];
}

@end
