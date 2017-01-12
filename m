Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750730AbdALEAq (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 11 Jan 2017 23:00:46 -0500
Date: Wed, 11 Jan 2017 21:00:22 -0700
From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH v2 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at
 startup
Message-ID: <20170112040022.GC27546@kernel.dk>
References: <20170104065453.15106-1-elliott@hpe.com>
 <20170110212127.64926-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170110212127.64926-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>
Cc: fio@vger.kernel.org

On Tue, Jan 10 2017, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> The pmemblk and dev-dax ioengines were loading libpmem.so and
> libpmemblk.so using dlopen() at runtime.
> 
> Although the upstream nvml Makefile installs a libpmem.so
> symbolic link, some of the distros (e.g. SUSE Linux Enterprise
> Server 12 SP2) are just installing so.1 symbolic links.  So,
> fio fails to find the libpmem.so and libpmemblk.so library files.
> 
> http://www.ibm.com/developerworks/linux/library/l-shlibs/index.html
> says applications should always load the versioned filenames to
> avoid compatibility issues; the non-versioned filenames are just
> for the compiler and linker.
> 
> Change ./configure to pass -lpmem and -lpmemblk to the compiler
> so the fio binary loads the versioned filename at startup like
> the other libraries, rather than open the non-versioned filename
> with dlopen() during runtime.
> 
> This way they show up in ldd:
> $ ldd fio
>         linux-vdso.so.1 (0x00007ffc290aa000)
>         libpmemblk.so.1 => /lib64/libpmemblk.so.1 (0x00007f65b5bc4000)
>         libpmem.so.1 => /lib64/libpmem.so.1 (0x00007f65b59be000)
>         libnuma.so.1 => /lib64/libnuma.so.1 (0x00007f65b57b3000)
>         librt.so.1 => /lib64/librt.so.1 (0x00007f65b55ab000)
>         libaio.so.1 => /lib64/libaio.so.1 (0x00007f65b53a9000)
>         libz.so.1 => /lib64/libz.so.1 (0x00007f65b5191000)
>         libm.so.6 => /lib64/libm.so.6 (0x00007f65b4e88000)
>         libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f65b4c6a000)
>         libdl.so.2 => /lib64/libdl.so.2 (0x00007f65b4a66000)
>         libc.so.6 => /lib64/libc.so.6 (0x00007f65b46a0000)
>         libuuid.so.1 => /lib64/libuuid.so.1 (0x00007f65b449b000)
>         /lib64/ld-linux-x86-64.so.2 (0x0000559f4d872000)

Added 1-4, thanks Robert.

-- 
Jens Axboe

