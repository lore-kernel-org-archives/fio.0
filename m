Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] init: fix --bandwidth-log without argument
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a202c493-e07d-c92d-dcd7-18965dc9cc8c@kernel.dk>
Date: Tue, 11 Oct 2016 16:05:00 -0600
MIME-Version: 1.0
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Omar Sandoval <osandov@osandov.com>, fio@vger.kernel.org
Cc: kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 10/05/2016 04:15 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> --bandwidth-log doesn't do anything with the argument that it requires,
> and the documentation doesn't indicate that it takes an argument.

Applied this, and 2-4 as well. Thanks Omar.

-- 
Jens Axboe


