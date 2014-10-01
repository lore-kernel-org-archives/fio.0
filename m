Return-Path: <axboe@kernel.dk>
Message-ID: <542B5632.8030404@kernel.dk>
Date: Tue, 30 Sep 2014 19:17:38 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 2014-09-30 19:12, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
> ...
>> I'd much rather keep fio ignorant of any "special" directories, even if
>> it means that sometimes you do potentially run into issues like the
>> above, where you specify a block device that does not exist.
>
> How about an option in the script:
> direct=2   file must exist and be a block device, otherwise skip it

Might be a bit nasty to overload direct= like that. But I'd be open to 
adding an option that says must_be_bdev or something, which can be a 
bool as well.

> If the size is too big, this is the error:
>
> drive_r: Laying out IO file(s) (1 file(s) / 1572864000MB)
> fio: posix_fallocate fails: No space left on device
>
> fio: ENOSPC on laying out file, stopping
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT
> fio: pid=8991, err=22/file:filesetup.c:611, func=open(/dev/sdnothere), error=Invalid argument
> fio: pid=8990, err=22/file:filesetup.c:611, func=open(/dev/sdnothere), error=Invalid argument
>
> and it leaves a "file" that looks like:
>
> $ ls -alt /dev/sd*
> -rw-r--r-- 1 root root 1649267441664000 Sep 30 20:10 /dev/sdnothere

Yeah I know, I've had that happen myself 1-2 times.

-- 
Jens Axboe


