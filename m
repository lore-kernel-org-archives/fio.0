Return-Path: <axboe@kernel.dk>
Message-ID: <542B52B3.5060908@kernel.dk>
Date: Tue, 30 Sep 2014 19:02:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 2014-09-30 17:49, Elliott, Robert (Server Storage) wrote:
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
>> Of Sitsofe Wheeler
> ...
>> filename=\\.\physicaldrive1
>> ioengine=windowsaio
>> direct=1
> ...
>> size=86%
>> bs=4k
> ...
>
> I noticed that, in linux, if you select
> 	filename=/dev/sd<not there>
> 	size=<something>
>
> (e.g., if you run fio after a device has failed), it  creates a
> normal file of the specified size (which could be quite large
> if using a script such as above).
>
> If you use direct=1, the file is created, followed by this error:
> fio: pid=8914, err=22/file:filesetup.c:611, func=open(/dev/sdad), error=Invalid argument
> fio: looks like your file system does not support direct=1/buffered=0
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT

This is because /dev is usually devtmpfs these days, and that fs does 
not support O_DIRECT.

> If you don't use size=, no file is created and this error
> occurs:
> fio: pid=0, err=22/file:filesetup.c:820, func=total_file_size, error=Invalid argument
> drive_ag: you need to specify size=
>
> If you recreate the device, udevd blows away any such file with
> the block device node file, so it's not a good place to put
> normal files, even if that is intentional.
>
> In Windows, all "\\.\" paths are assumed to mean block devices,
> so fio doesn't inadvertently try to create a normal file in
> such a location.
>
> Should fio treat "/dev" paths in linux the same way?

No, I don't think so. It's a directory like anything else. Who knows 
what will happen in the future, with all the core OS changes in Linux. 
/dev could be a symlink, or special files could be in a different 
location completely.  What about FreeBSD, should we do the same there? 
Or Solaris?

I'd much rather keep fio ignorant of any "special" directories, even if 
it means that sometimes you do potentially run into issues like the 
above, where you specify a block device that does not exist.

-- 
Jens Axboe


