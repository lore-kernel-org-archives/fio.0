Return-Path: <dan.j.williams@gmail.com>
MIME-Version: 1.0
Sender: dan.j.williams@gmail.com
In-Reply-To: <CS1PR84MB0165239238258EDF42E762A1AB910@CS1PR84MB0165.NAMPRD84.PROD.OUTLOOK.COM>
References: <148192914644.212226.6107445930190025121.stgit@djiang5-desk3.ch.intel.com>
 <CS1PR84MB0165239238258EDF42E762A1AB910@CS1PR84MB0165.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Dec 2016 16:01:28 -0800
Message-ID: <CAA9_cmfS-BqCxTOip60Wd7rM32JMvaXi-nwLRJf8mWNgYsaL6A@mail.gmail.com>
Subject: Re: [PATCH] fio: add additional support for dev-dax ioengine
Content-Type: text/plain; charset=UTF-8
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Dave Jiang <dave.jiang@intel.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Dec 19, 2016 at 12:08 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Dave Jiang
>> Sent: Friday, December 16, 2016 4:59 PM
>> Subject: [PATCH] fio: add additional support for dev-dax ioengine
>>
>> Fixup options.c to add the dev-dax to ioengine list. Update fio.1 and
>> HOWTO as well. Also adding example fio job file.
>>
> ...
>> diff --git a/examples/dev-dax.fio b/examples/dev-dax.fio
>> +bs=2m
>> +ioengine=dev-dax
> ...
>> +# The dev-dax engine does IO to DAX device that are special character
>> +# devices exported by the kernel (e.g. /dev/dax0.0). The device is
>> +# opened normally and then the region is accessible via mmap. We do
>> +# not use the O_DIRECT flag because the device is naturally direct
>> +# access. The O_DIRECT flags will result in failure. The engine
>> +# access the underlying NVDIMM directly once the mmapping is setup.
>> +#
>> +# Check the alignment requirement of your DAX device. Currently the default
>> +# should be 2M. Blocksize (bs) should meet alignment requirement.
>
> Although /dev/dax needs the mmap() calls aligned and of a certain size,
> the reads and writes within those mapped regions don't need to be.  Can
> these concepts be separated, with bs= continuing to just specify the
> read/write size?
>
> Since not every write needs to persist, could you include a parameter
> to use pmem_memcpy_nodrain() for the writes, plus call pmem_persist()
> at a different specified rate?
>

I don't think we should be adding features that don't exist for the
mmap engine. Unless / until the mmap engine grows support for I/O at
different granularity than the mapping, or msync at different
frequency than the I/O submit rate then I don't think the dev-dax
engine should add these things in isolation.

With the 4.10 kernel we'll start communicating the alignment of the
dax-region in a reliable location so the 2M requirement can be reduced
to 4K if the device-dax instance is so configured.

