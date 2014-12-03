Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49340 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLCTtr (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Dec 2014 14:49:47 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so20815555wgh.3
        for <fio@vger.kernel.org>; Wed, 03 Dec 2014 11:49:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANvN+e=_YQGD3CtDD+1+8__oXNS8TcCwTuA-nvis9Np0Azwq7g@mail.gmail.com>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
 <CANvN+e=_YQGD3CtDD+1+8__oXNS8TcCwTuA-nvis9Np0Azwq7g@mail.gmail.com>
From: Karthick Srinivasachary <karthick@pernixdata.com>
Date: Wed, 3 Dec 2014 11:49:25 -0800
Message-ID: <CAGmU4NTBsARGCwpHRf-OobPOmHZpPM5zZ5VaF7xxnHr99HMFCA@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org

Thanks. I tried that.
With verify_pattern='"pattern", pattern is not repeated matching
buffer_compression_percentage.

-Karthick

On Wed, Dec 3, 2014 at 11:45 AM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> On Wed, Dec 3, 2014 at 9:48 PM, Karthick Srinivasachary
> <karthick@pernixdata.com> wrote:
>> Hi Folks,
>>
>> I have question. Any feedback appreciated..!
>>
>> With buffer_compress_percentage, fio writes random data + zeros.
>>
>> Is there a way to write random data + repeat_pattern (instead of
>> zero's). Pattern can be any user given pattern.
>
> fio has a verification mode based on user-specified pattern (in
> verify_pattern mode). May be you can merge this with compression, to
> get you where you want to be.
>
> HTH,
> Andrey
>
>>
>> Thanks in advance.
>> -Karthick
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
