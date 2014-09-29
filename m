Return-Path: <axboe@kernel.dk>
Message-ID: <5428A98D.6040300@kernel.dk>
Date: Sun, 28 Sep 2014 18:36:29 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [RFC PATCH] fio: allow arithmetic expressions in job files
References: <CADzpL0TTYJ7VehiK=B8HC4yHp+vVGgv5S06hQWn-2FrYs2XQLA@mail.gmail.com>
In-Reply-To: <CADzpL0TTYJ7VehiK=B8HC4yHp+vVGgv5S06hQWn-2FrYs2XQLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Stephen Cameron <stephenmcameron@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-28 18:19, Stephen Cameron wrote:
> Note:  this patch is not really production quality.  I was just messing
> around with lex and yacc and wrote a little expression parser, and then
> thought, hmm, I always wished I could say "runtime=(24*60*60)" in an fio
> job file... how hard could it be to make that work?
>
> Some known issues:
>
> 1) Have not integrated with autoconf (don't know how, esp. since it uses
> lex and yacc).
>
> 2) overflow and underflow during arithmetic expression evaluation is not
> handled, and detection of floating point divide by zero is probably a
> bit iffy.  Probably some other numeric subtleties lurking in there too.
> To mitigate that, I required that expressions be enclosed in parens, so
> existing jobs essentially use the existing code for conversion of
> strings to numbers, the idea being to try to avoid accidentally breaking
> existing job files.
>
> 3) It's been awhile since I looked at fio's source, so it's possible I
> missed some avenues by which numbers are parsed.  I *think* they all go
> through str_to_float() and str_to_decimal() in parse.c.  If there are
> other avenues, I  missed those.
>
> 4) I did do some testing, but I'm no lex / yacc expert by any stretch,
> so there could be wild bugs in there.
>
> Just a fun little project I did today so I thought I'd share it, but if
> getting autoconf to deal with lex and yacc is too painful, or those
> aren't available on windows, etc., or for whatever reason this patch is
> deemed to be unusable, that won't hurt my feelings at all.

That's pretty awesome! I've wanted something like that as well, so I do 
welcome an effort to make that work. That said, there seems to be some 
hitches. I get this:

axboe@lenny:[.]git/fio/expression-parser $ make
yacc -d expression-parser.y
cc -Wall -Wextra   -c -o y.tab.o y.tab.c
lex expression-parser.l
cc -Wall -Wextra   -c -o lex.yy.o lex.yy.c
In file included from expression-parser.l:23:0:
y.tab.h:60:15: error: stray ‘#’ in program
  typedef union #line 47 "expression-parser.y" /* yacc.c:1909  */
                ^
y.tab.h:60:21: error: expected identifier or ‘(’ before numeric constant
  typedef union #line 47 "expression-parser.y" /* yacc.c:1909  */
                      ^
y.tab.h:63:7: error: stray ‘#’ in program
  union #line 47 "expression-parser.y" /* yacc.c:1909  */
        ^
y.tab.h:63:13: error: expected identifier or ‘(’ before numeric constant
  union #line 47 "expression-parser.y" /* yacc.c:1909  */
              ^
In file included from expression-parser.l:23:0:
y.tab.h:83:1: error: unknown type name ‘YYSTYPE’
  extern YYSTYPE yylval;
  ^
expression-parser.l: In function ‘yylex’:
expression-parser.l:53:11: error: request for member ‘v’ in something 
not a structure or union
      yylval.v.dval = dval;
            ^
expression-parser.l:54:11: error: request for member ‘v’ in something 
not a structure or union
      yylval.v.ival = (long long) dval;
            ^
expression-parser.l:55:11: error: request for member ‘v’ in something 
not a structure or union
      yylval.v.has_dval = 1;
            ^
expression-parser.l:56:11: error: request for member ‘v’ in something 
not a structure or union
      yylval.v.has_error = 0;
            ^
expression-parser.l:60:11: error: request for member ‘v’ in something 
not a structure or union
      yylval.v.has_error = 1;
            ^
expression-parser.l:68:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.ival = intval;
           ^
expression-parser.l:69:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.dval = (double) intval;
           ^
expression-parser.l:70:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_dval = 0;
           ^
expression-parser.l:71:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_error = 0;
           ^
expression-parser.l:75:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_error = 1;
           ^
expression-parser.l:83:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.ival = intval;
           ^
expression-parser.l:84:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.dval = (double) intval;
           ^
expression-parser.l:85:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_dval = 0;
           ^
expression-parser.l:86:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_error = 0;
           ^
expression-parser.l:90:10: error: request for member ‘v’ in something 
not a structure or union
     yylval.v.has_error = 1;
           ^
expression-parser.l:97:9: error: request for member ‘v’ in something not 
a structure or union
    yylval.v.has_error = 1;
          ^
make: *** [lex.yy.o] Error 1

And there are a few issues around the Makefile and ensuring the lex/yacc 
bits are built properly, but those can be easily fixed up.

Don't worry about the configure bits, Windows, etc. I can fix that stuff 
up pretty easily. Would be nice to have it work for me, though :-)

> p.s.  I have a feeling the mailing list won't like that I'm sending this
> from gmail.

Looked good from this end, but that may be the direct email, dunno.

-- 
Jens Axboe


