using System;
using System.Collections.Generic;
using System.Linq;

namespace LinqpadExtensions {
    public static class EnumerableExtensions {
        public static IEnumerable<T> ForEach<T>( this IEnumerable<T> enumerable, Action<T> action ) {
            foreach ( var item in enumerable ) {
                action( item );
            }
            return enumerable;
        }

        public static string JoinString( this IEnumerable<string> enumerable, string seperator ) {
            return String.Join( seperator, enumerable.ToArray() );
        }

        public static bool IsEmpty<T>( this IEnumerable<T> items ) {
            return items.Count() == 0;
        }
    }
}