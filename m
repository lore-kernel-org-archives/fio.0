Return-Path: <axboe@kernel.dk>
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Jens Axboe <axboe@kernel.dk>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
 <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
 <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org>
 <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
 <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org>
 <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk>
Message-ID: <bb30474a-0996-0154-8323-8a050519eaa7@kernel.dk>
Date: Thu, 26 Oct 2017 12:06:31 -0600
MIME-Version: 1.0
In-Reply-To: <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/25/2017 10:32 PM, Jens Axboe wrote:
> On 10/24/2017 08:10 AM, Paolo Valente wrote:
>>
>>> Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler <sitsofe@gmail.com> ha scritto:
>>>
>>> Hi,
>>>
>>> If memory serves it's actually slightly more complicated. If you are
>>> using loops=<number> then I *think* (you'll have to check) you will
>>> find that invalidation happens once per each loop start. However when
>>> you use time_based to do the repetition there is essentially only one
>>> "loop" (even though the job goes on forever) so loop actions only
>>> happen right at the start of the job with that option (that's why I
>>> put the scare quotes around "beginning" ;-).
>>>
>>
>> Thanks for this additional, useful piece of information.  Actually,
>> this further, possibly different caching behavior makes me think that
>> some extra comment in the manpage might be helpful.
> 
> Would probably make sense to change 'invalidate' to be a range of
> possible values:
> 
> 0	As it is now, never invalidate
> 1	As it is now, invalidate initially
> once	Same as '1', invalidate initially / once
> open	New value, invalidate on every open
> close	New value, invalidate on close
> 
> as I can definitely see reasons why you would want to invalidate every
> time you open the file.
> 
> To do that, the 'invalidate' option should be changed from a
> FIO_OPT_BOOL to a FIO_OPT_STR, and the above possible values should be
> added as posval[] for that option.
> 
> Compliment that with the an enum of ranges for the ovals:
> 
> enum {
> 	FIO_FILE_INVALIDATE_OFF	= 0,
> 	FIO_FILE_INVALIDATE_ONCE,
> 	FIO_FILE_INVALIDATE_OPEN,
> 	FIO_FILE_INVALIDATE_CLOSE
> };
> 
> Hope this makes sense, should be trivial to add as most of the work is
> already documented in this email :-). The remaining bits is just calling
> file_invalidate_cache() in the proper locations,
> td_io_{open,close}_file() would be prime candidates.

On a plane, so decided to take a look at this. Looking at how it's
implemented, fio actually does do cache invalidation at open time,
if you look at td_io_open_file(). I traced it, and it's invoked just
fine by default, and if you use loops=X (with X > 1).

For time_based, we don't open and close the file, so we don't trigger
that at all. We just loop/reset the offsets. Something like the below
should do the trick.


diff --git a/io_u.c b/io_u.c
index fb4180a3bc35..34d8cf7e986d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -323,6 +323,15 @@ fetch:
 	goto fetch;
 }
 
+static void loop_cache_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	if (td->o.invalidate_cache) {
+		int fio_unused ret;
+
+		ret = file_invalidate_cache(td, f);
+	}
+}
+
 static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, uint64_t *b)
 {
@@ -334,6 +343,7 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 		fio_file_reset(td, f);
 		if (!get_next_rand_offset(td, f, ddir, b))
 			return 0;
+		loop_cache_invalidate(td, f);
 	}
 
 	dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
@@ -358,6 +368,8 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			f->last_pos[ddir] = 0;
 		else
 			f->last_pos[ddir] = f->last_pos[ddir] - io_size;
+
+		loop_cache_invalidate(td, f);
 	}
 
 	if (f->last_pos[ddir] < f->real_file_size) {

-- 
Jens Axboe


