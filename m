Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33375 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCTwd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Dec 2014 14:52:33 -0500
Received: by mail-lb0-f170.google.com with SMTP id w7so12965057lbi.29
        for <fio@vger.kernel.org>; Wed, 03 Dec 2014 11:52:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGmU4NTBsARGCwpHRf-OobPOmHZpPM5zZ5VaF7xxnHr99HMFCA@mail.gmail.com>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
 <CANvN+e=_YQGD3CtDD+1+8__oXNS8TcCwTuA-nvis9Np0Azwq7g@mail.gmail.com> <CAGmU4NTBsARGCwpHRf-OobPOmHZpPM5zZ5VaF7xxnHr99HMFCA@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 3 Dec 2014 22:52:11 +0300
Message-ID: <CANvN+e=KPSx6uY=B++FTyTjYE5UOYNf_xE9SqFnqncMm3eP+0A@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Karthick Srinivasachary <karthick@pernixdata.com>
Cc: fio@vger.kernel.org

On Wed, Dec 3, 2014 at 10:49 PM, Karthick Srinivasachary
<karthick@pernixdata.com> wrote:
> Thanks. I tried that.
> With verify_pattern='"pattern", pattern is not repeated matching
> buffer_compression_percentage.

It won't work out-of-the-box as it serves a totally different purpose,
needs some extra code.

Regards,
Andrey
>
> -Karthick
>
> On Wed, Dec 3, 2014 at 11:45 AM, Andrey Kuzmin
> <andrey.v.kuzmin@gmail.com> wrote:
>> On Wed, Dec 3, 2014 at 9:48 PM, Karthick Srinivasachary
>> <karthick@pernixdata.com> wrote:
>>> Hi Folks,
>>>
>>> I have question. Any feedback appreciated..!
>>>
>>> With buffer_compress_percentage, fio writes random data + zeros.
>>>
>>> Is there a way to write random data + repeat_pattern (instead of
>>> zero's). Pattern can be any user given pattern.
>>
>> fio has a verification mode based on user-specified pattern (in
>> verify_pattern mode). May be you can merge this with compression, to
>> get you where you want to be.
>>
>> HTH,
>> Andrey
>>
>>>
>>> Thanks in advance.
>>> -Karthick
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
