Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: add NVMe engine
References: <20200326204406.GA29597@avx2>
 <9d18acbf-f878-c685-6272-a77eb5f98bcc@kernel.dk> <20200327061921.GA3260@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <221f7ccd-53e9-3ad6-0afa-958e74c2ded1@kernel.dk>
Date: Fri, 27 Mar 2020 08:45:59 -0600
MIME-Version: 1.0
In-Reply-To: <20200327061921.GA3260@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/27/20 12:19 AM, Alexey Dobriyan wrote:
>>> +static int fio_nvme_read(struct fio_file *f, struct io_u *io_u)
>>> +{
>>> +	fio_unused uint32_t nsid = get_nsid(f);
>>> +	struct nvme_user_io cmd = {};
>>> +
>>> +	//printf("R %u %llu/%llu\n", nsid, io_u->offset, io_u->xfer_buflen);
>>
>> Leftover debug
> 
> dprint(FD_IO is pretty chatty, but OK.

Having stubbed out debug is pointless, since you need to edit the file
to enable it anyway, and recompile. At that point you may as well just
add the printf.

-- 
Jens Axboe


