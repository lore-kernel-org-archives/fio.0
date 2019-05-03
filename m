Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:33729 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfECFTJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 May 2019 01:19:09 -0400
Received: by mail-wr1-f46.google.com with SMTP id e28so6179524wra.0
        for <fio@vger.kernel.org>; Thu, 02 May 2019 22:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAJQBtgm5kTYnn0Qjs_CHXDqirr+7=qVhev0ScXq0x6wxoib8QQ@mail.gmail.com>
 <AT5PR8401MB11693A24BC27035F38619B85AB340@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAJQBtgksHEjb5oR-yA2eUHkDyuiboLc+MPV-dWJLNdm8v04YWw@mail.gmail.com>
In-Reply-To: <CAJQBtgksHEjb5oR-yA2eUHkDyuiboLc+MPV-dWJLNdm8v04YWw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 3 May 2019 06:19:33 +0100
Message-ID: <CALjAwxhXwjbmEtry40DzJkfp3QO7EHZEuCo0Gqo4gXq1aJ208w@mail.gmail.com>
Subject: Re: How do reads and writes overlap?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Left Right <olegsivokon@gmail.com>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, 2 May 2019 at 19:31, Left Right <olegsivokon@gmail.com> wrote:
>
> Thanks a lot for your answer. Just to clarify, the reason I wanted to
> know this isn't really data validation. It's important for
> understanding of the results of my benchmarks. Since the program that
> I'm testing is a kind of iSCSI server, which needs to, for example,
> acknowledge writes based on user's policy pertaining as to how far the
> data had propagated, a read from a block with a write pending might be
> served from the server's cache, rather than going the full circle to
> the physical storage and back.
>
> Thus, understanding the percentage of such overlaps would be very
> important for me. So, I was wondering if there is any way of
> controlling this behavior.

What Robert said is definitely a way to achieve what you're interested
in - if you use verify_backlog
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-backlog
) along with all the usual verify options your reads will be only for
data that has been written. A different option to look at if you're
only worried about avoiding collisions between pending I/Os is
serialize_overlap
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-serialize-overlap
)...

-- 
Sitsofe | http://sucs.org/~sits/

