Return-Path: <jeremic@informatik.uni-rostock.de>
Message-ID: <535E8CB3.8070803@informatik.uni-rostock.de>
Date: Mon, 28 Apr 2014 19:15:31 +0200
From: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>
MIME-Version: 1.0
Subject: Re: Writing an amount of data less than capacity at random to offsets
 from whole address range
References: <534BD74E.1080205@informatik.uni-rostock.de> <534C40D7.3060406@kernel.dk>
In-Reply-To: <534C40D7.3060406@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hello,

first of all, thank you very much. It works very well. I would be 
grateful if you could add this option to the next fio release.

Thanks,
Nikolaus


Am 14.04.2014 22:11, schrieb Jens Axboe:
> On 04/14/2014 06:40 AM, Nikolaus Jeremic wrote:
>> Hello,
>>
>> how can I nudge fio to write a certain amount of data (less than
>> capacity of block device) to randomly generated offsets covering the
>> whole address space of a block device (e.g. MD RAID device)?
>>
>> Using the size parameter yields offsets from 0 to size (thus, not
>> covering the whole address range). Using a time based job leads to the
>> desired result, but I would like two write a defined amount of data. I
>> have already tried this with fio 2.0.14, 2.1.6.1, 2.1.17, and 2.1.18
>> without success. I am using Gentoo Linux with kernel 3.13.6 and libaio
>> 0.3.109. The job description looks as follows:
>
> Fio doesn't currently support that. Can you try the attached? It adds an
> option to separately define an io limit, io_limit. If io_limit is not
> set, size= behaves as it did before: if you don't give a size, size is
> defined by the files added. With this patch, if you do
>
> filename=/dev/md9
> size=40g
>
> fio would read 40g between 0..40G
>
> If you do:
>
> filename=/dev/md9
>
> fio would access the entire device.
>
> If you do:
>
> filename=/dev/md9
> io_limit=10g
>
> fio would access the entire device, quit when 10G of IO was done. Etc.
>


-- 
Dipl.-Inf. Nikolaus Jeremic          nikolaus.jeremic@uni-rostock.de
Universitaet Rostock                 Tel:  (+49) 381 / 498 - 7635
Albert-Einstein-Str. 22	             Fax:  (+49) 381 / 498 - 7482
18059 Rostock, Germany               wwwava.informatik.uni-rostock.de

