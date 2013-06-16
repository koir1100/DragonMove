//
//  HowtoLayer.h
//  DragonMove
//
//  Created by DongGyu Park(My Professor's name) on 13. 2. 14..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"

enum {
	kTagHowtoBackground = 50,
	kTagHowtoMenu,
	kTagLogoIntroBackground,
	kTagLogoIntroMenu,
    kTagScrollView,
};

@interface HowtoLayer : CCLayer <UIScrollViewDelegate>
{
    //IntroLogoScrollView *introLogoScrollView;
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIImage *imageBG;
}

// 게임을 어떻게 하는지 UIScrollViewDelegate protocol을 통해 scrolling 기능을 처리할 수 있음


@property (nonatomic, retain) UIImage *imageBG;

-(void) menuMoveUpDown:(id)sender withOffset:(int)offset;
-(void) menuMove1:(id)sender;

@end
