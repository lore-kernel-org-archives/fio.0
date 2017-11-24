Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:39740 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbdKXKVK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Nov 2017 05:21:10 -0500
Received: by mail-io0-f182.google.com with SMTP id x63so29075332ioe.6
        for <fio@vger.kernel.org>; Fri, 24 Nov 2017 02:21:10 -0800 (PST)
MIME-Version: 1.0
From: qingwei wei <tchengwee@gmail.com>
Date: Fri, 24 Nov 2017 18:21:09 +0800
Message-ID: <CAGjEAhsHnSXCJoO+wj8BZDdNi9yH3rQiMQisgFDWsm64P6DG9Q@mail.gmail.com>
Subject: FIO and gfapi
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I am currently using glusterfs 3.12.2 and when i use FIO 3.2, the file
is extended automatically to 16E when doing read.

Steps to produce

1. Perform sequential write
sudo fio -group_reporting -ioengine gfapi -volume test -brick
ubuntu24D -fallocate none -direct 1 -nrfiles 1 -filesize 1G -openfiles
1 -bs 256k -numjobs 1 -iodepth 1 -name test6 -rw write

2. Perform sequential read
sudo fio -group_reporting -ioengine gfapi -volume test -brick
ubuntu24D -fallocate none -direct 1 -nrfiles 1 -filesize 1G -openfiles
1 -bs 256k -numjobs 1 -iodepth 1 -name test6 -rw read

3. Mount the gluster volume using FUSE and can see the file size is now 16E
-rw-r--r--  1 root root  16E Nov 24 18:02 test6.0.0


I also run in debug mode and you can see the file is extended to 16E

file     12546 fio file test8.0.0 open mode rw td rw read
file     12546 fio extend file test8.0.0 from 1073741824 to 18446744073709551615

I also do some printf and i can see that f->real_file_size =
buf.st_size; is never executed and the function return on if (!g ||
!g->fs) {

int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f)
{
        struct stat buf;
        int ret;
        struct gf_data *g = td->io_ops_data;

        dprint(FD_FILE, "get file size %s\n", f->file_name);

        if (!g || !g->fs) {
                return 0;
        }
        if (fio_file_size_known(f))
                return 0;

        ret = glfs_lstat(g->fs, f->file_name, &buf);
        if (ret < 0) {
                log_err("glfs_lstat failed.\n");
                return ret;
        }

        f->real_file_size = buf.st_size;
        fio_file_set_size_known(f);

        return 0;

}

Anyone can help to see what goes wrong? Thanks.

Cw
