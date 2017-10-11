Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] use mkdir instead of mkdirat
References: <1507752919-14323-1-git-send-email-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8644d448-7d99-b628-f8cd-42172539347c@kernel.dk>
Date: Wed, 11 Oct 2017 14:30:26 -0600
MIME-Version: 1.0
In-Reply-To: <1507752919-14323-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

On 10/11/2017 02:15 PM, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Windows doesn't have a way to do mkdirat, so convert to mkdir instead.

Added 1+2, but to make things even more fun, mkdir() on mingw doesn't
take a mode argument. After that was fixed up, we're back to compiling
on Windows again.

-- 
Jens Axboe


