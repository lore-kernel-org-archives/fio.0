Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:54476 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdI1RKJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Sep 2017 13:10:09 -0400
Received: by mail-ua0-f178.google.com with SMTP id l94so1333681ual.11
        for <fio@vger.kernel.org>; Thu, 28 Sep 2017 10:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e3249202-42d4-6345-d3e7-52672c68c2c9@gmail.com>
References: <CAOmo8DYM7JGSqFVB1tyicUMUk=HxfMFTAAZfRAz_PoQMPZd6JQ@mail.gmail.com>
 <e3249202-42d4-6345-d3e7-52672c68c2c9@gmail.com>
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Thu, 28 Sep 2017 10:10:07 -0700
Message-ID: <CAOmo8DYCi4HM0cuHxra16key-AC=vVFzND2DoKs_NjqA-NkOMg@mail.gmail.com>
Subject: Re: Question on source code
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org

Got you. Even found patch you authored on that.
Thanks!

On Thu, Sep 28, 2017 at 10:06 AM, Vincent Fu <vincentfu@gmail.com> wrote:
> Originally FIO_IO_U_PLAT_GROUP_NR was 19. It was changed to 29 when the time
> unit was changed from usec to nsec.
>
> The description is based on the original 19 groups.
>
> Vincent
>
>
> On 28-Sep-17 12:55, Andrzej Jakowski wrote:
>>
>> Hi,
>>
>> I'm checking source code for percentile calculation:
>> There is a descrption, showing there is 19 groups:
>> https://github.com/axboe/fio/blob/master/stat.h#L89
>>
>> Below it there is macro showing group number to be 29.
>> #define FIO_IO_U_PLAT_GROUP_NR 29
>> https://github.com/axboe/fio/blob/master/stat.h#L112
>>
>> I'm wondering if the original intent for setting
>> FIO_IO_U_PLAT_GROUP_NR was to 19 and what I see there is just a typo.
>> Please let me know.
>>
>> Thx,
>> Andrzej
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
