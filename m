Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] filesetup: Initialize all members of struct fio_file
References: <20180310004636.5853-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7a8ae2e1-742b-f91b-ad1b-54dd5496dd52@kernel.dk>
Date: Fri, 9 Mar 2018 21:34:55 -0700
MIME-Version: 1.0
In-Reply-To: <20180310004636.5853-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 5:46 PM, Bart Van Assche wrote:
> This patch avoids that Valgrind reports complaints like the following:
> 
> ==10492== Conditional jump or move depends on uninitialised value(s)
> ==10492==    at 0x43BF19: fio_file_reset (filesetup.c:1872)
> ==10492==    by 0x43AB7F: alloc_new_file (filesetup.c:1496)
> ==10492==    by 0x43AED4: add_file (filesetup.c:1581)
> ==10492==    by 0x4528D3: str_filename_cb (options.c:1276)
> ==10492==    by 0x44D83A: __handle_option (parse.c:722)
> ==10492==    by 0x44E303: handle_option (parse.c:941)
> ==10492==    by 0x44E68B: parse_cmd_option (parse.c:1061)
> ==10492==    by 0x4541DD: fio_cmd_option_parse (options.c:4966)
> ==10492==    by 0x427C6D: parse_cmd_line (init.c:2652)
> ==10492==    by 0x428685: parse_options (init.c:2924)
> ==10492==    by 0x4920AC: main (fio.c:47)

Applied, thanks.

-- 
Jens Axboe


