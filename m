Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAB8+yyV+-vHSY7-iN0w6GY5Ukj-wt_oS064W+O7n6rO+rFmT8A@mail.gmail.com>
References: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
 <8e8a7151-9329-cdee-2100-3f94c5dd1b1f@kernel.dk> <CALjAwxgN=+PPByGL_ZQhq9RjTgzYE8h83NEapYtDDSSUAqDuuw@mail.gmail.com>
 <CAB8+yyU-uZoyQgx_P0U=xhi9dA5y6D+bOW2BaQzDfEFH4j9+LA@mail.gmail.com> <CAB8+yyV+-vHSY7-iN0w6GY5Ukj-wt_oS064W+O7n6rO+rFmT8A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 10 May 2017 19:38:21 +0100
Message-ID: <CALjAwxhY23YmTJ5dYbe1pHs31MHP7wZCOXTAYX5LO=Kff_iMKg@mail.gmail.com>
Subject: Re: Fio Checksum tracking and enhanced trim workloads
Content-Type: text/plain; charset=UTF-8
To: paul houlihan <phoulihan9@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

For some reason Paul's emails don't seem to be going to the list -
Paul are you using a non-gmail SMTP server but using a gmail address?

On 9 May 2017 at 02:01, paul houlihan <phoulihan9@gmail.com> wrote:
> The second sentence was incorrect.
>
> It should read: I would like the changes at
> https://github.com/phoulihan9/fio/pull/1/commits  to be reviewed and
> considered for inclusion to fio.
>
> On Mon, May 8, 2017 at 4:05 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> > -------- Forwarded Message --------
>> > Subject:        Fio Checksum tracking and enhanced trim workloads
>> > Date:   Sun, 7 May 2017 23:54:16 -0400
>> > From:   paul houlihan <phoulihan9@gmail.com>
>> > To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
>> >
>> > I have a submission for fio that enhances the data corruption detection
>> > and diagnosis capabilities taking fio from pretty good corruption detection
>> > to absolute guarantees. I would like these changes on the tracking
>> > branch???? to be reviewed and considered for inclusion to fio. A quick
>> > review would be helpful as I am losing access to test systems shortly.

On 9 May 2017 at 02:51, paul houlihan <phoulihan9@gmail.com> wrote:
> Let me know if the changes are not accessible. I am new to github and not
> sure I am doing it right. They are reviewable for me using the
> aforementioned link..

I've posted some comments up on Github. Are they visible to you? I
think the key thing is it would help if the commit was to be split up
into smaller commits...

> I can look at Sitsofe overlapping changes but I don't have a lot of time for
> major rework. What is here works fairly robustly, is quite useful and that
> is what I am offering. Although I realize that there is huge number of fio
> arguments and there might still be contradictions I don't use. I can rework
> it a bit if there are small issues to tackle.
>
> I have not spent a lot of time using bsrange. I am usually interested in
> stressing specific block sizes. I think it will all just work as long as no
> overlapping I/O results.

Sadly overlapping I/O often turns up with random block sizes.

>> Are you sure? I thought readwrite verifying workloads caused the reads
>> to be verifying if the block had been written in the same workload?
>
> Yes for read/write workload, all writes do result in a read verification.
> However that still leaves unverified those blocks that were only read and
> never written in this workload. That's not acceptable if your requirement is
> absolute data integrity guarantees. My goal was that all reads (and for that
> matter trims) in all workloads be verified including those blocks written by
> a prior fio job or even a prior fio run on a different virtual machine. The
> current fio verifies all read blocks only for read-only workloads where it
> assumes a prior job has initialized the blocks.

>> Many would find this useful. Perhaps it could be ported to C like
>> t/verify-state.c ?
> Yes I wish I had done it in C and there would be no extra dependency on
> python for troubleshooting. Also the C could use the definition in verify.h
> in case the header ever changes. However python is ubiquitous so it seems a
> minor dependency. I could consider this if the list of requested changes is
> doable.

OK.

>> How does this interact with verify_state_*
> Again something I have not stress. Bear in mind that if fio aborts on an
> error the verify log is not created as this can lead to false corruption
> detection. Note control-c is a normal exit and the tracking log is preserved
> in this case. However it should just work if the tracking log is preserved.
> I thought about tracking checksums within verify state but it was not easily
> extended to track all checksums for all blocks.

Fair enough.

-- 
Sitsofe | http://sucs.org/~sits/

