using System.Collections.Generic;
using System.ComponentModel;

namespace LinqpadExtensions {
    public static class ObjectExtensions {

        public static bool IsNull( this object obj ) {
            return obj == null;
        }

        public static IDictionary<string, object> ToDictionary( this object obj ) {
            IDictionary<string, object> result = new Dictionary<string, object>();
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties( obj );
            foreach ( PropertyDescriptor property in properties ) {
                result.Add( property.Name, property.GetValue( obj ) );
            }
            return result;
        }

        public static object GetPropertyValue( this object obj, string property ) {
            return TypeDescriptor.GetProperties( obj )[property].GetValue( obj );
        }

        public static T As<T>( this object obj ) {
            return ( T ) obj;
        }

        public static T As<T>( this object obj, T anonymousType ) {
            return ( T ) obj;
        }
    }
}