Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47506 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDUTNt (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Apr 2009 15:13:49 -0400
Received: by fxm2 with SMTP id 2so2698120fxm.37
        for <fio@vger.kernel.org>; Tue, 21 Apr 2009 12:13:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090421190113.GN4593@kernel.dk>
References: <m2eiw1fys9.fsf@gmail.com>
	 <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
	 <38b2ab8a0904211137v3369b1cdxf80ee66658284719@mail.gmail.com>
	 <20090421190113.GN4593@kernel.dk>
Date: Tue, 21 Apr 2009 21:13:47 +0200
Message-ID: <38b2ab8a0904211213y18196b82w4384200b0c6ab8dd@mail.gmail.com>
Subject: Re: question about fork_main()
From: Francis Moreau <francis.moro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Carl Henrik Lunde <chlunde@ping.uio.no>, fio@vger.kernel.org

Hello Jens

On Tue, Apr 21, 2009 at 9:01 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Apr 21 2009, Francis Moreau wrote:
>> On Mon, Apr 20, 2009 at 3:16 AM, Carl Henrik Lunde <chlunde@ping.uio.no> wrote:
>> > I think your observation is correct, this is not necessary, shmat in
>> > the child can be avoided.
>>
>> Should I send a patch ?
>
> Sure, provided you do testing of it as well ;-)
>

OK, I'll do that (probably at the end of the week).

thanks
-- 
Francis
