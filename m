Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] stat: fix --bandwidth-log segfault
References: <20180608082625.2884-1-igor.j.konopko@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bb1067d6-6180-076d-5cf6-5b0ab766c22d@kernel.dk>
Date: Fri, 8 Jun 2018 08:31:35 -0600
MIME-Version: 1.0
In-Reply-To: <20180608082625.2884-1-igor.j.konopko@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Igor Konopko <igor.j.konopko@intel.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/8/18 2:26 AM, Igor Konopko wrote:
> Since bandwidth log has no corresponding thread data
> and pending struct, we cannot access any fields inside it.

Thanks Igor, applied.

-- 
Jens Axboe


