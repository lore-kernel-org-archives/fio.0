Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:50724 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfKLGzQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Nov 2019 01:55:16 -0500
Received: by mail-wm1-f52.google.com with SMTP id l17so1824822wmh.0
        for <fio@vger.kernel.org>; Mon, 11 Nov 2019 22:55:15 -0800 (PST)
MIME-Version: 1.0
References: <CAKaVHqeWbV67BF1chqihOpnfwuUcgzC4M1C755C7n-JK9U52vQ@mail.gmail.com>
In-Reply-To: <CAKaVHqeWbV67BF1chqihOpnfwuUcgzC4M1C755C7n-JK9U52vQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 12 Nov 2019 06:54:48 +0000
Message-ID: <CALjAwxiAWYjyn_2yeJbpc8Sx1hLtpKdBktVNxyFWsVQfP=2SwA@mail.gmail.com>
Subject: Re: Logging using "write_bw_log" seems off
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shivam Dhir <dhirs1@uci.edu>
Cc: fio <fio@vger.kernel.org>

Hi Shivam,

On Tue, 12 Nov 2019 at 00:37, Shivam Dhir <dhirs1@uci.edu> wrote:
>
> Hi
>
> I was trying to draw some performance graphs executing a sequence like
>
> 1 Sequential write
> 3 Random writes
> 25% trim command
> 3 Sequential writes
>
> I observed a discrepancy in the bandwidth logging for last two
> sequential writes.
> I notice that the last two sequential writes differ by 300 MB/s but
> the last individual reading of these logs indicate that the slower
> sequential write actually took slightly less time to complete.
> Capacity is 4TB.
>
> Can you provide some inputs if this is a known issue?
> I am using fio-2.2.10.

This might have been fixed. Does this still happen when you use a
recent fio (e.g. 3.16 - see https://github.com/axboe/fio/releases for
what we're up to)?
-- 
Sitsofe | http://sucs.org/~sits/

