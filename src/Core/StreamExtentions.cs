namespace LinqpadExtensions {
    public static class StreamExtentions {
        public static byte[] ReadBytes( this System.IO.Stream inputStream ) {
            var buf = new byte[inputStream.Length];
            inputStream.Read( buf, 0, ( int ) inputStream.Length );
            return buf;
        }
    }
}