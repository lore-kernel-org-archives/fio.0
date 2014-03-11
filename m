Return-Path: <axboe@kernel.dk>
Message-ID: <531F2D56.8080801@kernel.dk>
Date: Tue, 11 Mar 2014 09:35:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: number_ios is checked on completion, not submission
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net>
Content-Type: multipart/mixed;
 boundary="------------050603080603020302070802"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050603080603020302070802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/10/2014 03:12 PM, Elliott, Robert (Server Storage) wrote:
> Since number_ios is checked in io_u.c account_io_completion() rather than a submission function, fio actually runs the requested number of I/Os plus iodepth - 1.
>
> Example: for a job specifying:
> number_ios=5000
> iodepth=128
>
> the results are:
>    read : io=20000KB, bw=222222KB/s, iops=56966, runt=    90msec
>    IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%
>       issued    : total=r=5127/w=0/d=0, short=r=0/w=0/d=0
>
> Should that just be documented as such, or should this logic be moved to submission?
> static void account_io_completion(struct thread_data *td, struct io_u *io_u,
> ...
>          if (td->o.number_ios && !--td->o.number_ios)
>                  td->done = 1;

Can you try the attached patch and see if that makes it behave more like 
expected?

-- 
Jens Axboe


--------------050603080603020302070802
Content-Type: text/x-patch;
 name="number_ios.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="number_ios.patch"

diff --git a/backend.c b/backend.c
index 992033c5c170..cee185571082 100644
--- a/backend.c
+++ b/backend.c
@@ -625,6 +625,7 @@ reap:
 
 static int io_bytes_exceeded(struct thread_data *td)
 {
+	unsigned long long number_ios = 0;
 	unsigned long long bytes;
 
 	if (td_rw(td))
@@ -636,7 +637,13 @@ static int io_bytes_exceeded(struct thread_data *td)
 	else
 		bytes = td->this_io_bytes[DDIR_TRIM];
 
-	return bytes >= td->o.size;
+	if (td->o.number_ios) {
+		number_ios = ddir_rw_sum(td->this_io_blocks);
+		number_ios += td->io_u_queued;
+	}
+
+	return bytes >= td->o.size ||
+		(number_ios && number_ios >= td->o.number_ios);
 }
 
 /*
@@ -1128,6 +1135,14 @@ static int keep_running(struct thread_data *td)
 		return 1;
 	}
 
+	if (td->o.number_ios) {
+		unsigned long long number_ios = ddir_rw_sum(td->this_io_blocks);
+
+		number_ios += td->io_u_queued;
+		if (number_ios >= td->o.number_ios)
+			return 0;
+	}
+
 	if (td->o.size != -1ULL && ddir_rw_sum(td->io_bytes) < td->o.size) {
 		uint64_t diff;
 
diff --git a/io_u.c b/io_u.c
index 8e27708731c7..0b86d9f3c281 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,9 +1595,6 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (!gtod_reduce(td))
 		add_iops_sample(td, idx, bytes, &icd->time);
-
-	if (td->o.number_ios && !--td->o.number_ios)
-		td->done = 1;
 }
 
 static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)

--------------050603080603020302070802--

