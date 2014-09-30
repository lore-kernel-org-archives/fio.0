Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
	<5429B424.7080903@kernel.dk>
	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
	<5429C839.7090408@kernel.dk>
	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
Date: Tue, 30 Sep 2014 03:23:47 +0100
Message-ID: <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
Subject: Re: Limit LBA Range
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jon Tango <cheerios123@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 29 September 2014 22:10, Jon Tango <cheerios123@outlook.com> wrote:
>
> I include both of those commands, in addition to size=745g, and it seems to
> be conducting the workload over the entire LBA range. Is this the correct
> combination of the three parameters? Here is the test script:
>
>  [global]
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
> #########################################################
>
> [4K Precon]
> stonewall
> runtime=15000
> iodepth=32
> bs=4k
> rw=randwrite

Bear in mind that because you are asking for eight stonewalled jobs
this fio run will take 8 * 15000 seconds (around 33 hours) to finish
because after the first job has run for four hours the second job will
start etc.

-- 
Sitsofe | http://sucs.org/~sits/

