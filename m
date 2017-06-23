Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/8] ignore directory= if the given path is absolute
Date: Sat, 24 Jun 2017 01:07:54 +0300
Message-Id: <20170623220801.38178-2-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

When filename= is specified in absolute path format (starts with '/'),
being able to use directory= doesn't make much sense and also likely
to result in an unexpected error, thus it should be ignored if any.

(If combining directory= and absolute filename= is a feature rather
than unexpected, then it should be documented, since it works as long
as directory/filename doesn't contain invalid directory. For example,
directory=. and filename=/tmp/xxx work as ./tmp/xxx if ./tmp exists
as shown in below.)

Not sure about the proper way to handle this on Windows, so I had to
add WIN32 guard.

--
 # ./fio --version
 fio-2.21-26-gcf6b7
 # ls ./tmp
 ls: cannot access './tmp': No such file or directory
 # ./fio --name=xxxxx --ioengine=sync --rw=read --size=1m --directory=. --filename=/tmp/xxx > /dev/null; echo $?
 fio: pid=0, err=2/file:filesetup.c:99, func=open, error=No such file or directory
 1
 # mkdir ./tmp
 # ./fio --name=xxxxx --ioengine=sync --rw=read --size=1m --directory=. --filename=/tmp/xxx > /dev/null; echo $?
 0
 # ls ./tmp
 xxx
 # ls /tmp/xxx
 ls: cannot access '/tmp/xxx': No such file or directory

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO       |  3 ++-
 filesetup.c | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index 22c5a5b..ec1352b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -727,7 +727,8 @@ Target file/device
 	long as they are using generated filenames. If specific `filename(s)` are
 	set fio will use the first listed directory, and thereby matching the
 	`filename` semantic which generates a file each clone if not specified, but
-	let all clones use the same if set.
+	let all clones use the same if set. If `filename(s)` are given as absolute
+	paths, this option is ignored (except for on Windows).
 
 	See the :option:`filename` option for escaping certain characters.
 
diff --git a/filesetup.c b/filesetup.c
index 13079e4..ae74ea1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1494,9 +1494,13 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	dprint(FD_FILE, "add file %s\n", fname);
 
-	if (td->o.directory)
-		len = set_name_idx(file_name, PATH_MAX, td->o.directory, numjob,
-					td->o.unique_filename);
+	if (td->o.directory) {
+#ifndef WIN32
+		if (fname[0] != '/')
+#endif
+			len = set_name_idx(file_name, PATH_MAX, td->o.directory,
+						numjob, td->o.unique_filename);
+	}
 
 	sprintf(file_name + len, "%s", fname);
 
-- 
2.9.4


