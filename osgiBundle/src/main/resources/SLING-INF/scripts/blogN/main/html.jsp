<%@page session="false"
contentType="text/html;charset=UTF-8"
import="org.apache.sling.api.request.ResponseUtil"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><sling:defineObjects/>
<%@page import="java.util.Iterator"%>
<%@page import="javax.jcr.Node, java.time.format.*, java.time.LocalDateTime"%>
<%@page import="java.util.Iterator"%>
<%@page import="javax.jcr.Node"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Scanner"%>
<%@ page import = "java.io.*,java.util.*, java.text.SimpleDateFormat, java.time.LocalDateTime, java.time.format.*" %>
<!DOCTYPE html>
<html>
<head>
	<title>Hlavní stránka Blog</title>
	<link rel="stylesheet" type="text/css" href="/apps/blogN/css/test1.css">
</head>
<body>
	<%
		Date objektData = new Date();
     	Long timeStamp = objektData.getTime();

	%>
	<div class="containerPicture">
      <img src="/apps/pictures/apacheLogo.png" width="60px" height="30px">
    </div>
	<h1 style="text-align: center;">Hlavní stránka blogu</h1>
	<div><a href="/content/MyBlog/vytvor_blog.html">Vytvoř nový blog</a> </div>
	<div>
		<div>Již vytvořené blogy: </div>
		<br>
		<%-- var pro pocet blogu --%>
		<% int pocetBlogu = 0; %>
		<%-- Iterator pro vypsání nazev nodu + odkaz --%>
		<%	
		    Iterator<Node> ni = currentNode.getNodes(); 
		  	while (ni.hasNext()) {	
		  	Node n = ni.next();
		  %>
		  	<table>
		  		<ul>
		  		<li>
		  		<%
				out.println("Nazev blogu:  " + n.getProperty("nazev").getString());
			    %> <br> <%
				out.println("Anotace blogu: " + n.getProperty("body").getString());
				%> <br> <%
				out.println("Odkaz na blog "); %> <a href="<%= n.getProperty("url").getString() %>"> <%= n.getProperty("title").getString() %> </a>
				<br>
				<form method="post" action="/MyBlog/Uprav_blog.html">
					<!-- <input type="hidden" name="presmerovanoZ" value="<% n.getProperty("title").getString(); %>"> -->
			         <input type="hidden" name="_charset_" value="UTF-8" />
			         <input type="hidden" name=":redirect" value="/content/MyBlog/uprav_blog.html">
					 <input type="submit" value="uprav blog">
			         <input type="hidden" name="textPole" value="<%= n.getProperty("textPole").getString() %>">
			         <input type="hidden" name="title" value="<%= n.getProperty("title").getString() %>">
			         <input type="hidden" name="body" value="<%= n.getProperty("body").getString() %>">
			         <input type="hidden" name="puvodniURLStranky" value="<%= n.getProperty("url").getString() %>">
				</form>
				<form method="POST" action="/MyBlog/main/<%=n.getProperty("title").getString()%>">
            		<input type="submit" value="Delete" >
            		<input type="hidden" name=":operation" value="delete" >
            		<input type="hidden" name=":redirect" value="/content/MyBlog/main.html?t=<%= timeStamp %>">
          		</form>
				</form>
				</ul>
			</table>
			<br> <%  	
			  	
				pocetBlogu++;
			  	}
		%>

		<br/>
	</div>
	<div>Celkový počet blogu: <%= pocetBlogu %></div>

</body>
</html>