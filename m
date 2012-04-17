Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2DQGbD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Apr 2012 02:31:03 -0400
Message-ID: <4F8D0E1A.2020004@kernel.dk>
Date: Tue, 17 Apr 2012 08:30:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com> <4F899663.8050406@kernel.dk> <4F8997E9.6090206@kernel.dk> <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
In-Reply-To: <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 04/17/2012 01:15 AM, Suresh Dhanarajan wrote:
> Hi Jens,
> 
> I am facing issues while applying the patch,
> Please find the details,
> ===========
> The patch for the file is ,
> 
> --- a/fio.h
> +++ b/fio.h
> @@ -67,6 +67,7 @@ struct thread_data {
>        char verror[FIO_VERROR_SIZE];
>        pthread_t thread;
>        unsigned int thread_number;
> +       unsigned int group_thread_number;
>        unsigned int groupid;
>        struct thread_stat ts;
> 
> There is no such line in that file.
> 
> $>grep 'unsigned int thread_number' fio.h
> extern unsigned int thread_number;
> 
> The line 67 does not have any related lines,
> 
> 65 enum {
>  66     RW_SEQ_SEQ  = 0,
>  67     RW_SEQ_IDENT,
>  68 };
> 
> Let me know how to proceed further.

It was against the gfio branch. The line is there in fio.h, it's just
further down and thread_number isn't unsigned :-)

Here's a patch against the master branch, should apply against any
recent version.

diff --git a/filesetup.c b/filesetup.c
index f3d3829..0fc0b41 100644
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
index 6da22f0..d4fb907 100644
--- a/fio.h
+++ b/fio.h
@@ -280,6 +280,7 @@ struct thread_data {
 	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	int thread_number;
+	unsigned int group_thread_number;
 	int groupid;
 	struct thread_stat ts;
 
diff --git a/init.c b/init.c
index 3865d09..465ffa9 100644
--- a/init.c
+++ b/init.c
@@ -33,6 +33,7 @@ static int dump_cmdline;
 static int def_timeout;
 
 static struct thread_data def_thread;
+static int group_thread_number;
 struct thread_data *threads = NULL;
 
 int exitall_on_terminate = 0;
@@ -824,8 +825,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
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

