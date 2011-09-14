Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37078 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab1INNNc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 14 Sep 2011 09:13:32 -0400
Received: by yxm8 with SMTP id 8so1374398yxm.19
        for <fio@vger.kernel.org>; Wed, 14 Sep 2011 06:13:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E707A47.1060002@cesnet.cz>
References: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com>
	<CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com>
	<4E707A47.1060002@cesnet.cz>
Date: Wed, 14 Sep 2011 21:13:31 +0800
Message-ID: <CADson1zR5rmYXhnvtrYogGEKOi_Ko5A_BvGRwA26yA+NXHzvDg@mail.gmail.com>
Subject: Re: memory leak bug? when do write with verify
From: Zhang Taile <zhangtl@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org

Hi,
Seems not same bug. I have tested latest (trunk), still has the memory
leak issue.

Taile

On Wed, Sep 14, 2011 at 5:56 PM, Jiri Horky <jiri.horky@cesnet.cz> wrote:
> Hi,
>
> this sounds like the problem addressed by this thread [1]. Have you tried to
> use the latest (trunk) version that includes the mentioned patch?
>
> Jiri Horky
>
> [1] http://www.spinics.net/lists/fio/msg00843.html
>
> On 09/14/2011 11:53 AM, Zhang Taile wrote:
>>
>> HI
>> When I do RandWrite with verify, fio will use a lot of memory. The fio
>> will increase memory about 10MB in every second. And, the system will
>> become very slow, after fio start to use swap partition.
>>
>> For example,  if use fio with following configuration,
>> [rand-write]
>> rw=randwrite
>> numjobs=32
>> loops=10
>> thread=1
>> filename=/dev/sdb
>> verify=md5
>> verify_interval=4k
>>
>> after  minutes, top will Like this :
>>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>  3749 root      15   0 2672m 1.5g 304m S 169.4 40.4   4:10.04 fio
>>
>>
>> If remove the verify from the configuration, there will be no the
>> memory problem.
>>
>> I guess it is a memory leak problem?
>>
>>
>> Thanks!
>> --
>> Taile
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Zhang, Taile  张泰乐
zhangtl@gmail.com
MP:18611745290
msn:zhangtaile@hotmail.com
skype: zhangtaile
