Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:34422 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfEIGda (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 May 2019 02:33:30 -0400
Received: by mail-wr1-f44.google.com with SMTP id f7so1278734wrq.1
        for <fio@vger.kernel.org>; Wed, 08 May 2019 23:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
 <CALjAwxgYk51y7hap2aHKwMrKWPjDdkS0CAyk=wf4-5DW6OaDwg@mail.gmail.com> <CAPqbHXhjmOR5hfXbTYcDTjhqH=1HDVKGCe_FOwgd+udCEuCb1g@mail.gmail.com>
In-Reply-To: <CAPqbHXhjmOR5hfXbTYcDTjhqH=1HDVKGCe_FOwgd+udCEuCb1g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 9 May 2019 07:33:02 +0100
Message-ID: <CALjAwxi0K+Nig4fgszqQNyFtGxF+gsD2xwnSj3HX0eE0xmctFQ@mail.gmail.com>
Subject: Re: Sequential Writes and Random Reads in parallel
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Prabhakaran <prabhugce@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Mon, 6 May 2019 at 19:54, Prabhakaran <prabhugce@gmail.com> wrote:
>
> Looks like percentage_random option would not work, as I would be
> needing IOPs log data for sequential and random separate. Your
> alternate option, with having separate jobs and controlling the ratio
> using flow, works fine. But, I'm seeing a significant performance drop
> when flow is introduced, although random and sequential ratio looks
> fine. Below is the comparison table with values in IOPs.

<snip>

> As you can see, with pure random, the IOPs is at 204131. And when flow
> is set to 50%, iops drops down to 1318 for random. I would expect
> something like 100k iops for random as that workload is set to
> function for 50%. Is my assumption wrong?

Are you sure your writes are as fast as your reads? When you use flow
the jobs are tethered so ultimately you will go at the speed of the
slowest job...

--
Sitsofe | http://sucs.org/~sits/

