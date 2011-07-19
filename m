Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64994 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1GSAWc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jul 2011 20:22:32 -0400
Received: by vws1 with SMTP id 1so2554436vws.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 17:22:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANWz5fg0RmLJVvfUevz7owHzasYtiNrMyFajgmnF6_QUOk44-A@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
	<CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
	<CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com>
	<CANWz5fi-=P5J=Op5o7-pr+3UMh+CLQMsnctem8hhOG2RnHuiLA@mail.gmail.com>
	<CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com>
	<CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com>
	<CAAZKuFY=QEXqSD0uHYY0u8E4uiJf2xKWbQAsKde3DWcd6jOhpw@mail.gmail.com>
	<CANWz5fg0RmLJVvfUevz7owHzasYtiNrMyFajgmnF6_QUOk44-A@mail.gmail.com>
Date: Mon, 18 Jul 2011 18:22:31 -0600
Message-ID: <CANWz5fjEAx2ksmyCpbWcGQ3HczyBafAKWqoZR1a8_vLw1cxsjA@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Farina <daniel@heroku.com>
Cc: fio@vger.kernel.org

On Mon, Jul 18, 2011 at 6:19 PM, Chris Worley <worleys@gmail.com> wrote:
> Do you mean to be using --timeout or --runtime?

I should word that differently: it works fine using "runtime=3D5",
"timeout=3D5" should work, but doesn't.

Chris
>
> On Mon, Jul 18, 2011 at 6:02 PM, Daniel Farina <daniel@heroku.com> wrote:
>> On Mon, Jul 18, 2011 at 4:49 PM, Chris Worley <worleys@gmail.com> wrote:
>>> Could you add-in "--loops=3D10000"?
>>
>> No timeout occurs.
>>
>> FYI, I have poked around at init.c, and feel that somehow
>> fill_def_thread isn't doing its job when job files are not being used:
>>
>> int parse_options(int argc, char *argv[])
>> {
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDint job_files, i;
>>
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDf_out =3D stdout;
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDf_err =3D stderr;
>>
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDfio_options_fill_optstring();
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDfio_options_dup_and_init(l_opts);
>>
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (setup_thread_area())
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BDreturn 1;
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (fill_def_thread())
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BDreturn 1;
>>
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDjob_files =3D parse_cmd_line(argc=
, argv);
>>
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDfor (i =3D 0; i < job_files; i++)=
 {
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BDif (fill_def_thread())
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDreturn 1;
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BDif (parse_jobs_ini(ini_file[i], i))
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDreturn 1;
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BDfree(ini_file[i]);
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD}
>>
>> I think something is fishy here with the order of events (see
>> parse_cmd_line, which interprets the timeout, but fill_def_thread is
>> not called after that point unless there are job files). gdb seemed to
>> confirm that the value wasn't getting copied to the thread-local
>> memory. =EF=BF=BD(I also did try the non-forked based backend to make su=
re it
>> wasn't some mechanism problem there, if memory serves).
>>
>> --
>> fdr
>>
>
