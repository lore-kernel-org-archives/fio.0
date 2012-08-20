Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2HTLnD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Aug 2012 07:43:03 -0400
Message-ID: <50322299.1020103@kernel.dk>
Date: Mon, 20 Aug 2012 13:42:17 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Direct io on Ubuntu i386?
References: <CAHaS=Qwn2zxQWkvy=ZPQstwwOuX1P__=Gp1jw9WW3Jy6jpDWxA@mail.gmail.com> <50321835.8060608@kernel.dk> <CAHaS=QzRx=KGHy4V5MDMEo8DDQHQHdh=i019vM9iRtadNGoarA@mail.gmail.com>
In-Reply-To: <CAHaS=QzRx=KGHy4V5MDMEo8DDQHQHdh=i019vM9iRtadNGoarA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 08/20/2012 01:37 PM, Greg Sullivan wrote:
> On 20 August 2012 20:57, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 08/20/2012 02:57 AM, Greg Sullivan wrote:
>>> I'm trying to do direct io (to avoid the file system cache) on Ubuntu
>>> i386. I've tried direct=1, and tried the io engines sync and libaio -
>>> it always seems to use the cache.
>>>
>>> Is there a way to bypass the file system cache on Ubuntu? I've got a
>>> vanilla install using the automated Ubuntu installer for Windows i386
>>> 32-bit (dual boot).
>>
>> direct=1 will certainly bypass the cache on Linux, regardless of
>> version. What makes you suspect otherwise?
>>
>> --
>> Jens Axboe
> 
> 
> Running a simple job that reads a 50MB file, the first time I run it,
> the aggregate throughput reported by fio is ~20MB/s For subsequent
> runs, the transfer rate is significantly higher  - ~150MB/s. When I
> then clear the file system cache, and then run it again, the transfer
> rate drops back to 20MB/s.
> 
> The INI:
> [read]
> bs=4k
> direct=1
> sync=1
> size=50M
> rw=read
> 
> Just in case it's relevant, I'm running this on a very old laptop - a
> Compaq NW8000. (and 150MB/s is impossibly fast for it to be reading
> that from disk)

Please run fio with strace -o somefile -f fio <ini.file> and bzip2+send
the 'somefile' file.

-- 
Jens Axboe

