Message-ID: <4C266870.4050805@fusionio.com>
Date: Sat, 26 Jun 2010 22:52:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix posix_fallocate() return value usage
References: <20100625152522.GB29790@w-gedwards.lhn.com>
In-Reply-To: <20100625152522.GB29790@w-gedwards.lhn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Greg Edwards <greg.edwards@hp.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 25/06/10 17.25, Greg Edwards wrote:
> posix_fallocate() returns the error number on failure.  Fix the return value
> usage.

Thanks, will apply.

-- 
Jens Axboe


