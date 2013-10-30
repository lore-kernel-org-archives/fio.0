Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50362 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3J3Wbi (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Oct 2013 18:31:38 -0400
Received: by mail-ee0-f41.google.com with SMTP id e53so984971eek.28
        for <fio@vger.kernel.org>; Wed, 30 Oct 2013 15:31:37 -0700 (PDT)
MIME-Version: 1.0
From: Niraj Tolia <ntolia@maginatics.com>
Date: Wed, 30 Oct 2013 15:31:17 -0700
Message-ID: <CA+6NFoB5ikwUcHkYE=fau0J6AdTK6RKtXVUpjodr-1BccbKEXA@mail.gmail.com>
Subject: Confusion with jobname, nrfiles, and numjobs
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am confused around the interaction between the jobname, nrfiles, and
numjobs parameters together and, in particular, where nrfiles == 1. In
this case, when I run fio with nrfiles=1 and numjobs=3, only one file
is created. However, if I bump nrfiles=2, 6 files are created. I can
repro this with HEAD.

FIO=fio-data-$(date +%s)

rm -rf ${FIO} && mkdir ${FIO} && \
  ./fio --name=${FIO} --directory=${FIO} --rw=write --size=1m \
  --bs=64k --scramble_buffers=1 --ioengine=sync --nrfiles=2 \
  --numjobs=3 > /dev/null && ls ${FIO} | wc -l
       6

rm -rf ${FIO} && mkdir ${FIO} && \
  ./fio --name=${FIO} --directory=${FIO} --rw=write --size=1m \
  --bs=64k --scramble_buffers=1 --ioengine=sync --nrfiles=1 \
  --numjobs=3 > /dev/null && ls ${FIO} | wc -l
       1

Note that the filename in the run with --nrfiles=1 is simply "jobname"
instead of "jobname.jobnumber.filenumber". After looking at the code,
it turns out that this happens because the job name is the same as the
directory name. A very quick code scan leads me to believe that this
comes from init.c that does this:

                if (o->nr_files == 1 && exists_and_not_file(jobname))
                        add_file(td, jobname);
                else {
                        for (i = 0; i < o->nr_files; i++)
                add_file(td, make_filename(fname, o, jobname,
td->thread_number, i));
                }

Is there a reason for the short circuit in the first case? Would be
great to document this somewhere if there is a reason the code should
stay.

Cheers,
Niraj
