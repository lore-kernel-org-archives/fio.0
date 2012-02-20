Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2BTKKk (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Feb 2012 05:10:40 -0500
Message-ID: <4F421BC7.40802@kernel.dk>
Date: Mon, 20 Feb 2012 11:09:11 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [RFC] fio: Token-based flow control
References: <1329442053-28519-1-git-send-email-dehrenberg@google.com> <4F420F34.9070902@kernel.dk>
In-Reply-To: <4F420F34.9070902@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com

On 02/20/2012 10:15 AM, Jens Axboe wrote:
> On 02/17/2012 02:27 AM, Dan Ehrenberg wrote:
>> This patch allows two fio jobs to be kept to a certain
>> proportion of each other using token-based flow control.
>> There are three new parameters: flow, flow_watermark, and
>> flow_sleep, documented in the fio options. An example of an fio
>> job using these parameters is below:
>>
>> [global]
>> norandommap
>> thread
>> time_based
>> runtime=30
>> direct=1
>> ioengine=libaio
>> iodepth=256
>> size=100g
>> bs=8k
>> filename=/tmp/testfile
>> flow_watermark=100
>> flow_sleep=1000
>>
>> [job2]
>> numjobs=1
>> rw=write
>> flow=-8
>>
>> [job1]
>> numjobs=1
>> rw=randread
>> flow=1
>>
>> The motivating application of this patch was to allow random reads
>> and sequential writes at a particular given proportion.
>>
>> This initial version is only correct when run with 'thread', as shared
>> state is represented with a global variable. It also only allows two
>> jobs to be synchronized properly. A future version might do more, but
>> no more functionality was needed for my application.
>>
>> Tested: Ran a few fio jobs with this flow control, observing
>> the proportion of IOPS to match what was intended by the job file.
>> Varied the flow_watermark and flow_sleep parameters and observed
>> the effect on throughput.
> 
> I like this, it's definitely a useful feature. Any chance I could talk
> you into finishing the patch? You could have a flow_id= option, and then
> move the flow storage to being smalloc() backed.

Since I'm in such a good mood today, I did it myself. See:

http://git.kernel.dk/?p=fio.git;a=commit;h=9e684a4976b7934f5ce011ea281dfef3352e5738

It's your patch, just with a bit of glue to support arbitrary flows. If
you can confirm it still works for you, I'd appreciateit :-)

-- 
Jens Axboe

