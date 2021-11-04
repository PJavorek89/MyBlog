<%@page session="false"
contentType="text/plain;charset=UTF-8"
import="org.apache.sling.api.request.ResponseUtil"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><sling:defineObjects/>
<%@page import="java.util.Iterator"%>
<%@page import="javax.jcr.Node"%>
Hello world!

<%=currentNode %>

<%
  String hodnota = currentNode.getProperty("hodnota").getString();
  out.println(hodnota);
  Iterator<Node> ni = currentNode.getNodes();
  while (ni.hasNext()) {
    Node n = ni.next();
    out.println(n);
    out.println(n.getName());
    out.println(n.getPath());
  }
%>
