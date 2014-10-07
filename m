Return-Path: <axboe@kernel.dk>
Message-ID: <54333D69.7060304@kernel.dk>
Date: Mon, 06 Oct 2014 19:10:01 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>	<D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>	<CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>	<D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>
In-Reply-To: <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Stephen Cameron <stephenmcameron@gmail.com>, "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-06 16:25, Stephen Cameron wrote:
> On Mon, Oct 6, 2014 at 5:10 PM, Neto, Antonio Jose Rodrigues
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>
>>
> [...]
>>
>> gcc -o lex.yy.o -std=gnu99 -Wwrite-strings -Wall
>> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE -include
>> config-host.h -DBITS_PER_LONG=64 -DFIO_VERSION='"fio-2.1.13-26-gb220c"'
>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL
>> -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c lex.yy.c
>> exp/expression-parser.l:23:19: error: y.tab.h: No such file or directory
>> exp/expression-parser.l: In function ‘yylex’:
>> exp/expression-parser.l:51: error: ‘yylval’ undeclared (first use in this
>> function)
>> exp/expression-parser.l:51: error: (Each undeclared identifier is reported
>> only once
>> exp/expression-parser.l:51: error: for each function it appears in.)
>> exp/expression-parser.l:52: error: ‘SUFFIX’ undeclared (first use in this
>> function)
>> exp/expression-parser.l:122: error: ‘NUMBER’ undeclared (first use in this
>> function)
>> make: *** [lex.yy.o] Error 1
>>
>>
>
> Ok, hmm.
>
> Try making the following change to the Makefile:
>
> --- a/Makefile
> +++ b/Makefile
> @@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
>          $(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
>
>   y.tab.c: exp/expression-parser.y
> -       $(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
> +       $(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
>
>   y.tab.h: y.tab.c
>
> (I cut and pasted the above, so it is probably not a well formatted
> patch anymore).
>
> That is, add " -b y " into the line for yacc.  bison by default
> doesn't produce y.tab.c y.tab.h, it produces from xxx.y -> xxx.tab.c
> and xxx.tab.h, which makes more sense than what yacc does, but it's
> not what the makefile is expecting.  The "-b y" tells bison to use "y"
> as the output file prefix, just as yacc normally does.
>
> then "make clean" and "make YACC=bison" and see if that works.

Should we default to using bison? Right now it checks for yacc first, 
and uses that if available. If not, it checks for bison and uses that. 
Would be easy enough to move around in configure.

-- 
Jens Axboe


