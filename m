Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Remove prof_io_ops.fill_io_u_off(), .fill_io_u_size() and
 .get_next_file()
References: <20180309171623.19487-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1e5e7dbc-fdf5-df8d-ebea-7826414fc1cb@kernel.dk>
Date: Fri, 9 Mar 2018 10:21:07 -0700
MIME-Version: 1.0
In-Reply-To: <20180309171623.19487-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 10:16 AM, Bart Van Assche wrote:
> Remove the struct prof_io_ops methods for which no implementations
> have been defined. This patch does not change any functionality.

Thanks Bart, applied.

-- 
Jens Axboe


