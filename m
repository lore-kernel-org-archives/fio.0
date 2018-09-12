Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeILREh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Sep 2018 13:04:37 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g03om-0003jh-TX
        for fio@vger.kernel.org; Wed, 12 Sep 2018 12:00:24 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180912120001.EDAE22C0311@kernel.dk>
Date: Wed, 12 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 39281024d26b5dbd4c70ce7620aeadc8933ac8c7:

  Merge branch 'no-unittest-dep' of https://github.com/parallel-fs-utils/fio (2018-09-10 09:56:11 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e8ed50bc3ce67f449714c55c3fbf2f8eb50730c2:

  windows: fix the most egregious posix.c style errors (2018-09-11 16:54:39 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      Merge branch 'offload-flags-fix' of https://github.com/vincentkfu/fio
      Add regression test for recent offload locking bug
      Fio 3.10
      windows: handle ERROR_NOT_READY
      windows: fix the most egregious posix.c style errors

Vincent Fu (1):
      rate_submit: synchronize accesses to io_u_queue->nr

 FIO-VERSION-GEN           |   2 +-
 os/windows/posix.c        | 366 +++++++++++++++++++++++++++-------------------
 rate-submit.c             |   2 +-
 t/jobs/t0010-b7aae4ba.fio |   8 +
 4 files changed, 229 insertions(+), 149 deletions(-)
 create mode 100644 t/jobs/t0010-b7aae4ba.fio

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f031594..f1d25d0 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.9
+DEF_VER=fio-3.10
 
 LF='
 '
diff --git a/os/windows/posix.c b/os/windows/posix.c
index d33250d..5b72bea 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -29,87 +29,149 @@ extern unsigned long mtime_since_now(struct timespec *);
 extern void fio_gettime(struct timespec *, void *);
 
 /* These aren't defined in the MinGW headers */
-HRESULT WINAPI StringCchCopyA(
-  char *pszDest,
-  size_t cchDest,
-  const char *pszSrc);
-
-HRESULT WINAPI StringCchPrintfA(
-  char *pszDest,
-  size_t cchDest,
-  const char *pszFormat,
-  ...);
+HRESULT WINAPI StringCchCopyA(char *pszDest, size_t cchDest, const char *pszSrc);
+HRESULT WINAPI StringCchPrintfA(char *pszDest, size_t cchDest, const char *pszFormat, ...);
 
 int win_to_posix_error(DWORD winerr)
 {
-	switch (winerr)
-	{
-	case ERROR_FILE_NOT_FOUND:		return ENOENT;
-	case ERROR_PATH_NOT_FOUND:		return ENOENT;
-	case ERROR_ACCESS_DENIED:		return EACCES;
-	case ERROR_INVALID_HANDLE:		return EBADF;
-	case ERROR_NOT_ENOUGH_MEMORY:	return ENOMEM;
-	case ERROR_INVALID_DATA:		return EINVAL;
-	case ERROR_OUTOFMEMORY:			return ENOMEM;
-	case ERROR_INVALID_DRIVE:		return ENODEV;
-	case ERROR_NOT_SAME_DEVICE:		return EXDEV;
-	case ERROR_WRITE_PROTECT:		return EROFS;
-	case ERROR_BAD_UNIT:			return ENODEV;
-	case ERROR_SHARING_VIOLATION:	return EACCES;
-	case ERROR_LOCK_VIOLATION:		return EACCES;
-	case ERROR_SHARING_BUFFER_EXCEEDED:	return ENOLCK;
-	case ERROR_HANDLE_DISK_FULL:	return ENOSPC;
-	case ERROR_NOT_SUPPORTED:		return ENOSYS;
-	case ERROR_FILE_EXISTS:			return EEXIST;
-	case ERROR_CANNOT_MAKE:			return EPERM;
-	case ERROR_INVALID_PARAMETER:	return EINVAL;
-	case ERROR_NO_PROC_SLOTS:		return EAGAIN;
-	case ERROR_BROKEN_PIPE:			return EPIPE;
-	case ERROR_OPEN_FAILED:			return EIO;
-	case ERROR_NO_MORE_SEARCH_HANDLES:	return ENFILE;
-	case ERROR_CALL_NOT_IMPLEMENTED:	return ENOSYS;
-	case ERROR_INVALID_NAME:		return ENOENT;
-	case ERROR_WAIT_NO_CHILDREN:	return ECHILD;
-	case ERROR_CHILD_NOT_COMPLETE:	return EBUSY;
-	case ERROR_DIR_NOT_EMPTY:		return ENOTEMPTY;
-	case ERROR_SIGNAL_REFUSED:		return EIO;
-	case ERROR_BAD_PATHNAME:		return ENOENT;
-	case ERROR_SIGNAL_PENDING:		return EBUSY;
-	case ERROR_MAX_THRDS_REACHED:	return EAGAIN;
-	case ERROR_BUSY:				return EBUSY;
-	case ERROR_ALREADY_EXISTS:		return EEXIST;
-	case ERROR_NO_SIGNAL_SENT:		return EIO;
-	case ERROR_FILENAME_EXCED_RANGE:	return EINVAL;
-	case ERROR_META_EXPANSION_TOO_LONG:	return EINVAL;
-	case ERROR_INVALID_SIGNAL_NUMBER:	return EINVAL;
-	case ERROR_THREAD_1_INACTIVE:	return EINVAL;
-	case ERROR_BAD_PIPE:			return EINVAL;
-	case ERROR_PIPE_BUSY:			return EBUSY;
-	case ERROR_NO_DATA:				return EPIPE;
-	case ERROR_MORE_DATA:			return EAGAIN;
-	case ERROR_DIRECTORY:			return ENOTDIR;
-	case ERROR_PIPE_CONNECTED:		return EBUSY;
-	case ERROR_NO_TOKEN:			return EINVAL;
-	case ERROR_PROCESS_ABORTED:		return EFAULT;
-	case ERROR_BAD_DEVICE:			return ENODEV;
-	case ERROR_BAD_USERNAME:		return EINVAL;
-	case ERROR_OPEN_FILES:			return EAGAIN;
-	case ERROR_ACTIVE_CONNECTIONS:	return EAGAIN;
-	case ERROR_DEVICE_IN_USE:		return EAGAIN;
-	case ERROR_INVALID_AT_INTERRUPT_TIME:	return EINTR;
-	case ERROR_IO_DEVICE:			return EIO;
-	case ERROR_NOT_OWNER:			return EPERM;
-	case ERROR_END_OF_MEDIA:		return ENOSPC;
-	case ERROR_EOM_OVERFLOW:		return ENOSPC;
-	case ERROR_BEGINNING_OF_MEDIA:	return ESPIPE;
-	case ERROR_SETMARK_DETECTED:	return ESPIPE;
-	case ERROR_NO_DATA_DETECTED:	return ENOSPC;
-	case ERROR_POSSIBLE_DEADLOCK:	return EDEADLOCK;
-	case ERROR_CRC:					return EIO;
-	case ERROR_NEGATIVE_SEEK:		return EINVAL;
-	case ERROR_DISK_FULL:			return ENOSPC;
-	case ERROR_NOACCESS:			return EFAULT;
-	case ERROR_FILE_INVALID:		return ENXIO;
+	switch (winerr) {
+	case ERROR_FILE_NOT_FOUND:
+		return ENOENT;
+	case ERROR_PATH_NOT_FOUND:
+		return ENOENT;
+	case ERROR_ACCESS_DENIED:
+		return EACCES;
+	case ERROR_INVALID_HANDLE:
+		return EBADF;
+	case ERROR_NOT_ENOUGH_MEMORY:
+		return ENOMEM;
+	case ERROR_INVALID_DATA:
+		return EINVAL;
+	case ERROR_OUTOFMEMORY:
+		return ENOMEM;
+	case ERROR_INVALID_DRIVE:
+		return ENODEV;
+	case ERROR_NOT_SAME_DEVICE:
+		return EXDEV;
+	case ERROR_WRITE_PROTECT:
+		return EROFS;
+	case ERROR_BAD_UNIT:
+		return ENODEV;
+	case ERROR_NOT_READY:
+		return EAGAIN;
+	case ERROR_SHARING_VIOLATION:
+		return EACCES;
+	case ERROR_LOCK_VIOLATION:
+		return EACCES;
+	case ERROR_SHARING_BUFFER_EXCEEDED:
+		return ENOLCK;
+	case ERROR_HANDLE_DISK_FULL:
+		return ENOSPC;
+	case ERROR_NOT_SUPPORTED:
+		return ENOSYS;
+	case ERROR_FILE_EXISTS:
+		return EEXIST;
+	case ERROR_CANNOT_MAKE:
+		return EPERM;
+	case ERROR_INVALID_PARAMETER:
+		return EINVAL;
+	case ERROR_NO_PROC_SLOTS:
+		return EAGAIN;
+	case ERROR_BROKEN_PIPE:
+		return EPIPE;
+	case ERROR_OPEN_FAILED:
+		return EIO;
+	case ERROR_NO_MORE_SEARCH_HANDLES:
+		return ENFILE;
+	case ERROR_CALL_NOT_IMPLEMENTED:
+		return ENOSYS;
+	case ERROR_INVALID_NAME:
+		return ENOENT;
+	case ERROR_WAIT_NO_CHILDREN:
+		return ECHILD;
+	case ERROR_CHILD_NOT_COMPLETE:
+		return EBUSY;
+	case ERROR_DIR_NOT_EMPTY:
+		return ENOTEMPTY;
+	case ERROR_SIGNAL_REFUSED:
+		return EIO;
+	case ERROR_BAD_PATHNAME:
+		return ENOENT;
+	case ERROR_SIGNAL_PENDING:
+		return EBUSY;
+	case ERROR_MAX_THRDS_REACHED:
+		return EAGAIN;
+	case ERROR_BUSY:
+		return EBUSY;
+	case ERROR_ALREADY_EXISTS:
+		return EEXIST;
+	case ERROR_NO_SIGNAL_SENT:
+		return EIO;
+	case ERROR_FILENAME_EXCED_RANGE:
+		return EINVAL;
+	case ERROR_META_EXPANSION_TOO_LONG:
+		return EINVAL;
+	case ERROR_INVALID_SIGNAL_NUMBER:
+		return EINVAL;
+	case ERROR_THREAD_1_INACTIVE:
+		return EINVAL;
+	case ERROR_BAD_PIPE:
+		return EINVAL;
+	case ERROR_PIPE_BUSY:
+		return EBUSY;
+	case ERROR_NO_DATA:
+		return EPIPE;
+	case ERROR_MORE_DATA:
+		return EAGAIN;
+	case ERROR_DIRECTORY:
+		return ENOTDIR;
+	case ERROR_PIPE_CONNECTED:
+		return EBUSY;
+	case ERROR_NO_TOKEN:
+		return EINVAL;
+	case ERROR_PROCESS_ABORTED:
+		return EFAULT;
+	case ERROR_BAD_DEVICE:
+		return ENODEV;
+	case ERROR_BAD_USERNAME:
+		return EINVAL;
+	case ERROR_OPEN_FILES:
+		return EAGAIN;
+	case ERROR_ACTIVE_CONNECTIONS:
+		return EAGAIN;
+	case ERROR_DEVICE_IN_USE:
+		return EBUSY;
+	case ERROR_INVALID_AT_INTERRUPT_TIME:
+		return EINTR;
+	case ERROR_IO_DEVICE:
+		return EIO;
+	case ERROR_NOT_OWNER:
+		return EPERM;
+	case ERROR_END_OF_MEDIA:
+		return ENOSPC;
+	case ERROR_EOM_OVERFLOW:
+		return ENOSPC;
+	case ERROR_BEGINNING_OF_MEDIA:
+		return ESPIPE;
+	case ERROR_SETMARK_DETECTED:
+		return ESPIPE;
+	case ERROR_NO_DATA_DETECTED:
+		return ENOSPC;
+	case ERROR_POSSIBLE_DEADLOCK:
+		return EDEADLOCK;
+	case ERROR_CRC:
+		return EIO;
+	case ERROR_NEGATIVE_SEEK:
+		return EINVAL;
+	case ERROR_DISK_FULL:
+		return ENOSPC;
+	case ERROR_NOACCESS:
+		return EFAULT;
+	case ERROR_FILE_INVALID:
+		return ENXIO;
+	default:
+		log_err("fio: windows error %d not handled\n", winerr);
+		return EIO;
 	}
 
 	return winerr;
@@ -138,8 +200,7 @@ int GetNumLogicalProcessors(void)
 		}
 	}
 
-	for (i = 0; i < len / sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION); i++)
-	{
+	for (i = 0; i < len / sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION); i++) {
 		if (processor_info[i].Relationship == RelationProcessorCore)
 			num_processors += hweight64(processor_info[i].ProcessorMask);
 	}
@@ -155,8 +216,7 @@ long sysconf(int name)
 	SYSTEM_INFO sysInfo;
 	MEMORYSTATUSEX status;
 
-	switch (name)
-	{
+	switch (name) {
 	case _SC_NPROCESSORS_ONLN:
 		val = GetNumLogicalProcessors();
 		if (val == -1)
@@ -226,29 +286,36 @@ char *dlerror(void)
 /* Copied from http://blogs.msdn.com/b/joshpoley/archive/2007/12/19/date-time-formats-and-conversions.aspx */
 void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 {
-    FILETIME utcFT;
-    LONGLONG jan1970;
+	FILETIME utcFT;
+	LONGLONG jan1970;
 	SYSTEMTIME tempSystemTime;
 
-    jan1970 = Int32x32To64(dosTime, 10000000) + 116444736000000000;
-    utcFT.dwLowDateTime = (DWORD)jan1970;
-    utcFT.dwHighDateTime = jan1970 >> 32;
+	jan1970 = Int32x32To64(dosTime, 10000000) + 116444736000000000;
+	utcFT.dwLowDateTime = (DWORD)jan1970;
+	utcFT.dwHighDateTime = jan1970 >> 32;
 
-    FileTimeToSystemTime((FILETIME*)&utcFT, &tempSystemTime);
+	FileTimeToSystemTime((FILETIME*)&utcFT, &tempSystemTime);
 	SystemTimeToTzSpecificLocalTime(NULL, &tempSystemTime, systemTime);
 }
 
-char* ctime_r(const time_t *t, char *buf)
+char *ctime_r(const time_t *t, char *buf)
 {
-    SYSTEMTIME systime;
-    const char * const dayOfWeek[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
-    const char * const monthOfYear[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
-
-    Time_tToSystemTime(*t, &systime);
-    /* We don't know how long `buf` is, but assume it's rounded up from the minimum of 25 to 32 */
-    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d\n", dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
-										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond, systime.wYear);
-    return buf;
+	SYSTEMTIME systime;
+	const char * const dayOfWeek[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
+	const char * const monthOfYear[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
+
+	Time_tToSystemTime(*t, &systime);
+
+	/*
+	 * We don't know how long `buf` is, but assume it's rounded up from
+	 * the minimum of 25 to 32
+	 */
+	StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d\n",
+				dayOfWeek[systime.wDayOfWeek % 7],
+				monthOfYear[(systime.wMonth - 1) % 12],
+				systime.wDay, systime.wHour, systime.wMinute,
+				systime.wSecond, systime.wYear);
+	return buf;
 }
 
 int gettimeofday(struct timeval *restrict tp, void *restrict tzp)
@@ -275,8 +342,7 @@ int gettimeofday(struct timeval *restrict tp, void *restrict tzp)
 	return 0;
 }
 
-int sigaction(int sig, const struct sigaction *act,
-		struct sigaction *oact)
+int sigaction(int sig, const struct sigaction *act, struct sigaction *oact)
 {
 	int rc = 0;
 	void (*prev_handler)(int);
@@ -291,13 +357,12 @@ int sigaction(int sig, const struct sigaction *act,
 	return rc;
 }
 
-int lstat(const char * path, struct stat * buf)
+int lstat(const char *path, struct stat *buf)
 {
 	return stat(path, buf);
 }
 
-void *mmap(void *addr, size_t len, int prot, int flags,
-		int fildes, off_t off)
+void *mmap(void *addr, size_t len, int prot, int flags, int fildes, off_t off)
 {
 	DWORD vaProt = 0;
 	DWORD mapAccess = 0;
@@ -323,25 +388,20 @@ void *mmap(void *addr, size_t len, int prot, int flags,
 	lenhigh = len >> 16;
 	/* If the low DWORD is zero and the high DWORD is non-zero, `CreateFileMapping`
 	   will return ERROR_INVALID_PARAMETER. To avoid this, set both to zero. */
-	if (lenlow == 0) {
+	if (lenlow == 0)
 		lenhigh = 0;
-	}
 
-	if (flags & MAP_ANON || flags & MAP_ANONYMOUS)
-	{
+	if (flags & MAP_ANON || flags & MAP_ANONYMOUS) {
 		allocAddr = VirtualAlloc(addr, len, MEM_COMMIT, vaProt);
 		if (allocAddr == NULL)
 			errno = win_to_posix_error(GetLastError());
-	}
-	else
-	{
-		hMap = CreateFileMapping((HANDLE)_get_osfhandle(fildes), NULL, vaProt, lenhigh, lenlow, NULL);
+	} else {
+		hMap = CreateFileMapping((HANDLE)_get_osfhandle(fildes), NULL,
+						vaProt, lenhigh, lenlow, NULL);
 
 		if (hMap != NULL)
-		{
-			allocAddr = MapViewOfFile(hMap, mapAccess, off >> 16, off & 0xFFFF, len);
-		}
-
+			allocAddr = MapViewOfFile(hMap, mapAccess, off >> 16,
+							off & 0xFFFF, len);
 		if (hMap == NULL || allocAddr == NULL)
 			errno = win_to_posix_error(GetLastError());
 
@@ -360,9 +420,7 @@ int munmap(void *addr, size_t len)
 	success = UnmapViewOfFile(addr);
 
 	if (!success)
-	{
 		success = VirtualFree(addr, 0, MEM_RELEASE);
-	}
 
 	return !success;
 }
@@ -390,8 +448,12 @@ static HANDLE log_file = INVALID_HANDLE_VALUE;
 
 void openlog(const char *ident, int logopt, int facility)
 {
-	if (log_file == INVALID_HANDLE_VALUE)
-		log_file = CreateFileA("syslog.txt", GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, 0, NULL);
+	if (log_file != INVALID_HANDLE_VALUE)
+		return;
+
+	log_file = CreateFileA("syslog.txt", GENERIC_WRITE,
+				FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
+				OPEN_ALWAYS, 0, NULL);
 }
 
 void closelog(void)
@@ -408,7 +470,9 @@ void syslog(int priority, const char *message, ... /* argument */)
 	DWORD bytes_written;
 
 	if (log_file == INVALID_HANDLE_VALUE) {
-		log_file = CreateFileA("syslog.txt", GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, 0, NULL);
+		log_file = CreateFileA("syslog.txt", GENERIC_WRITE,
+					FILE_SHARE_READ | FILE_SHARE_WRITE,
+					NULL, OPEN_ALWAYS, 0, NULL);
 	}
 
 	if (log_file == INVALID_HANDLE_VALUE) {
@@ -483,8 +547,7 @@ int clock_gettime(clockid_t clock_id, struct timespec *tp)
 {
 	int rc = 0;
 
-	if (clock_id == CLOCK_MONOTONIC)
-	{
+	if (clock_id == CLOCK_MONOTONIC) {
 		static LARGE_INTEGER freq = {{0,0}};
 		LARGE_INTEGER counts;
 		uint64_t t;
@@ -503,9 +566,7 @@ int clock_gettime(clockid_t clock_id, struct timespec *tp)
 		 * and then divide by the frequency. */
 		t *= 1000000000;
 		tp->tv_nsec = t / freq.QuadPart;
-	}
-	else if (clock_id == CLOCK_REALTIME)
-	{
+	} else if (clock_id == CLOCK_REALTIME) {
 		/* clock_gettime(CLOCK_REALTIME,...) is just an alias for gettimeofday with a
 		 * higher-precision field. */
 		struct timeval tv;
@@ -552,6 +613,7 @@ int mlock(const void * addr, size_t len)
 int munlock(const void * addr, size_t len)
 {
 	BOOL success = VirtualUnlock((LPVOID)addr, len);
+
 	if (!success) {
 		errno = win_to_posix_error(GetLastError());
 		return -1;
@@ -611,22 +673,26 @@ int shmget(key_t key, size_t size, int shmflg)
 	int mapid = -1;
 	uint32_t size_low = size & 0xFFFFFFFF;
 	uint32_t size_high = ((uint64_t)size) >> 32;
-	HANDLE hMapping = CreateFileMapping(INVALID_HANDLE_VALUE, NULL, (PAGE_EXECUTE_READWRITE | SEC_RESERVE), size_high, size_low, NULL);
+	HANDLE hMapping;
+
+	hMapping = CreateFileMapping(INVALID_HANDLE_VALUE, NULL,
+					PAGE_EXECUTE_READWRITE | SEC_RESERVE,
+					size_high, size_low, NULL);
 	if (hMapping != NULL) {
 		fileMappings[nFileMappings] = hMapping;
 		mapid = nFileMappings;
 		nFileMappings++;
-	} else {
+	} else
 		errno = ENOSYS;
-	}
 
 	return mapid;
 }
 
 void *shmat(int shmid, const void *shmaddr, int shmflg)
 {
-	void* mapAddr;
+	void *mapAddr;
 	MEMORY_BASIC_INFORMATION memInfo;
+
 	mapAddr = MapViewOfFile(fileMappings[shmid], FILE_MAP_ALL_ACCESS, 0, 0, 0);
 	if (mapAddr == NULL) {
 		errno = win_to_posix_error(GetLastError());
@@ -662,9 +728,9 @@ int shmctl(int shmid, int cmd, struct shmid_ds *buf)
 	if (cmd == IPC_RMID) {
 		fileMappings[shmid] = INVALID_HANDLE_VALUE;
 		return 0;
-	} else {
-		log_err("%s is not implemented\n", __func__);
 	}
+
+	log_err("%s is not implemented\n", __func__);
 	errno = ENOSYS;
 	return -1;
 }
@@ -753,6 +819,7 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 {
 	int64_t pos = _telli64(fildes);
 	ssize_t len = _write(fildes, buf, nbyte);
+
 	_lseeki64(fildes, pos, SEEK_SET);
 	return len;
 }
@@ -761,6 +828,7 @@ ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
 {
 	int64_t pos = _telli64(fildes);
 	ssize_t len = read(fildes, buf, nbyte);
+
 	_lseeki64(fildes, pos, SEEK_SET);
 	return len;
 }
@@ -776,11 +844,12 @@ ssize_t writev(int fildes, const struct iovec *iov, int iovcnt)
 {
 	int i;
 	DWORD bytes_written = 0;
-	for (i = 0; i < iovcnt; i++)
-	{
-		int len = send((SOCKET)fildes, iov[i].iov_base, iov[i].iov_len, 0);
-		if (len == SOCKET_ERROR)
-		{
+
+	for (i = 0; i < iovcnt; i++) {
+		int len;
+
+		len = send((SOCKET)fildes, iov[i].iov_base, iov[i].iov_len, 0);
+		if (len == SOCKET_ERROR) {
 			DWORD err = GetLastError();
 			errno = win_to_posix_error(err);
 			bytes_written = -1;
@@ -792,8 +861,7 @@ ssize_t writev(int fildes, const struct iovec *iov, int iovcnt)
 	return bytes_written;
 }
 
-long long strtoll(const char *restrict str, char **restrict endptr,
-		int base)
+long long strtoll(const char *restrict str, char **restrict endptr, int base)
 {
 	return _strtoi64(str, endptr, base);
 }
@@ -816,8 +884,7 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 	FD_ZERO(&writefds);
 	FD_ZERO(&exceptfds);
 
-	for (i = 0; i < nfds; i++)
-	{
+	for (i = 0; i < nfds; i++) {
 		if (fds[i].fd < 0) {
 			fds[i].revents = 0;
 			continue;
@@ -834,11 +901,9 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 	rc = select(nfds, &readfds, &writefds, &exceptfds, to);
 
 	if (rc != SOCKET_ERROR) {
-		for (i = 0; i < nfds; i++)
-		{
-			if (fds[i].fd < 0) {
+		for (i = 0; i < nfds; i++) {
+			if (fds[i].fd < 0)
 				continue;
-			}
 
 			if ((fds[i].events & POLLIN) && FD_ISSET(fds[i].fd, &readfds))
 				fds[i].revents |= POLLIN;
@@ -884,9 +949,11 @@ int nanosleep(const struct timespec *rqtp, struct timespec *rmtp)
 DIR *opendir(const char *dirname)
 {
 	struct dirent_ctx *dc = NULL;
+	HANDLE file;
 
 	/* See if we can open it. If not, we'll return an error here */
-	HANDLE file = CreateFileA(dirname, 0, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, NULL);
+	file = CreateFileA(dirname, 0, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
+				OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, NULL);
 	if (file != INVALID_HANDLE_VALUE) {
 		CloseHandle(file);
 		dc = (struct dirent_ctx*)malloc(sizeof(struct dirent_ctx));
@@ -929,6 +996,7 @@ struct dirent *readdir(DIR *dirp)
 
 	if (dirp->find_handle == INVALID_HANDLE_VALUE) {
 		char search_pattern[MAX_PATH];
+
 		StringCchPrintfA(search_pattern, MAX_PATH-1, "%s\\*", dirp->dirname);
 		dirp->find_handle = FindFirstFileA(search_pattern, &find_data);
 		if (dirp->find_handle == INVALID_HANDLE_VALUE)
@@ -960,8 +1028,8 @@ in_addr_t inet_network(const char *cp)
 }
 
 #ifdef CONFIG_WINDOWS_XP
-const char* inet_ntop(int af, const void *restrict src,
-		char *restrict dst, socklen_t size)
+const char *inet_ntop(int af, const void *restrict src, char *restrict dst,
+		      socklen_t size)
 {
 	INT status = SOCKET_ERROR;
 	WSADATA wsd;
@@ -977,6 +1045,7 @@ const char* inet_ntop(int af, const void *restrict src,
 	if (af == AF_INET) {
 		struct sockaddr_in si;
 		DWORD len = size;
+
 		memset(&si, 0, sizeof(si));
 		si.sin_family = af;
 		memcpy(&si.sin_addr, src, sizeof(si.sin_addr));
@@ -984,6 +1053,7 @@ const char* inet_ntop(int af, const void *restrict src,
 	} else if (af == AF_INET6) {
 		struct sockaddr_in6 si6;
 		DWORD len = size;
+
 		memset(&si6, 0, sizeof(si6));
 		si6.sin6_family = af;
 		memcpy(&si6.sin6_addr, src, sizeof(si6.sin6_addr));
@@ -1016,6 +1086,7 @@ int inet_pton(int af, const char *restrict src, void *restrict dst)
 	if (af == AF_INET) {
 		struct sockaddr_in si;
 		INT len = sizeof(si);
+
 		memset(&si, 0, sizeof(si));
 		si.sin_family = af;
 		status = WSAStringToAddressA((char*)src, af, NULL, (struct sockaddr*)&si, &len);
@@ -1024,6 +1095,7 @@ int inet_pton(int af, const char *restrict src, void *restrict dst)
 	} else if (af == AF_INET6) {
 		struct sockaddr_in6 si6;
 		INT len = sizeof(si6);
+
 		memset(&si6, 0, sizeof(si6));
 		si6.sin6_family = af;
 		status = WSAStringToAddressA((char*)src, af, NULL, (struct sockaddr*)&si6, &len);
diff --git a/rate-submit.c b/rate-submit.c
index 5c77a4e..2f02fe2 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -126,7 +126,7 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	clear_io_state(td, 1);
 
 	td_set_runstate(td, TD_RUNNING);
-	td->flags |= TD_F_CHILD;
+	td->flags |= TD_F_CHILD | TD_F_NEED_LOCK;
 	td->parent = parent;
 	return 0;
 
diff --git a/t/jobs/t0010-b7aae4ba.fio b/t/jobs/t0010-b7aae4ba.fio
new file mode 100644
index 0000000..0223770
--- /dev/null
+++ b/t/jobs/t0010-b7aae4ba.fio
@@ -0,0 +1,8 @@
+# Expected result: fio runs and completes the job
+# Buggy result: fio segfaults
+#
+[test]
+ioengine=null
+size=10g
+io_submit_mode=offload
+iodepth=16

