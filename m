Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f175.google.com ([209.85.166.175]:33928 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387403AbfEWRd0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 13:33:26 -0400
Received: by mail-it1-f175.google.com with SMTP id g23so8821046iti.1
        for <fio@vger.kernel.org>; Thu, 23 May 2019 10:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
 <CALjAwxgYk51y7hap2aHKwMrKWPjDdkS0CAyk=wf4-5DW6OaDwg@mail.gmail.com>
 <CAPqbHXhjmOR5hfXbTYcDTjhqH=1HDVKGCe_FOwgd+udCEuCb1g@mail.gmail.com> <CALjAwxi0K+Nig4fgszqQNyFtGxF+gsD2xwnSj3HX0eE0xmctFQ@mail.gmail.com>
In-Reply-To: <CALjAwxi0K+Nig4fgszqQNyFtGxF+gsD2xwnSj3HX0eE0xmctFQ@mail.gmail.com>
From: Prabhakaran <prabhugce@gmail.com>
Date: Thu, 23 May 2019 11:33:13 -0600
Message-ID: <CAPqbHXj5kwiObCefXNL0EwmW2i_kZG+Q1AVAu5zGyqpBO9aV+Q@mail.gmail.com>
Subject: Re: Sequential Writes and Random Reads in parallel
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Sitsofe,

Yes, as you said the jobs are tethered running at the slowest job's
speed. How can I make one job run faster and the other one slower?

Thanks,
Prabhu

On Thu, 9 May 2019 at 00:33, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> On Mon, 6 May 2019 at 19:54, Prabhakaran <prabhugce@gmail.com> wrote:
> >
> > Looks like percentage_random option would not work, as I would be
> > needing IOPs log data for sequential and random separate. Your
> > alternate option, with having separate jobs and controlling the ratio
> > using flow, works fine. But, I'm seeing a significant performance drop
> > when flow is introduced, although random and sequential ratio looks
> > fine. Below is the comparison table with values in IOPs.
>
> <snip>
>
> > As you can see, with pure random, the IOPs is at 204131. And when flow
> > is set to 50%, iops drops down to 1318 for random. I would expect
> > something like 100k iops for random as that workload is set to
> > function for 50%. Is my assumption wrong?
>
> Are you sure your writes are as fast as your reads? When you use flow
> the jobs are tethered so ultimately you will go at the speed of the
> slowest job...
>
> --
> Sitsofe | http://sucs.org/~sits/

