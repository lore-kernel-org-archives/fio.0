Return-Path: <axboe@kernel.dk>
Message-ID: <531F36C2.6060103@kernel.dk>
Date: Tue, 11 Mar 2014 10:16:02 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: number_ios is checked on completion, not submission
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net> <531F2D56.8080801@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net> <531F3657.9030003@kernel.dk>
In-Reply-To: <531F3657.9030003@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------070302050407050007090809"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070302050407050007090809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/11/2014 10:14 AM, Jens Axboe wrote:
> On 03/11/2014 10:08 AM, Elliott, Robert (Server Storage) wrote:
>> That patch still exits after 5127 ios.
>>
>> io_bytes_exceeded is called 5128 times, but it sees td->io_u_queued=0
>> each time.
>
> Can you check if ->cur_depth or ->io_u_in_flight catches it?

It should, try this one.

-- 
Jens Axboe


--------------070302050407050007090809
Content-Type: text/x-patch;
 name="number_ios-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="number_ios-v2.patch"

diff --git a/backend.c b/backend.c
index 992033c5c170..bab202662ca5 100644
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
+		number_ios += td->io_u_queued + td->io_u_in_flight;
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
+		number_ios += td->io_u_queued + td->io_u_in_flight;
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

--------------070302050407050007090809--

