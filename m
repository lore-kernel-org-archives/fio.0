Return-Path: <buysell08@benslade.com>
Message-ID: <50BCD836.2040507@benslade.com>
Date: Mon, 3 Dec 2012 11:49:58 -0500
From: buysell08 <buysell08@benslade.com>
MIME-Version: 1.0
Subject: Re: Getting 'stat64 already defined' type errors when trying to "make"
 fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308)
References: <50B8FFFC.7000602@benslade.com> <50B90653.2030808@kernel.dk> <50BBA9F2.4050607@kernel.dk>
In-Reply-To: <50BBA9F2.4050607@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Re: you write centos 6.3, but it's running kernel 2.6.18. That can't be right

Indeed, it is not right.  I meant to say Centos 6.3, kernel version 2.6.32.   Apologies.

Re: Try adding a <sys/stat.h> include to fio.h

No joy.  Same compilation error

But.....    I found the web pages:

   http://mailman.videolan.org/pipermail/x264-devel/2011-June/008563.html

   http://lifecs.likai.org/2009/06/multiple-definition-of-extern-inline.html

which says to add the compiler flag "-fgnu89-inline" (because of an issue where old glibc libraries aren't compatible with "the c99 standard").   I added the compilation flag
(adding it just after the "-std=gnu99" option) and the compilation errors went away.

All done here.  Thanks the help.

Ben Slade
Kensington MD


Jens Axboe wrote, On 12/2/2012 2:20 PM:
> On 2012-11-30 20:17, Jens Axboe wrote:
>> On 2012-11-30 19:50, buysell08 wrote:
>>> I'm getting 'stat64 already defined' type errors when trying to "make" fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308).
>>>
>>> I couldn't find anything in the www.spinics.net/lists/fio mailing list archives about it.  Has anybody else seen a problem like this?
>>>
>>>> make
>>> DEP .depend
>>> CC gettime.o
>>> : Assembler messages:
>>> :354: Error: symbol `fstatat64' is already defined
>>> :388: Error: symbol `fstat64' is already defined
>>> :418: Error: symbol `lstat64' is already defined
>>> :448: Error: symbol `stat64' is already defined
>>> :1704: Error: symbol `pread64' is already defined
>>> make: *** [gettime.o] Error 1
>> Never seen that before. From what I can tell on similar problems on
>> google, it's an issue with your glibc causing double definitions when
>> programs are compiled with _FILE_OFFSET_BITS= such as fio is.
>>
>> If you can give me access to your system, I can probably add a
>> work-around for you.
> Wait, you write centos 6.3, but it's running kernel 2.6.18. That can't
> be right, that'd be series 5. Did you mean centos 5.3?
>


