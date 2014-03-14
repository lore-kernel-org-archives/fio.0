Return-Path: <axboe@kernel.dk>
Message-ID: <532361FE.10901@kernel.dk>
Date: Fri, 14 Mar 2014 14:09:34 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Possible bug when setting compression
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>	<532349BF.4010307@kernel.dk> <CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
In-Reply-To: <CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040508070101080503090504"
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040508070101080503090504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/14/2014 01:45 PM, Matthew Eaton wrote:
>> Interesting, it would make sense to simply not scramble if the compression
>> settings are set. That is what happens with refill_buffers right now, it has
>> precedence over the scrambling. Or if you give a buffer pattern, that also
>> disables the scrambling. I'll add the same for the compression settings.
>>
>> http://git.kernel.dk/?p=fio.git;a=commit;h=0574c885b82aea0332ab5fa35af84db0f3946726
>>
>> Care to give it a test spin, just to be on the safe side?
>>
>> --
>> Jens Axboe
>>
>
> Hey Jens,
>
> According to my test results below it worked for
> buffer_compress_percentage, but not zero_buffers.  Also, it looks like
> buffer_compress_percentage=0 is broken, unless =0 means disabling that
> option altogether.
>
> fio-2.1.6.1-11-g0574
>
> buffer_compress_percentage=100
> iops=83436
>
> buffer_compress_percentage=50
> iops=78625
>
> buffer_compress_percentage=1
> iops=52751
>
> buffer_compress_percentage=0
> iops=69433
>
> zero_buffers
> iops=69470
>
> scramble_buffers=0
> zero_buffers
> iops=83369
>

Doh yes, we can't use that as an enabled flag. Can you apply this on top 
of current git and see if it works? Untested...

-- 
Jens Axboe


--------------040508070101080503090504
Content-Type: text/x-patch;
 name="fio-compress.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-compress.patch"

diff --git a/fio.h b/fio.h
index 52f1def7a28d..befdce31ee20 100644
--- a/fio.h
+++ b/fio.h
@@ -71,6 +71,7 @@ enum {
 	TD_F_SCRAMBLE_BUFFERS	= 16,
 	TD_F_VER_NONE		= 32,
 	TD_F_PROFILE_OPS	= 64,
+	TD_F_COMPRESS		= 128,
 };
 
 enum {
diff --git a/init.c b/init.c
index 0a872c0f1eed..73ec9eb22a8d 100644
--- a/init.c
+++ b/init.c
@@ -856,11 +856,6 @@ int ioengine_load(struct thread_data *td)
 	return 0;
 }
 
-static int compression_enabled(struct thread_options *o)
-{
-	return o->compress_percentage || o->compress_chunk;
-}
-
 static void init_flags(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
@@ -873,14 +868,8 @@ static void init_flags(struct thread_data *td)
 		td->flags |= TD_F_READ_IOLOG;
 	if (o->refill_buffers)
 		td->flags |= TD_F_REFILL_BUFFERS;
-
-	/*
-	 * Don't scramble buffers if we set any of the compression
-	 * settings
-	 */
-	if (o->scramble_buffers && !compression_enabled(o))
+	if (o->scramble_buffers)
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
-
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
 }
diff --git a/io_u.c b/io_u.c
index 0b86d9f3c281..14645aeed50c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1490,7 +1490,8 @@ struct io_u *get_io_u(struct thread_data *td)
 			if (td->flags & TD_F_REFILL_BUFFERS) {
 				io_u_fill_buffer(td, io_u,
 					io_u->xfer_buflen, io_u->xfer_buflen);
-			} else if (td->flags & TD_F_SCRAMBLE_BUFFERS)
+			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
+				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
 			if (td->flags & TD_F_VER_NONE) {
 				populate_verify_io_u(td, io_u);
diff --git a/options.c b/options.c
index 4ff4c9b42a7b..63d6848370bd 100644
--- a/options.c
+++ b/options.c
@@ -1002,6 +1002,14 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	return ret;
 }
 
+static int str_buffer_compress_cb(void *data, long long *il)
+{
+	struct thread_data *td = data;
+
+	td->flags |= TD_F_COMPRESS;
+	return 0;
+}
+
 static int str_verify_pattern_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
@@ -3119,6 +3127,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Buffer compression percentage",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(compress_percentage),
+		.cb	= str_buffer_compress_cb,
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "How compressible the buffer is (approximately)",

--------------040508070101080503090504--

