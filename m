Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38313 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbcGSQJE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Jul 2016 12:09:04 -0400
Received: by mail-wm0-f44.google.com with SMTP id o80so32494203wme.1
        for <fio@vger.kernel.org>; Tue, 19 Jul 2016 09:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOxGABnv+cYYmVDQCiiZacp5EO+6tVKCnFRdJmgNzewn3eNzFw@mail.gmail.com>
References: <CAOxGABnCmZ6GTrGdL2hMZCTs6hRr5as-QhPtn9opwkrCnbt+1A@mail.gmail.com>
 <CAOxGABnv+cYYmVDQCiiZacp5EO+6tVKCnFRdJmgNzewn3eNzFw@mail.gmail.com>
From: Charlie Jacobsen <charlie.jacobsen@gmail.com>
Date: Tue, 19 Jul 2016 10:09:01 -0600
Message-ID: <CAOxGABnJr9fUPb34z7x2CUYK9FfDTRuhBEJWKGhgR-SGEdBUcw@mail.gmail.com>
Subject: Re: Verification without using headers
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Ah, I think I now see why write IO logging was shifted to submission
time - rand_seed mismatch problems. (Perhaps there are other reasons?)
Well, unless I'm missing something, I think that can be resolved by
storing the expected rand_seed in the log io piece (this is also
necessary for my new verification mode, and is the technique I'm
following for that).

It would still be nice to have verifysort be cheap, and it might be a
bit hard to make it as cheap when IO logging is shifted to completion
time.

On Mon, Jul 18, 2016 at 7:21 PM, Charlie Jacobsen
<charlie.jacobsen@gmail.com> wrote:
> I would also be open to discussing future plans for verification
> features in fio in another thread (there are others I plan to add).
> For example, perhaps you have plans for experimental_verify (I
> understand the intent behind this feature - no logging for
> verification).
>
> On Mon, Jul 18, 2016 at 6:51 PM, Charlie Jacobsen
> <charlie.jacobsen@gmail.com> wrote:
>> Hello,
>>
>> I'm working on a new verification mode that allows for filling entire
>> blocks with random data (no header is used). I would like some
>> feedback as I plan to submit the patch and I don't want to encounter
>> the same pitfalls you guys have likely encountered.
>>
>> With just a handful of simple changes, the new verification mode works
>> in combination with verify_backlog, verify_only (as long as fio is
>> seeded the same way), and io_size > size with norandommap=1 (blocks
>> can be overwritten).
>>
>> The biggest challenge I still face is getting this working with
>> blocksize ranges in combination with io_size > size and norandommap=1
>> (blocks can be overwritten, with varying block sizes). I understand
>> how this magically works when headers are used, but I won't have that
>> luxury. I would also like to use blocksize_unaligned in combination
>> with these other settings for full generality, which has limited
>> support right now.
>>
>> Here is a sketch of my plan:
>>
>> -- I plan to improve the code inside log_io_piece that updates the log
>> tree. When a write IO is inserted into the tree, prior log entries
>> that overlap will be shrunk, or discarded if the new write fully
>> overlaps.
>>
>> -- However, IOs are logged at submission time. If they fail, the
>> shrunk or discarded log entries in the tree would need to be restored.
>> This seems complicated. Instead, I think it makes more sense to move
>> log entry creation to completion time.
>>
>> -- I understand a lot of effort went into moving all write IO logging
>> to submission time (I've looked through some of the commits). Is there
>> any reason why submission time was chosen, e.g. any hardware or
>> low-level IO reasons? Any pitfalls or big disadvantages if IO logging
>> is moved to completion time?
>>
>> -- I plan to leverage the numberio field in the struct io_u as a way
>> to order write IOs at completion time. I will change the type of this
>> field to a uint64_t so it doesn't wrap. Of course, this change will
>> percolate into other parts of fio and make some data structures a bit
>> bigger (e.g., the struct verify_header).
>>
>> What do you think?
>>
>> Thanks for you time.
>>
>> Charlie Jacobsen
>> Primary Data
