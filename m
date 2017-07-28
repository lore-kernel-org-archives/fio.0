Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34411 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdG1GcF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jul 2017 02:32:05 -0400
Received: by mail-ua0-f172.google.com with SMTP id q25so138050635uah.1
        for <fio@vger.kernel.org>; Thu, 27 Jul 2017 23:32:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145790BF6F19F8F52E278C908FB90@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB145790BF6F19F8F52E278C908FB90@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 28 Jul 2017 07:31:33 +0100
Message-ID: <CALjAwxiDDUy2Ra-7dT3hmXrTwXKj=joQNtsV3eCvtpqFmGE5DA@mail.gmail.com>
Subject: Re: fio Windows Time
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 27 July 2017 at 00:45, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> When fio prints a summary output in Linux, the timestamp appears correct with the Linux system date/time.  However, on Windows, the time reported seems to be incorrect (wrong time zone)?
>
>     test_job: (groupid=0, jobs=1): err= 0: pid=1928: Tue Jul 25 21:24:23 2017
>
> It looks like the fio timestamp is reported by stat.c, show_thread_status_normal():
>
>     memset(time_buf, 0, sizeof(time_buf));
>
>     time(&time_p);
>     os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
>
>     if (!ts->error) {
>         log_buf(out, "%s: (groupid=%d, jobs=%d): err=%2d: pid=%d: %s",
>             ts->name, ts->groupid, ts->members,
>             ts->error, (int) ts->pid, time_buf);
>
> Is there a better way to query system time on Windows platforms?  Thanks.

What time were you expecting, what time was printed, what timezone are
you in, which version of fio and which version of Windows? I've just
done a quick run with fio-2.99 Windows 2012 R2 and found the time fio
prints on Windows appears to be UTC.

The Windows code that constructs the string is ctime_r in
os/windows/posix.h
(https://github.com/axboe/fio/blob/fio-2.99/os/windows/posix.c#L239 ).
If you wanted to print timezone information at a guess this would
involve getting and parsing GetTimeZoneInformation
(https://msdn.microsoft.com/en-us/library/windows/desktop/ms724421(v=vs.85).aspx
) and ensuring the time you retrieved was the local system one.

-- 
Sitsofe | http://sucs.org/~sits/
