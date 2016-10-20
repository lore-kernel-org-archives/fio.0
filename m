Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Remove getopt_long_only macro from NetBSD header
References: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d4a9dda7-ccd9-cc56-2732-c78d4ad12221@kernel.dk>
Date: Thu, 20 Oct 2016 08:17:06 -0600
MIME-Version: 1.0
In-Reply-To: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/20/2016 08:03 AM, Tomohiro Kusumi wrote:
> If CONFIG_GETOPT_LONG_ONLY isn't defined, fio is compiled with
> its own getopt_long_only(), so this macro is no longer needed.
> (os/os-netbsd.h was added before getopt_long_only() support)

Applied, thanks.

-- 
Jens Axboe


