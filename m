Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:42866 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDTGd4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Apr 2021 02:33:56 -0400
Subject: Re: [Question] Sequential mesuaring and filename option
References: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
 <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com>
 <6bf156f9-5771-0afe-92c5-d8bb1e04b69f@nttcom.co.jp_1>
 <CALjAwxj_-Q1HteM1MdcmxfeuAD54jvQMNpQi5Rt78sC-9ZRgHw@mail.gmail.com>
 <f2e9d44d-9d1f-46a2-3112-a1982c559ac5@nttcom.co.jp_1>
 <CALjAwxh79d7ebKNU3xZUaQgF50q-3bVLVSC1QJ+Ub=3DsX6XPQ@mail.gmail.com>
 <7cd0c68b-e3fe-10fe-27ba-9e92688ea931@nttcom.co.jp_1>
 <CALjAwxhB1PUQKrW7QNZsYLJ-LKtW+hegV3YQiHhmz2j4McOw0A@mail.gmail.com>
 <b9ed27ec-c915-17b4-efc4-94a6dd32cba7@nttcom.co.jp_1>
 <CALjAwxg8LzYAyP-gKB7LvFf8ybTJkuxSKpsVrHAzHGAQJR45CQ@mail.gmail.com>
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Message-id: <b4f76e75-97af-8796-3f6e-60c012f64f58@nttcom.co.jp_1>
Date: Tue, 20 Apr 2021 15:32:12 +0900
MIME-version: 1.0
In-reply-to: <CALjAwxg8LzYAyP-gKB7LvFf8ybTJkuxSKpsVrHAzHGAQJR45CQ@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Erwan Velu <e.velu@criteo.com>


On 2021/04/17 3:02, Sitsofe Wheeler wrote:
> On Fri, 16 Apr 2021 at 08:12, Nakajima Akira
> <nakajima.akira@nttcom.co.jp> wrote:
>>
>> Thank you very mush for the commentary.
>> By adding -offset_increment = x%, I got the same result with -filename
>> as with -directory.
>>
>>   > job1: | 0 | 1 | 2 | ...
>>   > job2: | 0 | 1 | 2 | ...
>>
>>   > In this case in the first
>>   > "instant" LBA 0 is being written twice, LBA 1 is being written twice
>>   > in the second instant and LBA 2 is being written twice in the third
>>   > instant.
>>
>> Is this a bug of fio?
>> I don't understand the purpose of the above operation.
>> Is there anyone who expects this behavior and measures it?
>>     (Despite -direct=1, Result is far exceeds the physical speed of the HDD)
> 
> I personally don't consider it a bug - it's not fio doing the
> "optimisation". There could be some pathological reason you need such
> a workload (e.g. you have to test your disk doesn't just die because
> it's actually a legal thing to do) and there are certain disks where
> the outcome IS strictly defined (I have a vague recollection about
> SCSI TASK attribute ORDERED). Ultimately, it's the result of combining
> things that make sense separately and the combination leading to a
> non-intuitive result. Sometimes there's no escape from having a good
> model of why you get the results you do - another popular case where
> things exceed physical speeds is when your data consists of all zeroes
> and you're writing to an I/O stack that does compression. You have to
> know enough to explain the outcome and why it may not reflect what you
> see in "real life"...
> 
> Having said that, would you like to submit a patch to update the
> documentation with a warning?



I understand it is a specification.
I'm enough because I just want to know whether it is a spec or a bug, 
and what options can give me the results I wanted.
All resolved.
Thank you very much.

Nakajima.


