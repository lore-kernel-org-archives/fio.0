Return-Path: <axboe@kernel.dk>
Message-ID: <542D9A26.6060204@kernel.dk>
Date: Thu, 02 Oct 2014 12:32:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk> <542B784F.5090405@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net> <542CA321.5090608@kernel.dk> <542CA44D.1030700@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CCAA76@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CCAA76@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 10/02/2014 12:21 PM, Elliott, Robert (Server Storage) wrote:
>>>> It might be better to continue to attempt to run the
>>>> other jobs.
>>>
>>> We should just go for the simpler create/nocreate solution, I prefer
>>> that. This is too involved, and it's hard to get all the cases right
>>> since there are a bunch of different ways that files are added. Which
>>> was why this patch only focused on filename=, since that is the one that
>>> is the most interesting. But it still isn't pretty. If we add the
>>> allow_file_create option, it's basically a two-liner change in a few
>>> places to not use O_CREAT.
>>
>> That took roughly 4 minutes... Does this work? Set allow_file_create=0
>> to disallow creating new files.
>>
> 
> Mostly.  
> 
> With no size= setting or size=xx%, the error messages it prints are 
> about the lack of size, not the fact that file creation is disallowed.
> It does proceed to run the jobs that have valid filenames.
> 
> drive_af: you need to specify size=
> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
> drive_af: you need to specify size=
> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
> ...
> drive_ag: you need to specify size=
> fio: pid=0, err=22/file:filesetup.c:822, func=total_file_size, error=Invalid argument
> Jobs: 168 (f=168): [r(168),X(24)] [0.0% done] [2449MB/0KB/0KB /s] [627K/0/0 iops] [eta 02d:11h:58m:33s]

Fio always does this, if the file does not exist and no size is given.
The reason is that it doesn't know what size to create. But we can
augment that a little bit if allow_file_create == 0, since the size
setting would not change that.

> With size=xxm (a fixed size), it prints complaints about O_DIRECT.
> It does proceed to run the jobs that have valid filenames.
> 
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT
> fio: pid=21834, err=22/file:filesetup.c:613, func=open(/dev/sdaf), error=Invalid argument
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT
> fio: pid=21846, err=22/file:filesetup.c:613, func=open(/dev/sdag), error=Invalid argument
> fio: looks like your file system does not support direct=1/buffered=0
> fio: destination does not support O_DIRECT
> ...
> fio: pid=21856, err=22/file:filesetup.c:613, func=open(/dev/sdag), error=Invalid argument
> Jobs: 168 (f=168): [r(168),X(24)] [0.0% done] [2449MB/0KB/0KB /s] [627K/0/0 iops] [eta 02d:11h:58m:50s]

OK, let me test that, will spin a new one.

-- 
Jens Axboe


