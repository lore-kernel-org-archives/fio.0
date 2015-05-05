Return-Path: <axboe@kernel.dk>
Message-ID: <5548E60E.4010301@kernel.dk>
Date: Tue, 05 May 2015 09:47:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO on ARM
References: <CF2184B79FF73642B463E092E85766BF04A85605@SACMBXIP01.sdcorp.global.sandisk.com>
In-Reply-To: <CF2184B79FF73642B463E092E85766BF04A85605@SACMBXIP01.sdcorp.global.sandisk.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexey Skidanov <Alexey.Skidanov@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>
List-ID: <fio@vger.kernel.org>

On 05/05/2015 03:02 AM, Alexey Skidanov wrote:
> Hi,
>
> I would like to run FIO on an ARM based board. I have cloned the git repository by git clone git://git.kernel.dk/fio.git and cross compiled the sources (exactly as it explained in the README file). After that, I have created a simple job file test.fio:
>
> [global]
> bs=512k
> iodepth=4
> size=1g
> direct=1
> runtime=60
> directory= ...
> filename= ...
> ioengine=libaio
>
> [seq-read]
> rw=read
> stonewall
>
> [rand-read]
> rw=randread
> stonewall
>
> [seq-write]
> rw=write
> stonewall
>
> [rand-write]
> rw=randwrite
> stonewall
>
> Running fio test.fio I get the following error:
>
> fio: engine libaio not loadable
> fio: failed to load engine libaio
> fio: file:ioengines.c:99, func=dlopen, error=libaio: cannot open shared object file: No such file or directory
>
> The config.log file contains the following error:
>
> Compiling test case libaio
> arm-linux-gnueabihf-gcc -D_GNU_SOURCE -include config-host.h -o /tmp/fio-conf--17007-.exe /tmp/fio-conf--17007-.c -laio
> /usr/lib/gcc/arm-linux-gnueabihf/4.6/../../../../arm-linux-gnueabihf/bin/ld: cannot find -laio
> collect2: ld returned 1 exit status
>
> The make printouts contain the following lines :
> FIO_VERSION = fio-2.2.7-29-g020d5
> Running configure for you...
> Operating system              Linux
> CPU                           arm
> Big endian                    no
> Compiler                      arm-linux-gnueabihf-gcc
> Cross compile                 yes
> ...
> Linux AIO support             no
> ...
>
> Since libaio-dev exists only for amd and i386 platforms, the fio couldn't be statically linked with aio. Thus, I need to download the libaio sources, compile them and install the libaio.so on the target.

That seems like a distro issue, there's absolutely no reason why 
libaio-dev(el) should not be available on arm based distro. 
Additionally, fio dynamically links with libaio, it's not a static link.

-- 
Jens Axboe


