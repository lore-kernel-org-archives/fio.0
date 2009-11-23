Return-Path: <4711@gnurz.de>
Message-ID: <53558.194.113.141.20.1258991444.squirrel@webmail.s-itc.de>
In-Reply-To: <20091123141923.GF8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
    <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk>
    <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de>
    <20091123121420.GX8742@kernel.dk>
    <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de>
    <20091123125912.GZ8742@kernel.dk>
    <44735.194.113.141.20.1258982494.squirrel@webmail.s-itc.de>
    <20091123141923.GF8742@kernel.dk>
Date: Mon, 23 Nov 2009 16:50:44 +0100 (CET)
Subject: Re: Fio on solaris
From: "Tom" <4711@gnurz.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tom <4711@gnurz.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Jens!
now it's possible to compile that, but (yes, we've a "but"), when I call:

> fio four_threads.fio
fio: engine libaio not loadable
fio: failed to load engine libaio
fio: file:ioengines.c:98, func=dlopen, error=ld.so.1: fio: fatal: libaio:
open failed: No such file or directory

I search for that libaio and found it

> ll    /usr/lib/libaio.so*
lrwxrwxrwx   1 root     root          21 Sep  4 10:28 /usr/lib/libaio.so
-> ../../lib/libaio.so.1
lrwxrwxrwx   1 root     root          21 Sep  4 10:28 /usr/lib/libaio.so.1
-> ../../lib/libaio.so.1

> ll /lib/libaio.so*
lrwxrwxrwx   1 root     root          11 Sep  4 10:34 /lib/libaio.so ->
libaio.so.1
-rwxr-xr-x   1 root     bin        46452 Feb 12  2009 /lib/libaio.so.1

but that on isn't the right one?

What kind of libaio have you installed at your SUN where ist it from? We
have looked around. For Linux we found tonns of libaio and libaio-devel,
but nothing for SUN.

Tom
> On Mon, Nov 23 2009, Tom wrote:
>> I search both on my server and found nothing, so I ask grandma google
>> and
>> I found this:
>>
>> Don't use the POSIX_MEMALIGN function on solaris.
>>
>> on
>> http://www.ruby-forum.com/topic/165346
>>
>> in a Website which is not our theme, but interessting.
>>
>> I try to find it with grep:
>>
>> # grep memalign /usr/include/stdlib.h
>> extern void *memalign(size_t, size_t);
>> extern void *memalign();
>>
>> # grep fallocate /usr/include/stdlib.h
>> # grep fallocate /usr/include/*
>
> Can you try the newest snapshot? I added weak directives for those two
> helpers.
>
> --
> Jens Axboe
>
>





