Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f53.google.com ([209.85.128.53]:34000 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfC2GIN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Mar 2019 02:08:13 -0400
Received: by mail-wm1-f53.google.com with SMTP id o10so8855217wmc.1
        for <fio@vger.kernel.org>; Thu, 28 Mar 2019 23:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <7A42A364-CFE4-4D0D-8CE1-452F565D9170@suse.com>
In-Reply-To: <7A42A364-CFE4-4D0D-8CE1-452F565D9170@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Mar 2019 06:07:47 +0000
Message-ID: <CALjAwxg-LZaQ-YL6RJ2337+=T7QKAkdn8mRQQe0eONcAEXsjSg@mail.gmail.com>
Subject: Re: bsrange split
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Byte <dbyte@suse.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello David,

On Thu, 28 Mar 2019 at 23:07, David Byte <dbyte@suse.com> wrote:
>
> I am trying to figure out how I would do a test where I have multiple ranges of block sizes with a percentage distribution assigned to each range.
>
> Something like this but works and reports the io data for each range: fio --bssplit=1k-8k/10:8k-128k/50 --name=test --rw=randrw --time_based=1 --runtime=30 --size=1G --filename=/tmp/test.
>
> Clearly using a jobfile with named sections is a start, but I'm not sure how to control the distribution of I/O between the sections?
>
> Thoughts or better yet an example?

I can give a thought... If you are trying to distribute I/O *between
two sections* you can look towards flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
). If you need it between N>2 sections (and not just pairs) I don't
think flow is going to be good enough and I don't have any suggestions
(yes multiple sections can work with the same counter but there are
only two sides to it's more like a tug of war).

What would be excellent is if someone were to add a feature that
allows flow to work in a "shares" mode. Every active job could say how
many shares they have and then each time they do I/O a share is used
and you can only do I/O while your shares are above 0. A job's shares
would only be replenished after every job's shares have become 0. I
suppose so long as the total shares added up to 100 people could even
see them percentages (but that may be a bit bursty and maybe you want
to try and order the jobs' "goes" in a way that everyone's shares to
drop to 0 at roughly the same time). There's also issues around jobs
that finish early while others are ongoing and jobs etc. but I still
think it could be made to work.

-- 
Sitsofe | http://sucs.org/~sits/

