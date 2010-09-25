namespace LinqpadExtensions {
    public static class StringExtensions {
        public static bool IsEmpty( this string input ) {
            return input == null || input.Trim().Length == 0;
        }

        public static string Right( this string input, int length ) {
            if ( input.IsEmpty() ) {
                return input;
            }

            if ( input.Length < length ) {
                return input;
            }

            return input.Substring( input.Length - length, length );

        }
    }
}