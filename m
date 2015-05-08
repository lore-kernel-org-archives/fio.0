Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbEHMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 May 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yqgwk-0000rD-Lv
	for fio@vger.kernel.org; Fri, 08 May 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150508120001.51CFF2C1078@kernel.dk>
Date: Fri,  8 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 477bd5ab362b65fe9c7749735236e6ed0d4346f8:

  server: bump version (2015-05-06 15:21:19 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 81f3d8e9b0c7e178fc308e6416fade2756898fed:

  Fio 2.2.8 (2015-05-07 18:19:25 -0600)

----------------------------------------------------------------
Ben England (3):
      allow --client to work with shared filesystem
      allow --client parameter to be pathname containing client host IPs/names
      document changes to --client syntax and behavior

Bruce Cran (3):
      Add Windows ctime_r implementation and add empty ioctl.h header
      Fix compiler warning and test progs linker errors on Windows
      Fix Windows installer build: LICENSE is now MORAL-LICENSE

Jens Axboe (8):
      Merge branch 'multiclnt-sharedfs-try3' of git://github.com/bengland2/fio
      Ensure that set_name_idx() doesn't exceed target bounds
      posixaio: use 'errno' for inline error
      Merge branch 'client-hostfile' of git://github.com/bengland2/fio
      Fix keyword replacement leaks
      README: add git:// for github as well
      Use PATH_MAX instead of _POSIX_HOST_NAME_MAX
      Fio 2.2.8

 FIO-VERSION-GEN                      |  2 +-
 Makefile                             |  6 ++++++
 README                               | 30 ++++++++++++++++++++++++++++--
 engines/posixaio.c                   |  2 +-
 filesetup.c                          |  2 +-
 fio.1                                | 31 +++++++++++++++++++++++++++++--
 fio.c                                | 14 ++++++++++----
 fio.h                                |  2 ++
 init.c                               | 29 +++++++++++++++++++++++++++++
 libfio.c                             |  5 +++++
 options.c                            | 25 +++++++++++++++++++++++--
 options.h                            |  4 +++-
 os/os-windows.h                      |  1 +
 os/windows/install.wxs               |  6 +++---
 os/windows/posix.c                   | 24 ++++++++++++++++++++++++
 os/windows/posix/include/sys/ioctl.h |  7 +++++++
 server.c                             |  1 +
 17 files changed, 174 insertions(+), 17 deletions(-)
 create mode 100644 os/windows/posix/include/sys/ioctl.h

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 22c9f68..25fad7d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.7
+DEF_VER=fio-2.2.8
 
 LF='
 '
diff --git a/Makefile b/Makefile
index 1b312cb..d9aedf5 100644
--- a/Makefile
+++ b/Makefile
@@ -218,6 +218,12 @@ T_OBJS += $(T_LFSR_TEST_OBJS)
 T_OBJS += $(T_BTRACE_FIO_OBJS)
 T_OBJS += $(T_DEDUPE_OBJS)
 
+ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
+    T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
+    T_SMALLOC_OBJS += os/windows/posix.o lib/hweight.o
+    T_LFSR_TEST_OBJS += os/windows/posix.o lib/hweight.o
+endif
+
 T_TEST_PROGS = $(T_SMALLOC_PROGS)
 T_TEST_PROGS += $(T_IEEE_PROGS)
 T_PROGS += $(T_ZIPF_PROGS)
diff --git a/README b/README
index 18d1c4f..25189f8 100644
--- a/README
+++ b/README
@@ -35,6 +35,7 @@ down for some reason, either one of those is safe to use:
 
 or
 
+	git://github.com/axboe/fio.git
 	https://github.com/axboe/fio.git
 
 
@@ -172,7 +173,7 @@ $ fio
 	--warnings-fatal	Fio parser warnings are fatal
 	--max-jobs		Maximum number of threads/processes to support
 	--server=args		Start backend server. See Client/Server section.
-	--client=host		Connect to specified backend.
+	--client=host		Connect to specified backend(s).
 	--remote-config=file	Tell fio server to load this local file
 	--idle-prof=option	Report cpu idleness on a system or percpu basis
 				(option=system,percpu) or run unit work
@@ -311,9 +312,34 @@ to load a local file as well. This is done by using --remote-config:
 
 fio --client=server --remote-config /path/to/file.fio
 
-Then the fio server will open this local (to the server) job file instead
+Then fio will open this local (to the server) job file instead
 of being passed one from the client.
 
+If you have many servers (example: 100 VMs/containers), 
+you can input a pathname of a file containing host IPs/names as the parameter 
+value for the --client option.  For example, here is an example "host.list" 
+file containing 2 hostnames:
+
+host1.your.dns.domain
+host2.your.dns.domain
+
+The fio command would then be:
+
+fio --client=host.list <job file(s)>
+
+In this mode, you cannot input server-specific parameters or job files -- all
+servers receive the same job file.  
+
+In order to let fio --client runs use a shared filesystem 
+from multiple hosts, fio  --client now prepends the IP address of the 
+server to the filename.  For example, if fio is using directory /mnt/nfs/fio 
+and is writing filename fileio.tmp, with a --client hostfile containing 
+two hostnames h1 and h2 with IP addresses 192.168.10.120 and  192.168.10.121,
+then fio will create two files:
+
+	/mnt/nfs/fio/192.168.10.120.fileio.tmp
+	/mnt/nfs/fio/192.168.10.121.fileio.tmp
+
 
 Platforms
 ---------
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 8ab88fb..29bcc5a 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -198,7 +198,7 @@ static int fio_posixaio_queue(struct thread_data *td,
 	}
 
 	if (ret) {
-		int aio_err = aio_error(aiocb);
+		int aio_err = errno;
 
 		/*
 		 * At least OSX has a very low limit on the number of pending
diff --git a/filesetup.c b/filesetup.c
index 10fc415..aee7ece 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1262,7 +1262,7 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	dprint(FD_FILE, "add file %s\n", fname);
 
 	if (td->o.directory)
-		len = set_name_idx(file_name, td->o.directory, numjob);
+		len = set_name_idx(file_name, PATH_MAX, td->o.directory, numjob);
 
 	sprintf(file_name + len, "%s", fname);
 
diff --git a/fio.1 b/fio.1
index e54e419..e5451b1 100644
--- a/fio.1
+++ b/fio.1
@@ -93,7 +93,7 @@ Start a backend server, with \fIargs\fP specifying what to listen to. See client
 Background a fio server, writing the pid to the given pid file.
 .TP
 .BI \-\-client \fR=\fPhost
-Instead of running the jobs locally, send and run them on the given host.
+Instead of running the jobs locally, send and run them on the given host or set of hosts.  See client/server section.
 .TP
 .BI \-\-idle\-prof \fR=\fPoption
 Report cpu idleness on a system or percpu basis (\fIoption\fP=system,percpu) or run unit work calibration only (\fIoption\fP=calibrate).
@@ -1911,8 +1911,35 @@ to load a local file as well. This is done by using \-\-remote-config:
 
 fio \-\-client=server \-\-remote-config /path/to/file.fio
 
-Then the fio serer will open this local (to the server) job file instead
+Then fio will open this local (to the server) job file instead
 of being passed one from the client.
+
+If you have many servers (example: 100 VMs/containers), you can input a pathname 
+of a file containing host IPs/names as the parameter value for the \-\-client option.
+For example, here is an example "host.list" file containing 2 hostnames:
+
+host1.your.dns.domain
+.br
+host2.your.dns.domain
+
+The fio command would then be:
+
+fio \-\-client=host.list <job file>
+
+In this mode, you cannot input server-specific parameters or job files, and all
+servers receive the same job file.
+
+In order to enable fio \-\-client runs utilizing a shared filesystem from multiple hosts,
+fio \-\-client now prepends the IP address of the server to the filename. For example, 
+if fio is using directory /mnt/nfs/fio and is writing filename fileio.tmp, 
+with a \-\-client hostfile
+containing two hostnames h1 and h2 with IP addresses 192.168.10.120 and 192.168.10.121, then
+fio will create two files:
+
+/mnt/nfs/fio/192.168.10.120.fileio.tmp
+.br
+/mnt/nfs/fio/192.168.10.121.fileio.tmp
+
 .SH AUTHORS
 
 .B fio
diff --git a/fio.c b/fio.c
index 9adc29a..ee6eae2 100644
--- a/fio.c
+++ b/fio.c
@@ -30,6 +30,8 @@
 
 int main(int argc, char *argv[], char *envp[])
 {
+	int ret = 1;
+
 	if (initialize_fio(envp))
 		return 1;
 
@@ -38,7 +40,7 @@ int main(int argc, char *argv[], char *envp[])
 #endif
 
 	if (parse_options(argc, argv))
-		return 1;
+		goto done;
 
 	fio_time_init();
 
@@ -46,8 +48,12 @@ int main(int argc, char *argv[], char *envp[])
 		set_genesis_time();
 
 		if (fio_start_all_clients())
-			return 1;
-		return fio_handle_clients(&fio_client_ops);
+			goto done;
+		ret = fio_handle_clients(&fio_client_ops);
 	} else
-		return fio_backend();
+		ret = fio_backend();
+
+done:
+	deinitialize_fio();
+	return ret;
 }
diff --git a/fio.h b/fio.h
index 0d5a0ef..6659e28 100644
--- a/fio.h
+++ b/fio.h
@@ -464,6 +464,7 @@ extern void reset_fio_state(void);
 extern void clear_io_state(struct thread_data *);
 extern int fio_options_parse(struct thread_data *, char **, int, int);
 extern void fio_keywords_init(void);
+extern void fio_keywords_exit(void);
 extern int fio_cmd_option_parse(struct thread_data *, const char *, char *);
 extern int fio_cmd_ioengine_option_parse(struct thread_data *, const char *, char *);
 extern void fio_fill_default_options(struct thread_data *);
@@ -483,6 +484,7 @@ extern int fio_set_fd_nonblocking(int, const char *);
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
 extern int initialize_fio(char *envp[]);
+extern void deinitialize_fio(void);
 
 #define FIO_GETOPT_JOB		0x89000000
 #define FIO_GETOPT_IOENGINE	0x98000000
diff --git a/init.c b/init.c
index 1a5d4c9..fa50d3c 100644
--- a/init.c
+++ b/init.c
@@ -2242,6 +2242,35 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				exit_val = 1;
 				break;
 			}
+			/* if --client parameter contains a pathname */
+			if (0 == access(optarg, R_OK)) {
+				/* file contains a list of host addrs or names */
+				char hostaddr[PATH_MAX] = {0};
+				char formatstr[8];
+				FILE * hostf = fopen(optarg, "r");
+				if (!hostf) {
+					log_err("fio: could not open client list file %s for read\n", optarg);
+					do_exit++;
+					exit_val = 1;
+					break;
+				}
+				sprintf(formatstr, "%%%ds", PATH_MAX - 1);
+				/*
+				 * read at most PATH_MAX-1 chars from each
+				 * record in this file
+				 */
+				while (fscanf(hostf, formatstr, hostaddr) == 1) {
+					/* expect EVERY host in file to be valid */
+					if (fio_client_add(&fio_client_ops, hostaddr, &cur_client)) {
+						log_err("fio: failed adding client %s from file %s\n", hostaddr, optarg);
+						do_exit++;
+						exit_val = 1;
+						break;
+					}
+				}
+				fclose(hostf);
+				break; /* no possibility of job file for "this client only" */
+			}
 			if (fio_client_add(&fio_client_ops, optarg, &cur_client)) {
 				log_err("fio: failed adding client %s\n", optarg);
 				do_exit++;
diff --git a/libfio.c b/libfio.c
index ed26114..3a28f55 100644
--- a/libfio.c
+++ b/libfio.c
@@ -353,3 +353,8 @@ int initialize_fio(char *envp[])
 	fio_keywords_init();
 	return 0;
 }
+
+void deinitialize_fio(void)
+{
+	fio_keywords_exit();
+}
diff --git a/options.c b/options.c
index 40b69ed..f21ed26 100644
--- a/options.c
+++ b/options.c
@@ -8,6 +8,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <netinet/in.h>
 
 #include "fio.h"
 #include "verify.h"
@@ -17,6 +18,8 @@
 
 #include "crc/crc32c.h"
 
+char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
+
 /*
  * Check if mmap/mmaphuge has a :/foo/bar/file at the end. If so, return that.
  */
@@ -820,7 +823,7 @@ static int get_max_name_idx(char *input)
  * Returns the directory at the index, indexes > entires will be
  * assigned via modulo division of the index
  */
-int set_name_idx(char *target, char *input, int index)
+int set_name_idx(char *target, size_t tlen, char *input, int index)
 {
 	unsigned int cur_idx;
 	int len;
@@ -832,7 +835,13 @@ int set_name_idx(char *target, char *input, int index)
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
 		fname = get_next_name(&str);
 
-	len = sprintf(target, "%s/", fname);
+	if (client_sockaddr_str[0]) {
+		len = snprintf(target, tlen, "%s/%s.", fname,
+				client_sockaddr_str);
+	} else
+		len = snprintf(target, tlen, "%s/", fname);
+
+	target[tlen - 1] = '\0';
 	free(p);
 
 	return len;
@@ -3813,6 +3822,18 @@ static struct fio_keyword fio_keywords[] = {
 	},
 };
 
+void fio_keywords_exit(void)
+{
+	struct fio_keyword *kw;
+
+	kw = &fio_keywords[0];
+	while (kw->word) {
+		free(kw->replace);
+		kw->replace = NULL;
+		kw++;
+	}
+}
+
 void fio_keywords_init(void)
 {
 	unsigned long long mb_memory;
diff --git a/options.h b/options.h
index 2cf435a..6805b31 100644
--- a/options.h
+++ b/options.h
@@ -18,7 +18,9 @@ void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
 char *get_name_idx(char *, int);
-int set_name_idx(char *, char *, int);
+int set_name_idx(char *, size_t, char *, int);
+
+extern char client_sockaddr_str[];  /* used with --client option */
 
 extern struct fio_option fio_options[FIO_MAX_OPTS];
 
diff --git a/os/os-windows.h b/os/os-windows.h
index 6603635..9e931c9 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -105,6 +105,7 @@ int fcntl(int fildes, int cmd, ...);
 int fdatasync(int fildes);
 int lstat(const char * path, struct stat * buf);
 uid_t geteuid(void);
+char* ctime_r(const time_t *t, char *buf);
 int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index ba58b92..2a67a4d 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.7">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.8">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
@@ -40,7 +40,7 @@
 							<File Id="COPYING" Name="COPYING.txt" Source="..\..\COPYING"/>
 						</Component>
 						<Component>
-							<File Id="LICENSE" Name="LICENSE.txt" Source="..\..\LICENSE"/>
+							<File Id="MORAL_LICENSE" Name="MORAL-LICENSE.txt" Source="..\..\MORAL-LICENSE"/>
 						</Component>
 						<Directory Id="examples" Name="examples"/>
 					</Directory>
@@ -54,7 +54,7 @@
 		<ComponentRef Id="README"/>
 		<ComponentRef Id="REPORTING_BUGS"/>
 		<ComponentRef Id="COPYING"/>
-		<ComponentRef Id="LICENSE"/>
+		<ComponentRef Id="MORAL_LICENSE"/>
 		<ComponentGroupRef Id="examples"/>
 	</Feature>
 
diff --git a/os/windows/posix.c b/os/windows/posix.c
index d238c64..41fc480 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -229,6 +229,30 @@ char *dlerror(void)
 	return dl_error;
 }
 
+/* Copied from http://blogs.msdn.com/b/joshpoley/archive/2007/12/19/date-time-formats-and-conversions.aspx */
+void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
+{
+    LARGE_INTEGER jan1970FT;
+    LARGE_INTEGER utcFT;
+    jan1970FT.QuadPart = 116444736000000000LL; // january 1st 1970
+    utcFT.QuadPart = ((unsigned __int64)dosTime) * 10000000 + jan1970FT.QuadPart;
+
+    FileTimeToSystemTime((FILETIME*)&utcFT, systemTime);
+}
+
+char* ctime_r(const time_t *t, char *buf)
+{
+    SYSTEMTIME systime;
+    const char * const dayOfWeek[] = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
+    const char * const monthOfYear[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
+
+    Time_tToSystemTime(*t, &systime);
+    /* We don't know how long `buf` is, but assume it's rounded up from the minimum of 25 to 32 */
+    StringCchPrintfA(buf, 32, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek - 1], monthOfYear[systime.wMonth - 1],
+										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond, systime.wYear);
+    return buf;
+}
+
 int gettimeofday(struct timeval *restrict tp, void *restrict tzp)
 {
 	FILETIME fileTime;
diff --git a/os/windows/posix/include/sys/ioctl.h b/os/windows/posix/include/sys/ioctl.h
new file mode 100644
index 0000000..a42247d
--- /dev/null
+++ b/os/windows/posix/include/sys/ioctl.h
@@ -0,0 +1,7 @@
+#ifndef IOCTL_H
+#define IOCTL_H
+
+/* This file is empty since it only needs to exist on Windows
+   but isn't otherwise used */
+
+#endif /* IOCTL_H */
\ No newline at end of file
diff --git a/server.c b/server.c
index 93c0987..7a9b0a4 100644
--- a/server.c
+++ b/server.c
@@ -1007,6 +1007,7 @@ static int accept_loop(int listen_sk)
 		}
 
 		/* exits */
+		strncpy(client_sockaddr_str, from, INET6_ADDRSTRLEN);
 		handle_connection(sk);
 	}
 
