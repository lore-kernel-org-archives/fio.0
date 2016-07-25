Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39766 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbcGYXPx (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jul 2016 19:15:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bRp6E-0006en-AJ
	for fio@vger.kernel.org; Tue, 26 Jul 2016 01:15:50 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 01:15:50 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 01:15:50 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Date: Mon, 25 Jul 2016 18:15:29 -0500
Message-ID: <nn66ih$j66$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org> <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Here's the example:

[global]
bs=4k
ioengine=libaio
iodepth=32
size=1g
direct=1
time_based=1
runtime=300
filename=/dev/sdb
group_reporting
numjobs=1

# validation
do_verify=1
verify_fatal=1
verify_dump=1

verify_pattern=0x00000001

[sequential]
rw=readwrite
stonewall

[random]
rw=randrw
stonewall

So with this job file there are two job declarations (sequential & 
random).  Does the time_based & runtime requirement apply to the entire 
job as a whole or per job declaration?

On 2016-07-25 17:13:57 +0000, Sitsofe Wheeler said:

> On 25 July 2016 at 18:00, Saeed 
> <ionictea@gmail.com> wrote:
>> If a job file contains x number of job declarations ([jobxx]) how does the
>> 'time_based" and 'runtime' scoped?
>> 
>> Is it per job declaration or inclusive of all the job declarations in the
>> file?  I'm trying to set a limit in run time to have the jobs run until a
>> certain amount of time has been reached and the jobs still run over the
>> 'runtime' defined limit
> 
> Could you give a minimal job file that demonstrates the problem and
> just to check are you using time_based too
> (https://github.com/axboe/fio/blob/fio-2.13/HOWTO#L1200 )?



