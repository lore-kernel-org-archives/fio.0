Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760848Ab0GSRlY (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 19 Jul 2010 13:41:24 -0400
Date: Mon, 19 Jul 2010 13:40:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: An issue with fio performance on an SSD
Message-ID: <20100719174049.GA32503@redhat.com>
References: <4C44680B.4050707@scalableinformatics.com>
 <4C448A72.4070601@scalableinformatics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C448A72.4070601@scalableinformatics.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Joe Landman <landman@scalableinformatics.com>
Cc: fio@vger.kernel.org

On Mon, Jul 19, 2010 at 01:25:06PM -0400, Joe Landman wrote:
> Joe Landman wrote:
> >Greetings
> >
> >  We are playing with some SSDs, and as usual, we want to use fio
> >for our testing regime.  So we set up a simple streaming write:
> 
> Ok, I figured it out.
> 
> Add zero_buffers=1 to the job specification.  Then we get this:
> 
> Run status group 0 (all jobs):
>   WRITE: io=32,706MB, aggrb=535MB/s, minb=548MB/s, maxb=548MB/s,
> mint=61133msec, maxt=61133msec

Interesting. Why not initializing bufferes with zero leads to poor
performance?

Vivek

> 
> 
> 
> -- 
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics Inc.
> email: landman@scalableinformatics.com
> web  : http://scalableinformatics.com
>        http://scalableinformatics.com/jackrabbit
> phone: +1 734 786 8423 x121
> fax  : +1 866 888 3112
> cell : +1 734 612 4615
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
