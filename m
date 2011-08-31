Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:39732
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1HaVVm (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Aug 2011 17:21:42 -0400
Message-ID: <4E5EA5DF.5040609@fusionio.com>
Date: Wed, 31 Aug 2011 15:21:35 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio file test patterns
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com> <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com> <4E5E91D9.4000702@fusionio.com> <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com>
In-Reply-To: <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Fallik <bfallik@bamboom.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-31 14:34, Brian Fallik wrote:
> Hi,
> 
> Hmm.  I'm still unable to generate random test data using fio.   My
> new job control file is:
>   [foo0]
>   rate =,200k
>   rw =write
>   refill_buffers =1
>   size =4m
> 
>   [foo1]
>   rate =,200k
>   rw =write
>   refill_buffers =1
>   size =4m
> But:
>   $ diff foo0.1.0 foo1.2.0
> reports they're identical.  I also tried enabling data verification by
> adding "verify=crc32c-intel" but that had no effect.  Am I missing
> something obvious or is this potentially broken in fio 1.57?

It's random, just not across jobs apparently... Ooops. The below patch
should rectify that. It's also committed, jfyi.

> I also have another (maybe related?) question.  Apologies if this
> belongs in a separate thread, but are there any notes explaining why
> fio lays out the files before starting sequential writes?  The
> workload I was hoping to simulate is sustained, sequential writes to
> disk.  I'm trying to answer the question "How many simultaneous
> 200kBps writers can we support?"  Using my current jobs file, fio
> starts by creating the files (e.g "foo0: Laying out IO file(s) (1
> file(s) / 4MB)") before it starts processing.  However, creating the
> files in advance accounts for a chunk of performance that doesn't seem
> to be measured by fio.  Am I misunderstanding how to configure fio or
> its intended usage?

You should be able to set overwrite=0 to avoid that. Are they random
writes?


commit 3545a109a2cfe5ab22969ef453dc049db47f0b68
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Wed Aug 31 15:20:15 2011 -0600

    Ensure that buffer contents are random across jobs as well
    
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

diff --git a/fio.c b/fio.c
index 9c1bed3..4514840 100644
--- a/fio.c
+++ b/fio.c
@@ -874,9 +874,9 @@ static int init_io_u(struct thread_data *td)
 			io_u->buf = p + max_bs * i;
 			dprint(FD_MEM, "io_u %p, mem %p\n", io_u, io_u->buf);
 
-			if (td_write(td) && !td->o.refill_buffers)
+			if (td_write(td))
 				io_u_fill_buffer(td, io_u, max_bs);
-			else if (td_write(td) && td->o.verify_pattern_bytes) {
+			if (td_write(td) && td->o.verify_pattern_bytes) {
 				/*
 				 * Fill the buffer with the pattern if we are
 				 * going to be doing writes.
@@ -1699,7 +1699,6 @@ int main(int argc, char *argv[], char *envp[])
 	arch_init(envp);
 
 	sinit();
-	init_rand(&__fio_rand_state);
 
 	/*
 	 * We need locale for number printing, if it isn't set then just
diff --git a/fio.h b/fio.h
index 8401eda..6eb270d 100644
--- a/fio.h
+++ b/fio.h
@@ -460,7 +460,7 @@ struct thread_data {
 
 	char *sysfs_root;
 
-	unsigned long rand_seeds[7];
+	unsigned long rand_seeds[8];
 
 	union {
 		os_random_state_t bsrange_state;
@@ -475,6 +475,8 @@ struct thread_data {
 		struct frand_state __trim_state;
 	};
 
+	struct frand_state buf_state;
+
 	unsigned int verify_batch;
 	unsigned int trim_batch;
 
diff --git a/init.c b/init.c
index a920c6e..ed34269 100644
--- a/init.c
+++ b/init.c
@@ -515,6 +515,8 @@ void td_fill_rand_seeds(struct thread_data *td)
 		td_fill_rand_seeds_os(td);
 	else
 		td_fill_rand_seeds_internal(td);
+
+	init_rand_seed(&td->buf_state, td->rand_seeds[7]);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index 16c98b1..a87c58e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1450,7 +1450,7 @@ void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
 	io_u->buf_filled_len = 0;
 
 	if (!td->o.zero_buffers)
-		fill_random_buf(io_u->buf, max_bs);
+		fill_random_buf(&td->buf_state, io_u->buf, max_bs);
 	else
 		memset(io_u->buf, 0, max_bs);
 }
diff --git a/lib/rand.c b/lib/rand.c
index 3b2d67a..7c6fed1 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -36,8 +36,6 @@
 #include "rand.h"
 #include "../hash.h"
 
-struct frand_state __fio_rand_state;
-
 static inline int __seed(unsigned int x, unsigned int m)
 {
 	return (x < m) ? x + m : x;
@@ -79,12 +77,13 @@ void __fill_random_buf(void *buf, unsigned int len, unsigned long seed)
 	}
 }
 
-unsigned long fill_random_buf(void *buf, unsigned int len)
+unsigned long fill_random_buf(struct frand_state *fs, void *buf,
+			      unsigned int len)
 {
-	unsigned long r = __rand(&__fio_rand_state);
+	unsigned long r = __rand(fs);
 
 	if (sizeof(int) != sizeof(long *))
-		r *= (unsigned long) __rand(&__fio_rand_state);
+		r *= (unsigned long) __rand(fs);
 
 	__fill_random_buf(buf, len, r);
 	return r;
diff --git a/lib/rand.h b/lib/rand.h
index f80c111..6b9e13c 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -7,8 +7,6 @@ struct frand_state {
 	unsigned int s1, s2, s3;
 };
 
-extern struct frand_state __fio_rand_state;
-
 static inline unsigned int __rand(struct frand_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
@@ -23,6 +21,6 @@ static inline unsigned int __rand(struct frand_state *state)
 extern void init_rand(struct frand_state *);
 extern void init_rand_seed(struct frand_state *, unsigned int seed);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
-extern unsigned long fill_random_buf(void *buf, unsigned int len);
+extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 
 #endif
diff --git a/verify.c b/verify.c
index fc207cf..c450e88 100644
--- a/verify.c
+++ b/verify.c
@@ -36,7 +36,7 @@ void fill_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u
 		if (use_seed)
 			__fill_random_buf(p, len, seed);
 		else
-			io_u->rand_seed = fill_random_buf(p, len);
+			io_u->rand_seed = fill_random_buf(&td->buf_state, p, len);
 		break;
 	case 1:
 		/*

-- 
Jens Axboe

