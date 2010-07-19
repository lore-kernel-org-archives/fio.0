Return-Path: <fio-owner@vger.kernel.org>
Received: from adsl-99-17-64-89.dsl.sfldmi.sbcglobal.net ([99.17.64.89]:56547
	"EHLO crunch.scalableinformatics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760767Ab0GSRZP (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 19 Jul 2010 13:25:15 -0400
Message-ID: <4C448A72.4070601@scalableinformatics.com>
Date: Mon, 19 Jul 2010 13:25:06 -0400
From: Joe Landman <landman@scalableinformatics.com>
Reply-To: landman@scalableinformatics.com
MIME-Version: 1.0
Subject: Re: An issue with fio performance on an SSD
References: <4C44680B.4050707@scalableinformatics.com>
In-Reply-To: <4C44680B.4050707@scalableinformatics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: landman@scalableinformatics.com
Cc: fio@vger.kernel.org

Joe Landman wrote:
> Greetings
> 
>   We are playing with some SSDs, and as usual, we want to use fio for 
> our testing regime.  So we set up a simple streaming write:

Ok, I figured it out.

Add zero_buffers=1 to the job specification.  Then we get this:

Run status group 0 (all jobs):
   WRITE: io=32,706MB, aggrb=535MB/s, minb=548MB/s, maxb=548MB/s, 
mint=61133msec, maxt=61133msec



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
