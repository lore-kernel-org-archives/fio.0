Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
Subject: Re: Python scripts - /usr/bin/env python3 vs python vs python2.7
References: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <87ec264a-c0cd-2868-4173-f7d52297e7d5@gmail.com>
Date: Tue, 26 May 2020 10:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bsdio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 5/26/20 10:13 AM, Rebecca Cran wrote:
> Python scripts in fio use a variety of methods to run the python 
> interpreter: t/run_fio_tests.py has "#!/usr/bin/env python3" while 
> t/strided.py has "#!/usr/bin/python", and sgunmap-test.py has 
> "#!/usr/bin/python2.7".
> 
> 
> Would there any interest in converting them all to use "#!/usr/bin/env 
> python3 ?
> 
> 

I think having a uniform python interpreter line would be a good thing.

