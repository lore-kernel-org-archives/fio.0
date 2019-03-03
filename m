Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([96.73.9.1]:11214 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfCCBmm (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Mar 2019 20:42:42 -0500
Subject: Re: fio.exe has stopped working
References: <BYAPR04MB395750846A4577AE03C100F1AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
 <CALjAwxir74sOo-2drJ5Cu_sHbAZQgbd5x7fv2SXB0ttSQQadVA@mail.gmail.com>
 <BYAPR04MB39573C849C7FDFB05866D4A7AB760@BYAPR04MB3957.namprd04.prod.outlook.com>
 <CALjAwxhQOo4_LaD996KEhRO1ZwHNqv1_MJU_3SnF5AHBcmKv8g@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <4f515e7b-744e-71ca-7a04-c53a35dadb42@bluestop.org>
Date: Sat, 2 Mar 2019 18:36:51 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxhQOo4_LaD996KEhRO1ZwHNqv1_MJU_3SnF5AHBcmKv8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Sitsofe, TK,


I was indeed building over-specialized versions: I wasn't using the 
--disable-native flag.

I've just re-uploaded fio-3.13 binaries to https://bluestop.org/fio 
which should work better.


-- 

Rebecca


On 3/2/19 1:41 AM, Sitsofe Wheeler wrote:
> Hello Rebecca,
>
> It sounds like an over specialized version of your Windows fio
> binaries is being built. Could you check you're compiling them with
> --disable-native or that Build march=native somehow reports no?
>
> On Fri, 1 Mar 2019 at 07:42, TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com> wrote:
>> Hi Sitsofe,
>>
>> Yes the original FIO ver 3.12 was downloaded from bluestop.
>> I uninstalled that version and reinstall with the link that you provided and problem resolved.
>>
>> Thanks for your help!
>>
>> TK
>>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Sitsofe Wheeler
>> Sent: Thursday, February 28, 2019 8:22 PM
>> To: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>
>> Cc: fio@vger.kernel.org
>> Subject: Re: fio.exe has stopped working
>>
>> Hi,
>>
>> On Fri, 1 Mar 2019 at 02:12, TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com> wrote:
>>> Hi,
>>>
>>> I have installed FIO 3.12 on 4 desktop PCs - all running Windows 7 with different processors.
>>> 2 of them are running FIO without problem, but another 2 has this
>>> windows error
>>>
>>> "fio.exe has stopped working
>>> A problem caused the program to stop working correctly.
>>> Windows will close the program and notify you if a solution is
>>> Available.
>>>                                  Close program [button]"
>>>
>>>   Has anyone run into this problem before? And if yes, what is the solution?
>> Where are you grabbing the fio.exe binary from? Was it from https://bluestop.org/fio/ ?
>>
>> At a wild guess it could be the binary was built with instructions some of your PCs don't support due to march=native... Does the binary from https://ci.appveyor.com/project/axboe/fio/builds/20011071/job/54r8b1d6u8jpcth9/artifacts
>> work?

