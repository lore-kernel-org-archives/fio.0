Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:45219 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdIRL0t (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 07:26:49 -0400
Received: by mail-ua0-f179.google.com with SMTP id c27so107094uah.2
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 04:26:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=VkkHN6NOeTZH3ShrmYpumbaAKBJnf4dW-nMKiEmS6tzg@mail.gmail.com>
References: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
 <CAOfm_=VkkHN6NOeTZH3ShrmYpumbaAKBJnf4dW-nMKiEmS6tzg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 18 Sep 2017 12:26:18 +0100
Message-ID: <CALjAwxg0kcnEY5mdyroXr7kFQYYx-s-zBN_AOmhqTKGmw_71qw@mail.gmail.com>
Subject: Re: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udi-Yehuda Tamar <udi@excelero.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 18 September 2017 at 09:58, Udi-Yehuda Tamar <udi@excelero.com> wrote:
> I just retest it and in 2.99 all is working but v3 not
> please elaborate
>
> On Mon, Sep 18, 2017 at 11:54 AM, Udi-Yehuda Tamar <udi@excelero.com> wrote:
>>
>> After moving from 2.99 to v3.0.61 I got:
>>
>> DEBUG: ROUND PARAMS: job=8 ioDepth=1 blockSize=4k rwmixread=0 ioEngine=libaio
>> ERROR: fio: engine libaio not loadable
>> ERROR: fio: failed to load engine
>> DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
>> open shared object file: No such file or directory
>>
>> libaio and libaio-devel are both installed on latest , any Idea ?

It sounds like your fio has been compiled without libaio support and
you can confirm this by doing this:
path/to/fio/fio --enghelp

Can you have whoever is compiling fio give you the output of doing
bash -x ./configure 2>&1 | grep -B 20 'Linux AIO support'
so you can post it here?

-- 
Sitsofe | http://sucs.org/~sits/
