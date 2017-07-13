Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:32788 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752889AbdGMUeZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2017 16:34:25 -0400
Received: by mail-ua0-f180.google.com with SMTP id g13so22223257uaj.0
        for <fio@vger.kernel.org>; Thu, 13 Jul 2017 13:34:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDrT1+=sp+apFvqfokbgTXLMa+RQ3qg9aamrt+Wtx-b1rQ@mail.gmail.com>
References: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
 <CALjAwxi0aH0JH-dpemwA7F4k=D3TdE+kwmZkke77S=zZmYjtog@mail.gmail.com>
 <CAKwzdDqC_Ha0FzBNQMZK6MBcaZQXBZpTP0kKe3a5T6UTpZoYdw@mail.gmail.com>
 <CALjAwxgHOCfP-7=7V4bVRs5im0EbtXDbv3--P4wpaQNfFdb0eA@mail.gmail.com> <CAKwzdDrT1+=sp+apFvqfokbgTXLMa+RQ3qg9aamrt+Wtx-b1rQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 13 Jul 2017 21:33:54 +0100
Message-ID: <CALjAwxj3y37fKgTNooFSFqyyOURYwpMKu1_mWE_x3yichHmAXg@mail.gmail.com>
Subject: Re: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hey,

My Perl is a bit rusty but look at how the write throughput is calculated:

        # Run again, this time with an aggressor process injecting
        # writes in the background.  The aggressor is rate-limited
        # to a fraction of the baseline read throughput.
        foreach my $write_workload ( @write_workloads )
        {
            my ($write_pattern, $write_pct) = @$write_workload;

            my $write_tput_KBps =
                int ( ( $write_pct / 100 ) * $read_tput_KBps );

So it is accounting for the fact that the write throughput will be
limited to a percentage of the read throughput.

On 13 July 2017 at 20:02, abhishek koundal <akoundal@gmail.com> wrote:
> Hi,
> The main thing that i am trying to do is to model the storScor in
> linux enviornment
> (https://github.com/Microsoft/StorScore/blob/master/recipes/write_impact_check.rcp).
> So there you can control the rate of the of the writes as per the %
> that is required. While running that on windows i can see that i can
> have different BS and rate defined for the runs achieving expected
> output.
>
> In the above mentioned case the RND_RD will be unconstrained (i.e.
> full BW they can achieve) but writes will be slowed to x% of RND_RD.
> In fio when
> e.g.
> SEQ_WR 10% and RND_RD 90%, with seq_wr rate capped at 10% of rnd rd
> (if rnd_rd was 40m)
> [SEQ_WR]
> rate=4m
> bs=128K
> rw=write
> flow=9
> [RND_RD]
> rate=40m
> bs=4k
> rw=randread
> flow=-1
> When i run this the output that comes back shows that SEQ_WR b/w is
> capped ~ 4m but RND_RD also gets severely hit for the IOPS+BW as it
> tried to put the total BW under <45m>. I want that RND_RD doesn't need
> to be capped and should run to it closest potential like I am see in
> storScor.
> Really appreciate for the support and helping me understand the limitations.

-- 
Sitsofe | http://sucs.org/~sits/
