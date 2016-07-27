Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57235 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbcG0BgR (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jul 2016 21:36:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bSDle-0006mc-2q
	for fio@vger.kernel.org; Wed, 27 Jul 2016 03:36:14 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 27 Jul 2016 03:36:14 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 27 Jul 2016 03:36:14 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Date: Tue, 26 Jul 2016 20:36:00 -0500
Message-ID: <nn935v$so2$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org> <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com> <nn66ih$j66$1@ger.gmane.org> <CALjAwxhCSTdi_EjvciC=-zy8=8G4rz-X6G4RiOgKwTeyumPPog@mail.gmail.com> <nn84j6$5la$1@ger.gmane.org> <CALjAwxj0ig71RbtP4oNmMNa9QumcDnBkHxao2g-u2EyLFFq-7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Looking at this example 
https://github.com/axboe/fio/blob/master/examples/surface-scan.fio I 
noticed it didn't have any runtime and/or time_based bound settings so 
I wanted to confirm if its needed or not.


On 2016-07-26 18:11:47 +0000, Sitsofe Wheeler said:

> On 26 July 2016 at 17:53, Saeed 
> <ionictea@gmail.com> wrote:
>> But what about in the case of a verify job where we want verification done
>> (do_verify)?  Should we exclude the runtime & time_based settings from the
>> validation/verification job?
> 
> If I had to guarantee at least one write pass was completed and one
> verification pass was also completed then yes I'd ensure that runtime
> and time_based were not set on that write job. runtime/time_based is
> there so you can guarantee a job will run for given period of time
> (and not dramatically more or less time).
> 
>> http://www.coderplay.org/filesysdev/FIO-Data-Integrity-Test.html
>> 
>> "However, if the job file specifies to run based on time rather than total
>> number of bytes (setting runtime=int and time_based), then do_verify() is
>> not performed. "
> 
> This is correct and matches my previous warning. If you are asking for
> *both runtime and time_based* and the verification job is a write one
> then it won't stop writing until runtime is exceeded and at that point
> there can't be any time left to do the verify. What are you trying to
> achieve by setting runtime/time_based?



