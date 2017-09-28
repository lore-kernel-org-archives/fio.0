Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:53108 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdI1RGS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Sep 2017 13:06:18 -0400
Received: by mail-qk0-f172.google.com with SMTP id o77so2071339qke.9
        for <fio@vger.kernel.org>; Thu, 28 Sep 2017 10:06:18 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: Question on source code
References: <CAOmo8DYM7JGSqFVB1tyicUMUk=HxfMFTAAZfRAz_PoQMPZd6JQ@mail.gmail.com>
Message-ID: <e3249202-42d4-6345-d3e7-52672c68c2c9@gmail.com>
Date: Thu, 28 Sep 2017 13:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAOmo8DYM7JGSqFVB1tyicUMUk=HxfMFTAAZfRAz_PoQMPZd6JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@gmail.com>, fio@vger.kernel.org

Originally FIO_IO_U_PLAT_GROUP_NR was 19. It was changed to 29 when the 
time unit was changed from usec to nsec.

The description is based on the original 19 groups.

Vincent

On 28-Sep-17 12:55, Andrzej Jakowski wrote:
> Hi,
> 
> I'm checking source code for percentile calculation:
> There is a descrption, showing there is 19 groups:
> https://github.com/axboe/fio/blob/master/stat.h#L89
> 
> Below it there is macro showing group number to be 29.
> #define FIO_IO_U_PLAT_GROUP_NR 29
> https://github.com/axboe/fio/blob/master/stat.h#L112
> 
> I'm wondering if the original intent for setting
> FIO_IO_U_PLAT_GROUP_NR was to 19 and what I see there is just a typo.
> Please let me know.
> 
> Thx,
> Andrzej
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

