Return-Path: <axboe@kernel.dk>
Subject: Re: http://git.kernel.dk/?p=fio.git;a=summary returns 500 error
References: <CALjAwxgm+_X0iVkZaPPGiVhu1MRMV0D4__yuvZ+=nY_cGgxvVg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a6c3a786-2e30-6b13-3252-3b8187cc5074@kernel.dk>
Date: Sat, 28 Oct 2017 17:06:38 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgm+_X0iVkZaPPGiVhu1MRMV0D4__yuvZ+=nY_cGgxvVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/28/2017 02:50 PM, Sitsofe Wheeler wrote:
> Over in http://www.bbc.co.uk/blogs/internet/entries/ce3eff16-228f-49a0-8d4e-d1a013e4895f
> which is a blog on the BBC website the author tries to link to
> http://git.kernel.dk/?p=fio.git;a=summary but the page is returning
> this:
> 
> 500 - Internal Server Error
> ________________________________
> Insecure $ENV{PATH} while running setuid at
> /usr/share/gitweb/index.cgi line 775.
> 
> This link to fio is also popular among packages - see
> https://repology.org/metapackage/fio/packages .

Gah, I keep fixing this, and then a gitweb update ruins it again. Maybe
I should look for a more durable fix that doesn't require editing gitwebs
index.cgi.

Thanks for the heads up! Now fixed.

-- 
Jens Axboe


