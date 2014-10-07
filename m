Return-Path: <axboe@kernel.dk>
Message-ID: <5433F5FF.60508@kernel.dk>
Date: Tue, 07 Oct 2014 08:17:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com> <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com> <D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com> <54333D69.7060304@kernel.dk> <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com> <54334D63.70909@kernel.dk> <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05967DE.51EB1%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D05967DE.51EB1%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 07:51 AM, Neto, Antonio Jose Rodrigues wrote:
> 
> 
> On 10/7/14, 9:39 AM, "Neto, Antonio Jose Rodrigues"
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
> 
>>
>>
>> On 10/6/14, 10:18 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>
>>> On 2014-10-06 19:26, Stephen Cameron wrote:
>>>> On Mon, Oct 6, 2014 at 8:10 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 2014-10-06 16:25, Stephen Cameron wrote:
>>>>>>
>>>>>> On Mon, Oct 6, 2014 at 5:10 PM, Neto, Antonio Jose Rodrigues
>>>>>> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> [...]
>>>>>>>
>>>>>>>
>>>>>>> gcc -o lex.yy.o -std=gnu99 -Wwrite-strings -Wall
>>>>>>> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE
>>>>>>> -include
>>>>>>> config-host.h -DBITS_PER_LONG=64
>>>>>>> -DFIO_VERSION='"fio-2.1.13-26-gb220c"'
>>>>>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL
>>>>>>> -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c lex.yy.c
>>>>>>> exp/expression-parser.l:23:19: error: y.tab.h: No such file or
>>>>>>> directory
>>>>>>> exp/expression-parser.l: In function Œyylex¹:
>>>>>>> exp/expression-parser.l:51: error: Œyylval¹ undeclared (first use in
>>>>>>> this
>>>>>>> function)
>>>>>>> exp/expression-parser.l:51: error: (Each undeclared identifier is
>>>>>>> reported
>>>>>>> only once
>>>>>>> exp/expression-parser.l:51: error: for each function it appears in.)
>>>>>>> exp/expression-parser.l:52: error: ŒSUFFIX¹ undeclared (first use in
>>>>>>> this
>>>>>>> function)
>>>>>>> exp/expression-parser.l:122: error: ŒNUMBER¹ undeclared (first use
>>>>>>> in
>>>>>>> this
>>>>>>> function)
>>>>>>> make: *** [lex.yy.o] Error 1
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Ok, hmm.
>>>>>>
>>>>>> Try making the following change to the Makefile:
>>>>>>
>>>>>> --- a/Makefile
>>>>>> +++ b/Makefile
>>>>>> @@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
>>>>>>           $(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
>>>>>>
>>>>>>    y.tab.c: exp/expression-parser.y
>>>>>> -       $(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
>>>>>> +       $(QUIET_YACC)$(YACC) --no-lines -d -b y
>>>>>> exp/expression-parser.y
>>>>>>
>>>>>>    y.tab.h: y.tab.c
>>>>>>
>>>>>> (I cut and pasted the above, so it is probably not a well formatted
>>>>>> patch anymore).
>>>>>>
>>>>>> That is, add " -b y " into the line for yacc.  bison by default
>>>>>> doesn't produce y.tab.c y.tab.h, it produces from xxx.y -> xxx.tab.c
>>>>>> and xxx.tab.h, which makes more sense than what yacc does, but it's
>>>>>> not what the makefile is expecting.  The "-b y" tells bison to use
>>>>>> "y"
>>>>>> as the output file prefix, just as yacc normally does.
>>>>>>
>>>>>> then "make clean" and "make YACC=bison" and see if that works.
>>>>>
>>>>>
>>>>> Should we default to using bison? Right now it checks for yacc first,
>>>>> and
>>>>> uses that if available. If not, it checks for bison and uses that.
>>>>> Would be
>>>>> easy enough to move around in configure.
>>>>
>>>> I'm not sure, I haven't proposed a real fix because I'm not sure what
>>>> a real fix should look like.  We're using %parse-param, and I think
>>>> yacc, or bison doing an exceptionally good job of pretending to be
>>>> yacc, can't handle that.  I guess the versions of bison that I have
>>>> seen  do not do such a perfect job of pretending to be yacc, and allow
>>>> %parse-params to work anyway.   So the real fix might be to figure out
>>>> how to get away without using %parse-param, so that yacc can deal with
>>>> it.
>>>>
>>>> Or maybe we just require bison?   Maybe nowadays everyone has bison?
>>>
>>> It's probably a safer choice than defaulting to yacc, me thinks... We'll
>>> see how that goes. I might have to extend and improve it to check not
>>> just if it's there, but if it actually works for our case as well. But
>>> baby steps, perhaps this is enough.
>>>
>>>> Neto also mentioned that he wasn't able to build with arithmetic
>>>> configured off.  I didn't try to chase that down.
>>>
>>> I think that's a build issue due to hand editing stuff and attempting a
>>> build. The current code builds fine if it's off, I definitely tested
>>> that prior to pulling things in.
>>>
>>> -- 
>>> Jens Axboe
>>
>>
>>
>> Hi Jens,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> I have applied the latest commit.
>>
>> On MAC:
>>
>> Still getting warnings:
>>
>>  YACC y.tab.c
>>    CC lex.yy.o
>> lex.yy.c:1231:3: warning: incompatible pointer types passing 'yy_size_t *'
>>      (aka 'unsigned long *') to parameter of type 'int *'
>>      [-Wincompatible-pointer-types]
>>  ...YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
>>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
>>                lexer_input((buffer), &(bytes_read), (bytes_requested))
>>                                      ^~~~~~~~~~~~~
>> exp/expression-parser.l:27:43: note: passing argument to parameter
>> 'nbytes' here
>> extern int lexer_input(char* buffer, int *nbytes, int buffersize);
>>                                          ^
>>
>>
>>
>> On Linux (RedHat 6.4)
>>
>> All good :-)
>>
>> Thank you,
>>
>> neto
> 
> Hi Jens,
> 
> This is neto from Brazil
> 
> How are you?
> 
> Another issue that I have realized, on RHEL the new tools t/dedupe works
> but it does not work on my mac.
> 
> Seems to me that is related to YACC.
> 
> Please see below:
> 
> Nossa Senhora:fio neto$ make V=1 t/dedupe
> gcc  -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement -O3 -g
> -ffast-math  -D_GNU_SOURCE -include config-host.h -DBITS_PER_LONG=64
> -DFIO_VERSION='"fio-2.1.13-31-g15e3"' -o t/dedupe  -ll -lz  -lm  -lpthread
> -ldl
> Undefined symbols for architecture x86_64:
>   "_yylex", referenced from:
>       _main in libl.a(libmain.o)
> ld: symbol(s) not found for architecture x86_64
> clang: error: linker command failed with exit code 1 (use -v to see
> invocation)
> make: *** [t/dedupe] Error 1
> 
> Any idea how to fix it?

It's only supported on Linux right now, it will be built automatically
there. Not really a design problem, it's just that it has the Linux
method for getting the size of a block device hard wired. I can fix that
pretty quickly.

-- 
Jens Axboe


