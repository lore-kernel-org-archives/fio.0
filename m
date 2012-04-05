Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2DEWBO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 18:01:14 -0400
Message-ID: <4F7E1621.3070009@kernel.dk>
Date: Thu, 05 Apr 2012 16:01:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Usage of group reporting
References: <CBA33231.13A4%lucian@fb.com>
In-Reply-To: <CBA33231.13A4%lucian@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lucian Grijincu <lucian@fb.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-04-05 12:29, Lucian Grijincu wrote:
> 
> On 4/5/12 7:42 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>> Most people don't use the group reporting
> 
> 
> Why do you say that?
> 
> For example I'm trying to find those parameters (direct-io, fadvise,
> number of threads, libaio/mmap/sync, etc.) that give an overall "best
> performance" (whatever that means) on a simulated workload.
> 
> I'm using group reporting, because I want numbers for the entire system,
> not for an individual thread.
> 
> Am I using "fio" wrong or is "fio" mostly used for other kinds of
> benchmarking?

I think there's a confusion of termininology here, it's my fault. So
when I said group reporting, I meant the group status reporting. The
part that shows up at the end of the reporting:

Run status group 0 (all jobs):
   READ: io=2369KB, aggrb=1024KB/s, minb=1024KB/s, maxb=1024KB/s, mint=2313msec, maxt=2313msec

This is what you control with the new_group, forcing fio to group
multiple jobs together for reporting.

You are probably referring to group_reporting, which is used quite
extensively. That is not the one I meant :-)

-- 
Jens Axboe

