Return-Path: <fio-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64083 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752828AbdACPrl (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Jan 2017 10:47:41 -0500
Subject: Re: [PATCH v2] fio: add device dax engine
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
 <DF4PR84MB01692BD912B381B8B9BDE3ADAB930@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c33c6bb4-519f-d7d6-1450-a15e38a03238@intel.com>
Date: Tue, 3 Jan 2017 08:42:46 -0700
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB01692BD912B381B8B9BDE3ADAB930@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>



On 12/20/2016 05:33 PM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Dave Jiang
>> Sent: Wednesday, December 07, 2016 4:55 PM
>> Subject: [PATCH v2] fio: add device dax engine
>>
> ...
>> +static int fio_devdax_init(struct thread_data *td)
>> +{
>> +struct thread_options *o = &td->o;
>> +const char *path;
>> +void *dl;
>> +
>> +if ((o->rw_min_bs & page_mask) &&
>> +    (o->fsync_blocks || o->fdatasync_blocks)) {
>> +log_err("fio: mmap options dictate a minimum block size
>> of "
>> +"%llu bytes\n", (unsigned long long) page_size);
>> +return 1;
>> +}
>> +
>> +path = getenv("FIO_PMEM_LIB");
>> +if (!path)
>> +path = "libpmem.so";
>> +
>> +dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
>> +if (!dl) {
>> +log_err("fio: unable to open libpmem: %s\n", dlerror());
>> +return 1;
>> +}
> 
> Should that open libpmem.so.1 rather than libpmem.so? (same question
> for the pmemblk engine)

Hmmm....should we look for either? I have not encountered this issue on
my F25 install.

> 
> Although my upstream nvml Makefile installs a libpmem.so symbolic link,
> it looks like some or all of the distro packages (e.g. Fedora 25 and
> SUSE Linux  Enterprise Server 12 SP2) are just installing so.1
> symbolic links.  So, fio fails to find the library.
> 
> If I understand the version conventions correctly, including .1 would
> ensure ABI compatibility.
> 
> distro library *pmem* files:
> /usr/lib64/libpmemblk.so.1      /usr/lib64/libpmemobj.so.1
> /usr/lib64/libpmemblk.so.1.0.0  /usr/lib64/libpmemobj.so.1.0.0
> /usr/lib64/libpmemlog.so.1      /usr/lib64/libpmem.so.1
> /usr/lib64/libpmemlog.so.1.0.0  /usr/lib64/libpmem.so.1.0.0
> 
> vs. upstream nvml installation:
> /lib64/libpmem.a            /lib64/libpmemlog.so.1.0.0
> /lib64/libpmemblk.a         /lib64/libpmemobj.a
> /lib64/libpmemblk.so        /lib64/libpmemobj.so
> /lib64/libpmemblk.so.1      /lib64/libpmemobj.so.1
> /lib64/libpmemblk.so.1.0.0  /lib64/libpmemobj.so.1.0.0
> /lib64/libpmemlog.a         /lib64/libpmem.so
> /lib64/libpmemlog.so        /lib64/libpmem.so.1
> /lib64/libpmemlog.so.1      /lib64/libpmem.so.1.0.0
> 
> 
> ---
> Robert Elliott, HPE Persistent Memory
> 
> 
> 
