//
//  HelloWorldView.m
//  ARtigas
//
//  Created by Pablo Flores Guridi on 13/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"
#import "Isgl3dViewController.h"
#include "Isgl3dPODImporter.h"


/*viewView*/
@implementation videoView


- (id) init {
	
	if ((self = [super init])) {
        
	}
	
	return self;
}



- (void) dealloc {
    
	[super dealloc];
}

@end


/*HelloWorldView*/
@interface HelloWorldView()

@end


@implementation HelloWorldView


@synthesize traslacion = _traslacion;
@synthesize eulerAngles = _eulerAngles;
@synthesize rotacion = _rotacion;
@synthesize cubito1 = _cubito1;
@synthesize cubito2 = _cubito2;
@synthesize ARidObra = _ARidObra;

float punto3D1[3], punto3D2[3], punto3D3[3], punto3D4[3], puntoModelo3D1[4] = {0,0,0,1}, puntoModelo3D2[4] = {190,0,-30,1}, puntoModelo3D3[4] = {0,100,-30,1};// puntoModelo3D4[4] = {0,0,-60,1};
/*Si queremos meter cubos*/
//puntoModelo3D2[4] = {187.5,0,35/2,1}, puntoModelo3D3[4] = {0,105,35/2,1},
Isgl3dMatrix4 Matriz;
Isgl3dVector3 angles;
//float rotacion[3][3];

NSString *estring;



Isgl3dNode * _container;
Isgl3dKeyframeMesh * _mesh;

Isgl3dPODImporter * podImporter;
Isgl3dPODImporter * podImporter2;
Isgl3dPODImporter * podImporter3;
Isgl3dPODImporter * podImporter4;
Isgl3dPODImporter * podImporter5;
Isgl3dGLMesh* _ARmesh;
Isgl3dGLMesh* _ARmesh2;
Isgl3dGLMesh* _ARmesh3;
Isgl3dGLMesh* _ARmesh4;
Isgl3dGLMesh* _ARmesh5;
Isgl3dNode * node;

int i;
double k;
bool touched;

#ifndef OLD_ISGL3D
+ (id<Isgl3dCamera>)createDefaultSceneCameraForViewport:(CGRect)viewport {
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"creating default camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewport.size));

	float fovyRadians = Isgl3dMathDegreesToRadians(34.441f);
	Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewport.size fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];

	Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 0.01f);
	Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
	Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
	Isgl3dLookAtCamera *standardCamera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens
																									 eyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:cameraPosition.z
																								 centerX:cameraLookAt.x centerY:cameraLookAt.y centerZ:cameraLookAt.z
																									  upX:cameraLookUp.x upY:cameraLookUp.y upZ:cameraLookUp.z];
	[perspectiveLens release];
	return [standardCamera autorelease];
}
#endif

- (id) initARType:(NSString*)ARType ARObj:(NSString*)ARObj ARObj2:(NSString *)ARObj2 ARObj3:(NSString *)ARObj3 ARObj4:(NSString *)ARObj4 ARObj5:(NSString *)ARObj5{
    NSLog(@"INIT DEL HW");
   //printf("ArID desde HWORLD: %d\n",Ar);
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        NSLog(@"AR TYPE HW ES: %@",ARType);
        NSLog(@"AR OBJ HW ES: %@",ARObj);
    
//        if(Artigas){
        /* Create a container node as a parent for all scene objects.*/
        _container = [self.scene createNode];
        
     
        if([ARType isEqual:@"animacion"])
        {
        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
        
       
            
        NSLog(@"%@",ARObj);
        podImporter = [Isgl3dPODImporter  podImporterWithFile:ARObj];
        [podImporter buildSceneObjects];
        podImporter2 = [Isgl3dPODImporter podImporterWithFile:ARObj2];
        [podImporter2 buildSceneObjects];
        podImporter3 = [Isgl3dPODImporter podImporterWithFile:ARObj3];
        [podImporter3 buildSceneObjects];
        podImporter4 = [Isgl3dPODImporter podImporterWithFile:ARObj4];
        [podImporter4 buildSceneObjects];
        podImporter5 = [Isgl3dPODImporter podImporterWithFile:ARObj5];
        [podImporter5 buildSceneObjects];
        
        
        
        _ARmesh = [podImporter meshAtIndex:0 ];
        _ARmesh2 = [podImporter2 meshAtIndex:0 ];
        _ARmesh3 = [podImporter3 meshAtIndex:0 ];
        _ARmesh4 = [podImporter4 meshAtIndex:0 ];
        _ARmesh5 = [podImporter5 meshAtIndex:0 ];
        
        
        
        _mesh = [Isgl3dKeyframeMesh keyframeMeshWithMesh:_ARmesh];
        [_mesh addKeyframeMesh:_ARmesh2];
        [_mesh addKeyframeMesh:_ARmesh3];
        [_mesh addKeyframeMesh:_ARmesh4];
        [_mesh addKeyframeMesh:_ARmesh5];
        
        
//        [_mesh addKeyframeAnimationData:0 duration:1.0f];
//        [_mesh addKeyframeAnimationData:3 duration:1.0f];
//		[_mesh addKeyframeAnimationData:5 duration:2.0f];
//        [_mesh addKeyframeAnimationData:3 duration:1.0f];
//        [_mesh addKeyframeAnimationData:0 duration:2.0f];
        
        
        node = [_container createNodeWithMesh:_mesh andMaterial:[podImporter materialWithName:@"material_0"]];
		node.position = iv3(0,-50, 0);
        [podImporter addMeshesToScene:node];
        node.rotationX=90;
        node.rotationZ=90;
        
        node.scaleX=4;
        node.scaleY=4;
        node.scaleZ=4;
        
        Isgl3dNode * node2 = [_container createNodeWithMesh:_ARmesh andMaterial:[podImporter materialWithName:@"material_0"]];
		node2.position = iv3(0, -50, 0);
        node2.rotationX=90;
        node2.rotationZ=90;
        node2.alpha =0.0;
        node2.scaleX=4;
        node2.scaleY=4;
        node2.scaleZ=4;
        
        /*Agregamos interactividad*/
        node2.interactive =YES;
        [node2 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
        
        }
        
        if([ARType isEqual:@"modelo"])
        {
         
            /*--------------|INTRODUCIMOS EL MODELO|------------------*/
            NSLog(@"ARType:%@\n",ARType);
            NSLog(@"ARObj:%@\n",ARObj);

            Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:ARObj];
              
            node = [_container createNode];
        
            
            node.scaleX=5;
            node.scaleY=5;
            node.scaleZ=5;
            node.rotationZ = 90;
            
            [podImporter addMeshesToScene:node];

            node.position = iv3(190, -50, 0);
         
         
         
        }
        /*----------------------------------|LUCES|----------------------------------*/
        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light];
        light.position = iv3(-2, 2, -10);
        
        //light.renderLight = YES;
        
        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light2];
        light2.position = iv3(2, 2, -10);
        
        //light2.renderLight = YES;
        //
        //        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
        //		[self.scene addChild:light3];
        //        light3.position = iv3(-2, -2, -10);
        //
        //light3.renderLight = YES;
        
        
        Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light4];
        light4.position = iv3(2, -2, -10);
        
        //light4.renderLight = YES;
        /*----------------------------------|CAMARA|----------------------------------*/
        #ifdef OLD_ISGL3D
        self.camera.position = iv3(0,0,0.01);
        [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
        
        /*Seteamos el fov.*/
        self.camera.fov = 34.441;
#endif
        [self schedule:@selector(tick:)];
//        }else{
//        
//            /* Create a container node as a parent for all scene objects.*/
//                    _container = [self.scene createNode];
//            
//                    // Create the primitive
//            		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//                    Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
//            
//                    _cubito1 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
//                    _cubito1.position = iv3(0,0,0);
//            
//                    if (DosCubos) {
//                        _cubito2 = [_container createNodeWithMesh:cubeMesh andMaterial:material];
//                        _cubito2.position = iv3(190,0,0);
//                    }
//                    else{
//                    //UN CUBO Y modelos POD
//                        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
//            
//                        Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"chihuahua.pod"];
//                        Isgl3dPODImporter * podImporter2 = [Isgl3dPODImporter podImporterWithFile:@"sofa.pod"];
//            
//                        _model = [_container createSkeletonNode];
//                        _model2 = [_container createSkeletonNode];
//            
//                        _model.scaleX=5;
//                        _model.scaleY=5;
//                        _model.scaleZ=5;
//                        _model.rotationZ = 90;
//            
//                        _model2.scaleX=15;
//                        _model2.scaleY=15;
//                        _model2.scaleZ=15;
//            
//            
//            
//                        [podImporter addMeshesToScene:_model];
//                       // [podImporter printPODInfo];
//                        [podImporter2 addMeshesToScene:_model2];;
//            
//                        //		_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:_model andNumberOfFrames:[podImporter numberOfFrames]];
//                        //		[_animationController start];
//            
//                        _model.position = iv3(0, -100, 0);
//                        _model2.position = iv3(190,-100,0);
//            
//                        Isgl3dShadowCastingLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//                        [self.scene addChild:light];
//                        light.position = iv3(-2, 2, -10);
//            
//                        //light.renderLight = YES;
//            
//                        Isgl3dShadowCastingLight * light2  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//                        [self.scene addChild:light2];
//                        light2.position = iv3(2, 2, -10);
//            
//                        //light2.renderLight = YES;
//            
//                        Isgl3dShadowCastingLight * light3  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//                        [self.scene addChild:light3];
//                        light3.position = iv3(-2, -2, -10);
//                       //            //light3.renderLight = YES;
//            
//            
//                        Isgl3dShadowCastingLight * light4  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
//                        [self.scene addChild:light4];
//                        light4.position = iv3(2, -2, -10);
//            
//                        //light4.renderLight = YES;
//            
//            
//                        /*--------------|INTRODUCIMOS EL MODELO|------------------*/
//            
//            
//                    }
//            
//            
//            
//                    Isgl3dTextureMaterial * esquinasMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"esquinas.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
//            		Isgl3dGLUIButton * esquinasButton = [Isgl3dGLUIButton buttonWithMaterial:esquinasMaterial width:14.4 height:9.8];
//            		[self.scene addChild:esquinasButton];
//                    //esquinasButton.position = iv3(-15,-20,0);
//                   [esquinasButton setX:25 andY:15];
//                    esquinasButton.interactive = YES;
//                    [esquinasButton addEvent3DListener:self method:@selector(buttonTouched:) forEventType:TOUCH_EVENT];
//            
//
//            
//                    _cubito1.interactive =YES;
//                   [_cubito1 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
//            
//                    self.camera.position = iv3(0,0,0.1);
//                    [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
//            
//                    /*Seteamos el fov.*/
//                    self.camera.fov = 32;
//            
//                    [self schedule:@selector(tick:)];
//            
//        
//        }
        
    }
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis
    //NSLog(@"tick\n");
    if (self.traslacion != nil & _rotacion!=nil)
    {
#ifdef OLD_ISGL3D
		 Matriz.sxx = _rotacion[0][0];
		 Matriz.sxy = _rotacion[0][1];
		 Matriz.sxz = _rotacion[0][2];
		 Matriz.tx = self.traslacion[0];

		 Matriz.syx = _rotacion[1][0];
		 Matriz.syy = _rotacion[1][1];
		 Matriz.syz = _rotacion[1][2];
		 Matriz.ty = self.traslacion[1];

		 Matriz.szx = _rotacion[2][0];
		 Matriz.szy = _rotacion[2][1];
		 Matriz.szz = _rotacion[2][2];
		 Matriz.tz = self.traslacion[2];

		 Matriz.swx = 0;
		 Matriz.swy = 0;
		 Matriz.swz = 0;
		 Matriz.tw = 1;
#else
		 //FIXME: JUANC, this need to be checked
		 Matriz.m00 = _rotacion[0][0];
		 Matriz.m01 = _rotacion[0][1];
		 Matriz.m02 = _rotacion[0][2];
		 Matriz.m03 = self.traslacion[0];

		 Matriz.m10 = _rotacion[1][0];
		 Matriz.m11 = _rotacion[1][1];
		 Matriz.m12 = _rotacion[1][2];
		 Matriz.m13 = self.traslacion[1];

		 Matriz.m20 = _rotacion[2][0];
		 Matriz.m21 = _rotacion[2][1];
		 Matriz.m22 = _rotacion[2][2];
		 Matriz.m23 = self.traslacion[2];

		 Matriz.m30 = 0;
		 Matriz.m31 = 0;
		 Matriz.m32 = 0;
		 Matriz.m33 = 1;
#endif

#ifdef ENABLE_3D
        angles = im4ToEulerAngles(&Matriz);
#endif
        //        printf("\nisgl3d solucion\n");
        //        printf("psi1: %f\ntheta1: %f\nphi1: %f\n",angles.x,angles.y,angles.z);
        
        
        /*project CoplanarPosit*/
        float a[3],b[3];
        b[0]=puntoModelo3D1[0];
        b[1]=puntoModelo3D1[1];
        b[2]=puntoModelo3D1[2];
        MAT_DOT_VEC_3X3(a, _rotacion, b);
        VEC_SUM(punto3D1,a,self.traslacion);
        
        if (punto3D1[0] < INFINITY)
        {
            
            _container.position = iv3(punto3D1[0], -punto3D1[1], -punto3D1[2]);
            
            _container.rotationX =0;
            _container.rotationY = 0;
            _container.rotationZ = 0;
            
            [_container roll:-angles.z];
            [_container yaw:-angles.y];
            [_container pitch:angles.x];
            
            
        }
    }
    
    if(touched)
    {
        
        k = ((double)i)/60;
        
        /*Levantando la mano*/
        
        if(k<0.5) [_mesh interpolateMesh1:0 andMesh2:1 withFactor:2*k];
        if(0.5<=k && k<1) [_mesh interpolateMesh1:1 andMesh2:2 withFactor:fmod(2*k, 1.0)];
        if(1<=k && k<2) [_mesh interpolateMesh1:2 andMesh2:3 withFactor:fmod(k, 1.0)];
        
        if(4<=k && k<5) [_mesh interpolateMesh1:3 andMesh2:4 withFactor:fmod(k, 1.0)];
        if(5<=k && k<6) [_mesh interpolateMesh1:4 andMesh2:0 withFactor:fmod(k, 1.0)];
        if(k==6) touched=false;
        
        /*Sin levantar la mano*/
        
        //    if(k<1) [_mesh interpolateMesh1:0 andMesh2:4 withFactor:k];
        //    if(1<=k && k<2) [_mesh interpolateMesh1:4 andMesh2:3 withFactor:fmod(k, 1.0)];
        //
        //    if(4<=k && k<5) [_mesh interpolateMesh1:3 andMesh2:4 withFactor:fmod(k, 1.0)];
        //    if(5<=k && k<6) [_mesh interpolateMesh1:4 andMesh2:0 withFactor:fmod(k, 1.0)];
        //    if(k==6) touched=false;
        
        
        
        i++;
    }
    
}
-(void) objectTouched:(Isgl3dEvent3D *)event {
    
    i=0;
    
    
    
    touched = true;
}


@end

