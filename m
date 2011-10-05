Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:60550
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab1JEMV4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Oct 2011 08:21:56 -0400
Message-ID: <4E8C4BE3.10601@kernel.dk>
Date: Wed, 05 Oct 2011 14:21:55 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: new developments
References: <4E8967BC.3050404@kernel.dk> <201110051415.42260.ms@teamix.de>
In-Reply-To: <201110051415.42260.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 2011-10-05 14:15, Martin Steigerwald wrote:
> Am Montag, 3. Oktober 2011 schrieben Sie:
>> Hi,
> 
> Hi Jens!
> 
>> Those of you tracking git developments may have noticed that
>> I created a client-server branch and did a bit of hacking
>> in there. It's not complete yet, but it's the start of splitting
>> fio into a frontend/backend setup, with the two communicating over
>> via simple protocol over tcp/ip. This enables you to run fio
>> servers on test machines, with the frontend being run on your
>> desktop etc.
> 
> Nice.
> 
> Can it run with a unix socket for localhost?

Yes it runs locally too, it doesn't really matter whether the server is
remote or on the same machine.

Example, one xterm:

axboe@nelson:/home/axboe/git/fio $ ./fio -S

Another:

axboe@nelson:/home/axboe/git/fio $ ./fio --client localhost null
Probe: hostname=nelson, be=0, fio ver 1.99.0
<localhost> job: (g=0): rw=randwrite, bs=4K-32K/4K-32K, ioengine=null,
iodepth=32
<localhost> Starting 1 thread
^C<localhost>  [w] [25.0% done] [0K/17096M /s] [0 /1508K iops] [eta
00m:03s]
job: (groupid=0, jobs=1): err= 0: pid=24834
  Description  : []
  write: io=139628MB, bw=18662MB/s, iops=1379.9K, runt=  7482msec
    clat (usec): min=6 , max=126 , avg=10.79, stdev= 1.85
     lat (usec): min=6 , max=127 , avg=10.86, stdev= 1.85
     bw (KB/s) : min=16609168, max=21529712, per=101.08%, avg=19316400.57, stdev=1728099.09
  cpu          : usr=99.89%, sys=0.03%, ctx=1528, majf=0, minf=3
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=100.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=100.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/10324399/0, short=0/0/0
     lat (usec): 10=1.51%, 20=4.73%, 50=0.01%, 100=0.01%, 250=0.01%

Run status group 0 (all jobs):
  WRITE: io=139628MB, aggrb=18662MB/s, minb=19110MB/s, maxb=19110MB/s,
mint=7482msec, maxt=7482msec


>> One thing that I think would be very cool is a gtk2 frontend.
>> Something that allows you to simply click and select options
>> and then run the job, with graphical representation of the
>> ETA and final output.
>>
>> If you have gtk development experience, or simply the desire
>> to start this project for fio, then please do get in touch.
>> Otherwise I'll start this myself, once I'm done with the
>> basic frontend/backend funtionality.
> 
> And/Or Qt ;)

For sure, or Qt. I think it'd be really cool for various reasons, some
people find it a lot easier to visually see all the options and drop
down menus as opposed to a CLI tool. Also great for demo purposes. Like
iometer - it's a crap tool, but the spedometer thing really works for
demo/show purposes.

-- 
Jens Axboe

