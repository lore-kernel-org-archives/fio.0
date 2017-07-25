Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:37009 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGYGXr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2017 02:23:47 -0400
Received: by mail-ua0-f181.google.com with SMTP id f9so95624289uaf.4
        for <fio@vger.kernel.org>; Mon, 24 Jul 2017 23:23:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457186B80B40D775D03BF3B8FBB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457186B80B40D775D03BF3B8FBB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 25 Jul 2017 09:23:06 +0300
Message-ID: <CAHndrBkwcr6N+uJhyAixt81cmz+PFR6xk+q_r1VaG2AD82j5Pw@mail.gmail.com>
Subject: Re: fio Windows Invalidate
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Yes, it did change the behavior to print ENOTSUP message if
invalidation isn't supported (i.e. true on non Linux) for a block
device.
Nothing has changed other than printing it.

I've also confirmed this, but what makes this confusing is that
strerror(ENOTSUP) prints "Unknown error" on Cygwin.
I'll send a patch to make this less confusing or just not print it on ENOTSUP.


2017-07-25 2:31 GMT+03:00 Jeff Furlong <jeff.furlong@wdc.com>:
> Hi All,
> Commit 22de5d7741f963e57dd5e3bb70d822e992dd2515 seems to have changed how Windows works with the default invalidate parameter.  Previously it was not needed to specify invalidate=0, but now it is needed on Windows.  Without it, fio reports:
>
> fio-2.21
> Starting 1 thread
> fio: cache invalidation of \\.\PHYSICALDRIVE1 failed: Unknown error
> fio: cache invalidation of \\.\PHYSICALDRIVE1 failed: Unknown error
>
> Is the expectation that Windows default invalidate (1) should silently ignore this issue, or must the user specify invalidate=0 on Windows platforms?  Thanks.
>
> Regards,
> Jeff
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
