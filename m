Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:44981 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbeAFTQG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Jan 2018 14:16:06 -0500
Received: by mail-ua0-f193.google.com with SMTP id k4so4510137ual.11
        for <fio@vger.kernel.org>; Sat, 06 Jan 2018 11:16:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGjEAhsHnSXCJoO+wj8BZDdNi9yH3rQiMQisgFDWsm64P6DG9Q@mail.gmail.com>
References: <CAGjEAhsHnSXCJoO+wj8BZDdNi9yH3rQiMQisgFDWsm64P6DG9Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 6 Jan 2018 19:15:34 +0000
Message-ID: <CALjAwxg4e5URcZfeX73PKrGYZUHscdtdU8mhaEZYWJ6RBXWhaw@mail.gmail.com>
Subject: Re: FIO and gfapi
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: qingwei wei <tchengwee@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, castor@egocast.org, hchen@redhat.com

Hi,

I don't use the gluster gfapi ioengine but this looks like a subtlety
with ioengines that set .get_file_size() but don't set .setup().

If you have an ioengine which defines its own .get_file_size(), it has
to be prepared for that function to be called BEFORE the call to
.init() is done when there is no .setup() (this happens prior to file
layout in the scenario where the user doesn't explicitly set size with
the fio job). So in your case because add_job() over in init.c does
f->real_file_size = -1ULL for diskless ioengines and from
get_file_sizes() fio ends up calling fio_gf_get_file_size() which
returns 0 (making fio think the file_get_size call worked) and when
fio gets to fio_gf_open_file(), f->real_file_size still has the
maximum value and the ioengine goes on to extend the file.

I guess most are setting the size option when using the gfapi ioengine
- notice how it is set in the example gfapi.fio job
(https://github.com/axboe/fio/blob/master/examples/gfapi.fio ).

On 24 November 2017 at 10:21, qingwei wei <tchengwee@gmail.com> wrote:
> Hi,
>
> I am currently using glusterfs 3.12.2 and when i use FIO 3.2, the file
> is extended automatically to 16E when doing read.
>
> Steps to produce
>
> 1. Perform sequential write
> sudo fio -group_reporting -ioengine gfapi -volume test -brick
> ubuntu24D -fallocate none -direct 1 -nrfiles 1 -filesize 1G -openfiles
> 1 -bs 256k -numjobs 1 -iodepth 1 -name test6 -rw write
>
> 2. Perform sequential read
> sudo fio -group_reporting -ioengine gfapi -volume test -brick
> ubuntu24D -fallocate none -direct 1 -nrfiles 1 -filesize 1G -openfiles
> 1 -bs 256k -numjobs 1 -iodepth 1 -name test6 -rw read
>
> 3. Mount the gluster volume using FUSE and can see the file size is now 16E
> -rw-r--r--  1 root root  16E Nov 24 18:02 test6.0.0
>
>
> I also run in debug mode and you can see the file is extended to 16E
>
> file     12546 fio file test8.0.0 open mode rw td rw read
> file     12546 fio extend file test8.0.0 from 1073741824 to 18446744073709551615
>
> I also do some printf and i can see that f->real_file_size =
> buf.st_size; is never executed and the function return on if (!g ||
> !g->fs) {
>
> int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f)
> {
>         struct stat buf;
>         int ret;
>         struct gf_data *g = td->io_ops_data;
>
>         dprint(FD_FILE, "get file size %s\n", f->file_name);
>
>         if (!g || !g->fs) {
>                 return 0;
>         }
>         if (fio_file_size_known(f))
>                 return 0;
>
>         ret = glfs_lstat(g->fs, f->file_name, &buf);
>         if (ret < 0) {
>                 log_err("glfs_lstat failed.\n");
>                 return ret;
>         }
>
>         f->real_file_size = buf.st_size;
>         fio_file_set_size_known(f);
>
>         return 0;
>
> }
>
> Anyone can help to see what goes wrong? Thanks.
>
> Cw
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/
