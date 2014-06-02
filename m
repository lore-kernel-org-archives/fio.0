Return-Path: <jiri.horky@gmail.com>
Message-ID: <538CC242.60109@gmail.com>
Date: Mon, 02 Jun 2014 20:28:18 +0200
From: Jiri Horky <jiri.horky@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Allow to reset offset_increment counter
References: <537F439E.9040904@gmail.com> <537F7E8E.4050200@kernel.dk> <537F8454.3020203@gmail.com>
In-Reply-To: <537F8454.3020203@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010406030200040107080708"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010406030200040107080708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

so here is another try. I thought about it a little and I think that it
only makes sense to define offset_increment together with numjobs=X
setting, i.e. when using subjobs. The patch reflects this. Each subjob
starts at next offset_increment for each file it operates on.

Cheers
Jirka H.


On 05/23/2014 07:24 PM, Jiri Horky wrote:
> Hi Jens,
> On 05/23/2014 06:59 PM, Jens Axboe wrote:
>> On 2014-05-23 06:48, Jiri Horky wrote:
>>> Hi all,
>>>
>>> because I got bitten by this multiple times I decided to give this patch
>>> a try :)
>>>
>>> Current implementation of offset calculation when offset_increment is in
>>> effect uses global thread_number as follows:
>>>      f->file_offset = td->o.start_offset + (td->thread_number - 1) *
>>> td->o.offset_increment;
>>>
>>> The thread number gets incremented for every job (subjob) so even you
>>> have multiple jobs with different filenames, the offset calculation is
>>> shared. I find this very unintuitive, especially in cases the offsets
>>> gets past the device/file. For example, if one wants to run sequential
>>> read test in 16 threads of multiple devices (/dev/sd{b,c,d}) in one
>>> group, which are of  1TB size, and to eliminate caching effect he wants
>>> each read to start at different offset, the config could look like
>>> following:
>> Maybe it would be better to have this offset calculation be on a
>> per-thread-per-file basis? You are right in that it only makes sense
>> within the same file or device, so maybe it'd be better to make it
>> work more like you expect.
> I agree it should definitely be file-based, I just wasn't sure how you
> would express that in the config file. Or you mean that that the offset
> calculation would not be shared between different jobs (not subjobs)
> even if they share the same file?
> The fact is that one can always calculate the start offset in the new
> job definition if he needs the offset calculation to be shared. And if
> there are multiple files within a job, the offset_increment should be
> independent.
>
> I will try to look at this.
>
> Jiri
>


--------------010406030200040107080708
Content-Type: text/x-patch;
 name="fio.offset_increment.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio.offset_increment.patch"

diff --git a/filesetup.c b/filesetup.c
index 84eaed6..aa908ad 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -752,7 +752,7 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 		return f->real_file_size;
 
 	return td->o.start_offset +
-		(td->thread_number - 1) * td->o.offset_increment;
+		td->subjob_number * td->o.offset_increment;
 }
 
 /*
diff --git a/fio.1 b/fio.1
index 62f40ea..10f4b77 100644
--- a/fio.1
+++ b/fio.1
@@ -658,9 +658,10 @@ Offset in the file to start I/O. Data before the offset will not be touched.
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
 offset + offset_increment * thread_number, where the thread number is a counter
-that starts at 0 and is incremented for each job. This option is useful if
-there are several jobs which are intended to operate on a file in parallel in
-disjoint segments, with even spacing between the starting points.
+that starts at 0 and is incremented for each sub-job (i.e. when numjobs option
+is specified). This option is useful if there are several jobs which are
+intended to operate on a file in parallel in disjoint segments, with even
+spacing between the starting points.
 .TP
 .BI number_ios \fR=\fPint
 Fio will normally perform IOs until it has exhausted the size of the region
diff --git a/fio.h b/fio.h
index 4d4af0a..b0c247e 100644
--- a/fio.h
+++ b/fio.h
@@ -101,6 +101,7 @@ struct thread_data {
 	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	unsigned int thread_number;
+	unsigned int subjob_number;
 	unsigned int groupid;
 	struct thread_stat ts;
 
diff --git a/init.c b/init.c
index a546861..a454e5e 100644
--- a/init.c
+++ b/init.c
@@ -363,6 +363,7 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	profile_add_hooks(td);
 
 	td->thread_number = thread_number;
+	td->subjob_number = 0;
 
 	if (!parent->o.group_reporting)
 		stat_number++;
@@ -1198,6 +1199,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td_new->o.numjobs = 1;
 		td_new->o.stonewall = 0;
 		td_new->o.new_group = 0;
+		td_new->subjob_number = numjobs;
 
 		if (file_alloced) {
 			if (td_new->files) {

--------------010406030200040107080708--

