Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41735 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbcGXPdo (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 24 Jul 2016 11:33:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bRLPR-0005ac-9R
	for fio@vger.kernel.org; Sun, 24 Jul 2016 17:33:41 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Sun, 24 Jul 2016 17:33:41 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Sun, 24 Jul 2016 17:33:41 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: "errror=Invalid or incomplete multibyte or wide character" & "verify: bad header numberio" errors
Date: Sun, 24 Jul 2016 10:33:26 -0500
Message-ID: <nn2n46$tbh$1@ger.gmane.org>
References: <nmthlt$4m6$1@ger.gmane.org> <CALjAwxi_XeY4_yWf=xrNbNpF+a5-p5MjUSXUNQk=o0e0s7ASNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I reduced the number of jobs down to 1 and now getting no errors.

A


https://bugs.chromium.org/p/chromium/issues/detail?id=337651


On 2016-07-22 19:06:08 +0000, Sitsofe Wheeler said:

> On 22 July 2016 at 17:29, Saeed 
> <ionictea@gmail.com> wrote:
>> Has anyone seen these errors before?
>> 
>> Here's the job file:
>> 
>> bs=4k
>> ioengine=libaio
>> iodepth=32
>> size=1g
>> direct=1
>> runtime=60
>> filename=/dev/sdb
>> group_reporting
>> numjobs=10
>> 
>> # validation
>> do_verify=1
>> verify_fatal=1
>> verify_dump=1
>> 
>> verify_pattern=0x01020304
>> 
>> [mixed-a]
>> rw=readwrite
>> stonewall
>> 
>> [mixed-b]
>> rw=randrw
>> stonewall
> [...]
>> fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
> 
> I forgot to say that you might be getting these errors because you
> limit the runtime of individual jobs to 60 seconds and that might not
> be enough time for your mixed-a job to overwrite the entire 1GByte of
> the file before it stopped due to running out of time. If later
> verification jobs try to verify an area not written to, the header may
> not be there or/malformed thus generating error messages.
> 
> -- 
> Sitsofe | http://sucs.org/~sits/
> 
> On 22 July 2016 at 17:29, Saeed 
> <ionictea@gmail.com> wrote:
>> Has anyone seen these errors before?
>> 
>> Here's the job file:
>> 
>> bs=4k
>> ioengine=libaio
>> iodepth=32
>> size=1g
>> direct=1
>> runtime=60
>> filename=/dev/sdb
>> group_reporting
>> numjobs=10
>> 
>> # validation
>> do_verify=1
>> verify_fatal=1
>> verify_dump=1
>> 
>> verify_pattern=0x01020304
>> 
>> [mixed-a]
>> rw=readwrite
>> stonewall
>> 
>> [mixed-b]
>> rw=randrw
>> stonewall
>> 
>> [mixed-c]
>> rw=readwrite:4k
>> stonewall
>> 
>> [mixed-d]
>> rw=randrw:4k
>> stonewall
>> 
>> Errors:
>> 
>> Multiple writers may overwrite blocks that belong to other jobs. This can
>> cause verification failures.
>> mixed-verify-random-with-holes-4k: (g=3): rw=randrw, bs=4K-4K/4K-4K/4K-4K,
>> ioengine=libaio, iodepth=32
>> ...
>> fio-2.12
>> Starting 40 processes
>> fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
>> fio: pid=5814, err=84/file:io_u.c:1968, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
>> fio: pid=5808, err=84/file:io_u.c:1968, func=io_u_queued_complete,
>> error=Invalid or incomplete multibyte or wide character
>> 
>> verify: bad header numberio 2985, wanted 11 at file /dev/sdb offset 1224704,
>> length 4096
>> hdr_fail data dumped as sdb.1224704.hdr_fail
>> verify: bad header numberio 2986, wanted 12 at file /dev/sdb offset 1228800,
>> length 4096
>> hdr_fail data dumped as sdb.1228800.hdr_fail
>> verify: bad header numberio 23727, wanted 22903 at file /dev/sdb offset
>> 106496, length 4096
>> hdr_fail data dumped as sdb.106496.hdr_fail
>> verify: bad header numberio 13399, wanted 1319 at file /dev/sdb offset
>> 311296, length 4096
>> hdr_fail data dumped as sdb.311296.hdr_fail
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



