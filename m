Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33901 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFWbV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 6 Oct 2014 18:31:21 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so4705849obc.37
        for <fio@vger.kernel.org>; Mon, 06 Oct 2014 15:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D0588FC6.51DE1%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
	<D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>
	<D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>
	<D0588FC6.51DE1%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Mon, 6 Oct 2014 17:31:20 -0500
Message-ID: <CADzpL0Rf=j5U+TCZVv3GOVe9L7-DVPrXnDWt4J4aSfbVmf4N_Q@mail.gmail.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Glad I could help, and that this got fio going for you, and it's ok as
a temporary fix, but really, it should just work without having to
mess around with such things, so I still have some work to do to
figure out how to make that happen.

-- steve


On Mon, Oct 6, 2014 at 5:28 PM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
>
> On 10/6/14, 6:25 PM, "Stephen Cameron" <stephenmcameron@gmail.com> wrote:
>
>>On Mon, Oct 6, 2014 at 5:10 PM, Neto, Antonio Jose Rodrigues
>><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>>
>>>
>>[...]
>>>
>>> gcc -o lex.yy.o -std=gnu99 -Wwrite-strings -Wall
>>> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE -include
>>> config-host.h -DBITS_PER_LONG=64 -DFIO_VERSION='"fio-2.1.13-26-gb220c"'
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL
>>> -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c lex.yy.c
>>> exp/expression-parser.l:23:19: error: y.tab.h: No such file or directory
>>> exp/expression-parser.l: In function Œyylex¹:
>>> exp/expression-parser.l:51: error: Œyylval¹ undeclared (first use in
>>>this
>>> function)
>>> exp/expression-parser.l:51: error: (Each undeclared identifier is
>>>reported
>>> only once
>>> exp/expression-parser.l:51: error: for each function it appears in.)
>>> exp/expression-parser.l:52: error: ŒSUFFIX¹ undeclared (first use in
>>>this
>>> function)
>>> exp/expression-parser.l:122: error: ŒNUMBER¹ undeclared (first use in
>>>this
>>> function)
>>> make: *** [lex.yy.o] Error 1
>>>
>>>
>>
>>Ok, hmm.
>>
>>Try making the following change to the Makefile:
>>
>>--- a/Makefile
>>+++ b/Makefile
>>@@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
>>        $(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
>>
>> y.tab.c: exp/expression-parser.y
>>-       $(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
>>+       $(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
>>
>> y.tab.h: y.tab.c
>>
>>(I cut and pasted the above, so it is probably not a well formatted
>>patch anymore).
>>
>>That is, add " -b y " into the line for yacc.  bison by default
>>doesn't produce y.tab.c y.tab.h, it produces from xxx.y -> xxx.tab.c
>>and xxx.tab.h, which makes more sense than what yacc does, but it's
>>not what the makefile is expecting.  The "-b y" tells bison to use "y"
>>as the output file prefix, just as yacc normally does.
>>
>>then "make clean" and "make YACC=bison" and see if that works.
>>
>>-- steve
>
>
> Steve,
>
> This is neto from Brazil
>
> How are you?
>
> Thank you VERY MUCH. It worked.
>
>   LINK fio
>     CC t/stest.o
>     CC t/log.o
>     CC t/debug.o
>   LINK t/stest
>     CC t/ieee754.o
>   LINK t/ieee754
>     CC t/genzipf.o
>   LINK t/genzipf
>     CC t/axmap.o
>   LINK t/axmap
>     CC t/lfsr-test.o
>   LINK t/lfsr-test
>     CC t/btrace2fio.o
>   LINK t/btrace2fio
>     CC t/dedupe.o
>   LINK t/dedupe
>
>
>
> All the best,
>
> neto
>
