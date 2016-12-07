Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52533 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932583AbcLGWrv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Dec 2016 17:47:51 -0500
Date: Wed, 7 Dec 2016 15:47:49 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] fio: add device dax engine
Message-ID: <20161207224749.GA23559@linux.intel.com>
References: <148106914371.151212.12117076560989404157.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148106914371.151212.12117076560989404157.stgit@djiang5-desk3.ch.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: fio@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com

On Tue, Dec 06, 2016 at 05:05:43PM -0700, Dave Jiang wrote:
> Adding an ioengine that access DAX device directly. Very similar to the
> mmap engine. Uses the libpmem's pmem_memcpy_persist() call for writes.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

With just 2 tiny nits:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> +static int fio_devdax_file(struct thread_data *td, struct fio_file *f,
> +			   size_t length, off_t off)
> +{
> +	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
> +	int flags = 0;
> +
> +	if (td_rw(td))
> +		flags = PROT_READ | PROT_WRITE;
> +	else if (td_write(td)) {
> +		flags = PROT_WRITE;
> +
> +		if (td->o.verify != VERIFY_NONE)
> +			flags |= PROT_READ;
> +	} else
> +		flags = PROT_READ;
> +
> +	fdd->devdax_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
> +	if (fdd->devdax_ptr == MAP_FAILED) {
> +		fdd->devdax_ptr = NULL;
> +		td_verror(td, errno, "mmap");
> +		goto err;
> +	}
> +
> +err:

We don't need the 'err' label or the associated goto.  These are needed in the
mmap.c engine, but we can just fall through since we don't have the
posix_madvise() work.

> +	if (td->error && fdd->devdax_ptr)
> +		munmap(fdd->devdax_ptr, length);
> +
> +	return td->error;
> +}
> +
> +/*
> + * Just mmap an appropriate portion, we cannot mmap the full extent
> + */
> +static int fio_devdax_prep_limited(struct thread_data *td, struct io_u *io_u)
> +{
> +	struct fio_file *f = io_u->file;
> +	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
> +
> +	if (io_u->buflen > f->real_file_size) {
> +		log_err("fio: bs too big for mmap engine\n");
					     dev-dax
> +		return EIO;
> +	}
