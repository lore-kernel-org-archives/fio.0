Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:44052 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1BYH6F (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Feb 2011 02:58:05 -0500
Message-ID: <4D676108.1060700@fusionio.com>
Date: Fri, 25 Feb 2011 08:58:00 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: using blktrace, blkparse, and fio
References: <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com>
In-Reply-To: <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hsiao Su <Hsiao.Su@marklogic.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-02-24 20:13, Hsiao Su wrote:
> 
> Hi,
> 
> I'm trying to use these 3 tools to capture the IO workload of an
> application.  This application uses several different IO libraries.
> However, I'm not sure if I'm doing this right, so I've been trying to
> do this on a much smaller scale.  For this small scale test, my
> workload is simply to use the cp command to copy a large file onto the
> same filesystem, then use blktrace/blkparse/fio to replay that.
> 
> Some questions:
> 
> 1) Is using blkparse necessary?  I've actually found that you can skip
> blkparse, and simply use the output of blktrace and input it into fio.
> The result is that the replay is much much longer.  My cp command took
> only 1.5 minutes, but if I skip blkparse, the replay via fio would
> take almost an hour.
> 
> 2) Because of #1, I suspect that blkparse is a must.  So I've included
> the blkparse step.  But when I replay it via fio on the same device,
> it took about 4-5 minutes.  Does this sound about right?  Should I
> expect the fio replay to be 3-4 times longer than the original
> workload?  I was expecting that their time should be the same.

These are really the same question, so I'll answer here. You need to run
blkparse to generate a binary trace file for fio. It'll have the same
format as the origina file(s), the difference is that blkparse will
collect them into a single unified trace. It's what blkparse does for
the ascii display of events as well.

As to performance, what fio version are you using? You could try and use
replay_no_stall=1 option to see if that improves things.

> 3) I'm seeing so possible file system corruption now.  When I remove a
> file, I get an Input/Output Error.  Is this possibly due to what I had
> done in #1 and #2?  In general, when using fio, what steps should I
> take to prevent a file system corruption?

Since blktrace replay works on the device in question and not through
the file system, it will screw up the data on the device. So never use
it on anything you can't just regenerate, like test data. In general be
careful with raw device access, ideally use a dedicated drive for that
so you don't risk corrupting data you care about.

-- 
Jens Axboe

