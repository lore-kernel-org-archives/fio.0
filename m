Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix iodepth_batch=0
References: <7d9e503153a511700809a945521613b3c03389f5.1464764641.git.osandov@fb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <575054AD.90306@kernel.dk>
Date: Thu, 2 Jun 2016 09:45:49 -0600
MIME-Version: 1.0
In-Reply-To: <7d9e503153a511700809a945521613b3c03389f5.1464764641.git.osandov@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Omar Sandoval <osandov@osandov.com>, fio@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
List-ID: <fio@vger.kernel.org>

On 06/01/2016 01:04 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> The man page claims that iodepth_batch=0 falls back to whatever was
> specified for iodepth, but the enforced minimum of 1 means that 0 is not
> actually valid.
>
> Fixes: a2e6f8ac56a9 ("Make iodepth_batch=1 by default")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Probably a better idea to just adjust the check-and-set instead, ala the
below:

diff --git a/init.c b/init.c
index 7166ea766d8a..e82446ba6f2a 100644
--- a/init.c
+++ b/init.c
@@ -695,7 +695,8 @@ static int fixup_options(struct thread_data *td)
  	/*
  	 * If batch number isn't set, default to the same as iodepth
  	 */
-	if (o->iodepth_batch > o->iodepth || !o->iodepth_batch)
+	if (o->iodepth_batch > o->iodepth ||
+	    !fio_option_is_set(o, iodepth_batch))
  		o->iodepth_batch = o->iodepth;

  	/*

-- 
Jens Axboe


