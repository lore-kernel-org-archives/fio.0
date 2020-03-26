Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: add NVMe engine
References: <20200326204406.GA29597@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9d18acbf-f878-c685-6272-a77eb5f98bcc@kernel.dk>
Date: Thu, 26 Mar 2020 16:05:08 -0600
MIME-Version: 1.0
In-Reply-To: <20200326204406.GA29597@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/26/20 2:44 PM, Alexey Dobriyan wrote:
> Add simple iodepth=1 NVMe engine:
> 
> 	ioengine=nvme
> 
> It works via standard Linux NVMe ioctls.
> 
> It will be used for testing upcoming ZNS stuff.
> 
> Currently Linux doesn't recognize NVMe ZNS devices as zoned block
> devices so zone ioctls (BLKRESETZONE et al) can't be used.
> 
> Passthrough ioctls should allow Zone Append and whatever commands
> new specs bring.
> 
> Support read, write, fsync, fdatasync.
> Don't support sync_file_range obviously.
> Don't support trim for now, until I figure all qemu options and
> the story behind broken qemu trim support.

Needs a bit of cleanup, but otherwise simple enough. A few comments:

> +static inline uint32_t get_nsid(const struct fio_file *f)
> +{
> +	return (uintptr_t)f->engine_data;
> +}

You could pack both nsid and lba_shift in there, and maybe use
engine_pos instead to avoid the cast.

> +static int fio_nvme_read(struct fio_file *f, struct io_u *io_u)
> +{
> +	fio_unused uint32_t nsid = get_nsid(f);
> +	struct nvme_user_io cmd = {};
> +
> +	//printf("R %u %llu/%llu\n", nsid, io_u->offset, io_u->xfer_buflen);

Leftover debug

> +static int fio_nvme_write(struct fio_file *f, struct io_u *io_u)
> +{
> +	fio_unused uint32_t nsid = get_nsid(f);
> +	struct nvme_user_io cmd = {};
> +
> +	//printf("W %u %llu/%llu\n", nsid, io_u->offset, io_u->xfer_buflen);

Ditto

> +static int fio_nvme_flush(struct fio_file *f)
> +{
> +	uint32_t nsid = get_nsid(f);
> +	struct nvme_passthru_cmd cmd = {};
> +
> +	//printf("F %u\n", nsid);

Ditto

-- 
Jens Axboe


