Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49089 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1GSADP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Jul 2011 20:03:15 -0400
Received: by ywe9 with SMTP id 9so1562353ywe.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 17:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
 <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
 <CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com>
 <CANWz5fi-=P5J=Op5o7-pr+3UMh+CLQMsnctem8hhOG2RnHuiLA@mail.gmail.com>
 <CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com> <CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com>
From: Daniel Farina <daniel@heroku.com>
Date: Mon, 18 Jul 2011 17:02:55 -0700
Message-ID: <CAAZKuFY=QEXqSD0uHYY0u8E4uiJf2xKWbQAsKde3DWcd6jOhpw@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Jul 18, 2011 at 4:49 PM, Chris Worley <worleys@gmail.com> wrote:
> Could you add-in "--loops=10000"?

No timeout occurs.

FYI, I have poked around at init.c, and feel that somehow
fill_def_thread isn't doing its job when job files are not being used:

int parse_options(int argc, char *argv[])
{
	int job_files, i;

	f_out = stdout;
	f_err = stderr;

	fio_options_fill_optstring();
	fio_options_dup_and_init(l_opts);

	if (setup_thread_area())
		return 1;
	if (fill_def_thread())
		return 1;

	job_files = parse_cmd_line(argc, argv);

	for (i = 0; i < job_files; i++) {
		if (fill_def_thread())
			return 1;
		if (parse_jobs_ini(ini_file[i], i))
			return 1;
		free(ini_file[i]);
	}

I think something is fishy here with the order of events (see
parse_cmd_line, which interprets the timeout, but fill_def_thread is
not called after that point unless there are job files). gdb seemed to
confirm that the value wasn't getting copied to the thread-local
memory.  (I also did try the non-forked based backend to make sure it
wasn't some mechanism problem there, if memory serves).

-- 
fdr
