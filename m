Return-Path: <axboe@kernel.dk>
Message-ID: <533B045B.9070607@kernel.dk>
Date: Tue, 01 Apr 2014 12:24:27 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Shared files with thread=1: func=xfer, err=Bad file descriptor
References: <CANvN+ekEmEeFeXZ_b7-51QpetdWx2nwJHwoEsbsiFTOcpYwizw@mail.gmail.com> <533ACDDC.6010002@kernel.dk> <CANvN+emPxK2FmEAsbdruCMR0jDdjE-s6N6wovHtAqowFprJH4g@mail.gmail.com>
In-Reply-To: <CANvN+emPxK2FmEAsbdruCMR0jDdjE-s6N6wovHtAqowFprJH4g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010000090107030502050608"
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010000090107030502050608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/01/2014 09:56 AM, Andrey Kuzmin wrote:
> Thanks. On a separate (or may be related) note, shared files handling
> in dup_files seems to be broken (unless I'm missing the logic behind
> dropping non-shared files). The patch below has fixed it for me.
>
> diff --git a/init.c b/init.c
> index 9b0666d..99038b2 100644
> --- a/init.c
> +++ b/init.c
> @@ -1160,17 +1161,20 @@ static int add_job(struct thread_data *td, const char *j
>                  td_new->o.new_group = 0;
>
>                  if (file_alloced) {
> -                       td_new->files_index = 0;
> -                       td_new->files_size = 0;
>                          if (td_new->files) {
>                                  struct fio_file *f;
>                                  for_each_file(td_new, f, i) {
>                                          if (f->file_name)
> -                                               free(f->file_name);
> -                                       free(f);
> +                                               sfree(f->file_name);
> +                                       sfree(f);
>                                  }
> +                               free(td_new->files);
>                                  td_new->files = NULL;
>                          }
> +                       td_new->files_index = 0;
> +                       td_new->files_size = 0;
>                          if (td_new->o.filename) {
>                                  free(td_new->o.filename);
>                                  td_new->o.filename = NULL;

Thanks, I'll add this, definitely looks like a missing conversion at 
some point...

And while this isn't the bug, I think it's touching in the right area. 
Can you try with this one-liner and see if that fixes your issues with 
EBADF?

-- 
Jens Axboe


--------------010000090107030502050608
Content-Type: text/x-patch;
 name="file-close-race-shadow.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="file-close-race-shadow.patch"

diff --git a/filesetup.c b/filesetup.c
index db80a8b7e28b..ecbe3a5fb41b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1421,6 +1459,7 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 			assert(0);
 		}
 		__f->fd = -1;
+		__f->shadow_fd = -1;
 		fio_file_reset(td, __f);
 
 		if (f->file_name) {

--------------010000090107030502050608--

