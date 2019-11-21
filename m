Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKUN74 (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 21 Nov 2019 08:59:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALDvDTk027015
        for <fio@vger.kernel.org>; Thu, 21 Nov 2019 05:59:55 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842dhwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 21 Nov 2019 05:59:55 -0800
From: Joseph DeVincentis <jdevincentis@marvell.com>
Subject: RE: fio successful completions followed by segfault
Date: Thu, 21 Nov 2019 13:59:52 +0000
Message-ID: <DM6PR18MB2874CA8E0E01B4F6AB0A2B6EC44E0@DM6PR18MB2874.namprd18.prod.outlook.com>
References: <MN2PR18MB287796333F64B6B6F78B0169C44C0@MN2PR18MB2877.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB287796333F64B6B6F78B0169C44C0@MN2PR18MB2877.namprd18.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I modified both fio 3.9 and 3.16, adding logic to run_threads in backend.c,=
 to use pthread-join to ensure that the worker threads have exited before c=
ontinuing.
This has run > 24 hours without any issues.
Following is the git diff for backend.c

--Joe


diff --git a/backend.c b/backend.c
index 1c33940..646e783 100644
--- a/backend.c
+++ b/backend.c
@@ -2354,10 +2354,6 @@ reap:
 					break;
 				}
 				fd =3D NULL;
-				ret =3D pthread_detach(td->thread);
-				if (ret)
-					log_err("pthread_detach: %s",
-							strerror(ret));
 			} else {
 				pid_t pid;
 				dprint(FD_PROCESS, "will fork\n");
@@ -2455,6 +2451,18 @@ reap:
 	fio_idle_prof_stop();
=20
 	update_io_ticks();
+
+
+	for_each_td(td, i) {
+		int ret;
+		if (td->o.use_thread)
+		{
+			ret =3D pthread_join(td->thread, NULL);
+			if (ret) {
+				log_err("pthread_join: %s\n", strerror(ret));
+			}
+		}
+	}
 }
=20
 static void free_disk_util(void)

-----Original Message-----
From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of Jo=
seph DeVincentis
Sent: Tuesday, November 19, 2019 1:29 PM
To: fio@vger.kernel.org
Subject: fio successful completions followed by segfault

Hello,

I am seeing rare segfaults running "fio" threaded.  In these tests, fio is =
executed threaded for 60 second run periods, over and over again for 24 hou=
rs (simplified).

The fio operations always complete, results are reported, they are always s=
uccessful, it's just that rarely, the exit status reported by the fio run i=
s 139 / segfault.  The failure rate is perhaps 1 to 3 fio "runs" over a 24 =
hour period, so its not easy to reproduce.

I am running --threads, --numjobs=3D4.  (I am running 12 VMs, 2vcpus per, 2=
Gmem per, and this "fio stress" is one of a few other things going on in ea=
ch of the VMs).

I think the bug is that the worker threads (thread_main) are detatched, and=
 left to run to completion without coordination by "run_threads()", hence t=
hey are in a race with the main code flow.  The main code flow eventually f=
rees the thread specific memory, and I think that's where this segfault com=
es from.

The job ("thread_main") threads indicate that it is "done" via changing its=
 state to TD_EXITED.  This allows run_threads() to "reap"
their status, and then the code to finishup/exit.

However, "thread_main" makes function calls and even dereferences the threa=
d specific data AFTER it has indicated its state is TD_EXITED.

The final line of "thread_main" is ;
                return (void *) (uintptr_t) td->error;

Since the main code flow doesn't know that a thread is just about to resume=
 and dereference the thread specific data, (it doesn't know anything about =
the "main_thread" threads), it can't guarantee that it is safe to free the =
thread specific data (which it does via atexit()).

I have captured a few of these segfaults in a modified fio installing a bac=
ktrace dump on segv handler, and the segfault has always been on the last l=
ine of thread_main, e.g. dereferencing the thread specific pointer "td".

I have also captured one failure under gdb, automating the invocation of gd=
b/fio with an expect script.  This script dumped the CPU registers and the =
register holding the "td" pointer looked "sane", yet it still segfaulted. =
=20

This can be explained by a thread that has just resumed, so its registers h=
old what look like valid virtual addresses to the thread specific memory (t=
d pointer), but that memory has been freed by atexit(), and is no longer ma=
pped.

The version of fio is 3.9, however the latest version (3.16) has the same c=
ode, so I expect it could fail the same way if things line up just right.

      fio --version=20
      fio-3.9

Solutions:

If the threads are going to be detatched, and "completion" is indicated via=
 TD_EXITED, then I don't think thread_main should do anything after "td_set=
_runstate(td, TD_EXITED);" to avoid any race conditions.

A different option would be to leave the "thread_main" threads attached, an=
d add a small loop (for_each_td) that joins the pthreads and guarantees no =
race condition exists between the worker threads and the main code flow.

Experiments:

1) In backend.c:thread_main, I captured td->error into a local var, prior t=
o "thread_main" indicating TD_EXITED, and changed the return to return the =
local var, and ran 72 hours without failure in a scenario that fails at lea=
st 3 times per 24 hours.

2) I changed "thread_main" to NOT detatch the pthreads, and added explicit =
pthread_join() to the end of "run_threads()", and I have yet to see a failu=
re (obviously I need to run for a very long time to be certain, my typical =
run periods are 24 hours per scenario).

These are my parameters to fio.

fio --name=3Drandrw --minimal --readwrite=3Drandrw \
    --rwmixwrite=3D0 --bs=3D8192 --invalidate=3D1 --end_fsync=3D0 \
    --directory=3D/home/disk_stress --size=3D1048676 \
    --time_based --runtime=3D10 --group_reporting \
    --numjobs=3D4  --norandommap --randrepeat=3D0 --iodepth=3D8 \
    --direct=3D1 --thread

Thanks,
Joe



