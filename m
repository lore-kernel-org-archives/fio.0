Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:40897 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbeGGEYB (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Jul 2018 00:24:01 -0400
Received: by mail-vk0-f49.google.com with SMTP id s23-v6so7883405vks.7
        for <fio@vger.kernel.org>; Fri, 06 Jul 2018 21:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320ED986E73B1E9994929B38F470@MWHPR04MB0320.namprd04.prod.outlook.com>
References: <MWHPR04MB0320ED986E73B1E9994929B38F470@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 7 Jul 2018 05:23:29 +0100
Message-ID: <CALjAwxiTqn3U2vnOOCV1CZ3BkzXQ_KUaHK3wjw1WsbT5zg33rg@mail.gmail.com>
Subject: Re: fio serialize across jobs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 6 July 2018 at 23:14, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Hi All,
> Back in commit 997b5680d139ce82c2034ba3a0d602cfd778b89b "fio: add serialize_overlap option" the feature was added to prevent write/trim race conditions within the queue.  Can this feature be applied to multiple jobs?  Consider:
>
> fio --ioengine=libaio --direct=1  --filename=/dev/nvme0n1 --time_based --name=test1 --rw=randwrite --runtime=5s --name=test2 --rw=randwrite --runtime=5s --serialize_overlap=1
>
> Would we have to call in_flight_overlap() in a loop with all thread data pointers?

It would be a be more work (the original serialize_overlap was fiddly
to make correct but was easy to get going) but I can see why you might
want what you describe. The big problem is that I can't see how you
can do it without introducing a large amount of locking into the fio's
I/O path. I think this would also border on a feature that diskspd has
where multiple threads can do I/O to a single file but they all share
a randommap...

-- 
Sitsofe | http://sucs.org/~sits/
