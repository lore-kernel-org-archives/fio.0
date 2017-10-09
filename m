Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] add an filecreate example file to examples/
References: <1507581351-27797-1-git-send-email-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5757c4d3-2af4-bcea-b199-cd98f1b1746d@kernel.dk>
Date: Mon, 9 Oct 2017 14:44:03 -0600
MIME-Version: 1.0
In-Reply-To: <1507581351-27797-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, fio@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

On 10/09/2017 02:35 PM, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> This adds an example with some documentation on how to use
> ioengine=filecreate.

Applied, but killed the readwrite= line. We have to ensure that
the engine and job both use reads, otherwise the stats might not
display correctly (as zeroes). Might be an idea to fix this up
in an ->init() hook for the engine, to make it more resilient.

-- 
Jens Axboe


