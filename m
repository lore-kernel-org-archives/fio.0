Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk>
In-Reply-To: <5429B424.7080903@kernel.dk>
Subject: RE: Limit LBA Range
Date: Mon, 29 Sep 2014 15:46:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks for the reply. the capacity of the SSD is 850GB, but I am trying to
run the workload continuously between 0 and 745GB of the capacity. I would
like to workload to be time based so that it continues to run, even if more
than 745 GB of data is written, but still within that same range. Is there a
method of continuing to run the workload from 0 to 745GB, even if more than
745GB is written? 

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
Of Jens Axboe
Sent: Monday, September 29, 2014 2:34 PM
To: Jon Tango; fio@vger.kernel.org
Subject: Re: Limit LBA Range

On 2014-09-28 21:28, Jon Tango wrote:
> I am using windows server 2012R2 and am attempting to limit the LBA 
> range of the test. It doesn't seem to be working, I am using this, is it
correct?
>
> [global]
> name=4ktest
> filename=\\.\physicaldrive1
> direct=1
> numjobs=8
> norandommap
> ba=4k
> time_based
> size=745g
> log_avg_msec=100000
> group_reporting=1
>
> #########################################################
>
> [4K Precon]
> stonewall
> runtime=15000
> iodepth=32
> bs=4k
> rw=randwrite

The above will be doing IO between 0 and 745G, and do 745G worth of IO (in
other words, the full range given). Not sure how to answer your question
more precisely, as you don't mention what LBAs you want your test to be
limited to.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body
of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

