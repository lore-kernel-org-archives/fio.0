Return-Path: <stephenmcameron@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54333D69.7060304@kernel.dk>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
	<D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>
	<D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>
	<54333D69.7060304@kernel.dk>
Date: Mon, 6 Oct 2014 20:26:14 -0500
Message-ID: <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Oct 6, 2014 at 8:10 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-10-06 16:25, Stephen Cameron wrote:
>>
>> On Mon, Oct 6, 2014 at 5:10 PM, Neto, Antonio Jose Rodrigues
>> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>
>>>
>>>
>> [...]
>>>
>>>
>>> gcc -o lex.yy.o -std=3Dgnu99 -Wwrite-strings -Wall
>>> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE -includ=
e
>>> config-host.h -DBITS_PER_LONG=3D64 -DFIO_VERSION=3D'"fio-2.1.13-26-gb22=
0c"'
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -DFIO_INTERNAL
>>> -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG -c lex.yy.c
>>> exp/expression-parser.l:23:19: error: y.tab.h: No such file or director=
y
>>> exp/expression-parser.l: In function =E2=80=98yylex=E2=80=99:
>>> exp/expression-parser.l:51: error: =E2=80=98yylval=E2=80=99 undeclared =
(first use in this
>>> function)
>>> exp/expression-parser.l:51: error: (Each undeclared identifier is
>>> reported
>>> only once
>>> exp/expression-parser.l:51: error: for each function it appears in.)
>>> exp/expression-parser.l:52: error: =E2=80=98SUFFIX=E2=80=99 undeclared =
(first use in this
>>> function)
>>> exp/expression-parser.l:122: error: =E2=80=98NUMBER=E2=80=99 undeclared=
 (first use in
>>> this
>>> function)
>>> make: *** [lex.yy.o] Error 1
>>>
>>>
>>
>> Ok, hmm.
>>
>> Try making the following change to the Makefile:
>>
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
>>          $(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
>>
>>   y.tab.c: exp/expression-parser.y
>> -       $(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
>> +       $(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
>>
>>   y.tab.h: y.tab.c
>>
>> (I cut and pasted the above, so it is probably not a well formatted
>> patch anymore).
>>
>> That is, add " -b y " into the line for yacc.  bison by default
>> doesn't produce y.tab.c y.tab.h, it produces from xxx.y -> xxx.tab.c
>> and xxx.tab.h, which makes more sense than what yacc does, but it's
>> not what the makefile is expecting.  The "-b y" tells bison to use "y"
>> as the output file prefix, just as yacc normally does.
>>
>> then "make clean" and "make YACC=3Dbison" and see if that works.
>
>
> Should we default to using bison? Right now it checks for yacc first, and
> uses that if available. If not, it checks for bison and uses that. Would =
be
> easy enough to move around in configure.

I'm not sure, I haven't proposed a real fix because I'm not sure what
a real fix should look like.  We're using %parse-param, and I think
yacc, or bison doing an exceptionally good job of pretending to be
yacc, can't handle that.  I guess the versions of bison that I have
seen  do not do such a perfect job of pretending to be yacc, and allow
%parse-params to work anyway.   So the real fix might be to figure out
how to get away without using %parse-param, so that yacc can deal with
it.

Or maybe we just require bison?   Maybe nowadays everyone has bison?

Neto also mentioned that he wasn't able to build with arithmetic
configured off.  I didn't try to chase that down.

-- steve

