Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43808 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760877Ab3D3WEd convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 30 Apr 2013 18:04:33 -0400
From: "Akers, Jason B" <jason.b.akers@intel.com>
Subject: android ashmem patch [review request]
Date: Tue, 30 Apr 2013 22:04:14 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B85069DFC9@ORSMSX110.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

I wrapped the ashmem calls with the existing shm* function definitions. It's a little ugly, but makes for an easy patch touching only os/os-android.h.

Tested on both arm and x86 android phones.

Jason Akers


--- a/os/os-android.h	2013-04-30 14:30:05.014461848 -0700
+++ b/os/os-android.h	2013-04-30 14:24:49.442213734 -0700
@@ -57,24 +57,65 @@
 #include <linux/shm.h>
 #define SHM_HUGETLB    04000
 
+#include <stdio.h>
+#include <linux/ashmem.h>
+#include <sys/mman.h>
+
+#define ASHMEM_DEVICE	"/dev/ashmem"
+
 static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
 {
-	return syscall(__NR_shmctl, __shmid, __cmd, __buf);
+	int ret=0;
+	if (__cmd == IPC_RMID)
+	{
+		int length = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
+		struct ashmem_pin pin = {0 , length};
+		ret = ioctl(__shmid, ASHMEM_UNPIN, &pin);
+		close(__shmid);
+	}
+	return ret;
 }
 
 static inline int shmget (key_t __key, size_t __size, int __shmflg)
 {
-	return syscall(__NR_shmget, __key, __size, __shmflg);
+	int fd,ret;
+	char key[11];
+	
+	fd = open(ASHMEM_DEVICE, O_RDWR);
+	if (fd < 0)
+		return fd;
+
+	sprintf(key,"%d",__key);
+	ret = ioctl(fd, ASHMEM_SET_NAME, key);
+	if (ret < 0)
+		goto error;
+
+	ret = ioctl(fd, ASHMEM_SET_SIZE, __size);
+	if (ret < 0)
+		goto error;
+
+	return fd;
+	
+error:
+	close(fd);
+	return ret;
 }
 
 static inline void *shmat (int __shmid, const void *__shmaddr, int __shmflg)
 {
-	return (void *)syscall(__NR_shmat, __shmid, __shmaddr, __shmflg);
+	size_t *ptr, size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
+	ptr = mmap(NULL, size + sizeof(size_t), PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
+	*ptr = size;    //save size at beginning of buffer, for use with munmap
+	return &ptr[1];
 }
 
 static inline int shmdt (const void *__shmaddr)
 {
-	return syscall(__NR_shmctl, __shmaddr);
+	size_t *ptr, size;
+	ptr = (size_t *)__shmaddr;
+	ptr--;
+	size = *ptr;    //find mmap size which we stored at the beginning of the buffer
+	return munmap((void *)ptr, size + sizeof(size_t));
 }

