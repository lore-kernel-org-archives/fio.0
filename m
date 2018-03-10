Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38848 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbeCJK3t (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Mar 2018 05:29:49 -0500
Received: by mail-it0-f54.google.com with SMTP id j7-v6so5848448ita.3
        for <fio@vger.kernel.org>; Sat, 10 Mar 2018 02:29:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiYg1NMTcKEjfA1=JT61Gk+24vOw7MKx9x5H4q=-Z9tOQ@mail.gmail.com>
References: <CAKwzdDoswbH-Zun2i0pawWHLDDO3wgNW6PKE46ubixHtEm5cqg@mail.gmail.com>
 <CALjAwxjmbtuAjT_s40EgvFkhAD8nDBVGrmaEvxr6JbLKBg3tOQ@mail.gmail.com>
 <CAKwzdDp=wpc1v0nCwyS_+UigAwY2Fw5SgNusVEk+Rngwz5fRuw@mail.gmail.com>
 <CALjAwxgiQHEzTdwTtnzxiRgYFD37FX5UDig9gLW-mi+X08j8Vg@mail.gmail.com>
 <CAKwzdDoV7RR4FrUgtcpqU70Y8+OJsgeM80PC5mumVp=tB70=LA@mail.gmail.com> <CALjAwxiYg1NMTcKEjfA1=JT61Gk+24vOw7MKx9x5H4q=-Z9tOQ@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Sat, 10 Mar 2018 02:29:07 -0800
Message-ID: <CAKwzdDrhm-xPc1iqf5U98kCXBDgMhpTQg8zVk90S-yO0S1o7ng@mail.gmail.com>
Subject: Re: log_offset parameter not logging offset
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Where  log_offset description is given It will be best to have one
liner saying if log_avg_msec parameter is used offset wont be logged.
This will make it very clear.

On Sat, Mar 10, 2018 at 1:18 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> Glad to hear you found the cause. Nonetheless, do you think the
> documentation needs changing and if so how?
>
> On 10 March 2018 at 08:07, abhishek koundal <akoundal@gmail.com> wrote:
>> yes you are correct. thanks for the information, i can see the offset
>> w/o the log_avg_msec.
>> appreciate your prompt support.
>>
>> On Fri, Mar 9, 2018 at 9:48 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> On 9 March 2018 at 22:59, abhishek koundal <akoundal@gmail.com> wrote:
>>>>
>>>> On 9 March 2018 at 20:11, abhishek koundal <akoundal@gmail.com> wrote:
>>>>> All,
>>>>> Can someone please confirm if my usage is correct as earlier the
>>>>> offset used to be logged by using the log_offset=1 in the files.
>>>>> I am using FIO3.5.
>>>>
>>>> fio --name=global --time_based --size=100% --filename=/dev/nvme0n1
>>>> --runtime=10 --write_iops_log=wr.log --log_avg_msec=1000
>>>> --log_offset=1
>>>>
>>>> Still seeing the issue.
>>>
>>> log_avg_msec=1000 tries to average values seen every second which
>>> means some values will become nonsense when it's enabled. There's a
>>> warning at the end of the "Log File Formats" section of the HOWTO
>>> (http://fio.readthedocs.io/en/latest/fio_doc.html#log-file-formats )
>>> but perhaps it needs to be moved elsewhere - would it have been better
>>> under the log_avg_msec section of the HOWTO
>>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-log-avg-msec
>>> )?
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
