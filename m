Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:33645 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJAAPy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 Sep 2019 20:15:54 -0400
Received: by mail-wr1-f46.google.com with SMTP id b9so13291137wrs.0
        for <fio@vger.kernel.org>; Mon, 30 Sep 2019 17:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
 <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com>
In-Reply-To: <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com>
From: Elliott Balsley <elliott@altsystems.com>
Date: Mon, 30 Sep 2019 17:15:40 -0700
Message-ID: <CABO+gV-rjH3CJw6-G2Oj2DZ4xOb7v7VNx_aocqU3iwODZPvBtQ@mail.gmail.com>
Subject: Re: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

> That should be as good as it gets for an abrupt stop outside of
> something like killall -9 fio. Don't you get some message about
> 'hasn't exited in 60 seconds, it appears to be stuck. Doing forceful
> exit of this job." after 60 seconds?

No, after 60 seconds it is still going.  Sometimes kill -9 works, but
not always.  Sometimes it leaves the [fio] process showing in ps and
disk activity continues.  This is frustrating, not having a proper way
to quit.

