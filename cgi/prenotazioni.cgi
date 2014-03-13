#!/usr/bin/perl -w

use CGI;
use CGI::Carp 'fatalsToBrowser';
$page=new CGI;
print "Content-type: text/html\n\n";

print<<EOF

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  xml:lang="it" lang="it">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="viewport" content="width=device-width">
<title>Centro Sportivo</title>
<link rel="stylesheet" type="text/css" media="only screen and (min-width: 768px)" href="css/style.css" />
<link rel="stylesheet" media="only screen and (min-width: 481px) and (max-width: 767px)" href="css/tablet.css" />
<link rel="stylesheet" media="only screen and (max-width: 480px)" href="css/mobile.css" />

</head>
<body>
<div id="container">
	<div id="header">
		<h1>Centro Sportivo</h1>

		<div id="path">

		</div>
	</div>

	<div id="nav">
		<ul>
		<li><a href="./index.html">Home</a></li>
		<li><a href="./calcetto.html">Calcio a 5</a></li>
		<li><a href="./calciotto.html">Calciotto</a></li>
		<li><a href="./tennis.html">Tennis</a></li>
		<li><a href="./beachvolley.html"> <span xml:lang="en">Beach Volley</span></a></li>
		<li><a href="./pallavolo.html">Pallavolo</a></li>
		<li><a href="./artimarziali.html">Arti Marziali</a></li>
		<li><a href="./fitness.html">Fitness</a></li>
		<li><a href="./contatti.html">Contatti</a></li>
        <li><a id="active">Prenota</a></li>
		</ul>
	</div>

	<div id="content">
		<form method="POST" action="./cgi-bin/checkform.pl">
			<fieldset>
				<legend><h2>PRENOTAZIONE</h2></legend>
				<label>Nome:
				    <input type="text" name="nome" id="nome" value="" />
                </label>
				<label>Cognome: 
				    <input type="text" name="cognome" id="cognome" value="" />
                </label>    
				<label>Telefono: 
				    <input type="text" name="telefono" id="telefono" value="" />
                </label>    
				<label >Email:
				    <input type="email" name="email" id="email" value="" />
                 </label>    
				<label> Disciplina:
				    <select name="disciplina" id="disciplina"><option value="Calcetto">Calcetto</option><option value="Calciotto">Calciotto</option><option value="Pallavolo">Pallavolo</option></select> 
                 </label>
				<!--
				<label for="giorno"> Giorno: </label>
				<select name="giorno" id="giorno"><option value="01">01</option><option value="02">02</option><option value="03">03</option></select>
				<label for="mese"> Mese: </label>
				<select name="mese" id="mese"><option value="Calcetto">Calcetto</option><option value="Calciotto">Calciotto</option><option value="Pallavolo">Pallavolo</option></select> 
				<label for="anno"> Anno: </label>
				<select name="anno" id="anno"><option value="Calcetto">Calcetto</option><option value="Calciotto">Calciotto</option><option value="Pallavolo">Pallavolo</option></select>  
			-->
				<label>Giorno: 
   				<input type="date" name="mydatetime" id="date" >
  				</label>
            </fieldset>
            <fieldset>
  		        <input type="reset"  value="Resetta il form" class="button">
  		        <input type="submit" value="Invia" class="button">
            </fieldset>
	</form>
	</div>
	<div id="news_container">
	<div id="news">
			<h2>NEWS</h2>
		<ul>
		      <li>NEW1</li>
		      <li>NEW2</li>
		      <li>ew3New3NewNew3New3New3New3NewNew3New3New3NewNew3New3New3</li>
		      <li>New4</li>
		</ul>
	</div>
	</div>
	<div id="footer">
		<p>
		    <span xml:lang="en">Copyright</span>© 2014 CiccipanzeSulWeb
		    <a href="http://validator.w3.org/check?uri=referer">
			<img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Strict" height="31" width="88" />
		    </a>
		</p>
	</div>

</div>
</body>
</html>

EOF
