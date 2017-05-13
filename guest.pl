#!/usr/bin/perl -w
use strict;
use CGI;
########################################
my $posts_dir = "guest";
my $per_page = 5;
my $title = "Tiny Guestbook by cal";
########################################
my $query = new CGI;
print qq(content-type: text/html\n\n);
print qq(<html><head><title>$title</title></head><body><b>$title</b><hr>);
my $post = $query->param('post');
if ($post){
	my $time = time();
	open(FH,">$posts_dir/$time-$$") or die;
	print FH $post;
	close(FH);
	print "POST: $posts_dir/$time-$$";
}
my $page = $query->param('page');
if (!$page){$page = 1;}
opendir(DH,$posts_dir);
my @files = reverse sort{(split(/-/,$a))[0] <=> (split(/-/,$b))[0]} grep{$_ ne '.' && $_ ne '..'}readdir DH;
close(DH);
my $pages = scalar(@files)/$per_page;
$pages = (int($pages) == $pages)?$pages:int($pages)+1;
@files = splice(@files,($page-1)*$per_page,$per_page);
for(@files){
	open(FH,"$posts_dir/$_") or die;
	print join("<br>",<FH>).'<hr>';
	close(FH);
}
print "<b>Page: </b>";
for(1..$pages){if ($_==$page){print"<b>$_</b> ";}else{print"<a href=\"guest.pl?page=$_\">$_</a> ";}}
print qq(<form method="post"><textarea name="post" cols="30" rows="8"></textarea><br><input type="submit" value="post"></form>);
print qq(<a href="source.pl?script=guest.pl">View the source</a></body></html>);