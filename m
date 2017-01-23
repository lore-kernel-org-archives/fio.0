Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:33433 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAWUZK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 15:25:10 -0500
Received: by mail-vk0-f54.google.com with SMTP id k127so98453703vke.0
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 12:25:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com> <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com> <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 23 Jan 2017 20:24:39 +0000
Message-ID: <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 23 January 2017 at 19:40, Tobias Oberstein
<tobias.oberstein@gmail.com> wrote:
> Am 23.01.2017 um 20:13 schrieb Sitsofe Wheeler:
>>
>> On 23 January 2017 at 18:33, Tobias Oberstein
>> <tobias.oberstein@gmail.com> wrote:
>>>
>>> libaio is nowhere near what I get with engine=sync and high job counts.
>>> Mmh.
>>> Plus the strange behavior.
>>
>> Have you tried batching the IOs and controlling how much are you
>> reaping at any one time? See
>>
>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth_batch_submit
>> for some of the options for controlling this...
>
> Thanks! Nice.
>
> For libaio, and with all the hints applied (no 4k sectors yet), I get (4k
> randread)
>
> Individual NVMes: iops=7350.4K
> MD (RAID-0) over NVMes: iops=4112.8K
>
> The going up and down of IOPS is gone.
>
> It's becoming more apparent I'd say, that tthere is a MD bottleneck though.

If you're "just" trying for higher IOPS you can also try gtod_reduce
(see http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-gtod_reduce
). This subsumes things like disable_lat but you'll get fewer and less
accurate measurement stats back. With libaio userspace reap
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-userspace_reap
) can sometimes nudge numbers up but at the cost of CPU.

-- 
Sitsofe | http://sucs.org/~sits/
