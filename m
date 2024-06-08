Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA398E57D
	for <fio@vger.kernel.org>; Sat,  8 Jun 2024 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717854287; cv=none; b=S2teFQcH6Hjmpu8syrWapMoiQCWLLsrPvgCJzzca4gZvIhqqxxDrmlxTsUAyz/6oiZvX2Mh9P1ugzEG4wy77QWq5p49aSbWGQLzdjb774aTfaG+V9S6GNd+R+r0agX9t03LjgALMRaIMH/76vKlHAVF6Xl0h9OjHToLoGbEAaPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717854287; c=relaxed/simple;
	bh=RIzhxDYH7Iwa6UZw3SDf9nDS3f3nmBxzVuajGI4P6LI=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=iixluO9aUI2ilW5ISXFRutW5eaVpIN/aA26IaMli+wvm/RjeMyDluMVrt4WfN0y5rLpm3PTo1mIzBX6QKVTXgTZEhpb7es7fT/91m5nO83JIqsQuYBsIVSp2YP5LiqyGxWEsgEqjba0Sjf5dc2Kx7z4o5hXqtdvjMyXI5pJOdMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rz55ghxR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rz55ghxR"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 458DCl1p027614
	for <fio@vger.kernel.org>; Sat, 8 Jun 2024 13:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:subject:message-id:content-type:sender
	:content-transfer-encoding:mime-version; s=pp1; bh=T3Hqo4LdQ8/vS
	N/PshXROwoFvlv6Qd/3JheeWXGBULQ=; b=rz55ghxRsC5RSNr83b4duz/BbiDhA
	/GcUVFJeNgrXsYBKiM04lLa6P3cwBRj36Ion/OMbB6WmgQzSJfUiPabTenJKLtEY
	eAjkjkxBBcGBZWrIdT45uWicQRBHGqwEJLOJ/HqW6SVhJZOBv979EWARUJYguIdk
	J6tb3qa1kJ6RT9Zgj9UEVTjWtqm13F5HrCsD/IQVkQiaYhlt4LGXR4F9k8l29Zz9
	sIKe6iWeSbYFnek5VbJO2Y7UUorI7wYQP2INIds/nqJytXdwWWGJ1tJ4INQe4mwX
	QMhTqha6FzTdHmdW2u7yDc2Ox4aleAW+3LlzW+JXlaWyPUJCd/7AzZpQg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ymqsdr1wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Sat, 08 Jun 2024 13:44:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 458BLkXi002504
	for <fio@vger.kernel.org>; Sat, 8 Jun 2024 13:44:42 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ymff9t61g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Sat, 08 Jun 2024 13:44:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 458DibGG51642854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 8 Jun 2024 13:44:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D90C2004B;
	Sat,  8 Jun 2024 13:44:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4266A20040;
	Sat,  8 Jun 2024 13:44:37 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.13.161])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat,  8 Jun 2024 13:44:37 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.97.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1sFwN2-00000004Vky-3hdB;
	Sat, 08 Jun 2024 15:44:36 +0200
Date: Sat, 8 Jun 2024 15:44:36 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: fio list <fio@vger.kernel.org>
Subject: Regression with 40f61ec71936 ("cpus_allowed: use __NRPROCESSORS_CONF
 instead of __SC_NPROCESSORS_ONLN for non-sequential CPU ids") and Idleness
 Profiling
Message-ID: <20240608134436.GA957171@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vd3KBAPOHFX-_Gxmzb_0wEGmyQGWv2Pd
X-Proofpoint-GUID: vd3KBAPOHFX-_Gxmzb_0wEGmyQGWv2Pd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-08_07,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1011 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406080100

Hello,

Not sure whether you prefer Github reports or this format. If you want me to
re-create this on Github, please do tell.

I've noticed that when I run fio on a system where
`sysconf(_SC_NPROCESSORS_CONF)` returns a higher/different number than
processors that are really online right now, and I enable idleness profiling
via the command line switch `--idle-prof=system` fio first prints hundreds (in
my case) of error messages, and after running all jobs, it doesn't quit, but
is stuck on a wait condition.

Environment:
 * Architecture: s390x
 * Generation: IBM z16
 * Hypervisor: LPAR
 * Operating System: Linux (Fedora 40)
 * Kernel: v6.10.0-rc2
 * fio: v3.37

Here `sysconf(_SC_NPROCESSORS_CONF)` returns 400, but this LPAR partition has
only 8 processors online (indexes 0-7, so nothing with holes).

Because of that, when initializing idleness profiling

    void fio_idle_prof_init(void)
    {
    	int i, ret;
    	struct timespec ts;
    	pthread_attr_t tattr;
    	pthread_condattr_t cattr;
    	struct idle_prof_thread *ipt;
    
    	ipc.nr_cpus = cpus_configured();
    	ipc.status = IDLE_PROF_STATUS_OK;

`ipc.nr_cpus` is set to 400. It then starts 400 profiling threads for 8
processors

    	for (i = 0; i < ipc.nr_cpus; i++) {
    		ipt = &ipc.ipts[i];
    
    		ipt->cpu = i;	

		...
    
    		if ((ret = pthread_create(&ipt->thread, &tattr, idle_prof_thread_fn, ipt))) {

Each of these is meant to be pinned to a specific CPU; done via
`set_cpu_affinity()`

    static int set_cpu_affinity(struct idle_prof_thread *ipt)
    {
    #if defined(FIO_HAVE_CPU_AFFINITY)
    	if (fio_cpuset_init(&ipt->cpu_mask)) {
    		log_err("fio: cpuset init failed\n");
    		return -1;
    	}
    
    	fio_cpu_set(&ipt->cpu_mask, ipt->cpu);
    
    	if (fio_setaffinity(gettid(), ipt->cpu_mask)) {
    		log_err("fio: fio_setaffinity failed\n");
    		fio_cpuset_exit(&ipt->cpu_mask);
    		return -1;
    	}
    
    	return 0;
    #else

But `fio_setaffinity()`, which is `sched_setaffinity()` on Linux, returns an
error, if the given CPU mask is invalid, because none of the CPUs in it are
available

    sched_setaffinity(2)          System Calls Manual         sched_setaffinity(2)
    
    ...
    
    ERRORS
         EFAULT A supplied memory address was invalid.
    
         EINVAL The  affinity bit mask mask contains no processors that are cur‐
                rently physically on the system and permitted to the thread  ac‐
                cording  to  any  restrictions  that  may  be  imposed by cpuset
                cgroups or the "cpuset" mechanism described in cpuset(7).

So 392 out of the 400 profiling threads will receive `EINVAL` here and print
`fio: fio_setaffinity failed`. That's sorta annoying/confusing; but this has
other side effects.

Frist of which is, the profiling threads that *do* correspond to an existing
processor do not actually start profiling. I noticed that when I took a glance
at `top` while the job was running; usually you'd expect all processor to have
100% utilization due to the profiling threads, but not so on my system; they
are all idle (apart from minor noise).

Secondly, `fio` doesn't quit after all jobs are done, but is stuck. I killed
one of these stuck processes and collected a coredump (`kill -QUIT`), and it
is stuck on a pthread condition

    GNU gdb (Fedora Linux) 14.2-2.fc40
    
    ...
    
    Core was generated by `fio --output out.json --output-format=json+ --idle-prof=system ../test.fio'.
    
    ...
    
    (gdb) info threads
      Id   Target Id                        Frame
    * 1    Thread 0x3ff87869860 (LWP 18868) 0x000003ff86ba8b4e in __futex_abstimed_wait_common64 (private=0, futex_word=0x2236c88, expected=0, op=137, abstime=0x3ffe0cf1830,
        cancel=<optimized out>) at futex-internal.c:57
      2    Thread 0x3ff787008c0 (LWP 18877) 0x000003ff86c2916c in __GI___select (nfds=<optimized out>, readfds=0x3ff786ffbf8, writefds=0x0, exceptfds=0x3ff786ffb78, timeout=0x0)
        at ../sysdeps/unix/sysv/linux/select.c:69
    (gdb) bt
    #0  0x000003ff86ba8b4e in __futex_abstimed_wait_common64 (private=0, futex_word=0x2236c88, expected=0, op=137, abstime=0x3ffe0cf1830, cancel=<optimized out>) at futex-internal.c:57
    #1  __futex_abstimed_wait_common (futex_word=futex_word@entry=0x2236c88, expected=expected@entry=0, clockid=clockid@entry=1, abstime=abstime@entry=0x3ffe0cf1830,
        private=private@entry=0, cancel=true) at futex-internal.c:87
    #2  0x000003ff86ba8bb8 in __GI___futex_abstimed_wait_cancelable64 (futex_word=futex_word@entry=0x2236c88, expected=expected@entry=0, clockid=clockid@entry=1,
        abstime=abstime@entry=0x3ffe0cf1830, private=private@entry=0) at futex-internal.c:139
    #3  0x000003ff86babb4a in __pthread_cond_wait_common (cond=0x2236c60, mutex=0x2236cb8, clockid=1, abstime=0x3ffe0cf1830) at pthread_cond_wait.c:503
    #4  ___pthread_cond_timedwait64 (cond=0x2236c60, mutex=0x2236cb8, abstime=0x3ffe0cf1830) at pthread_cond_wait.c:643
    #5  0x00000000010b4938 in fio_idle_prof_stop () at idletime.c:380
    #6  0x00000000010aa2d0 in run_threads (sk_out=0x0) at backend.c:2613
    #7  0x00000000010aa4f2 in fio_backend (sk_out=0x0) at backend.c:2666
    #8  0x00000000010f1906 in main (argc=6, argv=0x3ffe0cf9e78, envp=0x3ffe0cf9eb0) at fio.c:60

    ...

    (gdb) up
    #5  0x00000000010b4938 in fio_idle_prof_stop () at idletime.c:380
    380                             pthread_cond_timedwait(&ipt->cond, &ipt->start_lock, &ts);
    (gdb) l
    375                     while ((ipt->state != TD_EXITED) &&
    376                            (ipt->state!=TD_NOT_CREATED)) {
    377                             fio_gettime(&ts, NULL);
    378                             ts.tv_sec += 1;
    379                             /* timed wait in case a signal is not received */
    380                             pthread_cond_timedwait(&ipt->cond, &ipt->start_lock, &ts);
    381                     }
    382                     pthread_mutex_unlock(&ipt->start_lock);
    383
    384                     /* calculate idleness */
    (gdb) p *ipt
    $2 = {thread = 4395781589184, cpu = 0, state = 2, tps = {tv_sec = 4294967296, tv_nsec = 3926762167912908}, tpe = {tv_sec = 8589934592, tv_nsec = 3926762167912908},
      cali_time = 21.789999999999999, loops = 1.9400782865548643e-308, idleness = 8.4879831638610893e-314,
      data = 0x2257920 "\031\032\033\034\035\036\037 !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\177\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337", <incomplete sequence \340>..., cond = {__data = {__wseq = {__value64 = 2, __value32 = {__low = 0, __high = 2}}, __g1_start = {__value64 = 0, __value32 = {__low = 0, __high = 0}}, __g_refs = {2,
            0}, __g_size = {0, 0}, __g1_orig_size = 0, __wrefs = 10, __g_signals = {0, 0}},
        __size = "\000\000\000\000\000\000\000\002", '\000' <repeats 11 times>, "\002", '\000' <repeats 19 times>, "\n\000\000\000\000\000\000\000", __align = 2}, init_lock = {__data = {
          __lock = 0, __count = 0, __owner = 0, __nusers = 0, __kind = 0, __spins = 0, __elision = 0, __list = {__prev = 0x0, __next = 0x0}}, __size = '\000' <repeats 39 times>,
        __align = 0}, start_lock = {__data = {__lock = 0, __count = 0, __owner = 0, __nusers = 1, __kind = 0, __spins = 0, __elision = 0, __list = {__prev = 0x0, __next = 0x0}},
        __size = '\000' <repeats 15 times>, "\001", '\000' <repeats 23 times>, __align = 0}, cpu_mask = {__bits = {1, 0 <repeats 15 times>}}}
    (gdb) t 2
    
    [Switching to thread 2 (Thread 0x3ff787008c0 (LWP 18877))]
    #0  0x000003ff86c2916c in __GI___select (nfds=<optimized out>, readfds=0x3ff786ffbf8, writefds=0x0, exceptfds=0x3ff786ffb78, timeout=0x0) at ../sysdeps/unix/sysv/linux/select.c:69
    69        int r = SYSCALL_CANCEL (pselect6_time64, nfds, readfds, writefds, exceptfds,
    (gdb) bt
    
    #0  0x000003ff86c2916c in __GI___select (nfds=<optimized out>, readfds=0x3ff786ffbf8, writefds=0x0, exceptfds=0x3ff786ffb78, timeout=0x0) at ../sysdeps/unix/sysv/linux/select.c:69
    #1  0x00000000010bad5c in wait_for_action (fd=4, timeout_ms=250) at helper_thread.c:223
    #2  0x00000000010bb2ea in helper_thread_main (data=0x3ff84b25150) at helper_thread.c:325
    #3  0x000003ff86bac3fa in start_thread (arg=0x3ff787008c0) at pthread_create.c:447
    #4  0x000003ff86c2bdd0 in thread_start () at ../sysdeps/unix/sysv/linux/s390/s390-64/clone3.S:71

And since no other threads are running anymore in this process, I assume this
will be stuck forever unless killed by someone.

Looking at `ipt->state` in the gdb output above, it is `TD_INITIALIZED`, so
while that profiling thread was able to get past `set_cpu_affinity()`, it
never got into state `TD_RUNNING`; which probably explains why I didn't see
any load in `top`, if all profiling thread are like that.

Right, in `fio_idle_prof_init()`, after it started all the 400 profiling
threads, it goes over each of their states, and waits until they either have
exited (`TD_EXITED`) or are finished initializing (`TD_INITIALIZED`)

    void fio_idle_prof_init(void)
    {
    	...

    	ipc.status = IDLE_PROF_STATUS_OK;
    
    	...
    	
    	/* wait for calibration to finish */
    	for (i = 0; i < ipc.nr_cpus; i++) {
    		ipt = &ipc.ipts[i];
    		pthread_mutex_lock(&ipt->init_lock);
    		while ((ipt->state != TD_EXITED) &&
    		       (ipt->state!=TD_INITIALIZED)) {

    			...

    			pthread_cond_timedwait(&ipt->cond, &ipt->init_lock, &ts);
    		}
    		pthread_mutex_unlock(&ipt->init_lock);
    	
		...

    		if (ipt->state == TD_EXITED)
    			ipc.status = IDLE_PROF_STATUS_ABORT;
    	}

In case they already exited, like in my case, where 392 threads are unable to
be pinned to a specific CPU, we set `ipc.status` to `IDLE_PROF_STATUS_ABORT`,
signaling that profiling should be completely aborted. I guess the rational
is, otherwise we skew the result, in case a legitimate profiling thread aborts
for some reason.
    This happens here.

This is done before `&ipt->start_lock` is unlocked in `fio_idle_prof_start()`.
And that causes all the other profiling threads to exit, before they change
their state into `TD_RUNNING`

    static void *idle_prof_thread_fn(void *data)
    {
    	...
    
    	ipt->state = TD_INITIALIZED;
    
    	/* signal the main thread that calibration is done */
    	pthread_cond_signal(&ipt->cond);
    	pthread_mutex_unlock(&ipt->init_lock);
    
    	/* wait for other calibration to finish */
    	pthread_mutex_lock(&ipt->start_lock);
    
    	/* exit if other threads failed to initialize */
    	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
    		pthread_mutex_unlock(&ipt->start_lock);
    		goto do_exit;
    	}
    
    	...
    
    	fio_gettime(&ipt->tps, NULL);
    	ipt->state = TD_RUNNING;

	...

    do_exit:
    	free_cpu_affinity(ipt);
    	return NULL;
    }

They also don't set `TD_EXITED` in this scenario, and so, when `fio` tries to
exit eventually, and `fio_idle_prof_stop()` is called it gets stuck in the
loop seen above in the `gdb` session

    void fio_idle_prof_stop(void)
    {
    	...
    
    	ipc.status = IDLE_PROF_STATUS_PROF_STOP;
    
    	/* wait for all threads to exit from profiling */
    	for (i = 0; i < ipc.nr_cpus; i++) {
    		ipt = &ipc.ipts[i];
    		pthread_mutex_lock(&ipt->start_lock);
    		while ((ipt->state != TD_EXITED) &&
    		       (ipt->state!=TD_NOT_CREATED)) {
    			fio_gettime(&ts, NULL);
    			ts.tv_sec += 1;
    			/* timed wait in case a signal is not received */
    			pthread_cond_timedwait(&ipt->cond, &ipt->start_lock, &ts);
    		}
    		pthread_mutex_unlock(&ipt->start_lock);

The inner `while` condition won't ever be true here, because the threads that
actually managed to bind to a specific CPU exited with `TD_INITIALIZED` as
their state.

As for the "regression" in the subject. Before
40f61ec71936 ("cpus_allowed: use __NRPROCESSORS_CONF instead of __SC_NPROCESSORS_ONLN for non-sequential CPU ids")
`fio` would use `sysconf(_SC_NPROCESSORS_ONLN)`, which we then only start as
many idleness profiling threads as CPUs are online, which on my system would
work as expect. Changing

    @@ -183,13 +180,14 @@ static void calibration_stats(void)
     
     void fio_idle_prof_init(void)
     {
    -	int i, ret;
    +	int i, ret, cpus;
     	struct timespec ts;
     	pthread_attr_t tattr;
     	pthread_condattr_t cattr;
     	struct idle_prof_thread *ipt;
     
    -	ipc.nr_cpus = cpus_configured();
    +	cpus = get_nprocs();
    +	ipc.nr_cpus = (cpus < 1 ? 1 : cpus);
     	ipc.status = IDLE_PROF_STATUS_OK;
     
     	if (ipc.opt == IDLE_PROF_OPT_NONE)

makes idleness profiling work as expected for me. But of course, the patch in
questioned aimed at system where there are "holes" in the CPU list, with some
processors not being online. So that change would assumable not work for such
systems.

Making a small change like this to the profiling thread

    @@ -123,13 +123,11 @@ static void *idle_prof_thread_fn(void *data)
     
     	/* exit if other threads failed to initialize */
     	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
    -		pthread_mutex_unlock(&ipt->start_lock);
     		goto do_exit;
     	}
     
v     	/* exit if we are doing calibration only */
     	if (ipc.status == IDLE_PROF_STATUS_CALI_STOP) {
    -		pthread_mutex_unlock(&ipt->start_lock);
     		goto do_exit;
     	}
     
    @@ -151,10 +149,9 @@ static void *idle_prof_thread_fn(void *data)
     idle_prof_done:
     
     	ipt->loops = j + (double) k / page_size;
    +do_exit:
     	ipt->state = TD_EXITED;
     	pthread_mutex_unlock(&ipt->start_lock);
    -
    -do_exit:
     	free_cpu_affinity(ipt);
     	return NULL;
     }

fixes the issue that `fio` doesn't exit in case a profiling thread
aborts/exits before reaching their main loop. But with things like they are,
this would still exit *all* profiling threads, in case even one aborts,
because e.g. can't pin itself to a processor.

I guess, one would have to check whether a thread corresponds to an online
processor, or not, before deciding to either start it at all, or whether to
abort all other threads in case it aborts later, because it can't set it's
affinity.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
