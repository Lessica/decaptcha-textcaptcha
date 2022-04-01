#!/usr/bin/env perl
{
    package MyWebServer;

    use 5.010;
    use strict;
    use warnings;

    use Decaptcha::TextCaptcha;
    use HTTP::Server::Simple::CGI;
    use base qw(HTTP::Server::Simple::CGI);
    
    my %dispatch = (
        '/hello' => \&resp_hello,
        '/qa' => \&resp_qa,
        # ...
    );
    
    sub handle_request {
        my $self = shift;
        my $cgi  = shift;
    
        my $path = $cgi->path_info();
        my $handler = $dispatch{$path};
    
        if (ref($handler) eq "CODE") {
            print "HTTP/1.0 200 OK\r\n";
            $handler->($cgi);
        } else {
            print "HTTP/1.0 404 Not found\r\n";
            print $cgi->header,
                $cgi->start_html('Not found'),
                $cgi->h1('Not found'),
                $cgi->end_html;
        }
    }
    
    sub resp_hello {
        my $cgi  = shift;   # CGI.pm object
        return if !ref $cgi;
        
        my $who = $cgi->param('name');
        
        print $cgi->header,
            $cgi->start_html("Hello"),
            $cgi->h1("Hello $who!"),
            $cgi->end_html;
    }

    sub resp_qa {
        my $cgi  = shift;   # CGI.pm object
        return if !ref $cgi;

        my $question = $cgi->param('q');
        my $answer = decaptcha $question;

        print $cgi->header,
            $cgi->start_html("Answer"),
            $cgi->p("$answer"),
            $cgi->end_html;
    }
} 
 
# start the server on port 8093
my $pid = MyWebServer->new(8093)
->run();
# ->background();
# print "Use 'kill $pid' to stop server.\n";
