Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbhGZLUN (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Jul 2021 07:20:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CCFC061757
        for <fio@vger.kernel.org>; Mon, 26 Jul 2021 05:00:39 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7zHB-00DvKo-N2
        for fio@vger.kernel.org; Mon, 26 Jul 2021 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210726120002.10A6E1BC0133@kernel.dk>
Date: Mon, 26 Jul 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae5c7cdd710dfa97705d965dcf001a96504e5f31:

  Merge branch 'dedupe_workset' of https://github.com/bardavid/fio (2021-07-15 09:54:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9ce6f6f2bd636e9678982b86d6992ed419634c31:

  Merge branch 'evelu-fix-engines' of https://github.com/ErwanAliasr1/fio (2021-07-25 16:48:02 -0600)

----------------------------------------------------------------
Erwan Velu (3):
      engines: Adding exec engine
      fiograph: Adding exec engine support
      engines/exec: Code cleanup to remove leaks

Jens Axboe (3):
      Merge branch 'evelu-exec' of https://github.com/ErwanAliasr1/fio
      engines/exec: style cleanups
      Merge branch 'evelu-fix-engines' of https://github.com/ErwanAliasr1/fio

 HOWTO                        |  25 +++
 Makefile                     |   1 +
 engines/exec.c               | 394 +++++++++++++++++++++++++++++++++++++++++++
 examples/exec.fio            |  36 ++++
 examples/exec.png            | Bin 0 -> 101933 bytes
 fio.1                        |  28 +++
 os/os-windows.h              |   1 +
 tools/fiograph/fiograph.conf |   3 +
 8 files changed, 488 insertions(+)
 create mode 100644 engines/exec.c
 create mode 100644 examples/exec.fio
 create mode 100644 examples/exec.png

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a12bccba..59c7f1ff 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2139,6 +2139,9 @@ I/O engine
 			achieving higher concurrency and thus throughput than is possible
 			via kernel NFS.
 
+		**exec**
+			Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2566,6 +2569,28 @@ with the caveat that when used on the command line, they must come after the
 	URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
 	Refer to the libnfs README for more details.
 
+.. option:: program=str : [exec]
+
+	Specify the program to execute.
+
+.. option:: arguments=str : [exec]
+
+	Specify arguments to pass to program.
+	Some special variables can be expanded to pass fio's job details to the program.
+
+	**%r**
+		Replaced by the duration of the job in seconds.
+	**%n**
+		Replaced by the name of the job.
+
+.. option:: grace_time=int : [exec]
+
+	Specify the time between the SIGTERM and SIGKILL signals. Default is 1 second.
+
+.. option:: std_redirect=boot : [exec]
+
+	If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index cc7dada7..6b4b4122 100644
--- a/Makefile
+++ b/Makefile
@@ -57,6 +57,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/filedelete.c \
+		engines/exec.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/exec.c b/engines/exec.c
new file mode 100644
index 00000000..ab3639c5
--- /dev/null
+++ b/engines/exec.c
@@ -0,0 +1,394 @@
+/*
+ * Exec engine
+ *
+ * Doesn't transfer any data, merely run 3rd party tools
+ *
+ */
+#include "../fio.h"
+#include "../optgroup.h"
+#include <signal.h>
+
+struct exec_options {
+	void *pad;
+	char *program;
+	char *arguments;
+	int grace_time;
+	unsigned int std_redirect;
+	pid_t pid;
+};
+
+static struct fio_option options[] = {
+	{
+		.name = "program",
+		.lname = "Program",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct exec_options, program),
+		.help = "Program to execute",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
+		.name = "arguments",
+		.lname = "Arguments",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct exec_options, arguments),
+		.help = "Arguments to pass",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
+		.name = "grace_time",
+		.lname = "Grace time",
+		.type = FIO_OPT_INT,
+		.minval = 0,
+		.def = "1",
+		.off1 = offsetof(struct exec_options, grace_time),
+		.help = "Grace time before sending a SIGKILL",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
+		.name = "std_redirect",
+		.lname = "Std redirect",
+		.type = FIO_OPT_BOOL,
+		.def = "1",
+		.off1 = offsetof(struct exec_options, std_redirect),
+		.help = "Redirect stdout & stderr to files",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
+		.name = NULL,
+	},
+};
+
+char *str_replace(char *orig, const char *rep, const char *with)
+{
+	/*
+	 * Replace a substring by another.
+	 *
+	 * Returns the new string if occurences were found
+	 * Returns orig if no occurence is found
+	 */
+	char *result, *insert, *tmp;
+	int len_rep, len_with, len_front, count;
+
+	/* sanity checks and initialization */
+	if (!orig || !rep)
+		return orig;
+
+	len_rep = strlen(rep);
+	if (len_rep == 0)
+		return orig;
+
+	if (!with)
+		with = "";
+	len_with = strlen(with);
+
+	insert = orig;
+	for (count = 0; (tmp = strstr(insert, rep)); ++count) {
+		insert = tmp + len_rep;
+	}
+
+	tmp = result = malloc(strlen(orig) + (len_with - len_rep) * count + 1);
+
+	if (!result)
+		return orig;
+
+	while (count--) {
+		insert = strstr(orig, rep);
+		len_front = insert - orig;
+		tmp = strncpy(tmp, orig, len_front) + len_front;
+		tmp = strcpy(tmp, with) + len_with;
+		orig += len_front + len_rep;
+	}
+	strcpy(tmp, orig);
+	return result;
+}
+
+char *expand_variables(struct thread_options *o, char *arguments)
+{
+	char str[16];
+	char *expanded_runtime, *expanded_name;
+	snprintf(str, sizeof(str), "%lld", o->timeout / 1000000);
+
+	/* %r is replaced by the runtime in seconds */
+	expanded_runtime = str_replace(arguments, "%r", str);
+
+	/* %n is replaced by the name of the running job */
+	expanded_name = str_replace(expanded_runtime, "%n", o->name);
+
+	free(expanded_runtime);
+	return expanded_name;
+}
+
+static int exec_background(struct thread_options *o, struct exec_options *eo)
+{
+	char *outfilename = NULL, *errfilename = NULL;
+	int outfd = 0, errfd = 0;
+	pid_t pid;
+	char *expanded_arguments = NULL;
+	/* For the arguments splitting */
+	char **arguments_array = NULL;
+	char *p;
+	char *exec_cmd = NULL;
+	size_t arguments_nb_items = 0, q;
+
+	if (asprintf(&outfilename, "%s.stdout", o->name) < 0)
+		return -1;
+
+	if (asprintf(&errfilename, "%s.stderr", o->name) < 0) {
+		free(outfilename);
+		return -1;
+	}
+
+	/* If we have variables in the arguments, let's expand them */
+	expanded_arguments = expand_variables(o, eo->arguments);
+
+	if (eo->std_redirect) {
+		log_info("%s : Saving output of %s %s : stdout=%s stderr=%s\n",
+			 o->name, eo->program, expanded_arguments, outfilename,
+			 errfilename);
+
+		/* Creating the stderr & stdout output files */
+		outfd = open(outfilename, O_CREAT | O_WRONLY | O_TRUNC, 0644);
+		if (outfd < 0) {
+			log_err("fio: cannot open output file %s : %s\n",
+				outfilename, strerror(errno));
+			free(outfilename);
+			free(errfilename);
+			free(expanded_arguments);
+			return -1;
+		}
+
+		errfd = open(errfilename, O_CREAT | O_WRONLY | O_TRUNC, 0644);
+		if (errfd < 0) {
+			log_err("fio: cannot open output file %s : %s\n",
+				errfilename, strerror(errno));
+			free(outfilename);
+			free(errfilename);
+			free(expanded_arguments);
+			close(outfd);
+			return -1;
+		}
+	} else {
+		log_info("%s : Running %s %s\n",
+			 o->name, eo->program, expanded_arguments);
+	}
+
+	pid = fork();
+
+	/* We are on the control thread (parent side of the fork */
+	if (pid > 0) {
+		eo->pid = pid;
+		if (eo->std_redirect) {
+			/* The output file is for the client side of the fork */
+			close(outfd);
+			close(errfd);
+			free(outfilename);
+			free(errfilename);
+		}
+		free(expanded_arguments);
+		return 0;
+	}
+
+	/* If the fork failed */
+	if (pid < 0) {
+		log_err("fio: forking failed %s \n", strerror(errno));
+		if (eo->std_redirect) {
+			close(outfd);
+			close(errfd);
+			free(outfilename);
+			free(errfilename);
+		}
+		free(expanded_arguments);
+		return -1;
+	}
+
+	/* We are in the worker (child side of the fork) */
+	if (pid == 0) {
+		if (eo->std_redirect) {
+			/* replace stdout by the output file we create */
+			dup2(outfd, 1);
+			/* replace stderr by the output file we create */
+			dup2(errfd, 2);
+			close(outfd);
+			close(errfd);
+			free(outfilename);
+			free(errfilename);
+		}
+
+		/*
+		 * Let's split the command line into a null terminated array to
+		 * be passed to the exec'd program.
+		 * But don't asprintf expanded_arguments if NULL as it would be
+		 * converted to a '(null)' argument, while we want no arguments
+		 * at all.
+		 */
+		if (expanded_arguments != NULL) {
+			if (asprintf(&exec_cmd, "%s %s", eo->program, expanded_arguments) < 0) {
+				free(expanded_arguments);
+				return -1;
+			}
+		} else {
+			if (asprintf(&exec_cmd, "%s", eo->program) < 0)
+				return -1;
+		}
+
+		/*
+		 * Let's build an argv array to based on the program name and
+		 * arguments
+		 */
+		p = exec_cmd;
+		for (;;) {
+			p += strspn(p, " ");
+
+			if (!(q = strcspn(p, " ")))
+				break;
+
+			if (q) {
+				arguments_array =
+				    realloc(arguments_array,
+					    (arguments_nb_items +
+					     1) * sizeof(char *));
+				arguments_array[arguments_nb_items] =
+				    malloc(q + 1);
+				strncpy(arguments_array[arguments_nb_items], p,
+					q);
+				arguments_array[arguments_nb_items][q] = 0;
+				arguments_nb_items++;
+				p += q;
+			}
+		}
+
+		/* Adding a null-terminated item to close the list */
+		arguments_array =
+		    realloc(arguments_array,
+			    (arguments_nb_items + 1) * sizeof(char *));
+		arguments_array[arguments_nb_items] = NULL;
+
+		/*
+		 * Replace the fio program from the child fork by the target
+		 * program
+		 */
+		execvp(arguments_array[0], arguments_array);
+	}
+	/* We never reach this place */
+	/* Let's free the malloc'ed structures to make static checkers happy */
+	if (expanded_arguments)
+		free(expanded_arguments);
+	if (arguments_array)
+		free(arguments_array);
+	return 0;
+}
+
+static enum fio_q_status
+fio_exec_queue(struct thread_data *td, struct io_u fio_unused * io_u)
+{
+	struct thread_options *o = &td->o;
+	struct exec_options *eo = td->eo;
+
+	/* Let's execute the program the first time we get queued */
+	if (eo->pid == -1) {
+		exec_background(o, eo);
+	} else {
+		/*
+		 * The program is running in background, let's check on a
+		 * regular basis
+		 * if the time is over and if we need to stop the tool
+		 */
+		usleep(o->thinktime);
+		if (utime_since_now(&td->start) > o->timeout) {
+			/* Let's stop the child */
+			kill(eo->pid, SIGTERM);
+			/*
+			 * Let's give grace_time (1 sec by default) to the 3rd
+			 * party tool to stop
+			 */
+			sleep(eo->grace_time);
+		}
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_exec_init(struct thread_data *td)
+{
+	struct thread_options *o = &td->o;
+	struct exec_options *eo = td->eo;
+	int td_previous_state;
+
+	eo->pid = -1;
+
+	if (!eo->program) {
+		td_vmsg(td, EINVAL,
+			"no program is defined, it is mandatory to define one",
+			"exec");
+		return 1;
+	}
+
+	log_info("%s : program=%s, arguments=%s\n",
+		 td->o.name, eo->program, eo->arguments);
+
+	/* Saving the current thread state */
+	td_previous_state = td->runstate;
+
+	/*
+	 * Reporting that we are preparing the engine
+	 * This is useful as the qsort() calibration takes time
+	 * This prevents the job from starting before init is completed
+	 */
+	td_set_runstate(td, TD_SETTING_UP);
+
+	/*
+	 * set thinktime_sleep and thinktime_spin appropriately
+	 */
+	o->thinktime_blocks = 1;
+	o->thinktime_blocks_type = THINKTIME_BLOCKS_TYPE_COMPLETE;
+	o->thinktime_spin = 0;
+	/* 50ms pause when waiting for the program to complete */
+	o->thinktime = 50000;
+
+	o->nr_files = o->open_files = 1;
+
+	/* Let's restore the previous state. */
+	td_set_runstate(td, td_previous_state);
+	return 0;
+}
+
+static void fio_exec_cleanup(struct thread_data *td)
+{
+	struct exec_options *eo = td->eo;
+	/* Send a sigkill to ensure the job is well terminated */
+	if (eo->pid > 0)
+		kill(eo->pid, SIGKILL);
+}
+
+static int
+fio_exec_open(struct thread_data fio_unused * td,
+	      struct fio_file fio_unused * f)
+{
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name = "exec",
+	.version = FIO_IOOPS_VERSION,
+	.queue = fio_exec_queue,
+	.init = fio_exec_init,
+	.cleanup = fio_exec_cleanup,
+	.open_file = fio_exec_open,
+	.flags = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOIO,
+	.options = options,
+	.option_struct_size = sizeof(struct exec_options),
+};
+
+static void fio_init fio_exec_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_exec_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/exec.fio b/examples/exec.fio
new file mode 100644
index 00000000..ac1bedfb
--- /dev/null
+++ b/examples/exec.fio
@@ -0,0 +1,36 @@
+[global]
+time_based
+runtime=30
+
+[monitoring_noop]
+ioengine=exec
+program=/usr/sbin/turbostat
+arguments=-c package -qS --interval 5 -s Busy%,Bzy_MHz,Avg_MHz,CorWatt,PkgWatt,RAMWatt,PkgTmp
+
+[cpuload_noop]
+ioengine=cpuio
+cpuload=100
+numjobs=12
+cpumode=noop
+
+[sleep]
+# Let the processor cooling down for a few seconds
+stonewall
+ioengine=exec
+runtime=10
+program=/bin/sleep
+arguments=%r
+grace_time=0
+std_redirect=0
+
+[monitoring_qsort]
+stonewall
+ioengine=exec
+program=/usr/sbin/turbostat
+arguments=-c package -qS --interval 5 -s Busy%,Bzy_MHz,Avg_MHz,CorWatt,PkgWatt,RAMWatt,PkgTmp
+
+[cpuload_qsort]
+ioengine=cpuio
+cpuload=100
+numjobs=12
+cpumode=qsort
diff --git a/examples/exec.png b/examples/exec.png
new file mode 100644
index 00000000..5f9f3b59
Binary files /dev/null and b/examples/exec.png differ
diff --git a/fio.1 b/fio.1
index bd315e11..6cc82542 100644
--- a/fio.1
+++ b/fio.1
@@ -1954,6 +1954,9 @@ I/O engine supporting asynchronous read and write operations to
 NFS filesystems from userspace via libnfs. This is useful for
 achieving higher concurrency and thus throughput than is possible
 via kernel NFS.
+.TP
+.B exec
+Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2340,6 +2343,31 @@ Use DAOS container's object class by default.
 .BI (nfs)nfs_url
 URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
 Refer to the libnfs README for more details.
+.TP
+.BI (exec)program\fR=\fPstr
+Specify the program to execute.
+Note the program will receive a SIGTERM when the job is reaching the time limit.
+A SIGKILL is sent once the job is over. The delay between the two signals is defined by \fBgrace_time\fR option.
+.TP
+.BI (exec)arguments\fR=\fPstr
+Specify arguments to pass to program.
+Some special variables can be expanded to pass fio's job details to the program :
+.RS
+.RS
+.TP
+.B %r
+replaced by the duration of the job in seconds
+.TP
+.BI %n
+replaced by the name of the job
+.RE
+.RE
+.TP
+.BI (exec)grace_time\fR=\fPint
+Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
+.TP
+.BI (exec)std_redirect\fR=\fbool
+If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/os/os-windows.h b/os/os-windows.h
index ddfae413..59da9dba 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -77,6 +77,7 @@
 #define SIGCONT	0
 #define SIGUSR1	1
 #define SIGUSR2 2
+#define SIGKILL 15 /* SIGKILL doesn't exists, let's use SIGTERM */
 
 typedef int sigset_t;
 typedef int siginfo_t;
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 7b851e19..5becc4d9 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -35,6 +35,9 @@ specific_options=pool  cont  chunk_size  object_class  svcl
 [ioengine_e4defrag]
 specific_options=donorname  inplace
 
+[ioengine_exec]
+specific_options=program arguments grace_time std_redirect
+
 [ioengine_filestat]
 specific_options=stat_type
 

