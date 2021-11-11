<%@page session="false"
contentType="text/html;charset=UTF-8"
import="org.apache.sling.api.request.ResponseUtil"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><sling:defineObjects/>
<%@page import="javax.jcr.Node"%>
<%@ page import = "java.io.*,java.util.*, java.text.SimpleDateFormat, java.time.LocalDateTime, java.time.format.*" %>

<!DOCTYPE html>
<html>
<head>
   <link rel="stylesheet" type="text/css" href="/apps/blogN/css/test1.css">
   <meta charset="UTF-8">
   <!--nazev stranky v html -->
   <title><%= currentNode.getProperty("title").getString() %> </title>
</head>
<body style="text-align: center;">
    <%-- neznámé --%>
    <%  
     String prazdne = "";
     String body;
     String textPole;
     String nazev;
     String puvodniSablona = currentNode.getProperty("sling:resourceType").getString();
     String puvodniTypPisma;
     //je nutno mit title (v zahlavi stranky=nazev stranky) + nazev jako samostatne promenne
     String title = currentNode.getProperty("title").getString();
     //v pripade noveho zalozeni ziska priznak TRUE
     String noveZalozeno = currentNode.getProperty("noveZalozeno").getString();    
     String soucasnaURL = request.getRequestURL().toString();
     currentNode.setProperty("url", soucasnaURL);
     String url = currentNode.getProperty("url").getString();
     String datum = currentNode.getProperty("jcr:created").getString();
     String obr = currentNode.getProperty("obr").getString();
     //String zmena = currentNode.getProperty("zmena").getString();
     DateTimeFormatter format = DateTimeFormatter.ofPattern("HH:mm:ss dd.MM.yyyy");
     LocalDateTime aktualniCas = LocalDateTime.now();
     String formatAktualniCas = aktualniCas.format(format);
     Date objektData = new Date();
     Long timeStamp = objektData.getTime();
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
          currentNode.setProperty("textPole", "neni");
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


   <%-- metody --%>



      <%-- prevedeni datumu --%>
        <%
        String datumFormat = datum.substring(11, 16) +" "+ datum.substring(8, 10) + "." + datum.substring(5, 7) + " " + datum.substring(0, 4);
        currentNode.setProperty("datumVytvoreni", datumFormat); 
        %>

      <%--vypsani priznaku jestli stranka prosla zmenou --%>
      <%
         //pokud je stranka nove zalozena do nazvu se nahraje title, pri uprave jiz pouze nazev
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
    <!--vyber a vykresleni obrazku -->
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
            <div class ="containerPicture">
            <img src="<%= obr %>" width="30px" height="50px">
            </div>
          <%
          }

       }
    %>

    <!-- nadpis -->
    <h2><u><% out.println(nazev); %></u></h2>
    <br>
    <%-- table s anotaci--%>
    <div>
        <table id="anotace" style="border: 1px solid black;">
          <tr>
          <td><% out.println(body); %></td>
          </tr>
        </table>
        <br>
        <%--text blogu--%>
          <div><u>Obsah blogu:</u></div>
          <table width="100%" height="200px" border = "1" >
            <tr  class="box">
              <td>
                  <%--if-else pro vyber typu --%>
                  <%--vyber stylu pisma vcetne odchyceni vyjimky --%>
        <%
          try {

            if(currentNode.getProperty("style").getString().equals("italic")){
              %> 
              <div style="font-style: italic;"> <% out.println(textPole); %> </div>
              <%
            }
            else if(currentNode.getProperty("style").getString().equals("bold")) {
              %>
              <div><strong><% out.println(textPole); %></strong></div> 
            <% 
            }
            else {
              %>
                <div><u><% out.println(textPole); %></u></div>
              <% 
            }
              }
          catch (Exception e) {
               %> <div> <% out.println(textPole); %> </div> <%
              }
                %>
              </td>
            </tr>    
          </table>
       <br/>
       </div>
       <br>
      <!-- tlacitka pro uprava + delete nodu --> 
      <div class="vycentrujTlacitka">
        <!-- form + button pro přeměrování na uprav blog -->
        <div>
          <form method="POST" action="/content/MyBlog/uprav_blog">
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
            <input type="hidden" name="puvodniSablona" value="<%= puvodniSablona %>">
            <input type="hidden" name="puvodniTypPisma" value="<%= puvodniTypPisma %>">
            <input type="hidden" name="puvodniObrazek" value="<%= obr %>">
            <input type="hidden" name="puvodniPath" value="<%= currentNode.getPath() %>">

            <input type="hidden" name="datumVytvoreniPuvodniStranky" value="<%= datumFormat %>">
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
       <br>
       <!-- tabulka Obecné -->
       <div>
         <fieldset style="display: inline-block;">
                        <legend >Obecné</legend>
         <% out.println("Blog s názvem " + nazev + " ohledně " + body + " má URL adresu: " + url + " a byl vytvořen: " + datumFormat);  %>
       </div>
       <div><a href="/content/MyBlog/main.html">Odkaz na hlavní stránku</a></div>
   </div>
   <!-- je treba zavolat session curent node a pote ulozit -->
   <% currentNode.getSession().save(); %>
</body>
</html>

