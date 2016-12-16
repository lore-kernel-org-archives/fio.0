Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] use type double in creating floating point JSON values
References: <BL2PR02MB19863CD9980E3B05246402678C9B0@BL2PR02MB1986.namprd02.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <227a7fcd-305f-1e58-00fa-96fc888f67f6@kernel.dk>
Date: Fri, 16 Dec 2016 10:57:19 -0700
MIME-Version: 1.0
In-Reply-To: <BL2PR02MB19863CD9980E3B05246402678C9B0@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/13/2016 01:55 PM, Vincent Fu wrote:
> struct json_value uses a double to store floating point values. Have
> json_create_value_float also take a double (instead of a float) as an
> argument.

Applied, thanks Vincent.

-- 
Jens Axboe


