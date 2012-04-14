Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2DNP3v (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 14 Apr 2012 11:29:51 -0400
Message-ID: <4F8997E9.6090206@kernel.dk>
Date: Sat, 14 Apr 2012 17:29:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com> <4F899663.8050406@kernel.dk>
In-Reply-To: <4F899663.8050406@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-14 17:23, Jens Axboe wrote:
> On 2012-04-14 01:48, Suresh Dhanarajan wrote:
>> Hi,
>>
>> I wanted to use the "offset increment option" and  "numjobs" so that i
>> can split the work load between ten jobs and reduce the run time.
>> But what i am seeing is that the offset counter is not getting reset
>> when the first job in the jobfile is completed.(is it that the offset
>> is global for the job file and not for the Jobs inside the jobfile?)
>> So  my read starts from the last offset set by the writes.
>>
>> here is my job file,
>>
>> [global]
>> bs=64k
>> direct=1
>> numjobs=10
>> size=1m
>> group_reporting
>>
>> [write-phase]
>> offset_increment=1m
>> filename=/dev/sdb
>> rw=write
>> write_iolog=verfywrite2
>>
>> [read-phase]
>> stonewall
>> offset_increment=1m
>> filename=/dev/sdb
>> rw=read
>> write_iolog=verfyread2
>>
>> I tried using the offset=0 option in the read phase job but now every
>> time the read happens from zeroth offsite.
>> Now the offset increment option is not getting honored.
>>
>> [write-phase]
>> offset_increment=1m
>> filename=/dev/sdb
>> rw=write
>> write_iolog=verfywrite2
>>
>> [read-phase]
>> stonewall
>> offset=0
>> offset_increment=1m
>> filename=/dev/sdb
>> rw=read
>> write_iolog=verfyread2
>>
>> I tried the same case with verify option.
>> the behavior is same.
>>
>> Is there any way that i can reset the offset counters once the job is completed?
> 
> Right now there isn't, but it does make sense to reset the counter
> across stonewalls. At the moment, it'll just increment for each job.
> Internally, fio sets up all the jobs, even across stonewalls, when it
> starts up. It just starts some of them later on, depending on those
> parameters. It does seem most useful to have it reset across a hard
> barrier though, I can definitely change it to do that.
> 
> Let me brew up a patch later today that you can test.

Had a few minutes now, didn't expect that. Can you try this? Do a make
clean first.

diff --git a/filesetup.c b/filesetup.c
index 166ace8..bad5bed 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -714,7 +714,7 @@ int setup_files(struct thread_data *td)
 	need_extend = 0;
 	for_each_file(td, f, i) {
 		f->file_offset = td->o.start_offset +
-			(td->thread_number - 1) * td->o.offset_increment;
+			(td->group_thread_number - 1) * td->o.offset_increment;
 
 		if (!td->o.file_size_low) {
 			/*
diff --git a/fio.h b/fio.h
index 95d9d77..05a5572 100644
--- a/fio.h
+++ b/fio.h
@@ -67,6 +67,7 @@ struct thread_data {
 	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	unsigned int thread_number;
+	unsigned int group_thread_number;
 	unsigned int groupid;
 	struct thread_stat ts;
 
diff --git a/init.c b/init.c
index 7422628..46571ee 100644
--- a/init.c
+++ b/init.c
@@ -35,6 +35,7 @@ static int dump_cmdline;
 static int def_timeout;
 
 static struct thread_data def_thread;
+static int group_thread_number;
 struct thread_data *threads = NULL;
 
 int exitall_on_terminate = 0;
@@ -829,8 +830,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if ((td->o.stonewall || td->o.new_group) && prev_group_jobs) {
 		prev_group_jobs = 0;
 		groupid++;
+		group_thread_number = 0;
 	}
 
+	td->group_thread_number = ++group_thread_number;
 	td->groupid = groupid;
 	prev_group_jobs++;
 

-- 
Jens Axboe

