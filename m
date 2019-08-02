Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v4] engines: Add Network Block Device (NBD) support using
 libnbd.
References: <20190802153225.11480-1-rjones@redhat.com>
 <20190802153225.11480-2-rjones@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <89e26f7b-ca39-5f28-3aa7-6b6b0e62a146@kernel.dk>
Date: Fri, 2 Aug 2019 09:40:38 -0600
MIME-Version: 1.0
In-Reply-To: <20190802153225.11480-2-rjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>, fio@vger.kernel.org
Cc: eblake@redhat.com
List-ID: <fio@vger.kernel.org>

On 8/2/19 9:32 AM, Richard W.M. Jones wrote:
> diff --git a/engines/nbd.c b/engines/nbd.c
> new file mode 100644
> index 00000000..399da5f3
> --- /dev/null
> +++ b/engines/nbd.c
> @@ -0,0 +1,368 @@
> +/*
> + * NBD engine
> + *
> + * IO engine that talks to an NBD server.
> + *
> + * Copyright (C) 2019 Red Hat Inc.
> + * Written by Richard W.M. Jones <rjones@redhat.com>
> + *
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <errno.h>
> +
> +#include <libnbd.h>
> +
> +#include "../fio.h"
> +#include "../optgroup.h"
> +
> +/* Actually this differs across servers, but for nbdkit ... */
> +#define NBD_MAX_REQUEST_SIZE (64 * 1024 * 1024)
> +
> +/* Storage for the NBD handle. */
> +struct nbd_data {
> +	struct nbd_handle *nbd;
> +        int debug;

Here (and lots of other places) you have a mix of tabs and spaces.
Please make them all tab based.

-- 
Jens Axboe


