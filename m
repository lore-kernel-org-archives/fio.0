Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37975 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfIPLyX (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Sep 2019 07:54:23 -0400
Received: by mail-wm1-f41.google.com with SMTP id o184so9971485wme.3
        for <fio@vger.kernel.org>; Mon, 16 Sep 2019 04:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
In-Reply-To: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Sep 2019 12:53:55 +0100
Message-ID: <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com>
Subject: Re: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Mon, 16 Sep 2019 at 09:06, Elliott Balsley <elliott@altsystems.com> wrote:
>
> Hello.  Simple question, what is the best way to cancel an fio job in
> progress?  If I start a job with wrong options by mistake, I try
> Ctrl-C but this just prints "fio: terminating on signal 2" and the job
> continues.

That should be as good as it gets for an abrupt stop outside of
something like killall -9 fio. Don't you get some message about
'hasn't exited in 60 seconds, it appears to be stuck. Doing forceful
exit of this job." after 60 seconds?

--
Sitsofe | http://sucs.org/~sits/

