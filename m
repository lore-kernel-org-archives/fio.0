Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:60179 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaJWSSe (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Oct 2014 14:18:34 -0400
Received: by mail-oi0-f49.google.com with SMTP id a3so1109776oib.8
        for <fio@vger.kernel.org>; Thu, 23 Oct 2014 11:18:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54494059.8030207@kernel.dk>
References: <CAGRFgs1Urv6c41Roz9_QKJsP-7yw-ihDKoe3VUq87anDNJWF5g@mail.gmail.com>
	<CAGRFgs23OL8CDXOA5ENik+B+kPk2s_U_E+kYA9PAr4opux3jYQ@mail.gmail.com>
	<54494059.8030207@kernel.dk>
Date: Thu, 23 Oct 2014 12:18:33 -0600
Message-ID: <CAGRFgs1udDB5Y040nzQ8kZjxmEXiAK3Aee7KMVrL_cGNrSKYSw@mail.gmail.com>
Subject: Re: Per-thread and aggregate bandwidth reporting
From: George Smith <glsmith555@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Thanks Jens.

When you say neither number makes sense, are you referring to the sum
of threads and the aggrb value, or the summed value and  my suggestion
of an average value?

These threads are reading from a NAS device, so there's inherent
variability expected.  I suppose the ideal solution would be to read
or write for a set amount of time, record the per-thread I/O done over
that fixed time, then divide by the time.  It seems like I could
accomplish this using the "runtime" feature; the challenge (for me)
with that is that I don't necessarily  know the length of the test
before the test is run, so it's difficult to choose an appropriate
runtime.

I didn't see anything in the documentation, but is there a way to stop
all the threads in a group once one of the threads has completed all
the requested I/O?

On Thu, Oct 23, 2014 at 11:52 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/23/2014 11:04 AM, George Smith wrote:
>> Uh oh, silence is never good :)  Please let me know if I haven't
>> included key information, missed something obvious, etc.
>>
>> Here's maybe a clearer example of what I'm talking about.  The output
>> file is from a read test using 5 threads:
>>
>> # grep 'read :' output.out
>>  read : io=51200MB, bw=116673KB/s, iops=113 , runt=449367msec
>>  read : io=51200MB, bw=189201KB/s, iops=184 , runt=277106msec
>>  read : io=51200MB, bw=143385KB/s, iops=140 , runt=365650msec
>>  read : io=51200MB, bw=114654KB/s, iops=111 , runt=457279msec
>>  read : io=51200MB, bw=183110KB/s, iops=178 , runt=286324msec
>>
>> # grep READ output.out
>>   READ: io=256000MB, aggrb=573269KB/s, minb=114653KB/s,
>> maxb=189201KB/s, mint=277106msec, maxt=457279msec
>>
>>
>> The sum of the threads is 747023, but aggrb is 573269.  The bw= value
>> in each thread line is the amount of I/O (from io=) divided by the
>> time the I/O took.
>>
>> The aggrb= value is the total amount of I/O done (which is the sum of
>> each thread's io= value), divided by maxt, which seems to be the
>> maximum time seen during the run (which happens to be with my 4th
>> thread).
>>
>> So it appears that this is the discrepancy.  I'm not sure if it's
>> correct to say the aggregate bandwidth is the total I/O divided by the
>> max time that one of the threads in the group took to complete.  Seems
>> like taking the average time and dividing total I/O by that would be
>> more correct.
>>
>> Am I missing the spirit of what the READ line is supposed to be conveying to me?
>
> I think you deduced it correctly. And yes, it is a bit misleading, in
> that it differs from the sum of the reported bandwidths. Neither number
> really makes sense, however.
>
> --
> Jens Axboe
>
