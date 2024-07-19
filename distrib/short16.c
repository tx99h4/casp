/* 
 *   SHORT16.C 
 *   An ANSI C implementation of SHORT16.M that convert
 *   double into 16-bit with truncation
 *   (c) Copyright 2010, Muhiy-eddine Cherik
 *
 */

#include "mex.h"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *argin;
    __int16 *y, *adr;
    int lenargin, i=0;
    
    /* arguments are missing? */
    if(nrhs != 1)
        mexErrMsgTxt("Not enough input arguments.");
   
    lenargin = mxGetM(prhs[0]) * mxGetN(prhs[0]);
    
    /* coefficients are empty */
    if(lenargin == 0)
       mexErrMsgTxt("x is empty.");
    
    /* get pointer from inputs */
    argin = mxGetPr(prhs[0]);
        
    /* Allocate memory for output */
    plhs[0] = mxCreateNumericMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]), mxINT16_CLASS, mxREAL);
    y = (__int16 *) mxGetData(plhs[0]);
	adr = y;
    
    //for(;i<lenargin;i++)
    while(lenargin--)
        *y++ = *argin++;

	y = adr;
    
    return;
}


