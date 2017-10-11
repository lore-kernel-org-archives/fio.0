Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] create subdirs if specified in the filename_format
References: <1507748292-8941-1-git-send-email-josef@toxicpanda.com>
 <1507748292-8941-2-git-send-email-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <528f84d5-4b76-245a-a9b2-d989c2289fd9@kernel.dk>
Date: Wed, 11 Oct 2017 13:05:08 -0600
MIME-Version: 1.0
In-Reply-To: <1507748292-8941-2-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, fio@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

On 10/11/2017 12:58 PM, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Currently there's no way for a user to specify a directory that doesn't
> exist yet for a job.  Fix this by looking for paths in the file name
> provided by the job and creating any subdirectories that may be
> required.

Applied 1, and this one except I dropped the flag shift change which
isn't needed.

Would be nice with a documentation change as well for this, so it's
clear that filename_format can take directory names as well, just
so that's clear to users.

-- 
Jens Axboe


