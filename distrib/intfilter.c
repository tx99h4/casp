/* 
FILTER.C 
An ANSI C implementation of MATLAB FILTER.M (built-in)
Written by Chen Yangquan <elecyq@nus.edu.sg>
1998-11-11

MEX adaptation by muhiy-eddine Cherik, 2010-14-06
*/

#include "mex.h"
#include <stdio.h>
#include <assert.h>

__inline void intfilter(int ord, double *b, int np, __int16 *x, __int16 *y)
{
    int i,j;
    int ords = ord+1;
    
	//y[0] = b[0] * x[0];
    *y = *b * *x;
    
	for (i=1;i<ords;i++)
	{
        y[i] = 0;
        
        for (j=0;j<i+1;j++)
        	y[i] = y[i] + (__int16)(b[j] * x[i-j]);
        
        //for (j=0;j<i;j++)
        //	y[i] = y[i] - y[i-j-1];
        
	}/* end of initial part */
		
	for (i=ords;i<np;i++)
	{
		y[i] = 0;
		for (j=0;j<ords;j++)
			y[i] = y[i] + (__int16)(b[j] * x[i-j]);
		
        //for (j=0;j<ord;j++)
		//	y[i] = y[i] - y[i-j-1];
	}
    
} /* end of intfilter */


__inline void intsynthes(int ord, double *a, int np, __int16 *x, __int16 *y)
{
    int i,j;
    int ords = ord+1;
    int nps = np+1;
    
    *y = *x;
            
	for (i=1;i<ords;i++){
        
        y[i] = x[i];
        
        for (j=0;j<i;j++)
        	y[i] = y[i] - (__int16)(a[j+1] * y[i-j-1]);
        
        
	} /* end of initial part */
		
	for (i=ords;i<np;i++){
        
        y[i] = x[i];
		
        for (j=0;j<ord;j++)
			y[i] = y[i] - (__int16)(a[j+1] * y[i-j-1]);
	}
    
} /* end of intsynthes */


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *arg2, *arg1;
    __int16 *x, *y;
    int np, ord, ordarg1, ordarg2;
    
    /* arguments are missing? */
    if(nrhs != 3)
        mexErrMsgTxt("Not enough input arguments.");
    
    ordarg2 = mxGetM(prhs[1]) * mxGetN(prhs[1]);
    ordarg1 = mxGetM(prhs[0]) * mxGetN(prhs[0]);
    ord  = ordarg1>1?ordarg1:ordarg2;  
    ord--;
    
    /* coefficients are empty */
    if(ord == 0)
       mexErrMsgTxt("a or b are empty.");
    
    /* get pointer from inputs coef */
    arg2 = mxGetPr(prhs[1]);
    arg1 = mxGetPr(prhs[0]);
    
    /* Get X length */
    np  = mxGetM(prhs[2]) * mxGetN(prhs[2]);
    
    /* X is empty? */
    if(np == 0)
       mexErrMsgTxt("X empty.");
    
    /* Get pointer from X */
    x = (__int16 *)mxGetData(prhs[2]);
    
    /* X must is 16-bit? */
    if(mxIsInt16(prhs[2])){
        
        /* Allocate memory for output */
        plhs[0] = mxCreateNumericMatrix(mxGetM(prhs[2]), mxGetN(prhs[2]), mxINT16_CLASS, mxREAL);
        y = (__int16 *)mxGetData(plhs[0]);
        
        if (ordarg2 == 1)
            intfilter(ord, arg1, np, x, y);
        else if (ordarg1 == 1)
            intsynthes(ord, arg2, np, x, y);

    }
    else
        mexErrMsgTxt("x must be of type 'int16' data.");
    
    return;
}


