//
//  processing.c
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "processing.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <float.h>

/*--------------------------------------Definiciones de tipos-------------------------------------*/
//typedef struct image_double_s
//{
//    double * data;
//    unsigned int xsize,ysize;
//} * image_double;
//
//typedef struct ntuple_list_s
//{
//    unsigned int size;
//    unsigned int max_size;
//    unsigned int dim;
//    double * values;
//} * ntuple_list;


/*--------------------------------------Definiciones de tipos-------------------------------------*/
/*----------------------------------------------------------------------------*/
/** Fatal error, print a message to standard-error output and exit.
 */
static void error(char * msg)
{
    fprintf(stderr,"LSD Error: %s\n",msg);
    exit(EXIT_FAILURE);
}

/*----------------------------------------------------------------------------*/
/** Create a new image_double of size 'xsize' times 'ysize'.
 */
static image_double new_image_double(unsigned int xsize, unsigned int ysize)
{
    image_double image;
    
    /* check parameters */
    if( xsize == 0 || ysize == 0 ) error("new_image_double: invalid image size.");
    
    /* get memory */
    image = (image_double) malloc( sizeof(struct image_double_s) );
    if( image == NULL ) error("not enough memory.");
    image->data = (double *) calloc( (size_t) (xsize*ysize), sizeof(double) );
    if( image->data == NULL ) error("not enough memory.");
    
    /* set image size */
    image->xsize = xsize;
    image->ysize = ysize;
    
    return image;
}

/*----------------------------------------------------------------------------*/
/** Create an n-tuple list and allocate memory for one element.
@param dim the dimension (n) of the n-tuple.
*/
static ntuple_list new_ntuple_list(unsigned int dim)
{
    ntuple_list n_tuple;
    
    /* check parameters */
    if( dim == 0 ) error("new_ntuple_list: 'dim' must be positive.");
    
    /* get memory for list structure */
    n_tuple = (ntuple_list) malloc( sizeof(struct ntuple_list_s) );
    if( n_tuple == NULL ) error("not enough memory.");
    
    /* initialize list */
    n_tuple->size = 0;
    n_tuple->max_size = 1;
    n_tuple->dim = dim;
    
    /* get memory for tuples */
    n_tuple->values = (double *) malloc( dim*n_tuple->max_size * sizeof(double) );
    if( n_tuple->values == NULL ) error("not enough memory.");
    
    return n_tuple;
}
/*----------------------------------------------------------------------------*/
/** Enlarge the allocated memory of an n-tuple list.
 */
static void enlarge_ntuple_list(ntuple_list n_tuple)
{
    /* check parameters */
    if( n_tuple == NULL || n_tuple->values == NULL || n_tuple->max_size == 0 )
        error("enlarge_ntuple_list: invalid n-tuple.");
    
    /* duplicate number of tuples */
    n_tuple->max_size *= 2;
    
    /* realloc memory */
    n_tuple->values = (double *) realloc( (void *) n_tuple->values,
                                         n_tuple->dim * n_tuple->max_size * sizeof(double) );
    if( n_tuple->values == NULL ) error("not enough memory.");
}

/*----------------------------------------------------------------------------*/
/** Free memory used in image_double 'i'.
 */
void free_image_double(image_double i)
{
    if( i == NULL || i->data == NULL )
        error("free_image_double: invalid input image.");
    free( (void *) i->data );
    free( (void *) i );
}

/*----------------------------------------------------------------------------*/
/** Free memory used in n-tuple 'in'.
 */
static void free_ntuple_list(ntuple_list in)
{
    if( in == NULL || in->values == NULL )
        error("free_ntuple_list: invalid n-tuple input.");
    free( (void *) in->values );
    free( (void *) in );
}

/*----------------------------------------------------------------------------*/
/** Create a new image_double of size 'xsize' times 'ysize'
 with the data pointed by 'data'.
 */
image_double new_image_double_ptr( unsigned int xsize, unsigned int ysize, double * data )
{
    image_double image;
    
    /* check parameters */
    //  if( xsize == 0 || ysize == 0 )
    //    error("new_image_double_ptr: invalid image size.");
    //  if( data == NULL ) error("new_image_double_ptr: NULL data pointer.");
    
    /* get memory */
    image = (image_double) malloc( sizeof(struct image_double_s) );
    if( image == NULL ) error("not enough memory.");
    
    /* set image */
    image->xsize = xsize;
    image->ysize = ysize;
    image->data = data;
    
    return image;
}


/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/*-------------------------------RGB 2 GRAY-----------------------------------*/
/*----------------------------------------------------------------------------*/

void rgb2gray(double* brillo, unsigned char *pixels, int w, int h, int d)
{
    // printf("w: %-3d h: %-3d\n",w,h);
    
    unsigned long int  pixelNr;
    for(int j=0;j<h;j++)
    {
        
        for(int i=0;i<w;i=i++)
        {
            /* The values asigned to brillo obtained as follows:
            pixelNr = j*w+i;
            blue                = pixelNr*d;
            green               = pixelNr*d+1;
            red                = pixelNr*d+2;
            
            r=pixels[red];
            g=pixels[green];
            b=pixels[blue];
            */
            pixelNr = j*w+i;
            
            /*convert each pixel to gray*/
            brillo[pixelNr] = 0.30*pixels[pixelNr*d+2] + 0.59*pixels[pixelNr*d+1] + 0.11*pixels[pixelNr*d];
        }
    }
    
    
}
/*----------------------------------------------------------------------------*/
/*-----------------------------GAUSSIAN KERNEL--------------------------------*/
/*----------------------------------------------------------------------------*/

static void gaussian_kernel(ntuple_list kernel, double sigma, double mean)
{
    double sum = 0.0;
    //double val;
    unsigned int i;
    
    /* check parameters */
    //  if( kernel == NULL || kernel->values == NULL )
    //    error("gaussian_kernel: invalid n-tuple 'kernel'.");
    //  if( sigma <= 0.0 ) error("gaussian_kernel: 'sigma' must be positive.");
    
    /* compute Gaussian kernel */
    if( kernel->max_size < 1 ) enlarge_ntuple_list(kernel);
    kernel->size = 1;
    for(i=0;i<kernel->dim;i++)
    {
        //      val = ( (double) i - mean ) / sigma;
        //      kernel->values[i] = exp( -0.5 * val * val );
        
        kernel->values[i] = exp( -0.5 * (( (double) i - mean ) / sigma) * (( (double) i - mean ) / sigma) );
        sum += kernel->values[i];
    }
    
    /* normalization */
    if( sum >= 0.0 ) for(i=0;i<kernel->dim;i++) kernel->values[i] /= sum;
}
/*----------------------------------------------------------------------------*/
/*----------------------------GAUSSIAN SAMPLER--------------------------------*/
/*----------------------------------------------------------------------------*/

//static image_double gaussian_sampler( double* in, int width,int height, int d, double scale,
                                     //double sigma_scale )
image_double gaussian_sampler( image_double in, double scale, double sigma_scale )
{
    image_double aux,out;
    ntuple_list kernel;
    unsigned int N,M,h,n,x,y,i;
    int xc,yc,j,double_x_size,double_y_size;
    double sigma,xx,yy,sum,prec;
    
    /* check parameters */
    //  if( in == NULL || in->data == NULL || in->xsize == 0 || in->ysize == 0 )
    //    error("gaussian_sampler: invalid image.");
    //  if( scale <= 0.0 ) error("gaussian_sampler: 'scale' must be positive.");
    //  if( sigma_scale <= 0.0 )
    //    error("gaussian_sampler: 'sigma_scale' must be positive.");
    
    /* compute new image size and get memory for images */
    if( in->xsize * scale > (double) UINT_MAX ||
       in->ysize * scale > (double) UINT_MAX )
        
        error("gaussian_sampler: the output image size exceeds the handled size.");
    N = (unsigned int) ceil( in->xsize * scale );
    M = (unsigned int) ceil( in->ysize * scale );
    
    
    
    aux = new_image_double(N,in->ysize);
    out = new_image_double(N,M);
    
    /* sigma, kernel size and memory for the kernel */
    sigma = scale < 1.0 ? sigma_scale / scale : sigma_scale;
    /*Como para ingresar a este codigo scale <1 (se evalua en la funcion LineSegmentDetection),
     siempre se va a cumplir que sigma = sigma_scale / scale */
    /*
     The size of the kernel is selected to guarantee that the
     the first discarded term is at least 10^prec times smaller
     than the central value. For that, h should be larger than x, with
     e^(-x^2/2sigma^2) = 1/10^prec.
     Then,
     x = sigma * sqrt( 2 * prec * ln(10) ).
     */
    prec = 3.0;
    h = (unsigned int) ceil( sigma * sqrt( 2.0 * prec * log(10.0) ) );
    /*La funcion log() corresponde al logaritmo neperiano*/
    n = 1+2*h; /* kernel size */
    kernel = new_ntuple_list(n);
    
    /* auxiliary double image size variables */
    double_x_size = (int) (2 * in->xsize);
    double_y_size = (int) (2 * in->ysize);
    
    /* First subsampling: x axis */
    for(x=0;x<aux->xsize;x++)
    {
        /*
         x   is the coordinate in the new image.
         xx  is the corresponding x-value in the original size image.
         xc  is the integer value, the pixel coordinate of xx.
         */
        xx = (double) x / scale; /*Esto es para recorrer toda la imagen porque aux-> size = width*scale*/
        /* coordinate (0.0,0.0) is in the center of pixel (0,0),
         so the pixel with xc=0 get the values of xx from -0.5 to 0.5 */
        xc = (int) floor( xx + 0.5 ); /*Aca redondeamos el valor. Seria lo mismo que hacer round(xx)*/
        
        gaussian_kernel( kernel, sigma, (double) h + xx - (double) xc );
        
        /* the kernel must be computed for each x because the fine
         offset xx-xc is different in each case */
        
        for(y=0;y<aux->ysize;y++)
        {
            sum = 0.0;
            for(i=0;i<kernel->dim;i++)
            {
                j = xc - h + i;
                
                /* symmetry boundary condition */
                while( j < 0 ) j += double_x_size;
                while( j >= double_x_size ) j -= double_x_size;
                if( j >= (int) in->xsize ) j = double_x_size-1-j;
                
                sum += in->data[ j + y * in->xsize ] * kernel->values[i];
                
            }
            aux->data[ x + y * aux->xsize ] = sum;
        }
    }
    
    /* Second subsampling: y axis */
    for(y=0;y<out->ysize;y++)
    {
        /*
         y   is the coordinate in the new image.
         yy  is the corresponding x-value in the original size image.
         yc  is the integer value, the pixel coordinate of xx.
         */
        yy = (double) y / scale;
        /* coordinate (0.0,0.0) is in the center of pixel (0,0),
         so the pixel with yc=0 get the values of yy from -0.5 to 0.5 */
        yc = (int) floor( yy + 0.5 );
        gaussian_kernel( kernel, sigma, (double) h + yy - (double) yc );
        /* the kernel must be computed for each y because the fine
         offset yy-yc is different in each case */
        
        for(x=0;x<out->xsize;x++)
        {
            sum = 0.0;
            for(i=0;i<kernel->dim;i++)
            {
                j = yc - h + i;
                
                /* symmetry boundary condition */
                while( j < 0 ) j += double_y_size;
                while( j >= double_y_size ) j -= double_y_size;
                if( j >= (int) in->ysize ) j = double_y_size-1-j;
                
                sum += aux->data[ x + j * aux->xsize ] * kernel->values[i];
                
            }
            out->data[ x + y * out->xsize ] = sum;
        }
    }
    
    /* free memory */
    free_ntuple_list(kernel);
    free_image_double(aux);
    
    return out;
}

    
