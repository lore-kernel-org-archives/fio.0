Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 12/15] Fix stat(2) related bugs introduced by changes made for Windows
Date: Wed, 27 Jul 2016 22:37:17 +0900
Message-Id: <1469626640-13335-12-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Non-Windows could have regular files that start with "\\\\.\\",
so the conditionals added by ecc314ba and 3892182a in 2011-2012
introduced corner case bugs, though in reality I doubt anyone
would want to create such a file.

This commit brings back the original conditional that was there
before ecc314ba for non-Windows platforms. It also adds WIN32
guard for a change made by 3892182a.

--
 # uname
 Linux
 # cat ./test1.c
 #include <stdio.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 /* copied from fio/init.c */
 static int exists_and_not_file(const char *filename)
 {
 	struct stat sb;
 	if (lstat(filename, &sb) == -1)
 		return 0;
 	/* \\.\ is the device namespace in Windows, where every file
 	 * is a device node */
 	if (S_ISREG(sb.st_mode) && strncmp(filename, "\\\\.\\", 4) != 0)
 		return 0;
 	return 1;
 }
 int main(int argc, char **argv) {
 	printf("exists_and_not_file(\"%s\") = %d\n",
 		argv[1], exists_and_not_file(argv[1]));
 	return 0;
 }
 # gcc -Wall -g ./test1.c -o test1
 # ls /dev/sda
 /dev/sda
 # ./test1 /dev/sda
 exists_and_not_file("/dev/sda") = 1  /* the existing blkdev isn't a file */
 # touch xxxxx
 # ./test1 ./xxxxx
 exists_and_not_file("./xxxxx") = 0  /* the existing regfile is not not a file */
 # touch "\\\\.\\xxxxx"
 # ./test1 "\\\\.\\xxxxx"
 exists_and_not_file("\\.\xxxxx") = 1  /* XXX */
 # stat "\\\\.\\xxxxx" | head -2
   File: `\\\\.\\xxxxx'
   Size: 0               Blocks: 0          IO Block: 4096   regular empty file

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 filesetup.c | 2 ++
 init.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index d208a69..a48faf5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1225,10 +1225,12 @@ static void get_file_type(struct fio_file *f)
 	else
 		f->filetype = FIO_TYPE_FILE;
 
+#ifdef WIN32
 	/* \\.\ is the device namespace in Windows, where every file is
 	 * a block device */
 	if (strncmp(f->file_name, "\\\\.\\", 4) == 0)
 		f->filetype = FIO_TYPE_BD;
+#endif
 
 	if (!stat(f->file_name, &sb)) {
 		if (S_ISBLK(sb.st_mode))
diff --git a/init.c b/init.c
index 47519bf..82b21c7 100644
--- a/init.c
+++ b/init.c
@@ -911,10 +911,15 @@ static int exists_and_not_file(const char *filename)
 	if (lstat(filename, &sb) == -1)
 		return 0;
 
+#ifndef WIN32 /* NOT Windows */
+	if (S_ISREG(sb.st_mode))
+		return 0;
+#else
 	/* \\.\ is the device namespace in Windows, where every file
 	 * is a device node */
 	if (S_ISREG(sb.st_mode) && strncmp(filename, "\\\\.\\", 4) != 0)
 		return 0;
+#endif
 
 	return 1;
 }
-- 
2.5.5


