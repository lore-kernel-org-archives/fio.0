Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52699 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfJCIEq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Oct 2019 04:04:46 -0400
Received: by mail-wm1-f44.google.com with SMTP id r19so1469330wmh.2
        for <fio@vger.kernel.org>; Thu, 03 Oct 2019 01:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
 <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com> <CABO+gV-rjH3CJw6-G2Oj2DZ4xOb7v7VNx_aocqU3iwODZPvBtQ@mail.gmail.com>
In-Reply-To: <CABO+gV-rjH3CJw6-G2Oj2DZ4xOb7v7VNx_aocqU3iwODZPvBtQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 3 Oct 2019 09:04:17 +0100
Message-ID: <CALjAwxhRz6OVURRTmTyUrnN+7pLy0SpC94NEE3izJyd2Gu3yfg@mail.gmail.com>
Subject: Re: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

On Tue, 1 Oct 2019 at 01:15, Elliott Balsley <elliott@altsystems.com> wrote:
>
> No, after 60 seconds it is still going.  Sometimes kill -9 works, but
> not always.  Sometimes it leaves the [fio] process showing in ps and
> disk activity continues.  This is frustrating, not having a proper way
> to quit.

This sounds unexpected. Are there easy reproduction steps for this? Is
I/O definitely being processed by the lower levels of the kernel?

-- 
Sitsofe | http://sucs.org/~sits/

