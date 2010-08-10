Return-Path: <fio-owner@vger.kernel.org>
Received: from sd-19487.dedibox.fr ([88.190.12.23]:60522 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0HJMTm (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Aug 2010 08:19:42 -0400
Received: from [80.10.52.177] (unknown [80.10.52.177])
	by mail.free-electrons.com (Postfix) with ESMTPA id 05850CF
	for <fio@vger.kernel.org>; Tue, 10 Aug 2010 14:11:25 +0200 (CEST)
Message-ID: <4C6141EC.7060205@free-electrons.com>
Date: Tue, 10 Aug 2010 14:11:24 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Subject: Build issue on arm: undefined reference to `get_cpu_clock'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio mailing list <fio@vger.kernel.org>

Hello,

Though the arm platform seems to be supported, fio fails to build on the
arm platform. Other non Intel platforms should also be impacted.

gettime.o: In function `get_cycles_per_usec':
/home/ubuntu/.phoronix-test-suite/installed-tests/fio/fio-1.42/gettime.c:192:
undefined reference to `get_cpu_clock'
/home/ubuntu/.phoronix-test-suite/installed-tests/fio/fio-1.42/gettime.c:199:
undefined reference to `get_cpu_clock'
make: *** [fio] Error 1

Unlike in the fio_gettime, where there is an "#ifdef
ARCH_HAVE_CPU_CLOCK" statement around the calls to get_cpu_clock(),
there are other places where this function is used unconditionally.

The get_cpu_clock function is only defined in
arch/arch-ia64.h
arch/arch-x86.h
arch/arch-x86_64.h

How are other architectures supported? I don't understand fio can
support them without defining the get_cpu_clock() function.

I did my tests on version 1.42, but faced the same issues with the
latest git version.

Thank you in advance.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+ 33 621 604 642

