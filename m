Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3HACZh (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Jul 2013 22:25:37 -0400
Date: Wed, 31 Jul 2013 20:25:35 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO and Storage Data Integrity testing
Message-ID: <20130801022535.GF24569@kernel.dk>
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com>
 <51F98044.1080105@kernel.dk>
 <CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Juan Casse <jcasse@google.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jul 31 2013, Grant Grundler wrote:
> On Wed, Jul 31, 2013 at 2:23 PM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> >> o log writes (save a map) so we can repeatedly verify writes at a
> >> later date (weeks or months later)
> >
> > One approach that I have started favoring is instead providing coverage
> > through the use of an lfsr.
> 
> "Log File Structured <something>?" Expand that and I can better assess
> if I think this is a good idea or not.

Linear feedback shift registers. Basically a way to generate a "random"
sequence of numbers that are guarenteed not to repeat until the cycle is
repeated. Then you never have to do on-the-side tracking to avoid
overlaps or overwrites.

For verify, you simple re-set the seed to the value when the sequence
started to hit all of the same blocks again. Or variations around that
theme, if you only want some of them.

> I'm not too picky about the implementation that meets the requirement.
> I understand maps or sparse maps can get very awkward to handle for
> devices with more than a few billion blocks. ("Can plz haz 4k blox?"
> :)

Indeed, fio has the "axmap" to track it otherwise, which gets very close
to 1 bit per block without having the pathological behavior when the map
gets near full.

> 
> > This negates the need for dedicated tracking
> > map or log. Fio supports this through random_generator=lfsr. The one
> > thing that does not YET work is lfsr and multiple block sizes. Should be
> > doable through layered use of multiple lfsrs. Something for your intern
> > to tackle?
> 
> Yes. That would be fair game.

Excellent! 

> >> o provide some "bread crumbs" for debugging when data is NOT correct.
> >>    (Not available typically will result in reported errors)
> >
> > So lets say that one of the fio verify modes was augmented to include a
> > time stamp (say the meta mode, or could even be added to all the verify
> > modes), that could be part of the bread crumbs and aid in judging
> > retention of the data.
> 
> I want four pieces of data for bread crumbs:
> o timestamp

Don't have that, trivial to add.

> o LBA written (e.g. if it's a partition, that means the offset into
> the partition)

Got it.

> o magic number for that test run (think of it as a GUID - verifies the
> block was written by fio)

Got it, but it's a fio generic magic. We could add a specific magic as
well, would be trivial.

> o generation number in the case that we rewrite an LBA - so we can
> detect stale data

Don't have that, trivial to add.

> I haven't checked if fio provides all four of those.
> 
> BTW, to eventually support adding "trim/discard command" testing into
> the mix, we would need to know when a block is explicitly unmapped and
> should be all zeros if we attempt to read it.

This possibly again could be done without on-the-side tracking, if we
used a separate lfsr to generate the read/write/trim part. This would
keep the memory foot print down. Fio does support trim already.

> >> o be done in < 6 weeks by a full time intern. :)
> >
> > Depends on the quality of the intern :-)
> 
> Juan is capable enough. He's also extremely persistent. So I think
> yes, he can get this done.

Excellent!

> >> Questions:
> >> 1) You know anyone else developing data integrity/retention testing with fio?
> >
> > I know of lots of people/companies using it for data integrity testing
> > (I even work for one of them), but not data retention. So I think that
> > would be a very interesting feature to add.
> 
> Good. thanks!
> 
> My review a few months ago of fio docs didn't give me the impression
> the data integrity checking was providing enough bread crumbs for good
> debugging or able to detect stale data. But my memory isn't very good
> and I could be wrong or just out of date.

Depends on your use case. Fio checksums the verify header separate. If
that is good, we can check the actual data. If that is not good, we can
recreate the original content and compare with what is on disk. That
gives you a pretty good idea of what was destroyed and how. But it does
not have the required bits for real retention testing, like timestamp
and/or sequence. That could be added to the verify_header structure, or
it could be a specific part of eg the meta verify. The latter has the
offset written already, for instance.

> >> 3) You have a preference on how this might be implemented if (a) we
> >> used code from OR (b) integrated this functionality into fio?
> >
> > I think the the data retention aspect should be integrated into the
> > verify modes. The fio verification modes checksum both the stored
> > header, as well as the actual contents. There might be additional
> > tracking required on the side for retention, to be able to pass some
> > interesting info on where we seem to fall off a cliff.
> 
> Ok. Let me clarify the requirement for data retention: I wanted
> "verify" to be an option to the "read" workload mix. So not
> necessarily all data that gets written will get verified "during" the
> write workload. The reason is performance statistics need to be as
> consistent as possible without "verify" in a mixed read/write
> workload.

Fio already supports that. Simply do the write workload with
do_verify=0, then do a similar read workload with do_verify=1 and the
same verify checksum etc settings.

> To verify everything that was written or trimmed, we can invoke fio
> again (think autotest invoking fio twice per test run) to check for
> retention. And then invoke fio many more times while the device is
> getting baked in a thermal chamber.

Trim verification can be done if the device supports persistent and
guaranteed zero return on a completed trim. trim_verify_zero. If that
isn't set, trimmed regions are simply ignored for a verify.

> > I'll be happy to work with you guys on this, both on the initial
> > design phase and the final integration into fio.
> 
> Awesome - thank you!
> 
> Design phase?! :) This is design phase. :)

Agree :-)

-- 
Jens Axboe

