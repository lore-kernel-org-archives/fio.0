Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:35105 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbdIAVFb (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Sep 2017 17:05:31 -0400
Received: by mail-ua0-f172.google.com with SMTP id c27so3722494uah.2
        for <fio@vger.kernel.org>; Fri, 01 Sep 2017 14:05:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABhOJBQNWMipsS1do7rfRP578uxBQAG_LAfPWVCv_Fhz0EQbMw@mail.gmail.com>
References: <CALjAwxh2Uy1dbBTndB1i=gRLhXCAgSMwqQmwoQvU1t7p9HeVKQ@mail.gmail.com>
 <CABhOJBQNWMipsS1do7rfRP578uxBQAG_LAfPWVCv_Fhz0EQbMw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 1 Sep 2017 22:05:00 +0100
Message-ID: <CALjAwxhyNkNW3ySL0hPw00uHVOy0ZFksKdsBC-EMJEsK17UVkQ@mail.gmail.com>
Subject: Re: generating unique offsets
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 31 August 2017 at 10:13, Elhamer Oussama AbdelKHalek
<abdelkhalekdev@gmail.com> wrote:
>
> On Wed, Aug 30, 2017 at 8:21 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> On 30 August 2017 at 14:16, Elhamer Oussama AbdelKHalek
>> <abdelkhalekdev@gmail.com> wrote:
>>
> I got the same result at my end. The thing is that at first i didn't
> know you could dump the generated offsets using  --debug=io , so i've
> printed the values of '*b' for 8 different seeds (--size=2m --bs=128k
> --rw=randwrite --ioengine=libaio) explicitly ( printf the values in
> the source code / recompile fio), the result contains  collisions!
>
> If i am understanding correctly, when a generated random value is
> already in the axmap table, another one will be generated!
> Here a dump fo both  b* and  off values (16 offsets)
> https://gist.github.com/SamTheDev/29ede9f3ef2466c5b5d2e026f4bd2aec
>
> Where exactly the *b offset is updated (according to axmap table) in
> the code? and does that mean that changing only the *b value for a
> custom random generator won't do the trick?

See https://github.com/axboe/fio/blob/fio-3.0/io_u.c#L129 where b can
be "corrected" by axmap_next_free().

>> I should have asked - what performance were you expecting to see?
>>
> Sorry, i forgot to mention that the drive was fully written and
> partially trimmed before running the randwrite job.
> On a full nvme drive, i ran a randtrim job, after a reasonable delay i
> ran the randwrite job using the same rand-seed. My drive bandwidth can
> go up to 1.4 Gb/s, when using the default TAUSWORTHE random generator
> the bw was around 150 Mb/s, which sounds reasonable, but when using
> the Fisher-yates generator  i was getting top performance (around 1.3
> Gb/s!)
> the job files look something like that:
> [global]
> ioengine=libaio
> iodepth=256
> size=1117G
> direct=1
> do_verify=0
> continue_on_error=all
> filename=/dev/nvme0n1
> randseed=23534
> sync=1
> [write-job]
> rw=randwrite / randtrim
> bs=128k

I don't have a good explanation for this other than to check that the
contents of the blocks being written looks suitably random and to plot
the sequence numbers your Fisher/Yate algorithm generates. Another
thing to try is using fio's record/replay facilities
(http://fio.readthedocs.io/en/latest/fio_doc.html#i-o-replay  ) to
recheck the order but with different data.

-- 
Sitsofe | http://sucs.org/~sits/
