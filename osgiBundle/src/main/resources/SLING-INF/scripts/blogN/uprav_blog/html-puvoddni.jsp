<%@page session="false"
contentType="text/html;charset=UTF-8"
import="org.apache.sling.api.request.ResponseUtil"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><sling:defineObjects/>
<%@page import="java.util.Iterator"%>
<%@page import="javax.jcr.Node"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Scanner"%>
<%@page import="javax.jcr.Node"%>
<%@page import = "java.io.*,java.util.*, java.text.SimpleDateFormat, java.time.LocalDateTime, java.time.format.*" %>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="/apps/blogN/css/test1.css">
</head>
<meta charset="UTF-8">



<body>

  %>

  <!--hodnoty zaslane z upravovane stranky -->
<%
  String upravovanaStrankaURL = currentNode.getProperty("puvodniURLStranky").getString();
  
  String prazdne = "";
  String body;
  String textPole;
  String nazev = currentNode.getProperty("nazev").getString();

%>
   


<%= upravovanaStrankaURL %> 



<%-- Try&Catch pro odchyceni prazdnych retezcu body + textPole --%>
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

        }
      %>
       
       

 

<div align="center">
<div class="containerPicture">
      <img src="/apps/pictures/apacheLogo.png" width="60px" height="30px">
    </div>
<h1>Uprav Blog</h1>
<form method="POST" action="<%= upravovanaStrankaURL %>" > 
<!-- hidden pro zaslani cestiny na stranku -->
<input type="hidden" name="_charset_" value="UTF-8" />
  <div class="containerVytvorBlog1 wrapper1">
    <table> <!--table obsahuje nazev + anotaci -->
      <tr>
        <td>
        <!--Nazev blogu a stranky (objevi se ve slingu) + anotace stranky -->
        Název:<br/>
                <input type="text" name="nazev" value="<%= nazev %>" required><br/>

              <br/>
        Anotace:<br/>
        <input type="text" name="body" value="<%= body %>"><br/>
        <br/>
        </td>            
      </tr>
    </table>
    <table>
      <tr>
      <hr width="100%">          
        <!--Text blogu -->
            Vzkaz na blog:<br>
                <input style="height:120px;" wrap="on" type="text" name="textPole" value="<%= textPole %>"></input>
                <br>
      </tr>
      <tr>        
          <td>
              <!-- vyber resource type: standart/non-standart -->
              <tr> <!--tr: resource type + styl pisma -->
                <div class="zarovnejNaKonceStranky"> <!--parent container -->
                  <fieldset> <!-- vyber resource type -->
                    <legend >Výběr resource type</legend>
                    <div align="left">
                    <input type="radio" name="sling:resourceType" value="blogN/standart" checked> Standart resource type </input> <br>
                    <input type="radio" name="sling:resourceType" value="blogN/nonStandart" >  Non-standart resource type </input> <br>
                    </div>
                  </fieldset>
                  <br>
                    <fieldset style="display: inline-block;"> <!-- vyber typ pisma -->
                      <legend>Vyber typ písma</legend>
                      <select name="style" multiple="1">
                        <option value="italic">Italic</option>
                        <option value="bold">Bold</option>
                        <option value="underline">Underline</option>
                      </select>
                    </fieldset>
                  <br>
                  <fieldset style="display: inline-block;"> <!-- vyber typ pisma -->
                      <legend>Vyber obrázek</legend>
                      <select name="obr" size="1">
                        <option value="/apps/pictures/apacheLogo.png">logo apache</option>
                        <option value="/apps/pictures/tux.jpg">tux</option>
                        <option value="none">bez obrazku</option>
                      </select>
                    </fieldset>
                </div>
              </tr>
          </td>    
      </tr>

      <br>
       <div>
      </div>
</form>
    </table>
  </div>
  <hr>
  <br>
  <br>
  <br>
  <br>     
  <input type="submit" name="submit" value="Ulož změny">
  <input type="hidden" name=":redirect" value="<%= upravovanaStrankaURL %>">
  <input type="hidden" name="noveZalozeno" value="FALSE">
  <!-- preposlani property zpet na puvodnni nod -->
  
  <!-- to do: je mozno odstranit?

  
  <input type="hidden" name="zmena" value="zmeneno">
  -->      
</div>
</body>
</html>