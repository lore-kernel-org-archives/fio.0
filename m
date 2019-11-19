Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726307AbfKSS33 (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 19 Nov 2019 13:29:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJIQFjU003932
        for <fio@vger.kernel.org>; Tue, 19 Nov 2019 10:29:28 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc8423fby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Tue, 19 Nov 2019 10:29:28 -0800
From: Joseph DeVincentis <jdevincentis@marvell.com>
Subject: fio successful completions followed by segfault
Date: Tue, 19 Nov 2019 18:29:25 +0000
Message-ID: <MN2PR18MB287796333F64B6B6F78B0169C44C0@MN2PR18MB2877.namprd18.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I am seeing rare segfaults running "fio" threaded.  In these
tests, fio is executed threaded for 60 second run periods, over
and over again for 24 hours (simplified).

The fio operations always complete, results are reported, they are=20
always successful, it's just that rarely, the exit status reported by=20
the fio run is 139 / segfault.  The failure rate is perhaps 1 to 3
fio "runs" over a 24 hour period, so its not easy to reproduce.

I am running --threads, --numjobs=3D4.  (I am running 12 VMs, 2vcpus
per, 2Gmem per, and this "fio stress" is one of a few other things
going on in each of the VMs).

I think the bug is that the worker threads (thread_main) are detatched,
and left to run to completion without coordination by "run_threads()", henc=
e
they are in a race with the main code flow.  The main code flow eventually
frees the thread specific memory, and I think that's where this segfault co=
mes from.

The job ("thread_main") threads indicate that it is "done" via
changing its state to TD_EXITED.  This allows run_threads() to "reap"
their status, and then the code to finishup/exit.

However, "thread_main" makes function calls and even dereferences the=20
thread specific data AFTER it has indicated its state is TD_EXITED.

The final line of "thread_main" is ;
                return (void *) (uintptr_t) td->error;

Since the main code flow doesn't know that a thread is just about to resume
and dereference the thread specific data, (it doesn't know anything about
the "main_thread" threads), it can't guarantee that it is safe
to free the thread specific data (which it does via atexit()).

I have captured a few of these segfaults in a modified fio installing a
backtrace dump on segv handler, and the segfault has always been
on the last line of thread_main, e.g. dereferencing the thread specific
pointer "td".

I have also captured one failure under gdb, automating the invocation of=20
gdb/fio with an expect script.  This script dumped the CPU registers and th=
e
register holding the "td" pointer looked "sane", yet it still segfaulted. =
=20

This can be explained by a thread that has just resumed, so its registers=20
hold what look like valid virtual addresses to the thread specific memory=20
(td pointer), but that memory has been freed by atexit(), and is no longer=
=20
mapped.

The version of fio is 3.9, however the latest version (3.16) has
the same code, so I expect it could fail the same way if things
line up just right.

      fio --version=20
      fio-3.9

Solutions:

If the threads are going to be detatched, and "completion" is indicated
via TD_EXITED, then I don't think thread_main should do anything after=20
"td_set_runstate(td, TD_EXITED);" to avoid any race conditions.

A different option would be to leave the "thread_main" threads attached,=20
and add a small loop (for_each_td) that joins the pthreads and guarantees
no race condition exists between the worker threads and the main code
flow.

Experiments:

1) In backend.c:thread_main, I captured td->error into a local var,=20
prior to "thread_main" indicating TD_EXITED, and changed the return to retu=
rn=20
the local var, and ran 72 hours without failure in a scenario that fails
at least 3 times per 24 hours.

2) I changed "thread_main" to NOT detatch the pthreads, and added
explicit pthread_join() to the end of "run_threads()", and I have
yet to see a failure (obviously I need to run for a very long time
to be certain, my typical run periods are 24 hours per scenario).

These are my parameters to fio.

fio --name=3Drandrw --minimal --readwrite=3Drandrw \
    --rwmixwrite=3D0 --bs=3D8192 --invalidate=3D1 --end_fsync=3D0 \
    --directory=3D/home/disk_stress --size=3D1048676 \
    --time_based --runtime=3D10 --group_reporting \
    --numjobs=3D4  --norandommap --randrepeat=3D0 --iodepth=3D8 \
    --direct=3D1 --thread

Thanks,
Joe



