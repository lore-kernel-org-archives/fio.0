Return-Path: <fio-owner@vger.kernel.org>
Received: from adsl-99-17-64-89.dsl.sfldmi.sbcglobal.net ([99.17.64.89]:51754
	"EHLO crunch.scalableinformatics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932452Ab0GSRpE (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 19 Jul 2010 13:45:04 -0400
Message-ID: <4C448F17.9050309@scalableinformatics.com>
Date: Mon, 19 Jul 2010 13:44:55 -0400
From: Joe Landman <landman@scalableinformatics.com>
Reply-To: landman@scalableinformatics.com
MIME-Version: 1.0
Subject: Re: An issue with fio performance on an SSD
References: <4C44680B.4050707@scalableinformatics.com> <4C448A72.4070601@scalableinformatics.com> <20100719174049.GA32503@redhat.com>
In-Reply-To: <20100719174049.GA32503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fio@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 19, 2010 at 01:25:06PM -0400, Joe Landman wrote:
>> Joe Landman wrote:
>>> Greetings
>>>
>>>  We are playing with some SSDs, and as usual, we want to use fio
>>> for our testing regime.  So we set up a simple streaming write:
>> Ok, I figured it out.
>>
>> Add zero_buffers=1 to the job specification.  Then we get this:
>>
>> Run status group 0 (all jobs):
>>   WRITE: io=32,706MB, aggrb=535MB/s, minb=548MB/s, maxb=548MB/s,
>> mint=61133msec, maxt=61133msec
> 
> Interesting. Why not initializing bufferes with zero leads to poor
> performance?

I think this is an SSD controller compression issue.  That is, the 
Sandforce controllers want to do compression of some sort on the data. 
So if we start out with truly random data, which doesn't get good 
compression ratios, we get not so good performance.

Joe

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
