Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:46448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758386AbbEELhh convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 5 May 2015 07:37:37 -0400
From: Alexey Skidanov <Alexey.Skidanov@sandisk.com>
Subject: FIO on ARM
Date: Tue, 5 May 2015 09:02:38 +0000
Message-ID: <CF2184B79FF73642B463E092E85766BF04A85605@SACMBXIP01.sdcorp.global.sandisk.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>

Hi,

I would like to run FIO on an ARM based board. I have cloned the git repository by git clone git://git.kernel.dk/fio.git and cross compiled the sources (exactly as it explained in the README file). After that, I have created a simple job file test.fio:

[global]
bs=512k
iodepth=4
size=1g
direct=1
runtime=60
directory= ...
filename= ...
ioengine=libaio

[seq-read]
rw=read
stonewall

[rand-read]
rw=randread
stonewall

[seq-write]
rw=write
stonewall

[rand-write]
rw=randwrite
stonewall

Running fio test.fio I get the following error:

fio: engine libaio not loadable
fio: failed to load engine libaio
fio: file:ioengines.c:99, func=dlopen, error=libaio: cannot open shared object file: No such file or directory

The config.log file contains the following error:

Compiling test case libaio
arm-linux-gnueabihf-gcc -D_GNU_SOURCE -include config-host.h -o /tmp/fio-conf--17007-.exe /tmp/fio-conf--17007-.c -laio
/usr/lib/gcc/arm-linux-gnueabihf/4.6/../../../../arm-linux-gnueabihf/bin/ld: cannot find -laio
collect2: ld returned 1 exit status

The make printouts contain the following lines :
FIO_VERSION = fio-2.2.7-29-g020d5
Running configure for you...
Operating system              Linux
CPU                           arm
Big endian                    no
Compiler                      arm-linux-gnueabihf-gcc
Cross compile                 yes
...
Linux AIO support             no
...

Since libaio-dev exists only for amd and i386 platforms, the fio couldn't be statically linked with aio. Thus, I need to download the libaio sources, compile them and install the libaio.so on the target.

Thanks,
Alexey



