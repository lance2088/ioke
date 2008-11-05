/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang.util;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class StringUtils {
    public StringUtils() {
    }

    public String replaceEscapes(String s) {
        if(s.indexOf('\\') == -1) {
            return s;
        }

        int len = s.length();
        StringBuilder result = new StringBuilder(s.length());
        for(int i=0;i<len;i++) {
            char c = s.charAt(i);
            if(c != '\\') {
                result.append(c);
            } else {
                switch(s.charAt(++i)) {
                case '\n':
                    // escaped newline means nothing.
                    break;
                case '\\':
                    result.append(c);
                    break;
                case 'f':
                    result.append('\f');
                    break;
                case 'r':
                    result.append('\r');
                    break;
                case 'n':
                    result.append('\n');
                    break;
                case 't':
                    result.append('\t');
                    break;
                case 'b':
                    result.append('\b');
                    break;
                case '"':
                    result.append('"');
                    break;
                case '#':
                    result.append('#');
                    break;
                default:
                    // Shouldn't happen, but this is a reasonable default
                    result.append(s.charAt(i-1));
                    break;
                }
            }
        }

        return result.toString();
    }
}// StringUtils
