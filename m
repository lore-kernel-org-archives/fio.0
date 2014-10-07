Return-Path: <axboe@kernel.dk>
Message-ID: <5433F5CA.80902@kernel.dk>
Date: Tue, 07 Oct 2014 08:16:42 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com> <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com> <D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com> <54333D69.7060304@kernel.dk> <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com> <54334D63.70909@kernel.dk> <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 07:39 AM, Neto, Antonio Jose Rodrigues wrote:
>=20
>=20
> On 10/6/14, 10:18 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>=20
>> On 2014-10-06 19:26, Stephen Cameron wrote:
>>> On Mon, Oct 6, 2014 at 8:10 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2014-10-06 16:25, Stephen Cameron wrote:
>>>>>
>>>>> On Mon, Oct 6, 2014 at 5:10 PM, Neto, Antonio Jose Rodrigues
>>>>> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>> [...]
>>>>>>
>>>>>>
>>>>>> gcc -o lex.yy.o -std=3Dgnu99 -Wwrite-strings -Wall
>>>>>> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE
>>>>>> -include
>>>>>> config-host.h -DBITS_PER_LONG=3D64
>>>>>> -DFIO_VERSION=3D'"fio-2.1.13-26-gb220c"'
>>>>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -DFIO_INTERNAL
>>>>>> -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG -c lex.yy.c
>>>>>> exp/expression-parser.l:23:19: error: y.tab.h: No such file or
>>>>>> directory
>>>>>> exp/expression-parser.l: In function =EF=BF=BDyylex=EF=BF=BD:
>>>>>> exp/expression-parser.l:51: error: =EF=BF=BDyylval=EF=BF=BD undeclar=
ed (first use in
>>>>>> this
>>>>>> function)
>>>>>> exp/expression-parser.l:51: error: (Each undeclared identifier is
>>>>>> reported
>>>>>> only once
>>>>>> exp/expression-parser.l:51: error: for each function it appears in.)
>>>>>> exp/expression-parser.l:52: error: =EF=BF=BDSUFFIX=EF=BF=BD undeclar=
ed (first use in
>>>>>> this
>>>>>> function)
>>>>>> exp/expression-parser.l:122: error: =EF=BF=BDNUMBER=EF=BF=BD undecla=
red (first use in
>>>>>> this
>>>>>> function)
>>>>>> make: *** [lex.yy.o] Error 1
>>>>>>
>>>>>>
>>>>>
>>>>> Ok, hmm.
>>>>>
>>>>> Try making the following change to the Makefile:
>>>>>
>>>>> --- a/Makefile
>>>>> +++ b/Makefile
>>>>> @@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
>>>>>           $(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
>>>>>
>>>>>    y.tab.c: exp/expression-parser.y
>>>>> -       $(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
>>>>> +       $(QUIET_YACC)$(YACC) --no-lines -d -b y
>>>>> exp/expression-parser.y
>>>>>
>>>>>    y.tab.h: y.tab.c
>>>>>
>>>>> (I cut and pasted the above, so it is probably not a well formatted
>>>>> patch anymore).
>>>>>
>>>>> That is, add " -b y " into the line for yacc.  bison by default
>>>>> doesn't produce y.tab.c y.tab.h, it produces from xxx.y -> xxx.tab.c
>>>>> and xxx.tab.h, which makes more sense than what yacc does, but it's
>>>>> not what the makefile is expecting.  The "-b y" tells bison to use "y"
>>>>> as the output file prefix, just as yacc normally does.
>>>>>
>>>>> then "make clean" and "make YACC=3Dbison" and see if that works.
>>>>
>>>>
>>>> Should we default to using bison? Right now it checks for yacc first,
>>>> and
>>>> uses that if available. If not, it checks for bison and uses that.
>>>> Would be
>>>> easy enough to move around in configure.
>>>
>>> I'm not sure, I haven't proposed a real fix because I'm not sure what
>>> a real fix should look like.  We're using %parse-param, and I think
>>> yacc, or bison doing an exceptionally good job of pretending to be
>>> yacc, can't handle that.  I guess the versions of bison that I have
>>> seen  do not do such a perfect job of pretending to be yacc, and allow
>>> %parse-params to work anyway.   So the real fix might be to figure out
>>> how to get away without using %parse-param, so that yacc can deal with
>>> it.
>>>
>>> Or maybe we just require bison?   Maybe nowadays everyone has bison?
>>
>> It's probably a safer choice than defaulting to yacc, me thinks... We'll
>> see how that goes. I might have to extend and improve it to check not
>> just if it's there, but if it actually works for our case as well. But
>> baby steps, perhaps this is enough.
>>
>>> Neto also mentioned that he wasn't able to build with arithmetic
>>> configured off.  I didn't try to chase that down.
>>
>> I think that's a build issue due to hand editing stuff and attempting a
>> build. The current code builds fine if it's off, I definitely tested
>> that prior to pulling things in.
>>
>> --=20
>> Jens Axboe
>=20
>=20
>=20
> Hi Jens,
>=20
> This is neto from Brazil
>=20
> How are you?
>=20
> I have applied the latest commit.
>=20
> On MAC:
>=20
> Still getting warnings:
>=20
>   YACC y.tab.c
>     CC lex.yy.o
> lex.yy.c:1231:3: warning: incompatible pointer types passing 'yy_size_t *'
>       (aka 'unsigned long *') to parameter of type 'int *'
>       [-Wincompatible-pointer-types]
>   ...YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
>                 lexer_input((buffer), &(bytes_read), (bytes_requested))
>                                       ^~~~~~~~~~~~~
> exp/expression-parser.l:27:43: note: passing argument to parameter
> 'nbytes' here
> extern int lexer_input(char* buffer, int *nbytes, int buffersize);

Should be better if you pull the latest. Let me know.

--=20
Jens Axboe


