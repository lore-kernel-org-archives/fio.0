Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 01/11] configure: Disable CONFIG_POSIX_FALLOCATE on NetBSD even if posix_fallocate(3) compiles
Date: Mon,  1 May 2017 21:48:10 +0300
Message-Id: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio on NetBSD may have CONFIG_POSIX_FALLOCATE configuration enabled
since posix_fallocate(3) compiles (at least on recent versions),
but this is actually not supported on UFS as mentioned in below wiki
and fio result.

https://wiki.netbsd.org/projects/project/ffs-fallocate/
> This functionality is not currently implemented for FFS;

compile_prog() during ./configure fails to catch this as it doesn't
run the test code after compilation (and it needs to use a valid fd
in order to do runtime test).

This commit simply disables CONFIG_POSIX_FALLOCATE on NetBSD regardless
of compilation result on ./configure. It doesn't check the fs type,
but it should be enough provided that UFS is the fs used by majority
of users and there's also no real alternative for disk fs.

-- yes for posix_fallocate(3), but EOPNOTSUPP on runtime
 # uname
 NetBSD
 # gmake clean >/dev/null 2>&1
 # ./configure | grep "POSIX fallocate"
 POSIX fallocate               yes
 # grep -A1 posix_fallocate ./config.log
 Compiling test case posix_fallocate
 gcc -D_GNU_SOURCE -include config-host.h -o /tmp/fio-conf--23834-.exe /tmp/fio-conf--23834-.c -lrt -lz
 # gmake -j8 >/dev/null 2>&1
 # ./fio --name=xxxxx --ioengine=sync --rw=read --bs=2k --size=1m --unlink=1 | grep posix_fallocate
 fio: posix_fallocate fails: Operation not supported

-- try posix_fallocate(3) test in ./configure with a valid fd
 # uname
 NetBSD
 # cat ./test2.c
 #include <stdio.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 int main(int argc, char **argv)
 {
   int r, fd;
   fd = open(argv[1], O_WRONLY | O_CREAT, 0644);
   if (fd < 0)
           return errno;
   r = posix_fallocate(fd, 0, 1024);
   close(fd);
   return r;
 }
 # gcc -Wall -g ./test2.c
 # ./a.out xxx; echo $?
 45

-- try above on Linux
 # uname
 Linux
 # gcc -Wall -g ./test2.c
 # ./a.out xxx; echo $?
 0

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure   | 5 +++++
 filesetup.c | 6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index bcb898a..c3e06cd 100755
--- a/configure
+++ b/configure
@@ -781,6 +781,11 @@ EOF
 if compile_prog "" "" "posix_fallocate"; then
     posix_fallocate="yes"
 fi
+# Ignore the result for NetBSD since it's not supported at least on UFS,
+# which is what people basically use on NetBSD.
+if test "$targetos" = "NetBSD"; then
+    posix_fallocate="no"
+fi
 echo "POSIX fallocate               $posix_fallocate"
 
 ##########################################
diff --git a/filesetup.c b/filesetup.c
index 612e794..23fd537 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -109,7 +109,11 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
 				 f->file_name,
 				 (unsigned long long) f->real_file_size);
-
+			/*
+			 * Note that some OS/filesystem, for e.g. UFS on NetBSD
+			 * doesn't support posix_fallocate(3) even if it compiles.
+			 * Try to avoid it on ./configure if it's a known issue.
+			 */
 			r = posix_fallocate(f->fd, 0, f->real_file_size);
 			if (r > 0) {
 				log_err("fio: posix_fallocate fails: %s\n",
-- 
2.9.3


