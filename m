Return-Path: <axboe@kernel.dk>
Message-ID: <5363BEA6.6010009@kernel.dk>
Date: Fri, 02 May 2014 09:49:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <CF890B7F.5B0BE%ajoy@fastorsystems.com>
In-Reply-To: <CF890B7F.5B0BE%ajoy@fastorsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ajoy Aswadhati <ajoy@fastorsystems.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/02/2014 09:47 AM, Ajoy Aswadhati wrote:
> I am referring to only one 1GB file and want the data distributed randomly
> across the 1TB target disk.
> 1 TB disk can be raw without a file system. What is the algorithm for
> distributing this 1GB over the 1TB space?

Fio has no control over where the filesystem chooses to allocate the
physical blocks, so that's not a solvable problem from userspace.

-- 
Jens Axboe


