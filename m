Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:45844 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYKSNVe (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2008 08:21:34 -0500
Date: Wed, 19 Nov 2008 14:19:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Help required to understand fio output
Message-ID: <20081119131945.GD26308@kernel.dk>
References: <4924115E.6040701@seanodes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4924115E.6040701@seanodes.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Wed, Nov 19 2008, Erwan Velu wrote:
> Here come a typical output I have using fio. I added some line numbers 
> as an helper.
> 
> 01: /dev/mydisk: (groupid=1, jobs=1): err= 0: pid=7433
> 02:  write: io=79,112MiB, bw=72,774KiB/s, iops=740, runt=1139888msec
> 03:    slat (usec): min=9, max=572, avg=21.22, stdev= 7.03
> 04:    clat (msec): min=2, max=668, avg=86.43, stdev=24.47
> 05:    bw (KiB/s) : min=    0, max=80749, per=100.06%, avg=72815.92, 
> stdev=2318.78
> 06:  cpu          : usr=0.93%, sys=1.35%, ctx=722885, majf=0, minf=10031
> 07:  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
> >=64=100.0%
> 08:     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
> 09:     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, 
> >=64=0.0%
> 10:     issued r/w: total=0/843855, short=0/0
> 11:
> 12:     lat (msec): 4=0.01%, 10=0.03%, 20=0.38%, 50=6.53%, 100=64.24%
> 13:     lat (msec): 250=28.79%, 500=0.01%, 750=0.01%
> 
> 
> I have some questions about the output.
> 
> About Latencies:
> Line 4, clat is reported to be at 86ms as average but line 12 is is 
> written that 100=64 250=29
> What's the meaning of "100=" ? Does it means "there were 64% of IOs 
> completed between 100 & 249 ms ?"
> If yes,  that's pretty surprising that while having 95% of my IOs that 
> are completed in more than 100ms, the average is reported as 86.
> If "100=" means "IO between 50 and 99ms", thus output become pretty 
> confusing.

The output could do with a bit of prettying up... It's explained in the
documentation, though, The 100=64.24% field means that 64.24% of the ios
completed within 50 and 99ms, as you indicate.

> About IO depths:
> In my config file I had set a depth to 64. Line 07 reports that 100% of 
> my IOs where >=64... cool but is it also said that 0.6% were spent on <=64K
> Sounds to be a rounding effect but does this really means that some IOs 
> where sent with a short depth ?

It's rounding, 0.1% indicates that it's over 0%. Since we build up the
queue in the beginning, this is usually the case.

> And then, how should I understan lines 8 & 9 that reports that 100% of 
> IOs were completed with a depth=4... What happened ?

Same deal, 4 means 1-4 completions per io_getevents() call for your test
case. So any attempt to retrieve completed IO from the system resulted
in a return of 1-4 ios.

> Hope this questions aren't too stupid ;o)

Not at all, I'd appreciate constructive criticism on how to improve the
output.

-- 
Jens Axboe

