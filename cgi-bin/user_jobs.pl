#!/usr/bin/perl

use UTILS::UserService;

my $cgi = CGI->new;
my $service = UTILS::UserService->new;
my %sess_params = $service->session_params($cgi);
unless($sess_params{is_logged} || $cgi->param('_cmd') eq 'reg'){
    print $cgi->header(-location => 'load.cgi?page=registrazione');
    return;
}

my %job = (
    'mod_d'  => \&mod_data,
    'mod_pw' => \&mod_pwd,
    'send'   => \&send_mail,
    'book'   => \&book,
    'reg'    => \&register
    );

if($cgi->request_method eq 'GET'){
    print $cgi->redirect(-location => 'load.cgi?page=home');
}
my $cmd = $cgi->param('_cmd');	# lanciare pagina 404

$job{$cmd}->($cgi);

sub book {
    my $cgi = shift;
    my $today = $service->_today();
    my($disciplina, $giorno, $mese, $anno, $ora) = 
	($cgi->param('disciplina'), $cgi->param('giorno'), $cgi->param('mese'), $cgi->param('anno'), $cgi->param('ora'));
    my $data = $anno."-".$mese."-".$giorno;
    $data = $today->ymd("-") if $data eq '';
    $service->validate($data);
    my $campo = $service->select_field($disciplina, $data, $ora);
    my $parser = XML::LibXML->new();
    my $xml = $parser->parse_file("../data/prenotazioni.xml");
    my ($show, $table, $tbl, $test);

    if($campo != -1){
	my $new_element = 
	    "
    <prenotante>
      <email>".$sess_params{profile}."</email>
      <disciplina>".$disciplina."</disciplina>
      <campo>".$campo."</campo>
      <data>".$data."</data>
      <ora>".$ora."</ora>
    </prenotante>
    ";
	
	my $pren = $xml->getElementsByTagName('prenotazioni')->[0];
	my $chunk = $parser->parse_balanced_chunk($new_element);
    
	$pren->appendChild($chunk);	# appendo il nuovo appena creato
	# $prenotazioni[0]->appendChild($chunk);
    
	open(OUT, ">../data/prenotazioni.xml");
	print OUT $xml->toString; 
	close OUT;
	$test = 1;
	$show = 1;
    }
    else{
	$test = 0;
	$show = 1;
	$table = $service->getWeek($disciplina, $campo, $data);
    }

    my %params = (
	LOGIN => $sess_params{is_logged},
	USER =>  $sess_params{profile},
	page => 'prenota',
	path => '<a href="load.cgi?page=prenotazioni">Prenotazioni</a> >> Prenota',
	is_logged => $sess_params{is_logged},
	show     => $show,
	test     => $test,
	campo    => $campo,
	table    => $table,
	);
    
    $service->dispatcher('prenota', %params);
}

sub register {
    my $cgi = shift;
    my ($name, $surname, $tel, $email, $password) = 
	($cgi->param('nome'), $cgi->param('cognome'), $cgi->param('telefono'), $cgi->param('email'), $cgi->param('password'));
    my $file = '../data/profili.xml';
    my $parser = XML::LibXML->new();
    my $xml = $parser->parse_file($file);
    my %find = $service->get_generals($email);
    my $registered = 0;
    my $has_account = 0;
    my $error = 0;

    if($email !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i || !$service->validate_tel($tel) || !length($name) || !length($surname) || !length($tel) || !length($email) || !length($password)){
	$error = 1;
    }
    elsif(exists $find{not_found}){
	my $new_element = 
	    "
    <profilo>
      <username>".$email."</username>
      <password>".$password."</password>
      <nome>".$name."</nome>
      <cognome>".$surname."</cognome>
      <telefono>".$tel."</telefono>
    </profilo>
    ";
	
	my $pren = $xml->getElementsByTagName('profili')->[0];
	my $chunk = $parser->parse_balanced_chunk($new_element);
	
	$pren->appendChild($chunk);	# appendo il nuovo appena creato
# $prenotazioni[0]->appendChild($chunk);
	
	open(OUT, ">$file");
	print OUT $xml->toString; 
	close OUT;
	$registered = 1;
    }
    else  { $has_account = 1;}
    my %params = (
	title       => 'Centro sportivo - Registrazione',
	page        => 'registrazione',
	path        => '<a href="load.cgi?page=personale">Personale</a> >> Registrazione',
	LOGIN       => 0,
	has_account => $has_account,
	registered  => $registered,
	error       => $error,
	r_name      => $name,
	r_surname   => $surname,
	r_tel       => $tel,
	r_mail      => $email
	);
    $service->dispatcher('registrazione', %params);   
}

sub mod_data {
    my $cgi = shift;
    my ($nome, $cognome, $email, $telefono)  = 
	($cgi->param('nome'), $cgi->param('cognome'), $sess_params{profile}, $cgi->param('telefono'));

    my $parser = XML::LibXML->new();
    my $xml = $parser->parse_file('../data/profili.xml');
    my $root = $xml->getDocumentElement();
    my $password;
    if($root->exists("//profilo[username='$email']")){
	$password = $xml->findnodes("//profilo[username='$email']/password")->[0]->textContent;
    }
    else{
	print "Content-type: text/html\n\nerrore";
	return;
	# 404
    }
    my $token = $xml->getElementsByTagName('profili')->[0];
    my $node = "
   <profilo>
      <username>$email</username>
      <nome>$nome</nome>
      <cognome>$cognome</cognome>
      <telefono>$telefono</telefono>
      <password>$password</password>
   </profilo>
";
    my $chunk = $parser->parse_balanced_chunk($node);
    $token = $root->findnodes("//profilo[username='$email']")->get_node(1);
    $token->replaceChild($chunk, $token) || die $!;

    open(OUT, ">../data/profili.xml") || die $!;
    print OUT $xml->toString || die $!;
    close OUT;
    print "Content-type: text/html\n\nOperazione riuscita\n";
}

sub mod_pwd {
    my $cgi = shift;
    my ($old_pwd, $new_pwd) = ($cgi->param('vpassword'), $cgi->param('password'));
    my $parser = XML::LibXML->new();
    my $xml = $parser->parse_file('../data/profili.xml');
    my $root = $xml->getDocumentElement();
    unless($root->exists("//profilo[username='$sess_params{profile}' and password='$old_pwd']")){
	# error 404;
    }
    my ($node) = $root->findnodes("//profilo[username='$sess_params{profile}' and password='$old_pwd']/password");
    $node->removeChildNodes();
    $node->appendText($new_pwd);
    open(OUT, ">../data/profili.xml") || die $!;
    print OUT $xml->toString || die $!;
    close OUT;
}

sub send_mail {
}
