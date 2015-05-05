Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhARkXBLf3_FBbcpBJg+ayPsveKRPt00nA+Prxm618Nug@mail.gmail.com>
References: <CABtFm2Vmn_u39=pXTKKv9AsDBu=BM9gmSpUmtQpqFGm5Uy00yA@mail.gmail.com>
	<CALjAwxhARkXBLf3_FBbcpBJg+ayPsveKRPt00nA+Prxm618Nug@mail.gmail.com>
Date: Tue, 5 May 2015 08:26:53 +0800
Message-ID: <CABtFm2VTrC_nNMWimz8YvO2iAPv-+BByUAzzXJGX05QpQChPNw@mail.gmail.com>
Subject: Re: Unexpected runtime when running FIO in time based
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Sorry. That was a mistake. I thought i was writing 1g. Thanks anyway
for pointing that out.
Srinivasa R Chamarthy


On Mon, May 4, 2015 at 8:38 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> When you report these issues could you cut the fio job file down to
> the smallest possible file that still reproduces the problem (i.e.
> removing any line in the job file should make the problem disappear)?
>
> On 3 May 2015 at 13:00, Srinivasa Chamarthy <chamarthy.raju@gmail.com> wrote:
>
> <snip>
>
>> # cat test1.fio
>> [global]
>> ioengine=libaio
>> size=1m
>> blocksize=1024k,1024k
>> iodepth=8
>> iodepth_batch=4
>> iodepth_low=2
>> ;runtime=60
>> ;time_based
>> filename=testfile_test1
>> numjobs=1
>>
>> [pattern_one_seq_write]
>> buffer_pattern=0xff
>> readwrite=write
>
> So the file size is 1024KBytes, the block size is 1024KBytes and you
> would like to queue 8 x 1024KByte (i.e. 8192KBytes) blocks in parallel
> at any one time? Is that correct and your intent?
>
> One immediate issue is that you aren't likely to achieve your I/O
> depth of 8 because OS restrictions on buffered I/O (see
> https://github.com/axboe/fio/blob/fio-2.2.7/HOWTO#L785 for warning
> about libaio and buffered I/O case).
>
> --
> Sitsofe | http://sucs.org/~sits/

