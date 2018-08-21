Return-Path: <axboe@kernel.dk>
Subject: Re: [Bug-Report] fio cannot handle some situation
References: <CADhrBQRs9AnEwucJi01ydagqZjuZ=CYeWKeBG+Ds0P46sb-g+Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b0ba9833-7739-e9ea-0b36-e8744734c9ed@kernel.dk>
Date: Tue, 21 Aug 2018 09:19:57 -0600
MIME-Version: 1.0
In-Reply-To: <CADhrBQRs9AnEwucJi01ydagqZjuZ=CYeWKeBG+Ds0P46sb-g+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Chao Guo <guochao@nutstore.net>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/21/18 4:21 AM, Chao Guo wrote:
> 1) A description of what you think the bug is:
> 
>   when using readwrite=randread and do_verify=1, fio always fails with
> 'Invalid or incomplete multibyte or wide character'
> 
> 
> 2) Environment (Linux distro version, kernel version). This is mostly
>    needed if it's a build bug.
> 
>    CentOS 7(fio 3.1-2)
> 
>    CentOS 7(build from github.com/axboe/fio, master)
> 
>    Ubuntu 18.04(fio 3.1-1)
> 
> 3) The output from fio --version.
> 
>    See above
> 
> 4) How to reproduce. Please include a full list of the parameters
>    passed to fio and the job file used (if any).
> 
> [global]
> ioengine=libaio
> direct=1
> group_reporting
> iodepth=128
> bs=1M
> readwrite=randread
> size=500MB
> do_verify=1
> verify=crc32c-intel
> 
> [test]
> filename=test

You're asking fio to verify a file, which assumes that the file
has already been written with verify data. That's not the case
(unless you ran another job to do that first), so the verify will
naturally fail.

Change your readwrite=randread to readwrite=randwrite, and fio
will randomly write it first, them randomly read and verify.

-- 
Jens Axboe


