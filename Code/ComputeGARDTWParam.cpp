#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"

#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))
#define INF 1000000000000 // pseudo infinity
#define VERTICAL 0
#define HORIZONTAL 1
#define DIAGONAL 2
#define DEBUG 0

void ComputeGARDTWParam(double* signalS, double* signalT, int length,
						double regionWidthPer, double* path, int pathLen,
						double* scaling, double* offset, double cMin, double cMax)
{
	double rho = 0;
	double gamma = 0;
	double tau = 0;
	double phi = 0;
	int regionHalfWidth = ceil(regionWidthPer * length);
	for (int k = 0; k < pathLen; k++)
	{
		int sIndex = (int)path[k];
		int tIndex = (int)path[k + pathLen];
		double tempRho = 0;
		double tempGamma = 0;
		double tempTau = 0;
		double tempPhi = 0;
		int accountedWidth = 0;
		for (int m = -regionHalfWidth; m <= regionHalfWidth; m++)
		{
			int sRegionIndex = sIndex + m;
			int tRegionIndex = tIndex + m;
			if (sRegionIndex < 0 || tRegionIndex < 0 || 
				sRegionIndex >= length || tRegionIndex >= length)
			{
				continue;
			}
			accountedWidth = accountedWidth + 1;
			tempRho = tempRho + signalS[sRegionIndex]*signalT[tRegionIndex];
			tempGamma = tempGamma + signalT[tRegionIndex]*signalT[tRegionIndex];
			tempTau = tempTau + signalT[tRegionIndex];
			tempPhi = tempPhi + signalS[sRegionIndex];
		}
		rho = rho + tempRho/accountedWidth;
		gamma = gamma + tempGamma/accountedWidth;
		tau = tau + tempTau/accountedWidth;
		phi = phi + tempPhi/accountedWidth;
	}
	*scaling = (rho - (tau*phi)/pathLen) / (gamma - (tau*tau)/pathLen);
	if (*scaling < cMin)
	{
		*scaling = cMin;
	}
	else if (*scaling > cMax)
	{
		*scaling = cMax;
	}
	*offset = (phi - (*scaling)*tau)/pathLen;
}

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double* signal;
	double* reference;
	double* path;
	double regionWidthPer;
    int length;
	int pathLen;
	double cMin;
	double cMax;
    
    /*  check for proper number of arguments */
    if(nrhs!=6)
    {
        mexErrMsgIdAndTxt( "MATLAB : ComputeGARDTWParam.cpp : Invalid Number of Inputs",
                "Four inputs required.");
    }
    if(nlhs!=2)
    {
        mexErrMsgIdAndTxt( "MATLAB : ComputeGARDTWParam.cpp : Invalid Number of Outputs",
                "Two outputs required.");
    }
    
	regionWidthPer = mxGetScalar(prhs[3]);
    
    // create pointers to MATLAB objects
    signal = mxGetPr(prhs[0]);
    reference = mxGetPr(prhs[1]);
	path = mxGetPr(prhs[2]);
	cMin = (double) mxGetScalar(prhs[4]);
	cMax = (double) mxGetScalar(prhs[5]);
    // get the dimensions of the matrix input signal
	// note that the lengths of signal and reference need to be the same
    length = (int) mxGetM(prhs[0]);
	pathLen = (int) mxGetM(prhs[2]);
    
	double* scaling;
	double* offset;
	
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	scaling = mxGetPr(plhs[0]);
	plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
	offset = mxGetPr(plhs[1]);
	
	ComputeGARDTWParam(signal, reference, length,
						regionWidthPer, path, pathLen,
						scaling, offset, cMin, cMax);
	
}