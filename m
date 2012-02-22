Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37205 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab2BVCc1 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Feb 2012 21:32:27 -0500
Received: by obcva7 with SMTP id va7so9362494obc.19
        for <fio@vger.kernel.org>; Tue, 21 Feb 2012 18:32:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F421BC7.40802@kernel.dk>
References: <1329442053-28519-1-git-send-email-dehrenberg@google.com>
	<4F420F34.9070902@kernel.dk>
	<4F421BC7.40802@kernel.dk>
Date: Tue, 21 Feb 2012 18:32:26 -0800
Message-ID: <CAAK6Zt2WejN9a+iWtVf8yrD6QVA0Vie1r9R7s3=kXycJ7-_voA@mail.gmail.com>
Subject: Re: [RFC] fio: Token-based flow control
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com

Thanks for the improvement there, Jens. With the bug fix patch I just
mailed, it works for me.

Dan

On Mon, Feb 20, 2012 at 2:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 02/20/2012 10:15 AM, Jens Axboe wrote:
>> On 02/17/2012 02:27 AM, Dan Ehrenberg wrote:
>>> This patch allows two fio jobs to be kept to a certain
>>> proportion of each other using token-based flow control.
>>> There are three new parameters: flow, flow_watermark, and
>>> flow_sleep, documented in the fio options. An example of an fio
>>> job using these parameters is below:
>>>
>>> [global]
>>> norandommap
>>> thread
>>> time_based
>>> runtime=3D30
>>> direct=3D1
>>> ioengine=3Dlibaio
>>> iodepth=3D256
>>> size=3D100g
>>> bs=3D8k
>>> filename=3D/tmp/testfile
>>> flow_watermark=3D100
>>> flow_sleep=3D1000
>>>
>>> [job2]
>>> numjobs=3D1
>>> rw=3Dwrite
>>> flow=3D-8
>>>
>>> [job1]
>>> numjobs=3D1
>>> rw=3Drandread
>>> flow=3D1
>>>
>>> The motivating application of this patch was to allow random reads
>>> and sequential writes at a particular given proportion.
>>>
>>> This initial version is only correct when run with 'thread', as shared
>>> state is represented with a global variable. It also only allows two
>>> jobs to be synchronized properly. A future version might do more, but
>>> no more functionality was needed for my application.
>>>
>>> Tested: Ran a few fio jobs with this flow control, observing
>>> the proportion of IOPS to match what was intended by the job file.
>>> Varied the flow_watermark and flow_sleep parameters and observed
>>> the effect on throughput.
>>
>> I like this, it's definitely a useful feature. Any chance I could talk
>> you into finishing the patch? You could have a flow_id=3D option, and th=
en
>> move the flow storage to being smalloc() backed.
>
> Since I'm in such a good mood today, I did it myself. See:
>
> http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3D9e684a4976b7934f5ce011ea=
281dfef3352e5738
>
> It's your patch, just with a bit of glue to support arbitrary flows. If
> you can confirm it still works for you, I'd appreciateit :-)
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
