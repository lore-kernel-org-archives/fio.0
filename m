Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:55540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZDVGF3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 02:05:29 -0400
Date: Wed, 22 Apr 2009 08:05:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Issue running random reads with verify on a raw device
Message-ID: <20090422060528.GU4593@kernel.dk>
References: <66dfd3fe0904101557g99d6b63r5a24a84cfe01ffbf@mail.gmail.com> <20090418175308.GE4593@kernel.dk> <66dfd3fe0904211631q2d5b7045o5664a3bdda100c19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0904211631q2d5b7045o5664a3bdda100c19@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Tue, Apr 21 2009, Radha Ramachandran wrote:
> Hi Jens,
> Ah right, I missed the offset.
> My interpretation of the options was that the check needs to be that
> the (new random block + offset) needs to be < both the real_file_size
> and io_size.
> 
> Iam not sure i understand what you said very well, so the fix that I have is:

I read up on the code, and I think your previous patch was correct. The
offset isn't added until later in the process, so we should indeed not
check the offset in this location.

I'll test your previous patch and add it, sorry for the noise!

BTW, in the future, please send unified diffs. Use -up as options to
diff, then provides more readable diffs and with function context as
well.


> 
> diff -crB io_u.c io_u.c_fixed
> *** io_u.c      Fri Apr 10 15:47:02 2009
> --- io_u.c_fixed        Tue Apr 21 16:29:30 2009
> ***************
> *** 113,119 ****
> 
>         i = f->last_free_lookup;
>         *b = (i * BLOCKS_PER_MAP);
> !       while ((*b) * min_bs < f->real_file_size) {
>                 if (f->file_map[i] != (unsigned int) -1) {
>                         *b += ffz(f->file_map[i]);
>                         if (*b > last_block(td, f, ddir))
> --- 113,120 ----
> 
>         i = f->last_free_lookup;
>         *b = (i * BLOCKS_PER_MAP);
> !       while ((((*b) * min_bs + f->offset) < f->real_file_size) &&
> !               (((*b) * min_bs + f->offset) < f->io_size)) {
>                 if (f->file_map[i] != (unsigned int) -1) {
>                         *b += ffz(f->file_map[i]);
>                         if (*b > last_block(td, f, ddir))
> 
> thanks
> -radha
> On Sat, Apr 18, 2009 at 10:53 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Fri, Apr 10 2009, Radha Ramachandran wrote:
> >> Hi,
> >> We have a test that runs the test on a raw device say of size 100GB
> >> > Sequential write of a pattern to the raw device with size=10GB (so even though the device is 100GB big we try to write only to the first 10GB)
> >> > Random read and verify of the pattern to the raw device with size=10GB, (with randommap, so we maintain the bitmap of previously visited blocks)
> >>
> >> This test almost always lands up trying to do the read beyond the
> >> 10GB. So I see this code in io_u.c:
> >>
> >> static int get_next_free_block(struct thread_data *td, struct fio_file *f,
> >>                              enum fio_ddir ddir, unsigned long long *b) {
> >> ...
> >>        while ((*b) * min_bs < f->real_file_size) {   ========= This
> >> code looks for an unvisited block within the real_file_size which in
> >> this case is 100GB, and will exceed 10GB in a lot of cases causing the
> >> verify to fail.
> >>
> >>
> >> So i fixed this by checking if the block is within the real_file_size
> >> and the io_size, so this wld work in cases where:
> >> 1. Actual file size < io_size
> >> 2. io_size < Actual file size
> >>
> >>
> >> diff -crB io_u.c io_u.c_fixed
> >> *** io_u.c      Fri Apr 10 15:47:02 2009
> >> --- io_u.c_fixed        Fri Apr 10 15:48:02 2009
> >> ***************
> >> *** 113,119 ****
> >>
> >>         i = f->last_free_lookup;
> >>         *b = (i * BLOCKS_PER_MAP);
> >> !       while ((*b) * min_bs < f->real_file_size) {
> >>                 if (f->file_map[i] != (unsigned int) -1) {
> >>                         *b += ffz(f->file_map[i]);
> >>                         if (*b > last_block(td, f, ddir))
> >> --- 113,120 ----
> >>
> >>         i = f->last_free_lookup;
> >>         *b = (i * BLOCKS_PER_MAP);
> >> !       while (((*b) * min_bs < f->real_file_size) &&
> >> !               ((*b) * min_bs < f->io_size)) {
> >>                 if (f->file_map[i] != (unsigned int) -1) {
> >>                         *b += ffz(f->file_map[i]);
> >>                         if (*b > last_block(td, f, ddir))
> >>
> >>
> >> Is there some case I missed?
> >
> > Yeah I don't think this will work for using an offset within the file,
> > as it's legal for the offset to be larger than the io_size. If you can
> > check and add the offset check, I think it should be ok.
> >
> > --
> > Jens Axboe
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

