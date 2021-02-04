Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237599AbhBDQBG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Feb 2021 11:01:06 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92EFC0613D6
        for <fio@vger.kernel.org>; Thu,  4 Feb 2021 08:00:25 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id y5so3029559ilg.4
        for <fio@vger.kernel.org>; Thu, 04 Feb 2021 08:00:25 -0800 (PST)
MIME-Version: 1.0
From: Marcel Bielcik <bielcik1995@gmail.com>
Date: Thu, 4 Feb 2021 17:00:13 +0100
Message-ID: <CANtcVJ3dXKnEz74G9Sh4LzvjdgWe_V4mxwXOEOwGtpYL0LN3fg@mail.gmail.com>
Subject: HTTP Engine of fio
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,



I wanted to execute some S3 performance tests on my storage. If I am
execute fio with the HTTP engine, I always receive the following
output:


fio: engine http not loadable

fio: failed to load engine

Bad option <http_verbose=3D0>

Bad option <https=3Doff>

Did you mean loops?

Bad option <http_mode=3Ds3>

Did you mean zonemode?

Bad option <http_s3_key=3DsomeKey

Bad option <http_s3_keyid=3DsomeKey>

Bad option <http_host=3Dhttp://=E2=80=A6. >

Bad option <http_s3_region=3Deu-central-1>

fio: job global dropped

=E2=80=9D



If I running the command =E2=80=9C./configure=E2=80=9D, I can see that the =
http engine
is not available.


Operating system              Linux

CPU                           x86_64

Big endian                    no

Compiler                      gcc

Cross compile                 no



Static build                  no

Wordsize                      64

zlib                          yes

Linux AIO support             no

Linux AIO support rw flags    no

POSIX AIO support             yes

POSIX AIO support needs -lrt  yes

POSIX AIO fsync               yes

POSIX pshared support         yes

pthread_condattr_setclock()   yes

pthread_sigmask()             yes

Solaris AIO support           no

__sync_fetch_and_add          yes

__sync_synchronize            yes

__sync_val_compare_and_swap   yes

libverbs                      no

rdmacm                        no

asprintf()                    yes

vasprintf()                   yes

Linux fallocate               yes

POSIX fadvise                 yes

POSIX fallocate               yes

sched_setaffinity(3 arg)      yes

sched_setaffinity(2 arg)      no

clock_gettime                 yes

CLOCK_MONOTONIC               yes

clockid_t                     yes

gettimeofday                  yes

fdatasync                     yes

pipe()                        yes

pipe2()                       yes

pread()                       yes

sync_file_range               yes

EXT4 move extent              yes

Linux splice(2)               yes

libnuma                       no

strsep                        yes

strcasestr                    yes

strlcat                       no

getopt_long_only()            yes

inet_aton                     yes

socklen_t                     yes

__thread                      yes

RUSAGE_THREAD                 yes

SCHED_IDLE                    yes

TCP_NODELAY                   yes

Net engine window_size        yes

TCP_MAXSEG                    yes

RLIMIT_MEMLOCK                yes

pwritev/preadv                yes

pwritev2/preadv2              yes

IPv6 helpers                  yes

http engine                   no

Rados engine                  no

Rados Block Device engine     no

setvbuf                       yes

Gluster API engine            no

s390_z196_facilities          no

HDFS engine                   no

MTD                           yes

libpmem                       no

libpmem1_5                    no

libpmemblk                    no

PMDK pmemblk engine           no

PMDK dev-dax engine           no

PMDK libpmem engine           no

DDN's Infinite Memory Engine  no

iscsi engine                  no

NBD engine                    no

lex/yacc for arithmetic       no

getmntent                     yes

getmntinfo                    no

Static Assert                 yes

bool                          yes

strndup                       yes

Valgrind headers              no

Zoned block device support    yes

Zoned block device capacity   no

libzbc engine                 no

march_armv8_a_crc_crypto      no

cuda                          no

libcufile                     no

Build march=3Dnative            yes

CUnit                         no

__kernel_rwf_t                yes

-Wimplicit-fallthrough=3D2      yes

MADV_HUGEPAGE                 yes

gettid                        yes

statx(2)/libc                 yes

statx(2)/syscall              yes

Windows PDB generation        no

timerfd_create                yes

Lib-based ioengines dynamic   no

TCMalloc support              no

=E2=80=9C

I am working with the current master.

Environment:

Operating System: Ubuntu 20.04.2 LTS

Kernel: Linux 5.4.0-62-generic

Architecture: x86-64



I hope someone can help me.


Kind Regards

Marcel

