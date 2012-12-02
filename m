Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33545
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab2LBTUV (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 2 Dec 2012 14:20:21 -0500
Message-ID: <50BBA9F2.4050607@kernel.dk>
Date: Sun, 02 Dec 2012 20:20:18 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Getting 'stat64 already defined' type errors when trying to "make"
 fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308)
References: <50B8FFFC.7000602@benslade.com> <50B90653.2030808@kernel.dk>
In-Reply-To: <50B90653.2030808@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: buysell08 <buysell08@benslade.com>
Cc: fio@vger.kernel.org

On 2012-11-30 20:17, Jens Axboe wrote:
> On 2012-11-30 19:50, buysell08 wrote:
>> I'm getting 'stat64 already defined' type errors when trying to "make" fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308).
>>
>> I couldn't find anything in the www.spinics.net/lists/fio mailing list archives about it.  Has anybody else seen a problem like this?
>>
>>> make
>> DEP .depend
>> CC gettime.o
>> : Assembler messages:
>> :354: Error: symbol `fstatat64' is already defined
>> :388: Error: symbol `fstat64' is already defined
>> :418: Error: symbol `lstat64' is already defined
>> :448: Error: symbol `stat64' is already defined
>> :1704: Error: symbol `pread64' is already defined
>> make: *** [gettime.o] Error 1
> 
> Never seen that before. From what I can tell on similar problems on
> google, it's an issue with your glibc causing double definitions when
> programs are compiled with _FILE_OFFSET_BITS= such as fio is.
> 
> If you can give me access to your system, I can probably add a
> work-around for you.

Wait, you write centos 6.3, but it's running kernel 2.6.18. That can't
be right, that'd be series 5. Did you mean centos 5.3?

-- 
Jens Axboe

