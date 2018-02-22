Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:40055 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbeBVVPv (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Feb 2018 16:15:51 -0500
Received: by mail-ua0-f181.google.com with SMTP id t6so4263555ual.7
        for <fio@vger.kernel.org>; Thu, 22 Feb 2018 13:15:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALBCzHdb+dtY1GbMYU8G6v3FPV=kkTVHN=Rcn43xf4r02tEOag@mail.gmail.com>
References: <CALBCzHdb+dtY1GbMYU8G6v3FPV=kkTVHN=Rcn43xf4r02tEOag@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 22 Feb 2018 21:15:20 +0000
Message-ID: <CALjAwxgTRnZ7R4-AYyS0OXTAUksBxbnZcQczuokkbNsiprUvcw@mail.gmail.com>
Subject: Re: reduce the size of log files
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: RomanS <execooler@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 22 February 2018 at 20:58, RomanS <execooler@gmail.com> wrote:
>
> I'm trying to run with generating log files to be able to plot the results.
>
> My test is running during 10 mins and the result files are huge.

You don't say which sort of logging you're doing but have you seen the
log_avg_msec option
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-log-avg-msec
)?

"By default, fio will log an entry in the iops, latency, or bw log for
every I/O that completes. When writing to the disk log, that can
quickly grow to a very large size. Setting this option makes fio
average the each log entry over the specified period of time, reducing
the resolution of the log."

-- 
Sitsofe | http://sucs.org/~sits/
