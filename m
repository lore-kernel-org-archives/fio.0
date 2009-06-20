Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:39804 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZFTPdl (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 20 Jun 2009 11:33:41 -0400
Date: Sat, 20 Jun 2009 17:33:44 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Ques on FIO output (how to interpret iops)
Message-ID: <20090620153343.GN31415@kernel.dk>
References: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com> <20090620062702.GI31415@kernel.dk> <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Disposition: inline
In-Reply-To: <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Cagle <jcagle@gmail.com>
Cc: Learner Study <learner.study@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 20/06/2009, at 15.21, John Cagle <jcagle@gmail.com> wrote:

> On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe <jens.axboe@oracle.com>  
> wrote:
> On Fri, Jun 19 2009, Learner Study wrote:
> > Hi:
> >
> > How do I calculate total IOPS done by different FIO threads/jobs?
> >
> > Following is output from FIO (with two threads)...
> >
> > Each thread shows "bw" and "iops" numbers. Towards the end of  
> output log,
> > there is "aggrb" which is sum of individual "bw" of threads, but  
> "io" field
> > (3 line from the bottom of output below) doesn't seem to be sum of
> > individual thread iops....
> >
> > For example, Thread_1 has bw: 15k iops: 29366
> > Thread_2 has bw: 15k iops: 29445
> > But, the summary towards the end (third line from bottom of  
> output), says
> > "io=1,723MiB, aggrb=30,105KiB/s".
> >
> > In this aggrb is good but io doesn't match up (it should be  
> 58781) ! Can
> > someone please educate what am I missing?
>
> Can you try a newer version? If the problem is still there, the best  
> way
> to get it fixed is to send my a simple job file that reproduces the
> problem, and then I can easily fix it for you.
>
> I thought the "io=" summary at the end was the total amount of I/O  
> performed (in megabytes), not the total number of IOPS.

It is, you are correct. Seems I misread the problem.
