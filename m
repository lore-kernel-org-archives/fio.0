Return-Path: <ajoy@fastorsystems.com>
Return-Path: <ajoy@fastorsystems.com>
Date: Fri, 02 May 2014 08:47:35 -0700
Subject: Re: Recent changes (master)
From: Ajoy Aswadhati <ajoy@fastorsystems.com>
Message-ID: <CF890B7F.5B0BE%ajoy@fastorsystems.com>
In-Reply-To: <5363AE9C.7040505@kernel.dk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I am referring to only one 1GB file and want the data distributed randomly
across the 1TB target disk.
1 TB disk can be raw without a file system. What is the algorithm for
distributing this 1GB over the 1TB space?

Thanks
-ajoy

On 5/2/14 7:41 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 05/02/2014 08:36 AM, Ajoy Aswadhati wrote:
>> Hi Jens,
>> With the new io_limit option, is it possible to do the following:
>> Have the disk size be 1TB and use 1GB file size and make it use the 1TB
>> space randomly and not confine to the first 1GB.
>> I.e. Use the entire disk in a sparse and random order repeatedly for n
>> iterations. If yes can you provide a config.
>
>On the raw disk, you can do that with
>
>size=1tb
>io_limiut=1gb
>
>and add loops=x for however many iterations you want.
>
>If you mean from a file system, then you would need a 1TB file to
>achieve (roughly) the same thing. Not sure what you mean here, but are
>you referring to multiple 1GB files?
>
>-- 
>Jens Axboe
>



