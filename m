Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34914 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbeDKH7q (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Apr 2018 03:59:46 -0400
Received: by mail-ua0-f169.google.com with SMTP id c3so570460uae.2
        for <fio@vger.kernel.org>; Wed, 11 Apr 2018 00:59:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
References: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 11 Apr 2018 08:59:15 +0100
Message-ID: <CALjAwxj56y_2eFaqz0aXpT3Pixgcy2QGgndhqTmnwB9g4ixj3w@mail.gmail.com>
Subject: Re: help about how to use latency options
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Larry Chen <lchen@suse.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 11 April 2018 at 07:48, Larry Chen <lchen@suse.com> wrote:
>
> I referred to the docs and examples but I'm still hard to understand how to
> use latency_target, latency_window and latency_percentile.
> Could any one help explain it in detail?
> Thanks in advance
>
> Sorry for that this letter might be resent to the list because my
> misoperation of subscribing fio mail list.

These options are used to probe the highest iodepth usable such that
the I/Os still have a latency equal to or below that of latency_target
on the basis that more asynchronous I/Os being sent at the same time
the higher each I/Os latency will be (this is what
http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-latency-window
is trying to say). latency_window controls the time window that I/Os
are considered over. latency_percentile is used to adjust the
sensitivity to outlier I/Os during this process so a single moment
high spike is ignored.

Any clearer?

-- 
Sitsofe | http://sucs.org/~sits/
