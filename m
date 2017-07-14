Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34039 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdGNGVF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jul 2017 02:21:05 -0400
Received: by mail-vk0-f43.google.com with SMTP id r125so41652679vkf.1
        for <fio@vger.kernel.org>; Thu, 13 Jul 2017 23:21:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDrwFQ2QAqw4t9Er2QVf2mP3BaGKXGFWZ69opLfv+Vx8uA@mail.gmail.com>
References: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
 <CALjAwxi0aH0JH-dpemwA7F4k=D3TdE+kwmZkke77S=zZmYjtog@mail.gmail.com>
 <CAKwzdDqC_Ha0FzBNQMZK6MBcaZQXBZpTP0kKe3a5T6UTpZoYdw@mail.gmail.com>
 <CALjAwxgHOCfP-7=7V4bVRs5im0EbtXDbv3--P4wpaQNfFdb0eA@mail.gmail.com>
 <CAKwzdDrT1+=sp+apFvqfokbgTXLMa+RQ3qg9aamrt+Wtx-b1rQ@mail.gmail.com>
 <CALjAwxj3y37fKgTNooFSFqyyOURYwpMKu1_mWE_x3yichHmAXg@mail.gmail.com> <CAKwzdDrwFQ2QAqw4t9Er2QVf2mP3BaGKXGFWZ69opLfv+Vx8uA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 14 Jul 2017 07:20:33 +0100
Message-ID: <CALjAwxhV4uf_Wps_SQOEuFqUL3b+10dZbhJHEp6DU7dKZyrM-Q@mail.gmail.com>
Subject: Re: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Over on https://github.com/Microsoft/StorScore/blob/master/recipes/write_impact_check.rcp
the reads *must* be being capped otherwise what purpose does
$read_tput_KBps have? See the following:

        # Run the workload once undisturbed as a baseline.
        my %baseline =
            test( %workload, description => "$desc Baseline" );

        my $read_tput_KBps = $baseline{'MB/sec Total'} * 1000;
[...]

        # Run again, this time with an aggressor process injecting
        # writes in the background.  The aggressor is rate-limited
        # to a fraction of the baseline read throughput.
        foreach my $write_workload ( @write_workloads )
        {
[...]

            my $write_tput_KBps =
                int ( ( $write_pct / 100 ) * $read_tput_KBps );

The comment explains where the read "cap" came from. Briefly the
StoreScore program seems to be doing this:
1. Run DISKSPD briefly to find the random read throughput of the disk
and put this value into the prev_rand_read_tput variable.
2. seq_write_tput = prev_rand_read_tput * 10 / 100.
3. rand_read_tput = prev_rand_read_tput.
4. Run a detached DISKSPD at the same time as 4 that does sequential
writes but with a throughput cap of seq_write_tput.
6. Run a detached DISKSPD that does random writes but with a
throughput cap of rand_read_tput.

This strikes me as different to what you were proposing:
a) You said: "I want fio to do 10% 'this' / 90% 'that'"
b) That StorScore program does: "100% of 'that' capped to what I've
'previously measured that' can do, and 'this' capped to 10% of the
'previously measured that'".

"Previously measured" becomes fixed and won't be changing as the
subsequent DISKSPD processes are running. Further, the ratio in a)
isn't between the same things as the ratio in b) and the even the
ratio itself isn't the same!

For example, in the StorScore program imagine the baseline is
100MBytes/s. You start running 4. and 5. together and the DISKSPD
process at 4. immediately falls to 0 (e.g. the disk is weird and can't
do reads and writes simultaneously). That does not mean the step 5.
DISKSPD will limit its throughput to 0 and continues chugging away at
10MBytes/s. Thus the ratio between the step 4 DISKSPD and the step 5
DISKSPD quickly becomes 10:0.

You would have to talk to Microsoft as to why their StoreScore recipe
was written the way it is but the comments do suggest it was
intentional. It's worth noting DISKSPD itself can't balance entire
running "jobs" against each other but as previously mentioned that's
not what the StorScore program you linked is trying to do anyway...

On 13 July 2017 at 21:55, abhishek koundal <akoundal@gmail.com> wrote:
> Yes that is correct.
> So e.g. if you have RND_RD  b/w 45MBps and had 10%SEQ_WR 90%RND_RD the
> write throughput will be:
> =10/100 *45MBs = ~4.5MB/s
>
> Now if you try to cap the write throughput (rate =5m) to this in
> Linux, the RND_RD also gets impacted and wont run to its full
> potential.
>
> In StorScor reads thread will not get capped and only writes thread
> will be capped, hence deliver the expected results.
>
> On Thu, Jul 13, 2017 at 1:33 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hey,
>>
>> My Perl is a bit rusty but look at how the write throughput is calculated:
>>
>>         # Run again, this time with an aggressor process injecting
>>         # writes in the background.  The aggressor is rate-limited
>>         # to a fraction of the baseline read throughput.
>>         foreach my $write_workload ( @write_workloads )
>>         {
>>             my ($write_pattern, $write_pct) = @$write_workload;
>>
>>             my $write_tput_KBps =
>>                 int ( ( $write_pct / 100 ) * $read_tput_KBps );
>>
>> So it is accounting for the fact that the write throughput will be
>> limited to a percentage of the read throughput.
>>
>> On 13 July 2017 at 20:02, abhishek koundal <akoundal@gmail.com> wrote:
>>> Hi,
>>> The main thing that i am trying to do is to model the storScor in
>>> linux enviornment
>>> (https://github.com/Microsoft/StorScore/blob/master/recipes/write_impact_check.rcp).
>>> So there you can control the rate of the of the writes as per the %
>>> that is required. While running that on windows i can see that i can
>>> have different BS and rate defined for the runs achieving expected
>>> output.
>>>
>>> In the above mentioned case the RND_RD will be unconstrained (i.e.
>>> full BW they can achieve) but writes will be slowed to x% of RND_RD.
>>> In fio when
>>> e.g.
>>> SEQ_WR 10% and RND_RD 90%, with seq_wr rate capped at 10% of rnd rd
>>> (if rnd_rd was 40m)
>>> [SEQ_WR]
>>> rate=4m
>>> bs=128K
>>> rw=write
>>> flow=9
>>> [RND_RD]
>>> rate=40m
>>> bs=4k
>>> rw=randread
>>> flow=-1
>>> When i run this the output that comes back shows that SEQ_WR b/w is
>>> capped ~ 4m but RND_RD also gets severely hit for the IOPS+BW as it
>>> tried to put the total BW under <45m>. I want that RND_RD doesn't need
>>> to be capped and should run to it closest potential like I am see in
>>> storScor.
>>> Really appreciate for the support and helping me understand the limitations.
>>
>> --
>> Sitsofe | http://sucs.org/~sits/

-- 
Sitsofe | http://sucs.org/~sits/
