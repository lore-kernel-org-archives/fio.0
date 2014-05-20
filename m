Return-Path: <xanpeng@gmail.com>
MIME-Version: 1.0
In-Reply-To: <537A5CFE.4090800@kernel.dk>
References: <CA+8ZFngfLhzUopzPznyQ-ZwZgqMuDiEPhUpK5c20HkWNe0nz6w@mail.gmail.com>
	<537A5CFE.4090800@kernel.dk>
Date: Tue, 20 May 2014 09:32:10 +0800
Message-ID: <CA+8ZFng-kGsBJJqNH+ze9TCjpkAMpxTUUeh97U1NKSiFX9K6EQ@mail.gmail.com>
Subject: Re: Fix a bug of rbd engine when specify invalidate=1 or fadvise_hint=1
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: daniel.gollub@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Sure, it's better to have a new type.
the pull request (https://github.com/axboe/fio/pull/11) is updated in
the following way:

---
diff --git a/engines/rbd.c b/engines/rbd.c
index f5f7a06..f1d9fd0 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -406,11 +406,11 @@ static int fio_rbd_open(struct thread_data *td,
struct fio_file *f)
         *
         * As files used in rbd engine is artificial (fd equals -1), with
         * "invalidte=1" or "fadvise_hint=1" set, fio will call posix_fadvise(2)
-        * and EBADF will be returned.
+        * and -EBADF will be returned.
         *
-        * Set file type to FIO_TYPE_CHAR will work-around call of
posix_fadvise(2).
+        * Set file type to FIO_TYPE_SPECIAL will work-around call of
posix_fadvise(2).
         */
-       f->filetype = FIO_TYPE_CHAR;
+       f->filetype = FIO_TYPE_SPECIAL;
        return 0;
 }

diff --git a/file.h b/file.h
index add7773..9398cb7 100644
--- a/file.h
+++ b/file.h
@@ -17,6 +17,7 @@ enum fio_filetype {
        FIO_TYPE_BD,                    /* block device */
        FIO_TYPE_CHAR,                  /* character device */
        FIO_TYPE_PIPE,                  /* pipe */
+       FIO_TYPE_SPECIAL,               /* special file, e.g.,
artificial file */
 };

 enum fio_file_flags {
diff --git a/filesetup.c b/filesetup.c
index ad7fb85..ceeda47 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -419,7 +419,8 @@ static int __file_invalidate_cache(struct
thread_data *td, struct fio_file *f,
                        }
                        ret = 0;
                }
-       } else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
+       } else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE
+                               || f->filetype == FIO_TYPE_SPECIAL)
                ret = 0;

        /*

On Tue, May 20, 2014 at 3:35 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-05-19 11:38, xan.peng wrote:
>>
>> When specify invalidate=1 or fadvise_hint=1, fio will call
>> posix_fadvise(2), which will return -EBADF and prevent fio librbd
>> engine acting normally.
>> Here is the call path: ... > td_io_open_file() >
>> file_invalidate_cache() > __file_invalidate_cache() > posix_fadvise(fd
>> = -1) > ...
>>
>> The patch work-around this problem by setting file type to
>> FIO_TYPE_CHAR in fio_rbd_open().
>
>
> Might be better to add a new type for this, like FIO_TYPE_SPECIAL or
> something. Otherwise we could risk running into other cases, where fio then
> thinks it really is a char device.
>
> --
> Jens Axboe
>

