Return-Path: <greg.sullivan@sullivang.net>
MIME-Version: 1.0
In-Reply-To: <50322299.1020103@kernel.dk>
References: <CAHaS=Qwn2zxQWkvy=ZPQstwwOuX1P__=Gp1jw9WW3Jy6jpDWxA@mail.gmail.com>
	<50321835.8060608@kernel.dk>
	<CAHaS=QzRx=KGHy4V5MDMEo8DDQHQHdh=i019vM9iRtadNGoarA@mail.gmail.com>
	<50322299.1020103@kernel.dk>
Date: Tue, 21 Aug 2012 21:32:33 +1000
Message-ID: <CAHaS=QyoixnjjZAJtwPLxRCD1JF+ZTDa4oU8Ljb=xKXsSCp2Uw@mail.gmail.com>
Subject: Re: Direct io on Ubuntu i386?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 20 August 2012 21:42, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/20/2012 01:37 PM, Greg Sullivan wrote:
>> On 20 August 2012 20:57, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 08/20/2012 02:57 AM, Greg Sullivan wrote:
>>>> I'm trying to do direct io (to avoid the file system cache) on Ubuntu
>>>> i386. I've tried direct=1, and tried the io engines sync and libaio -
>>>> it always seems to use the cache.
>>>>
>>>> Is there a way to bypass the file system cache on Ubuntu? I've got a
>>>> vanilla install using the automated Ubuntu installer for Windows i386
>>>> 32-bit (dual boot).
>>>
>>> direct=1 will certainly bypass the cache on Linux, regardless of
>>> version. What makes you suspect otherwise?
>>>
>>> --
>>> Jens Axboe
>>
>>
>> Running a simple job that reads a 50MB file, the first time I run it,
>> the aggregate throughput reported by fio is ~20MB/s For subsequent
>> runs, the transfer rate is significantly higher  - ~150MB/s. When I
>> then clear the file system cache, and then run it again, the transfer
>> rate drops back to 20MB/s.
>>
>> The INI:
>> [read]
>> bs=4k
>> direct=1
>> sync=1
>> size=50M
>> rw=read
>>
>> Just in case it's relevant, I'm running this on a very old laptop - a
>> Compaq NW8000. (and 150MB/s is impossibly fast for it to be reading
>> that from disk)
>
> Please run fio with strace -o somefile -f fio <ini.file> and bzip2+send
> the 'somefile' file.
>
> --
> Jens Axboe
>

Jens kindly helped me a bit offline. My problem was due to the fact
that I am booting off a FUSE virtual disk, and direct io won't work. I
have now tested direct io using a natively formatted USB FLASH drive,
and it's working fine. ;^)

Greg.

