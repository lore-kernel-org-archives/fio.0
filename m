Return-Path: <fio-owner@vger.kernel.org>
Received: from redcrew.org ([37.157.195.192]:50668 "EHLO redcrew.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgANKZZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jan 2020 05:25:25 -0500
Date: Tue, 14 Jan 2020 11:17:47 +0100
From: Dan =?UTF-8?B?SG9yw6Fr?= <dan@danny.cz>
Subject: fio fails to build on s390x and armv7 after enabling more tests
Message-Id: <20200114111747.dbfba9c9764da37e9d26870b@danny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sandeen@redhat.com

Hi,

our CI discovered that after
https://git.kernel.dk/cgit/fio/commit/?id=5ad80fa7cf5be0399c8d9d68967781e56a767c82
fio fails to build on s390x and armv7 (the builders use Fedora 31).

...
    CC t/read-to-pipe-async.o
  LINK t/read-to-pipe-async
    CC t/io_uring.o
t/io_uring.c: In function ‘io_uring_register_buffers’:
t/io_uring.c:103:17: error: ‘__NR_sys_io_uring_register’ undeclared (first use in this function); did you mean ‘SYS_io_uring_register’?
  103 |  return syscall(__NR_sys_io_uring_register, s->ring_fd,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                 SYS_io_uring_register
t/io_uring.c:103:17: note: each undeclared identifier is reported only once for each function it appears in
t/io_uring.c: In function ‘io_uring_register_files’:
t/io_uring.c:120:17: error: ‘__NR_sys_io_uring_register’ undeclared (first use in this function); did you mean ‘SYS_io_uring_register’?
  120 |  return syscall(__NR_sys_io_uring_register, s->ring_fd,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                 SYS_io_uring_register
t/io_uring.c: In function ‘io_uring_setup’:
t/io_uring.c:126:17: error: ‘__NR_sys_io_uring_setup’ undeclared (first use in this function); did you mean ‘SYS_io_uring_setup’?
  126 |  return syscall(__NR_sys_io_uring_setup, entries, p);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~
      |                 SYS_io_uring_setup
t/io_uring.c: In function ‘io_uring_enter’:
t/io_uring.c:132:17: error: ‘__NR_sys_io_uring_enter’ undeclared (first use in this function); did you mean ‘SYS_io_uring_enter’?
  132 |  return syscall(__NR_sys_io_uring_enter, s->ring_fd, to_submit,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~
      |                 SYS_io_uring_enter
t/io_uring.c: In function ‘io_uring_register_buffers’:
t/io_uring.c:105:1: warning: control reaches end of non-void function [-Wreturn-type]
  105 | }
      | ^
t/io_uring.c: In function ‘io_uring_register_files’:
t/io_uring.c:122:1: warning: control reaches end of non-void function [-Wreturn-type]
  122 | }
      | ^
t/io_uring.c: In function ‘io_uring_setup’:
t/io_uring.c:127:1: warning: control reaches end of non-void function [-Wreturn-type]
  127 | }
      | ^
t/io_uring.c: In function ‘io_uring_enter’:
t/io_uring.c:134:1: warning: control reaches end of non-void function [-Wreturn-type]
  134 | }
      | ^
make: *** [Makefile:380: t/io_uring.o] Chyba 1


	Thanks,

		Dan

