Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:51177 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgA1UbR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Jan 2020 15:31:17 -0500
Received: by mail-wm1-f52.google.com with SMTP id a5so3966686wmb.0
        for <fio@vger.kernel.org>; Tue, 28 Jan 2020 12:31:15 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV7Hzs_TbhGsAXoFUP55oGQGeDot+c8Dh3RcLjWrxbqO9Q@mail.gmail.com>
In-Reply-To: <CAHEKYV7Hzs_TbhGsAXoFUP55oGQGeDot+c8Dh3RcLjWrxbqO9Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Jan 2020 20:30:48 +0000
Message-ID: <CALjAwxh3k_nQTFnbin=swLV5NCfervPnk57YfM_1GV-b4f0EhA@mail.gmail.com>
Subject: Re: clock setaffinity failed: Invalid argument
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hii,

On Mon, 27 Jan 2020 at 18:25, Mauricio Tavares <raubvogel@gmail.com> wrote:
>
> I am seeing a lot of those errors:
>
> run write in 512K(1)][90.3%][w=1942MiB/s][w=7766 IOPS][eta 03m:13s]
> clock setaffinity failed: Invalid argument
> clock setaffinity failed: Invalid argument
> clock setaffinity failed: Invalid argument
> [...]
> clock setaffinity failed: Invalid argument
> Jobs: 1 (f=1): [W(1)][45.2%][w=2010MiB/s][w=4019 IOPS][eta 18m:07s]
>
> According to https://github.com/axboe/fio/issues/46, I would expect to
> see a bit more descriptive error (I am compiling using source checked
> out of https://github.com/axboe/fio on Fedora 31 on Intel), but that
> is not the case. Any suggestions of what I should be looking into?

Are you doing this in a container or in some sort of sandbox?

-- 
Sitsofe | http://sucs.org/~sits/

