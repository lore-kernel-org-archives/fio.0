Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Fix invalid ioengine initialization for cpp_null
References: <1483637537-14347-1-git-send-email-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5488eccc-7550-14f1-f86d-ec91a94740ef@kernel.dk>
Date: Thu, 5 Jan 2017 10:36:12 -0700
MIME-Version: 1.0
In-Reply-To: <1483637537-14347-1-git-send-email-tkusumi@tuxera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 01/05/2017 10:32 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> ->name is a pointer now, so it can't be strcpy'd without a valid
> address set to ->name.

Applied 1-2, thanks.

-- 
Jens Axboe


