Return-Path: <bruce@cran.org.uk>
Subject: Re: fio crash on windows when using json output
References: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
 <d8754f54-4c79-62c3-df33-d4f216aaec91@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <52eccbdb-00ea-ef0e-f46f-be7961b59b6d@cran.org.uk>
Date: Fri, 28 Oct 2016 18:26:22 -0600
MIME-Version: 1.0
In-Reply-To: <d8754f54-4c79-62c3-df33-d4f216aaec91@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Shahar Glixman <sglixman@velostrata.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/12/2016 4:20 PM, Jens Axboe wrote:
> Does this still happen in current -git? It's too bad the windows version
> doesn't generate the git sha, Bruce, any chance that could get added?
>

It does output the git sha if you're running a build that hasn't been 
tagged:

C:\...\workspace\fio>fio --version
fio-2.15-2-ga955

-- 
Bruce

