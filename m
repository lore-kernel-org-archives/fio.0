Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20090418175308.GE4593@kernel.dk>
References: <66dfd3fe0904101557g99d6b63r5a24a84cfe01ffbf@mail.gmail.com>
	 <20090418175308.GE4593@kernel.dk>
Date: Tue, 21 Apr 2009 16:31:38 -0700
Message-ID: <66dfd3fe0904211631q2d5b7045o5664a3bdda100c19@mail.gmail.com>
Subject: Re: Issue running random reads with verify on a raw device
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,
Ah right, I missed the offset.
My interpretation of the options was that the check needs to be that
the (new random block + offset) needs to be < both the real_file_size
and io_size.

Iam not sure i understand what you said very well, so the fix that I have is:

diff -crB io_u.c io_u.c_fixed
*** io_u.c      Fri Apr 10 15:47:02 2009
--- io_u.c_fixed        Tue Apr 21 16:29:30 2009
***************
*** 113,119 ****

        i = f->last_free_lookup;
        *b = (i * BLOCKS_PER_MAP);
!       while ((*b) * min_bs < f->real_file_size) {
                if (f->file_map[i] != (unsigned int) -1) {
                        *b += ffz(f->file_map[i]);
                        if (*b > last_block(td, f, ddir))
--- 113,120 ----

        i = f->last_free_lookup;
        *b = (i * BLOCKS_PER_MAP);
!       while ((((*b) * min_bs + f->offset) < f->real_file_size) &&
!               (((*b) * min_bs + f->offset) < f->io_size)) {
                if (f->file_map[i] != (unsigned int) -1) {
                        *b += ffz(f->file_map[i]);
                        if (*b > last_block(td, f, ddir))

thanks
-radha
On Sat, Apr 18, 2009 at 10:53 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Apr 10 2009, Radha Ramachandran wrote:
>> Hi,
>> We have a test that runs the test on a raw device say of size 100GB
>> > Sequential write of a pattern to the raw device with size=10GB (so even though the device is 100GB big we try to write only to the first 10GB)
>> > Random read and verify of the pattern to the raw device with size=10GB, (with randommap, so we maintain the bitmap of previously visited blocks)
>>
>> This test almost always lands up trying to do the read beyond the
>> 10GB. So I see this code in io_u.c:
>>
>> static int get_next_free_block(struct thread_data *td, struct fio_file *f,
>>                              enum fio_ddir ddir, unsigned long long *b) {
>> ...
>>        while ((*b) * min_bs < f->real_file_size) {   ========= This
>> code looks for an unvisited block within the real_file_size which in
>> this case is 100GB, and will exceed 10GB in a lot of cases causing the
>> verify to fail.
>>
>>
>> So i fixed this by checking if the block is within the real_file_size
>> and the io_size, so this wld work in cases where:
>> 1. Actual file size < io_size
>> 2. io_size < Actual file size
>>
>>
>> diff -crB io_u.c io_u.c_fixed
>> *** io_u.c      Fri Apr 10 15:47:02 2009
>> --- io_u.c_fixed        Fri Apr 10 15:48:02 2009
>> ***************
>> *** 113,119 ****
>>
>>         i = f->last_free_lookup;
>>         *b = (i * BLOCKS_PER_MAP);
>> !       while ((*b) * min_bs < f->real_file_size) {
>>                 if (f->file_map[i] != (unsigned int) -1) {
>>                         *b += ffz(f->file_map[i]);
>>                         if (*b > last_block(td, f, ddir))
>> --- 113,120 ----
>>
>>         i = f->last_free_lookup;
>>         *b = (i * BLOCKS_PER_MAP);
>> !       while (((*b) * min_bs < f->real_file_size) &&
>> !               ((*b) * min_bs < f->io_size)) {
>>                 if (f->file_map[i] != (unsigned int) -1) {
>>                         *b += ffz(f->file_map[i]);
>>                         if (*b > last_block(td, f, ddir))
>>
>>
>> Is there some case I missed?
>
> Yeah I don't think this will work for using an offset within the file,
> as it's legal for the offset to be larger than the io_size. If you can
> check and add the offset check, I think it should be ok.
>
> --
> Jens Axboe
>
>

