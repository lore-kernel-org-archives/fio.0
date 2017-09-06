Return-Path: <rebecca@bluestop.org>
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
 <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk>
 <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org>
Date: Wed, 6 Sep 2017 12:31:08 -0600
MIME-Version: 1.0
In-Reply-To: <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/30/2017 2:57 PM, Elliott, Robert (Persistent Memory) wrote:
> There's even a new patch set to use the Intel QuickData DMA engines
> for transfers rather than the CPU (a "blkmq" pmem driver).  It'd be
> interesting if fio could use that hardware too (with direct access by
> fio, not resorting to kernel read()/write() calls).

I build the example performance tester program from Intel that compares 
memcpy with QuickData for various buffer and block sizes, and the best 
result was QuickData being the same speed as memcpy; otherwise, 
QuickData was between a tenth and half the speed.
Given that, I'm planning to focus on just adding SSE (not sure about 
this one yet, since all x86_64 systems support it, so memcpy should be 
using it already), AVX, AVX-512 and A64 Advanced SIMD (for ARM64) to FIO.

-- 
Rebecca


