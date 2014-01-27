Return-Path: <wallencelu@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20140127192215.GF2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
	<20140127192215.GF2782@kernel.dk>
Date: Mon, 27 Jan 2014 12:42:28 -0800
Message-ID: <CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
Subject: Re: A bug in combining fsrange and verify
From: Wallence Lu <wallencelu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Recreated with fio 2.0.11-35-g8428, the version was checked out from
https://github.com/axboe/fio.

I read a little bit of the source code, it seems to me the randwrite
option gets the LBA without specifying the IO size. With that said,
for a bsrange option, it is likely one random IO can step onto another
IO if they happen to be adjacent. For example, request A has LBA
of 1024 and size 8K, request B has LBA 1016 and size 16K. Without
checking the request size, request B can overwrite content of request
A.

Is that the right interpretation? Do I miss something? Thanks.

On Mon, Jan 27, 2014 at 11:22 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Jan 24 2014, Wallence Lu wrote:
>> Hi,
>>
>> I've hit a bug in using the combination of bsrange and verify.
>> Basically I want to do a random write test with a variable block size,
>> and then verify the content after the write. But for some reason, the
>> verify phase fails consistently.
>>
>> Linux distribution:
>> Ubuntu 12.04.2 LTS, Linux version 3.5.0-23-generic
>> $ fio --version
>> fio 1.59
>>
>> Conf file:
>> [global]
>> thread=1
>> ioengine=libaio
>> buffered=0
>> direct=1
>> runtime=5400
>> write_iolog=./w_iolog2
>>
>> [rand-write]
>> bsrange=512-32K
>> filename=disk.raw
>> iodepth=1280
>> size=256M
>> verify=meta
>> verify_pattern=0x33
>> rw=randwrite
>>
>> The output complains as the following:
>> Jobs: 1 (f=1): [V] [50.5% done] [0K/0K/0K /s] [0 /0 /0  iops] [eta
>> 01m:40s]     verify: bad magic header 0, wanted acca at file
>> /home/maohua/test-clone/softwareCache/qemu/iscsi_sdd2/disk.raw offset
>> 1179648, length 0
>> fio: pid=6118, err=84/file:io_u.c:1477, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
>>
>> rand-write: (groupid=0, jobs=1): err=84 (file:io_u.c:1477,
>> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
>> wide character): pid=6118: Fri Jan 24 17:40:16 201
>
> Fio 1.59 is ancient. Please try and reproduce on a recent version and
> report back what happens.
>
> --
> Jens Axboe
>

