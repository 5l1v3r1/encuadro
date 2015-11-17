//
//  HelloWorldView.h
//  ARtigas
//
//  Created by Pablo Flores Guridi on 13/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "isgl3d.h"
//#import "VistaViewController.h"
//#import "claseDibujar.h"

#ifdef __cplusplus
extern "C"{
#endif
    
#include "vvector.h"
	
#ifdef __cplusplus
}
#endif
//#import "configuration.h"
int jota;
bool fin;

@interface videoView : UIImageView <AVAudioPlayerDelegate> {
}

@end


@class Isgl3dDemoCameraController;
@interface HelloWorldView : Isgl3dBasic3DView {
    
@private
	// The rendered text
    Isgl3dMeshNode * _3dText;
    Isgl3dDemoCameraController * _cameraController;
    Isgl3dNode * _container;
    Isgl3dSkeletonNode * _model;
    Isgl3dNode * _model2;
    Isgl3dAnimationController * _animationController;
}
@property (nonatomic) float* eulerAngles;
@property (nonatomic) float* traslacion;
@property (nonatomic) float** rotacion;
@property(nonatomic, retain) Isgl3dNode* cubito1;
@property(nonatomic, retain) Isgl3dNode* cubito2;
@property (nonatomic, readwrite) int ARidObra;
- (id)initARType:(NSString*)ARType ARObj:(NSString*)ARObj ARObj2:(NSString*)ARObj2 ARObj3:(NSString*)ARObj3 ARObj4:(NSString*)ARObj4 ARObj5:(NSString*)ARObj5;

@end

#import "app0100AppDelegate.h"
@interface AppDelegate : app0100AppDelegate
- (void) createViews;
@end


