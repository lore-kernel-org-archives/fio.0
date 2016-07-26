Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59915 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbcGZQyL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jul 2016 12:54:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bS5cO-00085b-Bh
	for fio@vger.kernel.org; Tue, 26 Jul 2016 18:54:08 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 18:54:08 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 18:54:08 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Date: Tue, 26 Jul 2016 11:53:58 -0500
Message-ID: <nn84j6$5la$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org> <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com> <nn66ih$j66$1@ger.gmane.org> <CALjAwxhCSTdi_EjvciC=-zy8=8G4rz-X6G4RiOgKwTeyumPPog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

But what about in the case of a verify job where we want verification 
done (do_verify)?  Should we exclude the runtime & time_based settings 
from the validation/verification job?

http://www.coderplay.org/filesysdev/FIO-Data-Integrity-Test.html

"However, if the job file specifies to run based on time rather than 
total number of bytes (setting runtime=int and time_based), then 
do_verify() is not performed. "

On 2016-07-26 06:15:34 +0000, Sitsofe Wheeler said:

> On 26 July 2016 at 00:15, Saeed 
> <ionictea@gmail.com> wrote:
>> Here's the example:
>> 
>> [global]
>> bs=4k
>> ioengine=libaio
>> iodepth=32
>> size=1g
>> direct=1
>> time_based=1
>> runtime=300
>> filename=/dev/sdb
>> group_reporting
>> numjobs=1
>> 
>> # validation
>> do_verify=1
>> verify_fatal=1
>> verify_dump=1
>> 
>> verify_pattern=0x00000001
>> 
>> [sequential]
>> rw=readwrite
>> stonewall
>> 
>> [random]
>> rw=randrw
>> stonewall
>> 
>> So with this job file there are two job declarations (sequential & random).
>> Does the time_based & runtime requirement apply to the entire job as a whole
>> or per job declaration?
> 
> time_based and runtime are per job (like nearly all fio options) so
> this job file above will take 600 seconds to complete. This is easy to
> check with a smaller and simpler job file:
> 
> [global]
> runtime=5
> time_based
> size=10M
> stonewall
> filename=/tmp/fiotmp
> [job1]
> [job2]
> 
> The stonewall forces the jobs to run one after the other and the
> results will show long each job ran for. If necessary we can easily
> use a program like time to see how long the total running time turned
> out to be.
> 
> Remember that runtime applies to all parts of a job. If a job is
> supposed to verify after it has finished writing but the runtime is
> exceeded during the writing part then no verification will occur.



