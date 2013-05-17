Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130517104305.GW697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com> <20130517074751.GS697@kernel.dk> <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com> <20130517102244.GV697@kernel.dk> <20130517104305.GW697@kernel.dk>
MIME-Version: 1.0
Subject: Re: latency measurements when adding thinktime
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF939737E8.20889948-ON80257B6E.003B42BD-80257B6E.003B6E91@uk.ibm.com>
Date: Fri, 17 May 2013 11:48:59 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Many thanks !!!!!!!!!!!

looking at the history of changes I had spotted that there was a fix for 
latency reports using rate
and that is what made me move from 2.0.13 to 2.1

--------------------------------------------------
regards,
Edoardo Comar
WebSphere Application Service Platform for Networks (ASPN)
ecomar@uk.ibm.com
+44 (0)1962 81 5576 
IBM UK Ltd, Hursley Park, SO21 2JN




From:   Jens Axboe <axboe@kernel.dk>
To:     Edoardo Comar/UK/IBM@IBMGB, 
Cc:     fio@vger.kernel.org
Date:   17/05/2013 11:43
Subject:        Re: latency measurements when adding thinktime



On Fri, May 17 2013, Jens Axboe wrote:
> On Fri, May 17 2013, Edoardo Comar wrote:
> > Hi Jens,
> > 
> > thanks a lot, I tried your suggestion straight away: 
> > The cpu line in the output shows that the job has not been idle at 
all.
> > but even with thinktime_spin, the latency stays high at at 150ms.
> > 
> > Note also that if I increase thinktime & thinktime_spin by another 
10000 
> > us
> > to a total of 20000, then the reported latency goes up another 150ms 
to a 
> > total of 300ms.
> > Could this be a bug?
> 
> It certainly could. Let me take a look here and see if I can reproduce
> it.

And it was... Basically the same issue that was fixed for rate limiting.
When going to sleep or spinning, ensure that we have all IOs flushed.
Otherwise we could unfairly attribute the sleep towards the completion
latencies.

Fixed here:

http://git.kernel.dk/?p=fio.git;a=commit;h=002e7183cb86d6100efef690b6fa90bf0988b084


or just git pull and you'll get the fix.

-- 
Jens Axboe



Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


