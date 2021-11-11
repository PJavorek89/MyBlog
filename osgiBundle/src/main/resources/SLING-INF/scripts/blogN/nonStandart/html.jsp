<%@page session="false"
contentType="text/html;charset=UTF-8"
import="org.apache.sling.api.request.ResponseUtil"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><sling:defineObjects/>
<%@page import="java.util.Iterator"%>
<%@page import="javax.jcr.Node"%>
<%@ page import = "java.io.*,java.util.*, java.text.SimpleDateFormat, java.time.LocalDateTime, java.time.format.*" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="/apps/blogN/css/test1.css">
	 <%-- var --%>
	    <%  
	     String prazdne = "";
         String body;
         String textPole;
	     String nazev;
	     String puvodniSablona = currentNode.getProperty("sling:resourceType").getString();
	     String puvodniTypPisma;
     	 String title = currentNode.getProperty("title").getString();	
	     String noveZalozeno = currentNode.getProperty("noveZalozeno").getString();
	     String soucasnaURL = request.getRequestURL().toString();
	     currentNode.setProperty("url", soucasnaURL);
	     String url = currentNode.getProperty("url").getString();
	     String obr = currentNode.getProperty("obr").getString();
	     /*kvuli pozdejsi iniciaci textPole je incicace techto probemeych
	     * zadano v casti metody a cykly, vcetne osetreni poctu slov pro 0 slov
	     */
	     String[] slova;
	     int pocetSlov;;
	     String textBezMezer = "";
	     String datum = currentNode.getProperty("jcr:created").getString();
	     Date objektData = new Date();
         Long timeStamp = objektData.getTime();
	     // ulozeni session
	     currentNode.getSession().save();
      %>
      <%-- try&catch pro odchyceni prazdnych retezcu body + textPole --%>
	      <%-- body - prazdny retezec --%>
		      <%
		        try {
		          body = currentNode.getProperty("body").getString();
		        }
		        catch (Exception e) {
		          currentNode.setProperty("body", prazdne);
		          body = currentNode.getProperty("body").getString();
		          currentNode.getSession().save();
		        }
		      %>
	      <%-- textPole - prazdny retezec --%>
		      <%
		        try {
		          textPole = currentNode.getProperty("textPole").getString();
		        }
		        catch (Exception e) {
		          currentNode.setProperty("textPole", prazdne);
		          textPole = currentNode.getProperty("textPole").getString();
		          currentNode.getSession().save();
		        }
		      %>

		        <%-- try catch pro odchyceni prazdneho style (styl pisma) --%>
    <%
      try {
          puvodniTypPisma = currentNode.getProperty("style").getString();
        }
        catch (Exception e) {
          currentNode.setProperty("style", "prazdne");
          puvodniTypPisma = currentNode.getProperty("style").getString();
          currentNode.getSession().save();
        }
      %>


     <%-- metody a cykly --%>
     	 <%
	     	 //presunuto sem z promennych kvuli pozdejsi iniciaci textPole
	     	 slova = textPole.split(" ");

	     	 if(textPole.equals("")) {
	     	 	pocetSlov=0;
	     	 }
	     	 else {
	     	 	pocetSlov = slova.length;
	     	 }

	 	 %>
     	<%--vypsani priznaku jestli stranka prosla zmenou --%>
	     <%
		     if(noveZalozeno.equals("TRUE")) {
		         nazev = currentNode.getProperty("title").getString();

		     }
		     else {
		        nazev = currentNode.getProperty("nazev").getString();
		     }
	     %>
	    <%-- nastaveni priznaku nazev, v pripade ze probehne drive tak nastane 500 kvuli ulozeni neinicializovane promenne --%>  
	        <%
	        currentNode.setProperty("nazev", nazev); //property se bude posilat na upravit kde ho bude mozno modifikovat aniz by se zmenilo url
	        %>  
	    <%-- metoda pro spocitani poctu znaku --%>
	     <%
		     for(int i = 0; i<slova.length; i++){
		     	textBezMezer += slova[i];
		     }
		     int pocetZnaku = textBezMezer.length();
	     %>

	    <%-- prevedeni datumu --%>
	      <%
	      String datumFormat = datum.substring(11, 16) +" "+ datum.substring(8, 10) + "." + datum.substring(5, 7) + ".  " + datum.substring(0, 4);
	      currentNode.setProperty("datumVytvoreni", datumFormat); 
	      %>
	<meta charset="utf-8">
	<title></title>
</head>
<body>
	<!--vykresleni obrazku -->
		<% if(!(obr).equals("none")) {

	          //vybrani velikosti obrazku
	          if(obr.contains("apacheLogo")) {
	          %>
	            <div class="containerPicture">
	            	<img src="<%= obr %>" width="60px" height="30px">
	            </div>
	          <%
	          }
	          else {
	          %>
	            <div class="containerPicture">
	            	<img src="<%= obr %>" width="30px" height="50px">
	            </div>
	          <%
	          }

	       }
	    %>
	<%--texty v blogu - start --%>
		<h1><i> Název blogu: <%= nazev %> </i></h1><br>
		<div>Anotace blogu: <%= body %> </div><br>
		<div><u>Text blogu: </u></div>
		<%= textPole %>
		<hr>
		<div>Blog obsahuje : <%= pocetSlov %> slov.</div>
		<div>Blog obsahuje: <%= pocetZnaku %> znaku bez mezer.</div>
		<div>URL: <%= request.getRequestURL().toString() %></div>
	<%--texty v blogu - konec --%>

	<!-- tlacitka pro uprava + delete nodu --> 
  <div class="vycentrujTlacitka">
		<!-- form + button pro přeměrování na uprav blog -->
	        <div>
	          <form method="POST" action="/content/MyBlog/uprav_blog.html">
	            <input type="hidden" name="_charset_" value="UTF-8" />
	            <input type="hidden" name=":redirect" value="/content/MyBlog/uprav_blog.html">
	            <input type="submit" value="uprav">
	            <!-- preposlani vsech potrebnych property -->
	            <input type="hidden" name="presmerovanoZ" value="<%= title %>">
	            <input type="hidden" name="textPole" value="<%= textPole %>">
	            <input type="hidden" name="title" value="<%= title %>">
	            <input type="hidden" name="body" value="<%= body %>">
	            <input type="hidden" name="nazev" value="<%= nazev %>">
	            <input type="hidden" name="puvodniURLStranky" value="<%= url %>">
	            <input type="hidden" name="datumVytvoreniPuvodniStranky" value="<%= datumFormat %>">
	            <input type="hidden" name="puvodniSablona" value="<%= puvodniSablona %>">
	            <input type="hidden" name="puvodniTypPisma" value="<%= puvodniTypPisma %>">
             <input type="hidden" name="puvodniObrazek" value="<%= obr %>">
             <input type="hidden" name="puvodniPath" value="<%= currentNode.getPath() %>">
	          </form>
	         </div>
		<!-- form pro smazaní blogu -->
	        <div>
	          <form method="POST" action="/content/MyBlog/main/<%= currentNode.getName() %>">
	            <input type="submit" value="Delete" />
	            <input type="hidden" name=":redirect" value="/content/MyBlog/main.html?t=<%= timeStamp %>">
	            <input type="hidden" name=":operation" value="delete" />
	           <!-- <input type="hidden" name=":redirect" value="/MyBlog/main.html"> -->
	            <% currentNode.getSession().save(); %>

	          </form>
	        </div>
	</div>        	
	<div>Vytvořeno: <%= datumFormat %> </div>
	<div style="font-size: 60%"><a href="/content/MyBlog/main.html">Odkaz na hlavní stránku</a></div>
</body>
</html>