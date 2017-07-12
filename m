Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34013 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdGLG0r (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Jul 2017 02:26:47 -0400
Received: by mail-ua0-f179.google.com with SMTP id z22so8364371uah.1
        for <fio@vger.kernel.org>; Tue, 11 Jul 2017 23:26:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
References: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 12 Jul 2017 07:26:15 +0100
Message-ID: <CALjAwxjpBN+JQcCZ4tK7G+m-091NJv083SKgwoD1_bQo1Ge0mw@mail.gmail.com>
Subject: Re: unexpected stonewall parsing led jobs separated by stonewall to
 run concurrently
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ido Ben-Tsion <idob@infinidat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 12 July 2017 at 06:13, Ido Ben-Tsion <idob@infinidat.com> wrote:
> fio version: fio-2.21-37-ga2c9
>
> fio file excerpt:
> [global]
> ioengine=sg
> invalidate=1
> ramp_time=5
> iodepth=16
> runtime=300
> time_based
> bs=64k
> norandommap
> loops=5
>
> [seq_read-2-jobs]
> rw=read
> numjobs=2
> stonewall
>
> [randread]
> rw=randread
> [seq_write]
> rw=write
> stonewall
> ...
>
> In the report, I see jobs with groupid 0 which are not supposed to be
> on same group:
> ...,jobname,groupid,...
> ...,seq_read-2-jobs,0,...
> ...,seq_read-2-jobs,0,...
> ...,randread,0,...
> ...,seq_write,1,...

I'm not sure I follow - which jobs are wrong? Looking at the opening
sentence explanation (and the alternative name) for stonewall in the
HOWTO (http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-stonewall
) seems to describe the behaviour you're seeing.

Can you be more explicit as to the problem?

-- 
Sitsofe | http://sucs.org/~sits/
