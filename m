Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:63365 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaLCTpa (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Dec 2014 14:45:30 -0500
Received: by mail-la0-f46.google.com with SMTP id q1so8115722lam.5
        for <fio@vger.kernel.org>; Wed, 03 Dec 2014 11:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 3 Dec 2014 22:45:08 +0300
Message-ID: <CANvN+e=_YQGD3CtDD+1+8__oXNS8TcCwTuA-nvis9Np0Azwq7g@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Karthick Srinivasachary <karthick@pernixdata.com>
Cc: fio@vger.kernel.org

On Wed, Dec 3, 2014 at 9:48 PM, Karthick Srinivasachary
<karthick@pernixdata.com> wrote:
> Hi Folks,
>
> I have question. Any feedback appreciated..!
>
> With buffer_compress_percentage, fio writes random data + zeros.
>
> Is there a way to write random data + repeat_pattern (instead of
> zero's). Pattern can be any user given pattern.

fio has a verification mode based on user-specified pattern (in
verify_pattern mode). May be you can merge this with compression, to
get you where you want to be.

HTH,
Andrey

>
> Thanks in advance.
> -Karthick
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
