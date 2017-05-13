#!/usr/bin/perl -w
use strict;
use CGI;
########################################
my $posts_dir = "board";
my $title = "Tiny Bulletin Board by cal";
########################################
my $query = new CGI;
print qq(content-type: text/html\n\n);
print qq(<html><head><title>$title</title></head><body><b>$title</b><hr>);
my $t=$query->param('t');
my $topic=$query->param('topic');
my $email=$query->param('email');
my $message=$query->param('message');
$message =~ s|\n|<br>|g;
if ($t){
	if ($email){
		my $p = time()."-$$";
		open(FH,">$posts_dir/p-$t-$p") or die;
		print FH "$email\n";
		print FH "$message\n";
		close(FH);
	}
	open(FH,"$posts_dir/t-$t") or die;
	my $thread = <FH>;
	close(FH);
	print qq(<b><a href="board.pl">Topics</a> &gt; $thread</b><br><br>);
	opendir(DH,$posts_dir);
	my @posts = sort{(split(/-/,$a))[1] <=> (split(/-/,$b))[1]} grep{m|^p-$t-|}readdir DH;
	close(DH);
	foreach(@posts){
		open(FH,"$posts_dir/$_") or die;
		chomp(my @post = <FH>);
		print qq(<hr><i><a href="mailto:$post[0]">$post[0]</a> says:</i><br><br>$post[1]);
		close(FH);
	}
	print qq(<hr><form method="post"><input type="hidden" name="t" value="$t">email:<br><input type="text" name="email"><br>message:<br><textarea name="message" cols="30" rows="8"></textarea><br><br><input type="submit" value="Post Reply"></form>);
}else{
	if ($topic){
		my $t = time()."-$$";
		open(FH,">$posts_dir/t-$t") or die;
		print FH $topic;
		close(FH);
		open(FH,">$posts_dir/p-$t-$t") or die;
		print FH "$email\n";
		print FH "$message\n";
		close(FH);
	}
	print qq(<b>Topics</b><br><br>);
	opendir(DH,$posts_dir);
	my @topics = reverse sort{(split(/-/,$a))[1] <=> (split(/-/,$b))[1]} grep{m|^t-|}readdir DH;
	close(DH);
	foreach(@topics){
		open(FH,"$posts_dir/$_") or die;
		my $data = <FH>;
		my @x = split(/-/,$_);
		print qq(<a href="board.pl?t=$x[1]-$x[2]">$data</a><br>);
		close(FH);		
	}
	print qq(<hr><form method="post">topic:<br><input type="text" name="topic"><br>email:<br><input type="text" name="email"><br>message:<br><textarea name="message" cols="30" rows="8"></textarea><br><br><input type="submit" value="Post Topic"></form>);
}
print qq(<a href="source.pl?script=board.pl">View the source</a></body></html>);