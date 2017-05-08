Return-Path: <axboe@kernel.dk>
Subject: Re: Writing buffers allocated by numa_alloc_onnode to files opened
 with O_DIRECT
References: <E12F3002-0737-4C94-8E43-D2E4B449ED0A@cisco.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2c218e4d-d618-a068-459e-b4c7e7ced87d@kernel.dk>
Date: Mon, 8 May 2017 08:33:32 -0600
MIME-Version: 1.0
In-Reply-To: <E12F3002-0737-4C94-8E43-D2E4B449ED0A@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Scott Forman (scforman)" <scforman@cisco.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/02/2017 08:44 PM, Scott Forman (scforman) wrote:
> Hi,
> 
> I am wondering if someone on this mailing list would know if the
> numa_alloc_onnode() function properly aligns memory buffers so that
> they can be written to a file opened with the O_DIRECT flag.
> 
> I have seen some conflicting information on the web about this, so I
> would appreciate any input you might have.

The man page says that it rounds the size to the nearest page size, so I
think you can safely assume that then the alignment will also be fine
for O_DIRECT.

-- 
Jens Axboe


