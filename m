Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37171 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZD0GAo (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Apr 2009 02:00:44 -0400
Date: Mon, 27 Apr 2009 08:00:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: "directory=" option not working??
Message-ID: <20090427060043.GU4593@kernel.dk>
References: <6863f0c90904251938v2fd125egaf900257c1eb33dd@mail.gmail.com> <6863f0c90904251948o5d4e8c36y75c9042c0ae800cd@mail.gmail.com> <20090426063718.GQ4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426063718.GQ4593@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Cagle <jcagle@gmail.com>
Cc: fio@vger.kernel.org

On Sun, Apr 26 2009, Jens Axboe wrote:
> On Sat, Apr 25 2009, John Cagle wrote:
> > More info:  It looks like the [global] filename is not affected by the
> > [global] directory, but if you move the filename down into a job
> > section, it will get the directory name prepended...
> 
> Ah, good catch! Fio does do sorting, but not across sections. Weird that
> in then fails for global, I'll take a look at this tomorrow.

Not sure what happened there, but this will make it work. The case that
will still not work is this:

[global]
...
filename=foo

[job]
directory=/bar

I'll commit this patch and consider a way to fix the above.


diff --git a/options.c b/options.c
index 21de222..9267f79 100644
--- a/options.c
+++ b/options.c
@@ -605,7 +605,7 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(filename),
 		.cb	= str_filename_cb,
-		.prio	= 1, /* must come before "directory" */
+		.prio	= -1, /* must come after "directory" */
 		.help	= "File(s) to use for the workload",
 	},
 	{

-- 
Jens Axboe

