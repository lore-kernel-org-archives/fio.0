Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:37506 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbeADGgP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jan 2018 01:36:15 -0500
Received: by mail-vk0-f42.google.com with SMTP id n2so383562vkf.4
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 22:36:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmQ5a=sN26L3b6BVH8Cht0=44LW=FtmkbkVvMawSsXzgEw@mail.gmail.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
 <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
 <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
 <CALjAwxj5oinoiFhFp18C8CmthwX_OP3231+PMHbAs8EHMQeHJw@mail.gmail.com>
 <CAPSTwmT+iOh5+THJAnyBHMcRf6AqURTq+M=rwWc6NayuuxW5nA@mail.gmail.com>
 <BN3PR0401MB1457B3B643C952B2B3F1C3EF8F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAPSTwmQ5a=sN26L3b6BVH8Cht0=44LW=FtmkbkVvMawSsXzgEw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 4 Jan 2018 06:35:43 +0000
Message-ID: <CALjAwxjSKx+rtBLPW5m292iLuz2Ege9Sih34YVcirTetuNUjUw@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Gnana,

On 4 January 2018 at 04:10, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Thanks for the response. That's the exact command I am using in the
> script to get sector size and multiply sector size with no. of sectors
> to get the size in Bytes.
> The size in Bytes is passed to the FIO in --size parameter
>
> I wasn't sure if FIO has an option to pass in the LBA count as
> parameter so that the above logic can be skipped

Ah I understand now. No fio doesn't have generic code to deduce the
underlying LBA size of a block device (although certain ioengines such
as sg find it out for themselves for other purposes). Personally, I've
found it's not easy to find out the block size a filesystem is using
which would make such a feature less useful since fio works on files
as well as block devices. Further if you actually need to do
arithmetic with the value then it's nicer to do all of that upfront
and no later than parsing time so  doing it outside of fio as you are
doing seems preferable...

-- 
Sitsofe | http://sucs.org/~sits/
