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
<%@page import="java.io.*,java.util.*, java.text.SimpleDateFormat, java.time.LocalDateTime, java.time.format.*" %>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="/apps/blogN/css/test1.css">
</head>
<meta charset="UTF-8">



<body>


  <!--hodnoty zaslane z upravovane stranky -->
  <%
  String upravovanaStrankaURL = currentNode.getProperty("puvodniURLStranky").getString();  
  String prazdne = "";
  String body = "";
  String textPole = "";
  String nazev = currentNode.getProperty("nazev").getString();;
  String puvodniObrazek = "";
  String puvodniTypPisma = "";
  String puvodniSablona = "";
  String odkazZpet =  currentNode.getProperty("puvodniPath").getString();

%>

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





       <%-- checked zaslaneho vyberu u sling:resourceType --%>
      
         <%--
         Bude treba nejdrive zjistit jaky je sling:Resource type pomoci if (v pripade vetsiho vyberu bude mozno upravit do else-if) a priradit (int) pomVar
        //vytvorena neznama "(String)priznakResource-nazev resource type" kterou inicializuji prazdnou - pocet resource type = pocet techto neznamych
        //Pote pomoci switch prepinace (int pomVar)bude do dane nezname prirazen String checked, tato neznama bude pomoci JSP expresion tagu zobrazena v inputu
        --%>
       
      <%

        try{
          puvodniSablona = currentNode.getProperty("puvodniSablona").getString();
        }
        catch(Exception e){
          currentNode.setProperty("puvodniSablona", "blogN/standart");
          puvodniSablona = currentNode.getProperty("puvodniSablona").getString();
        }

        
        int poradiResource;
        String resourceStandart = "";
        String resourceNonStandart = "";

        if(puvodniSablona.equals("blogN/standart")) {
            
            poradiResource = 0;
          }
        else {
          poradiResource = 1;
        }

        switch(poradiResource){

          case 0 : 
          resourceStandart = "checked";
          break;

          case 1 : 
          resourceNonStandart = "checked";
          break;
        }

      %>

      <%-- checked zaslaneho vyberu u  puvodniho stylu pisma --%>
      <%  
        try{
          puvodniTypPisma = currentNode.getProperty("puvodniTypPisma").getString();
        }
        catch(Exception e){
          currentNode.setProperty("puvodniTypPisma", "none");
          puvodniTypPisma = currentNode.getProperty("puvodniTypPisma").getString();
        }
        int poradiTypPisma;
        String italicResource = "";
        String boldResource = "";
        String underlineResource = "";
        String noneResource = "";

        if(puvodniTypPisma.equals("italic")) {
            
            poradiTypPisma = 0;
          }
        else if(puvodniTypPisma.equals("bold")){
          poradiTypPisma = 1;
        }
        else if(puvodniTypPisma.equals("underline")){
          poradiTypPisma = 2;
        }
        else {
          poradiTypPisma = -1;
        }

        switch(poradiTypPisma){

          case 0 : 
          italicResource = "selected";
          break;

          case 1 : 
          boldResource = "selected";
          break;

          case 2 : 
          underlineResource = "selected";
          break;

          default :
          noneResource = "selected";
          break;
        
        }

      %>
      <%-- checked zaslaneho vyberu u  puvodniho stylu pisma --%>
      <%  
        try{
          puvodniObrazek = currentNode.getProperty("puvodniObrazek").getString();
        }
        catch(Exception e){
          currentNode.setProperty("puvodniObrazek", "none");
          puvodniObrazek = currentNode.getProperty("puvodniObrazek").getString();
        }
        
        int poradiObrazek;
        String obrazekLogo = "";
        String obrazekTux = "";
        String bezObrazku = "";

        if(puvodniObrazek.contains("apacheLogo")) {
            
            poradiObrazek = 0;
          }
        else if(puvodniObrazek.contains("tux")){
          poradiObrazek = 1;
        }
        else{
          poradiObrazek = -1;
        }

        switch(poradiObrazek){

          case 0 : 
          obrazekLogo = "selected";
          break;

          case 1 : 
          obrazekTux = "selected";
          break;

          default :
          bezObrazku = "selected";
          break;
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
                    <input type="radio" name="sling:resourceType" value="blogN/standart" <%= resourceStandart %> > Standart resource type </input> <br>
                    <input type="radio" name="sling:resourceType" value="blogN/nonStandart" <%= resourceNonStandart %> >  Non-standart resource type </input> <br>
                    </div>
                  </fieldset>
                  <br>
                    <fieldset style="display: inline-block;"> <!-- vyber typ pisma -->
                      <legend>Vyber typ písma</legend>
                      <select name="style" multiple="1">
                        <option value="italic" <%= italicResource %> >Italic</option>
                        <option value="bold" <%= boldResource %> >Bold</option>
                        <option value="underline" <%= underlineResource %> >Underline</option>
                        <option value="none" <%= noneResource %> >zadny</option>
                      </select>
                    </fieldset>
                  <br>
                  <fieldset style="display: inline-block;"> <!-- vyber typ pisma -->
                      <legend>Vyber obrázek</legend>
                      <select name="obr" size="1">
                        <option value="/apps/pictures/apacheLogo.png" <%= obrazekLogo %> >logo apache</option>
                        <option value="/apps/pictures/tux.jpg" <%= obrazekTux %>>tux</option>
                        <option value="none" <%= bezObrazku %>>bez obrazku</option>
                      </select>
                    </fieldset>
                </div>
              </tr>
          </td>    
      </tr>

      <br>
       <div>
      </div>
      <div class="vycentrujTlacitka">
      <input type="submit" name="submit" value="Ulož změny">
      <input type="hidden" name="title" value="<%= currentNode.getProperty("title").getString()%>">
      <input type="hidden" name=":redirect" value="<%= odkazZpet %>.html">
      <input type="hidden" name="noveZalozeno" value="FALSE">
      <input type="reset" value="vymaž změny">
      </div>
</form>
    </table>
  </div>
  <hr>
  <br>
  <br>
  <br>
  <br>     
  
  <!-- preposlani property zpet na puvodnni nod -->
  
  <!-- to do: je mozno odstranit?

  
  <input type="hidden" name="zmena" value="zmeneno">
  -->      
</div>
</body>
</html>