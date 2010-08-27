Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51633 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0H0Qz5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Aug 2010 12:55:57 -0400
Message-ID: <4C77EE22.6020009@fusionio.com>
Date: Fri, 27 Aug 2010 18:56:02 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: using ioengine=sg
References: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>	<4C776359.70403@fusionio.com> <AANLkTikN0M5eVXOAi9APqeS2Q7tiuYPacMsWiO0FnAWC@mail.gmail.com>
In-Reply-To: <AANLkTikN0M5eVXOAi9APqeS2Q7tiuYPacMsWiO0FnAWC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-08-27 17:40, Chuck Tuffli wrote:
> On Fri, Aug 27, 2010 at 12:03 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> ...
>> You are not doing anything wrong, it's a bug. This patch will fix
>> it.
> 
> Thanks for the patch. Now I see the following
> 
>> sudo ./fio sgtest.fio
> /dev/sg2: (g=0): rw=read, bs=512-512/512-512, ioengine=sg, iodepth=1
> Starting 1 process
> Jobs: 1 (f=0): [R] [12900.0% done] [0K/0K /s] [0/0 iops] [eta
> 1158050441d:06h:58m:08s]

Works for me, exact same job file. Can you do an sg_inq /dev/sg2?

-- 
Jens Axboe

