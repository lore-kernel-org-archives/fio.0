Return-Path: <esandeen@redhat.com>
Return-Path: <esandeen@redhat.com>
From: Eric Sandeen <esandeen@redhat.com>
Subject: [PATCH] don't access dlclose'd dynamic ioengine object after close
Message-ID: <14499187-1da8-ff0c-6b60-8fa6dd33d9fa@redhat.com>
Date: Fri, 7 May 2021 16:13:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

Alexey reported this bug when using dynamically loaded IO engines;
a segfault on the line where we set the dlhandle to NULL after
the dlclose.

I think this is because ops points to the thing we obtained from dlsym:

	ops = dlsym(dlhandle, engine_lib);

and after the final dlclose, the object no longer exists and efforts
to set the handle within it will fail for obvious reasons.
I'm not sure why I hadn't seen this before.

Fixes-RH-Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1956963
Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: f6931a1 ("fio: move dynamic library handle to io_ops structure")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Please, somebody who is better than I am at this review it to see
if I'm just causing more problems.  ;)

diff --git a/ioengines.c b/ioengines.c
index 3561bb4e..dd61af07 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -234,7 +234,6 @@ void free_ioengine(struct thread_data *td)
 	if (td->io_ops->dlhandle) {
 		dprint(FD_IO, "dlclose ioengine %s\n", td->io_ops->name);
 		dlclose(td->io_ops->dlhandle);
-		td->io_ops->dlhandle = NULL;
 	}
 
 	td->io_ops = NULL;


