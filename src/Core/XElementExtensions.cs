using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace LinqpadExtensions {
    public static class XElementExtensions {
        /// <summary>
        /// Gets the value of the element inside the input element with the name equal to the input string
        /// </summary>
        /// <param name="element">Element in which search is performed</param>
        /// <param name="name">Name of the element to be searched</param>
        /// <returns>Value of the searched element, empty if it is not found</returns>
        public static string GetValue( this XElement element, string name ) {
            if ( element == null ) {
                return null;
            }

            XElement tokenElement = element.Element( name );

            if ( tokenElement == null || string.IsNullOrEmpty( tokenElement.Value ) ) {
                return string.Empty;
            }
            return tokenElement.Value;
        }

        public static XElement GetUniqueElement( this XElement element, string name ) {
            if ( element == null ) {
                return null;
            }
            IEnumerable<XElement> descendants = element.Descendants( name );
            if ( descendants.Count() != 1 ) {
                return null;
            }
            return descendants.SingleOrDefault();
        }

        public static XElement AddElement( this XElement element, string name ) {
            return element.AddElement( name, null );
        }
        public static XElement AddElement( this XElement element, string name, string value ) {
            element.Add( new XElement( name, value ) );
            return element;
        }

    }

    public static class XDocumentExtensions {
        public static XElement GetUniqueElement( this XDocument doc, string name ) {
            if ( doc == null ) {
                return null;
            }
            IEnumerable<XElement> descendants = doc.Descendants( name );
            if ( descendants.Count() != 1 ) {
                return null;
            }
            return descendants.SingleOrDefault();
        }

        public static bool HasErrors( this XDocument doc ) {
            return doc.Descendants( "Error" ).Count() > 0;
        }
    }
}