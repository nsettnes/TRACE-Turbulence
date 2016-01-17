//
//	Code repository for GPU noise development blog
//	http://briansharpe.wordpress.com
//	https://github.com/BrianSharpe
//
//	I'm not one for copyrights.  Use the code however you wish.
//	All I ask is that credit be given back to the blog or myself when appropriate.
//	And also to let me know if you come up with any changes, improvements, thoughts or interesting uses for this stuff. :)
//	Thanks!
//
//	Brian Sharpe
//	brisharpe CIRCLE_A yahoo DOT com
//	http://briansharpe.wordpress.com
//	https://github.com/BrianSharpe
//

//
//	FastHash32_2
//
//	An alternative to FastHash32
//	- slightly slower
//	- can have a larger domain
//	- allows for a 4D implementation
//
//	(eg)4D is computed like so....
//	coord = mod( coord, DOMAIN );
//	coord = ( coord * SCALE ) + OFFSET;
//	coord *= coord;
//	hash = mod( coord.x * coord.y * coord.z * coord.w, SOMELARGEFLOAT ) / SOMELARGEFLOAT;
//
float4 FAST32_2_hash_2D( float2 gridcell )	//	generates a random number for each of the 4 cell corners
{
    //	gridcell is assumed to be an integer coordinate
    const float2 OFFSET = float2( 403.839172, 377.242706 );
    const float DOMAIN = 69.0;		//	NOTE:  this can most likely be extended with some tweaking of the other parameters
    const float SOMELARGEFLOAT = 32745.708984;
    const float2 SCALE = float2( 2.009842, 1.372549 );

    float4 P = float4( gridcell.xy, gridcell.xy + 1.0 );
    P = P - floor(P * ( 1.0 / DOMAIN )) * DOMAIN;
    P = ( P * SCALE.xyxy ) + OFFSET.xyxy;
    P *= P;
    return frac( P.xzxz * P.yyww * ( 1.0 / SOMELARGEFLOAT ) );
}
void FAST32_2_hash_3D( 	float3 gridcell,
                        out float4 z0_hash,			//  float4 == ( x0y0, x1y0, x0y1, x1y1 )
                        out float4 z1_hash	)		//	generates a random number for each of the 8 cell corners
{
    //	gridcell is assumed to be an integer coordinate
    const float3 OFFSET = float3( 55.882355, 63.167774, 52.941177 );
    const float DOMAIN = 69.0;		//	NOTE:  this can most likely be extended with some tweaking of the other parameters
    const float SOMELARGEFLOAT = 69412.070313;
    const float3 SCALE = float3( 0.235142, 0.205890, 0.216449 );

    //	truncate the domain
    gridcell = gridcell - floor(gridcell * ( 1.0 / DOMAIN )) * DOMAIN;
    float3 gridcell_inc1 = step( gridcell, float3( DOMAIN - 1.5, DOMAIN - 1.5, DOMAIN - 1.5 ) ) * ( gridcell + 1.0 );

    //	calculate the noise
    gridcell = ( gridcell * SCALE ) + OFFSET;
    gridcell_inc1 = ( gridcell_inc1 * SCALE ) + OFFSET;
    gridcell *= gridcell;
    gridcell_inc1 *= gridcell_inc1;

    float4 x0y0_x1y0_x0y1_x1y1 = float4( gridcell.x, gridcell_inc1.x, gridcell.x, gridcell_inc1.x ) * float4( gridcell.yy, gridcell_inc1.yy );

    z0_hash = frac( x0y0_x1y0_x0y1_x1y1 * gridcell.zzzz * ( 1.0 / SOMELARGEFLOAT ) );
    z1_hash = frac( x0y0_x1y0_x0y1_x1y1 * gridcell_inc1.zzzz * ( 1.0 / SOMELARGEFLOAT ) );
}
void FAST32_2_hash_4D( 	float4 gridcell,
                        out float4 z0w0_hash,		//  float4 == ( x0y0, x1y0, x0y1, x1y1 )
                        out float4 z1w0_hash,
                        out float4 z0w1_hash,
                        out float4 z1w1_hash	)
{
    //    gridcell is assumed to be an integer coordinate

    //	TODO: 	these constants need tweaked to find the best possible noise.
    //			probably requires some kind of brute force computational searching or something....
    const float4 OFFSET = float4( 16.841230, 18.774548, 16.873274, 13.664607 );
    const float DOMAIN = 69.0;
    const float SOMELARGEFLOAT = 47165.636719;
    const float4 SCALE = float4( 0.102007, 0.114473, 0.139651, 0.084550 );

    //	truncate the domain
    gridcell = gridcell - floor(gridcell * ( 1.0 / DOMAIN )) * DOMAIN;
    float4 gridcell_inc1 = step( gridcell, float4( DOMAIN - 1.5, DOMAIN - 1.5, DOMAIN - 1.5, DOMAIN - 1.5 ) ) * ( gridcell + 1.0 );

    //	calculate the noise
    gridcell = ( gridcell * SCALE ) + OFFSET;
    gridcell_inc1 = ( gridcell_inc1 * SCALE ) + OFFSET;
    gridcell *= gridcell;
    gridcell_inc1 *= gridcell_inc1;

    float4 x0y0_x1y0_x0y1_x1y1 = float4( gridcell.x, gridcell_inc1.x, gridcell.x, gridcell_inc1.x ) * float4( gridcell.yy, gridcell_inc1.yy );
    float4 z0w0_z1w0_z0w1_z1w1 = float4( gridcell.z, gridcell_inc1.z, gridcell.z, gridcell_inc1.z ) * float4( gridcell.ww, gridcell_inc1.ww );

    z0w0_hash = frac( x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.xxxx * ( 1.0 / SOMELARGEFLOAT ) );
    z1w0_hash = frac( x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.yyyy * ( 1.0 / SOMELARGEFLOAT ) );
    z0w1_hash = frac( x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.zzzz * ( 1.0 / SOMELARGEFLOAT ) );
    z1w1_hash = frac( x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.wwww * ( 1.0 / SOMELARGEFLOAT ) );
}
void FAST32_2_hash_4D( 	float4 gridcell,
                        out float4 z0w0_hash_0,		//  float4 == ( x0y0, x1y0, x0y1, x1y1 )
                        out float4 z0w0_hash_1,
                        out float4 z0w0_hash_2,
                        out float4 z0w0_hash_3,
                        out float4 z1w0_hash_0,
                        out float4 z1w0_hash_1,
                        out float4 z1w0_hash_2,
                        out float4 z1w0_hash_3,
                        out float4 z0w1_hash_0,
                        out float4 z0w1_hash_1,
                        out float4 z0w1_hash_2,
                        out float4 z0w1_hash_3,
                        out float4 z1w1_hash_0,
                        out float4 z1w1_hash_1,
                        out float4 z1w1_hash_2,
                        out float4 z1w1_hash_3	)
{
    //    gridcell is assumed to be an integer coordinate

    //	TODO: 	these constants need tweaked to find the best possible noise.
    //			probably requires some kind of brute force computational searching or something....
    const float4 OFFSET = float4( 16.841230, 18.774548, 16.873274, 13.664607 );
    const float DOMAIN = 69.0;
    const float4 SOMELARGEFLOATS = float4( 56974.746094, 47165.636719, 55049.667969, 49901.273438 );
    const float4 SCALE = float4( 0.102007, 0.114473, 0.139651, 0.084550 );

    //	truncate the domain
    gridcell = gridcell - floor(gridcell * ( 1.0 / DOMAIN )) * DOMAIN;
    float4 gridcell_inc1 = step( gridcell, float4( DOMAIN - 1.5, DOMAIN - 1.5, DOMAIN - 1.5, DOMAIN - 1.5 ) ) * ( gridcell + 1.0 );

    //	calculate the noise
    gridcell = ( gridcell * SCALE ) + OFFSET;
    gridcell_inc1 = ( gridcell_inc1 * SCALE ) + OFFSET;
    gridcell *= gridcell;
    gridcell_inc1 *= gridcell_inc1;

    float4 x0y0_x1y0_x0y1_x1y1 = float4( gridcell.x, gridcell_inc1.x, gridcell.x, gridcell_inc1.x ) * float4( gridcell.yy, gridcell_inc1.yy );
    float4 z0w0_z1w0_z0w1_z1w1 = float4( gridcell.z, gridcell_inc1.z, gridcell.z, gridcell_inc1.z ) * float4( gridcell.ww, gridcell_inc1.ww );

    float4 hashval = x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.xxxx;
    z0w0_hash_0 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.x ) );
    z0w0_hash_1 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.y ) );
    z0w0_hash_2 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.z ) );
    z0w0_hash_3 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.w ) );
    hashval = x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.yyyy;
    z1w0_hash_0 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.x ) );
    z1w0_hash_1 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.y ) );
    z1w0_hash_2 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.z ) );
    z1w0_hash_3 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.w ) );
    hashval = x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.zzzz;
    z0w1_hash_0 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.x ) );
    z0w1_hash_1 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.y ) );
    z0w1_hash_2 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.z ) );
    z0w1_hash_3 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.w ) );
    hashval = x0y0_x1y0_x0y1_x1y1 * z0w0_z1w0_z0w1_z1w1.wwww;
    z1w1_hash_0 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.x ) );
    z1w1_hash_1 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.y ) );
    z1w1_hash_2 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.z ) );
    z1w1_hash_3 = frac( hashval * ( 1.0 / SOMELARGEFLOATS.w ) );
}

//
//	Interpolation functions
//	( smoothly increase from 0.0 to 1.0 as x increases linearly from 0.0 to 1.0 )
//	http://briansharpe.wordpress.com/2011/11/14/two-useful-interpolation-functions-for-noise-development/
//
float Interpolation_C1( float x ) { return x * x * (3.0 - 2.0 * x); }   //  3x^2-2x^3  ( Hermine Curve.  Same as SmoothStep().  As used by Perlin in Original Noise. )
float2 Interpolation_C1( float2 x ) { return x * x * (3.0 - 2.0 * x); }
float3 Interpolation_C1( float3 x ) { return x * x * (3.0 - 2.0 * x); }
float4 Interpolation_C1( float4 x ) { return x * x * (3.0 - 2.0 * x); }

float Interpolation_C2( float x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }   //  6x^5-15x^4+10x^3	( Quintic Curve.  As used by Perlin in Improved Noise.  http://mrl.nyu.edu/~perlin/paper445.pdf )
float2 Interpolation_C2( float2 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
float3 Interpolation_C2( float3 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
float4 Interpolation_C2( float4 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
float4 Interpolation_C2_InterpAndDeriv( float2 x ) { return x.xyxy * x.xyxy * ( x.xyxy * ( x.xyxy * ( x.xyxy * float4( 6.0, 6.0, 0.0, 0.0 ) + float4( -15.0, -15.0, 30.0, 30.0 ) ) + float4( 10.0, 10.0, -60.0, -60.0 ) ) + float4( 0.0, 0.0, 30.0, 30.0 ) ); }
float3 Interpolation_C2_Deriv( float3 x ) { return x * x * (x * (x * 30.0 - 60.0) + 30.0); }

float Interpolation_C2_Fast( float x ) { float x3 = x*x*x; return ( 7.0 + ( x3 - 7.0 ) * x ) * x3; }   //  7x^3-7x^4+x^7   ( Faster than Perlin Quintic.  Not quite as good shape. )
float2 Interpolation_C2_Fast( float2 x ) { float2 x3 = x*x*x; return ( 7.0 + ( x3 - 7.0 ) * x ) * x3; }
float3 Interpolation_C2_Fast( float3 x ) { float3 x3 = x*x*x; return ( 7.0 + ( x3 - 7.0 ) * x ) * x3; }
float4 Interpolation_C2_Fast( float4 x ) { float4 x3 = x*x*x; return ( 7.0 + ( x3 - 7.0 ) * x ) * x3; }

float Interpolation_C3( float x ) { float xsq = x*x; float xsqsq = xsq*xsq; return xsqsq * ( 25.0 - 48.0 * x + xsq * ( 25.0 - xsqsq ) ); }   //  25x^4-48x^5+25x^6-x^10		( C3 Interpolation function.  If anyone ever needs it... :) )
float2 Interpolation_C3( float2 x ) { float2 xsq = x*x; float2 xsqsq = xsq*xsq; return xsqsq * ( 25.0 - 48.0 * x + xsq * ( 25.0 - xsqsq ) ); }
float3 Interpolation_C3( float3 x ) { float3 xsq = x*x; float3 xsqsq = xsq*xsq; return xsqsq * ( 25.0 - 48.0 * x + xsq * ( 25.0 - xsqsq ) ); }
float4 Interpolation_C3( float4 x ) { float4 xsq = x*x; float4 xsqsq = xsq*xsq; return xsqsq * ( 25.0 - 48.0 * x + xsq * ( 25.0 - xsqsq ) ); }

//
//	Falloff defined in XSquared
//	( smoothly decrease from 1.0 to 0.0 as xsq increases from 0.0 to 1.0 )
//	http://briansharpe.wordpress.com/2011/11/14/two-useful-interpolation-functions-for-noise-development/
//
float Falloff_Xsq_C1( float xsq ) { xsq = 1.0 - xsq; return xsq*xsq; }	// ( 1.0 - x*x )^2   ( Used by Humus for lighting falloff in Just Cause 2.  GPUPro 1 )
float Falloff_Xsq_C2( float xsq ) { xsq = 1.0 - xsq; return xsq*xsq*xsq; }	// ( 1.0 - x*x )^3.   NOTE: 2nd derivative is 0.0 at x=1.0, but non-zero at x=0.0
float4 Falloff_Xsq_C2( float4 xsq ) { xsq = 1.0 - xsq; return xsq*xsq*xsq; }

//
//	Quintic Hermite Interpolation
//	http://www.rose-hulman.edu/~finn/CCLI/Notes/day09.pdf
//
//  NOTE: maximum value of a hermitequintic interpolation with zero acceleration at the endpoints would be...
//        f(x=0.5) = MAXPOS + MAXVELOCITY * ( ( x - 6x^3 + 8x^4 - 3x^5 ) - ( -4x^3 + 7x^4 -3x^5 ) ) = MAXPOS + MAXVELOCITY * 0.3125
//
//	variable naming conventions:
//	val = value ( position )
//	grad = gradient ( velocity )
//	x = 0.0->1.0 ( time )
//	i = interpolation = a value to be interpolated
//	e = evaluation = a value to be used to calculate the interpolation
//	0 = start
//	1 = end
//
float QuinticHermite( float x, float ival0, float ival1, float egrad0, float egrad1 )		// quintic hermite with start/end acceleration of 0.0
{
	const float3 C0 = float3( -15.0, 8.0, 7.0 );
	const float3 C1 = float3( 6.0, -3.0, -3.0 );
	const float3 C2 = float3( 10.0, -6.0, -4.0 );
	float3 h123 = ( ( ( C0 + C1 * x ) * x ) + C2 ) * ( x*x*x );
	return ival0 + dot( float3( (ival1 - ival0), egrad0, egrad1 ), h123.xyz + float3( 0.0, x, 0.0 ) );
}
float4 QuinticHermite( float x, float4 ival0, float4 ival1, float4 egrad0, float4 egrad1 )		// quintic hermite with start/end acceleration of 0.0
{
	const float3 C0 = float3( -15.0, 8.0, 7.0 );
	const float3 C1 = float3( 6.0, -3.0, -3.0 );
	const float3 C2 = float3( 10.0, -6.0, -4.0 );
	float3 h123 = ( ( ( C0 + C1 * x ) * x ) + C2 ) * ( x*x*x );
	return ival0 + (ival1 - ival0) * h123.xxxx + egrad0 * float4( h123.y + x, h123.y + x, h123.y + x, h123.y + x ) + egrad1 * h123.zzzz;
}
float4 QuinticHermite( float x, float2 igrad0, float2 igrad1, float2 egrad0, float2 egrad1 )		// quintic hermite with start/end position and acceleration of 0.0
{
	const float3 C0 = float3( -15.0, 8.0, 7.0 );
	const float3 C1 = float3( 6.0, -3.0, -3.0 );
	const float3 C2 = float3( 10.0, -6.0, -4.0 );
	float3 h123 = ( ( ( C0 + C1 * x ) * x ) + C2 ) * ( x*x*x );
	return float4( egrad1, igrad0 ) * float4( h123.zz, 1.0, 1.0 ) + float4( egrad0, h123.xx ) * float4( float2( h123.y + x, h123.y + x ), (igrad1 - igrad0) );	//	returns float4( out_ival.xy, out_igrad.xy )
}
void QuinticHermite( 	float x,
						float4 ival0, float4 ival1,			//	values are interpolated using the gradient arguments
						float4 igrad_x0, float4 igrad_x1, 	//	gradients are interpolated using eval gradients of 0.0
						float4 igrad_y0, float4 igrad_y1,
						float4 egrad0, float4 egrad1, 		//	our evaluation gradients
						out float4 out_ival, out float4 out_igrad_x, out float4 out_igrad_y )	// quintic hermite with start/end acceleration of 0.0
{
	const float3 C0 = float3( -15.0, 8.0, 7.0 );
	const float3 C1 = float3( 6.0, -3.0, -3.0 );
	const float3 C2 = float3( 10.0, -6.0, -4.0 );
	float3 h123 = ( ( ( C0 + C1 * x ) * x ) + C2 ) * ( x*x*x );
	out_ival = ival0 + (ival1 - ival0) * h123.xxxx + egrad0 * float4( h123.y + x, h123.y + x, h123.y + x, h123.y + x ) + egrad1 * h123.zzzz;
	out_igrad_x = igrad_x0 + (igrad_x1 - igrad_x0) * h123.xxxx;	//	NOTE: gradients of 0.0
	out_igrad_y = igrad_y0 + (igrad_y1 - igrad_y0) * h123.xxxx;	//	NOTE: gradients of 0.0
}
void QuinticHermite( 	float x,
						float4 igrad_x0, float4 igrad_x1, 	//	gradients are interpolated using eval gradients of 0.0
						float4 igrad_y0, float4 igrad_y1,
						float4 egrad0, float4 egrad1, 		//	our evaluation gradients
						out float4 out_ival, out float4 out_igrad_x, out float4 out_igrad_y )	// quintic hermite with start/end position and acceleration of 0.0
{
	const float3 C0 = float3( -15.0, 8.0, 7.0 );
	const float3 C1 = float3( 6.0, -3.0, -3.0 );
	const float3 C2 = float3( 10.0, -6.0, -4.0 );
	float3 h123 = ( ( ( C0 + C1 * x ) * x ) + C2 ) * ( x*x*x );
	out_ival = egrad0 * float4( h123.y + x, h123.y + x, h123.y + x, h123.y + x ) + egrad1 * h123.zzzz;
	out_igrad_x = igrad_x0 + (igrad_x1 - igrad_x0) * h123.xxxx;	//	NOTE: gradients of 0.0
	out_igrad_y = igrad_y0 + (igrad_y1 - igrad_y0) * h123.xxxx;	//	NOTE: gradients of 0.0
}
float QuinticHermiteDeriv( float x, float ival0, float ival1, float egrad0, float egrad1 )	// gives the derivative of quintic hermite with start/end acceleration of 0.0
{
	const float3 C0 = float3( 30.0, -15.0, -15.0 );
	const float3 C1 = float3( -60.0, 32.0, 28.0 );
	const float3 C2 = float3( 30.0, -18.0, -12.0 );
	float3 h123 = ( ( ( C1 + C0 * x ) * x ) + C2 ) * ( x*x );
	return dot( float3( (ival1 - ival0), egrad0, egrad1 ), h123.xyz + float3( 0.0, 1.0, 0.0 ) );
}

//
//	Value Noise 4D
//	Return value range of 0.0->1.0
//
float Value4D( float4 P )
{
    //	establish our grid cell and unit position
    float4 Pi = floor(P);
    float4 Pf = P - Pi;

    //	calculate the hash.
    float4 z0w0_hash;		//  float4 == ( x0y0, x1y0, x0y1, x1y1 )
    float4 z1w0_hash;
    float4 z0w1_hash;
    float4 z1w1_hash;
    FAST32_2_hash_4D( Pi, z0w0_hash, z1w0_hash, z0w1_hash, z1w1_hash );

    //	blend the results and return
    float4 blend = Interpolation_C2( Pf );
    float4 res0 = lerp( z0w0_hash, z0w1_hash, blend.w );
    float4 res1 = lerp( z1w0_hash, z1w1_hash, blend.w );
    res0 = lerp( res0, res1, blend.z );
    float2 res2 = lerp( res0.xy, res0.zw, blend.y );
    return lerp( res2.x, res2.y, blend.x );
}

//
// Perlin Noise 4D ( gradient noise )
// Return value range of -1.0->1.0
//
float Perlin4D( float4 P )
{
    // establish our grid cell and unit position
    float4 Pi = floor(P);
    float4 Pf = P - Pi;
    float4 Pf_min1 = Pf - 1.0;

    //    calculate the hash.
    float4 lowz_loww_hash_0, lowz_loww_hash_1, lowz_loww_hash_2, lowz_loww_hash_3;
    float4 highz_loww_hash_0, highz_loww_hash_1, highz_loww_hash_2, highz_loww_hash_3;
    float4 lowz_highw_hash_0, lowz_highw_hash_1, lowz_highw_hash_2, lowz_highw_hash_3;
    float4 highz_highw_hash_0, highz_highw_hash_1, highz_highw_hash_2, highz_highw_hash_3;
    FAST32_2_hash_4D(
        Pi,
        lowz_loww_hash_0, lowz_loww_hash_1, lowz_loww_hash_2, lowz_loww_hash_3,
        highz_loww_hash_0, highz_loww_hash_1, highz_loww_hash_2, highz_loww_hash_3,
        lowz_highw_hash_0, lowz_highw_hash_1, lowz_highw_hash_2, lowz_highw_hash_3,
        highz_highw_hash_0, highz_highw_hash_1, highz_highw_hash_2, highz_highw_hash_3 );

    //	calculate the gradients
    lowz_loww_hash_0 -= 0.49999;
    lowz_loww_hash_1 -= 0.49999;
    lowz_loww_hash_2 -= 0.49999;
    lowz_loww_hash_3 -= 0.49999;
    highz_loww_hash_0 -= 0.49999;
    highz_loww_hash_1 -= 0.49999;
    highz_loww_hash_2 -= 0.49999;
    highz_loww_hash_3 -= 0.49999;
    lowz_highw_hash_0 -= 0.49999;
    lowz_highw_hash_1 -= 0.49999;
    lowz_highw_hash_2 -= 0.49999;
    lowz_highw_hash_3 -= 0.49999;
    highz_highw_hash_0 -= 0.49999;
    highz_highw_hash_1 -= 0.49999;
    highz_highw_hash_2 -= 0.49999;
    highz_highw_hash_3 -= 0.49999;

    float4 grad_results_lowz_loww = rsqrt( lowz_loww_hash_0 * lowz_loww_hash_0 + lowz_loww_hash_1 * lowz_loww_hash_1 + lowz_loww_hash_2 * lowz_loww_hash_2 + lowz_loww_hash_3 * lowz_loww_hash_3 );
    grad_results_lowz_loww *= ( float2( Pf.x, Pf_min1.x ).xyxy * lowz_loww_hash_0 + float2( Pf.y, Pf_min1.y ).xxyy * lowz_loww_hash_1 + Pf.zzzz * lowz_loww_hash_2 + Pf.wwww * lowz_loww_hash_3 );

    float4 grad_results_highz_loww = rsqrt( highz_loww_hash_0 * highz_loww_hash_0 + highz_loww_hash_1 * highz_loww_hash_1 + highz_loww_hash_2 * highz_loww_hash_2 + highz_loww_hash_3 * highz_loww_hash_3 );
    grad_results_highz_loww *= ( float2( Pf.x, Pf_min1.x ).xyxy * highz_loww_hash_0 + float2( Pf.y, Pf_min1.y ).xxyy * highz_loww_hash_1 + Pf_min1.zzzz * highz_loww_hash_2 + Pf.wwww * highz_loww_hash_3 );

    float4 grad_results_lowz_highw = rsqrt( lowz_highw_hash_0 * lowz_highw_hash_0 + lowz_highw_hash_1 * lowz_highw_hash_1 + lowz_highw_hash_2 * lowz_highw_hash_2 + lowz_highw_hash_3 * lowz_highw_hash_3 );
    grad_results_lowz_highw *= ( float2( Pf.x, Pf_min1.x ).xyxy * lowz_highw_hash_0 + float2( Pf.y, Pf_min1.y ).xxyy * lowz_highw_hash_1 + Pf.zzzz * lowz_highw_hash_2 + Pf_min1.wwww * lowz_highw_hash_3 );

    float4 grad_results_highz_highw = rsqrt( highz_highw_hash_0 * highz_highw_hash_0 + highz_highw_hash_1 * highz_highw_hash_1 + highz_highw_hash_2 * highz_highw_hash_2 + highz_highw_hash_3 * highz_highw_hash_3 );
    grad_results_highz_highw *= ( float2( Pf.x, Pf_min1.x ).xyxy * highz_highw_hash_0 + float2( Pf.y, Pf_min1.y ).xxyy * highz_highw_hash_1 + Pf_min1.zzzz * highz_highw_hash_2 + Pf_min1.wwww * highz_highw_hash_3 );

    // Classic Perlin Interpolation
    float4 blend = Interpolation_C2( Pf );
    float4 res0 = lerp( grad_results_lowz_loww, grad_results_lowz_highw, blend.w );
    float4 res1 = lerp( grad_results_highz_loww, grad_results_highz_highw, blend.w );
    res0 = lerp( res0, res1, blend.z );
    float2 res2 = lerp( res0.xy, res0.zw, blend.y );
    return lerp( res2.x, res2.y, blend.x );
}

//
// FBM functions
//

float Value(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = Value4D((p + offset) * frequency);
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}

float ValueRidged(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence, float ridgeOffset)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = 0.5 * (ridgeOffset - abs(4*Value4D((p + offset) * frequency)));
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}

float ValueBillowed(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = abs(Value4D((p + offset) * frequency));
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}

float Perlin(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = Perlin4D((p + offset) * frequency);
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}

float PerlinRidged(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence, float ridgeOffset)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = 0.5 * (ridgeOffset - abs(4*Perlin4D((p + offset) * frequency)));
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}

float PerlinBillowed(float4 p, int octaves, float4 offset, float frequency, float amplitude, float lacunarity, float persistence)
{
	float sum = 0;
	for (int i = 0; i < octaves; i++)
	{
		float h = 0;
		h = abs(Perlin4D((p + offset) * frequency));
		sum += h*amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return sum;
}