using System;
using System.Collections.Generic;

namespace LinqpadExtensions {
    public static class IntegerExtensions {
        public static void Times( this int number, Action<int> action ) {
            for ( int i = 0; i < number; i++ ) {
                action( i );
            }
        }

        public static IEnumerable<int> Till( this int beginning, int end ) {
            for ( int i = beginning; i <= end; i++ ) {
                yield return i;
            }
        }

    }
}