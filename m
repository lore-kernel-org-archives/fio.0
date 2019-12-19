Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36437 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfLSHUG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Dec 2019 02:20:06 -0500
Received: by mail-wm1-f52.google.com with SMTP id p17so4485387wma.1
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 23:20:05 -0800 (PST)
MIME-Version: 1.0
References: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
 <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com>
 <CABO+gV-rjH3CJw6-G2Oj2DZ4xOb7v7VNx_aocqU3iwODZPvBtQ@mail.gmail.com>
 <CALjAwxhRz6OVURRTmTyUrnN+7pLy0SpC94NEE3izJyd2Gu3yfg@mail.gmail.com>
 <CABO+gV8xNYo-aJ0hpr48z87tSxG7Yu6_HbmcRrZ+0AB969yyKQ@mail.gmail.com>
 <CALjAwxhPCTyFxoYOYAwJjA+TjGpwvGCCCkNuhMFSi-_OXWBoqw@mail.gmail.com> <CABO+gV9smN4-A3nMKnHXDbH1BCXnkfWpQScV_9akqqtzO_p5kw@mail.gmail.com>
In-Reply-To: <CABO+gV9smN4-A3nMKnHXDbH1BCXnkfWpQScV_9akqqtzO_p5kw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 07:19:40 +0000
Message-ID: <CALjAwxh82pascdnGQdfyrJg2HkuYRATYT69ktrDNYVyRQknBRw@mail.gmail.com>
Subject: Re: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

On Sat, 5 Oct 2019 at 20:51, Elliott Balsley <elliott@altsystems.com> wrote:
>
> Thanks, I had not noticed the D state.  I learn something every day.
> I am indeed using NFS hard mount, but when this issue happens there is
> no problem with the mount itself.  Other apps can read/write just
> fine.  So maybe this could be improved by making fio do interruptible
> sleep?  Usually this happens when I accidentally start a job with a
> size much higher than I intended.

(Sorry for the late reply) It's not fio's choice - it's the kernel's.
Fio is doing I/O down to a file (maybe just that file is causing the
NFS server heartache?) and the kernel chooses whether doing that I/O
makes the task (hopefully temporarily) uninterruptible. Your other
tasks might not be doing enough NFS I/O to get caught out (presumably
the queue of I/O is backing up) and/or you don't spot them hanging
because you're not actively killing them.

-- 
Sitsofe | http://sucs.org/~sits/

