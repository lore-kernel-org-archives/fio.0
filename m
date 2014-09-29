Return-Path: <axboe@kernel.dk>
Message-ID: <5429B424.7080903@kernel.dk>
Date: Mon, 29 Sep 2014 13:33:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
In-Reply-To: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jon Tango <cheerios123@outlook.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-28 21:28, Jon Tango wrote:
> I am using windows server 2012R2 and am attempting to limit the LBA range of
> the test. It doesn't seem to be working, I am using this, is it correct?
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

The above will be doing IO between 0 and 745G, and do 745G worth of IO 
(in other words, the full range given). Not sure how to answer your 
question more precisely, as you don't mention what LBAs you want your 
test to be limited to.

-- 
Jens Axboe


