Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35016 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab1GWLnO (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jul 2011 07:43:14 -0400
Message-ID: <4E2AB3CE.6030700@fusionio.com>
Date: Sat, 23 Jul 2011 13:43:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio: when not using a job file, timeouts are not applied
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com> <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com> <CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com> <CANWz5fi-=P5J=Op5o7-pr+3UMh+CLQMsnctem8hhOG2RnHuiLA@mail.gmail.com> <CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com> <CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com> <CAAZKuFY=QEXqSD0uHYY0u8E4uiJf2xKWbQAsKde3DWcd6jOhpw@mail.gmail.com> <CANWz5fg0RmLJVvfUevz7owHzasYtiNrMyFajgmnF6_QUOk44-A@mail.gmail.com> <CAAZKuFZ2WdK8YkLuo9ayyHe4=pv8+F7Tm1-cBO=JiQtuW5tLtA@mail.gmail.com>
In-Reply-To: <CAAZKuFZ2WdK8YkLuo9ayyHe4=pv8+F7Tm1-cBO=JiQtuW5tLtA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Farina <daniel@heroku.com>
Cc: Chris Worley <worleys@gmail.com>, fio@vger.kernel.org

On 2011-07-19 02:21, Daniel Farina wrote:
> On Mon, Jul 18, 2011 at 5:19 PM, Chris Worley <worleys@gmail.com> wrote:
>> Do you mean to be using --timeout or --runtime?
> 
> --timeout.  It's pretty clear the semantics using a job file and those
> without a job file are not the same, or are you not able to reproduce
> this?

Sorry for the late reply, I'm on vacation. This should fix it.

diff --git a/init.c b/init.c
index 85bd0f7..98e10f7 100644
--- a/init.c
+++ b/init.c
@@ -47,7 +47,6 @@ int warnings_fatal = 0;
 int write_bw_log = 0;
 int read_only = 0;
 
-static int def_timeout;
 static int write_lat_log;
 
 static int prev_group_jobs;
@@ -951,8 +950,6 @@ static int fill_def_thread(void)
 	 * fill default options
 	 */
 	fio_fill_default_options(&def_thread);
-
-	def_thread.o.timeout = def_timeout;
 	return 0;
 }
 
@@ -1160,7 +1157,7 @@ static int parse_cmd_line(int argc, char *argv[])
 			smalloc_pool_size = atoi(optarg);
 			break;
 		case 't':
-			def_timeout = atoi(optarg);
+			def_thread.o.timeout = atoi(optarg);
 			break;
 		case 'l':
 			write_lat_log = 1;

-- 
Jens Axboe

