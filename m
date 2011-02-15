Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1BOOPx (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Feb 2011 09:15:53 -0500
Received: by fxm20 with SMTP id 20so229495fxm.19
        for <fio@vger.kernel.org>; Tue, 15 Feb 2011 06:15:52 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 09:13:50 -0500
Message-ID: <AANLkTi=AU=4YUf4M905-_FrXQJCRXNmQQ+Ew7i7cOGc9@mail.gmail.com>
Subject: static compile of fio using snapshot 1.50.2
From: Roger Sibert <liquiz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am not debating static vs dynamic rather I am dealing with
environments where I can't predict what libraries are available or
possibly what version.  Without having access to the proper build
environments static binaries just get me further along than dynamic
ones.

Using a snapshot of fio 1.50.2 as a base on an Ubuntu 10 32bit setup I
set about trying to do a static build of fio.

Linux xyusfl541 2.6.32-26-generic-pae #48-Ubuntu SMP Wed Nov 24
10:31:20 UTC 2010 i686 GNU/Linux

gcc -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu
4.4.3-4ubuntu5'
--with-bugurl=file:///usr/share/doc/gcc-4.4/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--enable-shared --enable-multiarch --enable-linker-build-id
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.4
--program-suffix=-4.4 --enable-nls --enable-clocale=gnu
--enable-libstdcxx-debug --enable-plugin --enable-objc-gc
--enable-targets=all --disable-werror --with-arch-32=i486
--with-tune=generic --enable-checking=release --build=i486-linux-gnu
--host=i486-linux-gnu --target=i486-linux-gnu
Thread model: posix
gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5)


If you toss --static into the Makefile

OPTFLAGS= -O2 -fno-omit-frame-pointer -g --static $(EXTFLAGS)

The reulting make blows up when you get to the CC fio line (below is a
small excerpt from that)

fio/fio/engines/net.c:450: warning: Using 'gethostbyname' in
statically linked applications requires at runtime the shared
libraries from the glibc version used for linking
gettime.o: In function `calibrate_cpu_clock':
/home/xxxxxx/fio/fio/gettime.c:228: undefined reference to `sqrt'
/home/xxxxxx/fio/fio/gettime.c:234: undefined reference to `fmax'
/home/xxxxxx/fio/fio/gettime.c:234: undefined reference to `fmin'
fio.o: In function `thread_main':
/home/xxxxxx/fio/fio/fio.c:1052: undefined reference to `pthread_mutex_init'
/home/xxxxxx/fio/fio/fio.c:1055: undefined reference to `pthread_condattr_init'
/home/xxxxxx/fio/fio/fio.c:1056: undefined reference to `pthread_cond_init'
/home/xxxxxx/fio/fio/fio.c:1057: undefined reference to `pthread_cond_init'
fio.o: In function `fio_start_gtod_thread':
/home/xxxxxx/fio/fio/fio.c:1420: undefined reference to `pthread_attr_init'
/home/xxxxxx/fio/fio/fio.c:1421: undefined reference to
`pthread_attr_setstacksize'
/home/xxxxxx/fio/fio/fio.c:1422: undefined reference to `pthread_create'
/home/xxxxxx/fio/fio/fio.c:1423: undefined reference to `pthread_attr_destroy'
fio.o: In function `run_threads':
/home/xxxxxx/fio/fio/fio.c:1564: undefined reference to `pthread_create'
/home/xxxxxx/fio/fio/fio.c:1572: undefined reference to `pthread_detach'
fio.o: In function `fio_start_gtod_thread':
/home/xxxxxx/fio/fio/fio.c:1429: undefined reference to `pthread_detach'
fio.o: In function `create_disk_util_thread':
/home/xxxxxx/fio/fio/fio.c:151: undefined reference to `pthread_create'
/home/xxxxxx/fio/fio/fio.c:157: undefined reference to `pthread_detach'
ioengines.o: In function `close_ioengine':
/home/xxxxxx/fio/fio/ioengines.c:165: undefined reference to `dlclose'
ioengines.o: In function `dlopen_ioengine':
/home/xxxxxx/fio/fio/ioengines.c:96: undefined reference to `dlerror'
/home/xxxxxx/fio/fio/ioengines.c:97: undefined reference to `dlopen'
/home/xxxxxx/fio/fio/ioengines.c:107: undefined reference to `dlsym'
/home/xxxxxx/fio/fio/ioengines.c:110: undefined reference to `dlclose'
/home/xxxxxx/fio/fio/ioengines.c:99: undefined reference to `dlerror'
/home/xxxxxx/fio/fio/ioengines.c:109: undefined reference to `dlerror'

To fix the problem I ended up making two changes.

change LIBS line by moving -lpthread to the end of the line
LIBS    = -lm -ldl -lrt -laio -lpthread
change the fio CC line by moving $(LIBS) to the end of the line
$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

Doing a make results in the warnings that while not perfect are better
than what I had.
fio: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),
statically linked, for GNU/Linux 2.6.15, not stripped

I am by no means a programmer so the intricacies of gcc and linking
are beyond my current expertise.

Thanks,
Roger
