Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:38251 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbeCIXAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 18:00:15 -0500
Received: by mail-io0-f182.google.com with SMTP id g21so5268552ioj.5
        for <fio@vger.kernel.org>; Fri, 09 Mar 2018 15:00:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjmbtuAjT_s40EgvFkhAD8nDBVGrmaEvxr6JbLKBg3tOQ@mail.gmail.com>
References: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
 <CALjAwxjmbtuAjT_s40EgvFkhAD8nDBVGrmaEvxr6JbLKBg3tOQ@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Fri, 9 Mar 2018 14:59:34 -0800
Message-ID: <CAKwzdDp=wpc1v0nCwyS_+UigAwY2Fw5SgNusVEk+Rngwz5fRuw@mail.gmail.com>
Subject: Re: log_offset parameter not logging offset
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

fio --name=global --time_based --size=100% --filename=/dev/nvme0n1
--runtime=10 --write_iops_log=wr.log --log_avg_msec=1000
--log_offset=1

Still seeing the issue.

On Fri, Mar 9, 2018 at 1:52 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 9 March 2018 at 20:11, abhishek koundal <akoundal@gmail.com> wrote:
>> All,
>> Can someone please confirm if my usage is correct as earlier the
>> offset used to be logged by using the log_offset=1 in the files.
>> I am using FIO3.5.
>>
>> fio --name=global --time_based --size=100% --direct=1 --norandommap
>> --randrepeat=0 --buffered=0 --refill_buffers --name=job
>> --ioengine=libaio --group_reporting --filename=/dev/nvme0n1
>> --numjobs=1 --iodepth=128 --bs=128k --rw=rw --rwmixread=70
>> --runtime=10800 --write_iops_log=wr.log -write_lat_log=wr.clat.log
>> --log_avg_msec=1000 --log_offset=1
>
> To help us out a bit can you cut back as many options as possible?
> Ideally you should try to get to the point where you have the minimum
> number of options that still show the problem (i.e. to the point where
> you can't remove any one option and still have the problem happen)?
> For example I bet you can remove "--direct=1 --norandommap" and still
> have the problem you describe happen. It just makes it easier to
> investigate when there are less places to look...
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
