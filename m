Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] add a filecreate engine
References: <1507318994-8341-1-git-send-email-jbacik@fb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <95f48118-1202-2a57-54a7-80bea595bea1@kernel.dk>
Date: Mon, 9 Oct 2017 08:42:33 -0600
MIME-Version: 1.0
In-Reply-To: <1507318994-8341-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/06/2017 01:43 PM, Josef Bacik wrote:
> This is for doing empty file creation jobs much like what we do with
> fs_mark.  You still need to specify a filesize so that fio will pretend
> to do something, but the IO won't actually be done on the file.

Looks fine to me, though the HOWTO/man page bit could use some explanation
of how latencies are tracked as reads. Should also have an example job
file to go with it. Just looking at the documentation now, it's pretty
much impossible to figure out how to use this, without looking at the
source code.

-- 
Jens Axboe


