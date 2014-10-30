Return-Path: <robin@coraid.com>
From: "Robin P. Blanchard" <robin@coraid.com>
Subject: Re: yacc/flex/bison (?) regression since 2.1.13 (solaris 11 x86_64)
 - ../exp/*
Date: Thu, 30 Oct 2014 16:52:41 +0000
Message-ID: <1E01DB49-F96B-42DD-9DAA-E95B405802CB@coraid.com>
References: <9BFC2684-B327-440D-8051-5528AEDFA530@coraid.com>
 <545263A6.1010705@kernel.dk>
In-Reply-To: <545263A6.1010705@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5FFDD4C0BFBA704D9E04D4C53748E9E0@fwd6.exghost.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, stephen Cameron <stephenmcameron@gmail.com>
List-ID: <fio@vger.kernel.org>


On Oct 30, 2014, at 12:13, Jens Axboe <axboe@kernel.dk> wrote:

> On 10/30/2014 09:40 AM, Robin P. Blanchard wrote:
>> Hi there.
>>=20
>> The introduction of ../exp/* seems to have broken compilation on Solaris=
 11. Please let me know how I can help work through this.
>>=20
>> lex/yacc for arithmetic       yes
>>    CC gettime.o
>>    CC ioengines.o
>>    CC init.o
>>    CC stat.o
>>    CC log.o
>>    CC time.o
>>    CC filesetup.o
>>    CC eta.o
>>    CC verify.o
>>    CC memory.o
>>    CC io_u.o
>>   LEX lex.yy.c
>> "exp/expression-parser.l":line 166: Warning: Non-portable Character Clas=
s
>>  YACC y.tab.c
>>    CC lex.yy.o
>> exp/expression-parser.l:43:37: error: conflicting types for =91yyunput=
=92
>> lex.yy.c:31:7: note: previous declaration of =91yyunput=92 was here
>> exp/expression-parser.l:44:46: error: macro "input" passed 1 arguments, =
but takes just 0
>> exp/expression-parser.l: In function =91yylex=92:
>> exp/expression-parser.l:61:1: warning: label =91yyfussy=92 defined but n=
ot used
>> exp/expression-parser.l:54:22: warning: unused variable =91yyprevious=92
>> exp/expression-parser.l: At top level:
>> exp/expression-parser.l:297:1: warning: missing braces around initialize=
r
>> exp/expression-parser.l:297:1: warning: (near initialization for =91yycr=
ank[0]=92)
>> exp/expression-parser.l:376:1: warning: missing braces around initialize=
r
>> exp/expression-parser.l:376:1: warning: (near initialization for =91yysv=
ec[0]=92)
>> exp/expression-parser.l:714:6: error: conflicting types for =91yyunput=
=92
>> exp/expression-parser.l:43:37: note: previous declaration of =91yyunput=
=92 was here
>> make: *** [lex.yy.o] Error 1
>=20
> Try -git again and see if that works, I just disabled it (for now) on
> Solaris.


That works...

# fio --version
fio-2.1.13-111-g0960




>=20
> --=20
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Robin P. Blanchard
Technical Solutions Engineer
Global Field Services and Support
Coraid: storage that fits your business
www.coraid.com


