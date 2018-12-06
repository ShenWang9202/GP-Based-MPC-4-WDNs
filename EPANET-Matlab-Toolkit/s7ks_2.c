 /*  Machine Generated EPANET-MSX File - Do Not Edit */ 

 #include <math.h> 
 
 #undef WINDOWS 
 #ifdef _WIN32 
   #define WINDOWS 
 #endif 
 #ifdef __WIN32__ 
   #define WINDOWS 
 #endif 
 #ifdef WIN32 
   #define WINDOWS 
 #endif 
 
 #ifdef WINDOWS 
   #define DLLEXPORT __declspec(dllexport) 
 #else 
   #define DLLEXPORT 
 #endif 
  
 void  DLLEXPORT  MSXgetPipeRates(double *, double *, double *, double *, double *); 
 void  DLLEXPORT  MSXgetTankRates(double *, double *, double *, double *, double *); 
 void  DLLEXPORT  MSXgetPipeEquil(double *, double *, double *, double *, double *); 
 void  DLLEXPORT  MSXgetTankEquil(double *, double *, double *, double *, double *); 
 void  DLLEXPORT  MSXgetPipeFormulas(double *, double *, double *, double *); 
 void  DLLEXPORT  MSXgetTankFormulas(double *, double *, double *, double *); 
 double term(int, double *, double *, double *, double *); 
 double coth(double); 
 double cot(double); 
 double acot(double); 
 double step(double); 
 double sgn(double); 
 
 double coth(double x) { 
   return (exp(x) + exp(-x)) / (exp(x) - exp(-x)); } 
 double cot(double x) { 
   return 1.0 / tan(x); } 
 double acot(double x) { 
   return 1.57079632679489661923 - atan(x); } 
 double step(double x) { 
   if (x <= 0.0) return 0.0; 
   return 1.0; } 
 double sgn(double x) { 
   if (x < 0.0) return -1.0; 
   if (x > 0.0) return 1.0; 
   return 0.0; } 

 double term(int i, double c[], double k[], double p[], double h[])
 { 
     switch(i) { 
     case 1: return (k[3]) / (k[4]); 
     } 
     return 0.0; 
 }

 void DLLEXPORT MSXgetPipeRates(double c[], double k[], double p[], double h[], double f[])
 { 
     f[1] = -(((k[1]) * (c[1])) * (c[5])); 
     f[2] = (((k[1]) * (c[1])) * (c[5])) - ((h[7]) * ((((k[3]) * ((k[5]) - (c[4]))) * (c[2])) - ((k[4]) * (c[4])))); 
     f[5] = -((k[2]) * (c[5])); 
 }

 void DLLEXPORT MSXgetTankRates(double c[], double k[], double p[], double h[], double f[])
 { 
     f[1] = -(((k[1]) * (c[1])) * (c[5])); 
     f[2] = ((k[1]) * (c[1])) * (c[5]); 
     f[5] = -((k[2]) * (c[5])); 
 }

 void DLLEXPORT MSXgetPipeEquil(double c[], double k[], double p[], double h[], double f[])
 { 
     f[4] = ((((term(1, c, k, p, h)) * (k[5])) * (c[2])) / ((1) + ((term(1, c, k, p, h)) * (c[2])))) - (c[4]); 
 }

 void DLLEXPORT MSXgetTankEquil(double c[], double k[], double p[], double h[], double f[])
 { 
 }

 void DLLEXPORT MSXgetPipeFormulas(double c[], double k[],  double p[], double h[])
 { 
     c[3] = (c[1]) + (c[2]); 
 }

 void DLLEXPORT MSXgetTankFormulas(double c[], double k[], double p[], double h[])
 { 
     c[3] = (c[1]) + (c[2]); 
 }

