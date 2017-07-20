Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:57812 "EHLO
        wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933397AbdGTFtG (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 20 Jul 2017 01:49:06 -0400
Subject: Re: iSCSI write performance issues
References: <8b6ac1f2-a6e6-54a2-a439-339df8860e55@bisect.de>
 <CALjAwxi_CdQ1ffu8zADbiKof_c4Q0cTrDax1LWUZzL+onDbhQA@mail.gmail.com>
From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Reply-To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Message-ID: <6528223f-0962-240c-2ded-5799412131ae@bisect.de>
Date: Thu, 20 Jul 2017 07:49:04 +0200
MIME-Version: 1.0
In-Reply-To: <CALjAwxi_CdQ1ffu8zADbiKof_c4Q0cTrDax1LWUZzL+onDbhQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 19.07.2017 um 23:16 schrieb Sitsofe Wheeler:
> Hi,
> 
> On 19 July 2017 at 18:22, Danny Al-Gaaf <danny.al-gaaf@bisect.de> wrote:
>>
>> I'm running into an issue with performance measurements on an iSCSI
>> volume. The volume has set a QoS value of max. 30.000 iops.
>>
>> I run tests with the libaio engine against the volume with the following
>> base parameter:
>>
>> fio --filename=/dev/sde --ioengine=libaio --direct=1 --buffered=0
>> --atomic=1 --bs=4k --invalidate=0
>> --readwrite=[read,write,randwrite,randread] --iodepth=128 --time_based
>> --runtime=1200  --name=ft --write_iops_log=w_iops_log
>> --write_bw_log=w_bw_log --write_lat_log=w_lat_log --output=fio_log
>>
>> With randread/randwrite everything is as expected. The volume reaches
>> the QoS max value and not more. But with write/read/readwrite I can get
>> over the max QoS IOPs: ~41k iops.
>>
>> After some investigation with wireshark it seems with seq r/w packages
>> are aggregated (e.g. 8k TCP packages instead of 4k), which they are not
>> with randwrite.
>>
>> Is there an issue in libaio or in fio? Or is it an expected behavior
>> from the kernel?
> 
> Is fio's output (see "And finally, the disk statistics are printed" in
> http://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
> ) saying that merges took place?

No, it says merge=0/248086. Thats why I was puzzled with the situation.
It seems there is a small bug in fio. I will take a look at it.

> If so if you tell the kernel to
> disable all merging (see nomerges in
> https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt which
> talks about how it is possible to disable merging by writing 2 to the
> block device's nomerges parameter) does that change things? If so then
> I'd say you are seeing expected kernel behaviour.

By setting nomerges to '2' the behavior is changed and the performance
fits the expectations.

Thanks for the hint.

Danny


