Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] Fix overflow in percentile calculation for Windows
References: <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
 <20171012055758.11167-1-andrzej.jakowski@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <630dc1b4-a749-a572-95ca-094274dc6b00@kernel.dk>
Date: Thu, 12 Oct 2017 08:32:18 -0600
MIME-Version: 1.0
In-Reply-To: <20171012055758.11167-1-andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Andrzej Jakowski <andrzej.jakowski@intel.com>, fio@vger.kernel.org
Cc: vincentfu@gmail.com
List-ID: <fio@vger.kernel.org>

On 10/11/2017 11:57 PM, Andrzej Jakowski wrote:
> This patch fixes percentile calculation for Windows where overflow
> on 32 bit type happened while calculating actual percentiles.

I already applied the previous one, so I hand edited this one and
massaged the changelog somewhat.

-- 
Jens Axboe


