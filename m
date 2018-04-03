Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33527 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeDCUHQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Apr 2018 16:07:16 -0400
Received: by mail-vk0-f48.google.com with SMTP id d201so6618943vke.0
        for <fio@vger.kernel.org>; Tue, 03 Apr 2018 13:07:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF+0mvk1tq03iVgVHGLMmarmG8XNjGqiWebSqBjJVUOEW5j-Lg@mail.gmail.com>
References: <CAB-428nGSovor98bWztkQK3C0veSCK_ECey-yeBk2SahVXWFsA@mail.gmail.com>
 <CAF+0mvk1tq03iVgVHGLMmarmG8XNjGqiWebSqBjJVUOEW5j-Lg@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 3 Apr 2018 15:06:35 -0500
Message-ID: <CAB-428kJrcOxH_s+meWvQzxKShHzkwU=yVGampwPiGUe88JPSQ@mail.gmail.com>
Subject: Re: Terse output header ?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

On Tue, Apr 3, 2018 at 2:48 PM, Matthew Eaton <m.eaton82@gmail.com> wrote:
> On Tue, Apr 3, 2018 at 11:18 AM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>> Is there any way that we can get the full header with Terse output?
>>
>> Without a header, it prints a long line which is very hard to count
>> and match the column with the definitions of columns in the howto
>> guide. Moreover, some columns that are defined in the howto might be
>> missing in my output and therefore, it makes the script development to
>> use the terse output very hard.
>>
>>
>> --
>> Alireza
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> This might be helpful if you're using the default terse version.
> https://www.andypeace.com/fio_minimal.html

Thanks, that is exactly what I need. This indexes should be part of
the user guide IMO.
