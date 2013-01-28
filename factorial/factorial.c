/* factorial.c

   Recursive implementation of the factorial function (x!).
   Caches computed values.
   Since 35! > 2^127, only values up to 34! can be contained in a
   signed long long on a typical 64-bit implementation. So larger arguments
   will lead to overflows unless we change the return type to floating-point
   or some form of BigInt.
*/


long long factorial( int x )
{
    static long long fact[ 35 ];

    if ( x <= 1 )
        return 1LL;
    else if ( x < 35 )
        if ( fact[ x ] != 0LL )
            return fact[ x ];
        else
            return (fact[ x ] = x * factorial( x - 1 ));
    else
        return x * factorial( x - 1 );
}

