Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44384 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab0H1Gxh (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 28 Aug 2010 02:53:37 -0400
Message-ID: <4C78B273.6000707@fusionio.com>
Date: Sat, 28 Aug 2010 08:53:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: using ioengine=sg
References: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>	<4C776359.70403@fusionio.com>	<AANLkTikN0M5eVXOAi9APqeS2Q7tiuYPacMsWiO0FnAWC@mail.gmail.com>	<4C77EE22.6020009@fusionio.com> <AANLkTi=JxBLiV4L1B_RHW9yK1jna_JHu7iton+0h-P_d@mail.gmail.com>
In-Reply-To: <AANLkTi=JxBLiV4L1B_RHW9yK1jna_JHu7iton+0h-P_d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/27/2010 11:37 PM, Chuck Tuffli wrote:
> On Fri, Aug 27, 2010 at 9:56 AM, Jens Axboe <jaxboe@fusionio.com>
> ...
>> Works for me, exact same job file. Can you do an sg_inq /dev/sg2?
> 
> Ugh, inquiries failed to that device but not others. Something went
> wrong with the LLDD, but a reboot cleared everything up. BTW, the
> patch really helped with the performance I'm seeing. Thanks again!

Great, I was starting to worry there was more than one bug there :-)

-- 
Jens Axboe

