Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37852 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbfC2Gg1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Mar 2019 02:36:27 -0400
Received: by mail-wm1-f47.google.com with SMTP id v14so1423222wmf.2
        for <fio@vger.kernel.org>; Thu, 28 Mar 2019 23:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAKaVHqfGJnRP9mM_o8x+jY3e9Bq2XDieXssMU7J3VH6HTstrzQ@mail.gmail.com>
In-Reply-To: <CAKaVHqfGJnRP9mM_o8x+jY3e9Bq2XDieXssMU7J3VH6HTstrzQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Mar 2019 06:36:00 +0000
Message-ID: <CALjAwxj=N58RJRzydWBkOWPfcos1z37rpxPmTRiZsWc42dwQKA@mail.gmail.com>
Subject: Re: FIO Issue #755
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shivam Dhir <dhirs1@uci.edu>
Cc: fio <fio@vger.kernel.org>

Hi Shivam,

On Thu, 28 Mar 2019 at 16:56, Shivam Dhir <dhirs1@uci.edu> wrote:
>
> Hi
>
> Continuing the discussion on FIO issue #755 from the github page
>
> My intention is to simulate a mixed i/o for overlapped reads/writes.
> More specifically, I want some reads and write to be overlapped so
> that I can test a cache feature of a write i.e. if the write is still
> not written to NAND and there is a read issued for that specific data,
> I want to cover that edge case in my drive firmware.
>
> For this, I came up with 70-30 ratio for reads and writes respectively
> and used the following parameters: (changed from original post, I
> mistakenly put the wrong filename in ealier one)
>
> ./fio --ioengine=libaio --filename=/dev/nvme0n1 --direct=1 --bs=4K
> --rw=randrw --percentage_random=100,0 --rwmixread=70 --iodepth=128
> --do_verify=1 --verify=md5 --verify_interval=4096 --runtime=300
>
> My assumption here is that when I issue the above command, fio is
> doing some writes on some blocks and reads the same data. So with a
> do_verify=1, it should run fine. Is this correct?

rw=rw and rw=randrw jobs with verification is a tricky business. I
think there are open bugs about using that combination of options
(e.g. https://github.com/axboe/fio/issues/740 ).

> In view of the above, I am looking for further clarity on below things.
>
> sitsofe-->"This questions is vague... fio does I/O against specific
> points of the file so with your job above if fio chooses to do a read
> at offset 0 fio will read whatever the first 32 killobytes of the file
> is."
>
> Which file is being referred to here. Is it the same as being written?

My poor grammar aside (:-), in your case this depends on what the
filename option had inside (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
and especially the sentence starting "If the ioengine is file based").
In most cases only one file is specified (as above) so the file being
written is the same as the file being read.

> If not, then what is it reading if the drive is fully erased.

This will depend on whether the file existed before the job started or
not. If the job had to make the file it will ensure that it is full of
zeros. If the file (or in your case device) was already there and the
correct size etc. then what is read before a write will be whatever
was already in the file (or device).

> Also, If the read and write are independent i.e fio is writing
> something else and reading something else, what does do_verify=1 will
> be verifying then. My current assumption here is that do_verify=1
> verifies that read data was same as written data.

do_verify actually causes another phase to be done after the normal
job phase completes and this second phase will verify those areas that
were written.

> sitsofe-->"Not exactly but it is complicated."
>
> Your comment is suggesting that its reading some other blocks
> unrelated to where the writes are issued. If that is the case

(That is correct but it should hopefully not be verifying the data in them)

> 1. How can I make sure it is reading what I am writing through fio.
> 2. how the command needs to be modified simulate a overlapped
> read/writes as intended above.

Assuming by overlap you mean "and area that was touched at some point
in the past":

- If you are happy doing writes and only after they are all written
doing verification then just use a pure write job
(rw=write/rw=randwrite).
- If you want to verification to alternate with the writes you may
find verify_backlog
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-backlog
) and friends useful (by definition verifying reads will "overlap"
those areas written).
- If you don't care about the I/O being verified but you just want
"some writes and some reads in a balance" you could put the reading
and writing in seperate jobs and use flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
) to balance the jobs.
- If you don't want uniformity of your "random" reads (i.e. you don't
care if the same block is read multiple times and another block is
never read) you may want to turn the randommap off
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-norandommap
) on your reads.
- If you need to balance the verifying reads against normal writes I
don't know of a good way to do that. If we made the assumption that
jobs will have roughly a constant rate maybe after calculating the
bandwidth you could do it with asynchronous verifies and one of the
rate options (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rate
)?

> Thanks in advance!

Thanks for taking this to the list!

-- 
Sitsofe | http://sucs.org/~sits/

