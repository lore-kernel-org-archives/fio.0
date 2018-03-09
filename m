Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:36059 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932104AbeCIVwl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 16:52:41 -0500
Received: by mail-ua0-f172.google.com with SMTP id j15so3221129uan.3
        for <fio@vger.kernel.org>; Fri, 09 Mar 2018 13:52:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
References: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 9 Mar 2018 21:52:10 +0000
Message-ID: <CALjAwxjmbtuAjT_s40EgvFkhAD8nDBVGrmaEvxr6JbLKBg3tOQ@mail.gmail.com>
Subject: Re: log_offset parameter not logging offset
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 9 March 2018 at 20:11, abhishek koundal <akoundal@gmail.com> wrote:
> All,
> Can someone please confirm if my usage is correct as earlier the
> offset used to be logged by using the log_offset=1 in the files.
> I am using FIO3.5.
>
> fio --name=global --time_based --size=100% --direct=1 --norandommap
> --randrepeat=0 --buffered=0 --refill_buffers --name=job
> --ioengine=libaio --group_reporting --filename=/dev/nvme0n1
> --numjobs=1 --iodepth=128 --bs=128k --rw=rw --rwmixread=70
> --runtime=10800 --write_iops_log=wr.log -write_lat_log=wr.clat.log
> --log_avg_msec=1000 --log_offset=1

To help us out a bit can you cut back as many options as possible?
Ideally you should try to get to the point where you have the minimum
number of options that still show the problem (i.e. to the point where
you can't remove any one option and still have the problem happen)?
For example I bet you can remove "--direct=1 --norandommap" and still
have the problem you describe happen. It just makes it easier to
investigate when there are less places to look...

-- 
Sitsofe | http://sucs.org/~sits/
