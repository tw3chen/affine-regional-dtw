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
#define EPS 0 // pseudo epsilon to deal with numerical instability that could accompany the faster version of RDTW

int** RDTW(double* signal, double* reference, int length, 
		  double pathConstraintPer, double regionWidthPer,
		  // pathConstraintPer and regionWidthPer are half-width percents
		  double* distance, int* pathLen)
{
	int i,j,m;
	int pathConstraint = ceil(pathConstraintPer * length);
	int regionWidth = ceil(regionWidthPer * length);
	// initialize matrices for computing RDTW distance and path
	double** DTWDistMatrix;
	DTWDistMatrix = (double**) malloc(length * sizeof(double*));
	for (i = 0; i < length; i++)
	{
		DTWDistMatrix[i] = (double*) malloc(length * sizeof(double));
		for (j = 0; j < length; j++)
		{
			DTWDistMatrix[i][j] = INF; // need to watch out for overflow
		}
	}
	int** DTWDirMatrix;
	DTWDirMatrix = (int**) malloc(length * sizeof(int*));
	for (i = 0; i < length; i++)
	{
		DTWDirMatrix[i] = (int*) malloc(length * sizeof(int));
		for (j = 0; j < length; j++)
		{
			DTWDirMatrix[i][j] = -1;
		}
	}
	int** DTWLenMatrix;
	DTWLenMatrix = (int**) malloc(length * sizeof(int*));
	for (i = 0; i < length; i++)
	{
		DTWLenMatrix[i] = (int*) malloc(length * sizeof(int));
		for (j = 0; j < length; j++)
		{
			DTWLenMatrix[i][j] = -1;
		}
	}
	int fullConstraintWidth = 1 + 2*pathConstraint;
	double*** regionBuffer;
	regionBuffer = (double***) malloc(2 * sizeof(double**));
	for (i = 0; i < 2; i++)
	{
		regionBuffer[i] = (double**) malloc(fullConstraintWidth * sizeof(double*));
		for (j = 0; j < fullConstraintWidth; j++)
		{
			regionBuffer[i][j] = (double*) malloc(2 * sizeof(double));
			for (m = 0; m < 2; m++)
			{
				regionBuffer[i][j][m] = -1;
			}
		}
	}
	// populate matrices for computing RDTW distance and path
	for (i = 0; i < length; i++)
	{
		int regionStoreIndex;
		int regionLoadIndex;
		if (i % 2 == 0)
		{
			regionStoreIndex = 0;
			regionLoadIndex = 1;
		}
		else
		{
			regionStoreIndex = 1;
			regionLoadIndex = 0;
		}
		double** regionLoadBuffer = regionBuffer[regionLoadIndex];
		double** regionStoreBuffer = regionBuffer[regionStoreIndex];
		for (j = MAX(i-pathConstraint,0); j <= MIN(i+pathConstraint,length-1); j++)
		{
			int bufferIndex = j - i + pathConstraint;
			int mStart = -regionWidth;
			int mEnd = regionWidth;
			if ((i - regionWidth) < 0 || (j - regionWidth) < 0)
			{
				mStart -= MIN(i - regionWidth, j - regionWidth);
			}
			if ((i + regionWidth) >= length || (j + regionWidth) >= length)
			{
				// very, very doubtful
				mEnd -= MAX(i + regionWidth - length + 1, j + regionWidth - length + 1);
			}
			int accountedWidth = -mStart + mEnd + 1;
			double point_distance = 0;
			if (i == 0 || j == 0)
			{
				for (m = mStart; m <= mEnd; m++)
				{
					int iInd = i+m;
					int jInd = j+m;
					point_distance += (signal[iInd]-reference[jInd])*(signal[iInd]-reference[jInd]);
				}
			}
			else
			{
				int iInd = i+mEnd;
				int jInd = j+mEnd;
				if (mEnd < regionWidth)
				{
					point_distance = -regionLoadBuffer[bufferIndex][1] + regionLoadBuffer[bufferIndex][0];
				}
				else
				{
					point_distance = -regionLoadBuffer[bufferIndex][1] + regionLoadBuffer[bufferIndex][0] + (signal[iInd]-reference[jInd])*(signal[iInd]-reference[jInd]);
				}
			}
			regionStoreBuffer[bufferIndex][0] = point_distance;
			if (mStart > -regionWidth)
			{
				regionStoreBuffer[bufferIndex][1] = 0;
			}
			else
			{
				int iInd = i+mStart;
				int jInd = j+mStart;
				regionStoreBuffer[bufferIndex][1] = (signal[iInd]-reference[jInd])*(signal[iInd]-reference[jInd]);
			}
			point_distance /= accountedWidth;

			double horizontal_distance = (j-1 >= 0) ? DTWDistMatrix[i][j-1] : INF;
			double vertical_distance = (i-1 >= 0) ? DTWDistMatrix[i-1][j] : INF;
			double diagonal_distance = (i-1 >= 0 && j-1 >= 0) ? DTWDistMatrix[i-1][j-1] : INF;
			int horizontal_len = (j-1 >= 0) ? DTWLenMatrix[i][j-1] : INF;
			int vertical_len = (i-1 >= 0) ? DTWLenMatrix[i-1][j] : INF;
			int diagonal_len = (i-1 >= 0 && j-1 >= 0) ? DTWLenMatrix[i-1][j-1] : INF;
			int direction = -1;
			double prev_distance = 0;
			int prev_len = 0;
			diagonal_distance = diagonal_distance - EPS; 
			// done to prefer diagonal distance since repeated updates of regional distance can result in numerical instability with a tiny difference
			// even though there is in fact no difference at all
			if (i != 0 || j != 0) // MODIFIED FROM && to ||
			{
				if (diagonal_distance <= vertical_distance && diagonal_distance <= horizontal_distance)
				{
					direction = DIAGONAL;
					prev_distance = diagonal_distance;
					prev_len = diagonal_len;
				} else if (vertical_distance < diagonal_distance && vertical_distance <= horizontal_distance)
				{
					direction = VERTICAL;
					prev_distance = vertical_distance;
					prev_len = vertical_len;
				} else
				{
					direction = HORIZONTAL;
					prev_distance = horizontal_distance;
					prev_len = horizontal_len;
				}
			}
			DTWDistMatrix[i][j] = point_distance + prev_distance;
			DTWDirMatrix[i][j] = direction;
			DTWLenMatrix[i][j] = 1 + prev_len;
		}
	}

	*distance = DTWDistMatrix[length-1][length-1];
	*pathLen = DTWLenMatrix[length-1][length-1];
	// traverse DTW direction matrix to obtain the warp path
	int** warpedPath = (int**) malloc((*pathLen) * sizeof(int*));
	for (m = 0; m < *pathLen; m++)
	{
		warpedPath[m] = (int*) malloc(2 * sizeof(int));
		warpedPath[m][0] = 0;
		warpedPath[m][1] = 0;
	}
	i = length - 1;
	j = length - 1;
	for (m = 0; m < *pathLen; m++)
	{
		int pathInd = *pathLen - 1 - m;
		warpedPath[pathInd][0] = i;
		warpedPath[pathInd][1] = j;
		if (DTWDirMatrix[i][j] == VERTICAL)
		{
			i--;
		} else if (DTWDirMatrix[i][j] == HORIZONTAL)
		{
			j--;
		} else
		{
			i--;
			j--;
		}
	}

	if (DEBUG)
	{
		printf("Distance Matrix:\n");
		for (i = 0; i < length; i++)
		{
			for (j = 0; j < length; j++)
			{
				// printf("%12.2f ", DTWDistMatrix[length-1-i][j]);
				printf("%12.20f ", DTWDistMatrix[length-1-i][j]);
			}
			printf("\n");
		}
		printf("Direction Matrix:\n");
		for (i = 0; i < length; i++)
		{
			for (j = 0; j < length; j++)
			{
				printf("%2d ", DTWDirMatrix[length-1-i][j]);
			}
			printf("\n");
		}
		printf("Warped Path:\n");
		for (m = 0; m < *pathLen; m++)
		{
			printf("(%3d,%3d)\n", warpedPath[m][0], warpedPath[m][1]);
		}
	}

	// deallocation
	for (i = 0; i < length; i++)
	{
		free(DTWDistMatrix[i]);
	}
	free(DTWDistMatrix);
	for (i = 0; i < length; i++)
	{
		free(DTWDirMatrix[i]);
	}
	free(DTWDirMatrix);
	for (i = 0; i < length; i++)
	{
		free(DTWLenMatrix[i]);
	}
	free(DTWLenMatrix);
	for (i = 0; i < 2; i++)
	{
		for (j = 0; j < fullConstraintWidth; j++)
		{
			free(regionBuffer[i][j]);
		}
		free(regionBuffer[i]);
	}
	free(regionBuffer);

	return warpedPath;
}

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double* signal;
	double* reference;
	double pathConstraintPer;
	double regionWidthPer;
    int length;
    
    /*  check for proper number of arguments */
    if(nrhs!=4)
    {
        mexErrMsgIdAndTxt( "MATLAB : RDTW.cpp : Invalid Number of Inputs",
                "Four inputs required.");
    }
    if(nlhs!=2)
    {
        mexErrMsgIdAndTxt( "MATLAB : RDTW.cpp : Invalid Number of Outputs",
                "Two outputs required.");
    }
    
	pathConstraintPer = mxGetScalar(prhs[2]);
	regionWidthPer = mxGetScalar(prhs[3]);
    
    // create pointers to MATLAB objects
    signal = mxGetPr(prhs[0]);
    reference = mxGetPr(prhs[1]);
    // get the dimensions of the matrix input signal
	// note that the lengths of signal and reference need to be the same
    length = (int) mxGetM(prhs[0]);
    
	int** warpedPath;
	double* warpedPathOutput;
	double* distance;
	int pathLen;
	
	
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	distance = mxGetPr(plhs[0]);
	
	// perform RDTW
	warpedPath = RDTW(signal, reference, length, 
		  pathConstraintPer, regionWidthPer,
		  distance, &pathLen);
		  
		  
	plhs[1] = mxCreateDoubleMatrix(pathLen, 2, mxREAL);
	
	warpedPathOutput = mxGetPr(plhs[1]);
	for(int i = 0; i < pathLen; i++)
	{
		for (int j = 0; j < 2; j++)
		{
			warpedPathOutput[i + j*pathLen] = warpedPath[i][j] + 1; // +1 for MATLAB indexing
		}
	}
	for(int i = 0; i < pathLen; i++)
	{
		free(warpedPath[i]);
	}
	free(warpedPath);
}