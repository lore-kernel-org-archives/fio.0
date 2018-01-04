Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:45924 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbeADEKH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jan 2018 23:10:07 -0500
Received: by mail-wr0-f172.google.com with SMTP id o15so355187wrf.12
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 20:10:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457B3B643C952B2B3F1C3EF8F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
 <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
 <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
 <CALjAwxj5oinoiFhFp18C8CmthwX_OP3231+PMHbAs8EHMQeHJw@mail.gmail.com>
 <CAPSTwmT+iOh5+THJAnyBHMcRf6AqURTq+M=rwWc6NayuuxW5nA@mail.gmail.com> <BN3PR0401MB1457B3B643C952B2B3F1C3EF8F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Wed, 3 Jan 2018 21:10:05 -0700
Message-ID: <CAPSTwmQ5a=sN26L3b6BVH8Cht0=44LW=FtmkbkVvMawSsXzgEw@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jeff,

Thanks for the response. That's the exact command I am using in the
script to get sector size and multiply sector size with no. of sectors
to get the size in Bytes.
The size in Bytes is passed to the FIO in --size parameter

I wasn't sure if FIO has an option to pass in the LBA count as
parameter so that the above logic can be skipped

Regards,
Gnana

On Wed, Jan 3, 2018 at 4:37 PM, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>> how will I arrive at block size of 4k
> On Linux platforms, you may want to look at "blockdev --getss /dev/nvme0n1" to determine the sector size of your device.  Various other blockdev options will report various other device parameters.
>
> Regards,
> Jeff
>
