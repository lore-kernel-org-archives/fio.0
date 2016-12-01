Return-Path: <axboe@kernel.dk>
Subject: Re: fio server code fix
References: <BL2PR02MB1986D5E469BCE99E7753CF008C8F0@BL2PR02MB1986.namprd02.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <20019d0a-57b3-bd03-8421-108e5bb79daa@kernel.dk>
Date: Thu, 1 Dec 2016 10:32:00 -0700
MIME-Version: 1.0
In-Reply-To: <BL2PR02MB1986D5E469BCE99E7753CF008C8F0@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/01/2016 10:29 AM, Vincent Fu wrote:
> Jens, I have been working on getting steadystate detection to work in
> client/server mode and believe I found a bug in the server code. Please
> see the attached patch.

Thanks, good catch! Applied.

-- 
Jens Axboe


