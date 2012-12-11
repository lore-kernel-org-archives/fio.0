Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51469
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab2LKNaD (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 11 Dec 2012 08:30:03 -0500
Message-ID: <50C73545.90505@kernel.dk>
Date: Tue, 11 Dec 2012 14:29:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio --direct=1 and Linux page cache effects
References: <6e624hcpo4.fsf@just-testing.permabit.com> <50C108E9.4050408@kernel.dk> <50C1B02F.3000902@kernel.dk> <6evcc9bdxv.fsf@just-testing.permabit.com>
In-Reply-To: <6evcc9bdxv.fsf@just-testing.permabit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On 2012-12-11 02:00, Ken Raeburn wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Another idea would be to ensure that we do the bdev cache invalidation
>> at a safe point. But that is done at open time right now, which should
>> invalidate any cache mappings for the device. If the file close triggers
>> blkid and there are no further opens of the device, then those mappings
>> would remain.
>>
>> Would the below work for you?
> 
> It looks like it's not enough; the BLKFLSBUF ioctl winds up happening
> before blkid runs. I added some instrumentation to the patch and saw
> that one thread took the "f->fd != -1" path and then, after
> add_file_hash failed, came back to the "from_hash" path. But all of that
> seems to finish before blkid gets going, so the pages it pulls in still
> won't get invalidated.

You are right, blkid likely wont be done by then, so it's still down to
timing whether it'll help or not. This is pretty annoying.

This issue is due to the file being opened for write. But unfortunately
we cannot open for read always, as fcntl() wont allow change of file
access mode flags.

So how about the below. Basically DON'T close the fd, defer that until
we really close the file. This will keep one extra fd open until the
original is closed, but I don't see that as being an issue.

diff --git a/file.h b/file.h
index 3024c54..11695e2 100644
--- a/file.h
+++ b/file.h
@@ -65,6 +65,7 @@ struct fio_file {
 
 	void *file_data;
 	int fd;
+	int shadow_fd;
 #ifdef WIN32
 	HANDLE hFile;
 	HANDLE ioCP;
diff --git a/filesetup.c b/filesetup.c
index 3462a03..170572d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -434,6 +434,12 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 		ret = errno;
 
 	f->fd = -1;
+
+	if (f->shadow_fd != -1) {
+		close(f->shadow_fd);
+		f->shadow_fd = -1;
+	}
+
 	return ret;
 }
 
@@ -552,9 +558,22 @@ open_again:
 			int fio_unused ret;
 
 			/*
-			 * OK to ignore, we haven't done anything with it
+			 * Stash away descriptor for later close. This is to
+			 * work-around a "feature" on Linux, where a close of
+			 * an fd that has been opened for write will trigger
+			 * udev to call blkid to check partitions, fs id, etc.
+			 * That polutes the device cache, which can slow down
+			 * unbuffered accesses.
 			 */
-			ret = generic_close_file(td, f);
+			if (f->shadow_fd == -1)
+				f->shadow_fd = f->fd;
+			else {
+				/*
+			 	 * OK to ignore, we haven't done anything
+				 * with it
+				 */
+				ret = generic_close_file(td, f);
+			}
 			goto open_again;
 		}
 	}
@@ -1029,6 +1048,7 @@ int add_file(struct thread_data *td, const char *fname)
 	}
 
 	f->fd = -1;
+	f->shadow_fd = -1;
 	fio_file_reset(f);
 
 	if (td->files_size <= td->files_index) {

-- 
Jens Axboe

