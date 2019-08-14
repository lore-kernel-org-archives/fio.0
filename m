Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/7] Seven fio patches
References: <20190814201012.253060-1-bvanassche@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <10f371c3-20cb-e5d1-b342-39e2b02de26d@kernel.dk>
Date: Wed, 14 Aug 2019 15:02:28 -0600
MIME-Version: 1.0
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/14/19 2:10 PM, Bart Van Assche wrote:
> Hi Jens,
> 
> The following changes are included in this patch series:
> - Declare local functions 'static' in zbd.c.
> - Make the zbd test scripts more robust.
> - Use snprintf() instead of strncpy() + explicit null termination.
> - Rework the approach for suppressing gcc 9 address of packed member warnings.
> - Add a 'fulltest' target that runs the zbd tests.

Applied, thanks Bart.

-- 
Jens Axboe


