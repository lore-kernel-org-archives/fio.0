Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:34931 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeCJFss (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Mar 2018 00:48:48 -0500
Received: by mail-vk0-f49.google.com with SMTP id b65so3428576vka.2
        for <fio@vger.kernel.org>; Fri, 09 Mar 2018 21:48:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDp=wpc1v0nCwyS_+UigAwY2Fw5SgNusVEk+Rngwz5fRuw@mail.gmail.com>
References: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
 <CALjAwxjmbtuAjT_s40EgvFkhAD8nDBVGrmaEvxr6JbLKBg3tOQ@mail.gmail.com> <CAKwzdDp=wpc1v0nCwyS_+UigAwY2Fw5SgNusVEk+Rngwz5fRuw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 10 Mar 2018 05:48:17 +0000
Message-ID: <CALjAwxgiQHEzTdwTtnzxiRgYFD37FX5UDig9gLW-mi+X08j8Vg@mail.gmail.com>
Subject: Re: log_offset parameter not logging offset
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 9 March 2018 at 22:59, abhishek koundal <akoundal@gmail.com> wrote:
>
> On 9 March 2018 at 20:11, abhishek koundal <akoundal@gmail.com> wrote:
>> All,
>> Can someone please confirm if my usage is correct as earlier the
>> offset used to be logged by using the log_offset=1 in the files.
>> I am using FIO3.5.
>
> fio --name=global --time_based --size=100% --filename=/dev/nvme0n1
> --runtime=10 --write_iops_log=wr.log --log_avg_msec=1000
> --log_offset=1
>
> Still seeing the issue.

log_avg_msec=1000 tries to average values seen every second which
means some values will become nonsense when it's enabled. There's a
warning at the end of the "Log File Formats" section of the HOWTO
(http://fio.readthedocs.io/en/latest/fio_doc.html#log-file-formats )
but perhaps it needs to be moved elsewhere - would it have been better
under the log_avg_msec section of the HOWTO
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-log-avg-msec
)?

-- 
Sitsofe | http://sucs.org/~sits/
