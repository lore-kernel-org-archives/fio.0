Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:49552 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaJFWEJ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 6 Oct 2014 18:04:09 -0400
Received: by mail-oi0-f45.google.com with SMTP id i138so4311757oig.4
        for <fio@vger.kernel.org>; Mon, 06 Oct 2014 15:04:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
	<D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Mon, 6 Oct 2014 17:04:08 -0500
Message-ID: <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Oct 6, 2014 at 4:49 PM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
>
> On 10/6/14, 5:44 PM, "Stephen Cameron" <stephenmcameron@gmail.com> wrote:
>
>>On Mon, Oct 6, 2014 at 4:12 PM, Neto, Antonio Jose Rodrigues
>><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>
>>> Hi All,
>>>
>>> This is neto from Brazil
>>>
>>> How are you?
>>>
>>> Trying to compile fio on RHEL 6.4 and I've got this error (latest git).
>>>
>>> Please any ideas how to fix it? (I've tried to use CONFIG_ARITHMETIC=n,
>>> but not success)
>>>
>>> CC verify.o
>>>     CC memory.o
>>>     CC io_u.o
>>>    LEX lex.yy.c
>>>   YACC y.tab.c
>>> Usage: /usr/bin/yacc [options] filename
>>>
>>> Options:
>>>   -b file_prefix        set filename prefix (default "y.")
>>>   -d                    write definitions (y.tab.h)
>>>   -g                    write a graphical description
>>>   -l                    suppress #line directives
>>>   -o output_file        (default "y.tab.c")
>>>   -p symbol_prefix      set symbol prefix (default "yy")
>>>   -r                    produce separate code and table files (y.code.c)
>>>   -t                    add debugging support
>>>   -v                    write description (y.output)
>>>   -V                    show version information and exit
>>> make: *** [y.tab.c] Error 1
>>
>>I suspect that your version of yacc does not comprehend the --no-lines
>>option (which we needed only in order to avoid a bug in some other
>>versions of yacc).  From the usage message it does appear to
>>understand both -d and -l though.
>>
>>Try changing the --no-lines option in the Makefile to -l instead, and
>>see if that helps.
>>
>>You can also run "make V=1 > output.txt" to get more verbose output
>>from make and get a clearer idea of what the offending command line is
>>trying to do.
>>
>>-- steve
>
> Hi Steve,
>
> This is neto from Brazil
>
> How are you?
>
> I have tried with -l and I've got this: :-(
>
>   YACC y.tab.c
> /usr/bin/yacc: e - line 66 of "exp/expression-parser.y", syntax error
> %parse-param { long long *result }
> ^
> make: *** [y.tab.c] Error 1
>
>
>
> [root@s1 fio]# make V=1
> gcc -o lex.yy.o -std=gnu99 -Wwrite-strings -Wall
> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE -include
> config-host.h -DBITS_PER_LONG=64 -DFIO_VERSION='"fio-2.1.13-26-gb220c"'
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL
> -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c lex.yy.c
> exp/expression-parser.l: In function Œyylex¹:
> exp/expression-parser.l:51: error: Œyylval¹ undeclared (first use in this
> function)
> exp/expression-parser.l:51: error: (Each undeclared identifier is reported
> only once
> exp/expression-parser.l:51: error: for each function it appears in.)
> exp/expression-parser.l:52: error: ŒSUFFIX¹ undeclared (first use in this
> function)
> exp/expression-parser.l:122: error: ŒNUMBER¹ undeclared (first use in this
> function)
> make: *** [lex.yy.o] Error 1
[...]
> Any other ideas?

I found this:

http://stackoverflow.com/questions/19691665/yyparse-argument-list-is-parse-param-portable

which suggests that the "%parse-param" thing only works with bison,
and with bsd's yacc, but not with at&t's yacc, which RHEL6.4 bison
must be emulating all too faithfully.

Try "make YACC=bison V=1" and see if that helps.

-- steve
